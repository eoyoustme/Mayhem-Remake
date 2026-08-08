game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local gameData = ReplicatedStorage:WaitForChild("GameData", 10)
local lastroom = gameData and gameData:WaitForChild("LatestRoom", 10)
local currentroom = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]

local depthsTer
pcall(function()
	depthsTer = game:GetObjects("rbxassetid://15439261945")[1]
end)

if not depthsTer then 
	warn("[Clock Script] Không thể lấy model rbxassetid://15439261945!")
	return 
end

depthsTer.Name = "AnnoyingClock"
depthsTer.Parent = Workspace

local grandfatherClocks = {}
for _, v in ipairs(currentroom:GetDescendants()) do
	if v:IsA("Model") and v.Name == "Grandfather_Clock" then
		table.insert(grandfatherClocks, v)
	end
end

if #grandfatherClocks > 0 then
	local targetClock = grandfatherClocks[math.random(1, #grandfatherClocks)]
	local clockCFrame = targetClock:GetPivot()

	targetClock:Destroy()
	depthsTer:PivotTo(clockCFrame)
else
	if character and character:FindFirstChild("HumanoidRootPart") then
		depthsTer:PivotTo(character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
	end
end

local promptPart = depthsTer:FindFirstChild("Base", true) or depthsTer.PrimaryPart or depthsTer:FindFirstChildWhichIsA("BasePart")
if not promptPart then
	promptPart = Instance.new("Part")
	promptPart.Size = Vector3.new(2, 2, 2)
	promptPart.Transparency = 1
	promptPart.CanCollide = false
	promptPart.Position = depthsTer:GetPivot().Position
	promptPart.Parent = depthsTer
	depthsTer.PrimaryPart = promptPart
end

local prompt = Instance.new("ProximityPrompt")
prompt.ObjectText = "I don't think this is a clock"
prompt.ActionText = "Clock"
prompt.HoldDuration = 1.5
prompt.MaxActivationDistance = 20
prompt.Style = Enum.ProximityPromptStyle.Custom 
prompt.RequiresLineOfSight = false 
prompt.Parent = promptPart

local clockActive = true
local roomConnection = nil

-- Các Effect âm thanh & hình ảnh
local clockSound = Instance.new("Sound")
clockSound.SoundId = "rbxassetid://4940109913"
clockSound.Looped = true
clockSound.Volume = 0
clockSound.Parent = Workspace

local distortion = Instance.new("DistortionSoundEffect")
distortion.Level = 0
distortion.Parent = clockSound

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local function cleanup()
	if not clockActive then return end
	clockActive = false

	if roomConnection then
		roomConnection:Disconnect()
		roomConnection = nil
	end

	if blur then blur:Destroy() end
	if clockSound then clockSound:Destroy() end
	if humanoid and humanoid.Parent then
		humanoid.WalkSpeed = 15
	end
	if depthsTer then depthsTer:Destroy() end
end

prompt.Triggered:Connect(function()
	cleanup()
end)

if lastroom then
	roomConnection = lastroom.Changed:Connect(function()
		cleanup()
	end)
end

task.spawn(function()
	if not lastroom then return end

	local roomTimer = 0
	local currentRoomValue = lastroom.Value

	while clockActive do
		task.wait(1)

		if lastroom.Value == currentRoomValue then
			roomTimer = roomTimer + 1
		else
			break
		end

		if roomTimer >= 60 then
			break
		end
	end

	if clockActive and roomTimer >= 60 then
		clockSound:Play()

		local attackDuration = 30 

		TweenService:Create(clockSound, TweenInfo.new(attackDuration, Enum.EasingStyle.Linear), {Volume = 10}):Play()
		TweenService:Create(distortion, TweenInfo.new(attackDuration, Enum.EasingStyle.Linear), {Level = 1}):Play()
		TweenService:Create(blur, TweenInfo.new(attackDuration, Enum.EasingStyle.Linear), {Size = 100}):Play()

		local startSpeed = humanoid.WalkSpeed
		local elapsed = 0

		while elapsed < attackDuration and clockActive do
			task.wait(0.1)
			elapsed = elapsed + 0.1
			if humanoid then
				humanoid.WalkSpeed = math.max(0, startSpeed * (1 - (elapsed / attackDuration)))
			end
		end

		-- Hết 30s nếu chưa tắt đồng hồ và chưa mở cửa -> Player chết
		if clockActive and humanoid and humanoid.Health > 0 then
			humanoid.Health = 0
			cleanup()
		end
	end
end)
