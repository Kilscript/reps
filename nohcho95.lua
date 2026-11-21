-- ============================================================
-- NOHCHO⁹⁵ HUB — Muscle Legends (v10.0 ANIME BOY EDITION)
-- Увеличенный интерфейс | Аниме-мальчик | Luna Teleport
-- Ключ: Ц1онтро
-- ============================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local CORRECT_KEY = "Ц1онтро"
local IS_RECONNECTING = false

-- >>> БЕЗОПАСНЫЕ ID КАРТИНОК (Не заблокированы) <<<
local ANIME_BG_ID = "rbxassetid://11809751316" -- Аниме мальчик на фон
local ANIME_ICON_ID = "rbxassetid://10201746380" -- Аниме мальчик (иконка)

local PRE_PORTAL_POS = Vector3.new(7.515656471252441, 14.683902740478516, -78.0965576171875)
local DESCENT_POS = Vector3.new(-1836.67, 84.76, -10974.69)

local function GetRemote(name)
    local RS = game:GetService("ReplicatedStorage")
    local custom = RS:FindFirstChild("rEvents") or RS:FindFirstChild("Remotes") or RS:FindFirstChild("Events")
    if custom then
        for _, obj in pairs(custom:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and string.find(string.lower(obj.Name), string.lower(name)) then
                return obj
            end
        end
    end
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
    lbl.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    lbl.BackgroundTransparency = 0.2
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sg
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", lbl)
    stroke.Color = Color3.fromRGB(150, 0, 255)
    stroke.Thickness = 1.5
    TweenService:Create(lbl, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
    task.delay(3.5, function()
        local tweenOut = TweenService:Create(lbl, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -150, 0, -60)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        sg:Destroy()
    end)
end

-- KEY SYSTEM
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
local keyStroke = Instance.new("UIStroke", keyBg)
keyStroke.Color = Color3.fromRGB(120, 0, 200)
keyStroke.Thickness = 2

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
keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 15
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyBg
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 8)

local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1, -40, 0, 20)
keyStatus.Position = UDim2.new(0, 20, 0, 115)
keyStatus.BackgroundTransparency = 1
keyStatus.Text = ""
keyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
keyStatus.Font = Enum.Font.Gotham
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

-- ОСНОВНОЙ ХАБ (Увеличенный)
local function LoadHub()
    local reconnected = IS_RECONNECTING
    if reconnected then
        IS_RECONNECTING = false
        Notify("Auto Reconnect: перезапуск...")
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NOHCHO95_Hub"
    screenGui.ResetOnSpawn = false
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Иконка для сворачивания (Аниме)
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    toggleBtn.Image = ANIME_ICON_ID
    toggleBtn.Visible = false
    toggleBtn.Parent = screenGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", toggleBtn).Color = Color3.fromRGB(150, 0, 255)

    -- Главное окно (Сделал БОЛЬШЕ: 360x550)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 360, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -180, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(120, 0, 200)
    mainStroke.Thickness = 1.5
    
    -- ФОН (Аниме мальчик)
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
    bgDarken.BackgroundTransparency = 0.45 
    bgDarken.BorderSizePixel = 0
    bgDarken.ZIndex = 1
    bgDarken.Parent = mainFrame

    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 360, 0, 550)}):Play()

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    titleBar.BackgroundTransparency = 0.2
    titleBar.ZIndex = 2
    titleBar.Parent = mainFrame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

    -- Аниме иконка в шапке
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Size = UDim2.new(0, 36, 0, 36)
    titleIcon.Position = UDim2.new(0, 10, 0, 7)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Image = ANIME_ICON_ID
    titleIcon.ZIndex = 3
    titleIcon.Parent = titleBar
    Instance.new("UICorner", titleIcon).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 55, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NOHCHO⁹⁵ | ANIME BOY"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = titleBar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(1, -68, 0, 11)
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    minBtn.Text = "—"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.ZIndex = 3
    minBtn.Parent = titleBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -34, 0, 11)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.ZIndex = 3
    closeBtn.Parent = titleBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    minBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false; toggleBtn.Visible = true end)
    toggleBtn.MouseButton1Click:Connect(function() toggleBtn.Visible = false; mainFrame.Visible = true end)
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Stats (Увеличил панель)
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, -20, 0, 90)
    statsFrame.Position = UDim2.new(0, 10, 0, 60)
    statsFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    statsFrame.BackgroundTransparency = 0.3
    statsFrame.ZIndex = 2
    statsFrame.Parent = mainFrame
    Instance.new("UICorner", statsFrame).CornerRadius = UDim.new(0, 8)

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
                if timePassed >= 5 then
                    local strDiff, rebDiff = currentStr - lastStrength, currentReb - lastRebirths
                    local strPerHour, rebPerHour = (strDiff / timePassed) * 3600, (rebDiff / timePassed) * 3600
                    statsText.Text = string.format(
                        " Strength: %s | Rebirths: %d\n Gain/h: %s | Gain/d: %s\n Reb/h: %.1f | Reb/d: %.1f",
                        FormatNumber(currentStr), currentReb, FormatNumber(strPerHour), FormatNumber(strPerHour*24), rebPerHour, rebPerHour*24
                    )
                    lastStrength, lastRebirths, lastTime = currentStr, currentReb, tick()
                end
            else
                statsText.Text = "Ожидание данных..."
            end
            task.wait(1)
        end
    end)

    -- Скролл (Увеличил под размер окна)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -170)
    scroll.Position = UDim2.new(0, 10, 0, 160)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 0, 200)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 2
    scroll.Parent = mainFrame
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = scroll

    local function AddModule(name, callback, isButton)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        btn.BackgroundTransparency = 0.2
        btn.Text = "  " .. name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.ZIndex = 3
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local state = false
        local thread = nil
        if isButton then
            btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
        else
            btn.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    btn.Text = "  " .. name .. " [ON]"
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 0, 200), BackgroundTransparency = 0.1}):Play()
                    if callback then thread = task.spawn(function() callback(function() return state end) end) end
                else
                    btn.Text = "  " .. name .. " [OFF]"
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 40), BackgroundTransparency = 0.2}):Play()
                    if thread then pcall(task.cancel, thread) end
                end
            end)
        end
        return btn
    end

    -- ГЛАВНАЯ ФУНКЦИЯ
    local alienFarmBtn = AddModule("Alien Boss Auto Train + Rebirth", function(isOn)
        local rebRemote = GetRemote("rebirth")
        
        task.spawn(function()
            while isOn() do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        if (char.HumanoidRootPart.Position - DESCENT_POS).Magnitude > 100 then
                            char.HumanoidRootPart.CFrame = CFrame.new(PRE_PORTAL_POS)
                            task.wait(0.5)
                            pcall(function()
                                local args = { "travelToArea", workspace:WaitForChild("areaCircles"):WaitForChild("alienGymCircle") }
                                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("areaTravelRemote"):InvokeServer(unpack(args))
                            end)
                            task.wait(2) 
                        end

                        local closestPrompt = nil
                        local shortestDist = math.huge
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") then
                                local parentPart = obj.Parent
                                if parentPart and parentPart:IsA("BasePart") then
                                    local dist = (parentPart.Position - char.HumanoidRootPart.Position).Magnitude
                                    if dist < shortestDist and dist < 100 then
                                        closestPrompt = obj
                                        shortestDist = dist
                                    end
                                end
                            end
                        end

                        if closestPrompt then
                            pcall(function() fireproximityprompt(closestPrompt) end)
                            task.wait(2) 
                        end
                    end
                end)
                task.wait(2)
            end
        end)

        task.spawn(function()
            while isOn() do
                pcall(function()
                    if LocalPlayer:FindFirstChild("muscleEvent") then
                        LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                        LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                    end
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end)
                task.wait(0.01)
            end
        end)

        task.spawn(function()
            while isOn() do
                pcall(function() if rebRemote then rebRemote:InvokeServer("rebirthRequest") end end)
                task.wait(1.5)
            end
        end)
    end)

    if reconnected then
        task.wait(2)
        alienFarmBtn.MouseButton1Click:Fire()
        Notify("Фарм автоматически возобновлен!")
    end

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

    AddModule("Anti-AFK", function(isOn)
        local conn = LocalPlayer.Idled:Connect(function()
            if not isOn() then return end
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
        end)
        while isOn() do task.wait(60) end
        if conn then conn:Disconnect() end
    end)
end

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
keyInput.FocusLost:Connect(function(entered) if entered then tryLogin() end end)
keyInput:CaptureFocus()
