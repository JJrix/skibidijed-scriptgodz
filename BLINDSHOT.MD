-- Combined ESP and Trophy TP System
-- Note: For educational purposes in Roblox Studio only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Check if we can use Drawing library (Studio only)
local function canUseDrawing()
    return pcall(function() return Drawing.new("Square") end)
end

-- ESP Variables
local espEnabled = false
local espObjects = {}
local drawingAvailable = canUseDrawing()

-- Trophy TP Variables
local trophyTPEnabled = false
local targetName = "Trophy"

-- GUI Variables
local guiMinimized = false
local guiVisible = true
local ScreenGui

-- Create the Combined GUI
local function createCombinedGUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CombinedTools_Gui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 200, 0, 160)
    MainContainer.Position = UDim2.new(0, 20, 0.5, -80)
    MainContainer.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
    MainContainer.BackgroundTransparency = 0.1
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = ScreenGui
    
    local UICorner1 = Instance.new("UICorner")
    UICorner1.CornerRadius = UDim.new(0, 8)
    UICorner1.Parent = MainContainer
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 70, 110)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainContainer
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 8)
    UICorner2.Parent = TitleBar
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "Game Tools"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    MinimizeBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 18
    MinimizeBtn.Parent = TitleBar
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 4)
    UICorner3.Parent = MinimizeBtn
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TitleBar
    
    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(0, 4)
    UICorner4.Parent = CloseBtn
    
    -- Content Frame (where buttons go)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainContainer
    
    -- ESP Button
    local ESPBtn = Instance.new("TextButton")
    ESPBtn.Name = "ESPBtn"
    ESPBtn.Size = UDim2.new(0.9, 0, 0, 40)
    ESPBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60) -- Red when off
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1, 1, 1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextSize = 16
    ESPBtn.Parent = ContentFrame
    
    local UICorner5 = Instance.new("UICorner")
    UICorner5.CornerRadius = UDim.new(0, 6)
    UICorner5.Parent = ESPBtn
    
    -- Trophy TP Button
    local TrophyBtn = Instance.new("TextButton")
    TrophyBtn.Name = "TrophyBtn"
    TrophyBtn.Size = UDim2.new(0.9, 0, 0, 40)
    TrophyBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
    TrophyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Dark gray when off
    TrophyBtn.Text = "CASH: OFF"
    TrophyBtn.TextColor3 = Color3.new(1, 1, 1)
    TrophyBtn.Font = Enum.Font.GothamBold
    TrophyBtn.TextSize = 16
    TrophyBtn.Parent = ContentFrame
    
    local UICorner6 = Instance.new("UICorner")
    UICorner6.CornerRadius = UDim.new(0, 6)
    UICorner6.Parent = TrophyBtn
    
    -- Function to toggle GUI minimization
    local function toggleMinimize()
        guiMinimized = not guiMinimized
        if guiMinimized then
            MainContainer.Size = UDim2.new(0, 200, 0, 30)
            MinimizeBtn.Text = "+"
            ContentFrame.Visible = false
        else
            MainContainer.Size = UDim2.new(0, 200, 0, 160)
            MinimizeBtn.Text = "-"
            ContentFrame.Visible = true
        end
    end
    
    -- Function to toggle GUI visibility
    local function toggleGUIVisibility()
        guiVisible = not guiVisible
        MainContainer.Visible = guiVisible
    end
    
    -- Function to update ESP button appearance
    local function updateESPButton()
        if espEnabled then
            ESPBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80) -- Green when on
            ESPBtn.Text = "ESP: ON"
        else
            ESPBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60) -- Red when off
            ESPBtn.Text = "ESP: OFF"
        end
    end
    
    -- Function to update Trophy TP button appearance
    local function updateTrophyButton()
        if trophyTPEnabled then
            TrophyBtn.BackgroundColor3 = Color3.fromRGB(200, 160, 0) -- Gold when on
            TrophyBtn.Text = "CASH: ON"
        else
            TrophyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Dark gray when off
            TrophyBtn.Text = "CASH: OFF"
        end
    end
    
    -- ESP toggle function
    local function toggleESP()
        if not drawingAvailable then
            warn("Drawing library not available. ESP requires Roblox Studio.")
            return
        end
        
        espEnabled = not espEnabled
        
        if espEnabled then
            -- ESP turned ON - create ESP for all players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            -- ESP turned OFF - remove all ESP objects
            for player, esp in pairs(espObjects) do
                if esp.box then
                    esp.box.Visible = false
                    esp.box:Remove()
                end
                if esp.name then
                    esp.name.Visible = false
                    esp.name:Remove()
                end
                if esp.distance then
                    esp.distance.Visible = false
                    esp.distance:Remove()
                end
            end
            espObjects = {}
        end
        
        updateESPButton()
    end
    
    -- Trophy TP toggle function
    local function toggleTrophyTP()
        trophyTPEnabled = not trophyTPEnabled
        updateTrophyButton()
    end
    
    -- Connect button events
    ESPBtn.MouseButton1Click:Connect(toggleESP)
    TrophyBtn.MouseButton1Click:Connect(toggleTrophyTP)
    MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        guiVisible = false
    end)
    
    -- Make the GUI draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                           startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Initialize button appearances
    updateESPButton()
    updateTrophyButton()
    
    return ScreenGui
end

-- ESP Functions
local function createESP(player)
    if not espEnabled or player == LocalPlayer then return end
    
    espObjects[player] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        distance = Drawing.new("Text")
    }
    
    local esp = espObjects[player]
    
    -- Box settings
    esp.box.Thickness = 2
    esp.box.Color = Color3.fromRGB(0, 255, 0)  -- Green
    esp.box.Filled = false
    
    -- Name settings
    esp.name.Text = player.Name
    esp.name.Color = Color3.fromRGB(255, 255, 255)
    esp.name.Size = 18
    esp.name.Outline = true
    esp.name.Center = true
    
    -- Distance text settings
    esp.distance.Text = "0 studs"
    esp.distance.Color = Color3.fromRGB(200, 200, 255)
    esp.distance.Size = 16
    esp.distance.Outline = true
    esp.distance.Center = true
end

local function updateESP()
    if not espEnabled then return end
    
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    
    for player, esp in pairs(espObjects) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local head = character:FindFirstChild("Head")
            
            if rootPart and head then
                local camera = workspace.CurrentCamera
                local rootPos, rootVisible = camera:WorldToViewportPoint(rootPart.Position)
                local headPos = camera:WorldToViewportPoint(head.Position)
                
                if rootVisible then
                    local height = math.abs(headPos.Y - rootPos.Y) * 2
                    local width = height * 0.6
                    
                    -- Update box
                    esp.box.Visible = true
                    esp.box.Size = Vector2.new(width, height)
                    esp.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                    
                    -- Update name
                    esp.name.Visible = true
                    esp.name.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 20)
                    
                    -- Update distance
                    if localRoot then
                        local distance = (localRoot.Position - rootPart.Position).Magnitude
                        esp.distance.Text = math.floor(distance) .. " studs"
                        esp.distance.Visible = true
                        esp.distance.Position = Vector2.new(rootPos.X, rootPos.Y + height/2 + 10)
                        
                        -- Color based on distance
                        if distance < 50 then
                            esp.box.Color = Color3.fromRGB(255, 50, 50)  -- Red
                        elseif distance < 100 then
                            esp.box.Color = Color3.fromRGB(255, 255, 50) -- Yellow
                        else
                            esp.box.Color = Color3.fromRGB(50, 255, 50)  -- Green
                        end
                    end
                else
                    esp.box.Visible = false
                    esp.name.Visible = false
                    esp.distance.Visible = false
                end
            end
        else
            esp.box.Visible = false
            esp.name.Visible = false
            esp.distance.Visible = false
        end
    end
end

-- Trophy TP Loop
local function trophyTPLoop()
    while true do
        if trophyTPEnabled then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local trophy = workspace:FindFirstChild(targetName)
            
            if hrp and trophy then
                if trophy:IsA("Model") then
                    trophy:PivotTo(hrp.CFrame * CFrame.new(0, 0, -3))
                elseif trophy:IsA("BasePart") then
                    trophy.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
                end
            end
        end
        task.wait(0.1)
    end
end

-- Player Management for ESP
local function handlePlayerAdded(player)
    if espEnabled and player ~= LocalPlayer then
        createESP(player)
    end
end

local function handlePlayerRemoving(player)
    if espObjects[player] then
        if espObjects[player].box then
            espObjects[player].box:Remove()
        end
        if espObjects[player].name then
            espObjects[player].name:Remove()
        end
        if espObjects[player].distance then
            espObjects[player].distance:Remove()
        end
        espObjects[player] = nil
    end
end

-- Hotkey Support
local function setupHotkeys()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == Enum.KeyCode.F5 then
                -- Toggle ESP
                if drawingAvailable then
                    espEnabled = not espEnabled
                    
                    if espEnabled then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer then
                                createESP(player)
                            end
                        end
                    else
                        for player, esp in pairs(espObjects) do
                            if esp.box then esp.box:Remove() end
                            if esp.name then esp.name:Remove() end
                            if esp.distance then esp.distance:Remove() end
                        end
                        espObjects = {}
                    end
                    
                    -- Update GUI button if exists
                    if ScreenGui and ScreenGui:FindFirstChild("MainContainer") then
                        local ESPBtn = ScreenGui.MainContainer.ContentFrame:FindFirstChild("ESPBtn")
                        if ESPBtn then
                            if espEnabled then
                                ESPBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
                                ESPBtn.Text = "ESP: ON"
                            else
                                ESPBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
                                ESPBtn.Text = "ESP: OFF"
                            end
                        end
                    end
                    
                    print("ESP toggled:", espEnabled and "ON" or "OFF")
                else
                    warn("Drawing library not available for ESP")
                end
                
            elseif input.KeyCode == Enum.KeyCode.F6 then
                -- Toggle Trophy TP
                trophyTPEnabled = not trophyTPEnabled
                
                -- Update GUI button if exists
                if ScreenGui and ScreenGui:FindFirstChild("MainContainer") then
                    local TrophyBtn = ScreenGui.MainContainer.ContentFrame:FindFirstChild("TrophyBtn")
                    if TrophyBtn then
                        if trophyTPEnabled then
                            TrophyBtn.BackgroundColor3 = Color3.fromRGB(200, 160, 0)
                            TrophyBtn.Text = "CASH: ON"
                        else
                            TrophyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                            TrophyBtn.Text = "CASH: OFF"
                        end
                    end
                end
                
                print("Cash TP toggled:", trophyTPEnabled and "ON" or "OFF")
                
            elseif input.KeyCode == Enum.KeyCode.F7 then
                -- Toggle GUI visibility
                if ScreenGui then
                    local MainContainer = ScreenGui:FindFirstChild("MainContainer")
                    if MainContainer then
                        guiVisible = not guiVisible
                        MainContainer.Visible = guiVisible
                        print("GUI toggled:", guiVisible and "SHOWN" or "HIDDEN")
                    end
                end
            end
        end
    end)
end

-- Main Initialization
createCombinedGUI()

-- Start Trophy TP loop
task.spawn(trophyTPLoop)

-- Setup ESP if drawing is available
if drawingAvailable then
    -- Setup player events
    for _, player in ipairs(Players:GetPlayers()) do
        handlePlayerAdded(player)
    end
    
    Players.PlayerAdded:Connect(handlePlayerAdded)
    Players.PlayerRemoving:Connect(handlePlayerRemoving)
    
    -- Start ESP update loop
    RunService.RenderStepped:Connect(updateESP)
    
    print("ESP system initialized")
else
    warn("Drawing library not available. ESP features disabled.")
end

-- Setup hotkeys
setupHotkeys()

print("Combined Tools loaded successfully!")
print("Hotkeys: F5 = ESP, F6 = Cash TP, F7 = GUI Toggle")
print("GUI: Blue design with minimize button")
