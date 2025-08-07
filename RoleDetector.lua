-- MM2 Role Detector (Console Only)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

-- Скрытное определение ролей через анализ игровых событий
local function getHiddenRoles()
    -- Вариант 1: Анализ атрибутов (если они есть)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            if player:GetAttribute("Murderer") then
                print("[СКРЫТАЯ ИНФО] "..player.Name.." - Убийца")
            elseif player:GetAttribute("Sheriff") then
                print("[СКРЫТАЯ ИНФО] "..player.Name.." - Шериф")
            end
        end
    end

    -- Вариант 2: Отслеживание оружия в инвентаре
    local function checkTools(char)
        if char:FindFirstChild("Knife") then
            return "Убийца"
        elseif char:FindFirstChild("Gun") then
            return "Шериф"
        end
        return "Невинный"
    end

    -- Проверка при появлении персонажа
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            local role = checkTools(char)
            if role ~= "Невинный" then
                print("[ОБНАРУЖЕНО] "..player.Name..": "..role)
            end
        end)
    end)

    -- Проверка существующих игроков
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local role = checkTools(player.Character)
            if role ~= "Невинный" then
                print("[ТЕКУЩАЯ ИНФО] "..player.Name..": "..role)
            end
        end
    end
end

-- Анти-античит проверка
local function isSafe()
    -- Проверяем, не в меню ли мы
    if not localPlayer.Character then return false end
    -- Проверяем наличие человечка
    if not localPlayer.Character:FindFirstChild("Humanoid") then return false end
    -- Проверяем, живы ли мы
    if localPlayer.Character.Humanoid.Health <= 0 then return false end
    return true
end

-- Основной цикл
while wait(5) do  -- Проверяем каждые 5 секунд чтобы не нагружать
    if isSafe() then
        getHiddenRoles()
    end
end
