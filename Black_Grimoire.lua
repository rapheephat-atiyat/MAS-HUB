local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Backpack = Player.Backpack
local VirtualUser = game:GetService("VirtualUser")

_G.AutoFarm = false
_G.AutoBoss = false
_G.Distance = 30
_G.Weapon = "Bow"

local Window = Rayfield:CreateWindow({
    Name = "MAS | Black Grimoire: Legacy",
    Icon = 0,
    LoadingTitle = "Black Grimoire: Legacy",
    LoadingSubtitle = "by MAS",
    Theme = "Default",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Big Hub"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },

    KeySystem = false,
})

local TabFarm = Window:CreateTab("Main", 4483362458)
local Section1 = TabFarm:CreateSection("Farming")
local Toggle_AutoFarm = TabFarm:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoFarm = Value
    end,
})
local Divider = TabFarm:CreateDivider()
local Toggle_AutoBoss = TabFarm:CreateToggle({
    Name = "Auto Boss",
    CurrentValue = false,
    Flag = "AutoBoss",
    Callback = function(Value)
        _G.AutoBoss = Value
    end,
})
local Section2 = TabFarm:CreateSection("Settings")
local Dropdown = TabFarm:CreateDropdown({
    Name = "Select Weapon",
    Options = {""},
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(Options)
        _G.Weapon = Options[1]
    end,
})
local Slider_Distance = TabFarm:CreateSlider({
    Name = "Distance",
    Range = {0, 100},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 30,
    Flag = "Distance",
    Callback = function(Value)
        _G.Distance = Value
    end,
})

-- anti afk
local function AntiAFK()
    while wait(300) do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end

local function GetWeapons()
    while wait(1) do
        if Backpack and Character then
            local oldWeapons = Dropdown.Options
            local weapons = {}
            for _, item in ipairs(Backpack:GetChildren()) do
                if item:IsA("Tool") then
                    table.insert(weapons, item.Name)
                end
            end
            if #weapons > 0 then
                if #oldWeapons ~= #weapons then
                    Dropdown:Refresh(weapons)
                end
            end
        end
    end
end

spawn(AntiAFK)
spawn(GetWeapons)

local function enableNoclip()
    if Character and _G.AutoFarm then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

local function freezePlayerCharacter()
    if Character and _G.AutoFarm then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        if Humanoid then
            Humanoid.PlatformStand = true
        end
    end
end

local QuestData = {
    -- [1] = {
    --     NPC = "Father Orfi",
    --     Monster = "BREAKMEWP",
    --     Quest = "CutWoods",
    --     Type = "questpls",
    --     Position = CFrame.new(-98.2187195, 46.5737, -542.440491, -0.99808234, -0.0208793581, 0.0582724735, -0.0209148973, 0.999781251, 9.48784873e-09, -0.0582597256, -0.0012187534, -0.998300731),
    --     Angle = CFrame.Angles(0, 0, 0),
    --     Path = workspace.THEMAP["11049506"]
    -- },
    -- [50] = {
    --     NPC = "Chris",
    --     Monster = "diesofbatataless",
    --     Quest = "GetPotatoes",
    --     Position = CFrame.new(-105.736382, 46.2866936, -449.492889, 0.984222054, -0.0702154636, 0.162409142, 0.105975367, 0.968970954, -0.223303527, -0.141690403, 0.236991614, 0.961123765),
    --     Angle = CFrame.Angles(0, 0, 0),
    --     Path = workspace.THEMAP.HAGEPOTATOES
    -- },
    -- [125] = {
    --     NPC = "Johnny",
    --     Monster = "Thief",
    --     Quest = "DefeatThief",
    --     Type = "questpls",
    --     Position = CFrame.new(-918.316223, 45.2600861, -2550.06177, -0.707134247, 0.0733348578, -0.703266025, 0, 0.994607091, 0.103715174, 0.707079291, 0.0733405575, -0.703320682),
    --     Angle = CFrame.Angles(-90, 0, 0),
    --     Path = workspace.BadNPCs
    -- },
    [1] = {
        NPC = "Davrqwy",
        Monster = "Golem",
        Quest = "DefeatGolem",
        Type = "questpls",
        Position = CFrame.new(-918.316223, 45.2600861, -2550.06177, -0.707134247, 0.0733348578, -0.703266025, 0, 0.994607091, 0.103715174, 0.707079291, 0.0733405575, -0.703320682),
        Angle = CFrame.Angles(-90, 0, 0),
        Path = workspace.BadNPCs
    },
}

local function ActivateQuest()
    local currentMissionFolder = Player.CurrentMission
    local npcUpperTorso = workspace.NPCs[QuestData[1].NPC]:FindFirstChild("UpperTorso")
    local questInProgress = currentMissionFolder:FindFirstChild(QuestData[1].Quest)
    if not questInProgress and npcUpperTorso then
        Player.Character:SetPrimaryPartCFrame(QuestData[1].Position)
        task.wait(1)
        for _, prompt in ipairs(npcUpperTorso:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                fireproximityprompt(prompt)
                wait(1)
                local args = {
                    [1] = "pcgamer",
                    [2] = {
                        ["Extra"] = QuestData[1].Quest,
                        ["Type"] = QuestData[1].Type,
                    }
                }
                game:GetService("ReplicatedStorage").MainRemote:FireServer(unpack(args))
            end
        end
    end
end

local function AttackMonster(v)
    if Character then
        local weapon = Backpack:FindFirstChild(_G.Weapon)
        if weapon then
            for _, item in ipairs(Backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name == _G.Weapon then
                    item.Parent = Character
                end
            end
        else
            local args = {
                [1] = "Letter H",
                [2] = v.HumanoidRootPart.CFrame
            }
            Character[_G.Weapon].RemoteEvent:FireServer(unpack(args))
        end
    end
end

local function StartFarm()
    if Character then
        local badNPCs = workspace:FindFirstChild("BadNPCs")
        for i, v in pairs(badNPCs:GetChildren()) do
            if _G.AutoFarm then
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name:find(QuestData[1].Monster) then
                    repeat
                        AttackMonster(v)
                        enableNoclip()
                        freezePlayerCharacter()
                        HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * QuestData[1].Angle 
                        task.wait()
                    until (v.Humanoid.Health <= 0 or not _G.AutoFarm)
                end
            end
        end
    end
end

function Main()
    pcall(function()
        while wait() do
            if _G.AutoFarm and Character then
                ActivateQuest()
                StartFarm()
                task.wait()
            end
        end
    end)
end

Main()