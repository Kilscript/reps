-- ============================================================
-- NOHCHO⁹⁵ HUB — Muscle Legends (v12.0 CLEAN)
-- Прямой запуск (без GitHub) | Умный поиск тренажеров
-- Ключ: Ц1онтро
-- ============================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local CORRECT_KEY = "Ц1онтро"
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

-- ОКНО ВВОДА КЛЮЧА
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "NOHCHO_Key"
keyGui.ResetOnSpawn = false
keyGui.Parent = CoreGui

local keyBg = Instance.new("Frame")
keyBg.Size = UDim2.new(0, 300, 0, 180)
keyBg.Position = UDim2.new(0.5, -150, 0.5, -90)
keyBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
keyBg.Parent = keyGui
Instance.new("UICorner", keyBg).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", keyBg).Color = Color3.fromRGB(150, 0, 255)

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 40)
keyTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
keyTitle.Text = "NOHCHO⁹⁵ | KEY"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 16
keyTitle.Parent = keyBg

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 40)
keyInput.Position = UDim2.new(0, 15, 0, 50)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
keyInput.PlaceholderText = "Введите ключ..."
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.Parent = keyBg
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 6)

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(1, -30, 0, 40)
keyBtn.Position = UDim2.new(0, 15, 0, 110)
keyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
keyBtn.Text = "Войти"
keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBtn.Font = Enum.Font.GothamBold
keyBtn.Parent = keyBg
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

-- ГЛАВНОЕ МЕНЮ
local function LoadHub()
    local sg = Instance.new("ScreenGui")
    sg.Name = "NOHCHO_Hub"
    sg.ResetOnSpawn = false
    sg.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 300, 0, 400)
    main.Position = UDim2.new(0.5, -150, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    main.Active = true
    main.Draggable = true
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", main).Color = Color3.fromRGB(150, 0, 255)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    title.Text = "NOHCHO⁹⁵ | CLEAN"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = main
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 25, 0, 25)
    close.Position = UDim2.new(1, -30, 0, 7)
    close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Font = Enum.Font.GothamBold
    close.Parent = title
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 4)
    close.MouseButton1Click:Connect(function() sg:Destroy() end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -50)
    scroll.Position = UDim2.new(0, 5, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = main
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroll

    local function AddBtn(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55) -- Светлый фон
        btn.Text = " " .. name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local state = false
        local th = nil
        btn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                btn.Text = " " .. name .. " [ON]"
                btn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
                th = task.spawn(function() callback(function() return state end) end)
            else
                btn.Text = " " .. name .. " [OFF]"
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                if th then pcall(task.cancel, th) end
            end
        end)
    end

    -- 1. ФАРМ
    AddBtn("Auto Farm (Gym)", function(isOn)
        local rebRemote = GetRemote("rebirth")
        
        task.spawn(function()
            while isOn() do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local closestPrompt = nil
                        local closestPart = nil
                        local minDist = math.huge

                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and obj.Enabled then
                                local parent = obj.Parent
                                if parent and parent:IsA("BasePart") then
                                    local txt = string.lower(obj.ObjectText or obj.ActionText or "")
                                    local mName = parent.Parent and string.lower(parent.Parent.Name) or ""
                                    
                                    -- Ищем тренажеры (Alien)
                                    if (string.find(txt, "alien") or string.find(mName, "alien")) and not (string.find(txt, "boss") or string.find(mName, "boss")) then
                                        local dist = (parent.Position - char.HumanoidRootPart.Position).Magnitude
                                        if dist < minDist then
                                            closestPrompt = obj
                                            closestPart = parent
                                            minDist = dist
                                        end
                                    end
                                end
                            end
                        end

                        if closestPrompt and closestPart then
                            if minDist > 8 then
                                char.HumanoidRootPart.CFrame = CFrame.new(closestPart.Position + Vector3.new(0, 3, 0))
                                task.wait(0.5)
                            else
                                pcall(function() fireproximityprompt(closestPrompt) end)
                                pcall(function()
                                    closestPrompt:InputHoldBegin()
                                    task.wait(1.5)
                                    closestPrompt:InputHoldEnd()
                                end)
                                task.wait(1)
                            end
                        else
                            if (char.HumanoidRootPart.Position - DESCENT_POS).Magnitude > 300 then
                                char.HumanoidRootPart.CFrame = CFrame.new(PRE_PORTAL_POS)
                                task.wait(0.5)
                                pcall(function()
                                    local area = workspace:FindFirstChild("areaCircles")
                                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("rEvents") and game:GetService("ReplicatedStorage").rEvents:FindFirstChild("areaTravelRemote")
                                    if area and area:FindFirstChild("alienGymCircle") and remote then
                                        remote:InvokeServer("travelToArea", area.alienGymCircle)
                                    end
                                end)
                                task.wait(4) 
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)

        -- Авто-ребёрс
        task.spawn(function()
            while isOn() do
                pcall(function() if rebRemote then rebRemote:InvokeServer("rebirthRequest") end end)
                task.wait(2)
            end
        end)
    end)

    -- 2. УДАРЫ
    AddBtn("Fast Punch", function(isOn)
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

    -- 3. АНТИ-АФК
    AddBtn("Anti-AFK", function(isOn)
        local conn = LocalPlayer.Idled:Connect(function()
            if not isOn() then return end
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
        end)
        while isOn() do task.wait(60) end
        if conn then conn:Disconnect() end
    end)
end

-- ЛОГИКА КЛЮЧА
local function tryLogin()
    if keyInput.Text == CORRECT_KEY then
        keyGui:Destroy()
        LoadHub()
    else
        keyInput.Text = ""
        keyInput.PlaceholderText = "Неверный ключ!"
    end
end
keyBtn.MouseButton1Click:Connect(tryLogin)
keyInput.FocusLost:Connect(function(ent) if ent then tryLogin() end end)
