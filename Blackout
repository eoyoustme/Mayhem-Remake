game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
local static = Instance.new("Sound")
static.SoundId = "rbxassetid://18870782376"
static.Parent = game.Workspace
static.Name = "Se"
static.Pitch = 0.6
static.Volume = 1.5
static.TimePosition = 1.6
static:Play()

local player = game.Players.LocalPlayer
local GUI = Instance.new("ScreenGui")
GUI.Name = "WarningGui"
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.IgnoreGuiInset = true
GUI.Parent = player:WaitForChild("PlayerGui")

local Image = Instance.new("ImageLabel")
Image.BackgroundColor3 = Color3.fromRGB(255,255,255)
Image.BackgroundTransparency = 1
Image.Size = UDim2.new(1,0,1,0)
Image.Image = "rbxassetid://15815325811" 
Image.ImageTransparency = 0
Image.Parent = GUI

local standStillTime = 7
local moveDetected = false
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

wait(1.4)

for i = 1, standStillTime * 10 do
	task.wait(0.1)
	if humanoid.MoveDirection.Magnitude > 0 then
		moveDetected = true
		break
	end
end

if moveDetected then
	if GUI and GUI.Parent then
		GUI:Destroy()
	end

	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local rng = Random.new()

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "JumpscareGui"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 999999
	screenGui.Parent = playerGui

	-- Tạo background
	local background = Instance.new("Frame")
	background.Name = "Background"
	background.Size = UDim2.fromScale(1, 1)
	background.Position = UDim2.fromScale(0, 0)
	background.BackgroundColor3 = Color3.new(0, 0, 0)
	background.BorderSizePixel = 0
	background.Parent = screenGui

	-- Tạo ImageLabel
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "ImageLabel"
	imageLabel.BackgroundTransparency = 1
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel.Size = UDim2.new(0, 0.001, 0, 0.001)
	imageLabel.Image = "rbxassetid://105547303105753"
	imageLabel.Parent = background

	-- Tạo Sound
	local jumpscareSound = Instance.new("Sound")
	jumpscareSound.Name = "Jumpscare"
	jumpscareSound.SoundId = "rbxassetid://18564431123"
	jumpscareSound.Volume = 10
	jumpscareSound.PlaybackSpeed = 0.8
	jumpscareSound.Parent = workspace

	local pitch = Instance.new("PitchShiftSoundEffect")
	pitch.Octave = 0.62
	pitch.Enabled = true
	pitch.Parent = jumpscareSound

	jumpscareSound:Play()

	local fullTween = TweenService:Create(
		imageLabel,
		TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
		{
			Size = UDim2.new(0, 1250, 0, 1250)
		}
	)

	fullTween:Play()

	for i = 1, 140 do
		local mode = rng:NextInteger(1, 3)

		if mode == 1 then
			background.BackgroundColor3 = Color3.new(0, 0, 0)
			imageLabel.ImageColor3 = Color3.new(1, 1, 1)
		elseif mode == 2 then
			background.BackgroundColor3 = Color3.new(0, 0, 0)
			imageLabel.ImageColor3 = Color3.new(0, 0, 0)
		else
			background.BackgroundColor3 = Color3.new(1, 1, 1)
			imageLabel.ImageColor3 = Color3.new(1, 1, 1)
		end
		
		imageLabel.Position = UDim2.new(rng:NextNumber(0.4, 0.6), 0, rng:NextNumber(0.4, 0.6), 0)

		imageLabel.Rotation = rng:NextInteger(-30, 30)
		task.wait(0)
	end


	screenGui:Destroy()
	imageLabel:Destroy()
	background:Destroy()
	humanoid:TakeDamage(20)
	static:Destroy()

	local stats = game.ReplicatedStorage:FindFirstChild("GameStats")
	if stats then
		local deathCause = stats:FindFirstChild("Player_".. player.Name)
		if deathCause then
			deathCause.Total.DeathCause.Value = "Blackout"
		end
	end

	firesignal(game.ReplicatedStorage.RemotesFolder.DeathHint.OnClientEvent,
		{"You died to who you call Blackout.", "Try your best to not move at all.", "He can sense you with sound."},
		"Yellow"
	)

	-- Xoá GUI jumpscare sau khi chết
	humanoid.Died:Connect(function()
	end)
else
	task.wait(1)
	if GUI and GUI.Parent then
		GUI:Destroy()
	end
end
