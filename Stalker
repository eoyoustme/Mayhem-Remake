local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local StalkerModelUrl = "https://github.com/eoyoustme/Mayhem-Remake/raw/main/Stalker.rbxm"
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

-- Hàm tải file rbxm từ GitHub
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

-- Hàm xử lý hiệu ứng Crucifixion (Thánh giá)
local function executeCrucifixion(stalkerModel, targetPart, crucifixTool)
	if crucifixTool then
		crucifixTool:Destroy()
	end

	local repentanceAsset = getgithubmodeL(RepentanceUrl)
	if not repentanceAsset then
		if stalkerModel then stalkerModel:Destroy() end
		return
	end

	local camera = Workspace.CurrentCamera
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then 
		stalkerModel:Destroy()
		repentanceAsset:Destroy()
		return 
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {character, stalkerModel, repentanceAsset}
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
		if bodyPos then
			bodyPos.Position = (rootPart.CFrame * CFrame.new(0.5, 2, -5)).Position
		end

		local bodyAngular = crucifixPart:FindFirstChild("BodyAngularVelocity")
		if bodyAngular then
			TweenService:Create(bodyAngular, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { AngularVelocity = Vector3.new(0, 30, 0) }):Play()
		end
	end

	if targetPart and entityPart then
		TweenService:Create(targetPart, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			CFrame = entityPart.CFrame
		}):Play()
	end

	task.wait(2)

	if targetPart then
		TweenService:Create(targetPart, TweenInfo.new(2.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			CFrame = targetPart.CFrame - Vector3.new(0, 25, 0)
		}):Play()
	end

	task.wait(2.5)
	if crucifixPart then
		TweenService:Create(crucifixPart, TweenInfo.new(1), { Size = crucifixPart.Size * 2, Transparency = 1 }):Play()
	end

	task.wait(1)
	if stalkerModel then stalkerModel:Destroy() end
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
		crucifixPart.CFrame = camera.CFrame * CFrame.new(0, 0, -7)
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
			targetPart.KillV2:Play()
			targetPart.KillV2.PlaybackSpeed = 0.5
			targetPart.KillV2.Volume = 3
			targetPart.Kill:Play()
			targetPart.Kill.Volume = 7
			targetPart.Kill.PlaybackSpeed = 0.2

			task.spawn(function()
				local Players = game:GetService("Players")
				local RunService = game:GetService("RunService")
				local localPlayer = Players.LocalPlayer

				if not localPlayer then return end

				local random = math.random
				local vector3New = Vector3.new

				local MAX_DISTANCE = 150        
				local GLITCH_INTENSITY = 1.5    
				local GLITCH_DURATION = 2.5      

				local startTime = os.clock()

				local visualClones = {}         
				local targetParts = {}
				setmetatable(visualClones, {__mode = "k"}) 

				-- [TỰ ĐỘNG TẠO UI FRAME NHẤP NHÁY]
				local playerGui = localPlayer:WaitForChild("PlayerGui")
				local screenGui = playerGui:FindFirstChild("GlitchGui") or Instance.new("ScreenGui")
				screenGui.Name = "GlitchGui"
				screenGui.ResetOnSpawn = false
				screenGui.Parent = playerGui
				screenGui.IgnoreGuiInset = true

				local Frame = screenGui:FindFirstChild("ShaderFrame") or Instance.new("Frame")
				Frame.Name = "ShaderFrame"
				Frame.Size = UDim2.new(1, 0, 1, 0)
				Frame.Position = UDim2.new(0, 10, 0, 10)
				Frame.BorderSizePixel = 0
				Frame.Visible = true
				Frame.Parent = screenGui
				Frame.BackgroundTransparency = 0.7

				task.spawn(function()
					while Frame and Frame.Parent do
						Frame.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
						task.wait(0.05)
					end
				end)

				local sound = Instance.new("Sound", workspace)
				sound.SoundId = "rbxassetid://140558918020400"
				sound.Volume = 10
				sound.PlaybackSpeed = 1
				sound:Play()

				local function isExcluded(part)
					if not part:IsA("BasePart") or part:IsA("Terrain") or part.Name == "GlitchVisualClone" then 
						return true 
					end
					local current = part.Parent
					while current and current ~= workspace do
						if current:IsA("Model") and current.Name == "Stalker" then return true end
						if current:IsA("Model") and Players:GetPlayerFromCharacter(current) then return true end
						current = current.Parent
					end
					return false
				end

				local function setupVisualClone(part)
					if visualClones[part] then return end

					local clone = part:Clone()

					for _, child in ipairs(clone:GetDescendants()) do
						if child:IsA("LuaSourceContainer") or child:IsA("BodyMover") or child:IsA("Constraint") then
							child:Destroy()
						end
					end

					clone.CanCollide = false
					clone.CanTouch = false
					clone.CanQuery = false
					clone.Anchored = true
					clone.Name = "GlitchVisualClone"
					clone.Transparency = 1
					clone.Parent = part

					visualClones[part] = {
						Clone = clone,
						OriginalSize = part.Size,
						OriginalCFrame = part.CFrame,
						OriginalColor = part.Color,
						OriginalTransparency = part.Transparency
					}
				end

				local function refreshCache()
					local newTargets = {}
					for _, part in ipairs(workspace:GetDescendants()) do
						if not isExcluded(part) then
							table.insert(newTargets, part)
							setupVisualClone(part)
						end
					end
					targetParts = newTargets
				end

				refreshCache()

				local isRunning = true
				task.spawn(function()
					while isRunning do
						task.wait(3)
						if isRunning then refreshCache() end
					end
				end)

				local heartbeatConnection

				local function restoreNormal()
					isRunning = false

					if heartbeatConnection then
						heartbeatConnection:Disconnect()
						heartbeatConnection = nil
					end

					for part, data in pairs(visualClones) do
						if part and part.Parent then
							part.Transparency = data.OriginalTransparency
						end
						if data.Clone and data.Clone.Parent then
							data.Clone:Destroy()
						end
					end

					-- 3. Xóa UI và Sound
					if sound then sound:Destroy() end
					if screenGui then screenGui:Destroy() end

				end

				heartbeatConnection = RunService.Heartbeat:Connect(function()
					local character = localPlayer.Character
					local rootPart = character and character:FindFirstChild("HumanoidRootPart")
					if not rootPart then return end
					local playerPosition = rootPart.Position

					local elapsedTime = os.clock() - startTime
					local progress = math.clamp(elapsedTime / GLITCH_DURATION, 0, 1)
					local currentIntensity = GLITCH_INTENSITY * progress

					for i = #targetParts, 1, -1 do
						local part = targetParts[i]

						if not part or not part.Parent then
							table.remove(targetParts, i)
							continue
						end

						local data = visualClones[part]
						if data then
							local clone = data.Clone
							local distance = (part.Position - playerPosition).Magnitude

							if distance <= MAX_DISTANCE then
								part.Transparency = 1
								clone.Transparency = data.OriginalTransparency

								local shakeX = (random(-100, 100) / 100) * currentIntensity
								local shakeY = (random(-100, 100) / 100) * currentIntensity
								local shakeZ = (random(-100, 100) / 100) * currentIntensity

								local offsetCFrame = CFrame.new(shakeX * 0.2, shakeY * 0.2, shakeZ * 0.2) 
									* CFrame.Angles(math.rad(shakeX * 8), math.rad(shakeY * 8), math.rad(shakeZ * 8))

								clone.CFrame = data.OriginalCFrame * offsetCFrame

								if random() > 0.6 then
									clone.Size = data.OriginalSize + vector3New(shakeX * 1.5, shakeY * 1.5, shakeZ * 1.5)
								else
									clone.Size = data.OriginalSize
								end

								for _, child in ipairs(clone:GetChildren()) do
									if child:IsA("Texture") then
										child.OffsetStudsU = random(-50, 50)
										child.OffsetStudsV = random(-50, 50)
										child.StudsPerTileU = random(5, 100) * 0.1
										child.StudsPerTileV = random(5, 100) * 0.1
									end
								end
							else
								if part.Transparency ~= data.OriginalTransparency then
									part.Transparency = data.OriginalTransparency
									clone.Transparency = 1
									clone.CFrame = data.OriginalCFrame
									clone.Size = data.OriginalSize
									clone.Color = data.OriginalColor
								end
							end
						end
					end
				end)
				task.delay(GLITCH_DURATION, restoreNormal)
			end)

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


				if entityModel then entityModel:Destroy() end

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

local function spawnStalker()
	local shockerModel = getgithubmodeL(StalkerModelUrl)
	if not shockerModel then return end

	local camera = Workspace.CurrentCamera
	local rootPart = shockerModel:FindFirstChild("HumanoidRootPart") or shockerModel:FindFirstChildWhichIsA("BasePart")
	shockerModel.PrimaryPart = rootPart

	-- KIỂM TRA VẬT CẢN KHI SPAWN (Tránh bị kẹt/ẩn trong tường)
	local spawnDistance = 10
	local rayParamsSpawn = RaycastParams.new()
	rayParamsSpawn.FilterType = Enum.RaycastFilterType.Exclude
	rayParamsSpawn.FilterDescendantsInstances = {character, shockerModel}

	local rayHit = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * spawnDistance, rayParamsSpawn)
	local targetSpawnCFrame
	if rayHit then
		-- Spawn ngay trước mặt bức tường/vật cản
		targetSpawnCFrame = CFrame.new(rayHit.Position - (camera.CFrame.LookVector * 1.5), camera.CFrame.Position)
	else
		targetSpawnCFrame = camera.CFrame * CFrame.new(0, -2, -spawnDistance)
	end

	shockerModel:PivotTo(targetSpawnCFrame)
	shockerModel.Parent = Workspace

	local oogaBoogaaPart = shockerModel:WaitForChild("Stalker", 5)
	if not oogaBoogaaPart then 
		shockerModel:Destroy() -- Dọn dẹp nếu load thất bại
		return 
	end

	oogaBoogaaPart.Anchored = true
	oogaBoogaaPart.CanCollide = true

	local lookDuration = 2
	local lookStart = nil
	local hasTriggered = false
	local hasFallen = false

	local function fallToGround()
		if hasFallen then return end
		hasFallen = true

		if oogaBoogaaPart and oogaBoogaaPart.Parent then
			oogaBoogaaPart.Anchored = false
			oogaBoogaaPart.CanCollide = false
		end

		task.delay(1.2, function()
			if shockerModel and shockerModel.Parent then
				shockerModel:Destroy()
			end
		end)
	end

	local connection
	connection = RunService.RenderStepped:Connect(function()
		if not character or not character:FindFirstChild("HumanoidRootPart") or not oogaBoogaaPart or not oogaBoogaaPart.Parent then return end
		if hasTriggered then 
			if connection then connection:Disconnect() end
			return 
		end

		local directionToShocker = (oogaBoogaaPart.Position - camera.CFrame.Position).Unit
		local playerLookVector = camera.CFrame.LookVector
		local dot = directionToShocker:Dot(playerLookVector)

		-- 1. Kiểm tra góc nhìn Camera
		if dot > 0.85 then
			-- 2. KIỂM TRA TẦM NHÌN (LINE OF SIGHT): Đảm bảo không bị vật cản/tường che mắt
			local losParams = RaycastParams.new()
			losParams.FilterType = Enum.RaycastFilterType.Exclude
			losParams.FilterDescendantsInstances = {character, shockerModel}

			local origin = camera.CFrame.Position
			local targetPos = oogaBoogaaPart.Position
			local losRay = workspace:Raycast(origin, targetPos - origin, losParams)

			-- Nếu raycast KHÔNG trúng vật cản nào -> Người chơi thực sự ĐANG THẤY Stalker
			if not losRay then
				if not lookStart then
					lookStart = os.clock()
				elseif os.clock() - lookStart >= lookDuration then
					hasTriggered = true
					connection:Disconnect()

					local targetPosChar = character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)
					local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local tween = TweenService:Create(oogaBoogaaPart, tweenInfo, {Position = targetPosChar})
					tween:Play()

					tween.Completed:Connect(function()
						local equippedTool = character:FindFirstChildOfClass("Tool")
						local hasCrucifix = (equippedTool and equippedTool.Name == "Crucifix")
						local toilet = (equippedTool and equippedTool.Name == "CrucifixSpecial")

						if hasCrucifix then
							executeCrucifixion(shockerModel, oogaBoogaaPart, equippedTool)
						elseif toilet then
							SpecialCrucifixion(shockerModel , oogaBoogaaPart , equippedTool)
						else
							task.spawn(function()
								local currentHealth = humanoid.Health
								if currentHealth <= 10 then
									for _, descendant in ipairs(Workspace:GetDescendants()) do
										if descendant:IsA("Sound") then
											descendant.Playing = false
										end
									end
									wait(0.3)
									local function GetGitSound(GithubSnd, SoundName)
										local url = GithubSnd
										if not isfile(SoundName .. ".mp3") then
											writefile(SoundName .. ".mp3", game:HttpGet(url))
										end
										local sound = Instance.new("Sound")
										sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
										return sound
									end

									local Jumpscare = GetGitSound("https://raw.githubusercontent.com/eoyoustme/Mayhem-Remake/main/StalkerGlitch.mp3", "PeleTheKing55")
									Jumpscare.Parent = workspace
									Jumpscare.Volume = 3
									Jumpscare.PlaybackSpeed = 1
									Jumpscare:Play()
									local playerGui = player:WaitForChild("PlayerGui")
									local screenGui = Instance.new("ScreenGui")
									humanoid.Health = 0
									screenGui.Name = "FlashOverlay"
									screenGui.IgnoreGuiInset = true
									screenGui.Parent = playerGui
									
									local frame = Instance.new("Frame")
									frame.Size = UDim2.new(1, 0, 1, 0)
									frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									frame.BackgroundTransparency = 0
									frame.BorderSizePixel = 0
									frame.Parent = screenGui
									
									local Smiler = Instance.new("ImageLabel")
									Smiler.Image = "rbxassetid://12739025060"
									Smiler.Size = UDim2.new(0, 800, 0, 800)
									Smiler.Position = UDim2.new(0.5, 0,0.5, 0)
									Smiler.ImageColor3 = Color3.fromRGB(255, 255, 255)
									Smiler.AnchorPoint = Vector2.new(0.5, 0.5)
									Smiler.Parent = screenGui
									Smiler.BackgroundTransparency = 1
									Smiler.ResampleMode = Enum.ResamplerMode.Pixelated
									Smiler.ImageTransparency = 0.7
									Smiler.ZIndex = 1000
									Smiler.Rotation = 0
									
									local imageLabel = Instance.new("ImageLabel")
									imageLabel.BackgroundTransparency = 1
									imageLabel.BorderSizePixel = 0
									imageLabel.Position = UDim2.new(0, 0, 0, 0)
									imageLabel.Size = UDim2.new(1, 0, 1, 0)
									imageLabel.ScaleType = Enum.ScaleType.Stretch
									imageLabel.ImageTransparency = 1
									imageLabel.Visible = true
									imageLabel.Parent = screenGui

									local jumpscareImages = {
										"rbxassetid://14577304668",
										"rbxassetid://15813727511",
										"rbxassetid://15813727319",
										"rbxassetid://17400340074",
										"rbxassetid://12710989538",
										"rbxassetid://15813726866",
										"rbxassetid://15813726700",
										"rbxassetid://85325712385294",
										"rbxassetid://132173691110215",
										"rbxassetid://15813726313",
										"rbxassetid://15813726068",
										"rbxassetid://73640229281491"
									}

									local oi = task.spawn(function()
										for i=1 , 1 do
											local flashDuration = 35
											task.spawn(function()
												local tweenIn = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
												TweenService:Create(imageLabel, tweenIn, {ImageTransparency = 0}):Play()
												wait(0.25)
												local tweenIn = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
												TweenService:Create(imageLabel, tweenIn, {ImageTransparency = 0.5}):Play()
											end)


											local start = os.clock()

											while os.clock() - start < flashDuration do
												for _, imgId in ipairs(jumpscareImages) do
													imageLabel.Image = imgId
													task.wait(0.03)
												end
											end
										end
									end)
									
									task.wait(1)
									
									Smiler.ImageColor3 = Color3.fromRGB(0, 0, 0)
									frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
									local origin = Smiler.Position

									local b = task.spawn(function()
										for i = 1 , 1000 do
											Smiler.Rotation = math.random(-8, 8)
											Smiler.Position = origin + UDim2.new(0, math.random(-40, 40), 0, math.random(-40, 40))
											task.wait(0.001)
										end
									end)
									wait(3)
									task.cancel(b)
									
									local c = task.spawn(function()
										for i = 1 , 1000 do
											Smiler.Rotation = math.random(-16, 16)
											Smiler.Position = origin + UDim2.new(0, math.random(-70, 70), 0, math.random(-70, 70))
											task.wait(0.001)
										end
									end)
									
									Smiler.ImageColor3 = Color3.fromRGB(255, 255, 255)
									frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									imageLabel.ImageTransparency = 0.35
									wait(2)
									local ay =  Smiler.Position
									task.cancel(c)
									Smiler.Position = ay
									task.cancel(oi)
									wait(2)
									game:Shutdown()

								else
									local cue2 = Instance.new("Sound")
									cue2.Parent = game
									cue2.Name = "Spawn"
									cue2.SoundId = "rbxasset://textures/0e828935720d2808f68a635c63293576481dcf474b645b34acf2d63f53d598b2.mp3"
									cue2.Volume = 6
									cue2.TimePosition = 0
									cue2.PlaybackSpeed = 1
									cue2:Play()

									local damage = Random.new():NextInteger(1, 100)
									local newHealth = math.max(1, currentHealth - damage)
									local FLASH_COLOR = Color3.fromRGB(85, 170, 255) 
									local FLASH_DURATION = 0.05 
									local FLASH_REPEAT = 12

									local playerGui = player:WaitForChild("PlayerGui")

									local screenGui = Instance.new("ScreenGui")
									screenGui.Name = "FlashOverlay"
									screenGui.IgnoreGuiInset = true
									screenGui.Parent = playerGui

									local frame = Instance.new("Frame")
									frame.Size = UDim2.new(1, 0, 1, 0)
									frame.BackgroundColor3 = FLASH_COLOR
									frame.BackgroundTransparency = 1
									frame.BorderSizePixel = 0
									frame.Parent = screenGui

									local rebound = Instance.new("ImageLabel")
									rebound.Image = "rbxassetid://12739025060"
									rebound.Size = UDim2.new(0, 100, 0, 100)
									rebound.Position = UDim2.new(0.5, 0, 0.5, 0)
									rebound.AnchorPoint = Vector2.new(0.5, 0.5)
									rebound.Parent = screenGui
									rebound.BackgroundTransparency = 1
									rebound.ResampleMode = Enum.ResamplerMode.Pixelated
									rebound.ImageTransparency = 0
									rebound.ZIndex = 1000

									TweenService:Create(rebound, TweenInfo.new(1.2), {Size = UDim2.new(0, 2000, 0, 2000), ImageTransparency = 0}):Play()
									Debris:AddItem(rebound, 2)

									local screenGui5 = Instance.new("ScreenGui")
									screenGui5.Name = "JumpscareOverlay"
									screenGui5.IgnoreGuiInset = true
									screenGui5.DisplayOrder = 999999
									screenGui5.Parent = playerGui

									local imageLabel = Instance.new("ImageLabel")
									imageLabel.BackgroundTransparency = 1
									imageLabel.BorderSizePixel = 0
									imageLabel.Position = UDim2.new(0, 0, 0, 0)
									imageLabel.Size = UDim2.new(1, 0, 1, 0)
									imageLabel.ScaleType = Enum.ScaleType.Stretch
									imageLabel.ImageTransparency = 1
									imageLabel.Visible = true
									imageLabel.Parent = screenGui5

									local jumpscareImages = {
										"rbxassetid://15813725670",
										"rbxassetid://15813727511",
										"rbxassetid://15813727319",
										"rbxassetid://15813727319",
										"rbxassetid://15813726972",
										"rbxassetid://15813726866",
										"rbxassetid://15813726700",
										"rbxassetid://15813726584",
										"rbxassetid://15813726463",
										"rbxassetid://15813726313",
										"rbxassetid://15813726068",
										"rbxassetid://15813725870"
									}

									task.spawn(function()
										task.wait(0.3)
										local cue2 = Instance.new("Sound")
										cue2.Parent = game.Workspace
										cue2.Name = "Spawn"
										cue2.SoundId = "rbxassetid://140708560546036"
										cue2.Volume = 10
										cue2.TimePosition = 0
										cue2.PlaybackSpeed = 0.7
										cue2:Play()

										local tweenIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
										TweenService:Create(imageLabel, tweenIn, {ImageTransparency = 0}):Play()

										local start = os.clock()
										local flashDuration = 0.8

										while os.clock() - start < flashDuration do
											for _, imgId in ipairs(jumpscareImages) do
												imageLabel.Image = imgId
												task.wait(0.03)
											end
										end
									end)

									for i = 1, FLASH_REPEAT do
										frame.BackgroundColor3 = FLASH_COLOR
										frame.BackgroundTransparency = 0
										task.wait(FLASH_DURATION)
										frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
										frame.BackgroundTransparency = 0
										task.wait(FLASH_DURATION)
									end
									if screenGui then screenGui:Destroy() end
									if screenGui5 then screenGui5:Destroy() end
									humanoid.Health = newHealth
								end
							end)

							task.wait(3)
							fallToGround()
						end
					end)
				end
			else
				lookStart = nil -- Reset đếm giây nếu bị tường che mất
			end
		else
			lookStart = nil 
		end
	end)

	task.delay(3, function()
		if not hasTriggered and not hasFallen then
			fallToGround()
		end
	end)

	pcall(function()
		local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
		achievementGiver({
			Title = "I watch from above, you face the one",
			Desc = "Look at me.",
			Reason = "Encounter Stalker.",
			Image = "rbxassetid://0"
		})
	end)
end

spawnStalker()
