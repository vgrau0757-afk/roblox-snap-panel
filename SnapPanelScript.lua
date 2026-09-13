-- SNAP PANEL SCRIPT - ROBLOX LUAU
-- LocalScript em StarterGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- ==========================================
-- CRIAR GUI
-- ==========================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SnapGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- BOTÃO ABRIR
local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(0, 100, 0, 50)
openBtn.Position = UDim2.new(1, -120, 0, 10)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.TextSize = 14
openBtn.Font = Enum.Font.GothamBold
openBtn.Text = "PAINEL"
openBtn.BorderSizePixel = 0
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openBtn

-- PAINEL
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 350, 0, 280)
panel.Position = UDim2.new(0.5, -175, 0.5, -140)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 100
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

-- BOTÃO SNAP
local snapBtn = Instance.new("TextButton")
snapBtn.Name = "SnapBtn"
snapBtn.Size = UDim2.new(0, 280, 0, 80)
snapBtn.Position = UDim2.new(0.5, -140, 0.5, -40)
snapBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
snapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
snapBtn.TextSize = 36
snapBtn.Font = Enum.Font.GothamBold
snapBtn.Text = "SNAP"
snapBtn.BorderSizePixel = 0
snapBtn.ZIndex = 101
snapBtn.Parent = panel

local snapCorner = Instance.new("UICorner")
snapCorner.CornerRadius = UDim.new(0, 10)
snapCorner.Parent = snapBtn

-- ==========================================
-- FUNÇÃO PARA ACHAR JOGADOR
-- ==========================================

local function findPlayer(targetName)
	-- Opção 1: Procurar nome exato
	local exactMatch = Players:FindFirstChild(targetName)
	if exactMatch and exactMatch.Character then
		return exactMatch
	end
	
	-- Opção 2: Procurar por parte do nome
	for _, p in pairs(Players:GetPlayers()) do
		if string.find(p.Name:lower(), targetName:lower()) then
			if p.Character then
				return p
			end
		end
	end
	
	-- Opção 3: Se não achar, retorna nil
	return nil
end

-- ==========================================
-- FUNÇÃO PARA MOSTRAR MENSAGEM
-- ==========================================

local function showMessage(text, color)
	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(0, 400, 0, 80)
	msg.Position = UDim2.new(0.5, -200, 0.5, -40)
	msg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	msg.BackgroundTransparency = 0.3
	msg.TextColor3 = color
	msg.TextSize = 18
	msg.Font = Enum.Font.Gotham
	msg.Text = text
	msg.ZIndex = 2000
	msg.Parent = screenGui
	
	local msgCorner = Instance.new("UICorner")
	msgCorner.CornerRadius = UDim.new(0, 12)
	msgCorner.Parent = msg
	
	task.wait(3)
	msg:Destroy()
end

-- ==========================================
-- FUNÇÃO SNAP
-- ==========================================

local function doSnap()
	print("INICIANDO SNAP")
	
	-- Procurar jogador
	local targetPlayer = findPlayer("los_tralaleritos778")
	
	local char
	local hrp
	
	if targetPlayer and targetPlayer.Character then
		print("✅ Jogador encontrado: " .. targetPlayer.Name)
		char = targetPlayer.Character
		hrp = char:FindFirstChild("HumanoidRootPart")
		
		if not hrp then
			print("⚠️ Jogador sem HumanoidRootPart")
			showMessage("❌ Jogador sem HumanoidRootPart!", Color3.fromRGB(255, 0, 0))
			return
		end
	else
		print("⚠️ Jogador não encontrado! Criando SNAP genérico...")
		showMessage("⚠️ Jogador offline! Criando SNAP fantasma...", Color3.fromRGB(255, 200, 0))
		
		-- Criar um "boneco fantasma" genérico para o snap
		char = Instance.new("Model")
		char.Name = "SnapFantasma"
		
		hrp = Instance.new("Part")
		hrp.Name = "HumanoidRootPart"
		hrp.Shape = Enum.PartType.Ball
		hrp.Size = Vector3.new(2, 2, 2)
		hrp.CanCollide = false
		hrp.Material = Enum.Material.Neon
		hrp.BrickColor = BrickColor.new("Cyan")
		hrp.TopSurface = Enum.SurfaceType.Smooth
		hrp.BottomSurface = Enum.SurfaceType.Smooth
		hrp.Parent = char
		
		char.Parent = workspace
	end
	
	-- CLONAR PERSONAGEM
	local clone = char:Clone()
	clone.Parent = workspace
	
	-- Remover humanoid se existir
	if clone:FindFirstChild("Humanoid") then
		clone.Humanoid:Destroy()
	end
	
	-- Posicionar na câmera
	local cloneHrp = clone:FindFirstChild("HumanoidRootPart")
	if not cloneHrp then
		print("❌ Clone não tem HumanoidRootPart")
		clone:Destroy()
		return
	end
	
	local pos = camera.CFrame.Position + camera.CFrame.LookVector * 20
	cloneHrp.CFrame = CFrame.new(pos)
	
	-- SALVAR TAMANHO ORIGINAL
	local sizes = {}
	for _, part in pairs(clone:GetDescendants()) do
		if part:IsA("BasePart") then
			sizes[part] = part.Size
			part.Size = part.Size * 0.1
		end
	end
	
	-- CRESCIMENTO
	print("📈 Crescendo...")
	local t0 = tick()
	while tick() - t0 < 2.5 do
		local prog = (tick() - t0) / 2.5
		local scale = 0.1 + (1 - 0.1) * prog
		
		for part, origSize in pairs(sizes) do
			if part.Parent then
				part.Size = origSize * scale
			end
		end
		
		task.wait(0.016)
	end
	
	-- Garantir tamanho final
	for part, origSize in pairs(sizes) do
		if part.Parent then
			part.Size = origSize
		end
	end
	
	task.wait(0.5)
	
	-- ESTRALO
	print("💥 ESTRALANDO!")
	local effect = Instance.new("Part")
	effect.Shape = Enum.PartType.Ball
	effect.Size = Vector3.new(2, 2, 2)
	effect.CanCollide = false
	effect.CFrame = cloneHrp.CFrame
	effect.Material = Enum.Material.Neon
	effect.BrickColor = BrickColor.new("Cyan")
	effect.Parent = workspace
	
	local light = Instance.new("PointLight")
	light.Brightness = 8
	light.Range = 100
	light.Color = Color3.fromRGB(0, 200, 255)
	light.Parent = effect
	
	-- Som estralo
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://7384185988"
	sound.Volume = 1
	sound.Parent = effect
	sound:Play()
	
	-- Expandir efeito
	for i = 1, 40 do
		effect.Size = effect.Size + Vector3.new(2, 2, 2)
		effect.Transparency = i / 40
		task.wait(0.02)
	end
	effect:Destroy()
	
	-- Desaparecer clone
	for i = 1, 20 do
		for _, part in pairs(clone:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = i / 20
			end
		end
		task.wait(0.05)
	end
	
	clone:Destroy()
	
	-- CONGELAMENTO
	print("❄️ CONGELADO POR 5 MIN")
	
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	overlay.BackgroundTransparency = 0.25
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 1000
	overlay.Parent = screenGui
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 300, 0, 100)
	label.Position = UDim2.new(0.5, -150, 0.5, -50)
	label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	label.BackgroundTransparency = 0.5
	label.TextColor3 = Color3.fromRGB(0, 255, 255)
	label.TextSize = 24
	label.Font = Enum.Font.GothamBold
	label.Text = "⚡ EVENTOS CONGELADOS ⚡"
	label.ZIndex = 1001
	label.Parent = screenGui
	
	local labelCorner = Instance.new("UICorner")
	labelCorner.CornerRadius = UDim.new(0, 12)
	labelCorner.Parent = label
	
	local timer = Instance.new("TextLabel")
	timer.Size = UDim2.new(0, 200, 0, 60)
	timer.Position = UDim2.new(0.5, -100, 0.65, 0)
	timer.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
	timer.BackgroundTransparency = 0.4
	timer.TextColor3 = Color3.fromRGB(255, 0, 0)
	timer.TextSize = 40
	timer.Font = Enum.Font.GothamBold
	timer.ZIndex = 1001
	timer.Parent = screenGui
	
	local timerCorner = Instance.new("UICorner")
	timerCorner.CornerRadius = UDim.new(0, 12)
	timerCorner.Parent = timer
	
	local inicio = tick()
	while tick() - inicio < 300 do
		local restante = 300 - (tick() - inicio)
		local min = math.floor(restante / 60)
		local seg = math.floor(restante % 60)
		timer.Text = string.format("%02d:%02d", min, seg)
		task.wait(0.1)
	end
	
	overlay:Destroy()
	label:Destroy()
	timer:Destroy()
	
	print("✅ DESCONGELADO!")
end

-- ==========================================
-- EVENTOS
-- ==========================================

openBtn.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
	openBtn.Text = panel.Visible and "FECHAR" or "PAINEL"
end)

snapBtn.MouseButton1Click:Connect(function()
	panel.Visible = false
	openBtn.Text = "PAINEL"
	doSnap()
end)

snapBtn.MouseEnter:Connect(function()
	snapBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
end)

snapBtn.MouseLeave:Connect(function()
	snapBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
end)

print("✅ SNAP SCRIPT CARREGADO - PRONTO PARA SNAP!")
