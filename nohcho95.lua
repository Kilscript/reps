-- ============================================================
-- NOHCHO⁹⁵ HUB — Muscle Legends (v14.1 IY SPAWNPOINT EDITION)
-- Спам качем ("rep") | Идеально для спавна на тренажерах
-- Ключ: Ц1онтро
-- ============================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local CORRECT_KEY = "Ц1онтро"
local IS_RECONNECTING = false

local function GetRemote(name)
    local RS = game:GetService("ReplicatedStorage")
    for _, obj in pairs(RS:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and string.find(string.lower(obj.Name), string.lower(name)) then
            return obj
        end
    end
    return nil
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
    task.delay(3, function() sg:Destroy() end)
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
Instance.new("UIStroke", keyBg).Color = Color3.fromRGB(120, 0, 200)

local keyHeader = Instance.new("TextLabel")
keyHeader.Size = UDim2.new(1, 0, 0, 50)
keyHeader.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
keyHeader.Text = "NOHCHO⁹⁵ | IY EDITION"
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

-- ОСНОВНОЙ ХАБ
local function LoadHub()
    local reconnected = IS_RECONNECTING
    if reconnected then IS_RECONNECTING = false end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NOHCHO95_Hub"
    screenGui.ResetOnSpawn = false
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 340, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -170, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(120, 0, 200)

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    titleBar.Parent = mainFrame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 50, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NOHCHO⁹⁵ | IY SPAWN"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -70)
    scroll.Position = UDim2.new(0, 10, 0, 60)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
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
        return btn
    end

    -- 1. ФАРМ (Спам качем без движения)
    local farmBtn = AddModule("Alien Gym Auto Farm", function(isOn)
        local rebRemote = GetRemote("rebirth")
        
        task.spawn(function()
            while isOn() do
                pcall(function()
                    local muscleEvent = LocalPlayer:FindFirstChild("muscleEvent")
                    local machinesFolder = workspace:FindFirstChild("machinesFolder")
                    
                    if muscleEvent and machinesFolder then
                        for _, machine in pairs(machinesFolder:GetChildren()) do
                            -- Ищем все тренажеры с "alien" в названии
                            if string.find(string.lower(machine.Name), "alien") and machine:FindFirstChild("interactSeat") then
                                muscleEvent:FireServer("rep", machine.interactSeat)
                            end
                        end
                    end
                end)
                task.wait(0.01) -- Максимальная скорость спама
            end
        end)

        -- Авто-ребёрс
        task.spawn(function()
            while isOn() do
                pcall(function() if rebRemote then rebRemote:InvokeServer("rebirthRequest") end end)
                task.wait(1)
            end
        end)
    end)

    -- 2. FAST PUNCH (Резервный кач)
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

    -- 3. AUTO RECONNECT
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

    -- 4. ANTI-AFK
    AddModule("Anti-AFK", function(isOn)
        local conn = LocalPlayer.Idled:Connect(function()
            if not isOn() then return end
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
        end)
        while isOn() do task.wait(60) end
        if conn then conn:Disconnect() end
    end)

    if reconnected then
        task.wait(2)
        farmBtn.MouseButton1Click:Fire()
        Notify("Фарм автоматически возобновлен!")
    end
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

keySubmit.MouseButton1Click:Connect(tryLogin)
keyInput.FocusLost:Connect(function(entered) if entered then tryLogin() end end)
