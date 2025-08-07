local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "MM2RoleDetector"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 60)
Frame.Position = UDim2.new(0.5, -110, 0, 20)
Frame.BackgroundTransparency = 0.7
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9, 0, 0.7, 0)
Button.Position = UDim2.new(0.05, 0, 0.15, 0)
Button.Text = "ПОКАЗАТЬ РОЛИ"
Button.TextSize = 14
Button.Font = Enum.Font.GothamBold
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Button.Parent = Frame

-- Хранилище подсветок
local Highlights = {}

-- Улучшенная функция создания подсветки
local function CreateESP(player, color)
    if not player.Character then return end
    
    local esp = Instance.new("BoxHandleAdornment")
    esp.Name = "RoleESP"
    esp.Adornee = player.Character:WaitForChild("HumanoidRootPart")
    esp.Size = Vector3.new(3, 6, 3)
    esp.Color3 = color
    esp.Transparency = 0.3
    esp.AlwaysOnTop = true
    esp.ZIndex = 10
    esp.Parent = player.Character
    
    Highlights[player] = esp
    
    -- Обновляем при изменении персонажа
    player.CharacterAdded:Connect(function(char)
        if Highlights[player] then
            esp.Adornee = char:WaitForChild("HumanoidRootPart")
        end
    end)
end

-- Функция очистки
local function ClearESP()
    for _, esp in pairs(Highlights) do
        esp:Destroy()
    end
    Highlights = {}
end

-- Улучшенный детектор ролей
local function DetectRoles()
    ClearESP()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Метод 1: Проверка атрибутов
            if player:GetAttribute("Murderer") or player:GetAttribute("Role") == "Murderer" then
                CreateESP(player, Color3.fromRGB(255, 50, 50))
            
            -- Метод 2: Проверка оружия
            elseif player.Character:FindFirstChildWhichIsA("Tool") and 
                   (player.Character:FindFirstChild("Knife") or 
                    player.Character:FindFirstChild("Sword")) then
                CreateESP(player, Color3.fromRGB(255, 0, 0))
                
            -- Метод 3: Шериф
            elseif player:GetAttribute("Sheriff") or 
                   player.Character:FindFirstChild("Gun") then
                CreateESP(player, Color3.fromRGB(50, 50, 255))
            end
        end
    end
    
    -- Автоочистка через 15 сек
    delay(15, ClearESP)
end

-- Обработчик кнопки
Button.MouseButton1Click:Connect(function()
    DetectRoles()
    
    -- Меняем кнопку на время кулдауна
    Button.Text = "СКАН ЗАВЕРШЕН"
    Button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    wait(3)
    Button.Text = "ПОКАЗАТЬ РОЛИ"
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

-- Автоочистка при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if Highlights[player] then
        Highlights[player]:Destroy()
        Highlights[player] = nil
    end
end)

print("MM2 Role Detector активирован! Нажмите кнопку для сканирования.")
