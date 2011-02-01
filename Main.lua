--[[ - - - - - - - - - - - ]]
--[[ 		Files Load     ]]
--[[ - - - - - - - - - - - ]]

--[[ Print Loading ... ]]
outputConsole("[" .. os.date() .. "] Server Started . Now loading Metagaming RPG...")

--[[ Load Engine ]]
outputConsole("[Metagaming RPG] Loading Engine")

dofile("MG/Engine/Tables.lua")
dofile("MG/Engine/Business.lua")
dofile("MG/Engine/Formulas.lua")
dofile("MG/Engine/VLE.lua")
dofile("MG/Engine/Metagaming.lua")
dofile("MG/Engine/Vehicle.lua")

--[[ Load File/Timers System ]]
outputConsole("[Metagaming RPG] Loading VLE Essentials")
dofile("MG/VLE/Files.lua")
dofile("MG/VLE/Timers.lua")

--[[ Load VLE Light ]]
dofile("MG/VLE/VLE Light.lua")

--[[ Load Metagaming ]]
outputConsole("[Metagaming RPG] Loading Metagaming Essentials")
dofile("MG/Metagaming/Metagaming-Callbacks.lua")
dofile("MG/Metagaming/Functions/Bank.lua")
dofile("MG/Metagaming/Functions/Inventory.lua")
dofile("MG/Metagaming/Functions/Lottery.lua")
dofile("MG/Metagaming/Functions/Register.lua")
dofile("MG/Metagaming/Functions/Fishing.lua")
dofile("MG/Metagaming/Functions/Vehicle.lua")
dofile("MG/Metagaming/Functions/Business.lua")
dofile("MG/Metagaming/Account.lua")
dofile("MG/Metagaming/Admin.lua")

--[[ Load Temporaries ]]
outputConsole("[Metagaming RPG] Loading Temporaries")
dofile("MG/Vehicles.lua")
dofile("MG/Objects.lua")

--[[ Load settings ]]
setServerName("Metagaming RPG Alpha")
setModeName("RPG")
setMaxPlayers(20)
setServerPassword("cake")
setServerPort(4800)
announce(true)

--[[ Load Tables ]]
PlayerInfo = {}
PlayerProfile = {}
PlayerBanInfo = {}
PlayerInv = {}
Fishing = {}
FoodSelect = {}
Lottery = {}
Vehicle = {}
VehiclePrice = {}
VehicleColor = {}
TempBanned = {}
PermBanned = {}
Points = {}
Business = {}
BusinessOwner = {}
BusinessPositions = {}
BusinessPrice = {}
BusinessName = {}
BusinessTime = {}
PlayerDate = {}
PlayerBusinessTime = {}
PlayerConnected = {}
VehicleData = {}

Items = {
	[1] = 'burger',
	[2] = 'pizza',
	[3] = 'hotdog',
	[4] = 'soda',
	[5] = 'donut',
	[6] = 'bagel',	
	[7] = 'coffee',
	[8] = 'beer',
	[9] = 'fishing rod',
	[10] = 'bait',
	[11] = 'anchovy',
	[12] = 'trout',
	[13] = 'bass',
	[14] = 'bat-ray',
	[15] = 'golden-trout',
	[16] = 'red-salmon',
	[17] = 'small-shark',
	[18] = 'salmon',
	[19] = 'manta-ray'
}

ItemPrices = {
	[1] = 20,
	[2] = 20,
	[3] = 10,
	[4] = 15,
	[5] = 10,
	[6] = 10,	
	[7] = 10,
	[8] = 5,
	[9] = 10,
	[10] = 5,
	[11] = 8,
	[12] = 7,
	[13] = 10,
	[14] = 15,
	[15] = 6,
	[16] = 17,
	[17] = 25,
	[18] = 12,
	[19] = 25
}

ItemAreas = {
	[1] = {PizzaA , PizzaB , PizzaC},
	[2] = {PizzaA , PizzaB , PizzaC},
	[3] = {PizzaA , PizzaB , PizzaC},
	[5] = {DonutsBagels},
	[6] = {DonutsBagels},
	[7] = {DonutsBagels},
	[8] = {BarDowntown}	
}

ItemMaxAmount = {
	[1] = 5,
	[2] = 5,
	[3] = 5,
	[4] = 10,
	[5] = 10,
	[6] = 10,
	[7] = 10,
	[8] = 5
}

FishesNames = {
	[1] = 'anchovy',
	[2] = 'trout',
	[3] = 'bass',
	[4] = 'bat-ray',
	[5] = 'golden-trout',
	[6] = 'red-salmon',
	[7] = 'small-shark',
	[8] = 'salmon',
	[9] = 'manta-ray'
}

FoodNames = {
	[1] = 'burger',
	[2] = 'pizza',
	[3] = 'hotdog',
	[4] = 'soda',
	[5] = 'donut',
	[6] = 'bagel',	
	[7] = 'coffee',
	[8] = 'beer'
}

FoodMessage = {
	[1] = 'You eat a hamburger, delicious!',
	[2] = 'You eat a slice of pizza, yummy!',
	[3] = 'You eat a hotdog, best hotdog in town!',
	[4] = 'You drink a soda, this calms your thirst',
	[5] = 'You eat a donut, mhhh donuts',
	[6] = 'You eat a bagel, so delicious',	
	[7] = 'You drink a coffee, hot!',
	[8] = 'You drink a beer, woaaah dizzy'

}

FoodHeal = {
	[1] = 20,
	[2] = 20,
	[3] = 15,
	[4] = 15,
	[5] = 10,
	[6] = 10,	
	[7] = 10,
	[8] = -5
}

LevelName = {
	[0] = "Un-registred player",
	[1] = "Registered player",
	[2] = "Trusted player",
	[3] = "Moderator",
	[4] = "Global Moderator",
	[5] = "Administrator",
}

WeatherName = {
	[0] = "sun",
	[1] = "cloud",
	[2] = "rain",
	[3] = "fog",
	[4] = "hot",
	[5] = "storm"
}

BlockedNames = {
	[1] = "Admin",
	[2] = "[Admin]",
	[3] = "Player",
	[4] = "The goverment",
	[5] = "fuck you",
	[6] = "fuckyou",
	[7] = ".Admin.",
	[8] = ":.Admin.:",
	[9] = "::Admin::",
	[10] = "Administrator",
	[11] = "Administratoor",
	[12] = "Administratooor",
	[13] = "Aadministrator",
	[14] = "Metagaming",
	[15] = "Metagaming Staff",
	[16] = "Metagaming Admin",
	[17] = "Metagaming Owner",
	[18] = "[Mg]",
	[19] = "[Metagaming]",
	[20] = "[MG]",
	[21] = "fuck you bruno",
	[22] = "Brunoo",
	[23] = "Brunooo",
	[24] = "Bruuno",
	[25] = "fuck",
	[26] = "bitch",
	[27] = "motherfucker",
	[28] = "mother fucker",
	[29] = "administrator",
	[30] = "administratoor",
	[31] = "admiinistrator",
}



for i,v in vfile("Files/Admin/TempBanned.txt") do
	TempBanned[i] = tonumber(v)
end

for i,v in vfile("Files/Admin/PermaBanned.txt") do
	PermBanned[i] = v
end

for i,v in vfile("Business/Price.txt") do
	BusinessPrice[tonumber(i)] = tonumber(v)
end

for i,v in vfile("Business/Name.txt") do
	BusinessName[tonumber(i)] = v
end

for i,v in vfile("Files/Admin/BlockedNames.txt") do
	table.insert(BlockedNames,i)
end

for i,v in vfile("Business/Owner.txt") do
	BusinessOwner[tonumber(i)] = v
end

for i,v in vfile("Business/Time.txt") do
    BusinessTime[tonumber(i)] = tonumber(v)
end

function LoadBusinessPositions()
	local BusinessID, XYPositions, MinZ, MaxZ
	for i,v in vfile("Business/Position.txt") do
        BusinessID = tonumber(i) 
		XYPositions = vtonumberTable(vexplode(v, ","))
		MaxZ = table.remove(XYPositions)
		MinZ = table.remove(XYPositions)

		BusinessPositions[BusinessID] = { XYPositions, MinZ, MaxZ }
	end
end

function LoadBusinessIncomes()
	local BusinessID, Income
	for i,v in vfile("Business/Incomes.txt") do
		BusinessID = tonumber(i)
		Income = tonumber(v)
		
		Business[BusinessID] = Income
	end
end

function LoadVehicles()
	local OldVehicleID,Data
	local NewVehicleID
	
	for i,v in vfile("Vehicle/Vehicles.txt") do
	OldVehicleID = tonumber( i )
	Data = vtonumberTable(vexplode( v, " " ))
	NewVehicleID = createVehicle(unpack(Data))
	VehicleData[NewVehicleID] = Data
	
	local VehicleFile = io.open("Vehicle/Vehicles.txt","w+b")
	VehicleFile:write(NewVehicleID  .. " " .. Data)
	io.close(VehicleFile)
	
	end
end

LoadVehicles()	
LoadBusinessIncomes()
LoadBusinessPositions()

for i,v in vfile("Vehicle/Owner.txt") do
	Vehicle[tonumber( i )] = v
end

for i,v in vfile("Vehicle/Price.txt") do
	VehiclePrice[tonumber( i )] = v
end

--[[ Print Loading results ]]
outputConsole("---------------------------------")
outputConsole("Metagaming loaded completly . Results:")
outputConsole("Metagaming has loaded " .. #Business .. " businesses")

--[[ Load Temporary Commands ]]

addCommand("removebusinessowner","RemoveBusinessOwner")
addCommand("mybusiness","MyBusiness")
addCommand("checkout","CheckoutBusiness")
addCommand("setbusinessowner","SetBusinessOwner")
addCommand("sellbusiness","SellBusiness")
addCommand("buybusiness","BuyBusiness")
addCommand("removeblockedname","removeBlockedNickname")
addCommand("addblockname","addBlockedNickname")
addCommand("stats","statsPlayer")
addCommand("countbusiness","countBusinesses")
addCommand("business","checkBusiness")
addCommand("savepoint","saveBusinessPoint")
addCommand("createbusiness","createBusiness")
addCommand("removepos","dumpPositions")
addCommand("flip","flipVehicle")
addCommand("repair","repairmgVehicle")
addCommand("car","PrintCarDriving")
addCommand("removecarowner","RemoveVehicleOwner")
addCommand("setcarowner","SetVehicleOwner")
addCommand("unpwarn","unPermWarn")
addCommand("untwarn","unTempWarn")
addCommand("unpban","unPermBan")
addCommand("untban","unTempBan")
addCommand("gotocar","GotoCar")
addCommand("getcar","GetCar")
addCommand("info","ChartInfo")
addCommand("startweather","AliveWeatherSystem")
addCommand("killweather","KillWeatherSystem")
addCommand("get","GetPlayer")
addCommand("goto","GotoPlayer")
addCommand("profile","GetProfile")
addCommand("unfreeze","UnFreezePlayer")
addCommand("freeze","FreezePlayer")
addCommand("banalias","BanAliasTypeB")
addCommand("alias","CheckAliases")
addCommand("pwarn","PermWarnPlayer")
addCommand("twarn","TempWarnPlayer")
addCommand("settime","SetTime")
addCommand("setlevel","SetLevel")
addCommand("asay","AdminSay")
addCommand("heal","SetHealth")
addCommand("setweather","SetWeather")
addCommand("tban","TempBanPlayer")
addCommand("pban","PermBanPlayer")
addCommand("kick","KickPlayer")
addCommand("level","CheckPlayerLevel")
addCommand("register","RegisterAccount")
addCommand("login","LogIntoThisAccount")
addCommand("slap","SlapPlayer")
addCommand("mycar","MyCar")
addCommand("sellcar","SellCar")
addCommand("buycar","BuyCar")
addCommand("lottery","CheckTicket")
addCommand("sellfish","SellFish")
addCommand("line","FishingLine")
addCommand("buybait","BuyBait")
addCommand("buyrod","BuyFishingRod")
addCommand("claimlottery","PrizeClaim")
addCommand("buyticket","BuyLotteryTicket")
addCommand("buy","BuyCommand")
addCommand("stopanim","StopAnimation")
addCommand("eat","UseFoodFromInventory")
addCommand("inventory","PrintMyInventory")
addCommand("bank","CurrentMoney")
addCommand("newbankacc","CreateBankAccount")
addCommand("withdraw","WitdrawMoney")
addCommand("deposit","DepositMoney")
addCommand("wiretransfer","WireTransfer")

--[[ - - - - - - - - ]]
--[[ Spawn settings  ]]
--[[ - - - - - - - - ]]

-- This is just to test with a spawn, later we'll add a nice spawn system with TABLES

local ClassID = 
	addSpawnClass("MetaGaming RPG",30,144,255,91.3151,281.051,22.0514,25,87.7601,291.28,22.8239,0)
for i = 68,68 do
	addClassMember(ClassID,i,92.1511,279.725,21.556,25,0,0,0,0,0,0) 
end

--[[ - - - - - - - - ]]
--[[ Test functions  ]]
--[[ - - - - - - - - ]]


function testReadingMultiple(PlayerID)
	for i,v in vfile("Vehicles.txt") do
		local i = tonumber( i )
		local Model, X, Y, Z, Angle,Col1, Col2 = unpack(vtonumberTable(vexplode( v, " " )))
		outputChatBox(Model .. " , " .. X .. " , " .. Y .. " , " .. Z .. " , " .. Angle .. " , " .. Col1 .. " , " .. Col2,0,255,0,255)
	end
end

addCommand("multiplereading","testReadingMultiple")

function testDistance(PlayerID,VehicleID)
	local VehicleID = tonumber(VehicleID)
	local X,Y,Z = getPlayerPos(PlayerID)
	local X1,Y1,Z1 = getVehiclePos(VehicleID)
	outputChatBox(vgetDistance(X,Y,Z,X1,Y1,Z1,0),255,110,180,255)
	outputChatBox(getDistance(X,Y,Z,X1,Y1,Z1),0,255,0,255)
end

addCommand("distance","testDistance")

function testCamera(PlayerID)
	setPlayerCameraPos(PlayerID,-1024.640137,-865.451416,15.085196)
	setPlayerCameraLookAt(PlayerID,-1030.151367,-857.416870,13.085196,0)
end

addCommand("testcam","testCamera")

function rotateVehicle(PlayerID,VehicleID,Amount)
	local VehicleID = tonumber(VehicleID)
	local Amount = tonumber(Amount)
	local a = getVehicleAngle(VehicleID)
	setVehicleAngle(VehicleID, a + Amount or 1)
	vtimer("soplete",0,100,"rotateVehicle",PlayerID,VehicleID,Amount)
end

addCommand("rotate","rotateVehicle")


function TeleAnywhere(PlayerID)
	setPlayerPos(PlayerID,421.477081,88.150360,20.268086)
end

addCommand("tele","TeleAnywhere")

function justForFun(PlayerID)	
    setPlayerHealth(PlayerID,999)
    setPlayerArmour(PlayerID,999)	
end

function giveAngle(PlayerID)
	local Angle = getPlayerAngle(PlayerID)
	outputChatBox(PlayerID,"Your angle is: " .. Angle .. "",0,175,0,255)
end

function spawnACar(PlayerID)	
	local X,Y,Z,a = getXYInFrontOfPlayer(PlayerID,5)	
	createVehicle(132,X,Y,Z,a,-1,-1)	
end

addCommand("stinger","spawnACar")

function spawnAPCG(PlayerID)	
	local X,Y,Z,a = getXYInFrontOfPlayer(PlayerID,5)	
	createVehicle(191,X,Y,Z,a,-1,-1)	
end

addCommand("pcj","spawnAPCG")

function spawnAHeli(PlayerID)
	local X,Y,Z,a = getXYInFrontOfPlayer(PlayerID,5)	
	createVehicle(217,X,Y,Z,a,-1,-1)
end

addCommand("heli","spawnAHeli")

function spawnARandome(PlayerID)
	local X,Y,Z,a = getXYInFrontOfPlayer(PlayerID,5)
	math.randomseed(os.time() + (os.time() / 3) * (3+6))
	createVehicle(math.random(130,236),X,Y,Z,a,-1,-1)
end

addCommand("randomcar","spawnARandome")

function gotoRelease(PlayerID)
	setPlayerPos(PlayerID,-1158.783203,-1404.260498,10.923742)
end

addCommand("rc2","gotoRelease")

function addRamp(PlayerID)
	local X,Y,Z,a = getXYInFrontOfPlayer(PlayerID,5)
	createGlobalObject(583,X,Y,Z,0,0,a,0)
end

addCommand("ramp","addRamp")
	

function addCash(PlayerID)
	outputChatBox(PlayerID,"Now adding $50",30,144,255,255)
	mgAddCash(PlayerID,50)
	outputChatBox(PlayerID,"$50 Added",30,144,255,255)
end

function takeCash(PlayerID)
	outputChatBox(PlayerID,"Now taking $50",30,144,255,255)
	mgTakeCash(PlayerID,50)
	outputChatBox(PlayerID,"$50 taken",30,144,255,255)
end

function getArea(PlayerID)
	local a = getPlayerArea(PlayerID)
	outputChatBox(a,0,230,0,255)
end

function givePos(PlayerID)
	local Data = {getPlayerPos(PlayerID)}
	local RGB = { 0, 230, 0, 255 }
	outputChatBox( table.concat(Data, " | "), unpack(RGB) )
end

function teleSunshine(PlayerID)	
	local VehicleID = getPlayerVehicleID(PlayerID)
	setVehiclePos(VehicleID,-1000,-900,20)
	setPlayerPos(PlayerID,-1000,-900,20)
end

addCommand("sunshine","teleSunshine")
addCommand("pos","givePos")
addCommand("area","getArea")
addCommand("money","addCash")
addCommand("angle","giveAngle")
addCommand("metagaming","justForFun")
addCommand("take","takeCash")

function ccommand_exe(PlayerID, ...)
	local Code = table.concat(arg, " ")
	local PlayerName = getPlayerName(PlayerID)

	if Code == "" then
		outputChatBox(PlayerID, "You must type the code to be executed.",100,100,200,255)
	else
		local Status, Error = pcall(loadstring(Code))
		if Status then
			outputChatBox(PlayerName.." executed the following code:",100,100,200,255)
			outputChatBox(Code,100,100,200,255)
		else
			outputChatBox(PlayerID, "The code you typed contained an error:",200,100,100,255)
			outputChatBox(PlayerID, "Code you typed: "..Code,200,100,100,255)
			outputChatBox(PlayerID, "Error: "..Error,200,100,100,255)
		end
	end
end

addCommand("exec","ccommand_exe")

function vcommand_ocb(PlayerID, ...)
    local Code = table.concat(arg, " ")
    local PlayerName = getPlayerName(PlayerID)
    local Command = "ocb"
    
    if Code == "" then
        outputChatBox(PlayerID, "You must type the code to be executed.",050,205,050,255)
    else
        local CallData = { pcall(loadstring("return "..Code)) }
        local Status = table.remove(CallData, 1)
        if not Status then
            local Error = CallData[1]
            outputChatBox("The code you typed contained an error:",050,205,050,255)
            outputChatBox("Code: "..Code,050,205,050,255)
            outputChatBox("Error: "..Error,050,205,050,255)
        else
            outputChatBox(PlayerName.." executed code: "..Code,050,205,050,255)
            local Returns = CallData
            if #Returns == 0 then
                outputChatBox("The code did not return a value.",050,205,050,255)
            else
                local ArgsString = vgetArgsString(unpack(Returns))
                outputChatBox("Returns: "..ArgsString,050,205,050,255)
            end
        end
    end
end

addCommand("ocb","vcommand_ocb")



-- 255,69,0,255 Error
-- 30,144,255,255 Metagaming Color
-- 255,127,0,255 Success!
-- 255,127,0,255 Orange [Bank]
--	139,087,066,255
--Mex pwnz!!!!
--I RULZ!
