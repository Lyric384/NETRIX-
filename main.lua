-- NETRIX | Fluxo PVP Hub - Tema Roxo
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis de Estado
local AimBotEnabled = false
local ShowFOV = true
local FOVRadius = 150

local ESPBoxEnabled = false
local ESPSkeletonEnabled = false
local ESPLineEnabled = false

local DiscordLink = "https://discord.gg/5TFHuucxgw"
local YoutubeLink = "https://www.youtube.com/@Netrixofc"

-- --- Interface Gráfica ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NetrixHubRoxo"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Painel Principal (Inicia Visível)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 260)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 15, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 1.5

-- 2. Botão Flutuante (Abre / Fecha Painel - Tamanho Aumentado)
local FloatingButton = Instance.new("ImageButton", ScreenGui)
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 48, 0, 48)
FloatingButton.Position = UDim2.new(0.05, 0, 0.2, 0)
FloatingButton.Image = "rbxthumb://type=Asset&id=109965584967630&w=420&h=420"
FloatingButton.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
FloatingButton.Active = true
FloatingButton.Draggable = true
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 10)

local FloatStroke = Instance.new("UIStroke", FloatingButton)
FloatStroke.Color = Color3.fromRGB(138, 43, 226)
FloatStroke.Thickness = 1.5

FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Título
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "NETRIX HUB | Fluxo PVP"
Title.Size = UDim2.new(1, 0, 0, 28)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13

-- Barra de Navegação de Abas
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 240, 0, 26)
TabBar.Position = UDim2.new(0.04, 0, 0, 28)
TabBar.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 6)

local TabPVPBtn = Instance.new("TextButton", TabBar)
TabPVPBtn.Size = UDim2.new(0.48, 0, 1, 0)
TabPVPBtn.Text = "⚡ PVP"
TabPVPBtn.Font = Enum.Font.GothamBold
TabPVPBtn.TextSize = 11
TabPVPBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
TabPVPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TabPVPBtn).CornerRadius = UDim.new(0, 5)

local TabRedesBtn = Instance.new("TextButton", TabBar)
TabRedesBtn.Size = UDim2.new(0.48, 0, 1, 0)
TabRedesBtn.Text = "🌐 Redes"
TabRedesBtn.Font = Enum.Font.GothamBold
TabRedesBtn.TextSize = 11
TabRedesBtn.BackgroundColor3 = Color3.fromRGB(30, 28, 38)
TabRedesBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
Instance.new("UICorner", TabRedesBtn).CornerRadius = UDim.new(0, 5)

-- Containers das Abas
local PVPFrame = Instance.new("ScrollingFrame", MainFrame)
PVPFrame.Name = "PVPFrame"
PVPFrame.Size = UDim2.new(1, 0, 1, -60)
PVPFrame.Position = UDim2.new(0, 0, 0, 60)
PVPFrame.BackgroundTransparency = 1
PVPFrame.ScrollBarThickness = 2
PVPFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
PVPFrame.CanvasSize = UDim2.new(0, 0, 0, 260)
PVPFrame.Visible = true

local RedesFrame = Instance.new("ScrollingFrame", MainFrame)
RedesFrame.Name = "RedesFrame"
RedesFrame.Size = UDim2.new(1, 0, 1, -60)
RedesFrame.Position = UDim2.new(0, 0, 0, 60)
RedesFrame.BackgroundTransparency = 1
RedesFrame.ScrollBarThickness = 2
RedesFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
RedesFrame.CanvasSize = UDim2.new(0, 0, 0, 100)
RedesFrame.Visible = false

-- Layouts
local PVPList = Instance.new("UIListLayout", PVPFrame)
PVPList.SortOrder = Enum.SortOrder.LayoutOrder
PVPList.Padding = UDim.new(0, 6)
PVPList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local RedesList = Instance.new("UIListLayout", RedesFrame)
RedesList.SortOrder = Enum.SortOrder.LayoutOrder
RedesList.Padding = UDim.new(0, 6)
RedesList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Troca de Abas
TabPVPBtn.MouseButton1Click:Connect(function()
    PVPFrame.Visible = true
    RedesFrame.Visible = false
    TabPVPBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    TabPVPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabRedesBtn.BackgroundColor3 = Color3.fromRGB(30, 28, 38)
    TabRedesBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

TabRedesBtn.MouseButton1Click:Connect(function()
    PVPFrame.Visible = false
    RedesFrame.Visible = true
    TabRedesBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    TabRedesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabPVPBtn.BackgroundColor3 = Color3.fromRGB(30, 28, 38)
    TabPVPBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

-- --- Criador de Switch Toggle ---
local function CreateSwitch(name, order, defaultState, callback)
    local state = defaultState

    local btnFrame = Instance.new("TextButton", PVPFrame)
    btnFrame.Size = UDim2.new(0.9, 0, 0, 32)
    btnFrame.LayoutOrder = order
    btnFrame.BackgroundColor3 = Color3.fromRGB(25, 23, 32)
    btnFrame.Text = ""
    btnFrame.AutoButtonColor = false
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local switchBG = Instance.new("Frame", btnFrame)
    switchBG.Size = UDim2.new(0, 32, 0, 16)
    switchBG.Position = UDim2.new(0.95, -32, 0.5, -8)
    switchBG.BackgroundColor3 = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(45, 42, 55)
    Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)

    local switchStroke = Instance.new("UIStroke", switchBG)
    switchStroke.Color = Color3.fromRGB(60, 55, 75)
    switchStroke.Thickness = 1

    local circle = Instance.new("Frame", switchBG)
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    btnFrame.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        local targetColor = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(45, 42, 55)
        
        TweenService:Create(circle, tweenInfo, {Position = targetPos}):Play()
        TweenService:Create(switchBG, tweenInfo, {BackgroundColor3 = targetColor}):Play()
        
        callback(state)
    end)
end

-- Slider FOV Compacto
local SliderFrame = Instance.new("Frame", PVPFrame)
SliderFrame.Size = UDim2.new(0.9, 0, 0, 32)
SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 23, 32)
SliderFrame.LayoutOrder = 3
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

local SliderLabel = Instance.new("TextLabel", SliderFrame)
SliderLabel.Size = UDim2.new(0.5, 0, 1, 0)
SliderLabel.Position = UDim2.new(0.05, 0, 0, 0)
SliderLabel.Text = "Tamanho FOV"
SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.TextSize = 13
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.BackgroundTransparency = 1

local MinusBtn = Instance.new("TextButton", SliderFrame)
MinusBtn.Size = UDim2.new(0, 20, 0, 20)
MinusBtn.Position = UDim2.new(0.55, 0, 0.18, 0)
MinusBtn.BackgroundColor3 = Color3.fromRGB(50, 45, 65)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.TextSize = 12
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 4)

local FOVValText = Instance.new("TextLabel", SliderFrame)
FOVValText.Size = UDim2.new(0, 36, 1, 0)
FOVValText.Position = UDim2.new(0.65, 0, 0, 0)
FOVValText.Text = tostring(FOVRadius) .. "px"
FOVValText.TextColor3 = Color3.fromRGB(138, 43, 226)
FOVValText.Font = Enum.Font.GothamBold
FOVValText.TextSize = 11
FOVValText.BackgroundTransparency = 1

local PlusBtn = Instance.new("TextButton", SliderFrame)
PlusBtn.Size = UDim2.new(0, 20, 0, 20)
PlusBtn.Position = UDim2.new(0.85, 0, 0.18, 0)
PlusBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.TextSize = 12
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 4)

MinusBtn.MouseButton1Click:Connect(function()
    if FOVRadius > 30 then
        FOVRadius = FOVRadius - 15
        FOVValText.Text = tostring(FOVRadius) .. "px"
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    if FOVRadius < 400 then
        FOVRadius = FOVRadius + 15
        FOVValText.Text = tostring(FOVRadius) .. "px"
    end
end)

-- Opções na Aba PVP
CreateSwitch("Aimbot Cabeça", 1, false, function(s) AimBotEnabled = s end)
CreateSwitch("Mostrar Círculo FOV", 2, true, function(s) ShowFOV = s end)
CreateSwitch("ESP Box", 4, false, function(s) ESPBoxEnabled = s end)
CreateSwitch("ESP Esqueleto", 5, false, function(s) ESPSkeletonEnabled = s end)
CreateSwitch("ESP Line", 6, false, function(s) ESPLineEnabled = s end)

-- Criador de Botões para a Aba Redes
local function CreateSocialBtn(text, link, iconText)
    local btn = Instance.new("TextButton", RedesFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(25, 23, 32)
    btn.Text = iconText .. " " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(138, 43, 226)
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(link)
        elseif toclipboard then
            toclipboard(link)
        end

        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "NETRIX",
                Text = "Link do " .. text .. " copiado!",
                Duration = 3
            })
        end)
    end)
end

CreateSocialBtn("Discord", DiscordLink, "💬")
CreateSocialBtn("YouTube", YoutubeLink, "▶")

-- --- Lógica Aimbot, FOV e ESPs ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
FOVCircle.Radius = FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 255) -- Azul Ciano
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false

local Lines = {}
local Skeletons = {}
local Boxes = {}

local function GetLine(player)
    if not Lines[player] then
        local line = Drawing.new("Line")
        line.Color = Color3.fromRGB(0, 255, 255) -- Azul Ciano
        line.Thickness = 1.5
        line.Transparency = 1
        Lines[player] = line
    end
    return Lines[player]
end

local function GetSkeleton(player)
    if not Skeletons[player] then
        local skel = {}
        for i = 1, 10 do
            local l = Drawing.new("Line")
            l.Color = Color3.fromRGB(0, 255, 255) -- Azul Ciano
            l.Thickness = 1.5
            l.Transparency = 1
            table.insert(skel, l)
        end
        Skeletons[player] = skel
    end
    return Skeletons[player]
end

local function GetBox(player)
    if not Boxes[player] then
        local box = Drawing.new("Square")
        box.Color = Color3.fromRGB(0, 255, 255) -- Azul Ciano
        box.Thickness = 1.5
        box.Filled = false
        box.Transparency = 1
        Boxes[player] = box
    end
    return Boxes[player]
end

local function HideSkeleton(skel)
    if skel then
        for _, l in ipairs(skel) do
            l.Visible = false
        end
    end
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = ShowFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = FOVRadius
    
    -- Aimbot
    if AimBotEnabled then
        local TargetHead = nil
        local NearestDist = FOVRadius
        local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") then
                if p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - CenterScreen).Magnitude
                        if dist < NearestDist then
                            TargetHead = p.Character.Head
                            NearestDist = dist
                        end
                    end
                end
            end
        end
        
        if TargetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetHead.Position)
        end
    end
    
    -- ESPs
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char.HumanoidRootPart
                
                -- ESP Box
                local box = GetBox(p)
                if ESPBoxEnabled and hum.Health > 0 then
                    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local headPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                        local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 1.8

                        box.Size = Vector2.new(width, height)
                        box.Position = Vector2.new(hrpPos.X - width / 2, headPos.Y)
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                else
                    box.Visible = false
                end

                -- ESP Esqueleto
                local skel = GetSkeleton(p)
                if ESPSkeletonEnabled and hum.Health > 0 then
                    local joints = {
                        {"Head", "UpperTorso"},
                        {"UpperTorso", "LowerTorso"},
                        {"UpperTorso", "LeftUpperArm"},
                        {"LeftUpperArm", "LeftLowerArm"},
                        {"UpperTorso", "RightUpperArm"},
                        {"RightUpperArm", "RightLowerArm"},
                        {"LowerTorso", "LeftUpperLeg"},
                        {"LeftUpperLeg", "LeftLowerLeg"},
                        {"LowerTorso", "RightUpperLeg"},
                        {"RightUpperLeg", "RightLowerLeg"}
                    }
                    
                    -- Suporte R6 / R15
                    if not char:FindFirstChild("UpperTorso") then
                        joints = {
                            {"Head", "Torso"},
                            {"Torso", "Left Arm"},
                            {"Torso", "Right Arm"},
                            {"Torso", "Left Leg"},
                            {"Torso", "Right Leg"}
                        }
                    end

                    for idx, pair in ipairs(joints) do
                        local partA = char:FindFirstChild(pair[1])
                        local partB = char:FindFirstChild(pair[2])
                        local l = skel[idx]
                        if partA and partB and l then
                            local posA, visA = Camera:WorldToViewportPoint(partA.Position)
                            local posB, visB = Camera:WorldToViewportPoint(partB.Position)
                            if visA and visB then
                                l.From = Vector2.new(posA.X, posA.Y)
                                l.To = Vector2.new(posB.X, posB.Y)
                                l.Visible = true
                            else
                                l.Visible = false
                            end
                        elseif l then
                            l.Visible = false
                        end
                    end
                else
                    HideSkeleton(skel)
                end

                -- Line (Cima para Baixo)
                local line = GetLine(p)
                if ESPLineEnabled and hum.Health > 0 then
                    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            else
                if Boxes[p] then Boxes[p].Visible = false end
                if Lines[p] then Lines[p].Visible = false end
                if Skeletons[p] then HideSkeleton(Skeletons[p]) end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if Boxes[p] then
        Boxes[p]:Remove()
        Boxes[p] = nil
    end
    if Lines[p] then
        Lines[p]:Remove()
        Lines[p] = nil
    end
    if Skeletons[p] then
        for _, l in ipairs(Skeletons[p]) do
            l:Remove()
        end
        Skeletons[p] = nil
    end
end)

