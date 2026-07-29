-- Services
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables
local Character
local Humanoid
local HumanoidRootPart
local isTweening = false
local PartTele = nil
local lastStoredFruit = nil

-- Settings
local Settings = {
    PlayerTweenSpeed = 300,
    GlobalDelay = 0.5
}

-- Remotes
local Remotes = {}

spawn(function()
    while not Remotes.CommF_ do
        pcall(function()
            Remotes.CommF_ = game:GetService("ReplicatedStorage").Remotes.CommF_
        end)
        task.wait(1)
    end
end)

-- Função round
function round(n)
    return math.floor(tonumber(n) + 0.5)
end

-- Character
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
    if PartTele then
        PartTele:Destroy()
        PartTele = nil
    end
    isTweening = false
end)

-- Tween
function TweenPlayer(targetCFrame)
    if not Character or not Humanoid or Humanoid.Health <= 0 then return end
    if not HumanoidRootPart then return end
    if isTweening then return end
    
    local targetPos = targetCFrame.Position
    local distance = (targetPos - HumanoidRootPart.Position).Magnitude
    
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

-- ESP
function InitEspDevilFruit()
    if not Character or not Character:FindFirstChild("Head") then return end
    
    for i, v in pairs(workspace:GetDescendants()) do
        pcall(function()
            if v.Name and string.find(v.Name, "Fruit") then
                if v:FindFirstChild("Handle") then
                    local handle = v.Handle
                    
                    if _G.EspDevilFruit then
                        if not handle:FindFirstChild("EspDevilFruit") then
                            local bill = Instance.new("BillboardGui")
                            bill.Name = "EspDevilFruit"
                            bill.ExtentsOffset = Vector3.new(0, 1, 0)
                            bill.Size = UDim2.new(1, 200, 1, 30)
                            bill.Adornee = handle
                            bill.AlwaysOnTop = true
                            bill.Parent = handle
                            
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
                            handle["EspDevilFruit"].Label.Text = v.Name .. " \n" .. round((Character.Head.Position - handle.Position).Magnitude / 3) .. " Distance"
                        end
                    else
                        if handle:FindFirstChild("EspDevilFruit") then
                            handle["EspDevilFruit"]:Destroy()
                        end
                    end
                end
            end
        end)
    end
end

spawn(function()
    while task.wait(1) do
        if _G.EspDevilFruit then
            InitEspDevilFruit()
        end
    end
end)

-- Teleport
function TeleportToFruit()
    if not Character or not HumanoidRootPart then return end
    
    local nearestFruit = nil
    local shortestDistance = math.huge
    
    for i, v in pairs(workspace:GetDescendants()) do
        if v.Name and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
            local distance = (v.Handle.Position - HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestFruit = v
            end
        end
    end
    
    if nearestFruit then
        HumanoidRootPart.CFrame = nearestFruit.Handle.CFrame * CFrame.new(0, 5, 0)
    end
end

-- Tween To Fruit
function TweenToFruit()
    if not Character or not HumanoidRootPart or isTweening then return end
    
    local nearestFruit = nil
    local shortestDistance = math.huge
    
    for i, v in pairs(workspace:GetDescendants()) do
        if v.Name and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
            local distance = (v.Handle.Position - HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestFruit = v
            end
        end
    end
    
    if nearestFruit then
        TweenPlayer(nearestFruit.Handle.CFrame)
    end
end

-- Auto Store
function AutoStoreFruit()
    if not _G.AutoStoreFruit then return end
    
    pcall(function()
        for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if string.find(v.Name, "Fruit") and v:IsA("Tool") then
                if v.Name ~= lastStoredFruit then
                    local fruitName = string.gsub(v.Name, " Fruit", "")
                    
                    if Remotes.CommF_ then
                        Remotes.CommF_:InvokeServer("StoreFruit", fruitName .. "-" .. fruitName, v)
                        lastStoredFruit = v.Name
                    end
                end
            end
        end
    end)
end

spawn(function()
    while task.wait(0.2) do
        AutoStoreFruit()
    end
end)

-- Server Hop
local Api = "https://games.roblox.com/v1/games/"

local function getServers()
    local url = Api .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local raw = game:HttpGet(url)
    return HttpService:JSONDecode(raw).data
end

function HopToLowestPlayers()
    local servers = getServers()

    for _, server in ipairs(servers) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            break
        end
    end
end

-- UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DevilFruitHub"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 40)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -20)
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = false
    MainFrame.Parent = ScreenGui
    
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
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Parent = ContentFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    
    local function CreateButton(title, callback)
        local Button = Instance.new("TextButton")
        Button.Text = title
        Button.Size = UDim2.new(1, -10, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.GothamMedium
        Button.TextSize = 14
        Button.BorderSizePixel = 0
        Button.Parent = ScrollingFrame
        
        Button.MouseButton1Click:Connect(callback)
        return Button
    end
    
    local function CreateToggle(title, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = ScrollingFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Text = title
        ToggleLabel.Size = UDim2.new(0, 170, 1, 0)
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
    
    CreateToggle("ESP Devil Fruit", false, function(state)
        _G.EspDevilFruit = state
        if state then
            InitEspDevilFruit()
        end
    end)
    
    CreateButton("Teleport To Fruit", function()
        TeleportToFruit()
    end)
    
    CreateButton("Tween To Fruit", function()
        TweenToFruit()
    end)
    
    CreateToggle("Auto Store Fruit", false, function(state)
        _G.AutoStoreFruit = state
    end)
    
    CreateButton("Hop To Lowest Players", function()
        HopToLowestPlayers()
    end)
    
    -- Ajuste automático da altura
    local function updateCanvasSize()
        local totalHeight = 0
        for _, child in ipairs(ScrollingFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                totalHeight = totalHeight + child.Size.Y.Offset + UIListLayout.Padding.Offset
            end
        end
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        
        local contentHeight = math.min(totalHeight + 43, 400)
        MainFrame.Size = UDim2.new(0, 250, 0, contentHeight)
    end
    
    updateCanvasSize()
    
    -- Arraste suave
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Minimizar
    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainFrame.Size = UDim2.new(0, 250, 0, 40)
            ContentFrame.Visible = false
            MinimizeButton.Text = "+"
        else
            ContentFrame.Visible = true
            updateCanvasSize()
            MinimizeButton.Text = "_"
        end
    end)
    
    return ScreenGui
end

CreateUI()

-- Globals
_G.EspDevilFruit = false
_G.AutoStoreFruit = false
_G.GlobalDelay = Settings.GlobalDelay
_G.PlayerTweenSpeed = Settings.PlayerTweenSpeed
