-- Nive Hub Evade | Легендарный космический скрипт
-- Метка: nive
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- ==================== НАСТРОЙКИ ====================
local Settings = {
    Speed = 16,
    InfJump = false,
    Invisible = false,
    GodMode = false,
    FlingPlayer = false,
    FlingAll = false,
    SelectedPlayer = nil,
    AutoBunnyhop = false,
    Slide = false,
    Fly = false,
    AutoRevive = false,
    AutoWin = false,
    AutoCollectCoins = false,
    NiveUnlocked = false,   -- разблокируется кодом 0908
    Theme = "Cosmic"        -- Cosmic, Blood, Ice
}

-- ==================== GUI ====================
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NiveHub"

-- Главный фрейм (горизонтальный, большой)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 520, 0, 360)
main.Position = UDim2.new(0.5, -260, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(160, 80, 255)
main.Active = true
main.Draggable = true
main.ClipsDescendants = true

-- Заголовок
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
titleBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Nive Hub Evade"
title.TextColor3 = Color3.new(0.9, 0.7, 1)
title.Font = Enum.Font.SciFi
title.TextSize = 16
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка сворачивания (-)
local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
minimizeBtn.BorderSizePixel = 1
minimizeBtn.BorderColor3 = Color3.fromRGB(120, 100, 180)

-- Кнопка закрытия (X)
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = Color3.fromRGB(120, 100, 180)

-- Космическая картинка (слева)
local image = Instance.new("ImageLabel", main)
image.Size = UDim2.new(0, 120, 0, 160)
image.Position = UDim2.new(0, 10, 0, 40)
image.BackgroundTransparency = 1
image.Image = "https://i.imgur.com/8kMqW9X.png"   -- космическая картинка

-- Вкладки
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(0, 140, 1, -40)
tabFrame.Position = UDim2.new(0, 5, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
tabFrame.BorderSizePixel = 0

local tabButtons = {}
local tabContents = {}
local tabNames = {"Player", "Combat", "Farm", "Nive", "Settings"}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 10 + (i-1)*35)
    btn.Text = name
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(100, 50, 200) or Color3.fromRGB(50, 40, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(120, 100, 180)
    tabButtons[i] = btn

    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1, -150, 1, -40)
    content.Position = UDim2.new(0, 150, 0, 40)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 4
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = (i == 1)
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 6)
    tabContents[i] = content

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(50, 40, 80) end
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        for _, c in ipairs(tabContents) do c.Visible = false end
        content.Visible = true
    end)
end

-- Сворачивание/разворачивание
local minimizedBar = Instance.new("Frame", gui)
minimizedBar.Size = UDim2.new(0, 200, 0, 30)
minimizedBar.Position = UDim2.new(0.5, -100, 0, 0)
minimizedBar.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
minimizedBar.BorderSizePixel = 1
minimizedBar.BorderColor3 = Color3.fromRGB(160, 80, 255)
minimizedBar.Visible = false
minimizedBar.Active = true
minimizedBar.Draggable = true

local minimizedTitle = Instance.new("TextLabel", minimizedBar)
minimizedTitle.Size = UDim2.new(1, 0, 1, 0)
minimizedTitle.Text = "Nive Hub Evade"
minimizedTitle.TextColor3 = Color3.new(0.9, 0.7, 1)
minimizedTitle.Font = Enum.Font.SciFi
minimizedTitle.TextSize = 14
minimizedTitle.BackgroundTransparency = 1

minimizedBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        minimizedBar.Visible = false
        main.Visible = true
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    minimizedBar.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    -- Отключить все функции (обнулим Settings, но они локальны, просто прекратим циклы)
    for k, v in pairs(Settings) do
        if type(v) == "boolean" then Settings[k] = false end
    end
end)

-- ==================== ФУНКЦИИ ДОБАВЛЕНИЯ ЭЛЕМЕНТОВ ====================
local function addToggle(content, text, key)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -4, 0, 30)
    btn.Text = "  "..text..": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 60, 120)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "  "..text..": "..(Settings[key] and "ON" or "OFF")
    end)
    content.CanvasSize += UDim2.new(0,0,0,36)
    return btn
end

local function addSlider(content, text, key, min, max)
    local label = Instance.new("TextLabel", content)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text..": "..Settings[key]
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 13
    content.CanvasSize += UDim2.new(0,0,0,26)

    local input = Instance.new("TextBox", content)
    input.Size = UDim2.new(1, -4, 0, 28)
    input.Text = tostring(Settings[key])
    input.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.SourceSans
    input.BorderSizePixel = 1
    input.BorderColor3 = Color3.fromRGB(80, 60, 120)
    input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        if num then
            num = math.clamp(num, min, max)
            Settings[key] = num
            label.Text = text..": "..num
            if key == "Speed" then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = num end
            end
        end
    end)
    content.CanvasSize += UDim2.new(0,0,0,36)
end

-- ================== ЗАПОЛНЕНИЕ ВКЛАДОК ==================
-- Player
addSlider(tabContents[1], "Speed", "Speed", 1, 500)
addToggle(tabContents[1], "Inf Jump", "InfJump")
addToggle(tabContents[1], "Invisible", "Invisible")
addToggle(tabContents[1], "God Mode", "GodMode")

-- Combat
addToggle(tabContents[2], "Fling Player", "FlingPlayer")
-- Список игроков для выбора
local playerList = Instance.new("ScrollingFrame", tabContents[2])
playerList.Size = UDim2.new(1, -4, 0, 100)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.BackgroundTransparency = 1
local playerListLayout = Instance.new("UIListLayout", playerList)
playerListLayout.Padding = UDim.new(0, 2)
tabContents[2].CanvasSize += UDim2.new(0,0,0,100)

local function updatePlayerList()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, 0, 0, 24)
            btn.Text = player.Name
            btn.BackgroundColor3 = Settings.SelectedPlayer == player and Color3.fromRGB(100,50,200) or Color3.fromRGB(50,50,70)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 12
            btn.BorderSizePixel = 1
            btn.MouseButton1Click:Connect(function()
                Settings.SelectedPlayer = player
                updatePlayerList()
            end)
        end
    end
end
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

addToggle(tabContents[2], "Fling All", "FlingAll")
addToggle(tabContents[2], "Auto Bunnyhop", "AutoBunnyhop")
addToggle(tabContents[2], "Slide", "Slide")
addToggle(tabContents[2], "Fly", "Fly")

-- Farm
addToggle(tabContents[3], "Auto Revive", "AutoRevive")
addToggle(tabContents[3], "Auto Win", "AutoWin")
addToggle(tabContents[3], "Auto Collect Coins", "AutoCollectCoins")

-- Nive
local codeInput = Instance.new("TextBox", tabContents[4])
codeInput.Size = UDim2.new(1, -4, 0, 30)
codeInput.PlaceholderText = "Enter code..."
codeInput.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
codeInput.TextColor3 = Color3.new(1,1,1)
codeInput.Font = Enum.Font.SourceSans
codeInput.BorderSizePixel = 1
codeInput.BorderColor3 = Color3.fromRGB(80, 60, 120)
tabContents[4].CanvasSize += UDim2.new(0,0,0,36)

local unlockBtn = Instance.new("TextButton", tabContents[4])
unlockBtn.Size = UDim2.new(1, -4, 0, 30)
unlockBtn.Text = "Unlock"
unlockBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
unlockBtn.TextColor3 = Color3.new(1,1,1)
unlockBtn.Font = Enum.Font.SourceSansBold
unlockBtn.BorderSizePixel = 1
unlockBtn.BorderColor3 = Color3.fromRGB(80, 60, 120)
tabContents[4].CanvasSize += UDim2.new(0,0,0,36)

unlockBtn.MouseButton1Click:Connect(function()
    if codeInput.Text == "0908" then
        Settings.NiveUnlocked = true
        unlockBtn.Text = "Unlocked!"
        -- Показываем секретные функции (можно добавить ниже)
    else
        unlockBtn.Text = "Wrong code!"
    end
end)

-- Settings
addToggle(tabContents[5], "Save Config", "SaveConfig")   -- заглушка, можно сделать через _G
-- Выбор темы
local themeLabel = Instance.new("TextLabel", tabContents[5])
themeLabel.Size = UDim2.new(1, 0, 0, 20)
themeLabel.Text = "Theme: "..Settings.Theme
themeLabel.TextColor3 = Color3.new(1,1,1)
themeLabel.BackgroundTransparency = 1
themeLabel.Font = Enum.Font.SourceSans
themeLabel.TextSize = 13
tabContents[5].CanvasSize += UDim2.new(0,0,0,26)

local themeBtn = Instance.new("TextButton", tabContents[5])
themeBtn.Size = UDim2.new(1, -4, 0, 30)
themeBtn.Text = "Change Theme"
themeBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
themeBtn.TextColor3 = Color3.new(1,1,1)
themeBtn.Font = Enum.Font.SourceSans
themeBtn.BorderSizePixel = 1
themeBtn.BorderColor3 = Color3.fromRGB(80, 60, 120)
tabContents[5].CanvasSize += UDim2.new(0,0,0,36)

local themes = {"Cosmic", "Blood", "Ice"}
local currentThemeIndex = 1
themeBtn.MouseButton1Click:Connect(function()
    currentThemeIndex = currentThemeIndex % #themes + 1
    Settings.Theme = themes[currentThemeIndex]
    themeLabel.Text = "Theme: "..Settings.Theme
    -- Применяем тему (меняем цвета меню)
    local themeColors = {
        Cosmic = {main = Color3.fromRGB(20, 15, 35), border = Color3.fromRGB(160, 80, 255)},
        Blood  = {main = Color3.fromRGB(35, 15, 15), border = Color3.fromRGB(200, 50, 50)},
        Ice    = {main = Color3.fromRGB(15, 25, 35), border = Color3.fromRGB(50, 180, 200)}
    }
    local colors = themeColors[Settings.Theme]
    main.BackgroundColor3 = colors.main
    main.BorderColor3 = colors.border
    titleBar.BackgroundColor3 = colors.main:Lerp(Color3.new(0,0,0), 0.3)
end)

-- ==================== ОСНОВНЫЕ ФУНКЦИИ ====================
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getRoot()
    return getChar() and getChar():FindFirstChild("HumanoidRootPart")
end
local function getHum()
    return getChar() and getChar():FindFirstChild("Humanoid")
end

-- Speed уже применяется через Heartbeat

-- Inf Jump
local function infJump()
    if not Settings.InfJump then return end
    local hum = getHum()
    if hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        hum.Jump = true
    end
end

-- Invisible
local function invisible()
    local char = getChar()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = Settings.Invisible and 0.7 or 0
        end
    end
end

-- God Mode
local function godMode()
    if not Settings.GodMode then return end
    local char = getChar()
    local hum = getHum()
    if char and hum then
        hum.Health = hum.MaxHealth
        hum.MaxHealth = 1e9
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end

-- Fling Player (выбранного)
local function flingPlayer()
    if not Settings.FlingPlayer or not Settings.SelectedPlayer then return end
    local target = Settings.SelectedPlayer
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local root = target.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity", root)
        bv.Velocity = Vector3.new(0, 5000, 0)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        game.Debris:AddItem(bv, 0.5)
    end
end

-- Fling All
local function flingAll()
    if not Settings.FlingAll then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity", root)
            bv.Velocity = Vector3.new(0, 5000, 0)
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            game.Debris:AddItem(bv, 0.5)
        end
    end
end

-- Auto Bunnyhop
local function autoBunnyhop()
    if not Settings.AutoBunnyhop then return end
    local hum = getHum()
    if hum and hum.MoveDirection.Magnitude > 0 and hum:GetState() == Enum.HumanoidStateType.Running then
        hum.Jump = true
    end
end

-- Slide (бесконечный слайд без потери скорости)
local function slide()
    if not Settings.Slide then return end
    local hum = getHum()
    if hum then
        hum.Friction = 0     -- отключаем трение, скорость не падает
        -- Если нужно, можно ещё установить WalkSpeed очень высоким
    end
end

-- Fly
local function fly()
    if not Settings.Fly then return end
    local root = getRoot()
    local hum = getHum()
    if not root or not hum then return end
    hum.PlatformStand = true
    local bf = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root)
    bf.Name = "FlyVel"
    bf.MaxForce = Vector3.new(1e5,1e5,1e5)
    local dir = Vector3.new()
    local cam = Workspace.CurrentCamera
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    bf.Velocity = dir * 50
end

-- Auto Revive (мгновенное возрождение при смерти)
local function autoRevive()
    if not Settings.AutoRevive then return end
    local char = getChar()
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then
        LocalPlayer:LoadCharacter()
    end
end

-- Auto Win (телепорт в воздух далеко)
local function autoWin()
    if not Settings.AutoWin then return end
    local root = getRoot()
    if root then
        root.CFrame = CFrame.new(0, 500, 0)   -- высоко в воздух
    end
end

-- Auto Collect Coins (летние монетки)
local function autoCollectCoins()
    if not Settings.AutoCollectCoins then return end
    local root = getRoot()
    if not root then return end
    local nearest, ndist = nil, math.huge
    -- Ищем монетки (предположим, они называются "SummerCoin" или "Coin")
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj.Name == "SummerCoin" or obj.Name == "Coin") and obj:IsA("BasePart") and obj.Transparency < 0.9 then
            local dist = (root.Position - obj.Position).Magnitude
            if dist < ndist then ndist = dist; nearest = obj end
        end
    end
    if nearest then
        root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 2, 0))
        task.wait(0.2)
        fireclickdetector(nearest)  -- собираем
    end
end

-- Секретные функции Nive (после разблокировки)
local function niveSecretFunctions()
    if not Settings.NiveUnlocked then return end
    -- Здесь можно добавить авто-выполнение ежедневных квестов и т.д.
    -- Для примера просто авто-фарм монет (уже есть), но можно расширить.
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================
RunService.Heartbeat:Connect(function()
    if not gui.Parent then return end   -- если GUI уничтожен, прекращаем
    pcall(infJump)
    pcall(invisible)
    pcall(godMode)
    pcall(autoBunnyhop)
    pcall(slide)
    pcall(fly)
    pcall(autoRevive)
    pcall(autoCollectCoins)
    pcall(niveSecretFunctions)

    local hum = getHum()
    if hum then
        hum.WalkSpeed = Settings.Speed
        if not Settings.Slide then hum.Friction = 1 end   -- восстанавливаем трение, если слайд выключен
    end
    -- Применяем Fling Player и Fling All по требованию (они срабатывают мгновенно, можно не в цикле)
    -- Но они будут срабатывать один раз при включении, можно сделать через флаги.
end)

-- Отдельная обработка Fling, чтобы не спамить
local lastFlingPlayer = false
local lastFlingAll = false
RunService.Heartbeat:Connect(function()
    if Settings.FlingPlayer and not lastFlingPlayer then
        flingPlayer()
        lastFlingPlayer = true
    elseif not Settings.FlingPlayer then
        lastFlingPlayer = false
    end
    if Settings.FlingAll and not lastFlingAll then
        flingAll()
        lastFlingAll = true
    elseif not Settings.FlingAll then
        lastFlingAll = false
    end
end)

-- Обработка Auto Win (тоже один раз при включении)
local lastAutoWin = false
RunService.Heartbeat:Connect(function()
    if Settings.AutoWin and not lastAutoWin then
        autoWin()
        lastAutoWin = true
    elseif not Settings.AutoWin then
        lastAutoWin = false
    end
end)

-- Сброс при возрождении
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Settings.GodMode then godMode() end
    if Settings.Invisible then invisible() end
end)

print("Nive Hub Evade loaded! Press Minimize or Close buttons.")
