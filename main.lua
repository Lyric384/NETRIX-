-- [[ RAYFIELD UI - FLUXO PVP EDITION | NETRIX ]]

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "NETRIX | Fluxo PVP Hub",
    LoadingTitle = "Carregando NETRIX...",
    LoadingSubtitle = "by NETRIX",

    ShowText = "",
    DisableRayfieldPrompts = true,

    ConfigurationSaving = {
        Enabled = false,
    },

    Discord = {
        Enabled = false,
    },

    KeySystem = false
})

-- =========================================================
-- SERVIÇOS
-- =========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =========================================================
-- FLUTUANTE NETRIX
-- =========================================================

local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "NETRIX_Floating"
FloatingGui.ResetOnSpawn = false
FloatingGui.IgnoreGuiInset = true
FloatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    FloatingGui.Parent = game:GetService("CoreGui")
end)

if not FloatingGui.Parent then
    FloatingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "NETRIX"
FloatingButton.Parent = FloatingGui

-- Tamanho pequeno e quadrado
FloatingButton.Size = UDim2.fromOffset(58, 58)

-- Posição inicial
FloatingButton.Position = UDim2.new(0, 20, 0.5, 0)

-- Visual
FloatingButton.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
FloatingButton.BackgroundTransparency = 0
FloatingButton.BorderSizePixel = 0

-- Imagem
FloatingButton.Image = "rbxthumb://type=Asset&id=109965584967630&w=420&h=420"
FloatingButton.ScaleType = Enum.ScaleType.Crop

-- Cantos levemente arredondados
local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 10)
FloatingCorner.Parent = FloatingButton

-- Borda NETRIX
local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Thickness = 2
FloatingStroke.Color = Color3.fromRGB(145, 0, 255)
FloatingStroke.Transparency = 0
FloatingStroke.Parent = FloatingButton

-- =========================================================
-- ARRASTAR FLUTUANTE
-- =========================================================

local Dragging = false
local DragStart = nil
local StartPosition = nil
local Moved = false

FloatingButton.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.Touch
        or Input.UserInputType == Enum.UserInputType.MouseButton1 then

        Dragging = true
        Moved = false

        DragStart = Input.Position
        StartPosition = FloatingButton.Position

        Input.Changed:Connect(function()

            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end

        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.Touch
        or Input.UserInputType == Enum.UserInputType.MouseMovement then

        local Delta = Input.Position - DragStart

        if Delta.Magnitude > 5 then
            Moved = true
        end

        FloatingButton.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

-- =========================================================
-- ABRIR / FECHAR PAINEL
-- =========================================================

FloatingButton.Activated:Connect(function()

    if Moved then
        Moved = false
        return
    end

    Rayfield:SetVisibility(not Rayfield:IsVisible())

end)

-- =========================================================
-- VARIÁVEIS
-- =========================================================

local AimbotEnabled = false
local FOVRadius = 150
local FOVVisible = true

local GrabEnabled = false
local TargetPlayer = nil

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

        local highlight =
            player.Character:FindFirstChild("NetrixESP")

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

local FOVCircle = nil

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
-- ENCONTRAR PLAYER NO FOV
-- =========================================================

local function GetClosestPlayerInFOV()

    local closest = nil
    local shortestDistance = FOVRadius

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer
            and player.Character
            and player.Character:FindFirstChild("Head")
            and player.Character:FindFirstChildOfClass("Humanoid") then

            local humanoid =
                player.Character:FindFirstChildOfClass("Humanoid")

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
                        (
                            Vector2.new(
                                screenPos.X,
                                screenPos.Y
                            ) - mousePos
                        ).Magnitude

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

        FOVCircle.Visible =
            FOVVisible and AimbotEnabled
    end

    -- AIMBOT
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

    -- GRAB
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

local CombatTab =
    Window:CreateTab("Combate", 4483362458)

-- AIMBOT

local AimbotToggle =
    CombatTab:CreateToggle({

        Name = "Mira Automática na Cabeça",

        CurrentValue = false,

        Flag = "AimbotHead",

        Callback = function(Value)

            AimbotEnabled = Value

        end,
    })

-- FOV

local FOVSlider =
    CombatTab:CreateSlider({

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

-- MOSTRAR FOV

local FOVToggle =
    CombatTab:CreateToggle({

        Name = "Mostrar Círculo na Tela",

        CurrentValue = true,

        Flag = "DrawFOV",

        Callback = function(Value)

            FOVVisible = Value

        end,
    })

-- ESP

local ESPToggle =
    CombatTab:CreateToggle({

        Name = "ESP Players",

        CurrentValue = false,

        Flag = "ESPPlayers",

        Callback = function(Value)

            ESPEnabled = Value

            UpdateESP()

        end,
    })

-- GRAB

local GrabToggle =
    CombatTab:CreateToggle({

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
-- DISCORD
-- =========================================================

local DiscordButton =
    CombatTab:CreateButton({

        Name = "Join Discord",

        Callback = function()

            local DiscordLink =
                "https://discord.gg/5TFHuucxgw"

            if setclipboard then

                setclipboard(DiscordLink)

                Rayfield:Notify({

                    Title = "NETRIX",

                    Content =
                        "Link do Discord copiado!",

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

local MovementTab =
    Window:CreateTab(
        "Movimentação",
        4483362458
    )

local SpeedSlider =
    MovementTab:CreateSlider({

        Name = "Velocidade (WalkSpeed)",

        Range = {16, 120},

        Increment = 2,

        CurrentValue = 16,

        Flag = "WalkSpeed",

        Callback = function(Value)

            if LocalPlayer.Character
                and LocalPlayer.Character:FindFirstChild("Humanoid") then

                LocalPlayer.Character.Humanoid.WalkSpeed =
                    Value

            end
        end,
    })

-- =========================================================
-- NOTIFICAÇÃO
-- =========================================================

Rayfield:Notify({

    Title = "NETRIX",

    Content =
        "Painel Fluxo PVP carregado com sucesso!",

    Duration = 5,

    Image = 4483362458,

})
