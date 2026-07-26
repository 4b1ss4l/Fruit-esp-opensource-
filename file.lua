-- [[ ESP Fruit & Auto Collect - Com Botão Móvel de Esconder/Revelar ]] --
local RelzUILib = loadstring(game:HttpGet("https://storage.relzhub.com/ui/v1.lua"))()
local RelzhubModule = loadstring(game:HttpGet("https://storage.relzhub.com/modules/main.lua"))()
local Window = RelzUILib:Window({
	Title = "Fruit ESP & Collect",
})

local Tabs = {
	FruitTab = Window:Tab({
		Title = "Fruit",
		Icon = "flask-conical"
	}),
	EspTab = Window:Tab({
		Title = "Esp",
		Icon = "eye"
	})
}

-- Variáveis
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes

local Character
local HumanoidRootPart

local function SetupCharacter(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    SetupCharacter(char)
end)

-- ==================== BOTÃO FLUTUANTE MÓVEL ====================
local ToggleButton = Instance.new("ScreenGui")
ToggleButton.Name = "FruitToggleButton"
ToggleButton.Parent = CoreGui
ToggleButton.ResetOnSpawn = false

local Button = Instance.new("TextButton")
Button.Name = "MainButton"
Button.Size = UDim2.new(0, 50, 0, 50)
Button.Position = UDim2.new(0.85, 0, 0.5, 0)
Button.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
Button.Text = "🍎"
Button.TextSize = 24
Button.Font = Enum.Font.GothamBold
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.BorderSizePixel = 0
Button.BackgroundTransparency = 0.1
Button.Parent = ToggleButton

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Button

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 200, 0)
UIStroke.Thickness = 2
UIStroke.Parent = Button

-- Efeito de brilho
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 30))
})
Gradient.Parent = Button

-- Texto de dica
local HintLabel = Instance.new("TextLabel")
HintLabel.Name = "HintLabel"
HintLabel.Size = UDim2.new(0, 150, 0, 20)
HintLabel.Position = UDim2.new(0, -160, 0, 15)
HintLabel.BackgroundTransparency = 1
HintLabel.Text = "Clique para esconder"
HintLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HintLabel.Font = Enum.Font.Gotham
HintLabel.TextSize = 12
HintLabel.TextStrokeTransparency = 0.5
HintLabel.Parent = Button

-- Sistema de arrastar o botão
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Button.Position
        HintLabel.Text = "Arrastando..."
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                HintLabel.Text = "Clique para esconder"
            end
        end)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        Button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Sistema de esconder/revelar
local menuVisible = true
local RelzWindow = Window

Button.MouseButton2Click:Connect(function()
    menuVisible = not menuVisible
    
    if menuVisible then
        RelzWindow:Show()
        Button.Text = "🍎"
        Button.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
        HintLabel.Text = "Clique para esconder"
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 30))
        })
    else
        RelzWindow:Hide()
        Button.Text = "👁️"
        Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        HintLabel.Text = "Clique para revelar"
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
        })
    end
end)

-- Também permitir clique normal
Button.MouseButton1Click:Connect(function()
    if not dragging then
        menuVisible = not menuVisible
        
        if menuVisible then
            RelzWindow:Show()
            Button.Text = "🍎"
            Button.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
            HintLabel.Text = "Clique para esconder"
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 30))
            })
        else
            RelzWindow:Hide()
            Button.Text = "👁️"
            Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            HintLabel.Text = "Clique para revelar"
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
            })
        end
    end
end)

-- Animação de pulso no botão
spawn(function()
    while wait(2) do
        if Button and Button.Parent then
            -- Efeito de pulsação
            Button.Size = UDim2.new(0, 55, 0, 55)
            wait(0.1)
            Button.Size = UDim2.new(0, 50, 0, 50)
            wait(0.1)
            Button.Size = UDim2.new(0, 55, 0, 55)
            wait(0.1)
            Button.Size = UDim2.new(0, 50, 0, 50)
        end
    end
end)

-- ==================== ESP FRUIT ====================
local FruitESP = {}
local EspFruitEnabled = false

EspTab:Section({
    Title = "Fruit ESP"
})

EspTab:Toggle({
    Title = "Enable Fruit ESP",
    Default = false,
    Callback = function(Value)
        EspFruitEnabled = Value
    end
})

EspTab:Toggle({
    Title = "Fruit Distance",
    Default = true,
    Callback = function(Value)
        _G.FruitDistanceESP = Value
    end
})

local function createFruitESP(fruit)
    if not fruit:IsA("Tool") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "FruitESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255, 100, 50)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 200, 0)
    highlight.OutlineTransparency = 0.3
    highlight.Adornee = fruit
    highlight.Parent = fruit

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FruitESP_Label"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = fruit

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Text = fruit.Name
    label.Parent = billboard

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = label

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 1, 5)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.Text = "Distance: --"
    distanceLabel.Parent = billboard

    FruitESP[fruit] = {
        highlight = highlight,
        billboard = billboard,
        distanceLabel = distanceLabel
    }
end

local function removeFruitESP(fruit)
    if FruitESP[fruit] then
        FruitESP[fruit].highlight:Destroy()
        FruitESP[fruit].billboard:Destroy()
        FruitESP[fruit] = nil
    end
end

local function updateFruitDistances()
    if not EspFruitEnabled then return end
    
    for fruit, espData in pairs(FruitESP) do
        if fruit and fruit.Parent and HumanoidRootPart then
            local distance = (HumanoidRootPart.Position - fruit.Position).Magnitude
            if _G.FruitDistanceESP then
                espData.distanceLabel.Text = string.format("Distance: %.0f studs", distance)
            else
                espData.distanceLabel.Text = ""
            end
        else
            removeFruitESP(fruit)
        end
    end
end

local function scanForFruits()
    if not EspFruitEnabled then return end
    
    for fruit, _ in pairs(FruitESP) do
        if not fruit or not fruit.Parent then
            removeFruitESP(fruit)
        end
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Fruit") then
            if not FruitESP[obj] then
                createFruitESP(obj)
            end
        end
    end
end

-- ==================== AUTO COLLECT FRUIT ====================
local AutoCollectEnabled = false
local AutoStoreEnabled = false
local SelectedRarity = "Common - Mythical"

FruitTab:Section({
    Title = "Auto Collect"
})

FruitTab:Toggle({
    Title = "Auto Collect Fruit",
    Default = false,
    Callback = function(Value)
        AutoCollectEnabled = Value
    end
})

FruitTab:Toggle({
    Title = "Auto Store Fruit",
    Default = false,
    Callback = function(Value)
        AutoStoreEnabled = Value
    end
})

FruitTab:Dropdown({
    Title = "Store Fruit Rarity",
    Values = {"Common", "Uncommon", "Rare", "Legendary", "Mythical", "Common - Mythical"},
    Default = "Common - Mythical",
    Callback = function(Value)
        SelectedRarity = Value
    end
})

local function getFruitRarity(fruitName)
    local fruitRarity = {
        -- Common
        ["Bomb-Bomb"] = "Common", ["Spike-Spike"] = "Common", ["Chop-Chop"] = "Common",
        ["Spring-Spring"] = "Common", ["Smoke-Smoke"] = "Common", ["Spin-Spin"] = "Common",
        ["Rocket-Rocket"] = "Common",
        -- Uncommon
        ["Flame-Flame"] = "Uncommon", ["Ice-Ice"] = "Uncommon", ["Sand-Sand"] = "Uncommon",
        ["Dark-Dark"] = "Uncommon", ["Diamond-Diamond"] = "Uncommon", ["Barrier-Barrier"] = "Uncommon",
        ["Rubber-Rubber"] = "Uncommon", ["Falcon-Falcon"] = "Uncommon",
        -- Rare
        ["Light-Light"] = "Rare", ["Magma-Magma"] = "Rare", ["Door-Door"] = "Rare",
        ["Quake-Quake"] = "Rare", ["Love-Love"] = "Rare", ["Spider-Spider"] = "Rare",
        ["Phoenix-Phoenix"] = "Rare", ["Portal-Portal"] = "Rare",
        -- Legendary
        ["Rumble-Rumble"] = "Legendary", ["String-String"] = "Legendary", 
        ["Buddha-Buddha"] = "Legendary", ["Paw-Paw"] = "Legendary",
        ["Gravity-Gravity"] = "Legendary", ["Shadow-Shadow"] = "Legendary",
        ["Venom-Venom"] = "Legendary", ["Spirit-Spirit"] = "Legendary",
        ["Blizzard-Blizzard"] = "Legendary", ["Sound-Sound"] = "Legendary",
        -- Mythical
        ["Dragon-Dragon"] = "Mythical", ["Dough-Dough"] = "Mythical",
        ["Leopard-Leopard"] = "Mythical", ["Kitsune-Kitsune"] = "Mythical",
        ["T-Rex-T-Rex"] = "Mythical", ["Mammoth-Mammoth"] = "Mythical"
    }
    
    return fruitRarity[fruitName] or "Common"
end

local function shouldStoreFruit(fruitName)
    if SelectedRarity == "Common - Mythical" then return true end
    
    local rarity = getFruitRarity(fruitName)
    local rarityOrder = {"Common", "Uncommon", "Rare", "Legendary", "Mythical"}
    local selectedIndex = table.find(rarityOrder, SelectedRarity) or 1
    local fruitIndex = table.find(rarityOrder, rarity) or 1
    
    return fruitIndex >= selectedIndex
end

local function collectFruit(fruit)
    if not HumanoidRootPart or not fruit or not fruit.Parent then return end
    
    local distance = (HumanoidRootPart.Position - fruit.Position).Magnitude
    
    if distance <= 100 then
        -- Teleporta até a fruta
        local tween = TweenService:Create(
            HumanoidRootPart,
            TweenInfo.new(distance / 300, Enum.EasingStyle.Linear),
            {CFrame = fruit.CFrame}
        )
        tween:Play()
        tween.Completed:Wait()
        
        -- Pega a fruta
        firetouchinterest(HumanoidRootPart, fruit, 0)
        firetouchinterest(HumanoidRootPart, fruit, 1)
        
        wait(0.5)
        
        -- Guarda a fruta se habilitado
        if AutoStoreEnabled and shouldStoreFruit(fruit.Name) then
            Remotes.CommF_:InvokeServer("StoreFruit", fruit.Name, fruit)
        end
    end
end

local function autoCollectFruits()
    if not AutoCollectEnabled then return end
    if not HumanoidRootPart then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Fruit") then
            local distance = (HumanoidRootPart.Position - obj.Position).Magnitude
            if distance <= 100 then
                collectFruit(obj)
            end
        end
    end
end

-- ==================== LOOPS ====================
spawn(function()
    while wait(0.5) do
        pcall(function()
            scanForFruits()
            updateFruitDistances()
        end)
    end
end)

spawn(function()
    while wait(1) do
        pcall(function()
            autoCollectFruits()
        end)
    end
end)

-- ==================== NOTIFICAÇÃO DE FRUTA SPAWNADA ====================
local NotifyFruitEnabled = false

EspTab:Toggle({
    Title = "Notify Fruit Spawn",
    Default = false,
    Callback = function(Value)
        NotifyFruitEnabled = Value
    end
})

local lastFruits = {}

spawn(function()
    while wait(2) do
        pcall(function()
            if not NotifyFruitEnabled then return end
            
            local currentFruits = {}
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") and obj:FindFirstChild("Fruit") then
                    table.insert(currentFruits, obj)
                    if not lastFruits[obj] then
                        -- Nova fruta encontrada
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "🍎 Fruit Spawned!",
                            Text = obj.Name .. " spawned!",
                            Duration = 5,
                            Button1 = "OK"
                        })
                    end
                    lastFruits[obj] = true
                end
            end
            lastFruits = {}
            for _, fruit in pairs(currentFruits) do
                lastFruits[fruit] = true
            end
        end)
    end
end)

print("✅ Fruit ESP & Auto Collect carregado com sucesso!")
print("📋 Funcionalidades:")
print("  - Botão móvel para esconder/revelar menu")
print("  - ESP de Frutas com destaque e distância")
print("  - Auto Coleta de frutas próximas")
print("  - Auto Armazenar por raridade")
print("  - Notificação de frutas novas")
print("🎯 Clique no botão 🍎 para esconder/revelar o menu")
print("🖱️ Arraste o botão para mover pela tela")
