local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local pumpkinEspEnabled = false
local lanternEspEnabled = false
local teleportActive = false
local lanternTeleportActive = false
local bossEspEnabled = false
local islandEspEnabled = false
local dbTeleportActive = true

local espObjects = {}
local islandAnchors = {}
local isMinimized = false
local selectedIslandTarget = nil
local islandMenuOpen = false

-- UI (Alterado para PlayerGui para garantir compatibilidade com executores)
local gui = Instance.new("ScreenGui")
gui.Name = "DragonBallRageESP"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 190, 0, 395)
frame.Position = UDim2.new(0.5, -95, 0.5, -197)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -35, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Dragon Ball Rage ESP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Botão de Minimizar (-)
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -30, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeButton

-- Container para os botões principais
local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -40)
container.Position = UDim2.new(0, 0, 0, 40)
container.BackgroundTransparency = 1
container.Parent = frame

-- Botão 1: Pumpkin ESP
local pumpkinButton = Instance.new("TextButton")
pumpkinButton.Size = UDim2.new(0.85, 0, 0, 32)
pumpkinButton.Position = UDim2.new(0.075, 0, 0, 5)
pumpkinButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
pumpkinButton.Text = "Pumpkin: OFF"
pumpkinButton.TextColor3 = Color3.new(1, 1, 1)
pumpkinButton.TextSize = 13
pumpkinButton.Font = Enum.Font.GothamBold
pumpkinButton.Parent = container

local pumpkinCorner = Instance.new("UICorner")
pumpkinCorner.CornerRadius = UDim.new(0, 8)
pumpkinCorner.Parent = pumpkinButton

-- Botão 2: Teleport Pumpkin
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.85, 0, 0, 32)
teleportButton.Position = UDim2.new(0.075, 0, 0, 42)
teleportButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
teleportButton.Text = "Teleport Pumpkin: OFF"
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.TextSize = 11
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Parent = container

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportButton

-- Botão 3: Lantern ESP
local lanternButton = Instance.new("TextButton")
lanternButton.Size = UDim2.new(0.85, 0, 0, 32)
lanternButton.Position = UDim2.new(0.075, 0, 0, 79)
lanternButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
lanternButton.Text = "Lantern: OFF"
lanternButton.TextColor3 = Color3.new(1, 1, 1)
lanternButton.TextSize = 13
lanternButton.Font = Enum.Font.GothamBold
lanternButton.Parent = container

local lanternCorner = Instance.new("UICorner")
lanternCorner.CornerRadius = UDim.new(0, 8)
lanternCorner.Parent = lanternButton

-- Botão 4: Teleport Lantern
local lanternTeleportButton = Instance.new("TextButton")
lanternTeleportButton.Size = UDim2.new(0.85, 0, 0, 32)
lanternTeleportButton.Position = UDim2.new(0.075, 0, 0, 116)
lanternTeleportButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
lanternTeleportButton.Text = "Teleport Lantern: OFF"
lanternTeleportButton.TextColor3 = Color3.new(1, 1, 1)
lanternTeleportButton.TextSize = 11
lanternTeleportButton.Font = Enum.Font.GothamBold
lanternTeleportButton.Parent = container

local lanternTeleportCorner = Instance.new("UICorner")
lanternTeleportCorner.CornerRadius = UDim.new(0, 8)
lanternTeleportCorner.Parent = lanternTeleportButton

-- Botão 5: Boss ESP
local bossButton = Instance.new("TextButton")
bossButton.Size = UDim2.new(0.85, 0, 0, 32)
bossButton.Position = UDim2.new(0.075, 0, 0, 153)
bossButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
bossButton.Text = "Boss ESP: OFF"
bossButton.TextColor3 = Color3.new(1, 1, 1)
bossButton.TextSize = 13
bossButton.Font = Enum.Font.GothamBold
bossButton.Parent = container

local bossCorner = Instance.new("UICorner")
bossCorner.CornerRadius = UDim.new(0, 8)
bossCorner.Parent = bossButton

-- Botão 6: Ilhas ESP
local islandButton = Instance.new("TextButton")
islandButton.Size = UDim2.new(0.85, 0, 0, 32)
islandButton.Position = UDim2.new(0.075, 0, 0, 190)
islandButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
islandButton.Text = "Ilha: OFF"
islandButton.TextColor3 = Color3.new(1, 1, 1)
islandButton.TextSize = 13
islandButton.Font = Enum.Font.GothamBold
islandButton.Parent = container

local islandCorner = Instance.new("UICorner")
islandCorner.CornerRadius = UDim.new(0, 8)
islandCorner.Parent = islandButton

-- Botão 7: Menu de Seleção de Ilha
local selectIslandMenuButton = Instance.new("TextButton")
selectIslandMenuButton.Size = UDim2.new(0.85, 0, 0, 32)
selectIslandMenuButton.Position = UDim2.new(0.075, 0, 0, 227)
selectIslandMenuButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
selectIslandMenuButton.Text = "Selecionar Ilha"
selectIslandMenuButton.TextColor3 = Color3.new(1, 1, 1)
selectIslandMenuButton.TextSize = 12
selectIslandMenuButton.Font = Enum.Font.GothamBold
selectIslandMenuButton.Parent = container

local selectIslandMenuCorner = Instance.new("UICorner")
selectIslandMenuCorner.CornerRadius = UDim.new(0, 8)
selectIslandMenuCorner.Parent = selectIslandMenuButton

-- Botão 8: TP para a Ilha Selecionada
local tpIslandButton = Instance.new("TextButton")
tpIslandButton.Size = UDim2.new(0.85, 0, 0, 32)
tpIslandButton.Position = UDim2.new(0.075, 0, 0, 264)
tpIslandButton.BackgroundColor3 = Color3.fromRGB(40, 90, 150)
tpIslandButton.Text = "TP para Ilha: Nenhuma"
tpIslandButton.TextColor3 = Color3.new(1, 1, 1)
tpIslandButton.TextSize = 11
tpIslandButton.Font = Enum.Font.GothamBold
tpIslandButton.Parent = container

local tpIslandCorner = Instance.new("UICorner")
tpIslandCorner.CornerRadius = UDim.new(0, 8)
tpIslandCorner.Parent = tpIslandButton

-- Botão 9: Teleport Dragon Ball
local dbTeleportButton = Instance.new("TextButton")
dbTeleportButton.Size = UDim2.new(0.85, 0, 0, 32)
dbTeleportButton.Position = UDim2.new(0.075, 0, 0, 301)
dbTeleportButton.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
dbTeleportButton.Text = "Teleport DB: ON"
dbTeleportButton.TextColor3 = Color3.new(1, 1, 1)
dbTeleportButton.TextSize = 11
dbTeleportButton.Font = Enum.Font.GothamBold
dbTeleportButton.Parent = container

local dbTeleportCorner = Instance.new("UICorner")
dbTeleportCorner.CornerRadius = UDim.new(0, 8)
dbTeleportCorner.Parent = dbTeleportButton

-- Janela Flutuante para Listar as Ilhas
local islandListFrame = Instance.new("ScrollingFrame")
islandListFrame.Size = UDim2.new(0, 170, 0, 250)
islandListFrame.Position = UDim2.new(1, 10, 0, 0)
islandListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
islandListFrame.BorderSizePixel = 0
islandListFrame.Visible = false
islandListFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
islandListFrame.ScrollBarThickness = 6
islandListFrame.Parent = frame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = islandListFrame

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    islandListFrame.Visible = false
    if isMinimized then
        container.Visible = false
        frame.Size = UDim2.new(0, 190, 0, 35)
        minimizeButton.Text = "+"
    else
        container.Visible = true
        frame.Size = UDim2.new(0, 190, 0, 395)
        minimizeButton.Text = "-"
    end
end)

local islandData = {
    {name = "DesertWoods", pos = Vector3.new(1462.00, 489.15, -3119.56)},
    {name = "Tournament", pos = Vector3.new(-1061.73, 523.80, -3578.73)},
    {name = "Volcano", pos = Vector3.new(1055.48, 1052.11, -5220.32)},
    {name = "LargeIsland", pos = Vector3.new(-3509.89, 619.80, 1301.48)},
    {name = "IceIsland", pos = Vector3.new(-3835.97, 599.61, -1536.60)},
    {name = "AbandonedIsland", pos = Vector3.new(-1451.31, 635.17, 3492.23)},
    {name = "StarterIsland", pos = Vector3.new(-708.16, 660.36, 3033.48)},
    {name = "Desert", pos = Vector3.new(3237.87, 658.73, -167.74)},
    {name = "Mountains", pos = Vector3.new(-1692.51, 634.36, -1003.13)}
}

for i, info in ipairs(islandData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, (i - 1) * 40 + 5)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = info.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = islandListFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        selectedIslandTarget = info
        tpIslandButton.Text = "TP: " .. info.name
        islandListFrame.Visible = false
    end)
end

selectIslandMenuButton.MouseButton1Click:Connect(function()
    islandListFrame.Visible = not islandListFrame.Visible
end)

tpIslandButton.MouseButton1Click:Connect(function()
    if selectedIslandTarget then
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(selectedIslandTarget.pos + Vector3.new(0, 5, 0))
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

local function createESP(obj, name, color, customHeight)
    if espObjects[obj] then return end

    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FarmESP"
    billboard.Size = UDim2.new(0, 180, 0, 60)
    billboard.StudsOffset = Vector3.new(0, customHeight or 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = part
    billboard.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextWrapped = true
    label.Parent = billboard

    espObjects[obj] = {
        gui = billboard,
        label = label,
        part = part,
        name = name,
        typeName = name:lower()
    }
end

local function removeESPByType(typeName)
    for obj, data in pairs(espObjects) do
        if data.typeName == typeName or data.typeName:find(typeName) then
            data.gui:Destroy()
            espObjects[obj] = nil
        end
    end
end

local function isLanternLit(obj)
    local light = obj:FindFirstChildWhichIsA("Light", true)
    if light then
        return light.Enabled
    end
    
    local fire = obj:FindFirstChildWhichIsA("Fire", true) or obj:FindFirstChildWhichIsA("ParticleEmitter", true)
    if fire then
        return fire.Enabled
    end

    local litValue = obj:FindFirstChild("Lit") or obj:FindFirstChild("IsLit") or obj:FindFirstChild("Activated")
    if litValue and litValue:IsA("BoolValue") then
        return litValue.Value
    end

    return false
end

local function isDragonBallMeteor(objName)
    return objName == "DragonBallMeteor"
end

local function toggleIslandESP(state)
    if state then
        for index, info in ipairs(islandData) do
            local anchorPart = Instance.new("Part")
            anchorPart.Size = Vector3.new(1, 1, 1)
            anchorPart.Position = info.pos
            anchorPart.Anchored = true
            anchorPart.Transparency = 1
            anchorPart.CanCollide = false
            anchorPart.Parent = Workspace

            table.insert(islandAnchors, anchorPart)

            local heightOffset = (index - 1) * 50
            if info.name == "AbandonedIsland" then
                heightOffset = heightOffset - 100
            end

            createESP(anchorPart, info.name, Color3.fromRGB(255, 255, 0), heightOffset)
        end
    else
        for _, anchor in ipairs(islandAnchors) do
            if anchor and anchor.Parent then
                anchor:Destroy()
            end
        end
        islandAnchors = {}

        for _, info in ipairs(islandData) do
            removeESPByType(info.name:lower())
        end
    end
end

local bossSet = {
    carl = true,
    brola = true,
    beast = true,
    janemba = true,
    gogeta = true,
    corruptkin = true,
    maz = true,
    guz = true,
    reaper = true,
    monstrosity = true,
    ablaze = true
}

local function isBossObject(lowerName)
    if bossSet[lowerName] then return true end
    for bName in pairs(bossSet) do
        if lowerName:find(bName) then
            return true
        end
    end
    return false
end

local function scan()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = obj.Name
        local lowerName = n:lower()

        if (lanternEspEnabled or lanternTeleportActive) and (lowerName:find("lantern") or lowerName:find("lamp")) then
            local isLit = isLanternLit(obj)
            local initialColor = isLit and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            createESP(obj, "Lantern", initialColor, 3)
        end

        if pumpkinEspEnabled and lowerName:find("pumpkin") then
            createESP(obj, "Pumpkin", Color3.fromRGB(255, 145, 0), 3)
        end

        if dbTeleportActive and isDragonBallMeteor(n) then
            createESP(obj, obj.Name, Color3.fromRGB(255, 215, 0), 3)
        end

        if bossEspEnabled and isBossObject(lowerName) then
            createESP(obj, obj.Name, Color3.fromRGB(0, 170, 255), 3)
        end
    end
end

pumpkinButton.MouseButton1Click:Connect(function()
    pumpkinEspEnabled = not pumpkinEspEnabled
    if pumpkinEspEnabled then
        pumpkinButton.Text = "Pumpkin: ON"
        pumpkinButton.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
    else
        pumpkinButton.Text = "Pumpkin: OFF"
        pumpkinButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
        removeESPByType("pumpkin")
    end
    scan()
end)

lanternButton.MouseButton1Click:Connect(function()
    lanternEspEnabled = not lanternEspEnabled
    if lanternEspEnabled then
        lanternButton.Text = "Lantern: ON"
        lanternButton.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
    else
        lanternButton.Text = "Lantern: OFF"
        lanternButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
        if not lanternTeleportActive then
            removeESPByType("lantern")
        end
    end
    scan()
end)

lanternTeleportButton.MouseButton1Click:Connect(function()
    lanternTeleportActive = not lanternTeleportActive
    if lanternTeleportActive then
        lanternTeleportButton.Text = "Teleport Lantern: ON"
        lanternTeleportButton.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
        scan()
    else
        lanternTeleportButton.Text = "Teleport Lantern: OFF"
        lanternTeleportButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
        if not lanternEspEnabled then
            removeESPByType("lantern")
        end
    end
end)

dbTeleportButton.MouseButton1Click:Connect(function()
    dbTeleportActive = not dbTeleportActive
    if dbTeleportActive then
        dbTeleportButton.Text = "Teleport DB: ON"
        dbTeleportButton.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
        scan()
    else
        dbTeleportButton.Text = "Teleport DB: OFF"
        dbTeleportButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
        removeESPByType("dragonballmeteor")
    end
end)

bossButton.MouseButton1Click:Connect(function()
    bossEspEnabled = not bossEspEnabled
    if bossEspEnabled then
        bossButton.Text = "Boss ESP: ON"
        bossButton.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
    else
        bossButton.Text = "Boss ESP: OFF"
        bossButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
        for bName in pairs(bossSet) do
            removeESPByType(bName)
        end
    end
    scan()
end)

islandButton.MouseButton1Click:Connect(function()
    islandEspEnabled = not islandEspEnabled
    if islandEspEnabled then
        islandButton.Text = "Ilha: ON"
        islandButton.BackgroundColor3 = Color3.fromRGB(30, 150, 60)
        toggleIslandESP(true)
    else
        islandButton.Text = "Ilha: OFF"
        islandButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
        toggleIslandESP(false)
    end
end)

-- Loop de Teleporte para Pumpkins
task.spawn(function()
    while true do
        task.wait(0.2)
        if teleportActive then
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                local closestPumpkinObj = nil
                local closestData = nil
                local shortestDistance = math.huge
                
                for obj, data in pairs(espObjects) do
                    if data.typeName == "pumpkin" then
                        if not obj or not obj.Parent or not data.part or not data.part.Parent or not Workspace:IsAncestorOf(data.part) then
                            if data.gui then data.gui:Destroy() end
                            espObjects[obj] = nil
                        end
                    end
                end
                
                for obj, data in pairs(espObjects) do
                    if data.typeName == "pumpkin" and data.part and data.part.Parent and Workspace:IsAncestorOf(data.part) then
                        local dist = (hrp.Position - data.part.Position).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestPumpkinObj = obj
                            closestData = data
                        end
                    end
                end
                
                if closestPumpkinObj and closestData and closestData.part and closestData.part.Parent then
                    local targetPosition = closestData.part.Position + Vector3.new(0, 3, 0)
                    
                    hrp.CFrame = CFrame.new(targetPosition)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    
                    while teleportActive and closestPumpkinObj and closestPumpkinObj.Parent and closestData.part and closestData.part.Parent and Workspace:IsAncestorOf(closestData.part) do
                        hrp.CFrame = CFrame.new(closestData.part.Position + Vector3.new(0, 3, 0))
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        task.wait(0.05)
                    end
                    
                    if closestPumpkinObj and espObjects[closestPumpkinObj] then
           
