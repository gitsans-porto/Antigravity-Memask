--[[
    ================================================
    EW SCRIPT HUB v1.0
    Escape Waves For Lucky Blocks
    Compatible: Delta Executor (Android/BlueStacks)
    ================================================
]]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Wait for character
repeat wait() until player.Character
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- STATE
local toggles = {
    speedBoost = false,
    noclip = false,
    godmode = false,
    antiAfk = false,
    autoCollect = false,
    autoSteal = false,
    espBlocks = false,
    autoSafe = false
}
local originalSpeed = humanoid.WalkSpeed
local originalJump = humanoid.JumpPower

-- =============================================
-- GUI CREATION
-- =============================================

-- Remove old GUI
pcall(function()
    player.PlayerGui:FindFirstChild("EWScriptHub"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "EWScriptHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 280, 0, 380)
main.Position = UDim2.new(0, 20, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 120, 255)
mainStroke.Thickness = 2
mainStroke.Parent = main

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Fix header bottom corners
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "EW Script Hub v1.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 0.8
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.TextSize = 20
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = header

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 8)
minBtnCorner.Parent = minBtn

-- Content container
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 45)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content

-- =============================================
-- TOGGLE BUTTON BUILDER
-- =============================================

local function createToggle(name, text, order, callback)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order
    frame.Parent = content

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 8)
    fCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Name = "Toggle"
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(1, -52, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 2, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    circle.BorderSizePixel = 0
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local isOn = false

    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggles[name] = isOn

        if isOn then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -20, 0.5, -9),
                BackgroundColor3 = Color3.new(1, 1, 1)
            }):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            }):Play()
        end

        callback(isOn)
    end)

    return btn
end

local function createButton(text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Name = text
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(60, 90, 200)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = content

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback()
    end)

    return btn
end

local function createSeparator(text, order)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 24)
    label.BackgroundTransparency = 1
    label.Text = "-- " .. text .. " --"
    label.TextColor3 = Color3.fromRGB(80, 120, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.LayoutOrder = order
    label.Parent = content
    return label
end

-- =============================================
-- MINIMIZE LOGIC
-- =============================================

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        main.Size = UDim2.new(0, 280, 0, 40)
        content.Visible = false
        minBtn.Text = "+"
    else
        main.Size = UDim2.new(0, 280, 0, 380)
        content.Visible = true
        minBtn.Text = "-"
    end
end)

-- =============================================
-- CHARACTER UPDATE HANDLER
-- =============================================

local function updateCharacter()
    character = player.Character
    if character then
        humanoid = character:WaitForChild("Humanoid", 5)
        rootPart = character:WaitForChild("HumanoidRootPart", 5)
        if humanoid then
            originalSpeed = 16
            originalJump = 50
        end
    end
end

player.CharacterAdded:Connect(function(char)
    wait(1)
    updateCharacter()

    -- Re-apply active toggles
    if toggles.speedBoost and humanoid then
        humanoid.WalkSpeed = 100
    end
    if toggles.godmode and humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

-- =============================================
-- FEATURE: SPEED BOOST
-- =============================================

createSeparator("MOVEMENT", 1)

createToggle("speedBoost", "Speed Boost (100)", 2, function(enabled)
    if humanoid then
        if enabled then
            humanoid.WalkSpeed = 100
        else
            humanoid.WalkSpeed = originalSpeed
        end
    end
end)

-- =============================================
-- FEATURE: HIGH JUMP
-- =============================================

createToggle("highJump", "High Jump", 3, function(enabled)
    if humanoid then
        if enabled then
            humanoid.JumpPower = 150
        else
            humanoid.JumpPower = originalJump
        end
    end
end)

-- =============================================
-- FEATURE: NOCLIP
-- =============================================

createToggle("noclip", "Noclip", 4, function(enabled)
    -- handled in heartbeat
end)

-- =============================================
-- FEATURE: GODMODE
-- =============================================

createSeparator("SURVIVAL", 5)

createToggle("godmode", "God Mode", 6, function(enabled)
    if humanoid then
        if enabled then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end)

-- =============================================
-- FEATURE: ANTI-AFK
-- =============================================

createSeparator("UTILITY", 7)

createToggle("antiAfk", "Anti-AFK", 8, function(enabled)
    -- handled via connection
end)

-- =============================================
-- FEATURE: ESP LUCKY BLOCKS
-- =============================================

createToggle("espBlocks", "ESP Lucky Blocks", 9, function(enabled)
    -- handled in heartbeat
end)

-- =============================================
-- FEATURE: AUTO COLLECT CASH
-- =============================================

createSeparator("AUTOMATION", 10)

createToggle("autoCollect", "Auto Collect Cash", 11, function(enabled)
    -- handled in spawn loop
end)

-- =============================================
-- FEATURE: AUTO STEAL LUCKY BLOCKS
-- =============================================

createToggle("autoSteal", "Auto Steal Blocks", 12, function(enabled)
    -- handled in spawn loop
end)

-- =============================================
-- INSTANT BUTTONS
-- =============================================

createSeparator("TELEPORT", 13)

createButton("TP to Spawn", 14, function()
    if rootPart then
        -- Most maps have spawn near origin
        local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
        if spawn then
            rootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        else
            rootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end
end)

createButton("TP to Nearest Lucky Block", 15, function()
    if not rootPart then return end
    local closest = nil
    local closestDist = math.huge

    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("lucky") or name:find("block") or name:find("luckyblock")) and obj:IsA("BasePart") then
            local dist = (obj.Position - rootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = obj
            end
        end
    end

    if closest then
        rootPart.CFrame = closest.CFrame + Vector3.new(0, 5, 0)
    end
end)

-- =============================================
-- MAIN LOOP (Heartbeat)
-- =============================================

RunService.Heartbeat:Connect(function()
    if not character or not character.Parent then return end
    if not humanoid or not humanoid.Parent then return end

    -- NOCLIP
    if toggles.noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- GODMODE
    if toggles.godmode then
        pcall(function()
            humanoid.Health = math.huge
            humanoid.MaxHealth = math.huge
        end)
    end

    -- SPEED BOOST (prevent reset)
    if toggles.speedBoost then
        if humanoid.WalkSpeed < 100 then
            humanoid.WalkSpeed = 100
        end
    end

    -- HIGH JUMP (prevent reset)
    if toggles.highJump then
        if humanoid.JumpPower < 150 then
            humanoid.JumpPower = 150
        end
    end
end)

-- =============================================
-- ESP LOOP
-- =============================================

spawn(function()
    while wait(2) do
        -- Remove old ESP
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "EW_ESP" then
                v:Destroy()
            end
        end

        if toggles.espBlocks then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if (name:find("lucky") or name:find("block")) and obj:IsA("BasePart") then
                    pcall(function()
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "EW_ESP"
                        highlight.FillColor = Color3.fromRGB(255, 255, 0)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineColor = Color3.fromRGB(255, 200, 0)
                        highlight.OutlineTransparency = 0
                        highlight.Adornee = obj
                        highlight.Parent = obj

                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "EW_ESP"
                        billboard.Size = UDim2.new(0, 100, 0, 30)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = obj
                        billboard.Parent = obj

                        local espLabel = Instance.new("TextLabel")
                        espLabel.Size = UDim2.new(1, 0, 1, 0)
                        espLabel.BackgroundTransparency = 1
                        espLabel.Text = obj.Name
                        espLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                        espLabel.TextStrokeTransparency = 0
                        espLabel.TextSize = 14
                        espLabel.Font = Enum.Font.GothamBold
                        espLabel.Parent = billboard
                    end)
                end
            end
        end
    end
end)

-- =============================================
-- AUTO COLLECT CASH LOOP
-- =============================================

spawn(function()
    while wait(0.5) do
        if toggles.autoCollect and rootPart then
            pcall(function()
                -- Look for cash/coin/money objects and touch them
                for _, obj in pairs(Workspace:GetDescendants()) do
                    local name = obj.Name:lower()
                    if (name:find("cash") or name:find("coin") or name:find("money") or name:find("collect") or name:find("earning")) and obj:IsA("BasePart") then
                        if (obj.Position - rootPart.Position).Magnitude < 200 then
                            firetouchinterest(rootPart, obj, 0)
                            wait()
                            firetouchinterest(rootPart, obj, 1)
                        end
                    end
                end
            end)
        end
    end
end)

-- =============================================
-- AUTO STEAL LUCKY BLOCKS LOOP
-- =============================================

spawn(function()
    while wait(1) do
        if toggles.autoSteal and rootPart then
            pcall(function()
                local closest = nil
                local closestDist = math.huge

                for _, obj in pairs(Workspace:GetDescendants()) do
                    local name = obj.Name:lower()
                    if (name:find("lucky") or name:find("block")) and obj:IsA("BasePart") then
                        local dist = (obj.Position - rootPart.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = obj
                        end
                    end
                end

                if closest and closestDist < 500 then
                    -- Teleport to block
                    rootPart.CFrame = closest.CFrame + Vector3.new(0, 3, 0)
                    wait(0.3)
                    -- Touch it
                    firetouchinterest(rootPart, closest, 0)
                    wait(0.1)
                    firetouchinterest(rootPart, closest, 1)
                end
            end)
        end
    end
end)

-- =============================================
-- ANTI-AFK
-- =============================================

spawn(function()
    while wait(60) do
        if toggles.antiAfk then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- =============================================
-- DONE
-- =============================================

print("================================")
print("EW Script Hub v1.0 LOADED!")
print("Game: Escape Waves For Lucky Blocks")
print("Executor: Delta (BlueStacks)")
print("================================")
print("Features:")
print("  - Speed Boost")
print("  - High Jump")
print("  - Noclip")
print("  - God Mode")
print("  - Anti-AFK")
print("  - ESP Lucky Blocks")
print("  - Auto Collect Cash")
print("  - Auto Steal Blocks")
print("  - TP to Spawn")
print("  - TP to Nearest Lucky Block")
print("================================")
