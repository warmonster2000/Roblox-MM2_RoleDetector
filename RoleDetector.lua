local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 50)
Frame.Position = UDim2.new(0.5, -100, 0, 10)
Frame.BackgroundTransparency = 0.5
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9, 0, 0.8, 0)
Button.Position = UDim2.new(0.05, 0, 0.1, 0)
Button.Text = "Показать роли"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Button.Parent = Frame

-- Для хранения подсветок
local Highlights = {}

-- Функция создания подсветки
local function CreateHighlight(player, color)
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "RoleHighlight"
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    Highlights[player] = highlight
end

-- Функция удаления подсветок
local function ClearHighlights()
    for _, highlight in pairs(Highlights) do
        highlight:Destroy()
    end
    Highlights = {}
end

-- Основная функция
Button.MouseButton1Click:Connect(function()
    ClearHighlights()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Проверка на убийцу
            if player:GetAttribute("Murderer") or player.Character:FindFirstChild("Knife") then
                CreateHighlight(player, Color3.fromRGB(255, 0, 0)) -- Красный
                print("Найден убийца: " .. player.Name)
            
            -- Проверка на шерифа
            elseif player:GetAttribute("Sheriff") or player.Character:FindFirstChild("Gun") then
                CreateHighlight(player, Color3.fromRGB(0, 0, 255)) -- Синий
                print("Найден шериф: " .. player.Name)
            end
        end
    end
    
    -- Автоматическое удаление через 10 секунд
    task.delay(10, ClearHighlights)
end)

-- Обновление подсветок при изменении персонажей
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if Highlights[player] then
            CreateHighlight(player, Highlights[player].FillColor)
        end
    end)
end)

-- Удаление при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if Highlights[player] then
        Highlights[player]:Destroy()
        Highlights[player] = nil
    end
end)
