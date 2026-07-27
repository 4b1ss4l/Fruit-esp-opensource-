--[[
    Script Roblox Integrado - Devil Fruit ESP & Utilities
    Organizado com todas as funcionalidades mantidas e integradas
]]

-- Serviços
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variáveis do Player
local Character
local Humanoid
local HumanoidRootPart

-- Variáveis de controle
local isTweening = false  -- Controla para não iniciar múltiplos tweens
local PartTele = nil      -- Parte usada para o tween

-- Remotes
local Remotes = {}

-- Aguarda os remotes estarem disponíveis
spawn(function()
    while not Remotes.CommF_ do
        pcall(function()
            Remotes.CommF_ = game:GetService("ReplicatedStorage").Remotes.CommF_
        end)
        task.wait(1)
    end
end)

-- Configurações globais
local Settings = {
    PlayerTweenSpeed = 300,  -- Velocidade do tween
    GlobalDelay = 0.5        -- Delay entre verificações
}

-- Função round
function round(n)
    return math.floor(tonumber(n) + 0.5)
end

-- Configuração do Character
local function SetupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    SetupCharacter(char)
    -- Limpa o PartTele quando o personagem muda
    if PartTele then
        PartTele:Destroy()
        PartTele = nil
    end
    isTweening = false
end)

-- Tween System
function TweenPlayer(targetCFrame)
    -- Verificações de segurança
    if not Character or not Humanoid or Humanoid.Health <= 0 then return end
    if not HumanoidRootPart then return end
    if isTweening then return end  -- Evita múltiplos tweens
    
    local targetPos = targetCFrame.Position
    local distance = (targetPos - HumanoidRootPart.Position).Magnitude
    
    -- Cria parte de teletransporte se não existir
    if not Character:FindFirstChild("PartTele") then
        PartTele = Instance.new("Part")
        PartTele.Name = "PartTele"
        PartTele.Size = Vector3.new(10, 1, 10)
        PartTele.Anchored = true
        PartTele.Transparency = 1
        PartTele.CanCollide = true
        PartTele.CFrame = HumanoidRootPart.CFrame
        PartTele.Parent = Character
        
        PartTele:GetPropertyChangedSignal("CFrame"):Connect(function()
            if not isTweening then return end
            task.wait()
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = PartTele.CFrame
            end
        end)
    else
        PartTele = Character:FindFirstChild("PartTele")
    end
    
    isTweening = true
    
    -- Cria e executa o tween
    local tweenInfo = TweenInfo.new(
        distance / Settings.PlayerTweenSpeed,
        Enum.EasingStyle.Linear
    )
    
    local tween = TweenService:Create(
        PartTele,
        tweenInfo,
        {CFrame = targetCFrame}
    )
    
    tween:Play()
    tween.Completed:Connect(function()
        isTweening = false
    end)
end

-- ESP Devil Fruit System
function InitEspDevilFruit()
    if not Character or not Character:FindFirstChild("Head") then return end
    
    for i, v in pairs(workspace:GetDescendants()) do
        pcall(function()
            if v.Name and string.find(v.Name, "Fruit") then
                if v:FindFirstChild("Handle") then
                    local handle = v.Handle
                    
                    if _G.EspDevilFruit then
                        if not handle:FindFirstChild("EspDevilFruit") then
                            -- Cria BillboardGui
                            local bill = Instance.new("BillboardGui")
                            bill.Name = "EspDevilFruit"
                            bill.ExtentsOffset = Vector3.new(0, 1, 0)
                            bill.Size = UDim2.new(1, 200, 1, 30)
                            bill.Adornee = handle
                            bill.AlwaysOnTop = true
                            bill.Parent = handle
                            
                            -- Label com nome e distância
                            local name = Instance.new("TextLabel")
                            name.Name = "Label"
                            name.Font = Enum.Font.GothamSemibold
                            name.TextSize = 14
                            name.TextWrapped = true
                            name.Size = UDim2.new(1, 0, 1, 0)
                            name.TextYAlignment = Enum.TextYAlignment.Top
                            name.BackgroundTransparency = 1
                            name.TextStrokeTransparency = 0.5
                            name.TextColor3 = Color3.fromRGB(255, 255, 255)
                            name.Text = v.Name .. " \n" .. round((Character.Head.Position - handle.Position).Magnitude / 3) .. " Distance"
                            name.Parent = bill
                            
                            -- Efeito arco-íris no texto
                            local rainbowColors = {
                                Color3.fromRGB(255, 0, 0),
                                Color3.fromRGB(255, 127, 0),
                                Color3.fromRGB(255, 255, 0),
                                Color3.fromRGB(0, 255, 0),
                                Color3.fromRGB(0, 0, 255),
                                Color3.fromRGB(75, 0, 130),
                                Color3.fromRGB(148, 0, 211)
                            }
                            
                            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                            
                            coroutine.wrap(function()
                                while handle:FindFirstChild("EspDevilFruit") do
                                    for _, color in ipairs(rainbowColors) do
                                        if not handle:FindFirstChild("EspDevilFruit") then break end
                                        local colorTween = TweenService:Create(
                                            name,
                                            tweenInfo,
                                            {TextColor3 = color}
                                        )
                                        colorTween:Play()
                                        colorTween.Completed:Wait()
                                    end
                                end
                            end)()
                        else
                            -- Atualiza apenas o texto
                            handle["EspDevilFruit"].Label.Text = v.Name .. " \n" .. round((Character.Head.Position - handle.Position).Magnitude / 3) .. " Distance"
                        end
                    else
                        -- Remove ESP se desativado
                        if handle:FindFirstChild("EspDevilFruit") then
                            handle["EspDevilFruit"]:Destroy()
                        end
                    end
                end
            end
        end)
    end
end

-- Loop de atualização do ESP
spawn(function()
    while task.wait(1) do
        if _G.EspDevilFruit then
            InitEspDevilFruit()
        end
    end
end)

-- Teleport To Fruit
function TeleportToFruit()
    if not Character or not HumanoidRootPart then return end
    
    local nearestFruit = nil
    local shortestDistance = math.huge
    
    -- Encontra a fruta mais próxima
    for i, v in pairs(workspace:GetDescendants()) do
        if v.Name and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
            local distance = (v.Handle.Position - HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestFruit = v
            end
        end
    end
    
    -- Teleporta para a fruta mais próxima
    if nearestFruit then
        HumanoidRootPart.CFrame = nearestFruit.Handle.CFrame * CFrame.new(0, 5, 0)
    end
end

-- Tween To Fruit
function TweenToFruit()
    if not Character or not HumanoidRootPart or isTweening then return end
    
    local nearestFruit = nil
    local shortestDistance = math.huge
    
    -- Encontra a fruta mais próxima
    for i, v in pairs(workspace:GetDescendants()) do
        if v.Name and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
            local distance = (v.Handle.Position - HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestFruit = v
            end
        end
    end
    
    -- Inicia o tween para a fruta mais próxima
    if nearestFruit then
        TweenPlayer(nearestFruit.Handle.CFrame)
    end
end

-- Auto Store Fruit
local lastStoredFruit = nil  -- Proteção contra chamadas repetidas

function AutoStoreFruit()
    if not _G.AutoStoreFruit then return end
    
    pcall(function()
        for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if string.find(v.Name, "Fruit") and v:IsA("Tool") then
                -- Proteção para evitar chamadas repetidas da mesma fruta
                if v.Name ~= lastStoredFruit then
                    -- Extrai o nome da fruta
                    local fruitName = string.gsub(v.Name, " Fruit", "")
                    
                    -- Tenta armazenar usando o Remote
                    if Remotes.CommF_ then
                        Remotes.CommF_:InvokeServer("StoreFruit", fruitName .. "-" .. fruitName, v)
                        lastStoredFruit = v.Name
                    end
                end
            end
        end
    end)
end

-- Loop do Auto Store Fruit
spawn(function()
    while task.wait(0.2) do
        AutoStoreFruit()
    end
end)

-- Server Hop para o servidor com menos jogadores
function HopToLowestPlayers()
    local Api = "https://games.roblox.com/v1/games/"
    local placeId = game.PlaceId
    
    -- Função para listar servidores
    local function ListServers(cursor)
        local url = Api .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor then
            url = url .. "&cursor=" .. cursor
        end
        
        local success, raw = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            return HttpService:JSONDecode(raw)
        end
        return nil
    end
    
    -- Busca o servidor com menos jogadores
    local server = nil
    local nextPage = nil
    
    repeat
        local servers = ListServers(nextPage)
        if servers and #servers.data > 0 then
            server = servers.data[1]
            nextPage = servers.nextPageCursor
        else
            break
        end
    until server
    
    -- Teleporta para o servidor encontrado
    if server then
        TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
    end
end

-- Interface do Usuário (UI)
local function CreateUI()
    -- ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DevilFruitHub"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = false
    MainFrame.Parent = ScreenGui
    
    -- Título/Header (arrastável)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = "Devil Fruit Hub"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Botão de minimizar
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Text = "_"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 20
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = Header
    
    -- Container para o conteúdo
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- ScrollingFrame para o conteúdo
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Parent = ContentFrame
    
    -- UIListLayout para organizar
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ScrollingFrame
    
    -- Função para criar uma seção
    local function CreateSection(name)
        local Section = Instance.new("Frame")
        Section.Name = name .. "Section"
        Section.Size = UDim2.new(1, -10, 0, 30)
        Section.Position = UDim2.new(0, 5, 0, 0)
        Section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Section.BorderSizePixel = 0
        Section.Parent = ScrollingFrame
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Text = name
        SectionTitle.Size = UDim2.new(1, 0, 1, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextSize = 16
        SectionTitle.Parent = Section
        
        return Section
    end
    
    -- Função para criar um botão
    local function CreateButton(section, title, callback)
        local Button = Instance.new("TextButton")
        Button.Text = title
        Button.Size = UDim2.new(1, -10, 0, 35)
        Button.Position = UDim2.new(0, 5, 0, 0)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.GothamMedium
        Button.TextSize = 14
        Button.BorderSizePixel = 0
        Button.Parent = ScrollingFrame
        
        Button.MouseButton1Click:Connect(callback)
        return Button
    end
    
    -- Função para criar um toggle
    local function CreateToggle(section, title, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
        ToggleFrame.Position = UDim2.new(0, 5, 0, 0)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = ScrollingFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Text = title
        ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.Font = Enum.Font.GothamMedium
        ToggleLabel.TextSize = 14
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Text = default and "ON" or "OFF"
        ToggleButton.Size = UDim2.new(0, 50, 0, 25)
        ToggleButton.Position = UDim2.new(1, -60, 0, 5)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 14
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame
        
        local isOn = default
        
        ToggleButton.MouseButton1Click:Connect(function()
            isOn = not isOn
            ToggleButton.Text = isOn and "ON" or "OFF"
            ToggleButton.BackgroundColor3 = isOn and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
            callback(isOn)
        end)
        
        return ToggleFrame
    end
    
    -- Criando as seções
    local FruitSection = CreateSection("Fruit")
    local MiscSection = CreateSection("Misc")
    
    -- Toggles e Botões da seção Fruit
    CreateToggle(FruitSection, "ESP Devil Fruit", false, function(state)
        _G.EspDevilFruit = state
        if state then
            InitEspDevilFruit()
        end
    end)
    
    CreateButton(FruitSection, "Teleport To Fruit", function()
        TeleportToFruit()
    end)
    
    CreateButton(FruitSection, "Tween To Fruit", function()
        TweenToFruit()
    end)
    
    CreateToggle(FruitSection, "Auto Store Fruit", false, function(state)
        _G.AutoStoreFruit = state
    end)
    
    -- Botões da seção Misc
    CreateButton(MiscSection, "Hop to Lowest Players", function()
        HopToLowestPlayers()
    end)
    
    -- Funcionalidade de arrastar (suporte Mouse e Touch)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)
    
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Funcionalidade de minimizar
    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainFrame.Size = UDim2.new(0, 300, 0, 40)
            ContentFrame.Visible = false
            MinimizeButton.Text = "+"
        else
            MainFrame.Size = UDim2.new(0, 300, 0, 400)
            ContentFrame.Visible = true
            MinimizeButton.Text = "_"
        end
    end)
    
    return ScreenGui
end

-- Inicializa a UI
CreateUI()

-- Inicializa variáveis globais
_G.EspDevilFruit = false
_G.AutoStoreFruit = false
_G.GlobalDelay = Settings.GlobalDelay
_G.PlayerTweenSpeed = Settings.PlayerTweenSpeed
