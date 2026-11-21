-- ============================================================
-- NOHCHO⁹⁵ HUB — Muscle Legends (v5.0)
-- Stats Predictor | Auto Farm | Auto Rebirth | Auto Sell | TP Boss
-- Ключ: Ц1онтро
-- ============================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local CORRECT_KEY = "Ц1онтро"
local IS_RECONNECTING = false

-- УМНЫЙ ПОИСК REMOTE
local function GetRemote(partialName)
    local RS = game:GetService("ReplicatedStorage")
    local custom = RS:FindFirstChild("rEvents") or RS:FindFirstChild("Remotes") or RS:FindFirstChild("Events")
    if custom then
        for _, obj in pairs(custom:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and string.find(string.lower(obj.Name), string.lower(partialName)) then
                return obj
            end
        end
    end
    for _, obj in pairs(RS:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and string.find(string.lower(obj.Name), string.lower(partialName)) then
            return obj
        end
    end
    return nil
end

-- ФОРМАТИРОВАНИЕ ЧИСЕЛ (1.5M, 2B и т.д.)
local function FormatNumber(n)
    if not n then return "0" end
    if n >= 1e12 then return string.format("%.2fT", n / 1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n / 1e3)
    else return tostring(math.floor(n)) end
end

-- УВЕДОМЛЕНИЯ
local function Notify(text)
    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 260, 0, 40)
    lbl.Position = UDim2.new(0.5, -130, 0, 20)
    lbl.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sg
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", lbl).Color = Color3.fromRGB(100, 0, 150)

    task.delay(3, function()
        pcall(function()
            lbl:TweenPosition(UDim2.new(0.5, -130, 0, -50), "Out", "Quad", 0.3)
            task.wait(0.4)
            sg:Destroy()
        end)
    end)
end

-- KEY SYSTEM
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "NOHCHO95_Key"
keyGui.ResetOnSpawn = false
pcall(function() keyGui.Parent = CoreGui end)
if not keyGui.Parent then keyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local keyBg = Instance.new("Frame")
keyBg.Size = UDim2.new(0, 300, 0, 180)
keyBg.Position = UDim2.new(0.5, -150, 0.5, -90)
keyBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
keyBg.BorderSizePixel = 0
keyBg.Active = true
keyBg.Draggable = true
keyBg.Parent = keyGui
Instance.new("UICorner", keyBg).CornerRadius = UDim.new(0, 10)
local keyStroke = Instance.new("UIStroke", keyBg)
keyStroke.Color = Color3.fromRGB(100, 0, 150)
keyStroke.Thickness = 2

local keyHeader = Instance.new("TextLabel")
keyHeader.Size = UDim2.new(1, 0, 0, 40)
keyHeader.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
keyHeader.Text = "NOHCHO⁹⁵ | KEY SYSTEM"
keyHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
keyHeader.Font = Enum.Font.GothamBold
keyHeader.TextSize = 16
keyHeader.Parent = keyBg
Instance.new("UICorner", keyHeader).CornerRadius = UDim.new(0, 10)

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 40)
keyInput.Position = UDim2.new(0, 15, 0, 55)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
keyInput.PlaceholderText = "Введите ключ..."
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 14
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyBg
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 6)

local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1, -30, 0, 20)
keyStatus.Position = UDim2.new(0, 15, 0, 100)
keyStatus.BackgroundTransparency = 1
keyStatus.Text = ""
keyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
keyStatus.Font = Enum.Font.Gotham
keyStatus.TextSize = 12
keyStatus.Parent = keyBg

local keySubmit = Instance.new("TextButton")
keySubmit.Size = UDim2.new(1, -30, 0, 40)
keySubmit.Position = UDim2.new(0, 15, 0, 125)
keySubmit.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
keySubmit.Text = "Авторизоваться"
keySubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmit.Font = Enum.Font.GothamBold
keySubmit.TextSize = 14
keySubmit.Parent = keyBg
Instance.new("UICorner", keySubmit).CornerRadius = UDim.new(0, 6)

-- ============================================================
-- ОСНОВНОЙ ХАБ
-- ============================================================
local function LoadHub()
    if IS_RECONNECTING then
        IS_RECONNECTING = false
        Notify("Auto Reconnect: скрипт перезапущен")
    end

    -- Создание GUI (как в прошлой версии)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NOHCHO95_Hub"
    screenGui.ResetOnSpawn = false
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Кнопка возврата (свернутое состояние)
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 45, 0, 45)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -22)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    toggleBtn.Image = "rbxassetid://6031280882"
    toggleBtn.ImageColor3 = Color3.fromRGB(150, 0, 255)
    toggleBtn.Visible = false
    toggleBtn.Parent = screenGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", toggleBtn).Color = Color3.fromRGB(100, 0, 150)

    -- Главное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 400) -- Чуть выше, чтобы влезли статы
    mainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(100, 0, 150)

    -- Шапка
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    titleBar.Parent = mainFrame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 40, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NOHCHO⁹⁵"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 24, 0, 24)
    logo.Position = UDim2.new(0, 10, 0, 8)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://6031280882"
    logo.ImageColor3 = Color3.fromRGB(150, 0, 255)
    logo.Parent = titleBar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 25, 0, 25)
    minBtn.Position = UDim2.new(1, -60, 0, 7)
    minBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = titleBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 7)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    minBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false; toggleBtn.Visible = true end)
    toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = true; toggleBtn.Visible = false end)
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- ==========================================
    -- СТАТИСТИКА И ПРОГНОЗ (Stats Panel)
    -- ==========================================
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, -10, 0, 75)
    statsFrame.Position = UDim2.new(0, 5, 0, 45)
    statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    statsFrame.Parent = mainFrame
    Instance.new("UICorner", statsFrame).CornerRadius = UDim.new(0, 6)

    local statsText = Instance.new("TextLabel")
    statsText.Size = UDim2.new(1, -10, 1, -10)
    statsText.Position = UDim2.new(0, 5, 0, 5)
    statsText.BackgroundTransparency = 1
    statsText.Text = "Загрузка статов..."
    statsText.TextColor3 = Color3.fromRGB(200, 200, 200)
    statsText.Font = Enum.Font.Code
    statsText.TextSize = 12
    statsText.TextXAlignment = Enum.TextXAlignment.Left
    statsText.TextYAlignment = Enum.TextYAlignment.Top
    statsText.Parent = statsFrame

    -- Логика подсчета статов
    local lastStrength, lastRebirths, lastTime = 0, 0, tick()
    task.spawn(function()
        while screenGui.Parent do
            local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Stats")
            if stats then
                local strengthObj = stats:FindFirstChild("Strength") or stats:FindFirstChild("Power")
                local rebirthObj = stats:FindFirstChild("Rebirths") or stats:FindFirstChild("Rebirth")
                
                local currentStr = strengthObj and strengthObj.Value or 0
                local currentReb = rebirthObj and rebirthObj.Value or 0
                
                local timePassed = tick() - lastTime
                if timePassed >= 5 then -- Обновляем прогноз каждые 5 секунд
                    local strDiff = currentStr - lastStrength
                    local rebDiff = currentReb - lastRebirths
                    
                    -- Прогноз на час и день
                    local strPerHour = (strDiff / timePassed) * 3600
                    local rebPerHour = (rebDiff / timePassed) * 3600
                    
                    local strPerDay = strPerHour * 24
                    local rebPerDay = rebPerHour * 24

                    statsText.Text = string.format(
                        " Strength: %s | Rebirths: %d\n" ..
                        " Gain/h: %s | Gain/d: %s\n" ..
                        " Reb/h: %.1f | Reb/d: %.1f",
                        FormatNumber(currentStr), currentReb,
                        FormatNumber(strPerHour), FormatNumber(strPerDay),
                        rebPerHour, rebPerDay
                    )
                    
                    lastStrength = currentStr
                    lastRebirths = currentReb
                    lastTime = tick()
                end
            else
                statsText.Text = "Ожидание загрузки данных..."
            end
            task.wait(1)
        end
    end)

    -- ==========================================
    -- СПИСОК ФУНКЦИЙ
    -- ==========================================
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -130)
    scroll.Position = UDim2.new(0, 5, 0, 125)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 0, 150)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = mainFrame
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scroll

    local function AddModule(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        btn.Text = name .. " [OFF]"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local pad = Instance.new("UIPadding", btn)
        pad.PaddingLeft = UDim.new(0, 10)

        local state = false
        local thread

        btn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                btn.Text = name .. " [ON]"
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
                if callback then
                    thread = task.spawn(function() callback(function() return state end) end)
                end
            else
                btn.Text = name .. " [OFF]"
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                if thread then pcall(task.cancel, thread) end
            end
        end)
    end

    -- 1. Auto Farm & Rebirth
    AddModule("Auto Farm & Rebirth", function(isOn)
        local muscleEvent = LocalPlayer:FindFirstChild("MuscleEvent")
        local rebirthRemote = GetRemote("rebirth")
        local ISLAND_CFRAME = CFrame.new(-8646, 17, -5738) -- Примерная локация

        while isOn() do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = ISLAND_CFRAME
                task.wait(0.5)
                
                -- Берем гантелю/тренажер
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                        firetouchinterest(char.HumanoidRootPart, obj.Handle, 0)
                        task.wait(0.2)
                        firetouchinterest(char.HumanoidRootPart, obj.Handle, 1)
                        break
                    end
                end
                
                -- Качаемся
                if muscleEvent then
                    pcall(function() muscleEvent:FireServer("punch", "leftHand") end)
                    pcall(function() muscleEvent:FireServer("punch", "rightHand") end)
                end
                
                -- Реберс
                if rebirthRemote then
                    pcall(function() rebirthRemote:InvokeServer("rebirthRequest") end)
                end
            end
            task.wait(0.1)
        end
    end)

    -- 2. Teleport to Alien Boss
    AddModule("TP to Alien Boss", function(isOn)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Координаты Алиен Босса (замените, если они другие)
            char.HumanoidRootPart.CFrame = CFrame.new(-1836.67, 84.76, -10974.69)
            Notify("Телепорт к Alien Boss")
        end
        isOn = function() return false end -- Одноразовое действие
    end)

    -- 3. Auto Sell Pets (Умный поиск)
    AddModule("Auto Sell Pets", function(isOn)
        local sellRemote = GetRemote("sell")
        if not sellRemote then Notify("Sell Remote не найден") return end
        while isOn() do
            pcall(function() sellRemote:FireServer() end)
            task.wait(3)
        end
    end)

    -- 4. Anti-AFK
    AddModule("Anti-AFK", function(isOn)
        local conn = LocalPlayer.Idled:Connect(function()
            if not isOn() then return end
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end)
        while isOn() do task.wait(60) end
        if conn then conn:Disconnect() end
    end)

    -- 5. Auto Reconnect
    AddModule("Auto Reconnect", function(isOn)
        local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
        local overlay = promptGui and promptGui:FindFirstChild("promptOverlay")
        if not overlay then return end
        local conn = overlay.DescendantAdded:Connect(function(err)
            if not isOn() then return end
            if err.Name == "ErrorTitle" then
                err:GetPropertyChangedSignal("Text"):Connect(function()
                    if err.Text:sub(1, 12) == "Disconnected" then
                        IS_RECONNECTING = true
                        task.wait(1)
                        pcall(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                        end)
                    end
                end)
            end
        end)
        while isOn() do task.wait(1) end
        if conn then conn:Disconnect() end
    end)
end

-- ЛОГИКА ВХОДА
local function tryLogin()
    if keyInput.Text == CORRECT_KEY then
        keyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        keyStatus.Text = "Успешно!"
        task.wait(0.4)
        keyGui:Destroy()
        LoadHub()
    else
        keyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        keyStatus.Text = "Неверный ключ!"
        keyInput.Text = ""
    end
end

LocalPlayer.OnTeleport:Connect(function(teleportState)
    if teleportState == Enum.TeleportState.Started and IS_RECONNECTING then
        task.wait(5)
        pcall(function() keyGui:Destroy(); LoadHub() end)
    end
end)

keySubmit.MouseButton1Click:Connect(tryLogin)
keyInput.FocusLost:Connect(function(enterPressed) if enterPressed then tryLogin() end end)
keyInput:CaptureFocus()
