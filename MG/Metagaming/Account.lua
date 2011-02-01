--[[ - - - - - - - - - - - ]]
--[[ 		Metagaming     ]]
--[[	Account Functions  ]]
--[[ - - - - - - - - - - - ]]

function RegisterAccount(PlayerID, ...)
	local Nickname = getPlayerName(PlayerID)	
	local Password = GetParams(arg)
	local Username = PlayerInfo[PlayerID].registered
	
	if Username == 1 then
		outputChatBox(PlayerID,"You are already registered, you cant do it twice",255,69,0,255)
	elseif not Password then
		outputChatBox(PlayerID,"You must input a password to register!",255,69,0,255)
		outputChatBox(PlayerID,"Synax: /register <Password> (dont use <> in your password)",255,69,0,255)
	else
		outputChatBox(PlayerID, "Congratulations, Your account has been created.",30,144,255,255)	
		outputChatBox(PlayerID, "Welcome to Metagaming RPG. If you need help type /help or /rules",30,144,255,255)
		outputChatBox(PlayerID, "Your level is 1: Registered player.",30,144,255,255)
		local LevelOne = 1
		vwrite("Files/Account/Level.txt",Nickname,LevelOne)
		PlayerInfo[PlayerID].level = LevelOne
		vwrite("Files/Account Passwords.txt",Nickname,Password)
		PlayerInfo[PlayerID].password = Password		
		RegisterThisAccount(PlayerID)
		LogInThisAccount(PlayerID)
		--vwrite("Inventory/" .. Nickname ..".txt","soda",1) InventoryAddItem(PlayerID,1)
		vwrite("Files/Account/FoodTime.txt",Nickname,os.time())		
		setPlayerPos(PlayerID,-292.266083,1731.855103,10.420886)
		setPlayerAngle(PlayerID,186.882599)
		setPlayerCameraPos(PlayerID,-288.980133,1715.592529,17.665932)
		setPlayerCameraLookAt(PlayerID,-292.266083,1731.855103,10.420886,0)
		outputChatBox(PlayerID, "To complete your profile, please select your sex",30,144,255,255)
		outputChatBox(PlayerID, "Use the arrows to select the highlight, choose if your Male or Female",30,144,255,255)
		outputChatBox(PlayerID, "by using the key \"Enter\" ",30,144,255,255)
		vtimer("PreventFromChoosingMale"..PlayerID,1,1000,"PreventMale",PlayerID)
		gameTextForPlayer(PlayerID,"	~y~		Male   ~h~ 		Female",4,100000000)
		togglePlayerControllable(PlayerID,0)
	end
end

function RegisterThisAccount(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local IP = getPlayerIP(PlayerID)
	
	vwrite("Files/Account/Registered.txt",Nickname,1)
	PlayerInfo[PlayerID].registered = 1
	vwrite("Files/Account/Ip.txt",Nickname,IP)
	PlayerInfo[PlayerID].ip = IP
	outputChatBox(PlayerID,"You will be auto-logged in with this IP: " .. IP .. "",30,144,255,255)
	local a = os.time()
	vwrite("Files/Account/FoodTime.txt",Nickname,a)
	PlayerInfo[PlayerID].foodtime = a
	vwrite("Alias Full/" .. IP ..".txt",Nickname,1)
	
	local Numbers = vexplode( IP, "." )
	local ClassBSubnet = table.concat( Numbers, ".", 1, 2 )
	local ClassCSubnet = table.concat( Numbers, ".", 1, 3 )
	
	vwrite("Alias B/" .. ClassBSubnet ..".txt",Nickname,1)
	vwrite("Alias C/" .. ClassCSubnet ..".txt",Nickname,1)
	vwrite("Files/Account/Registerts.txt",Nickname,os.time())
	PlayerInfo[PlayerID].registerts = os.time()
end

function LogInThisAccount(PlayerID)
	local Nickname = getPlayerName(PlayerID)	
	
	vwrite("Files/Account/Loggedin.txt",Nickname.."_LoggedIn",1)
	vwrite("Files/Account/Logints.txt",Nickname,os.time())
	PlayerInfo[PlayerID].loggedin = 1	
	PlayerInfo[PlayerID].logints = os.time()
end

function LogOutThisAccount(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	vwrite("Files/Account/Loggedin.txt",Nickname.."_LoggedIn",0)
	PlayerInfo[PlayerID].loggedin = 0
end

function LogIntoThisAccount(PlayerID, ...)
	local Nickname = getPlayerName(PlayerID)
	local IP = getPlayerIP(PlayerID)
	local Username = PlayerInfo[PlayerID].registered or 0
	local Password = GetParams(arg)
	local UserPassword = PlayerInfo[PlayerID].password
	local LoggedIn = PlayerInfo[PlayerID].loggedin or 0	
	local Tries = PlayerInfo[PlayerID].tries or 0
		
	if not Password then
		outputChatBox(PlayerID,"You must input a password to login",255,69,0,255)
		outputChatBox(PlayerID,"Syntax: /login <Password> (dont use <> in your password)",255,69,0,255)
	elseif Username == 0 then
		outputChatBox(PlayerID,"You must be registered before you login",255,69,0,255)
		outputChatBox(PlayerID,"Synax: /register <Password> (dont use <> in your password)",255,69,0,255)	
	elseif LoggedIn == 1 then
		outputChatBox(PlayerID,"You are already logged in",255,69,0,255)
	elseif Password ~= UserPassword then
		outputChatBox(PlayerID,"The password you input is incorrect",255,69,0,255)	
		local AddOneTry = Tries + 1
		vwrite("Files/Account/LoginAttempts.txt",Nickname,AddOneTry)
		PlayerInfo[PlayerID].tries = AddOneTry
		outputChatBox(PlayerID,"You have 3 chances to login before you get kicked",255,69,0,255)
	end
	if Tries == 3 then
		outputChatBox(PlayerID,"Too many login attempts , try again later!",255,69,0,255)
		kickPlayer(PlayerID)
		vwrite("Files/Account/LoginAttempts.txt",Nickname,0)
	end
	if Username == 1 and Password == UserPassword and LoggedIn == 0 then
		outputChatBox(PlayerID, "You have logged in to your account",30,144,255,255)
		vwrite("Files/Account/Ip.txt",Nickname,IP)
		PlayerInfo[PlayerID].ip = IP
		outputChatBox(PlayerID,"You will be auto-logged in with this IP: " .. IP .. "",30,144,255,255)
		vwrite("Files/Account/LoginAttempts.txt",Nickname,0)
		PlayerInfo[PlayerID].tries = 0
		vkillTimer("KickAfterNotLogginIn_"..PlayerID)
		if Connections == 0 then
			outputChatBox(Nickname .. " is new to Metagaming RPG!",30,144,255,255)
			PlayerInfo[PlayerID].connections = Connections + 1		
			vwrite("Profile/Connections.txt",Nickname,Connections + 1)
		else
			outputChatBox(Nickname .. " has connected " .. PlayerInfo[PlayerID].connections .. " times to Metagaming RPG!",30,144,255,255)
			PlayerInfo[PlayerID].connections = Connections + 1		
			vwrite("Profile/Connections.txt",Nickname,Connections + 1)
		end
	end
end

function KickAfterNotLogin(PlayerID)
	local Nickname = getPlayerName(PlayerID)	
	outputChatBox(Nickname .. " has been kicked for not logging in within 30 seconds",255,69,0,255)
	kickPlayer(PlayerID)
end


function isPlayerBanned(PlayerID)
	local Timestamp = PlayerBanInfo[PlayerID].timestamp		
	local Bantime = PlayerBanInfo[PlayerID].bantime
	
	if Timestamp and Bantime then
		if (os.time() - Timestamp) <  Bantime then return 1
			else return 0
		end
	else
		return 0
	end
end

function CheckPlayerLevel(PlayerID,TargetPlayer)
	local Nickname = getPlayerName(PlayerID)	
	local Level = GetAccountLevel(PlayerID)	
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)	
	
	if not TargetPlayer then
		outputChatBox(PlayerID,"Your level is: " .. Level .. " " .. LevelName[Level],255,215,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)		
		local Level2 = GetAccountLevel(TargetID)
		outputChatBox(PlayerID,Nickname2.. "'s level is: " .. Level2 .. " " .. LevelName[Level2],255,215,0,255)		
	end
	
end

--[[ - - - - - - - - - - - ]]
--[[ 	Print loaded	   ]]
--[[ - - - - - - - - - - - ]]


outputConsole("Account loaded succesfuly")