function ContinueRegister(PlayerID)
	setPlayerCameraPos(PlayerID,-281.540253,1720.962524,20.493670)
	setPlayerCameraLookAt(PlayerID,-291.654388,1731.425659,10.419170,1)
	setPlayerPos(PlayerID,-291.801788,1459.472900,10.325656)
	outputChatBox(PlayerID,"Since its your first time you are obligated to register to our server if you want to play",238,221,130,255)
	outputChatBox(PlayerID,"To use the register command do: /register <Password>",238,221,130,255)
	outputChatBox(PlayerID,"Remember that \"<>\" are not required in your password",238,221,130,255)
	togglePlayerControllable(PlayerID,0)
end

function PreventMale(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	vwrite("Files/Account/IsRegister.txt",Nickname,1)
	vwrite("Files/Sex.txt",Nickname,1)
	PlayerInfo[PlayerID].sex = 1
end

function PreventAge0(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Age = PlayerInfo[PlayerID].age
	gameTextForPlayer(PlayerID,"~b~ Your Age:	~y~		" .. Age,4,100000000)
end

--[[ Print Loading results ]]
outputConsole("		Register Functions Loaded")