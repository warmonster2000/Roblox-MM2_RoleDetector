-- MM2 Role Revealer for Delta Executor
-- Version: 1.2 (Stealth Mode)
-- Features: Murderer/Deputy detection, console-only output

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local CurrentRound = 0

-- Stealth check function
local function SafeCheck()
    if not LocalPlayer.Character then return false end
    if not LocalPlayer.Character:FindFirstChild("Humanoid") then return false end
    if LocalPlayer.Character.Humanoid.Health <= 0 then return false end
    return true
end

-- Advanced role detection
local function GetRoles()
    if not SafeCheck() then return end
    
    -- Method 1: Check for role tags (new MM2 update)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Check for Murderer tag
            if player:FindFirstChild("MurdererTag") or player:GetAttribute("IsMurderer") then
                print("[Delta] "..player.Name.." → 🔪 Murderer (Tag System)")
            
            -- Check for Sheriff/Deputy tag
            elseif player:FindFirstChild("SheriffTag") or player:GetAttribute("IsSheriff") then
                print("[Delta] "..player.Name.." → 👮 Deputy (Tag System)")
            end
        end
    end

    -- Method 2: Weapon detection (fallback)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            -- Knife detection (Murderer)
            if char:FindFirstChildOfClass("Tool") and char:FindFirstChildOfClass("Tool").Name:lower():find("knife") then
                print("[Delta] "..player.Name.." → 🔪 Murderer (Weapon Scan)")
            -- Gun detection (Deputy)
            elseif char:FindFirstChild("Gun") or char:FindFirstChild("Revolver") then
                print("[Delta] "..player.Name.." → 👮 Deputy (Weapon Scan)")
            end
        end
    end
end

-- Anti-detection measures
local RandomDelay = math.random(8, 15)
local SafeMode = true  -- Set to false for faster updates (riskier)

-- Main loop
while wait(RandomDelay) do
    if SafeMode and math.random(1, 3) == 1 then  -- Random skip some checks
        RandomDelay = math.random(8, 15)
        continue
    end
    
    pcall(GetRoles)
    
    -- Small delay variation to avoid pattern detection
    RandomDelay = SafeMode and math.random(8, 15) or math.random(4, 8)
end

print("[Delta] MM2 Role Detector Activated (Stealth Mode)")
