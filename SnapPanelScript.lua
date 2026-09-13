-- Script Luau para Roblox - Painel com botão SNAP ÉPICO
-- Coloque este script em StarterGui > ScreenGui como LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local FREEZE_DURATION = 5 * 60 -- 5 minutos

-- ============================================
-- CRIAR ESTRUTURA DO GUI
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SnapPanelGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Botão de Abertura (canto superior direito)
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 100, 0, 50)
openButton.Position = UDim2.new(1, -120, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 16
openButton.Font = Enum.Font.GothamBold
openButton.Text = "Abrir Painel"
openButton.BorderSizePixel = 0
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

-- Painel Principal
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 400, 0, 300)
mainPanel.Position = UDim2.new(0.5, -200, 0.5, -150)
mainPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = mainPanel

-- Título
local panelTitle = Instance.new("TextLabel")
panelTitle.Name = "Title"
panelTitle.Size = UDim2.new(1, 0, 0, 50)
panelTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
panelTitle.TextSize = 20
panelTitle.Font = Enum.Font.GothamBold
panelTitle.Text = "⚡ PAINEL SNAP ⚡"
panelTitle.BorderSizePixel = 0
panelTitle.Parent = mainPanel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = panelTitle

-- Botão SNAP
local snapButton = Instance.new("TextButton")
snapButton.Name = "SnapButton"
snapButton.Size = UDim2.new(0, 300, 0, 100)
snapButton.Position = UDim2.new(0.5, -150, 0.5, -50)
snapButton.BackgroundColor3 = Color3.fromRGB(255, 102, 0)
snapButton.TextColor3 = Color3.fromRGB(255, 255, 255)
snapButton.TextSize = 32
snapButton.Font = Enum.Font.GothamBold
snapButton.Text = "SNAP"
snapButton.BorderSizePixel = 0
snapButton.Parent = mainPanel

local snapCorner = Instance.new("UICorner")
snapCorner.CornerRadius = UDim.new(0, 10)
snapCorner.Parent = snapButton

-- Botão Fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "✕"
closeButton.BorderSizePixel = 0
closeButton.Parent = mainPanel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- ============================================
-- FUNÇÃO PARA CRIAR EFEITO DE LUZ
-- ============================================

local function createLightEffect(position)
	local effect = Instance.new("Part")
	effect.Name = "SnapEffect"
	effect.Shape = Enum.PartType.Ball
	effect.Size = Vector3.new(1, 1, 1)
	effect.CanCollide = false
	effect.CFrame = CFrame.new(position)
	effect.Material = Enum.Material.Neon
	effect.BrickColor = BrickColor.new("Cyan")
	effect.TopSurface = Enum.SurfaceType.Smooth
	effect.BottomSurface = Enum.SurfaceType.Smooth
	effect.Parent = workspace
	
	local light = Instance.new("PointLight")
	light.Brightness = 5
	light.Range = 50
	light.Color = Color3.fromRGB(0, 200, 255)
	light.Parent = effect
	
	-- Som
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://7384185988"
	sound.Volume = 1
	sound.Parent = effect
	sound:Play()
	
	-- Expandir e desaparecer
	for i = 1, 30 do
		effect.Size = effect.Size + Vector3.new(1.5, 1.5, 1.5)
		effect.Transparency = i / 30
		task.wait(0.03)
	end
	
	effect:Destroy()
end

-- ============================================
-- FUNÇÃO DE ANIMAÇÃO DO SNAP
-- ============================================

local function performSnapAnimation(snapType)
	print("🔵 INICIANDO SNAP: " .. snapType)
	
	-- Procurar o jogador
	local targetPlayer = Players:FindFirstChild("los_tralaleritos778")
	if not targetPlayer or not targetPlayer.Character then
		print("❌ Jogador não encontrado!")
		return
	end
	
	local character = targetPlayer.Character
	local hrp = character:FindFirstChild("HumanoidRootPart")
	
	if not hrp then
		print("❌ HumanoidRootPart não encontrado!")
		return
	end
	
	-- Clonar personagem
	print("👤 Clonando personagem...")
	local clonedCharacter = character:Clone()
	clonedCharacter.Name = "SnapClone"
	clonedCharacter.Parent = workspace
	
	-- Remover humanoid para não se comportar como um jogador
	local humanoid = clonedCharacter:FindFirstChild("Humanoid")
	if humanoid then
		humanoid:Destroy()
	end
	
	-- Remover scripts
	for _, desc in pairs(clonedCharacter:GetDescendants()) do
		if desc:IsA("Script") or desc:IsA("LocalScript") then
			desc:Destroy()
		end
	end
	
	-- Posicionar no centro da tela
	local clonedHrp = clonedCharacter:FindFirstChild("HumanoidRootPart")
	if not clonedHrp then
		print("❌ Clone não tem HumanoidRootPart!")
		clonedCharacter:Destroy()
		return
	end
	
	local targetPos = camera.CFrame.Position + camera.CFrame.LookVector * 25
	clonedHrp.CFrame = CFrame.new(targetPos)
	
	-- FASE 1: Fazer pequeno
	print("📉 Deixando pequeno...")
	local originalSize = {}
	for _, part in pairs(clonedCharacter:GetDescendants()) do
		if part:IsA("BasePart") then
			originalSize[part] = part.Size
			part.Size = part.Size * 0.05
		end
	end
	
	-- FASE 2: Crescer gradualmente
	print("📈 Crescendo...")
	local startTime = tick()
	local growDuration = 3
	
	while tick() - startTime < growDuration do
		local elapsed = tick() - startTime
		local progress = elapsed / growDuration
		local scale = 0.05 + (1 - 0.05) * (progress ^ 1.2) -- Easing
		
		for part, origSize in pairs(originalSize) do
			if part.Parent then
				part.Size = origSize * scale
			end
		end
		
		-- Rotação durante crescimento
		if clonedHrp.Parent then
			clonedHrp.CFrame = clonedHrp.CFrame * CFrame.Angles(
				math.rad(1),
				math.rad(2),
				math.rad(0.5)
			)
		end
		
		task.wait(0.016)
	end
	
	-- Garantir tamanho final correto
	for part, origSize in pairs(originalSize) do
		if part.Parent then
			part.Size = origSize
		end
	end
	
	print("💥 ESTRALANDO DEDOS...")
	task.wait(0.5)
	
	-- FASE 3: Efeito de snap (estralo)
	if clonedHrp.Parent then
		createLightEffect(clonedHrp.Position)
	end
	
	-- FASE 4: Desaparecer
	print("💨 Desaparecendo...")
	for i = 1, 20 do
		for _, part in pairs(clonedCharacter:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = i / 20
			end
		end
		task.wait(0.05)
	end
	
	clonedCharacter:Destroy()
	
	-- FASE 5: Overlay de congelamento
	print("❄️ CONGELANDO EVENTOS...")
	
	local freezeOverlay = Instance.new("Frame")
	freezeOverlay.Name = "FreezeOverlay"
	freezeOverlay.Size = UDim2.new(1, 0, 1, 0)
	freezeOverlay.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	freezeOverlay.BackgroundTransparency = 0.2
	freezeOverlay.BorderSizePixel = 0
	freezeOverlay.Parent = screenGui
	freezeOverlay.ZIndex = 1000
	
	-- Texto de status
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(0, 500, 0, 120)
	statusLabel.Position = UDim2.new(0.5, -250, 0.5, -60)
	statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	statusLabel.BackgroundTransparency = 0.4
	statusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
	statusLabel.TextSize = 28
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.ZIndex = 1001
	statusLabel.Parent = screenGui
	
	local statusCorner = Instance.new("UICorner")
	statusCorner.CornerRadius = UDim.new(0, 12)
	statusCorner.Parent = statusLabel
	
	local typeText = snapType == "global" and "🌍 GLOBAL" or "🖥️ SERVIDOR"
	statusLabel.Text = "⚡ SNAP " .. typeText .. " ⚡\n❄️ EVENTOS CONGELADOS"
	
	-- Timer
	local timerLabel = Instance.new("TextLabel")
	timerLabel.Name = "TimerLabel"
	timerLabel.Size = UDim2.new(0, 250, 0, 80)
	timerLabel.Position = UDim2.new(0.5, -125, 0.7, 0)
	timerLabel.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
	timerLabel.BackgroundTransparency = 0.3
	timerLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	timerLabel.TextSize = 48
	timerLabel.Font = Enum.Font.GothamBold
	timerLabel.ZIndex = 1001
	timerLabel.Parent = screenGui
	
	local timerCorner = Instance.new("UICorner")
	timerCorner.CornerRadius = UDim.new(0, 12)
	timerCorner.Parent = timerLabel
	
	-- Loop de congelamento com timer
	local freezeStart = tick()
	
	while tick() - freezeStart < FREEZE_DURATION do
		local remaining = FREEZE_DURATION - (tick() - freezeStart)
		local minutes = math.floor(remaining / 60)
		local seconds = math.floor(remaining % 60)
		
		timerLabel.Text = string.format("%02d:%02d", minutes, seconds)
		
		task.wait(0.1)
	end
	
	print("✅ EVENTOS DESCONGELADOS!")
	freezeOverlay:Destroy()
	statusLabel:Destroy()
	timerLabel:Destroy()
end

-- ============================================
-- DIÁLOGO DE ESCOLHA
-- ============================================

local function showSnapChoiceDialog()
	local choice = nil
	
	local dialog = Instance.new("Frame")
	dialog.Name = "SnapDialog"
	dialog.Size = UDim2.new(0, 400, 0, 200)
	dialog.Position = UDim2.new(0.5, -200, 0.5, -100)
	dialog.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 500
	dialog.Parent = screenGui
	
	local dialogCorner = Instance.new("UICorner")
	dialogCorner.CornerRadius = UDim.new(0, 12)
	dialogCorner.Parent = dialog
	
	local question = Instance.new("TextLabel")
	question.Size = UDim2.new(1, -20, 0, 70)
	question.Position = UDim2.new(0, 10, 0, 10)
	question.BackgroundTransparency = 1
	question.TextColor3 = Color3.fromRGB(255, 255, 255)
	question.TextSize = 18
	question.Font = Enum.Font.Gotham
	question.Text = "Deseja fazer SNAP em GLOBAL?"
	question.ZIndex = 501
	question.Parent = dialog
	
	-- Botão Global
	local globalBtn = Instance.new("TextButton")
	globalBtn.Name = "GlobalBtn"
	globalBtn.Size = UDim2.new(0, 170, 0, 60)
	globalBtn.Position = UDim2.new(0, 15, 0, 100)
	globalBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	globalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	globalBtn.TextSize = 16
	globalBtn.Font = Enum.Font.GothamBold
	globalBtn.Text = "🌍 SIM\n(GLOBAL)"
	globalBtn.BorderSizePixel = 0
	globalBtn.ZIndex = 501
	globalBtn.Parent = dialog
	
	local globalCorner = Instance.new("UICorner")
	globalCorner.CornerRadius = UDim.new(0, 8)
	globalCorner.Parent = globalBtn
	
	-- Botão Servidor
	local serverBtn = Instance.new("TextButton")
	serverBtn.Name = "ServerBtn"
	serverBtn.Size = UDim2.new(0, 170, 0, 60)
	serverBtn.Position = UDim2.new(1, -185, 0, 100)
	serverBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	serverBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	serverBtn.TextSize = 16
	serverBtn.Font = Enum.Font.GothamBold
	serverBtn.Text = "🖥️ NÃO\n(SERVIDOR)"
	serverBtn.BorderSizePixel = 0
	serverBtn.ZIndex = 501
	serverBtn.Parent = dialog
	
	local serverCorner = Instance.new("UICorner")
	serverCorner.CornerRadius = UDim.new(0, 8)
	serverCorner.Parent = serverBtn
	
	globalBtn.MouseButton1Click:Connect(function()
		choice = "global"
		dialog:Destroy()
	end)
	
	serverBtn.MouseButton1Click:Connect(function()
		choice = "server"
		dialog:Destroy()
	end)
	
	-- Esperar escolha
	while choice == nil do
		task.wait(0.05)
	end
	
	return choice
end

-- ============================================
-- EVENTOS DOS BOTÕES
-- ============================================

openButton.MouseButton1Click:Connect(function()
	mainPanel.Visible = not mainPanel.Visible
	openButton.Text = mainPanel.Visible and "Fechar" or "Abrir Painel"
end)

snapButton.MouseButton1Click:Connect(function()
	mainPanel.Visible = false
	openButton.Text = "Abrir Painel"
	
	local snapType = showSnapChoiceDialog()
	performSnapAnimation(snapType)
end)

closeButton.MouseButton1Click:Connect(function()
	mainPanel.Visible = false
	openButton.Text = "Abrir Painel"
end)

-- Hover effects
snapButton.MouseEnter:Connect(function()
	snapButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

snapButton.MouseLeave:Connect(function()
	snapButton.BackgroundColor3 = Color3.fromRGB(255, 102, 0)
end)

openButton.MouseEnter:Connect(function()
	openButton.BackgroundColor3 = Color3.fromRGB(0, 130, 180)
end)

openButton.MouseLeave:Connect(function()
	openButton.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
end)

print("✅ SCRIPT SNAP CARREGADO COM SUCESSO!")
