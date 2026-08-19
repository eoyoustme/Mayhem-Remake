getgenv().OgHungerNewSpawner = nil 

local success, Spawner = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Mayhem-Remake/refs/heads/main/OgHungerNewSpawner"))()
end)

if not success or not Spawner then
	return
end

local entity = Spawner:Create({
	Entity = {
		Name = "Template Entity",
		Asset = "https://github.com/RegularVynixu/DOORS-Entity-Spawner-V2/raw/main/Assets/Entities/Rush.rbxm",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = true,
			Duration = 1
		},
		Shatter = true,
		Repair = false
	},
	Earthquake = {
		Enabled = true
	},
	Spawned = {
		ChangeColorWhenSpawn = false, 
		Rainbow = false,              
		Color = Color3.fromRGB(0, 85, 255)
	},
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {1.5, 20, 0.1, 1}
	},

	Movement = {
		Speed = 100,
		Delay = 2,
		Reversed = true,                  
		EndWhenEnterLatestRoom = false,   
		EndDelay = 2.5,

		ReboundMoving = false,          
		TweenSecond = 1.5,            

		ReboundMoveStyle = false,      
		ReboundStyleTimes = 3,         
		ReboundStyleSound = "rbxassetid://130994177179386", 
		ReboundStyleVolume = 5        
	},

	Jumpscare = {
		Enabled = true,
		Image1 = "rbxassetid://11253398403", 
		Image2 = "rbxassetid://12293509957",
		Sound1 = "rbxassetid://0", 
		Sound2 = "rbxassetid://109582246349306", 
		Tease = {
			[1] = true,
			Min = 1,
			Max = 1
		},
		Flashing = {
			[1] = true,
			[2] = Color3.fromRGB(255, 255, 255)
		},
		Shake = true
	},
	Rebounding = {
		Enabled = true,
		Type = "Ambush",
		Min = 1,
		Max = 1,
		Delay = 2
	},
	Damage = {
		Enabled = true,
		Range = 40,
		Amount = 125,
		IgnoreHiding = false,

		JumpscareRipper = {
			Enabled = false,
			TargetPartName = "Ripe",
			AttachmentName = "ripe",
			ParticleName = "ParticleEmitter",
			ParticleTexture = "rbxassetid://12737595583",
			SoundUrl = "https://github.com/eoyoustme/back/raw/main/Kill_with_static.mp3",
			SlamSoundId = "rbxassetid://1837829565",
			EndSoundId = "rbxassetid://4988621968",
			Images = {
				"rbxassetid://8482795900",
				"rbxassetid://236542974",
				"rbxassetid://184251462",
				"rbxassetid://236777652"
			},
			FlashDuration = 1.6
		}
	},
	Crucifixion = {
		Enabled = true,
		Range = 40,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding",
		Hints = {"Death", "Hints", "Go", "Here"},
		Cause = ""
	}
})

entity:SetCallback("OnSpawned", function()
end)

entity:SetCallback("OnStartMoving", function()

end)

entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)

end)

entity:SetCallback("OnLookAt", function(lineOfSight: boolean)

end)

entity:SetCallback("OnRebounding", function(startOfRebound: boolean)

end)

entity:SetCallback("EndWhenGO", function()

end)

entity:SetCallback("OnDespawning", function()

end)

entity:SetCallback("OnDespawned", function()

end)

entity:SetCallback("OnDamagePlayer", function(newHealth: number)

end)

---====== Run Entity ======---

entity:Run(true)
