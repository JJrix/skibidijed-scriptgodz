-- GUI Part
local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Name = "SkibidiJedGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

TextLabel.Parent = ScreenGui
TextLabel.Size = UDim2.new(0, 250, 0, 50)
TextLabel.Position = UDim2.new(0.5, -125, 0, 20)
TextLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 20
TextLabel.Text = "Script By Skibidi Jed"
TextLabel.BorderSizePixel = 0
TextLabel.BackgroundTransparency = 0.2
TextLabel.TextStrokeTransparency = 0.5
TextLabel.TextWrapped = true

-- Auto-remove GUI after a few seconds
task.delay(4, function()
    ScreenGui:Destroy()
end)

-- Remote Renaming Part
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")

if not remotesFolder then
    warn("📂 'Remotes' folder not found in ReplicatedStorage.")
    return
end

local renameMap = {
    DeductCoin = "Xzcd1",
    DeductCash = "Hjk7z7",
    DeductOnHoldCash = "bypassedjed",
    DeductExp = "2!4699"
}

for oldName, newName in pairs(renameMap) do
    local remote = remotesFolder:FindFirstChild(oldName)
    if remote and remote:IsA("RemoteEvent") then
        remote.Name = newName
        print("✅ Renamed '" .. oldName .. "' to '" .. newName .. "'")
    else
        warn("⚠️ Remote '" .. oldName .. "' not found or not a RemoteEvent.")
    end
end
