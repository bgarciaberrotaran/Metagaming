--[[ - - - - - - - - - - - ]]
--[[ 		Metagaming     ]]
--[[		Callbacks	   ]]
--[[ - - - - - - - - - - - ]]

function onPlayerDisconnect(PlayerID,Reason)
	local Nickname = getPlayerName(PlayerID)
	for i,v in pairs(BusinessOwner) do
		if v == Nickname then		
			local PlayerBusinessSeconds = getPlayerBusinessTime(PlayerID)
			vwrite("Business/Active.txt", Nickname, PlayerBusinessSeconds)
			PlayerBusinessTime[PlayerID] = nil
		end
	end
	PlayerInfo[PlayerID] = nil	
	PlayerProfile[PlayerID] = nil
	PlayerBanInfo[PlayerID] = nil
	PlayerInv[PlayerID] = nil
	Fishing[PlayerID] = nil
	Lottery[PlayerID] = nil
	VehicleColor[PlayerID] = nil
	Points[PlayerID] = nil
	--Time[PlayerID] = nil	
	PlayerConnected[PlayerID] = nil
end

function onPlayerConnect(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local RestoreMoney = vread("Files/Account/Money.txt",Nickname)	
	local PlayerIP = getPlayerIP(PlayerID)
	local IP = getPlayerIP(PlayerID)
	local Numbers = vexplode( IP, "." )
	local ClassBSubnet = table.concat( Numbers, ".", 1, 2 )
	local IsPlayerOwned = vread("Alias/Alias B/" .. ClassBSubnet ..".txt","Banned")	
	local RegisteredIP = vread("Files/Account/Ip.txt", Nickname)	
	local Registered = vread("Files/Account/Registered.txt",Nickname)	
	local Level = vread("Files/Account/Level.txt",Nickname)
	local Sex = vread("Files/Account/Sex.txt",Nickname)
	local Age = vread("Files/Account/Age.txt",Nickname)
	local Cash = vread("Files/Account/Money.txt",Nickname)
	local ProfileMale = vread("Profile/" .. Nickname ..".txt","male")
	local ProfileFemale = vread("Profile/" .. Nickname ..".txt","female")
	local ProfileAge = vread("Profile/" .. Nickname ..".txt","age")
	local Password = vread("Files/Account/Password.txt",Nickname)
	local FoodTime = vread("Files/Account/FoodTime.txt",Nickname)
	local LoggedIn = vread("Files/Account/Loggedin.txt",Nickname.."_LoggedIn")
	local Tries = vread("Files/Account/LoginAttempts.txt",Nickname)
	local Timestamp = vread("Files/Admin/TempBanned.txt", Nickname.."_timestamp")
	local Bantime = vread("Files/Admin/TempBanned.txt", Nickname.."_bantime")
	local Bank = vread("Files/Account/Bank.txt",Nickname)
	local TWarns = vread("Files/Admin/Twarns.txt",Nickname)
	local PWarns = vread("Files/Admin/Pwarns.txt",Nickname)
	local RegisterTs = vread("Files/Account/Registerts.txt",Nickname)
	local Connections = vread("Profile/Connections.txt",Nickname)
	
	
	Level = (Level) and tonumber(Level)	
	Age = (Age) and tonumber(Age)
	Sex = (Sex) and tonumber(Sex)	
	Registered = (Registered) and tonumber(Registered) or 0	
	IsPlayerOwned = (IsPlayerOwned) and tonumber(IsPlayerOwned) or 0
	RestoreMoney = (RestoreMoney) and tonumber(RestoreMoney) or 0
	Cash = (Cash) and tonumber(Cash) or 0
	ProfileMale = (ProfileMale) and tonumber(ProfileMale) or 0
	ProfileFemale = (ProfileFemale) and tonumber(ProfileFemale) or 0
	ProfileAge = (ProfileAge) and tonumber(ProfileAge) or 0
	FoodTime = (FoodTime) and tonumber(FoodTime) or 0
	LoggedIn = (LoggedIn) and tonumber(LoggedIn) or 0
	Tries = (Tries) and tonumber(Tries) or 0
	Timestamp = (Timestamp) and tonumber(Timestamp) or 0
	Bantime = (Bantime) and tonumber(Bantime) or 0
	Bank = (Bank) and tonumber(Bank)	
	TWarns = (TWarns) and tonumber(TWarns) or 0
	PWarns = (PWarns) and tonumber(PWarns) or 0
	RegisterTs = (RegisterTs) and tonumber(RegisterTs)
	Connections = (Connections) and tonumber(Connections) or 0
	
	PlayerInfo[PlayerID] = {}
	PlayerProfile[PlayerID] = {}
	PlayerBanInfo[PlayerID] = {}
	Lottery[PlayerID] = {}
	VehicleColor[PlayerID] = {}
	Points[PlayerID] = {}
	--Time[PlayerID] = {}
	
	PlayerInv[PlayerID] = vfileTable("Inventory/" .. Nickname .. ".txt")
	
	PlayerInv[PlayerID] = vtonumberTable( PlayerInv[PlayerID], true ) -- convert table keys to number
	PlayerInv[PlayerID] = vtonumberTable( PlayerInv[PlayerID] ) -- convert table values to number
	
	PlayerInfo[PlayerID].level = Level
	PlayerInfo[PlayerID].age = Age
	PlayerInfo[PlayerID].sex = Sex
	PlayerInfo[PlayerID].registered = Registered
	PlayerInfo[PlayerID].owned = IsPlayerOwned
	PlayerInfo[PlayerID].ip = RegisteredIP
	PlayerInfo[PlayerID].cash = Cash
	PlayerInfo[PlayerID].restore = RestoreMoney
	PlayerInfo[PlayerID].password = Password
	PlayerInfo[PlayerID].foodtime = FoodTime
	PlayerInfo[PlayerID].loggedin = LoggedIn
	PlayerInfo[PlayerID].tries = Tries
	PlayerInfo[PlayerID].bank = Bank
	PlayerInfo[PlayerID].twarns = TWarns
	PlayerInfo[PlayerID].pwarns = PWarns
	PlayerInfo[PlayerID].registerts = RegisterTs
	PlayerInfo[PlayerID].registerdate = RegisterDate
	PlayerInfo[PlayerID].registertime = RegisterTime
	PlayerInfo[PlayerID].ingame = os.time()
	PlayerInfo[PlayerID].connections = Connections
	
	PlayerProfile[PlayerID].age = ProfileAge
	PlayerProfile[PlayerID].female = ProfileFemale
	PlayerProfile[PlayerID].male = ProfileMale
	
	PlayerBanInfo[PlayerID] = {}
	PlayerBanInfo[PlayerID].timestamp = Timestamp
	PlayerBanInfo[PlayerID].bantime = Bantime
	
	Fishing[PlayerID] = {}	
	Fishing[PlayerID].baited = 0
	Fishing[PlayerID].bited = 0
	Fishing[PlayerID].throw = 0
	
	Lottery[PlayerID].number = nil
	Lottery[PlayerID].prize = nil
	Lottery[PlayerID].winned = nil
	
	VehicleColor[PlayerID].menu = 0
	VehicleColor[PlayerID].primary = 0
	VehicleColor[PlayerID].secundary = 0
	VehicleColor[PlayerID].originalp = nil
	VehicleColor[PlayerID].originals = nil
	
	Points[PlayerID] = {}
	
	PlayerConnected[PlayerID] = os.time()
	
	setPlayerCash(PlayerID,RestoreMoney)
	
	for i,v in pairs(BusinessOwner) do
		if v == Nickname then
			PlayerBusinessTime[PlayerID] = tonumber(vread("Business/Active.txt", Nickname) or 0)
		end
	end
	
	if IsPlayerOwned == 1 then
		outputChatBox(PlayerID,"You have been Full IP Banned",30,144,255,255)
		kickPlayer(PlayerID)
	end
	if isNicknameBlocked(Nickname) then
		outputChatBox(PlayerID,"You cannot use this Nickname in Metagaming",30,144,255,255)
		outputChatBox(PlayerID,"Please select another name and come back!",30,144,255,255)
		kickPlayer(PlayerID)
	end
	
	outputChatBox(PlayerID,"Welcome to Metagaming RPG," .. Nickname .. "",30,144,255,255)
	clearGameTextForPlayer(PlayerID)
	
	if Registered == 1 then
		if RegisteredIP == PlayerIP then
			if isPlayerBanned(PlayerID) == 0 then
				LogInThisAccount(PlayerID)
				outputChatBox(PlayerID,"You have been auto-logged in",30,144,255,255)
				local Connections = PlayerInfo[PlayerID].connections
	
				if Connections == 0 then
					outputChatBox(Nickname .. " is new to Metagaming RPG!",30,144,255,255)
					PlayerInfo[PlayerID].connections = Connections + 1		
					vwrite("Profile/Connections.txt",Nickname,Connections + 1)
				else
					outputChatBox(Nickname .. " has connected " .. PlayerInfo[PlayerID].connections .. " times to Metagaming RPG!",30,144,255,255)
					PlayerInfo[PlayerID].connections = Connections + 1		
					vwrite("Profile/Connections.txt",Nickname,Connections + 1)
				end
			else
				local Timeleft = round(remainingBanTime(Nickname))
				outputChatBox(PlayerID,"You are banned for " .. Timeleft .. " minutes. Come back later", 30,144,255,255)
				kickPlayer(PlayerID)
			end
		else
			LogOutThisAccount(PlayerID)
			outputChatBox(PlayerID,"You are not logged in",30,144,255,255)
			outputChatBox(PlayerID,"You must login within the next 30 seconds or you will be autokicked",30,144,255,255)
			vtimer("KickAfterNotLogginIn_"..PlayerID,1,30000,"KickAfterNotLogin",PlayerID)
		end
	end
end

function onPlayerEnterGlobalMarker(PlayerID,MarkerID,Type)
	local Nickname = getPlayerName(PlayerID)	
	local Cash = mgGetPlayerCash(PlayerID)
	if MarkerID == pnp1 or MarkerID == pnp2 or MarkerID == pnp3 or MarkerID == pnp4 or MarkerID == pnp5 then 
		if isPlayerInAnyVehicle(PlayerID) == 1 then			
			if Cash >= 100 then
				outputChatBox(PlayerID,"Your vehicle is being repaired...",050,205,050,255)
				mgTakeCash(PlayerID,100)
				togglePlayerControllable(PlayerID,0)
				vtimer("PayNSpray"..PlayerID,1,5000,"PayNSpray",PlayerID)
			else
				outputChatBox(PlayerID,"You dont have enough money to repair your vehicle",255,69,0,255)
			end
		end
	end
	--[[local MarkerNID = nvcmt2[MarkerID]
	if MarkerNID then
		setPlayerPos(PlayerID, nvcmt[MarkerNID].tx, nvcmt[MarkerNID].ty, nvcmt[MarkerNID].tz)
		setPlayerAngle(PlayerID, nvcmt[MarkerNID].tangle)
		setPlayerInterior(PlayerID, nvcmt[MarkerNID].tint)
	end--]]
	if MarkerID == Sunshine then
		local VehicleID = getPlayerVehicleID(PlayerID)
		local Nickname = getPlayerName(PlayerID)
		local Cash = mgGetPlayerCash(PlayerID)		
		if isPlayerInAnyVehicle(PlayerID) == 1 then
			if Vehicle[VehicleID] == Nickname then
				if Cash > 200 then
					VehicleColor[PlayerID].menu = 1					
					togglePlayerControllable(PlayerID,0)
					setPlayerCameraPos(PlayerID,-1024.640137,-865.451416,15.085196)
					setPlayerCameraLookAt(PlayerID,-1030.151367,-857.416870,13.085196,0)
					setVehiclePos(VehicleID,-1030.151367,-857.416870,13.085196)
					setVehicleAngle(VehicleID,140)					
					outputChatBox(PlayerID,"Welcome to Sunshine Autos Car color change",0,178,238,255)
					outputChatBox(PlayerID,"Use Right and Left to change colors",0,178,238,255)
					outputChatBox(PlayerID,"Use Spacebar to switch between primary and secundary",0,178,238,255)
					outputChatBox(PlayerID,"Press ESC to leave. Press H to leave without any changes",0,178,238,255)
					local p,s = getVehicleColor(VehicleID)
					VehicleColor[PlayerID].originalp = p
					VehicleColor[PlayerID].originals = s
					setVehicleColor(VehicleID,0,0)					
					gameTextForPlayer(PlayerID,"	~h~			Primary",4,100000000)	
					destroyGlobalCheckpoint(Sunshine)
				end
			else
				outputChatBox(PlayerID,"You dont own this vehicle to change its color",255,69,0,255)
			end
		end				
	end
end



function onPlayerDeath(PlayerID,KillerID,WeaponID)
	local Nickname = getPlayerName(PlayerID)
	if strval(KillerID) == 255 then
		if WeaponID == 255 then		
			outputChatBox(getPlayerName(strval(PlayerID)) .. " died.",255,140,0,255)			
		else
			outputChatBox(getPlayerName(strval(PlayerID)) .. " died. (" .. getWeaponName(strval(WeaponID)) .. ")",255,140,0,255)			
		end
		return
	end
	outputChatBox(getPlayerName(strval(KillerID)) .. " killed " .. getPlayerName(strval(PlayerID)) .. ". (" .. getWeaponName(strval(WeaponID)) .. ")",255,140,0,255)	
end

function onPlayerSpawn(PlayerID)
	local Nickname = getPlayerName(PlayerID)	
	local Register = PlayerInfo[PlayerID].registered
	local Male = PlayerProfile[PlayerID].male
	local Female = PlayerProfile[PlayerID].female
	if Register == 0 then
		if Male == 0 or Female == 0 then
			outputChatBox(PlayerID,"Welcome to Metagaming RPG Server for the first time!",30,144,255,255)
			outputChatBox(PlayerID,"This is a server where we Roleplay, so please stick to the rules",30,144,255,255)
			outputChatBox(PlayerID,"You can check our rules by doing: /rules",30,144,255,255)
			vtimer("ContinueRegister_"..PlayerID,1,4000,"ContinueRegister",PlayerID)
			togglePlayerControllable(PlayerID,0) 
		end
	end
end

function onPlayerKeyPress(PlayerID, KeyID)
	local Nickname = getPlayerName(PlayerID)
	local Register = PlayerInfo[PlayerID].registered or 0
	local Sex = PlayerInfo[PlayerID].sex or 0
	local Age = PlayerInfo[PlayerID].age or 0
	
	if KeyID == 39 then
		if Register == 1 then
			if Sex == 1 then
				clearGameTextForPlayer(PlayerID)
				gameTextForPlayer(PlayerID,"	~h~		Male   ~y~ 		Female",4,100000000)
				local TurnToFemale = 2
				PlayerInfo[PlayerID].sex = TurnToFemale
				vwrite("Files/Sex.txt",Nickname,TurnToFemale)
				
			end
			if Age >= 1 then
				clearGameTextForPlayer(PlayerID)
				local AddOne = Age + 1
				PlayerInfo[PlayerID].age = AddOne
				vwrite("Files/Account/Age.txt",Nickname,AddOne)
				--gameTextForPlayer(PlayerID,"~b~ Your Age:	~y~		" .. Age,4,100000000)
				vtimer("PreventAge0_"..PlayerID,1,100,"PreventAge0",PlayerID)	
			end
		end
		if VehicleColor[PlayerID].menu == 1 then
			local VehicleID = getPlayerVehicleID(PlayerID)
			local Primary = VehicleColor[PlayerID].primary
			local Secundary = VehicleColor[PlayerID].secundary
			if Primary < 95 then
				VehicleColor[PlayerID].primary = Primary + 1
				setVehicleColor(VehicleID,Primary + 1,Secundary)
			else
				outputChatBox(PlayerID,"You have reached the maximum primary color",0,178,238,255)
				outputChatBox(PlayerID,"Use Spacebar to switch between primary and secundary",0,178,238,255)
				outputChatBox(PlayerID,"Press ESC to leave. Press H to leave without any changes",0,178,238,255)
			end
		end
		if VehicleColor[PlayerID].menu == 2 then
			local VehicleID = getPlayerVehicleID(PlayerID)
			local Primary = VehicleColor[PlayerID].primary
			local Secundary = VehicleColor[PlayerID].secundary
			if Secundary < 95 then
				VehicleColor[PlayerID].secundary = Secundary + 1
				setVehicleColor(VehicleID,Primary,Secundary + 1)
			else
				outputChatBox(PlayerID,"You have reached the maximum secundary color",0,178,238,255)
				outputChatBox(PlayerID,"Use Spacebar to switch between primary and secundary",0,178,238,255)
				outputChatBox(PlayerID,"Press ESC to leave. Press H to leave without any changes",0,178,238,255)
			end
		end
	end
	if KeyID == 37 then
		if Register == 1 then
			if Sex == 2 then
				clearGameTextForPlayer(PlayerID)
				gameTextForPlayer(PlayerID,"	~y~		Male   ~h~ 		Female",4,100000000)
				local TurnToMale = 1
				PlayerInfo[PlayerID].sex = TurnToMale
				vwrite("Files/Sex.txt",Nickname,TurnToMale)
			end
			if Age >= 1 then
				clearGameTextForPlayer(PlayerID)
				local TakeOne = Age - 1
				PlayerInfo[PlayerID].age = TakeOne
				vwrite("Files/Account/Age.txt",Nickname,TakeOne)
				--gameTextForPlayer(PlayerID,"~b~ Your Age:	~y~		" .. Age,4,100000000)
				vtimer("PreventAge0_"..PlayerID,1,100,"PreventAge0",PlayerID)
			end
		end
		if VehicleColor[PlayerID].menu == 1 then
			local VehicleID = getPlayerVehicleID(PlayerID)
			local Primary = VehicleColor[PlayerID].primary
			local Secundary = VehicleColor[PlayerID].secundary
			if Primary >= 0 then
				VehicleColor[PlayerID].primary = Primary - 1
				setVehicleColor(VehicleID,Primary - 1,Secundary)
			else
				outputChatBox(PlayerID,"You have reached the minimum primary color",0,178,238,255)
				outputChatBox(PlayerID,"Use Spacebar to switch between primary and secundary",0,178,238,255)
				outputChatBox(PlayerID,"Press ESC to leave. Press H to leave without any changes",0,178,238,255)
			end
		end
		if VehicleColor[PlayerID].menu == 2 then
			local VehicleID = getPlayerVehicleID(PlayerID)
			local Primary = VehicleColor[PlayerID].primary
			local Secundary = VehicleColor[PlayerID].secundary
			if Secundary >= 0 then
				VehicleColor[PlayerID].secundary = Secundary - 1
				setVehicleColor(VehicleID,Primary,Secundary - 1)
			else
				outputChatBox(PlayerID,"You have reached the minimum secundary color",0,178,238,255)
				outputChatBox(PlayerID,"Use Spacebar to switch between primary and secundary",0,178,238,255)
				outputChatBox(PlayerID,"Press ESC to leave. Press H to leave without any changes",0,178,238,255)
			end
		end
	end
	if KeyID == 13 then
		if Register == 1 then
			if Sex == 1 then
				outputChatBox(PlayerID,"You have selected: Male, Now its time to choose your age",0,191,255,255)
				PlayerInfo[PlayerID].sex = 0
				vwrite("Files/Sex.txt",Nickname,0)
				PlayerInfo[PlayerID].age = 12
				vwrite("Files/Account/Age.txt",Nickname,12)
				
				vwrite("Profile/" .. Nickname ..".txt","male",1)
				vwrite("Profile/" .. Nickname ..".txt","female",0)
				PlayerProfile[PlayerID].male = 1
				PlayerProfile[PlayerID].female = 0
				
				clearGameTextForPlayer(PlayerID)
				vtimer("PreventAge0_"..PlayerID,1,1000,"PreventAge0",PlayerID)				
			elseif Sex == 2 then
				outputChatBox(PlayerID,"You have selected: Female, Now its time to choose your age",255,110,180,255)				
				vwrite("Files/Sex.txt",Nickname,0)
				PlayerInfo[PlayerID].sex = 0
				vwrite("Files/Account/Age.txt",Nickname,12)
				PlayerInfo[PlayerID].age = 12
				
				vwrite("Profile/" .. Nickname ..".txt","male",0)
				vwrite("Profile/" .. Nickname ..".txt","female",1)
				PlayerProfile[PlayerID].male = 0
				PlayerProfile[PlayerID].female = 1
				
				clearGameTextForPlayer(PlayerID)
				vtimer("PreventAge0_"..PlayerID,1,1000,"PreventAge0",PlayerID)				
			end
			if Age >= 1 then
				outputChatBox(PlayerID,"You have selected : " .. Age .. " years old, its time play!",0,191,255,255)
				togglePlayerControllable(PlayerID,1)
				vwrite("Profile/" .. Nickname ..".txt","age",Age)		
				PlayerProfile[PlayerID].age = Age
				restorePlayerCamera(PlayerID)
				vwrite("Files/Account/Age.txt",Nickname,0)
				PlayerInfo[PlayerID].age = 0
				vwrite("Files/Account/IsRegister.txt",Nickname,0)
				clearGameTextForPlayer(PlayerID)
			end
		end
	end
	if KeyID == 27 then
		if VehicleColor[PlayerID].menu == 1 or VehicleColor[PlayerID].menu == 2 then
			local VehicleID = getPlayerVehicleID(PlayerID)
			outputChatBox(PlayerID,"Car color changed successfully, it costed you $200",0,178,238,255)
			mgTakeCash(PlayerID,200)
			outputChatBox(PlayerID,"Thank you for using Sunshine Autos Car color change",0,178,238,255)
			VehicleColor[PlayerID].menu = 0
			VehicleColor[PlayerID].primary = 0
			VehicleColor[PlayerID].secundary = 0
			VehicleColor[PlayerID].originalp = nil
			VehicleColor[PlayerID].originals = nil
			clearGameTextForPlayer(PlayerID)
			setVehiclePos(VehicleID,-1028.877563,-874.495605,12.637050)
			setVehicleAngle(VehicleID,223)
			restorePlayerCamera(PlayerID)
			togglePlayerControllable(PlayerID,1)			
			Sunshine = createGlobalCheckpoint(-1030.151367,-857.416870,13.085196,4)
		end
	end
	if KeyID == 72 then
		if VehicleColor[PlayerID].menu == 1 or VehicleColor[PlayerID].menu == 2 then
			local VehicleID = getPlayerVehicleID(PlayerID)
			outputChatBox(PlayerID,"You have left without any changes in your vehicle",0,178,238,255)
			outputChatBox(PlayerID,"Thank you for using Sunshine Autos Car color change",0,178,238,255)
			VehicleColor[PlayerID].menu = 0
			VehicleColor[PlayerID].primary = 0
			VehicleColor[PlayerID].secundary = 0	
			clearGameTextForPlayer(PlayerID)
			setVehiclePos(VehicleID,-1028.877563,-874.495605,12.637050)
			setVehicleAngle(VehicleID,223)
			restorePlayerCamera(PlayerID)
			togglePlayerControllable(PlayerID,1)			
			Sunshine = createGlobalCheckpoint(-1030.151367,-857.416870,13.085196,4)
			setVehicleColor(VehicleID,VehicleColor[PlayerID].originalp,VehicleColor[PlayerID].originals)
			VehicleColor[PlayerID].originalp = nil
			VehicleColor[PlayerID].originals = nil	
		end
	end
	if KeyID == 32 then
		if VehicleColor[PlayerID].menu == 1 then
			VehicleColor[PlayerID].menu = 2
			gameTextForPlayer(PlayerID,"	~h~			Secundary",4,100000000)
		elseif VehicleColor[PlayerID].menu == 2 then
			VehicleColor[PlayerID].menu = 1
			gameTextForPlayer(PlayerID,"	~h~			Primary",4,100000000)
		end
	end
	if KeyID == 78 then
		setVehicleSpeed(getPlayerVehicleID(PlayerID),200)
	end
end

function onPlayerEnterVehicle(PlayerID,VehicleID,SeatID)
	local VehicleModel = getVehicleModel(VehicleID)
	local VehicleName = getVehicleNameFromModelID(VehicleModel)
	local Nickname = getPlayerName(PlayerID)
	local WordPrefix = vgetWordPrefix(VehicleName)	
	
	if not Vehicle[VehicleID] then	
		outputChatBox(PlayerID,Nickname .. " entered " .. WordPrefix .. " " .. VehicleName .. " Owner: None | Price: $" .. VehiclePrice[VehicleModel] .. " (ID " .. VehicleID .. ")",0,178,238,255)
	else
		outputChatBox(PlayerID,Nickname .. " entered " .. WordPrefix .. " " .. VehicleName .. " Owner: " .. Vehicle[VehicleID] .. " (ID " .. VehicleID .. ")",0,178,238,255)
	end
end

--[[ - - - - - - - - - - - ]]
--[[ 	Print loaded	   ]]
--[[ - - - - - - - - - - - ]]

outputConsole("Metagaming Callbacks loaded succesfuly")