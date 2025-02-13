local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Head = Character:WaitForChild("Head")

local GuiName = "MasGUI"

local function findImageTag()
    local tag = Head:WaitForChild("Tag")
    return tag:FindFirstChildOfClass("ImageLabel")
end

function createGUI()
    local oldgui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(GuiName)
    if oldgui then
        oldgui:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = GuiName
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local imgLabel = Instance.new("ImageLabel")
    imgLabel.Parent = gui
    imgLabel.Size = UDim2.new(0, 80, 0, 80)
    imgLabel.Position = UDim2.new(1, -90, 0, 10)
    imgLabel.BackgroundTransparency = 1
    return imgLabel
end

while true do
    local imgTag = findImageTag()
    if imgTag then
        local imgLabel = createGUI()

        imgLabel.Image = imgTag.Image
        imgLabel.ImageRectOffset = imgTag.ImageRectOffset
        imgLabel.ImageRectSize = imgTag.ImageRectSize
    end
    task.wait(.1)
end