local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ===== CRUCIFIX SYSTEM =====
local RepentanceUrl = "https://github.com/RegularVynixu/DOORS-Entity-Spawner-V2/raw/main/Assets/Repentance.rbxm"
local SpecialUrl = "https://github.com/eoyoustme/Mayhem-Remake/raw/main/Repenction.rbxm"

local function tweenBeamTransparency(beam, targetValue, duration)
	if not beam or not beam:IsA("Beam") then return end

	local numVal = Instance.new("NumberValue")
	numVal.Value = 0

	local connection = numVal.Changed:Connect(function(val)
		if beam and beam.Parent then
			beam.Transparency = NumberSequence.new(val)
		end
	end)

	local tween = TweenService:Create(numVal, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Value = targetValue })
	tween:Play()

	tween.Completed:Connect(function()
		connection:Disconnect()
		numVal:Destroy()
	end)
end

local function getgithubmodeL(url)
	if not (writefile and getcustomasset and request) then return nil end
	local fileName = string.match(url, "([^/]+)$") or "temp_model.rbxm"
	local response = request({Url = url, Method = "GET"})
	if response.StatusCode ~= 200 then return nil end
	writefile(fileName, response.Body)
	local assetId = getcustomasset(fileName)
	local success, result = pcall(function() return game:GetObjects(assetId)[1] end)
	return success and result or nil
end

local function executeCrucifixion(entityModel, targetPart, crucifixTool)
	if crucifixTool then crucifixTool:Destroy() end
	local repentanceAsset = getgithubmodeL(RepentanceUrl)
	if not repentanceAsset then
		if entityModel then entityModel:Destroy() end
		return
	end

	local player = Players.LocalPlayer
	local char = player.Character
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	local camera = Workspace.CurrentCamera
	if not rootPart then
		if entityModel then entityModel:Destroy() end
		repentanceAsset:Destroy()
		return
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {char, entityModel, repentanceAsset}
	local rayResult = workspace:Raycast(targetPart.Position, Vector3.new(0, -1000, 0), rayParams)
	local groundPos = rayResult and rayResult.Position or (targetPart.Position - Vector3.new(0, 3, 0))

	repentanceAsset:PivotTo(CFrame.new(groundPos))
	repentanceAsset.Parent = workspace

	local crucifixPart = repentanceAsset:FindFirstChild("Crucifix")
	local entityPart = repentanceAsset:FindFirstChild("Entity") or targetPart

	local sound = crucifixPart and (crucifixPart:FindFirstChild("Sound") or crucifixPart:FindFirstChildWhichIsA("Sound"))
	if sound then sound:Play() end

	if crucifixPart then
		crucifixPart.CFrame = camera.CFrame * CFrame.new(0, 0, -3)
		local bodyPos = crucifixPart:FindFirstChild("BodyPosition")
		if bodyPos then bodyPos.Position = (rootPart.CFrame * CFrame.new(0.5, 2, -5)).Position end

		local bodyAngular = crucifixPart:FindFirstChild("BodyAngularVelocity")
		if bodyAngular then
			TweenService:Create(bodyAngular, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { AngularVelocity = Vector3.new(0, 30, 0) }):Play()
		end
	end

	if targetPart and entityPart then
		TweenService:Create(targetPart, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = entityPart.CFrame }):Play()
	end

	task.wait(2)
	if targetPart then
		TweenService:Create(targetPart, TweenInfo.new(2.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), { CFrame = targetPart.CFrame - Vector3.new(0, 25, 0) }):Play()
	end

	task.wait(2.5)
	if crucifixPart then
		TweenService:Create(crucifixPart, TweenInfo.new(1), { Size = crucifixPart.Size * 2, Transparency = 1 }):Play()
	end

	task.wait(1)
	if entityModel then entityModel:Destroy() end
	if repentanceAsset then repentanceAsset:Destroy() end
end

local function SpecialCrucifixion(entityModel, targetPart, crucifixTool)
	local repentanceAsset = getgithubmodeL(SpecialUrl)
	if not repentanceAsset then
		if entityModel then entityModel:Destroy() end
		return
	end

	local player = Players.LocalPlayer
	local char = player.Character
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	local camera = Workspace.CurrentCamera
	if not rootPart then
		if entityModel then entityModel:Destroy() end
		repentanceAsset:Destroy()
		return
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {char, entityModel, repentanceAsset}
	local rayResult = workspace:Raycast(targetPart.Position, Vector3.new(0, -1000, 0), rayParams)
	local groundPos = rayResult and rayResult.Position or (targetPart.Position - Vector3.new(0, 3, 0))

	repentanceAsset:PivotTo(CFrame.new(groundPos))
	repentanceAsset.Parent = workspace

	if repentanceAsset:FindFirstChild("Entity") and repentanceAsset.Entity:FindFirstChild("ChainEnd") then
		repentanceAsset.Entity.ChainEnd.Parent = targetPart
	end

	local clonedBeams = {} 
	local pentagram = repentanceAsset:FindFirstChild("Pentagram")
	if pentagram then
		local beamChain = pentagram:FindFirstChild("BeamChain", true) or pentagram:FindFirstChild("BeamChain")
		if beamChain then
			local overlapParams = OverlapParams.new()
			overlapParams.FilterType = Enum.RaycastFilterType.Exclude
			overlapParams.FilterDescendantsInstances = {char, entityModel, repentanceAsset}

			local leftParts = {}
			local rightParts = {}
			local foundParts = workspace:GetPartBoundsInRadius(groundPos, 40, overlapParams)
			local centerCF = rootPart.CFrame

			for _, p in ipairs(foundParts) do
				if p:IsA("BasePart") then
					local relPos = centerCF:PointToObjectSpace(p.Position)
					if relPos.X < -1 then
						table.insert(leftParts, p)
					elseif relPos.X > 1 then
						table.insert(rightParts, p)
					end
				end
			end

			local chosenLeft = #leftParts > 0 and leftParts[math.random(1, #leftParts)] or foundParts[1]
			local chosenRight = #rightParts > 0 and rightParts[math.random(1, #rightParts)] or foundParts[#foundParts]

			local targets = {
				{part = chosenLeft, side = "Left"},
				{part = chosenRight, side = "Right"}
			}

			for _, targetInfo in ipairs(targets) do
				local targetP = targetInfo.part
				if targetP and targetP:IsA("BasePart") then
					local beamClone = beamChain:Clone()
					local newAttachment = Instance.new("Attachment")
					newAttachment.Name = "BeamChainAttachment_" .. targetInfo.side
					newAttachment.Parent = targetP

					if beamClone:IsA("Beam") then
						beamClone.Attachment0 = newAttachment
					end

					beamClone.Parent = targetP

					table.insert(clonedBeams, {
						beam = beamClone,
						originPart = targetP
					})
				end
			end
		end
	end

	local crucifixPart = repentanceAsset:FindFirstChild("Crucifix")
	local entityPart = repentanceAsset:FindFirstChild("Entity") or targetPart

	local sound = crucifixPart and (crucifixPart:FindFirstChild("Sound") or crucifixPart:FindFirstChildWhichIsA("Sound"))
	if sound then sound:Play()
		sound.Parent = workspace 
		sound.Ended:Connect(function() sound:Destroy() end)
	end
	local bodyAngular = crucifixPart and crucifixPart:FindFirstChild("BodyAngularVelocity")
	if crucifixPart then
		crucifixPart.CFrame = camera.CFrame * CFrame.new(0, 0, -3)
		local bodyPos = crucifixPart:FindFirstChild("BodyPosition")
		if bodyPos then bodyPos.Position = (rootPart.CFrame * CFrame.new(0.5, 2, -5)).Position end

		if bodyAngular then
			TweenService:Create(bodyAngular, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { AngularVelocity = Vector3.new(0, 30, 0) }):Play()
		end
	end

	local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
	local cam = workspace.CurrentCamera
	local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
		cam.CFrame = cam.CFrame * shakeCf
	end)
	camShake:Start()
	camShake:ShakeOnce(10, 5, 3.5, 3.5, 3.5, 4)

	local centerParts = {} 

	task.wait(2.5)
	if crucifixPart then
		if crucifixPart:FindFirstChild("Light") then
			TweenService:Create(crucifixPart.Light, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Range = 60 , Brightness = 10 }):Play()
			crucifixPart.Light.Enabled = true
		end

		if bodyAngular then bodyAngular:Destroy() end
		TweenService:Create(crucifixPart, TweenInfo.new(1), { Size = crucifixPart.Size * 2, Transparency = 1 }):Play()

		task.spawn(function()
			targetPart.Scream:Play()
			targetPart.Scream.PlaybackSpeed = 0.5
			targetPart.Scream.Volume = 3
			targetPart.Repent:Play()
			targetPart.Repent.Volume = 7
			targetPart.Repent.PlaybackSpeed = 0.2
			task.wait(2)
			if crucifixPart:FindFirstChild("Light") then
				local mergeSound = Instance.new("Sound")
				mergeSound.Parent = workspace
				mergeSound.SoundId = "rbxassetid://119851057500597"
				mergeSound.Volume = 10
				mergeSound.PlaybackSpeed = 0.5
				mergeSound:Play()
				local revers = Instance.new("ReverbSoundEffect")
				revers.Parent = mergeSound

				wait(0.3)

				local mergeSound = Instance.new("Sound")
				mergeSound.Parent = workspace
				mergeSound.SoundId = "rbxassetid://5835557537"
				mergeSound.Volume = 4
				mergeSound.PlaybackSpeed = 0.9
				mergeSound:Play()
				local mergeSound = Instance.new("Sound")
				mergeSound.Parent = workspace
				mergeSound.SoundId = "rbxassetid://198606040"
				mergeSound.Volume = 5
				mergeSound.PlaybackSpeed = 1.1
				mergeSound:Play()
				local mergeSound = Instance.new("Sound")
				mergeSound.Parent = workspace
				mergeSound.SoundId = "rbxassetid://198606040"
				mergeSound.Volume = 6
				mergeSound.PlaybackSpeed = 1
				mergeSound:Play()
				local mergeSound = Instance.new("Sound")
				mergeSound.Parent = workspace
				mergeSound.SoundId = "rbxassetid://3607355239"
				mergeSound.Volume = 3
				mergeSound.PlaybackSpeed = 0.9
				mergeSound:Play()


				-- 1. XÓA ENTITY MODEL
				if entityModel then entityModel:Destroy() end

				-- 2. TẠO RIÊNG MỖI BEAMCHAIN 1 PART TÀNG HÌNH VÀ TWEEN VỀ CHÍNH PART NGUỒN CỦA NÓ
				for idx, info in ipairs(clonedBeams) do
					local b = info.beam
					local origP = info.originPart

					if b and b:IsA("Beam") and origP then
						local co = game:GetObjects("rbxassetid://9118302120")[1]
						co.Parent = workspace
						co.CFrame = targetPart.CFrame
						co.Anchored = true
						local att = co.Attachment.Blood
						att.Size = NumberSequence.new(8)
						att.Speed = NumberRange.new(80)
						local cPart = Instance.new("Part")
						cPart.Name = "SpecialCrucifixCenterPart_" .. idx
						cPart.Size = Vector3.new(1, 1, 1)
						cPart.Transparency = 1
						cPart.CanCollide = false
						cPart.Anchored = true
						cPart.CFrame = targetPart.CFrame -- Xuất phát từ vị trí Entity
						cPart.Parent = workspace

						local Reboundcolor = Instance.new("ColorCorrectionEffect",game.Lighting) game.Debris:AddItem(Reboundcolor,24)
						Reboundcolor.Name = "Warn"
						Reboundcolor.TintColor = Color3.fromRGB(74, 0, 0) Reboundcolor.Saturation = 0 Reboundcolor.Contrast = 0.2
						game.TweenService:Create(Reboundcolor,TweenInfo.new(1.6),{TintColor = Color3.fromRGB(255, 255, 255),Saturation = 0, Contrast = 0}):Play()
						local TweenService = game:GetService("TweenService")
						local TW = TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(1.6),{TintColor = Color3.fromRGB(255, 255, 255)})
						TW:Play()

						task.spawn(function()
							wait(0.6)
							att.Enabled = false
							wait(1)
							co:Destroy()
						end)

						local cAtt = Instance.new("Attachment")
						cAtt.Name = "CenterBeamAttachment"
						cAtt.Parent = cPart


						b.Attachment1 = cAtt

						TweenService:Create(cPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = origP.CFrame }):Play()

						table.insert(centerParts, cPart)
					end
				end

				if pentagram then
					for _, desc in ipairs(pentagram:GetDescendants()) do
						if desc:IsA("Beam") and desc.Name == "BeamGlow" then
							task.spawn(function()
								tweenBeamTransparency(desc, 1, 2)
							end)
						end
					end
				end

				local CameraShaker2 = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
				local cam2 = workspace.CurrentCamera
				local camShake2 = CameraShaker2.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
					cam2.CFrame = cam2.CFrame * shakeCf
				end)
				camShake2:Start()
				camShake2:ShakeOnce(30, 9, 0.1, 1, 0.1, 1)

				TweenService:Create(crucifixPart.Light, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Range = 0 , Brightness = 0 }):Play()
			end
		end)
	end

	task.wait(3)
	if pentagram then
		for _, desc in ipairs(pentagram:GetDescendants()) do
			if desc:IsA("Beam") and (desc.Name == "BeamChain" or desc.Name == "Beam Flat" or desc.Name == "BeamFlat") then
				task.spawn(function()
					tweenBeamTransparency(desc, 1, 1)
				end)
			end
		end
	end

	for _, info in ipairs(clonedBeams) do
		if info.beam and info.beam:IsA("Beam") then
			task.spawn(function()
				tweenBeamTransparency(info.beam, 1, 1)
			end)
		end
	end

	task.wait(2)
	for _, info in ipairs(clonedBeams) do
		if info.beam and info.beam.Parent then info.beam:Destroy() end
	end
	for _, cp in ipairs(centerParts) do
		if cp and cp.Parent then cp:Destroy() end
	end
	if repentanceAsset then repentanceAsset:Destroy() end
end
-- ============================

local Kill = true
local damageMultiplier = 1
local canAttack = true

local moveSpeed = 12 

local gameData = ReplicatedStorage:WaitForChild("GameData", 10)

local seed = 12345
if gameData then
	local seedVal = gameData:FindFirstChild("GameSeed")
	if seedVal and seedVal:IsA("ValueBase") then
		seed = seedVal.Value
	elseif gameData:GetAttribute("GameSeed") then
		seed = gameData:GetAttribute("GameSeed")
	end
end

local roomNum = (gameData and gameData:FindFirstChild("LatestRoom")) and gameData.LatestRoom.Value or 1

local spawnRNG = Random.new(seed + (roomNum * 8888) + 55)

local eye = game:GetObjects("rbxassetid://108376519790974")[1]
eye.Parent = Workspace
eye.Name = "Manaic Eyes"

local eyes = eye:IsA("BasePart") and eye or (eye:FindFirstChildWhichIsA("BasePart", true) or eye.PrimaryPart)

local currentRooms = Workspace.CurrentRooms:GetChildren()

local randomY = spawnRNG:NextInteger(0, 7)

local xSign = (spawnRNG:NextInteger(1, 2) == 1) and 1 or -1
local randomX = spawnRNG:NextInteger(5, 10) * xSign

local zSign = (spawnRNG:NextInteger(1, 2) == 1) and 1 or -1
local randomZ = spawnRNG:NextInteger(5, 10) * zSign

local targetRoom = currentRooms[#currentRooms - 1] or currentRooms[#currentRooms]
local spawnCFrame = targetRoom.Parts.Floor.CFrame + Vector3.new(randomX, 7 + randomY, randomZ)

if eye:IsA("Model") then
	eye:PivotTo(spawnCFrame)
else
	eyes.CFrame = spawnCFrame
end

local sound = Instance.new("Sound")
sound.Parent = eyes
sound.SoundId = "rbxassetid://1168009240"
sound.Volume = 10
sound.PlaybackSpeed = 0.4
sound:Play()

task.wait(2.038)

local moveDirection = Vector3.new(
	spawnRNG:NextNumber(-1, 1),
	spawnRNG:NextNumber(-0.3, 0.3),
	spawnRNG:NextNumber(-1, 1)
).Unit

if moveDirection.Magnitude == 0 then
	moveDirection = Vector3.new(1, 0, 1).Unit
end

local moveRayParams = RaycastParams.new()
moveRayParams.FilterType = Enum.RaycastFilterType.Exclude
moveRayParams.IgnoreWater = true

local moveConnection
moveConnection = RunService.Heartbeat:Connect(function(dt)
	if not Kill or not eyes or not eyes.Parent then
		if moveConnection then moveConnection:Disconnect() end
		return
	end

	if not canAttack then return end

	local player = Players.LocalPlayer
	local char = player and player.Character
	moveRayParams.FilterDescendantsInstances = {eye, char}

	local currentPos = eyes.Position
	local moveDistance = moveSpeed * dt
	local deltaVector = moveDirection * moveDistance

	local hitResult = Workspace:Raycast(currentPos, deltaVector + (moveDirection * 0.8), moveRayParams)

	if hitResult then
		local normal = hitResult.Normal
		moveDirection = (moveDirection - 2 * moveDirection:Dot(normal) * normal).Unit

		local newPos = hitResult.Position + (normal * 0.2)
		if eye:IsA("Model") then
			eye:PivotTo(CFrame.new(newPos))
		else
			eyes.CFrame = CFrame.new(newPos)
		end
	else
		local newPos = currentPos + deltaVector
		if eye:IsA("Model") then
			eye:PivotTo(CFrame.new(newPos))
		else
			eyes.CFrame = CFrame.new(newPos)
		end
	end
end)

local maniacEyes = Workspace:FindFirstChild("Maniac Eyes Blue", true)

if maniacEyes then
	canAttack = false
	moveConnection:Disconnect()

	local targetPart = maniacEyes:FindFirstChildWhichIsA("BasePart", true) or maniacEyes.PrimaryPart

	if targetPart then
		local CFrameValue = Instance.new("CFrameValue")
		CFrameValue.Value = eyes.CFrame

		local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		local tween = TweenService:Create(CFrameValue, tweenInfo, {Value = targetPart.CFrame})

		local conn = CFrameValue.Changed:Connect(function(newCFrame)
			if eye:IsA("Model") then
				eye:PivotTo(newCFrame)
			else
				eyes.CFrame = newCFrame
			end
		end)

		tween:Play()
		tween.Completed:Wait()
		conn:Disconnect()
		CFrameValue:Destroy()

		maniacEyes:Destroy()

		local purpleColor = Color3.fromRGB(160, 32, 240)
		for _, v in ipairs(eye:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Color = purpleColor
			elseif v:IsA("Light") then
				v.Color = purpleColor
			elseif v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
				v.Color = ColorSequence.new(purpleColor)
			end
		end

		local mergeSound = Instance.new("Sound")
		mergeSound.Parent = eyes
		mergeSound.SoundId = "rbxassetid://119851057500597"
		mergeSound.Volume = 10
		mergeSound.PlaybackSpeed = 0.5
		mergeSound:Play()

		local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
		local camera = workspace.CurrentCamera
		local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
			camera.CFrame = camera.CFrame * shakeCf
		end)
		camShake:Start()
		camShake:ShakeOnce(30, 6.5, 0.1, 1, 0.1, 0.5)

		damageMultiplier = 2
	end

	canAttack = true
end

task.spawn(function()
	local camera = Workspace.CurrentCamera
	local player = Players.LocalPlayer

	while Kill == true do
		task.wait(0.05)
		if canAttack and eyes and eyes.Parent then
			local _, onScreen = camera:WorldToViewportPoint(eyes.Position)

			if onScreen then
				local camPos = camera.CFrame.Position
				local direction = eyes.Position - camPos

				local rayParams = RaycastParams.new()
				rayParams.FilterType = Enum.RaycastFilterType.Exclude
				rayParams.FilterDescendantsInstances = {player.Character, eye}
				rayParams.IgnoreWater = true

				local hitResult = Workspace:Raycast(camPos, direction, rayParams)

				if not hitResult then
					local char = player.Character
					if char and char:FindFirstChild("Humanoid") then
						local equippedTool = char:FindFirstChildOfClass("Tool")
						if equippedTool and equippedTool.Name == "Crucifix" then
							Kill = false
							canAttack = false
							if moveConnection then moveConnection:Disconnect() end
							executeCrucifixion(eye, eyes, equippedTool)
							break
							
						elseif equippedTool and equippedTool.Name == "CrucifixSpecial" then
							Kill = false
							canAttack = false
							if moveConnection then moveConnection:Disconnect() end
							SpecialCrucifixion(eye, eyes, equippedTool)
							break
							else
							
							char.Humanoid:TakeDamage(10 * damageMultiplier)

							if char.Humanoid.Health <= 0 then
								pcall(function()
									ReplicatedStorage.GameStats["Player_".. player.Name].Total.DeathCause.Value = "Manaic Eyes"
								end)
							end
						end
					end
				end
			end
		end
	end
end)

if gameData and gameData:FindFirstChild("LatestRoom") then
	gameData.LatestRoom.Changed:Wait()
end

Kill = false
if moveConnection then moveConnection:Disconnect() end
if eye then eye:Destroy() end
