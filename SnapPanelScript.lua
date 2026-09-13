-- Script Luau para Roblox - Painel com botão SNAP com animação épica
-- Coloque este script em StarterGui > ScreenGui

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

-- Adicionar cantos arredondados ao botão de abertura
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

-- Painel Principal (inicialmente oculto)
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 400, 0, 300)
mainPanel.Position = UDim2.new(0.5, -200, 0.5, -150)
mainPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui

-- Cantos arredondados no painel
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = mainPanel

-- Sombra do painel
local panelShadow = Instance.new("UIStroke")
panelShadow.Color = Color3.fromRGB(0, 0, 0)
panelShadow.Thickness = 2
panelShadow.Parent = mainPanel

-- Título do Painel
local panelTitle = Instance.new("TextLabel")
panelTitle.Name = "Title"
panelTitle.Size = UDim2.new(1, 0, 0, 50)
panelTitle.Position = UDim2.new(0, 0, 0, 0)
panelTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
panelTitle.TextSize = 20
panelTitle.Font = Enum.Font.GothamBold
panelTitle.Text = "PAINEL SNAP"
panelTitle.BorderSizePixel = 0
panelTitle.Parent = mainPanel

-- Cantos arredondados no título
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = panelTitle

-- Botão SNAP Grande
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

-- Cantos arredondados no botão SNAP
local snapCorner = Instance.new("UICorner")
snapCorner.CornerRadius = UDim.new(0, 10)
snapCorner.Parent = snapButton

-- Botão de Fechar
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

-- Cantos arredondados no botão fechar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- ============================================
-- SONS (IDs do Roblox)
-- ============================================

local SNAP_SOUND_ID = "rbxassetid://1841228868" -- Som clássico de snap
local THANOS_SOUND = "rbxassetid://6518811441" -- Som épico
local SNAP_CRACK = "rbxassetid://7384185988" -- Estralo

-- ============================================
-- FUNÇÃO DE ANIMAÇÃO ÉPICA DO SNAP
-- ============================================

local function playSnapAnimation(snapType)
	print("🔵 INICIANDO ANIMAÇÃO DO SNAP: " .. snapType)
	
	-- Carregar o modelo do jogador
	local targetPlayer = Players:FindFirstChild("los_tralaleritos778")
	if not targetPlayer or not targetPlayer.Character then
		print("⚠️ Jogador não encontrado!")
		return
	end
	
	local character = targetPlayer.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	
	if not humanoidRootPart then
		print("⚠️ HumanoidRootPart não encontrado!")
		return
	end
	
	-- Criar uma cópia do personagem para a animação
	local animCharacter = character:Clone()
	animCharacter.Name = "SnapClone"
	animCharacter.Parent = workspace
	
	-- Remover scripts desnecessários
	for _, child in pairs(animCharacter:GetDescendants()) do
		if child:IsA("Script") or child:IsA("LocalScript") then
			child:Destroy()
		end
	end
	
	-- Desabilitar Humanoid para evitar comportamentos estranhos
	local humanoid = animCharacter:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Health = 0
	end
	
	-- Posicionar na câmera
	local camera = workspace.CurrentCamera
	local cameraPosition = camera.CFrame.Position + camera.CFrame.LookVector * 20
	
	if animCharacter:FindFirstChild("HumanoidRootPart") then
		animCharacter:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(cameraPosition)
	end
	
	-- FASE 1: Personagem pequeno aparecendo (0-1 segundo)
	local startSize = Vector3.new(0.1, 0.1, 0.1)
	local startTime = tick()
	
	for _, part in pairs(animCharacter:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Size = startSize
		end
	end
	
	-- Animar crescimento
	local growthStartTime = tick()
	local growthDuration = 2.5
	
	while tick() - growthStartTime < growthDuration do
		local progress = (tick() - growthStartTime) / growthDuration
		local scale = 0.1 + (1 - 0.1) * progress -- De 0.1 para 1
		
		-- Animar escala
		for _, part in pairs(animCharacter:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Size = startSize * (scale / 0.1)
			end
		end
		
		-- Animar posição (subindo para o centro)
		if animCharacter:FindFirstChild("HumanoidRootPart") then
			local hrp = animCharacter:FindFirstChild("HumanoidRootPart")
			local targetHeight = cameraPosition + Vector3.new(0, scale * 8, 0)
			hrp.CFrame = CFrame.new(targetHeight) * CFrame.Angles(
				math.rad(progress * 20),
				math.rad(progress * 30),
				math.rad(progress * 15)
			)
		end
		
		task.wait(0.016) -- 60 FPS
	end
	
	-- FASE 2: Atingir tamanho máximo (gigante)
	task.wait(0.5)
	
	-- FASE 3: ESTRALO DE DEDOS + EFEITOS
	print("💥 ESTRALANDO DEDOS!")
	
	-- Criar efeito de estralo (partículas/luz)
	local snapEffect = Instance.new("Part")
	snapEffect.Name = "SnapEffect"
	snapEffect.Shape = Enum.PartType.Ball
	snapEffect.Size = Vector3.new(5, 5, 5)
	snapEffect.CanCollide = false
	snapEffect.CFrame = animCharacter:FindFirstChild("HumanoidRootPart").CFrame
	snapEffect.Material = Enum.Material.Neon
	snapEffect.BrickColor = BrickColor.new("Cyan")
	snapEffect.Parent = workspace
	
	-- Som do estralo
	local snapSound = Instance.new("Sound")
	snapSound.SoundId = SNAP_CRACK
	snapSound.Volume = 1
	snapSound.Parent = snapEffect
	snapSound:Play()
	
	-- Luz de efeito
	local light = Instance.new("PointLight")
	light.Brightness = 3
	light.Range = 50
	light.Color = Color3.fromRGB(0, 200, 255)
	light.Parent = snapEffect
	
	-- Expansão do efeito
	for i = 1, 20 do
		snapEffect.Size = snapEffect.Size + Vector3.new(2, 2, 2)
		snapEffect.Transparency = i / 20
		task.wait(0.05)
	end
	
	snapEffect:Destroy()
	
	-- FASE 4: Efeitos visuais na tela (congelamento)
	print("❄️ EVENTOS CONGELADOS POR 5 MINUTOS!")
	
	-- Criar overlay de congelamento
	local freezeFrame = Instance.new("Frame")
	freezeFrame.Name = "FreezeOverlay"
	freezeFrame.Size = UDim2.new(1, 0, 1, 0)
	freezeFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
	freezeFrame.BackgroundTransparency = 0.3
	freezeFrame.BorderSizePixel = 0
	freezeFrame.Parent = screenGui
	freezeFrame.ZIndex = 100
	
	-- Texto de status
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(0, 400, 0, 100)
	statusLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
	statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	statusLabel.BackgroundTransparency = 0.5
	statusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
	statusLabel.TextSize = 24
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.Text = "⚡ SNAP ATIVADO! ⚡"
	statusLabel.ZIndex = 101
	statusLabel.Parent = screenGui
	
	local statusCorner = Instance.new("UICorner")
	statusCorner.CornerRadius = UDim.new(0, 12)
	statusCorner.Parent = statusLabel
	
	-- Determinar tipo de snap
	local snapTypeText = snapType == "global" and "🌍 GLOBAL" or "🖥️ SERVIDOR"
	statusLabel.Text = "⚡ SNAP " .. snapTypeText .. " ⚡\n❄️ EVENTOS PAUSADOS 5 MIN"
	
	-- Remover o personagem após 1 segundo
	task.wait(1)
	animCharacter:Destroy()
	
	-- CONGELAR EVENTOS POR 5 MINUTOS
	local freezeDuration = 5 * 60 -- 5 minutos em segundos
	local freezeStartTime = tick()
	
	-- Animar contador regressivo
	local timerLabel = Instance.new("TextLabel")
	timerLabel.Name = "TimerLabel"
	timerLabel.Size = UDim2.new(0, 200, 0, 60)
	timerLabel.Position = UDim2.new(0.5, -100, 0.3, 0)
	timerLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	timerLabel.BackgroundTransparency = 0.5
	timerLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	timerLabel.TextSize = 32
	timerLabel.Font = Enum.Font.GothamBold
	timerLabel.ZIndex = 102
	timerLabel.Parent = screenGui
	
	local timerCorner = Instance.new("UICorner")
	timerCorner.CornerRadius = UDim.new(0, 12)
	timerCorner.Parent = timerLabel
	
	-- Loop do congelamento
	while tick() - freezeStartTime < freezeDuration do
		local remainingTime = freezeDuration - (tick() - freezeStartTime)
		local minutes = math.floor(remainingTime / 60)
		local seconds = math.floor(remainingTime % 60)
		
		timerLabel.Text = string.format("%02d:%02d", minutes, seconds)
		
		task.wait(0.1)
	end
	
	-- Descongelar após 5 minutos
	print("✅ EVENTOS DESCONGELADOS!")
	freezeFrame:Destroy()
	statusLabel:Destroy()
	timerLabel:Destroy()
	
	-- Enviar evento para servidor se for global
	if snapType == "global" then
		print("🌍 Enviando SNAP para GLOBAL")
		-- Aqui você pode enviar para RemoteEvent
		-- game:GetService("ReplicatedStorage"):WaitForChild("SnapEvent"):FireServer("global")
	else
		print("🖥️ Enviando SNAP para SERVIDOR")
		-- game:GetService("ReplicatedStorage"):WaitForChild("SnapEvent"):FireServer("server")
	end
end

-- ============================================
-- FUNÇÃO DE DIÁLOGO DE ESCOLHA
-- ============================================

local function showChoiceDialog()
	local choice = nil
	
	-- Criar diálogo
	local dialog = Instance.new("Frame")
	dialog.Name = "ChoiceDialog"
	dialog.Size = UDim2.new(0, 350, 0, 200)
	dialog.Position = UDim2.new(0.5, -175, 0.5, -100)
	dialog.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	dialog.BorderSizePixel = 0
	dialog.Parent = screenGui
	dialog.ZIndex = 50
	
	local dialogCorner = Instance.new("UICorner")
	dialogCorner.CornerRadius = UDim.new(0, 12)
	dialogCorner.Parent = dialog
	
	-- Texto da pergunta
	local questionLabel = Instance.new("TextLabel")
	questionLabel.Size = UDim2.new(1, -20, 0, 60)
	questionLabel.Position = UDim2.new(0, 10, 0, 10)
	questionLabel.BackgroundTransparency = 1
	questionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	questionLabel.TextSize = 16
	questionLabel.Font = Enum.Font.Gotham
	questionLabel.Text = "Deseja fazer SNAP em GLOBAL?"
	questionLabel.ZIndex = 51
	questionLabel.Parent = dialog
	
	-- Botão SIM
	local yesButton = Instance.new("TextButton")
	yesButton.Name = "YesButton"
	yesButton.Size = UDim2.new(0, 140, 0, 50)
	yesButton.Position = UDim2.new(0, 20, 1, -70)
	yesButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
	yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	yesButton.TextSize = 18
	yesButton.Font = Enum.Font.GothamBold
	yesButton.Text = "SIM (Global)"
	yesButton.BorderSizePixel = 0
	yesButton.ZIndex = 51
	yesButton.Parent = dialog
	
	local yesCorner = Instance.new("UICorner")
	yesCorner.CornerRadius = UDim.new(0, 8)
	yesCorner.Parent = yesButton
	
	-- Botão NÃO
	local noButton = Instance.new("TextButton")
	noButton.Name = "NoButton"
	noButton.Size = UDim2.new(0, 140, 0, 50)
	noButton.Position = UDim2.new(1, -160, 1, -70)
	noButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	noButton.TextSize = 18
	noButton.Font = Enum.Font.GothamBold
	noButton.Text = "NÃO (Servidor)"
	noButton.BorderSizePixel = 0
	noButton.ZIndex = 51
	noButton.Parent = dialog
	
	local noCorner = Instance.new("UICorner")
	noCorner.CornerRadius = UDim.new(0, 8)
	noCorner.Parent = noButton
	
	-- Conectar eventos dos botões
	yesButton.MouseButton1Click:Connect(function()
		choice = "global"
		dialog:Destroy()
	end)
	
	noButton.MouseButton1Click:Connect(function()
		choice = "server"
		dialog:Destroy()
	end)
	
	-- Esperar até que uma escolha seja feita
	while choice == nil do
		task.wait(0.1)
	end
	
	return choice
end

-- ============================================
-- EVENTOS DOS BOTÕES
-- ============================================

-- Evento do botão de abertura
openButton.MouseButton1Click:Connect(function()
	mainPanel.Visible = not mainPanel.Visible
	openButton.Text = mainPanel.Visible and "Fechar" or "Abrir Painel"
end)

-- Evento do botão SNAP
snapButton.MouseButton1Click:Connect(function()
	mainPanel.Visible = false
	openButton.Text = "Abrir Painel"
	local snapType = showChoiceDialog()
	playSnapAnimation(snapType)
end)

-- Evento do botão fechar
closeButton.MouseButton1Click:Connect(function()
	mainPanel.Visible = false
	openButton.Text = "Abrir Painel"
end)

-- ============================================
-- ANIMAÇÕES DOS BOTÕES
-- ============================================

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

print("✅ Script de Snap Painel ÉPICO carregado com sucesso!")
