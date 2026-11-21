-- ============================================================
-- NOHCHO⁹⁵ HUB — Muscle Legends
-- Ключ: Ц1онтро
-- Функции: Auto Farm, Auto Equip Pet, Auto Lift, Anti-AFK, Auto Reconnect
-- ============================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local CORRECT_KEY = "Ц1онтро"

-- ============================================================
-- УВЕДОМЛЕНИЯ (всплывающие плашки)
-- ============================================================
local function Notify(text)
    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 260, 0, 40)
    lbl.Position = UDim2.new(0.5, -130, 0, 10)
    lbl.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sg
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)

    task.delay(3, function()
        pcall(function()
            lbl:TweenPosition(UDim2.new(0.5, -130, 0, -50), "Out", "Quad", 0.3)
            task.wait(0.4)
            sg:Destroy()
        end)
    end)
end

-- ============================================================
-- 0. KEY SYSTEM
-- ============================================================
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "NOHCHO95_Key"
keyGui.ResetOnSpawn = false
pcall(function() keyGui.Parent = CoreGui end)
if not keyGui.Parent then keyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local keyBg = Instance.new("Frame")
keyBg.Size = UDim2.new(0, 300, 0, 180)
keyBg.Position = UDim2.new(0.5, -150, 0.5, -90)
keyBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyBg.BorderSizePixel = 0
keyBg.Active = true
keyBg.Draggable = true
keyBg.Parent = keyGui
Instance.new("UICorner", keyBg).CornerRadius = UDim.new(0, 10)

local keyHeader = Instance.new("TextLabel")
keyHeader.Size = UDim2.new(1, 0, 0, 40)
keyHeader.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
keyHeader.Text = "NOHCHO⁹⁵ | Введите ключ"
keyHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
keyHeader.Font = Enum.Font.GothamBold
keyHeader.TextSize = 16
keyHeader.Parent = keyBg
Instance.new("UICorner", keyHeader).CornerRadius = UDim.new(0, 10)

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 40)
keyInput.Position = UDim2.new(0, 15, 0, 55)
keyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
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
keySubmit.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
keySubmit.Text = "Войти"
keySubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmit.Font = Enum.Font.GothamBold
keySubmit.TextSize = 14
keySubmit.Parent = keyBg
Instance.new("UICorner", keySubmit).CornerRadius = UDim.new(0, 6)

-- ============================================================
-- 1. ОСНОВНОЙ ХАБ
-- ============================================================
local function LoadHub()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NOHCHO95_Hub"
    screenGui.ResetOnSpawn = false
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 260, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -130, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    title.Text = "NOHCHO⁹⁵ HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = mainFrame
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -50)
    scroll.Position = UDim2.new(0, 5, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = mainFrame
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scroll

    local function AddModule(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local state = false
        local thread

        btn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                btn.Text = name .. ": ON"
                btn.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
                Notify(name .. " включён")
                if callback then
                    thread = task.spawn(function()
                        callback(function() return state end)
                    end)
                end
            else
                btn.Text = name .. ": OFF"
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                Notify(name .. " выключен")
                if thread then pcall(task.cancel, thread) end
            end
        end)
    end

    -- Auto Farm (Clicker)
    AddModule("Auto Farm", function(isOn)
        while isOn() do
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0, 0))
                task.wait(0.1)
                VirtualUser:Button1Up(Vector2.new(0, 0))
            end)
            task.wait(0.1)
        end
    end)

    -- Auto Equip Pet
    AddModule("Auto Equip Pet", function(isOn)
        local PRIORITY = { "Galactic Overlord", "Mythic Boss Pet" }
        local petsFolder = LocalPlayer:FindFirstChild("Pets")
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local equipRemote = remotes and (remotes:FindFirstChild("EquipPet") or remotes:FindFirstChild("Equip"))

        if not petsFolder then Notify("Папка Pets не найдена") return end
        if not equipRemote then Notify("RemoteEvent EquipPet не найден") return end

        while isOn() do
            for _, petName in ipairs(PRIORITY) do
                local pet = petsFolder:FindFirstChild(petName)
                if pet then
                    pcall(function() equipRemote:FireServer(pet) end)
                    print("[NOHCHO] Экипирован:", petName)
                    break
                end
            end
            task.wait(5)
        end
    end)

    -- Auto Lift
    AddModule("Auto Lift", function(isOn)
        local liftRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            and game:GetService("ReplicatedStorage").Events:FindFirstChild("Lift")
        if not liftRemote then Notify("RemoteEvent Lift не найден") return end
        while isOn() do
            pcall(function() liftRemote:FireServer() end)
            task.wait(1.2)
        end
    end)

    -- Anti-AFK
    AddModule("Anti-AFK", function(isOn)
        local conn = LocalPlayer.Idled:Connect(function()
            if not isOn() then return end
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end)
        while isOn() do
            task.wait(60)
            if not isOn() then break end
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end
        if conn then conn:Disconnect() end
    end)

    -- Auto Reconnect
    AddModule("Auto Reconnect", function(isOn)
        local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
        local overlay = promptGui and promptGui:FindFirstChild("promptOverlay")
        if not overlay then Notify("RobloxPromptGui не найден") return end
        local conn = overlay.DescendantAdded:Connect(function(err)
            if not isOn() then return end
            if err.Name == "ErrorTitle" then
                err:GetPropertyChangedSignal("Text"):Connect(function()
                    if err.Text:sub(1, 12) == "Disconnected" then
                        Notify("Дисконнект, переподключение...")
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

    Notify("NOHCHO⁹⁵ загружен")
    print("[NOHCHO⁹⁵] Hub готов.")
end

-- ============================================================
-- 2. ЛОГИКА КЛЮЧА
-- ============================================================
local function tryLogin()
    if keyInput.Text == CORRECT_KEY then
        keyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        keyStatus.Text = "Ключ верный. Загрузка..."
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
keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then tryLogin() end
end)
keyInput:CaptureFocus()
