-- ============================================================
-- NOHCHO⁹⁵ HUB — Muscle Legends (v11.2 STABLE)
-- Исправлен запуск | Поиск игроков | Стабильный UI
-- Ключ: Ц1онтро
-- ============================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local CORRECT_KEY = "Ц1онтро"
local IS_RECONNECTING = false
local ANIME_BG_ID = "rbxassetid://13160576240" 
local ANIME_ICON_ID = "rbxassetid://6031075936" 

local PRE_PORTAL_POS = Vector3.new(7.51, 14.68, -78.09)
local DESCENT_POS = Vector3.new(-1836.67, 84.76, -10974.69)

local function GetRemote(name)
    local RS = game:GetService("ReplicatedStorage")
    for _, obj in pairs(RS:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and string.find(string.lower(obj.Name), string.lower(name)) then
            return obj
        end
    end
    return nil
end

local function FormatNumber(n)
    if not n then return "0" end
    if n >= 1e12 then return string.format("%.2fT", n / 1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n / 1e3)
    else return tostring(math.floor(n)) end
end

local function Notify(text)
    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 300, 0, 45)
    lbl.Position = UDim2.new(0.5, -150, 0, -60)
    lbl.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sg
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", lbl).Color = Color3.fromRGB(150, 0, 255)
    TweenService:Create(lbl, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
    task.delay(3, function()
        TweenService:Create(lbl, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -150, 0, -60)}):Play()
        task.wait(0.4)
        sg:Destroy()
    end)
end

-- KEY SYSTEM (Упрощенный и стабильный)
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "NOHCHO95_Key"
keyGui.ResetOnSpawn = false
pcall(function() keyGui.Parent = CoreGui end)
if not keyGui.Parent then keyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local keyBg = Instance.new("Frame")
keyBg.Size = UDim2.new(0, 340, 0, 200)
keyBg.Position = UDim2.new(0.5, -170, 0.5, -100)
keyBg.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
keyBg.BorderSizePixel = 0
keyBg.Active = true
keyBg.Draggable = true
keyBg.Parent = keyGui
Instance.new("UICorner", keyBg).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", keyBg).Color = Color3.fromRGB(120, 0, 200)

local keyHeader = Instance.new("TextLabel")
keyHeader.Size = UDim2.new(1, 0, 0, 50)
keyHeader.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
keyHeader.Text = "NOHCHO⁹⁵ | KEY SYSTEM"
keyHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
keyHeader.Font = Enum.Font.GothamBold
keyHeader.TextSize = 18
keyHeader.Parent = keyBg
Instance.new("UICorner", keyHeader).CornerRadius = UDim.new(0, 12)

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -40, 0, 45)
keyInput.Position = UDim2.new(0, 20, 0, 65)
keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
keyInput.PlaceholderText = "Введите ключ..."
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 15
keyInput.Parent = keyBg
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 8)

local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1, -40, 0, 20)
keyStatus.Position = UDim2.new(0, 20, 0, 115)
keyStatus.BackgroundTransparency = 1
keyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
keyStatus.Font = Enum.Font.GothamBold
keyStatus.TextSize = 13
keyStatus.Parent = keyBg

local keySubmit = Instance.new("TextButton")
keySubmit.Size = UDim2.new(1, -40, 0, 45)
keySubmit.Position = UDim2.new(0, 20, 0, 140)
keySubmit.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
keySubmit.Text = "Авторизоваться"
keySubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmit.Font = Enum.Font.GothamBold
keySubmit.TextSize = 15
keySubmit.Parent = keyBg
Instance.new("UICorner", keySubmit).CornerRadius = UDim.new(0, 8)

-- ГЛАВНАЯ ФУНКЦИЯ
local function LoadHub()
    print("[NOHCHO] Скрипт запускается...")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NOHCHO95_Hub"
    screenGui.ResetOnSpawn = false
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 360, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -180, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(120, 0, 200)

    local bgImage = Instance.new("ImageLabel")
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = ANIME_BG_ID
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 1
    bgImage.Parent = mainFrame

    local bgDarken = Instance.new("Frame")
    bgDarken.Size = UDim2.new(1, 0, 1, 0)
    bgDarken.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgDarken.BackgroundTransparency = 0.5 
    bgDarken.BorderSizePixel = 0
    bgDarken.ZIndex = 1
    bgDarken.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    titleBar.ZIndex = 2
    titleBar.Parent = mainFrame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 50, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NOHCHO⁹⁵ | MEGA"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = titleBar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -70, 0, 10)
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    minBtn.Text = "—"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.ZIndex = 3
    minBtn.Parent = titleBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 3
    closeBtn.Parent = titleBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    -- Сворачивание
    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            mainFrame.Visible = false
        else
            mainFrame.Visible = true
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- СТАТЫ
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, -20, 0, 90)
    statsFrame.Position = UDim2.new(0, 10, 0, 60)
    statsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    statsFrame.ZIndex = 2
    statsFrame.Parent = mainFrame
    Instance.new("UICorner", statsFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", statsFrame).Color = Color3.fromRGB(80, 0, 150)

    local statsText = Instance.new("TextLabel")
    statsText.Size = UDim2.new(1, -20, 1, -20)
    statsText.Position = UDim2.new(0, 10, 0, 10)
    statsText.BackgroundTransparency = 1
    statsText.Text = "Загрузка статов..."
    statsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsText.Font = Enum.Font.Code
    statsText.TextSize = 14
    statsText.TextXAlignment = Enum.TextXAlignment.Left
    statsText.TextYAlignment = Enum.TextYAlignment.Top
    statsText.ZIndex = 3
    statsText.Parent = statsFrame

    -- Скролл
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -170)
    scroll.Position = UDim2.new(0, 10, 0, 160)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 2
    scroll.Parent = mainFrame
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = scroll

    local function AddModule(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.Text = "  " .. name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.ZIndex = 3
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        local state = false
        local thread = nil
        btn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                btn.Text = "  " .. name .. " [ON]"
                btn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
                if callback then thread = task.spawn(function() callback(function() return state end) end) end
            else
                btn.Text = "  " .. name .. " [OFF]"
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                if thread then pcall(task.cancel, thread) end
            end
        end)
    end

    -- 1. ФОЛЛОУ ФАРМ (Скрипт ищет игрока)
    AddModule("Alien Boss Follow & Train", function(isOn)
        task.spawn(function()
            while isOn() do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        
                        -- Ищем ближайшего игрока к зоне
                        local targetPos = nil
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                if (p.Character.HumanoidRootPart.Position - DESCENT_POS).Magnitude < 200 then
                                    targetPos = p.Character.HumanoidRootPart.Position
                                    break 
                                end
                            end
                        end

                        -- Если игрок есть, летим к нему
                        if targetPos then
                            if (char.HumanoidRootPart.Position - targetPos).Magnitude > 15 then
                                char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                                task.wait(1)
                            end
                        else
                            -- Если никого нет, летим сами
                            if (char.HumanoidRootPart.Position - DESCENT_POS).Magnitude > 500 then
                                char.HumanoidRootPart.CFrame = CFrame.new(PRE_PORTAL_POS)
                                task.wait(0.5)
                                pcall(function()
                                    local area = workspace:FindFirstChild("areaCircles")
                                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("rEvents") and game:GetService("ReplicatedStorage").rEvents:FindFirstChild("areaTravelRemote")
                                    if area and area:FindFirstChild("alienGymCircle") and remote then
                                        remote:InvokeServer("travelToArea", area.alienGymCircle)
                                    end
                                end)
                                task.wait(5) 
                            end
                        end

                        -- Ищем кнопку тренажера и зажимаем
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and obj.Enabled then
                                local parent = obj.Parent
                                if parent and parent:IsA("BasePart") then
                                    local modelName = parent.Parent and parent.Parent.Name or ""
                                    if string.find(string.lower(modelName), "alien") or string.find(string.lower(parent.Name), "alien") then
                                        if (parent.Position - char.HumanoidRootPart.Position).Magnitude < 20 then
                                            pcall(function() fireproximityprompt(obj) end)
                                            pcall(function()
                                                obj:InputHoldBegin()
                                                task.wait(1)
                                                obj:InputHoldEnd()
                                            end)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end)

    -- 2. FAST REBIRTH
    AddModule("Fast Rebirth", function(isOn)
        local rebRemote = GetRemote("rebirth")
        while isOn() do
            pcall(function() if rebRemote then rebRemote:InvokeServer("rebirthRequest") end end)
            task.wait(1)
        end
    end)

    -- 3. FAST PUNCH
    AddModule("Fast Punch", function(isOn)
        while isOn() do
            pcall(function()
                if LocalPlayer:FindFirstChild("muscleEvent") then
                    LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                    LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                end
            end)
            task.wait(0.05)
        end
    end)

    -- 4. AUTO RECONNECT
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
                        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
                    end
                end)
            end
        end)
        while isOn() do task.wait(1) end
        if conn then conn:Disconnect() end
    end)

    -- 5. ANTI-AFK
    AddModule("Anti-AFK", function(isOn)
        local conn = LocalPlayer.Idled:Connect(function()
            if not isOn() then return end
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
        end)
        while isOn() do task.wait(60) end
        if conn then conn:Disconnect() end
    end)
    
    print("[NOHCHO] Hub успешно загружен!")
end

-- ЗАПУСК
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

keySubmit.MouseButton1Click:Connect(tryLogin)
keyInput.FocusLost:Connect(function(entered) if entered then tryLogin() end end)
keyInput:CaptureFocus()
