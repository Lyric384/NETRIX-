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
local WalkSpeedValue = 16 -- Velocidade padrão do Roblox

local SpinbotEnabled = false
local EspContourEnabled = false
local ESPLineEnabled = false

local DiscordLink = "https://discord.gg/5TFHuucxgw"
local YoutubeLink = "https://www.youtube.com/@Netrixofc"

-- --- Interface Gráfica ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NetrixHubRoxo"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Painel Principal (Mais Largo: 280x230)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 230)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -115)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 15, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 1.5

-- 2. Botão Flutuante (48x48)
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
Title.Text = "Netrix Hub | Fluxo PVP"
Title.Size = UDim2.new(1, 0, 0, 26)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12

-- Barra de Navegação de Abas
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 260, 0, 26)
TabBar.Position = UDim2.new(0.035, 0, 0, 28)
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
PVPFrame.CanvasSize = UDim2.new(0, 0, 0, 240)
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
    btnFrame.Size = UDim2.new(0.92, 0, 0, 28)
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
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local switchBG = Instance.new("Frame", btnFrame)
    switchBG.Size = UDim2.new(0, 34, 0, 18)
    switchBG.Position = UDim2.new(0.95, -34, 0.5, -9)
    switchBG.BackgroundColor3 = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(45, 42, 55)
    Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)

    local switchStroke = Instance.new("UIStroke", switchBG)
    switchStroke.Color = Color3.fromRGB(60, 55, 75)
    switchStroke.Thickness = 1

    local circle = Instance.new("Frame", switchBG)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    btnFrame.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(45, 42, 55)
        
        TweenService:Create(circle, tweenInfo, {Position = targetPos}):Play()
        TweenService:Create(switchBG, tweenInfo, {BackgroundColor3 = targetColor}):Play()
        
        callback(state)
    end)
end

-- --- Criador de Ajustador (+ / -) ---
local function CreateAdjuster(name, order, minVal, maxVal, step, defaultVal, suffix, callback)
    local currentVal = defaultVal

    local frame = Instance.new("Frame", PVPFrame)
    frame.Size = UDim2.new(0.92, 0, 0, 28)
    frame.BackgroundColor3 = Color3.fromRGB(25, 23, 32)
    frame.LayoutOrder = order
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local minusBtn = Instance.new("TextButton", frame)
    minusBtn.Size = UDim2.new(0, 20, 0, 20)
    minusBtn.Position = UDim2.new(0.55, 0, 0.15, 0)
    minusBtn.BackgroundColor3 = Color3.fromRGB(50, 45, 65)
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 12
    Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4)

    local valText = Instance.new("TextLabel", frame)
    valText.Size = UDim2.new(0, 40, 1, 0)
    valText.Position = UDim2.new(0.64, 0, 0, 0)
    valText.Text = tostring(currentVal) .. suffix
    valText.TextColor3 = Color3.fromRGB(138, 43, 226)
    valText.Font = Enum.Font.GothamBold
    valText.TextSize = 10
    valText.BackgroundTransparency = 1

    local plusBtn = Instance.new("TextButton", frame)
    plusBtn.Size = UDim2.new(0, 20, 0, 20)
    plusBtn.Position = UDim2.new(0.85, 0, 0.15, 0)
    plusBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 12
    Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4)

    minusBtn.MouseButton1Click:Connect(function()
        if currentVal - step >= minVal then
            currentVal = currentVal - step
            valText.Text = tostring(currentVal) .. suffix
            callback(currentVal)
        end
    end)

    plusBtn.MouseButton1Click:Connect(function()
        if currentVal + step <= maxVal then
            currentVal = currentVal + step
            valText.Text = tostring(currentVal) .. suffix
            callback(currentVal)
        end
    end)
end

-- Opções na Aba PVP
CreateSwitch("Aimbot Cabeça", 1, false, function(s) AimBotEnabled = s end)
CreateSwitch("Mostrar Círculo FOV", 2, true, function(s) ShowFOV = s end)

-- Ajustes numéricos (FOV e Speed)
CreateAdjuster("Tamanho FOV", 3, 30, 400, 15, FOVRadius, "px", function(val)
    FOVRadius = val
end)

CreateAdjuster("Velocidade (Speed)", 4, 16, 200, 5, WalkSpeedValue, "", function(val)
    WalkSpeedValue = val
end)

CreateSwitch("Spinbot (Girar)", 5, false, function(s) SpinbotEnabled = s end)
CreateSwitch("ESP Contour", 6, false, function(s) EspContourEnabled = s end)
CreateSwitch("ESP Line", 7, false, function(s) ESPLineEnabled = s end)

-- Criador de Botões para a Aba Redes
local function CreateSocialBtn(text, link, iconText)
    local btn = Instance.new("TextButton", RedesFrame)
    btn.Size = UDim2.new(0.92, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(25, 23, 32)
    btn.Text = iconText .. " " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
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

-- --- Lógica Principal (Aimbot, FOV, Speed, Spinbot e ESPs) ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
FOVCircle.Radius = FOVRadius
FOVCircle.Color = Color3.fromRGB(138, 43, 226)
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false

local Lines = {}

local function GetLine(player)
    if not Lines[player] then
        local line = Drawing.new("Line")
        line.Color = Color3.fromRGB(138, 43, 226)
        line.Thickness = 1.5
        line.Transparency = 1
        Lines[player] = line
    end
    return Lines[player]
end

RunService.RenderStepped:Connect(function()
    -- Aplica a velocidade ajustada no personagem
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = WalkSpeedValue
    end

    FOVCircle.Visible = ShowFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = FOVRadius
    
    if SpinbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end

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
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char.HumanoidRootPart
                
                local highlight = char:FindFirstChild("NetrixContour")
                if EspContourEnabled and hum.Health > 0 then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "NetrixContour"
                        highlight.FillColor = Color3.fromRGB(138, 43, 226)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.Parent = char
                    end
                elseif highlight then
                    highlight:Destroy()
                end

                local line = GetLine(p)
                if ESPLineEnabled and hum.Health > 0 then
                    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            else
                if Lines[p] then Lines[p].Visible = false end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if Lines[p] then
        Lines[p]:Remove()
        Lines[p] = nil
    end
end)
