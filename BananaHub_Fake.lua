--==================================================
-- 🍌 Banana Hub FAKE 100%
-- UI vàng + Key Fake + Auto Farm + Aimlock Demo
-- Dùng để TEST / HỌC LÀM HUB
--==================================================

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--========================
-- CONFIG
--========================
local FAKE_KEY = "BANANA-123"
local KeyPassed = false

--========================
-- LOAD UI LIB
--========================
local OrionLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Orion/main/source"
))()

--========================
-- KEY SYSTEM (FAKE)
--========================
local KeyWindow = OrionLib:MakeWindow({
    Name = "🍌 Banana Hub | Key System",
    HidePremium = true,
    SaveConfig = false
})

local KeyTab = KeyWindow:MakeTab({
    Name = "Key",
    Icon = "rbxassetid://6034509993"
})

KeyTab:AddTextbox({
    Name = "Nhập Key",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        if Value == FAKE_KEY then
            KeyPassed = true
            OrionLib:MakeNotification({
                Name = "Banana Hub",
                Content = "Key đúng 🍌",
                Time = 3
            })
            OrionLib:Destroy()
        else
            OrionLib:MakeNotification({
                Name = "Banana Hub",
                Content = "Sai.key ❌",
                Time = 3
            })
        end
    end
})

-- Chờ nhập key
repeat task.wait() until KeyPassed

--========================
-- MAIN WINDOW
--========================
local Window = OrionLib:MakeWindow({
    Name = "🍌 Banana Hub",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Banana Hub 🍌"
})

--========================
-- VARIABLES
-- ========================
-- AUTO FARM SUPPORT
-- ========================

local AutoFarmMob = false
local SelectedMob = "Bandit"
local AttackSpeed = 0.15

-- Teleport
local function TP(cf)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cf
    end
end

-- Equip weapon
local function EquipWeapon()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    local bp = plr.Backpack

    if char and bp then
        for _,tool in pairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                char.Humanoid:EquipTool(tool)
                return
            end
        end
    end
end

-- Get mob
local function GetMob(name)
    if not workspace:FindFirstChild("Enemies") then return end
    for _,mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name == name
        and mob:FindFirstChild("Humanoid")
        and mob:FindFirstChild("HumanoidRootPart")
        and mob.Humanoid.Health > 0 then
            return mob
        end
    end
end
--========================
-- AUTO FARM VARIABLES
local AutoFarmMob = false
local SelectedMob = nil
local AttackSpeed = 0.15
local AutoFarm = false
local AimLock = false
local AimFOV = 150

--========================
-- TAB: BLOX FRUITS
--========================
local BloxTab = Window:MakeTab({
    Name = "Blox Fruits",
    Icon = "rbxassetid://4483345998"
})

BloxTab:AddToggle({
    Name = "Auto Farm (Demo)",
    Default = false,
    Callback = function(Value)
        AutoFarm = Value
    end
})

-- Auto Farm DEMO (quay người + tiến lên)
task.spawn(function()
    while task.wait(0.2) do
        if AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-1)
        end
    end
end)

--========================
-- TAB: FF / AIM
--========================
local FFtab = Window:MakeTab({
    Name = "FF / Aim",
    Icon = "rbxassetid://6034287594"
})

FFtab:AddToggle({
    Name = "Aim Lock (Demo)",
    Default = false,
    Callback = function(Value)
        AimLock = Value
    end
})       

FFtab:AddSlider({
    Name = "Aim FOV",
    Min = 50,
    Max = 500,
    Default = 150,
    Increment = 10,
    Color = Color3.fromRGB(255, 221, 0),
    Callback = function(Value)
        AimFOV = Value
    end
})

-- Aimlock DEMO (quay camera về player gần nhất)
RunService.RenderStepped:Connect(function()
    if AimLock then
        local cam = workspace.CurrentCamera
        local closest, dist = nil, AimFOV

        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local pos, onscreen = cam:WorldToViewportPoint(plr.Character.Head.Position)
                if onscreen then
                    local mag = (Vector2.new(pos.X,pos.Y) -
                        Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                    if mag < dist then
                        dist = mag
                        closest = plr
                    end
                end
            end
        end
        
        if closest then
            cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Character.Head.Position)
        end
    end
end)

--========================
-- TAB: PVP
--========================
local PvPTab = Window:MakeTab({
    Name = "PvP",
    Icon = "rbxassetid://6034509993"
})

PvPTab:AddButton({
    Name = "Test PvP Button",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Banana Hub",
            Content = "PvP test 🍌",
            Time = 3
        })
    end
})

--========================
-- FINISH
--========================
OrionLib:Init()