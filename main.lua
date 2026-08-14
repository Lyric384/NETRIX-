-- [[ RAYFIELD UI - FLUXO PVP EDITION | NETRIX ]]

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =========================================================
-- RAYFIELD
-- =========================================================

local Window = Rayfield:CreateWindow({
    Name = "NETRIX | Fluxo PVP Hub",
    LoadingTitle = "Carregando NETRIX...",
    LoadingSubtitle = "by NETRIX",

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
-- REMOVER "SHOW RAYFIELD"
-- =========================================================

local function RemoveShowRayfield()

    pcall(function()

        local function CheckObject(Object)

            -- Remove objetos chamados Prompt
            if Object.Name == "Prompt" then
                Object:Destroy()
                return
            end

            -- Remove elementos que contenham "Show Rayfield"
            if Object:IsA("TextLabel")
                or Object:IsA("TextButton")
                or Object:IsA("TextBox") then

                local Text = tostring(Object.Text)

                if string.find(
                    Text,
                    "Show Rayfield",
                    1,
                    true
                ) then

                    Object:Destroy()
                    return
                end
            end

            -- Alguns elementos podem possuir atributo relacionado
            if Object:GetAttribute("Text") == "Show Rayfield" then
                Object:Destroy()
                return
            end

        end

        -- CoreGui
        for _, Gui in ipairs(CoreGui:GetChildren()) do

            if Gui:IsA("ScreenGui") then

                for _, Object in ipairs(
                    Gui:GetDescendants()
                ) do

                    CheckObject(Object)

                end

            end
        end

        -- PlayerGui
        local PlayerGui =
            LocalPlayer:FindFirstChild("PlayerGui")

        if PlayerGui then

            for _, Object in ipairs(
                PlayerGui:GetDescendants()
            ) do

                CheckObject(Object)

            end

        end

    end)

end

-- Remove várias vezes durante o carregamento
task.spawn(function()

    for i = 1, 30 do

        RemoveShowRayfield()

        task.wait(0.1)

    end

end)

-- Continua removendo caso o Rayfield recrie
task.spawn(function()

    while task.wait(0.5) do

        RemoveShowRayfield()

    end

end)

-- =========================================================
-- FLUTUANTE NETRIX
-- =========================================================

local FloatingGui = Instance.new("ScreenGui")

FloatingGui.Name = "NETRIX_Floating"
FloatingGui.ResetOnSpawn = false
FloatingGui.IgnoreGuiInset = true
FloatingGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

pcall(function()
    FloatingGui.Parent = CoreGui
end)

if not FloatingGui.Parent then

    FloatingGui.Parent =
        LocalPlayer:WaitForChild("PlayerGui")

end

local FloatingButton =
    Instance.new("ImageButton")

FloatingButton.Name = "NETRIX"
FloatingButton.Parent = FloatingGui

-- Pequeno e quadrado
FloatingButton.Size =
    UDim2.fromOffset(58, 58)

FloatingButton.Position =
    UDim2.new(0, 20, 0.5, 0)

FloatingButton.BackgroundColor3 =
    Color3.fromRGB(12, 12, 12)

FloatingButton.BackgroundTransparency = 0
FloatingButton.BorderSizePixel = 0

-- Imagem NETRIX
FloatingButton.Image =
    "rbxthumb://type=Asset&id=109965584967630&w=420&h=420"

FloatingButton.ImageTransparency = 0
FloatingButton.ScaleType =
    Enum.ScaleType.Crop

-- Cantos arredondados
local FloatingCorner =
    Instance.new("UICorner")

FloatingCorner.CornerRadius =
    UDim.new(0, 10)

FloatingCorner.Parent =
    FloatingButton

-- Borda roxa
local FloatingStroke =
    Instance.new("UIStroke")

FloatingStroke.Thickness = 2
FloatingStroke.Color =
    Color3.fromRGB(145, 0, 255)

FloatingStroke.Parent =
    FloatingButton

-- =========================================================
-- ARRASTAR FLUTUANTE
-- =========================================================

local Dragging = false
local DragStart = nil
local StartPosition = nil
local Moved = false

FloatingButton.InputBegan:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.Touch

            or Input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            Dragging = true
            Moved = false

            DragStart =
                Input.Position

            StartPosition =
                FloatingButton.Position

            Input.Changed:Connect(
                function()

                    if Input.UserInputState ==
                        Enum.UserInputState.End then

                        Dragging = false

                    end

                end
            )

        end

    end
)

UserInputService.InputChanged:Connect(
    function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.Touch

            or Input.UserInputType ==
            Enum.UserInputType.MouseMovement then

            local Delta =
                Input.Position - DragStart

            if Delta.Magnitude > 5 then
                Moved = true
            end

            FloatingButton.Position =
                UDim2.new(
                    StartPosition.X.Scale,
                    StartPosition.X.Offset + Delta.X,

                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset + Delta.Y
                )

        end

    end
)

-- =========================================================
-- ABRIR / FECHAR NETRIX
-- =========================================================

FloatingButton.Activated:Connect(
    function()

        if Moved then
            Moved = false
            return
        end

        Rayfield:SetVisibility(
            not Rayfield:IsVisible()
        )

        -- Remove qualquer "Show Rayfield"
        task.defer(RemoveShowRayfield)

    end
)

-- =========================================================
-- VARIÁVEIS
-- =========================================================

local AimbotEnabled = false
local FOVRadius = 150
local FOVVisible = true

local GrabEnabled = false
local TargetPlayer = nil

local ESPEnabled = false

local ESPColor =
    Color3.fromRGB(255, 0, 50)

-- =========================================================
-- ESP
-- =========================================================

local function AddESP(player)

    if player == LocalPlayer then
        return
    end

    local Character =
        player.Character

    if not Character then
        return
    end

    if Character:FindFirstChild(
        "NetrixESP"
    ) then
        return
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "NetrixESP"

    Highlight.FillColor =
        ESPColor

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.Adornee =
        Character

    Highlight.Parent =
        Character

end

local function RemoveESP(player)

    if player.Character then

        local Highlight =
            player.Character:FindFirstChild(
                "NetrixESP"
            )

        if Highlight then
            Highlight:Destroy()
        end

    end

end

local function UpdateESP()

    for _, player in
        ipairs(Players:GetPlayers()) do

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

    player.CharacterAdded:Connect(
        function()

            task.wait(0.5)

            if ESPEnabled then
                AddESP(player)
            end

        end
    )

    if ESPEnabled then
        AddESP(player)
    end

end

for _, player in
    ipairs(Players:GetPlayers()) do

    SetupPlayerESP(player)

end

Players.PlayerAdded:Connect(
    function(player)
        SetupPlayerESP(player)
    end
)

Players.PlayerRemoving:Connect(
    function(player)
        RemoveESP(player)
    end
)

-- =========================================================
-- FOV
-- =========================================================

local FOVCircle = nil

if Drawing and Drawing.new then

    FOVCircle =
        Drawing.new("Circle")

    FOVCircle.Color =
        Color3.fromRGB(
            255,
            0,
            50
        )

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

    local Closest = nil
    local ShortestDistance =
        FOVRadius

    for _, Player in
        ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer
            and Player.Character
            and Player.Character:FindFirstChild("Head")
            and Player.Character:FindFirstChildOfClass(
                "Humanoid"
            ) then

            local Humanoid =
                Player.Character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if Humanoid
                and Humanoid.Health > 0 then

                local Head =
                    Player.Character.Head

                local ScreenPos, OnScreen =
                    Camera:WorldToViewportPoint(
                        Head.Position
                    )

                if OnScreen then

                    local Center =
                        Vector2.new(
                            Camera.ViewportSize.X / 2,
                            Camera.ViewportSize.Y / 2
                        )

                    local Distance =
                        (
                            Vector2.new(
                                ScreenPos.X,
                                ScreenPos.Y
                            ) - Center
                        ).Magnitude

                    if Distance <
                        ShortestDistance then

                        ShortestDistance =
                            Distance

                        Closest =
                            Player

                    end

                end

            end

        end

    end

    return Closest

end

-- =========================================================
-- RENDER LOOP
-- =========================================================

RunService.RenderStepped:Connect(
    function()

        if FOVCircle then

            FOVCircle.Position =
                Vector2.new(
                    Camera.ViewportSize.X / 2,
                    Camera.ViewportSize.Y / 2
                )

            FOVCircle.Radius =
                FOVRadius

            FOVCircle.Visible =
                FOVVisible
                and AimbotEnabled

        end

        -- AIMBOT
        if AimbotEnabled then

            local Target =
                GetClosestPlayerInFOV()

            if Target
                and Target.Character
                and Target.Character:FindFirstChild(
                    "Head"
                ) then

                Camera.CFrame =
                    CFrame.new(
                        Camera.CFrame.Position,
                        Target.Character.Head.Position
                    )

            end

        end

        -- GRAB
        if GrabEnabled then

            if not TargetPlayer
                or not TargetPlayer.Character
                or not TargetPlayer.Character:FindFirstChild(
                    "HumanoidRootPart"
                )
                or not TargetPlayer.Character:FindFirstChildOfClass(
                    "Humanoid"
                )
                or TargetPlayer.Character:FindFirstChildOfClass(
                    "Humanoid"
                ).Health <= 0 then

                TargetPlayer =
                    GetClosestPlayerInFOV()

            end

            if TargetPlayer
                and TargetPlayer.Character
                and TargetPlayer.Character:FindFirstChild(
                    "HumanoidRootPart"
                )
                and LocalPlayer.Character
                and LocalPlayer.Character:FindFirstChild(
                    "HumanoidRootPart"
                ) then

                LocalPlayer.Character.HumanoidRootPart.CFrame =
                    TargetPlayer.Character.HumanoidRootPart.CFrame
                    * CFrame.new(0, 0, -2)

            end

        end

    end
)

-- =========================================================
-- ABA COMBATE
-- =========================================================

local CombatTab =
    Window:CreateTab(
        "Combate",
        4483362458
    )

CombatTab:CreateToggle({

    Name =
        "Mira Automática na Cabeça",

    CurrentValue = false,

    Flag =
        "AimbotHead",

    Callback = function(Value)

        AimbotEnabled = Value

    end

})

CombatTab:CreateSlider({

    Name =
        "Tamanho do Círculo (FOV)",

    Range = {
        50,
        500
    },

    Increment = 10,

    Suffix = "px",

    CurrentValue = 150,

    Flag =
        "FOVSize",

    Callback = function(Value)

        FOVRadius = Value

    end

})

CombatTab:CreateToggle({

    Name =
        "Mostrar Círculo na Tela",

    CurrentValue = true,

    Flag =
        "DrawFOV",

    Callback = function(Value)

        FOVVisible = Value

    end

})

CombatTab:CreateToggle({

    Name =
        "ESP Players",

    CurrentValue = false,

    Flag =
        "ESPPlayers",

    Callback = function(Value)

        ESPEnabled = Value

        UpdateESP()

    end

})

CombatTab:CreateToggle({

    Name =
        "Agarrar Player (Grab & Hold)",

    CurrentValue = false,

    Flag =
        "GrabPlayer",

    Callback = function(Value)

        GrabEnabled = Value

        if not Value then
            TargetPlayer = nil
        end

    end

})

-- =========================================================
-- DISCORD
-- =========================================================

CombatTab:CreateButton({

    Name = "Join Discord",

    Callback = function()

        local DiscordLink =
            "https://discord.gg/5TFHuucxgw"

        if setclipboard then

            setclipboard(
                DiscordLink
            )

            Rayfield:Notify({

                Title = "NETRIX",

                Content =
                    "Link do Discord copiado!",

                Duration = 5,

                Image = 4483362458

            })

        else

            Rayfield:Notify({

                Title = "NETRIX",

                Content =
                    DiscordLink,

                Duration = 5,

                Image = 4483362458

            })

        end

    end

})

-- =========================================================
-- ABA MOVIMENTAÇÃO
-- =========================================================

local MovementTab =
    Window:CreateTab(
        "Movimentação",
        4483362458
    )

MovementTab:CreateSlider({

    Name =
        "Velocidade (WalkSpeed)",

    Range = {
        16,
        120
    },

    Increment = 2,

    CurrentValue = 16,

    Flag =
        "WalkSpeed",

    Callback = function(Value)

        if LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild(
                "Humanoid"
            ) then

            LocalPlayer.Character.Humanoid.WalkSpeed =
                Value

        end

    end

})

-- =========================================================
-- NOTIFICAÇÃO
-- =========================================================

Rayfield:Notify({

    Title = "NETRIX",

    Content =
        "Painel Fluxo PVP carregado com sucesso!",

    Duration = 5,

    Image = 4483362458

})

-- Última limpeza
task.defer(function()
    task.wait(1)
    RemoveShowRayfield()
end)
