-- ESP de Frutas para Blox Fruits
-- Script feito em LuaU

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Variáveis
local fruitESP = {}
local espEnabled = false
local fruitList = {}

-- Criar UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitESP_GUI"
ScreenGui.Parent = CoreGui

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.5, -125, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.1
MainFrame.Parent = ScreenGui

-- Arredondar cantos
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🍎 Fruit ESP - Blox Fruits"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- Botão de arrastar
local DragButton = Instance.new("TextButton")
DragButton.Size = UDim2.new(1, 0, 1, 0)
DragButton.BackgroundTransparency = 1
DragButton.Text = ""
DragButton.Parent = TitleBar

-- Conteúdo
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 0, 100)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Botão Ativar/Desativar
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 0, 40)
ToggleButton.Position = UDim2.new(0, 0, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "ATIVAR ESP"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ContentFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = ToggleButton

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Desativado"
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13
StatusLabel.Parent = ContentFrame

-- Função para verificar se é fruta
local function isFruit(obj)
    if obj:IsA("Tool") then
        local name = obj.Name:lower()
        if name:find("fruit") or name:find("fruta") or name:find("mochi") or 
           name:find("dough") or name:find("dragon") or name:find("leopard") or
           name:find("venom") or name:find("spirit") or name:find("shadow") or
           name:find("gravity") or name:find("paw") or name:find("phoenix") or
           name:find("portal") or name:find("rumble") or name:find("blizzard") or
           name:find("sound") or name:find("love") or name:find("spider") or
           name:find("quake") or name:find("buddha") or name:find("string") or
           name:find("bird") or name:find("falcon") or name:find("ice") or
           name:find("sand") or name:find("dark") or name:find("flame") or
           name:find("light") or name:find("magma") or name:find("barrier") or
           name:find("rubber") or name:find("door") or name:find("spin") or
           name:find("chop") or name:find("spring") or name:find("bomb") or
           name:find("smoke") or name:find("spike") or name:find("diamond") or
           name:find("rocket") or name:find("sword") == false then
            return true
        end
    end
    return false
end

-- Função para criar ESP de uma fruta
local function createFruitESP(fruit)
    local highlight = Instance.new("Highlight")
    highlight.Name = "FruitHighlight"
    highlight.FillColor = Color3.fromRGB(255, 100, 50)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 200, 0)
    highlight.OutlineTransparency = 0.3
    highlight.Adornee = fruit
    highlight.Parent = fruit

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FruitLabel"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
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
    distanceLabel.Text = "Distância: --"
    distanceLabel.Parent = billboard

    fruitESP[fruit] = {
        highlight = highlight,
        billboard = billboard,
        label = label,
        distanceLabel = distanceLabel
    }
end

-- Função para remover ESP de uma fruta
local function removeFruitESP(fruit)
    if fruitESP[fruit] then
        fruitESP[fruit].highlight:Destroy()
        fruitESP[fruit].billboard:Destroy()
        fruitESP[fruit] = nil
    end
end

-- Função para atualizar distância
local function updateDistances()
    if not espEnabled then return end
    
    for fruit, espData in pairs(fruitESP) do
        if fruit and fruit.Parent then
            local distance = (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
                            (player.Character.HumanoidRootPart.Position - fruit.Position).Magnitude) or 0
            espData.distanceLabel.Text = string.format("Distância: %.0f studs", distance)
        else
            removeFruitESP(fruit)
        end
    end
end

-- Atualizar frutas no mapa
local function scanForFruits()
    if not espEnabled then return end
    
    -- Remover ESP de frutas que não existem mais
    for fruit, _ in pairs(fruitESP) do
        if not fruit or not fruit.Parent then
            removeFruitESP(fruit)
        end
    end
    
    -- Procurar novas frutas
    for _, obj in pairs(workspace:GetDescendants()) do
        if isFruit(obj) and not fruitESP[obj] then
            createFruitESP(obj)
        end
    end
end

-- Toggle do ESP
ToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        ToggleButton.Text = "DESATIVAR ESP"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StatusLabel.Text = "Status: Ativado 🟢"
        StatusLabel.TextColor3 = Color3.fromRGB(50, 205, 50)
        scanForFruits()
    else
        ToggleButton.Text = "ATIVAR ESP"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        StatusLabel.Text = "Status: Desativado"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        
        -- Remover todos ESP
        for fruit, _ in pairs(fruitESP) do
            removeFruitESP(fruit)
        end
    end
end)

-- Arrastar UI
local dragging = false
local dragStart = nil
local startPos = nil

DragButton.MouseButton1Down:Connect(function()
    dragging = true
    dragStart = UserInputService:GetMouseLocation()
    startPos = MainFrame.Position
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Loop principal
RunService.Heartbeat:Connect(function()
    scanForFruits()
    updateDistances()
end)

-- Limpar quando o script for removido
script.Destroying:Connect(function()
    for fruit, _ in pairs(fruitESP) do
        removeFruitESP(fruit)
    end
end)

print("🍎 Fruit ESP carregado com sucesso!")
print("Pressione o botão na UI para ativar/desativar")
