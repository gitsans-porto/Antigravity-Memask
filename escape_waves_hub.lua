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
    antiTampar = false,
    superTampar = false,
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
-- FEATURE: ANTI-TAMPARAN v2 (Position Lock)
-- =============================================

local antiTamparConns = {}
local lastSafePos = nil
local lastSafeTime = tick()
local FLING_THRESHOLD = 50 -- velocity magnitude that counts as flung

local function cleanAntiTamparConns()
    for _, conn in pairs(antiTamparConns) do
        pcall(function() conn:Disconnect() end)
    end
    antiTamparConns = {}
end

local function setupAntiTampar()
    cleanAntiTamparConns()
    if not character or not rootPart then return end
    
    -- Save initial safe position
    lastSafePos = rootPart.CFrame
    lastSafeTime = tick()
    
    -- LAYER 1: RenderStepped (FASTEST - runs before every frame render)
    -- Saves position when normal, snaps back when flung
    table.insert(antiTamparConns, RunService.RenderStepped:Connect(function()
        if not toggles.antiTampar or not rootPart or not rootPart.Parent then return end
        
        pcall(function()
            local vel = rootPart.AssemblyLinearVelocity
            local horizontalVel = Vector3.new(vel.X, 0, vel.Z).Magnitude
            
            if horizontalVel > FLING_THRESHOLD then
                -- BEING FLUNG! Snap back to last safe position
                rootPart.CFrame = lastSafePos
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                
                -- Also remove any forces
                for _, part in pairs(character:GetDescendants()) do
                    if (part:IsA("BodyVelocity") or part:IsA("BodyForce") or
                        part:IsA("BodyAngularVelocity") or part:IsA("BodyThrust") or
                        part:IsA("LinearVelocity") or part:IsA("VectorForce") or
                        part:IsA("LineForce") or part:IsA("BodyPosition") or
                        part:IsA("AlignPosition") or part:IsA("RocketPropulsion")) and
                        part.Name ~= "EW_AutoTP" then
                        part:Destroy()
                    end
                end
            else
                -- Normal movement - save as safe position
                -- Only update every 0.1s to avoid saving mid-fling positions
                if tick() - lastSafeTime > 0.1 then
                    lastSafePos = rootPart.CFrame
                    lastSafeTime = tick()
                end
            end
        end)
    end))
    
    -- LAYER 2: DescendantAdded - destroy any forces added by others
    table.insert(antiTamparConns, character.DescendantAdded:Connect(function(obj)
        if not toggles.antiTampar then return end
        pcall(function()
            if (obj:IsA("BodyVelocity") or obj:IsA("BodyForce") or
                obj:IsA("BodyAngularVelocity") or obj:IsA("BodyThrust") or
                obj:IsA("LinearVelocity") or obj:IsA("VectorForce") or
                obj:IsA("LineForce") or obj:IsA("RocketPropulsion")) and
                obj.Name ~= "EW_AutoTP" then
                obj:Destroy()
                print("Anti-Tampar: Destroyed " .. obj.ClassName)
            end
        end)
    end))
    
    -- LAYER 3: Humanoid state change - prevent ragdoll/physics state
    table.insert(antiTamparConns, humanoid.StateChanged:Connect(function(_, newState)
        if not toggles.antiTampar then return end
        -- Block states that slaps use to fling
        if newState == Enum.HumanoidStateType.Physics or
           newState == Enum.HumanoidStateType.Ragdoll or
           newState == Enum.HumanoidStateType.FallingDown or
           newState == Enum.HumanoidStateType.PlatformStanding then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end))
end

createToggle("antiTampar", "Anti-Tamparan", 7, function(enabled)
    if enabled then
        setupAntiTampar()
        print("Anti-Tamparan v2: ON - Position Lock aktif!")
    else
        cleanAntiTamparConns()
        print("Anti-Tamparan: OFF")
    end
end)

-- =============================================
-- FEATURE: SUPER TAMPARAN (2x Slap Power)
-- =============================================

local superTamparConns = {}

local function cleanSuperTamparConns()
    for _, conn in pairs(superTamparConns) do
        pcall(function() conn:Disconnect() end)
    end
    superTamparConns = {}
end

local function setupSuperTampar()
    cleanSuperTamparConns()
    
    -- Monitor ALL other players for BodyVelocity being added
    -- When our slap tool hits them, the server adds a BodyVelocity
    -- We amplify it by 2x
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local conn = otherPlayer.Character.DescendantAdded:Connect(function(obj)
                if not toggles.superTampar then return end
                pcall(function()
                    if obj:IsA("BodyVelocity") then
                        -- Amplify velocity 2x
                        wait()
                        if obj and obj.Parent then
                            obj.Velocity = obj.Velocity * 2
                            obj.MaxForce = obj.MaxForce * 2
                            print("Super Tampar: Amplified hit on " .. otherPlayer.Name)
                        end
                    elseif obj:IsA("LinearVelocity") then
                        wait()
                        if obj and obj.Parent then
                            obj.VectorVelocity = obj.VectorVelocity * 2
                            print("Super Tampar: Amplified LinearVelocity on " .. otherPlayer.Name)
                        end
                    elseif obj:IsA("VectorForce") then
                        wait()
                        if obj and obj.Parent then
                            obj.Force = obj.Force * 2
                            print("Super Tampar: Amplified Force on " .. otherPlayer.Name)
                        end
                    elseif obj:IsA("BodyForce") then
                        wait()
                        if obj and obj.Parent then
                            obj.Force = obj.Force * 2
                            print("Super Tampar: Amplified BodyForce on " .. otherPlayer.Name)
                        end
                    end
                end)
            end)
            table.insert(superTamparConns, conn)
        end
    end
    
    -- Also monitor new players joining
    table.insert(superTamparConns, Players.PlayerAdded:Connect(function(newPlayer)
        if not toggles.superTampar then return end
        newPlayer.CharacterAdded:Connect(function(char)
            if not toggles.superTampar then return end
            local conn = char.DescendantAdded:Connect(function(obj)
                if not toggles.superTampar then return end
                pcall(function()
                    if obj:IsA("BodyVelocity") then
                        wait()
                        if obj and obj.Parent then
                            obj.Velocity = obj.Velocity * 2
                            obj.MaxForce = obj.MaxForce * 2
                        end
                    elseif obj:IsA("LinearVelocity") then
                        wait()
                        if obj and obj.Parent then
                            obj.VectorVelocity = obj.VectorVelocity * 2
                        end
                    end
                end)
            end)
            table.insert(superTamparConns, conn)
        end)
    end))
end

createToggle("superTampar", "Super Tamparan (2x)", 8, function(enabled)
    if enabled then
        setupSuperTampar()
        print("Super Tamparan: ON - Tamparan 2x lebih kuat!")
    else
        cleanSuperTamparConns()
        print("Super Tamparan: OFF")
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
-- ADVANCED TELEPORT SYSTEM (Multi-Method)
-- =============================================

local savedBasePos = nil
local isTeleporting = false
local teleportMethod = 1 -- Current method (cycles 1-4)

-- Remove all BodyMovers/Constraints that pull character back
local function removeBodyMovers()
    if not character then return end
    pcall(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BodyPosition") or part:IsA("BodyVelocity") or 
               part:IsA("BodyGyro") or part:IsA("BodyForce") or
               part:IsA("BodyAngularVelocity") or part:IsA("BodyThrust") or
               part:IsA("RocketPropulsion") or part:IsA("LinearVelocity") or
               part:IsA("AlignPosition") or part:IsA("AlignOrientation") or
               part:IsA("VectorForce") or part:IsA("LineForce") then
                part:Destroy()
            end
        end
    end)
end

-- Zero out all velocity
local function zeroVelocity()
    pcall(function()
        if rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- METHOD 1: Anchor Freeze Teleport
-- Anchors rootPart so physics cant move it, sets CFrame, unanchors after delay
local function anchorTeleport(targetCFrame)
    spawn(function()
        pcall(function()
            removeBodyMovers()
            zeroVelocity()
            rootPart.Anchored = true
            rootPart.CFrame = targetCFrame
            wait(0.5)
            rootPart.CFrame = targetCFrame
            wait(0.3)
            rootPart.Anchored = false
            zeroVelocity()
            removeBodyMovers()
        end)
        -- Hold briefly after unanchor
        for i = 1, 10 do
            wait(0.05)
            pcall(function()
                rootPart.CFrame = targetCFrame
                zeroVelocity()
            end)
        end
        isTeleporting = false
        print("Method 1 (Anchor) complete!")
    end)
end

-- METHOD 2: Incremental Step Teleport
-- Moves in many small steps so each step looks like normal movement
local function stepTeleport(targetCFrame)
    spawn(function()
        pcall(function()
            removeBodyMovers()
            local startPos = rootPart.Position
            local targetPos = targetCFrame.Position
            local distance = (targetPos - startPos).Magnitude
            
            -- Calculate steps: max 50 studs per step
            local stepSize = 50
            local steps = math.max(math.ceil(distance / stepSize), 1)
            
            for i = 1, steps do
                local alpha = i / steps
                local midPos = startPos:Lerp(targetPos, alpha)
                rootPart.CFrame = CFrame.new(midPos)
                zeroVelocity()
                removeBodyMovers()
                wait(0.05)
            end
            
            -- Final lock
            rootPart.CFrame = targetCFrame
            zeroVelocity()
        end)
        isTeleporting = false
        print("Method 2 (Step) complete!")
    end)
end

-- METHOD 3: Tween Teleport
-- Uses TweenService for smooth movement that looks natural
local function tweenTeleport(targetCFrame)
    spawn(function()
        pcall(function()
            removeBodyMovers()
            zeroVelocity()
            
            local distance = (targetCFrame.Position - rootPart.Position).Magnitude
            local speed = 300 -- studs per second
            local duration = math.max(distance / speed, 0.3)
            duration = math.min(duration, 3) -- cap at 3 seconds
            
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
            tween.Completed:Wait()
            
            -- Final lock
            rootPart.CFrame = targetCFrame
            zeroVelocity()
            removeBodyMovers()
        end)
        isTeleporting = false
        print("Method 3 (Tween) complete!")
    end)
end

-- METHOD 4: BodyPosition Teleport
-- Creates a BodyPosition to pull character to target (game-legit physics)
local function bodyPosTeleport(targetCFrame)
    spawn(function()
        pcall(function()
            removeBodyMovers()
            zeroVelocity()
            
            -- Create a BodyPosition to pull us there
            local bp = Instance.new("BodyPosition")
            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.D = 100
            bp.P = 50000
            bp.Position = targetCFrame.Position
            bp.Parent = rootPart
            
            -- Wait until we arrive or timeout
            local startTime = tick()
            while tick() - startTime < 5 do
                local dist = (rootPart.Position - targetCFrame.Position).Magnitude
                if dist < 5 then break end
                wait(0.1)
            end
            
            -- Clean up
            bp:Destroy()
            rootPart.CFrame = targetCFrame
            zeroVelocity()
        end)
        isTeleporting = false
        print("Method 4 (BodyPosition) complete!")
    end)
end

-- Main teleport function: tries current method
local function smartTeleport(targetCFrame)
    if isTeleporting then return end
    isTeleporting = true
    
    print("Teleporting with Method " .. teleportMethod .. "...")
    
    if teleportMethod == 1 then
        anchorTeleport(targetCFrame)
    elseif teleportMethod == 2 then
        stepTeleport(targetCFrame)
    elseif teleportMethod == 3 then
        tweenTeleport(targetCFrame)
    elseif teleportMethod == 4 then
        bodyPosTeleport(targetCFrame)
    end
end

-- =============================================
-- TELEPORT BUTTONS
-- =============================================

createSeparator("TELEPORT", 13)

-- AUTO TP TO BASE - The killer feature
-- Creates a PERSISTENT BodyPosition that continuously pulls to base
local autoTPActive = false
local autoTPBodyPos = nil

local function startAutoTP()
    if not savedBasePos then
        print("Save base position first!")
        return
    end
    if not rootPart then return end
    
    autoTPActive = true
    print("Auto TP to Base: ON - Pulling to base...")
    
    -- Remove any existing one
    pcall(function()
        if autoTPBodyPos and autoTPBodyPos.Parent then
            autoTPBodyPos:Destroy()
        end
    end)
    
    -- Create persistent BodyPosition
    pcall(function()
        removeBodyMovers()
        local bp = Instance.new("BodyPosition")
        bp.Name = "EW_AutoTP"
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.D = 150
        bp.P = 80000
        bp.Position = savedBasePos.Position
        bp.Parent = rootPart
        autoTPBodyPos = bp
    end)
end

local function stopAutoTP()
    autoTPActive = false
    pcall(function()
        if autoTPBodyPos and autoTPBodyPos.Parent then
            autoTPBodyPos:Destroy()
        end
        autoTPBodyPos = nil
        -- Also clean any leftover
        if rootPart then
            for _, v in pairs(rootPart:GetChildren()) do
                if v.Name == "EW_AutoTP" then
                    v:Destroy()
                end
            end
        end
    end)
    zeroVelocity()
    print("Auto TP to Base: OFF")
end

createButton("Save Base Position", 14, function()
    if rootPart then
        savedBasePos = rootPart.CFrame
        print("Base saved at: " .. tostring(rootPart.Position))
    end
end)

createToggle("autoTP", "Auto TP to Base", 15, function(enabled)
    if enabled then
        startAutoTP()
    else
        stopAutoTP()
    end
end)

createButton("TP to Spawn", 16, function()
    if not rootPart then return end
    local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
    if spawn then
        smartTeleport(spawn.CFrame + Vector3.new(0, 5, 0))
    else
        smartTeleport(CFrame.new(0, 50, 0))
    end
end)

createButton("TP to Nearest Lucky Block", 17, function()
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
        smartTeleport(closest.CFrame + Vector3.new(0, 5, 0))
    end
end)

-- Auto TP guardian: re-create BodyPosition if the game removes it
spawn(function()
    while wait(0.3) do
        if autoTPActive and savedBasePos and rootPart then
            pcall(function()
                -- Check if BodyPosition still exists
                local found = false
                for _, v in pairs(rootPart:GetChildren()) do
                    if v.Name == "EW_AutoTP" and v:IsA("BodyPosition") then
                        -- Update position in case base was re-saved
                        v.Position = savedBasePos.Position
                        found = true
                        break
                    end
                end
                
                -- Re-create if game destroyed it
                if not found then
                    local bp = Instance.new("BodyPosition")
                    bp.Name = "EW_AutoTP"
                    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bp.D = 150
                    bp.P = 80000
                    bp.Position = savedBasePos.Position
                    bp.Parent = rootPart
                    autoTPBodyPos = bp
                end
            end)
        end
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

    -- ANTI-TAMPARAN now handled by RenderStepped (faster than Heartbeat)
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
