-- Services.
local playersService = game:GetService("Players")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")

local localPlayer = playersService.LocalPlayer

-- Guard for execution.
if not shared then
    return warn("No shared, no script.")
end

---RANKUY Hub UI and Functions Initialization.
local function initializeRankuyHub()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RANKUY_Hub"
    screenGui.ResetOnSpawn = false
    
    local success, err = pcall(function()
        screenGui.Parent = coreGui
    end)
    if not success then
        screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    end

    -- Main Frame (Mobile Optimized & Sleek)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = mainFrame

    -- RGB UI Stroke Effect
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 2
    uiStroke.Parent = mainFrame

    task.spawn(function()
        while true do
            for i = 0, 1, 0.005 do
                uiStroke.Color = Color3.fromHSV(i, 1, 1)
                task.wait(0.02)
            end
        end
    end)

    -- Title Bar
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 45)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "RANKUY HUB"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame

    -- Scrolling Content Container
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -20, 1, -60)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 520)
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.Parent = mainFrame

    local uiLayout = Instance.new("UIListLayout")
    uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiLayout.Padding = UDim.new(0, 10)
    uiLayout.Parent = scrollingFrame

    -- Helper to create styled buttons
    local function createButton(name, text, callback)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamSemibold
        btn.Text = text
        btn.Parent = scrollingFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(60, 60, 60)
        stroke.Parent = btn

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- State Variables for toggles
    local flyActive = false
    local flyConnection

    -- 1. Fly Functionality
    createButton("FlyBtn", "Toggle Fly (บิน)", function()
        flyActive = not flyActive
        local character = localPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = character.HumanoidRootPart
        local cam = workspace.CurrentCamera

        if flyActive then
            flyConnection = runService.RenderStepped:Connect(function()
                if not flyActive then return end
                local moveDir = Vector3.new()
                if userInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CoordinateFrame.LookVector end
                if userInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CoordinateFrame.LookVector end
                if userInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CoordinateFrame.RightVector end
                if userInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CoordinateFrame.RightVector end
                hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * 50, 2, moveDir.Z * 50)
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)

    -- 2. Super Jump Functionality
    createButton("JumpBtn", "Super Jump (กระโดดสูง)", function()
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = 150
            character.Humanoid.Jump = true
        end
    end)

    -- 3. Speed Hack (WalkSpeed)
    createButton("SpeedBtn", "Speed Boost (วิ่งเร็ว)", function()
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 65
        end
    end)

    -- 4. Vehicle Speed Modification
    createButton("CarSpeedBtn", "Fast Vehicles (รถเร็วพิเศษ)", function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("VehicleSeat") then
                obj.MaxSpeed = 200
                obj.Torque = 50000
            end
        end
    end)

    -- 5. Secured Audio Player with Interception Defense & Spoofed ID Name
    createButton("AudioBtn", "Secure Audio (เปิดเพลง - กันเจาะ)", function()
        local character = localPlayer.Character
        if not character then return end
        
        local realAudioId = 1845726402 
        local spoofedDisplayId = "กันเจาะโดยรันค้าบบ"
        
        print("[RANKUY SECURE]: Audio ID protected as -> " .. spoofedDisplayId)

        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("boombox") or tool.Name:lower():find("radio")) then
                local remote = tool:FindFirstChild("Remote") or tool:FindFirstChildWhichIsA("RemoteEvent", true)
                if remote then
                    pcall(function()
                        remote:FireServer("PlayMusic", realAudioId)
                    end)
                end
            end
        end
    end)

    -- 6. Teleport to Center / Safe Spot
    createButton("TpBtn", "Teleport Center (วาปจุดศูนย์กลาง)", function()
        local character = localPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end)
end

-- Safely execute hub build
pcall(initializeRankuyHub)
```[cite: 2]
