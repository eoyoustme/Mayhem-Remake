local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

local gameData = ReplicatedStorage:WaitForChild("GameData", 10)
local lastroom = gameData and gameData:WaitForChild("LatestRoom", 10)

if not lastroom then 
	warn("[Twiter Script] Không tìm thấy LatestRoom, hủy thực thi!")
	return 
end

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

local function getGameSeed()
	if gameData then
		local seedVal = gameData:FindFirstChild("GameSeed")
		if seedVal and seedVal:IsA("ValueBase") and tonumber(seedVal.Value) then
			return tonumber(seedVal.Value)
		end

		local attrSeed = gameData:GetAttribute("GameSeed")
		if attrSeed and tonumber(attrSeed) then
			return tonumber(attrSeed)
		end
	end
	return 12345
end

-- Hàm lấy file từ GitHub (cho Asset/Sound/PNG)
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

local function GetGitSound(GithubSnd, SoundName)
	local url = GithubSnd:gsub("github%.com", "raw.githubusercontent.com"):gsub("/blob/", "/"):gsub("%?raw=true", "")
	local fileName = SoundName:sub(-4):lower() == ".mp3" and SoundName or (SoundName .. ".mp3")

	if not isfile(fileName) then
		pcall(function()
			writefile(fileName, game:HttpGet(url))
		end)
	end

	local sound = Instance.new("Sound")
	local getAsset = getcustomasset or getsynasset or syn_getcustomasset
	if getAsset and isfile(fileName) then
		sound.SoundId = getAsset(fileName)
	else
		sound.SoundId = url
	end
	return sound
end

function GitPNG(GithubImg, ImageName)
	local url = GithubImg:gsub("github%.com", "raw.githubusercontent.com"):gsub("/blob/", "/"):gsub("%?raw=true", "")
	local fileName = ImageName:sub(-4):lower() == ".png" and ImageName or (ImageName .. ".png")

	if not isfile(fileName) then
		local success, response = pcall(function()
			return game:HttpGet(url)
		end)

		if success and response and #response > 0 then
			writefile(fileName, response)
		else
			warn("[GitPNG Error] Không thể tải ảnh: " .. tostring(url))
			return ""
		end
	end

	local getAsset = getcustomasset or getsynasset or syn_getcustomasset
	if getAsset then
		return getAsset(fileName)
	else
		return ""
	end
end

-- Hàm thực thi hiệu ứng Crucifixion phong ấn Twiter
local function executeCrucifixion(entityModel, targetPart, crucifixTool)
	if crucifixTool then
		crucifixTool:Destroy()
	end

	local repentanceAsset = getgithubmodeL(RepentanceUrl)
	if not repentanceAsset then
		if entityModel then entityModel:Destroy() end
		return
	end

	local char = player.Character
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	local camera = Workspace.CurrentCamera
	if not rootPart then
		if entityModel then entityModel:Destroy() end
		repentanceAsset:Destroy()
		return
	end

	-- Raycast lấy mặt đất
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {char, entityModel, repentanceAsset}
	local rayResult = workspace:Raycast(targetPart.Position, Vector3.new(0, -1000, 0), rayParams)
	local groundPos = rayResult and rayResult.Position or (targetPart.Position - Vector3.new(0, 3, 0))

	repentanceAsset:PivotTo(CFrame.new(groundPos))
	repentanceAsset.Parent = workspace

	local crucifixPart = repentanceAsset:FindFirstChild("Crucifix")
	local entityPart = repentanceAsset:FindFirstChild("Entity") or targetPart

	-- Âm thanh
	local sound = crucifixPart and (crucifixPart:FindFirstChild("Sound") or crucifixPart:FindFirstChildWhichIsA("Sound"))
	if sound then sound:Play() end

	-- Hiệu ứng vương trượng/thánh giá bay
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

	-- Di chuyển Twiter vào tâm phong ấn
	if targetPart and entityPart then
		TweenService:Create(targetPart, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			CFrame = entityPart.CFrame
		}):Play()
	end

	task.wait(2)

	-- Kéo Twiter xuống đất
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
						co.CFrame = targetPart.CFrame * CFrame.new(0, -1, 0)
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
						cPart.CFrame = targetPart.CFrame * CFrame.new(0, -1, 0) -- Xuất phát từ vị trí Entity
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

local startRoomNum = lastroom.Value

local oldmodel = workspace:FindFirstChild("Twiter")
if oldmodel then
	oldmodel:Destroy()
	return
end

local warningSound = GetGitSound("https://github.com/eoyoustme/Mayhem-Remake/blob/main/SUPERSCREAM.mp3?raw=true", "SUPERSCREAMWAWA")
warningSound.Parent = workspace
warningSound.Volume = 2
warningSound.TimePosition = 0.3
warningSound.PlaybackSpeed = 1
warningSound:Play()

local warningSound55 = GetGitSound("https://github.com/eoyoustme/Mayhem-Remake/blob/main/Twister111.mp3?raw=true", "1.1.1.1")
warningSound55.Parent = workspace
warningSound55.Volume = 2
warningSound55.TimePosition = 0.3
warningSound55.PlaybackSpeed = 1
warningSound55:Play()
task.wait(0.3)

local warningSound5 = GetGitSound("https://github.com/eoyoustme/Mayhem-Remake/blob/main/Twister%20(1).mp3?raw=true", "warningSoundwarningSound")
warningSound5.Parent = workspace
warningSound5.Volume = 2
warningSound5.PlaybackSpeed = 1
warningSound5:Play()

local currentSeed = getGameSeed()
local syncRNG_Initial = Random.new(currentSeed + (startRoomNum * 777) + 11)
local initialRoomWait = syncRNG_Initial:NextInteger(1, 1)
local targetSpawnRoom = startRoomNum + initialRoomWait

while lastroom.Value < targetSpawnRoom do
	lastroom.Changed:Wait()
end

local Jumpscare = GetGitSound("https://github.com/eoyoustme/Mayhem-Remake/raw/main/Mayhem%20mode%20recreate_TwisterScream2.mp3", "Twitersaygttyt")
Jumpscare.Parent = workspace
Jumpscare.Volume = 6
Jumpscare.PlaybackSpeed = 1
Jumpscare:Play()

local depthsTer
pcall(function()
	depthsTer = game:GetObjects("rbxassetid://12802494019")[1]
end)

if not depthsTer then 
	warn("[Twiter Script] Không thể lấy Model rbxassetid://12802494019!")
	return 
end

depthsTer.Name = "Twiter"
depthsTer.Parent = workspace

local part = depthsTer:FindFirstChildWhichIsA("BasePart") or depthsTer:FindFirstChildWhichIsA("Part")
if not part then return end

local currentRooms = workspace:FindFirstChild("CurrentRooms")
if currentRooms then
	local roomsList = currentRooms:GetChildren()
	local targetRoom = roomsList[#roomsList - 1] or roomsList[#roomsList]
	if targetRoom and targetRoom:FindFirstChild("Parts") and targetRoom.Parts:FindFirstChild("Floor") then
		part.CFrame = targetRoom.Parts.Floor.CFrame + Vector3.new(0, 6, 0)
	else
		part.CFrame = (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 10, 0)
	end
end

if part:FindFirstChild("Footsteps") then part.Footsteps.Playing = false end
if part:FindFirstChild("Kill") then part.Kill:Play() end
if part:FindFirstChild("Repent") then part.Repent:Play() end
if part:FindFirstChild("Scream") then part.Scream:Play() end

local textureAsset = GitPNG("https://github.com/eoyoustme/Mayhem-Remake/blob/main/Twitser.png", "ACTALLY")
if part:FindFirstChild("Attachment") then
	if part.Attachment:FindFirstChild("ParticleEmitter") then
		part.Attachment.ParticleEmitter.Texture = textureAsset
	end
	if part.Attachment:FindFirstChild("BlackTrail") then
		part.Attachment.BlackTrail.Texture = textureAsset
	end
end

local damageInterval = 0.5
local damageAmount = 10
local activeTime = 3
local crazy = part:FindFirstChild("Attachment") and part.Attachment:FindFirstChildOfClass("PointLight")

task.spawn(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	local humanoid = char:WaitForChild("Humanoid", 5)

	if not hrp or not humanoid then return end

	local equippedTool = char:FindFirstChildOfClass("Tool")
	local hasCrucifix = (equippedTool and equippedTool.Name == "Crucifix")
	local Toilet = (equippedTool and equippedTool.Name == "CrucifixSpecial")

	if hasCrucifix then
		if Jumpscare then Jumpscare:Stop() end
		if part:FindFirstChild("Kill") then part.Kill:Stop() end
		if part:FindFirstChild("Scream") then part.Scream:Stop() end

		executeCrucifixion(depthsTer, part, equippedTool)
		return
	elseif Toilet then
			if Jumpscare then Jumpscare:Stop() end
			if part:FindFirstChild("Kill") then part.Kill:Stop() end
			if part:FindFirstChild("Scream") then part.Scream:Stop() end

			SpecialCrucifixion(depthsTer, part, equippedTool)
			return
	end

	local lastPos = hrp.Position
	local elapsedTime = 0

	while elapsedTime < activeTime do
		task.wait(damageInterval)

		if not char or not char.Parent then
			char = player.Character
			if char then
				hrp = char:FindFirstChild("HumanoidRootPart")
				humanoid = char:FindFirstChildOfClass("Humanoid")
			end
		end

		if hrp and humanoid and humanoid.Health > 0 then
			local currentPos = hrp.Position
			if (currentPos - lastPos).Magnitude > 0.5 then
				pcall(function()
					if playerGui:FindFirstChild("MainUI") and playerGui.MainUI:FindFirstChild("Initiator") then
						require(playerGui.MainUI.Initiator.Main_Game).caption("", true)
					end
				end)

				humanoid.Health = math.max(0, humanoid.Health - damageAmount)

				if humanoid.Health <= 0 then
					pcall(function()
						local setupval = debug.setupvalue or setupvalue
						local getinfo = debug.getinfo or getinfo
						local getgc = getgc

						if getgc then
							for _, v in pairs(getgc(false)) do
								if type(v) == "function" then
									local info = getinfo(v)
									if info and info.nups == 2 and info.is_vararg == 0 then
										setupval(v, 1, {
											"You died to Twiter.",
											"It punishes movement.",
											"When you hear the warning, freeze.",
											"Standing still might save your life."
										})
										setupval(v, 2, "Blue")
										break
									end
								end
							end
						end
					end)
				end
				lastPos = currentPos
			end
		end
		elapsedTime = elapsedTime + damageInterval
	end

	if Jumpscare and Jumpscare.Parent then
		TweenService:Create(Jumpscare, TweenInfo.new(1, Enum.EasingStyle.Linear), { Volume = 0 }):Play()
	end

	if crazy then
		TweenService:Create(crazy, TweenInfo.new(1, Enum.EasingStyle.Linear), { Range = 0 }):Play()
	end

	task.wait(1)

	if Jumpscare then Jumpscare:Destroy() end
	if depthsTer then depthsTer:Destroy() end
end) 

task.spawn(function()
	local syncRNG_Move1 = Random.new(currentSeed + (startRoomNum * 1337) + 99)
	local waitRooms = syncRNG_Move1:NextInteger(1, 1)
	local targetMoveRoom1 = targetSpawnRoom + waitRooms

	-- Chờ cho tới phòng di chuyển 1
	while lastroom.Value < targetMoveRoom1 do
		lastroom.Changed:Wait()
	end

	if warningSound and warningSound.Parent then
		warningSound:Play()
		warningSound5:Play()
		warningSound55:Play()
	end

	local syncRNG_Move2 = Random.new(currentSeed + (startRoomNum * 333) + 44)
	local waitRooms2 = syncRNG_Move2:NextInteger(1, 1)
	local targetMoveRoom2 = targetMoveRoom1 + waitRooms2

	-- Chờ cho tới phòng di chuyển 2
	while lastroom.Value < targetMoveRoom2 do
		lastroom.Changed:Wait()
	end

	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Mayhem-Remake/refs/heads/main/Twiter%20Move"))()
	end)
end)
