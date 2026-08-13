-- [[ RAYFIELD UI - FLUXO PVP EDITION | NETRIX ]]

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "NETRIX | Fluxo PVP Hub",
    LoadingTitle = "Carregando NETRIX...",
    LoadingSubtitle = "by NETRIX",

    ConfigurationSaving = {
        Enabled = false,
    },

    Discord = {
        Enabled = false,
    },

    KeySystem = false
})

-- =========================================================
-- BOTÃO FLUTUANTE NETRIX
-- =========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "NetrixFloatingButton"
FloatingGui.ResetOnSpawn = false
FloatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    FloatingGui.Parent = game:GetService("CoreGui")
end)

if not FloatingGui.Parent then
    FloatingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "NetrixFloat"
FloatingButton.Parent = FloatingGui
FloatingButton.Size = UDim2.new(0, 85, 0, 85)
FloatingButton.Position = UDim2.new(1, -35, 1, -120)
FloatingButton.AnchorPoint = Vector2.new(1, 1)

FloatingButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FloatingButton.BackgroundTransparency = 0.1
FloatingButton.Image = "rbxassetid://109965584967630"
FloatingButton.ScaleType = Enum.ScaleType.Crop
FloatingButton.AutoButtonColor = true

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingButton

local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Thickness = 2
FloatingStroke.Color = Color3.fromRGB(150, 0, 255)
FloatingStroke.Transparency = 0.1
FloatingStroke.Parent = FloatingButton

-- =========================================================
-- ARRASTAR BOTÃO FLUTUANTE
-- =========================================================

local Dragging = false
local DragStart
local StartPosition
local WasDragged = false

local function UpdateFloatingButton(input)
    local Delta = input.Position - DragStart

    FloatingButton.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        WasDragged = false
        DragStart = input.Position
        StartPosition = FloatingButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local Delta = input.Position - DragStart

        if Delta.Magnitude > 5 then
            WasDragged = true
        end

        UpdateFloatingButton(input)
    end
end)

-- =========================================================
-- ABRIR / FECHAR PAINEL
-- =========================================================

local PanelVisible = true

FloatingButton.Activated:Connect(function()
    if WasDragged then
        WasDragged = false
        return
    end

    PanelVisible = not PanelVisible
    Rayfield:SetVisibility(PanelVisible)
end)

-- =========================================================
-- SERVIÇOS
-- =========================================================

local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- =========================================================
-- VARIÁVEIS
-- =========================================================

local AimbotEnabled = false
local FOVRadius = 150
local FOVVisible = true

local GrabEnabled = false
local TargetPlayer = nil

-- ESP
local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 0, 50)

-- =========================================================
-- ESP
-- =========================================================

local function AddESP(player)
    if player == LocalPlayer then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    if character:FindFirstChild("NetrixESP") then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "NetrixESP"
    highlight.FillColor = ESPColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = character
    highlight.Parent = character
end

local function RemoveESP(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("NetrixESP")

        if highlight then
            highlight:Destroy()
        end
    end
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if ESPEnabled then
                AddESP(player)
            else
                RemoveESP(player)
            end
        end
    end
end

local function SetupPlayerESP(player)
    if player == LocalPlayer then
        return
    end

    player.CharacterAdded:Connect(function()
        task.wait(0.5)

        if ESPEnabled then
            AddESP(player)
        end
    end)

    if ESPEnabled then
        AddESP(player)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    SetupPlayerESP(player)
end

Players.PlayerAdded:Connect(function(player)
    SetupPlayerESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- =========================================================
-- FOV
-- =========================================================

local FOVCircle

if Drawing and Drawing.new then
    FOVCircle = Drawing.new("Circle")

    FOVCircle.Color = Color3.fromRGB(255, 0, 50)
    FOVCircle.Thickness = 2
    FOVCircle.NumSides = 64
    FOVCircle.Radius = FOVRadius
    FOVCircle.Filled = false
    FOVCircle.Visible = false
end

-- =========================================================
-- ENCONTRAR JOGADOR NO FOV
-- =========================================================

local function GetClosestPlayerInFOV()
    local closest = nil
    local shortestDistance = FOVRadius

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer
            and player.Character
            and player.Character:FindFirstChild("Head")
            and player.Character:FindFirstChildOfClass("Humanoid") then

            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then

                local head = player.Character.Head

                local screenPos, onScreen =
                    Camera:WorldToViewportPoint(head.Position)

                if onScreen then

                    local mousePos = Vector2.new(
                        Camera.ViewportSize.X / 2,
                        Camera.ViewportSize.Y / 2
                    )

                    local distance =
                        (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                    if distance < shortestDistance then
                        shortestDistance = distance
                        closest = player
                    end
                end
            end
        end
    end

    return closest
end

-- =========================================================
-- RENDER LOOP
-- =========================================================

RunService.RenderStepped:Connect(function()

    if FOVCircle then
        FOVCircle.Position = Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )

        FOVCircle.Radius = FOVRadius
        FOVCircle.Visible = FOVVisible and AimbotEnabled
    end

    if AimbotEnabled then

        local target = GetClosestPlayerInFOV()

        if target
            and target.Character
            and target.Character:FindFirstChild("Head") then

            Camera.CFrame = CFrame.new(
                Camera.CFrame.Position,
                target.Character.Head.Position
            )
        end
    end

    if GrabEnabled then

        if not TargetPlayer
            or not TargetPlayer.Character
            or not TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            or not TargetPlayer.Character:FindFirstChildOfClass("Humanoid")
            or TargetPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then

            TargetPlayer = GetClosestPlayerInFOV()
        end

        if TargetPlayer
            and TargetPlayer.Character
            and TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            and LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

            LocalPlayer.Character.HumanoidRootPart.CFrame =
                TargetPlayer.Character.HumanoidRootPart.CFrame *
                CFrame.new(0, 0, -2)
        end
    end
end)

-- =========================================================
-- ABA COMBATE
-- =========================================================

local CombatTab = Window:CreateTab("Combate", 4483362458)

local AimbotToggle = CombatTab:CreateToggle({
    Name = "Mira Automática na Cabeça",
    CurrentValue = false,
    Flag = "AimbotHead",

    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

local FOVSlider = CombatTab:CreateSlider({
    Name = "Tamanho do Círculo (FOV)",
    Range = {50, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOVSize",

    Callback = function(Value)
        FOVRadius = Value
    end,
})

local FOVToggle = CombatTab:CreateToggle({
    Name = "Mostrar Círculo na Tela",
    CurrentValue = true,
    Flag = "DrawFOV",

    Callback = function(Value)
        FOVVisible = Value
    end,
})

local ESPToggle = CombatTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Flag = "ESPPlayers",

    Callback = function(Value)
        ESPEnabled = Value
        UpdateESP()
    end,
})

local GrabToggle = CombatTab:CreateToggle({
    Name = "Agarrar Player (Grab & Hold)",
    CurrentValue = false,
    Flag = "GrabPlayer",

    Callback = function(Value)
        GrabEnabled = Value

        if not Value then
            TargetPlayer = nil
        end
    end,
})

-- =========================================================
-- JOIN DISCORD
-- =========================================================

local DiscordButton = CombatTab:CreateButton({
    Name = "Join Discord",

    Callback = function()

        local DiscordLink = "https://discord.gg/5TFHuucxgw"

        if setclipboard then
            setclipboard(DiscordLink)

            Rayfield:Notify({
                Title = "NETRIX",
                Content = "Link do Discord copiado!",
                Duration = 5,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "NETRIX",
                Content = DiscordLink,
                Duration = 5,
                Image = 4483362458,
            })
        end
    end,
})

-- =========================================================
-- ABA MOVIMENTAÇÃO
-- =========================================================

local MovementTab = Window:CreateTab("Movimentação", 4483362458)

local SpeedSlider = MovementTab:CreateSlider({
    Name = "Velocidade (WalkSpeed)",
    Range = {16, 120},
    Increment = 2,
    CurrentValue = 16,
    Flag = "WalkSpeed",

    Callback = function(Value)

        if LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("Humanoid") then

            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- =========================================================
-- NOTIFICAÇÃO
-- =========================================================

Rayfield:Notify({
    Title = "NETRIX",
    Content = "Painel Fluxo PVP carregado com sucesso!",
    Duration = 5,
    Image = 4483362458,
})
