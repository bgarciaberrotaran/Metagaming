--[[ - - - - - - - - - - - ]]
--[[ 		Metagaming     ]]
--[[	  Admin Functions  ]]
--[[ - - - - - - - - - - - ]]

function GiveRank(Level)
	local Level = tonumber(Level)
	if LevelName[Level] then
		return LevelName[Level]
	else
		return 0
	end
end
	
function AdminSay(PlayerID, ...)
	local Text = GetParams(arg)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)	
	
	if not Text then
		outputChatBox(PlayerID,"Syntax: /asay <Text>",255,69,0,255)
	elseif Level < 3 then
		merror(PlayerID,NotEnoughLevel,"3 to use Admin Chat")
    else
        outputChatBox("[" .. LevelName[Level] .. "] " .. Nickname .. ": " .. Text,0,230,0,255)
    end
end

function SetLevel(PlayerID,TargetPlayer,Amount)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)	
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Amount = tonumber(Amount)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to set a players level")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /setlevel <PlayerName> <Amount>",255,69,0,255)	
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif TargetID == PlayerID then
		outputChatBox(PlayerID,"You cant set your own level",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /setlevel <PlayerName> <Amount>",255,69,0,255)
	elseif isFloat(Amount) then
		outputChatBox(PlayerID,"Syntax: /setlevel <PlayerName> <Amount>",255,69,0,255)
	elseif Amount > 5 or Amount < 0 then
		outputChatBox(PlayerID,"Syntax: /setlevel <PlayerName> <Amount>",255,69,0,255)
		outputChatBox(PlayerID,"Level 0: Un-registred player",255,69,0,255)
		outputChatBox(PlayerID,"Level 1: Registered player",255,69,0,255)
		outputChatBox(PlayerID,"Level 2: Trusted player",255,69,0,255)
		outputChatBox(PlayerID,"Level 3: Moderator",255,69,0,255)
		outputChatBox(PlayerID,"Level 4: Global Moderator",255,69,0,255)
		outputChatBox(PlayerID,"Level 5: Administrator",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)		
		outputChatBox(Nickname .. " has set " .. Nickname2 .. "'s level to " .. Amount .. " (" .. GiveRank(Amount) .. ")",100,149,237,255)		
		vwrite("Files/Account/Level.txt",Nickname2,Amount)
		PlayerInfo[TargetID].level = Amount
	end		
end

function KickPlayer(PlayerID,TargetPlayer, ...)  
   local Nickname = getPlayerName(PlayerID)
   local Level = GetAccountLevel(PlayerID)   
   local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
   local Reason = GetParams(arg)
   
   if Level < 3 then      
	  merror(PlayerID,NotEnoughLevel,"3 to kick a player")
   elseif not TargetPlayer then
      outputChatBox(PlayerID,"Syntax: /kick <PlayerName> <Reason>",255,69,0,255)
   elseif not TargetID then
      outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
   elseif TargetID == PlayerID then
      outputChatBox(PlayerID,"You cannot kick yourself.",255,69,0,255)
   elseif not Reason then
      outputChatBox(PlayerID,"Syntax: /kick <PlayerName> <Reason>",255,69,0,255)
   else
		local Nickname2 = getPlayerName(TargetID)
		outputChatBox(Nickname2 .. " has been kicked by " .. Nickname .. " || Reason: " .. Reason,255,69,0,255)
		kickPlayer(TargetID)
   end
end

function SlapPlayer(PlayerID, TargetPlayer, Amount)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)	
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Amount = tonumber(Amount)	
	
	if Level < 3 then		
		merror(PlayerID,NotEnoughLevel,"3 to slap a player")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /slap <PlayerName> <Amount>",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /slap <PlayerName> <Amount>",255,69,0,255)
	elseif isFloat(Amount) then
		outputChatBox(PlayerID,"Syntax: /slap <PlayerName> <Amount>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif Amount > 0 then
		local Nickname2 = getPlayerName(TargetID)
		local Health = getPlayerHealth(TargetID)
		removePlayerFromVehicle(TargetID)
		outputChatBox(Nickname .. " has slapped " .. Nickname2 .. " for " .. Amount .. " of Hp. Ouch!",100,149,237,255)
		setPlayerHealth(TargetID, Health - Amount)
	elseif Amount == 0 then
		local Nickname2 = getPlayerName(TargetID)		
		local X1,Y1,Z1 = getPlayerPos(TargetID)
		outputChatBox(Nickname .. " has slapped " .. Nickname2 .. " for " .. Amount .. " of Hp!",100,149,237,255)		
		setPlayerPos(TargetID,X1,Y1,Z1+3)
	else
		outputChatBox(PlayerID,"Syntax: /slap <PlayerName> <Amount>",255,69,0,255)
	end
end


function mgPermaBan(PlayerID)
	local IP = getPlayerIP(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	vwrite("Files/Admin/PermaBanned.txt",Nickname,IP)
	PermBanned[Nickname] = IP
end


function mgTempBan(PlayerID,Time)
	local Nickname = getPlayerName(PlayerID)	
	local Timestamp = os.time()
	local Time = tonumber(Time)
	
	vwrite("Files/Admin/TempBanned.txt", Nickname .. "_timestamp", Timestamp)
	PlayerBanInfo[PlayerID].timestamp = Timestamp
	vwrite("Files/Admin/TempBanned.txt", Nickname .. "_bantime", Time*60)
	PlayerBanInfo[PlayerID].bantime = Time*60
	TempBanned["Mex_bantime"] = Time*60
	TempBanned["Mex_timestamp"] = Timestamp
end
	
function remainingBanTime(Nickname)
	local timestamp = PlayerBanInfo[PlayerID].timestamp
	local bantime = PlayerBanInfo[PlayerID].bantime
	
	if timestamp and bantime then
		return (bantime - (os.time() - timestamp))/60
	else return 0
	end
end

function TempBanPlayer(PlayerID,TargetPlayer,Time, ...)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)	
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Time = tonumber(Time)	
	local Reason = GetParams(arg)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to ban a player temporaly")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /tban <PlayerName> <Minutes> <Reason>",255,69,0,255)
	elseif not Reason then
		outputChatBox(PlayerID,"Syntax: /tban <PlayerName> <Minutes> <Reason>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif not Time then
		outputChatBox(PlayerID,"Syntax: /tban <PlayerName> <Minutes> <Reason>",255,69,0,255)
	elseif Time < 0 or Time > 720 then
		outputChatBox(PlayerID,"You cant ban that amount of time",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		outputChatBox(Nickname2 .. " has been temporaly banned by " .. Nickname .. " for " .. Time .. " minutes || Reason: " .. Reason .. "",255,69,0,255)
		mgTempBan(TargetID,Time)
		kickPlayer(TargetID)
	end	
end
	

function PermBanPlayer(PlayerID,TargetPlayer, ...)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)		
	local IP = getPlayerIP(PlayerID)
	local Reason = GetParams(arg)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to ban a player permanently")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /pban <Player Name> <Reason>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif not Reason then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		outputChatBox(Nickname2 .. " has been permanently banned by " .. Nickname .. " || Reason: " .. Reason .. "",255,69,0,255)
		mgPermaBan(TargetID)
		banPlayer(TargetID)
	end	
end

function TempWarnPlayer(PlayerID,TargetPlayer, ...)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Reason = GetParams(arg)
	
	if Level < 3 then		
		merror(PlayerID,NotEnoughLevel,"3 to temporaly warn a player")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /twarn <PlayerName> <Reason>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif not Reason then
		outputChatBox(PlayerID,"Syntax: /twarn <PlayerName> <Reason>",255,69,0,255)
	elseif TargetID == PlayerID then
		outputChatBox(PlayerID,"You cant temporarly warn yourself",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		local Warns = PlayerInfo[TargetID].twarns	
		if Warns == 2 then
			outputChatBox(Nickname2 .. " has been kicked by " .. Nickname .. " for the accumulation of 3 temporaly warnings",255,69,0,255)
			outputChatBox("Reason: " .. Reason .. "",255,69,0,255)
			vwrite("Files/Admin/Twarns.txt",Nickname2,0)
			PlayerInfo[TargetID].twarns = 0
			kickPlayer(TargetID)
		elseif Warns == 1 then
			outputChatBox(TargetID,"You have been temporaly warned by " .. Nickname .. "",255,69,0,255)
			outputChatBox(TargetID,"You have 1 warning left before you get kicked || Reason: " .. Reason,255,69,0,255)
			outputChatBox(Nickname .. " has temporaly warned " .. Nickname2 .. " Reason:" .. Reason,100,149,237,255)
			local AddOne = Warns + 1
			vwrite("Files/Admin/Twarns.txt",Nickname2,AddOne)
			PlayerInfo[TargetID].twarns = AddOne
		elseif Warns == 0 then
			outputChatBox(TargetID,"You have been temporaly warned by " .. Nickname .. "",255,69,0,255)
			outputChatBox(TargetID,"You have 2 warnings left before you get kicked || Reason: " .. Reason,255,69,0,255)
			outputChatBox(Nickname .. " has temporaly warned " .. Nickname2 .. " Reason:" .. Reason,100,149,237,255)
			local AddOne = Warns + 1
			vwrite("Files/Admin/Twarns.txt",Nickname2,AddOne)
			PlayerInfo[TargetID].twarns = AddOne
		end
	end
end

function PermWarnPlayer(PlayerID,TargetPlayer, ...)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Reason = GetParams(arg)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to permantly warn a player")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /pwarn <PlayerName> <Reason>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif not Reason then
		outputChatBox(PlayerID,"Syntax: /pwarn <PlayerName> <Reason>",255,69,0,255)
	elseif TargetID == PlayerID then
		outputChatBox(PlayerID,"You cant permanently warn yourself",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		local Warns = PlayerInfo[TargetID].pwarns
		if Warns == 2 then
			outputChatBox(Nickname2 .. " has been baned for 30 minutes by " .. Nickname .. " for the accumulation of 3 permantly warnings",255,69,0,255)
			TempBanPlayer(PlayerID,TargetID,30, "[Auto TempBan] Accumulation of 3 perm warnings")
			vwrite("Files/Admin/Pwarns.txt",Nickname2,0)
			PlayerInfo[TargetID].pwarns = 0
		elseif Warns == 1 then
			outputChatBox(TargetID,"You have been permantly warned by " .. Nickname,255,69,0,255)
			outputChatBox(TargetID,"You have 1 warning left before you get banned || Reason: " .. Reason,255,69,0,255)
			outputChatBox(PlayerID,"You have warned " .. Nickname2 .. " he has 1 more warning before he gets banned",100,149,237,255)
			local AddOne = Warns + 1
			vwrite("Files/Admin/Pwarns.txt",Nickname2,AddOne)
			PlayerInfo[TargetID].pwarns = AddOne
		elseif Warns == 0 then
			outputChatBox(TargetID,"You have been permantly warned by " .. Nickname,255,69,0,255)
			outputChatBox(TargetID,"You have 2 warnings left before you get banned || Reason: " .. Reason,255,69,0,255)
			outputChatBox(PlayerID,"You have warned " .. Nickname2 .. " he has 2 more warning before he gets banned",100,149,237,255)
			local AddOne = Warns + 1
			vwrite("Files/Admin/Pwarns.txt",Nickname2,AddOne)
			PlayerInfo[TargetID].pwarns = AddOne
		end
	end	
end

function SetHealth(PlayerID,TargetPlayer, Amount)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Amount = tonumber(Amount)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to heal a player")
	elseif not TargetPlayer then
		outputChatBox(Nickname .. " has healed himself for 100 of Hp.",100,149,237,255)
		setPlayerHealth(PlayerID, 100)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /heal <PlayerName> <Amount>",255,69,0,255)
	elseif isFloat(Amount) then
		outputChatBox(PlayerID,"Syntax: /heal <PlayerName> <Amount>",255,69,0,255)
	else
		local Health = getPlayerHealth(TargetID)
		local Nickname2 = getPlayerName(TargetID)
		if Health + Amount <= 100 then
			if TargetID == PlayerID then
				
			else
				outputChatBox(Nickname .. " has healed " .. Nickname2 .. " for " .. Amount .. " of Hp.",100,149,237,255)
				setPlayerHealth(TargetID, Health + Amount)
			end
		elseif TargetID == PlayerID then
			outputChatBox(Nickname .. " has restored his Hp",100,149,237,255)
			setPlayerHealth(PlayerID,100)
		elseif TargetID ~= PlayerID then
			outputChatBox(Nickname .. " has restored " .. Nickname2 .. "'s Hp",100,149,237,255)
			setPlayerHealth(TargetID,100)
		else		
			outputChatBox(PlayerID,"You cant heal a player for more than 100",255,69,0,255)			
		end
	end		
end

function SetWeather(PlayerID, ...)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)	
	local Weather = GetParams(arg)
	
	if Level < 3 then
		merror(PlayerID,NotEnoughLevel,"3 to set the weather")
	elseif not Weather then
		outputChatBox(PlayerID,"Syntax: /setweather <Weather Name>",255,69,0,255)
		outputChatBox(PlayerID,"Weathers are: sun, cloud, rain , storm, hot , fog",255,69,0,255)
	elseif vinTable(WeatherName,Weather) then
		string.lower(Weather)
		outputChatBox(Nickname .. " has set the weather to: " .. Weather,100,149,237,255)
		setServerWeather(tonumber(getTableKey(WeatherName,Weather)))
	else		
		outputChatBox(PlayerID,"Syntax: /setweather <Weather Name>",255,69,0,255)
		outputChatBox(PlayerID,"Weathers are: sun, cloud, rain , storm, hot , fog",255,69,0,255)
	end
end

function SetTime(PlayerID,Hours,Minutes)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local Hours = tonumber(Hours)
	local Minutes = tonumber(Minutes)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to set the time")
	elseif not Hours then
		outputChatBox(PlayerID,"Syntax: /settime <Hours> <Minutes>",255,69,0,255)
	elseif not Minutes then
		outputChatBox(PlayerID,"Syntax: /settime <Hours> <Minutes>",255,69,0,255)
	elseif isFloat(Hours) then
		outputChatBox(PlayerID,"Syntax: /settime <Hours> <Minutes>",255,69,0,255)
	elseif isFloat(Minutes) then
		outputChatBox(PlayerID,"Syntax: /settime <Hours> <Minutes>",255,69,0,255)
	elseif Minutes == 0 then
		setServerTime(Hours,Minutes)
		outputChatBox(Nickname .. " has set the time to: " .. Hours .. ":" .. Minutes .. "0",100,149,237,255)
	else
		setServerTime(Hours,Minutes)
		outputChatBox(Nickname .. " has set the time to: " .. Hours .. ":" .. Minutes .. "",100,149,237,255)
	end
end

function CheckAliases(PlayerID,TargetPlayer, ...)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local Type = string.lower(table.concat(arg," ") )
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to check a player alias")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /alias <PlayerName> <Full,B,C>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif Type == "" then
		outputChatBox(PlayerID,"Syntax: /alias <PlayerName> <Full,B,C>",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		local IP = getPlayerIP(TargetID)
		local a = 1
		if Type == "full" then
			outputChatBox(PlayerID,"Alias Full for " .. Nickname2 .. " || (IP: " .. IP .. ")",102,205,0,255)
			for i,v in vfile("Alias Full/" .. IP ..".txt") do
				outputChatBox(PlayerID,a ..") " .. i,102,205,0,255)		
				a = a + 1
			end
		elseif Type == "b" then
			local Numbers = vexplode( IP, "." )
			local ClassBSubnet = table.concat( Numbers, ".", 1, 2 )			
			outputChatBox(PlayerID,"Alias B for " .. Nickname2 .. " || (IP: " .. IP .. ")",102,205,0,255)
			for i,v in vfile("Alias B/" .. ClassBSubnet ..".txt") do
				outputChatBox(PlayerID,a ..") " .. i,102,205,0,255)		
				a = a + 1
			end
		elseif Type == "c" then
			local Numbers = vexplode( IP, "." )
			local ClassCSubnet = table.concat( Numbers, ".", 1, 3 )			
			outputChatBox(PlayerID,"Alias C for " .. Nickname2 .. " || (IP: " .. IP .. ")",102,205,0,255)
			for i,v in vfile("Alias C/" .. ClassCSubnet ..".txt") do
				outputChatBox(PlayerID,a ..") " .. i,102,205,0,255)		
				a = a + 1
			end
		end
	end
end

function BanAliasTypeB(PlayerID,TargetPlayer)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to ban a player alias")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /banalias <PlayerName>",255,69,0,255)
	else
		local IP = getPlayerIP(TargetID)
		local Numbers = vexplode( IP, "." )
		local ClassBSubnet = table.concat( Numbers, ".", 1, 2 )
		vwrite("Alias B/" .. ClassBSubnet ..".txt","Banned",1)
		outputChatBox(TargetID,"Your entire IP Range has been banned, see you later!",255,69,0,255)
		outputChatBox(TargetID,"Your entire IP Range has been banned, see you later!",255,69,0,255)
		outputChatBox(TargetID,"Your entire IP Range has been banned, see you later!",255,69,0,255)
		outputChatBox(TargetID,"Your entire IP Range has been banned, see you later!",255,69,0,255)
		outputChatBox(TargetID,"Your entire IP Range has been banned, see you later!",255,69,0,255)
		outputChatBox(TargetID,"Your entire IP Range has been banned, see you later!",255,69,0,255)
		outputChatBox(PlayerID,"You have banned " .. Nickname2 .. "'s entire IP Range, damn! (IP:" .. IP .. ")",100,149,237,255)
		kickPlayer(TargetID)
	end
end

function FreezePlayer(PlayerID,TargetPlayer,Time)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Time = tonumber(Time)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to freeze a player")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /freeze <PlayerName> <Time in seconds>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif not Time then
		outputChatBox(PlayerID,"Syntax: /freeze <PlayerName> <Time in seconds>",255,69,0,255)
	elseif Time <= 0 then
		outputChatBox(PlayerID,"The time has to be bigger than 0",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		outputChatBox(TargetID,"You have been freezed by " .. Nickname .. " for " .. Time .. " seconds",100,149,237,255)
		togglePlayerControllable(TargetID,0)
		vtimer("Unfreeze"..TargetID,1,Time*1000,"AutoUnfreeze",TargetID)
		outputChatBox(PlayerID,"You have freezed " .. Nickname2 .. " for " .. Time .. " seconds",100,149,237,255)
	end
	
end

function AutoUnfreeze(PlayerID)
	togglePlayerControllable(PlayerID,1)
	outputChatBox(PlayerID,"You have been automaticly unfrozen",100,149,237,255)
end

function UnFreezePlayer(PlayerID,TargetPlayer)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to un-freeze a player")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /unfreeze <PlayerName>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		outputChatBox(TargetID,"You have been un-freezed by " .. Nickname,100,149,237,255)
		togglePlayerControllable(TargetID,1)
		vkillTimer("Unfreeze"..TargetID)
		outputChatBox(PlayerID,"You have un-freezed " .. Nickname2,100,149,237,255)		
	end
end

function GetProfile(PlayerID,TargetPlayer)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)	
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to check a player's profile")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /profile <PlayerName>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	else	
		local Nickname2 = getPlayerName(TargetID)
		local Age = PlayerProfile[PlayerID].age
		local male = PlayerProfile[PlayerID].male
		local female = PlayerProfile[PlayerID].female
		local Bank = PlayerInfo[PlayerID].bank or 0
		local CurrentCash = mgGetPlayerCash(TargetID)
		outputChatBox(PlayerID,Nickname2 .. "'s Profile",244,164,096,255)		
		if male == 1 then
			outputChatBox(PlayerID,"Sex: Male",244,164,096,255)
		elseif female == 1 then
			outputChatBox(PlayerID,"Sex: Female",244,164,096,255)
		end
		outputChatBox(PlayerID,"Money in pocket: $" .. CurrentCash .. " | Money in Bank: $" .. Bank,244,164,096,255)
		outputChatBox(PlayerID,"Current Ip: " .. getPlayerIP(TargetID),244,164,096,255)
		outputChatBox(PlayerID,"Age: " .. Age .. " (born in " .. 2010 - Age .. ")",244,164,096,255)
		outputChatBox(PlayerID,"Time ingame: " .. vgetTimeString(os.time() - PlayerInfo[TargetID].ingame),244,164,096,255)
	end	
end

function GetPlayer(PlayerID,TargetPlayer,Silent)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local X,Y,Z = getXYInFrontOfPlayer(PlayerID,3)
	local Angle = getPlayerAngle(PlayerID)	
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to teleport a player")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /get <PlayerName>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server.",255,69,0,255)
	elseif TargetID == PlayerID then
		outputChatBox(PlayerID,"You cant teleport yourself.",255,69,0,255)
	elseif isPlayerSpawned(TargetID) == 0 then
		outputChatBox(PlayerID,"The player name you typed is not spawned",255,69,0,255)
	elseif not Silent then	
		local Nickname2 = getPlayerName(TargetID)		
		outputChatBox(TargetID,"You were teleported to " .. Nickname,100,149,237,255)
		outputChatBox(PlayerID,"You teleported " .. Nickname2 .. " to yourself",100,149,237,255)		
		if isPlayerInAnyVehicle(TargetID) == 1 then
			local VehicleID = getPlayerVehicleID(TargetID)
			local Interior = getPlayerInterior(PlayerID)
			setPlayerInterior(TargetID,Interior)
			setVehiclePos(VehicleID,X,Y,Z)
			setVehicleAngle(VehicleID,Angle)
		else
			local Interior = getPlayerInterior(PlayerID)
			setPlayerInterior(TargetID,Interior)
			setPlayerPos(TargetID,X,Y,Z)
			setPlayerAngle(TargetID,Angle)
		end
	elseif Silent == string.lower("silent") then
		local Nickname2 = getPlayerName(TargetID)
		if isPlayerInAnyVehicle(TargetID) == 1 then
			local VehicleID = getPlayerVehicleID(TargetID)
			local Interior = getPlayerInterior(PlayerID)
			setPlayerInterior(TargetID,Interior)
			setVehiclePos(VehicleID,X,Y,Z)
			setVehicleAngle(VehicleID,Angle)
		else
			local Interior = getPlayerInterior(PlayerID)
			setPlayerInterior(TargetID,Interior)
			setPlayerPos(TargetID,X,Y,Z)
			setVehicleAngle(TargetID,Angle)
		end
	end
end

function GotoPlayer(PlayerID,TargetPlayer,Silent)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local X,Y,Z = getXYInFrontOfPlayer(PlayerID,3)
	local Angle = getPlayerAngle(PlayerID)	
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to teleport to a player")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /goto <PlayerName>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server",255,69,0,255)
	elseif TargetID == PlayerID then
		outputChatBox(PlayerID,"You cant teleport to yourself",255,69,0,255)
	elseif isPlayerSpawned(TargetID) == 0 then
		outputChatBox(PlayerID,"The player name you typed is not spawned",255,69,0,255)
	elseif not Silent then		
		local X,Y,Z = getXYInFrontOfPlayer(TargetID,3)
		local Nickname2 = getPlayerName(TargetID)
		
		outputChatBox(PlayerID,"You were teleported to " .. Nickname2,100,149,237,255)
		outputChatBox(TargetID,Nickname .. " teleported to yourself",100,149,237,255)
		if isPlayerInAnyVehicle(PlayerID) == 1 then
			local VehicleID = getPlayerVehicleID(PlayerID)
			local Interior = getPlayerInterior(TargetID)
			setPlayerInterior(PlayerID,Interior)
			setVehiclePos(VehicleID,X,Y,Z)
			setVehicleAngle(VehicleID,Angle)
		else
			local Interior = getPlayerInterior(TargetID)
			setPlayerInterior(PlayerID,Interior)
			setPlayerPos(PlayerID,X,Y,Z)
			setPlayerAngle(PlayerID,Angle)
		end
	elseif Silent == string.lower("silent") then
		local Nickname2 = getPlayerName(TargetID)
		local X,Y,Z = getXYInFrontOfPlayer(TargetID,3)
		if isPlayerInAnyVehicle(PlayerID) == 1 then
			local VehicleID = getPlayerVehicleID(PlayerID)
			local Interior = getPlayerInterior(TargetID)
			setPlayerInterior(PlayerID,Interior)
			setVehiclePos(VehicleID,X,Y,Z)
			setVehicleAngle(PlayerID,Angle)
		else
			local Interior = getPlayerInterior(TargetID)
			setPlayerInterior(PlayerID,Interior)
			setPlayerPos(PlayerID,X,Y,Z)
			setPlayerAngle(PlayerID,Angle)
		end		
	end	
end

function ChartInfo(PlayerID,TargetPlayer)
	local Nickname = getPlayerName(PlayerID)
	local Nickname2 = getPlayerName(TargetID)
	local Level = GetAccountLevel(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Health = getPlayerHealth(TargetID)
	local Armour = getPlayerArmour(TargetID)	
	
	if Level < 3 then		
		merror(PlayerID,NotEnoughLevel,"3 to check a player's information")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /check <PlayerName>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server",255,69,0,255)
	else
		local Cash = mgGetPlayerCash(TargetID)
		local Level = GetAccountLevel(TargetID)
		outputChatBox(PlayerID,Nickname2 .. "'s Information Chart",100,149,237,255)
		outputChatBox(PlayerID,"Health: " .. Health,100,149,237,255)
		outputChatBox(PlayerID,"Armour: " .. Armour,100,149,237,255)
		outputChatBox(PlayerID,"Cash: " .. Cash,100,149,237,255)
		outputChatBox(PlayerID,"Level:" .. Level,100,149,237,255)		
	end	
end
	

function KillWeatherSystem(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to stop the weather")
	else
		vkillTimer("WeatherSystem__")		
		vkillTimer("StartWeather")
		outputChatBox(Nickname .. " has killed the weather system :X",100,149,237,255)
	end
end

function AliveWeatherSystem(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to start the weather")
	else
		vtimer("StartWeather",1,1000,"WeatherSystem")
		outputChatBox(Nickname .. " has started the weather system",100,149,237,255)
		outputChatBox("This changes will apply in a few minutes...",100,149,237,255)
	end
end

function GetCar(PlayerID,VehicleID)
	local VehicleID = tonumber(VehicleID)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local VehiclePos = getVehiclePos(VehicleID) or 0
	
	if Level < 4 then
		outputChatBox(PlayerID,"Your level is " .. Level .. ", you need to be at least lvl 4 to get a vehicle",255,69,0,255)
		merror(PlayerID,NotEnoughLevel,"3 to slap a player")
	elseif not VehicleID then
		outputChatBox(PlayerID,"Syntax: /getcar <Vehicle ID>",255,69,0,255)
	elseif VehicleID == nil then
		outputChatBox(PlayerID,"Syntax: /getcar <Vehicle ID>",255,69,0,255)
	elseif isFloat(VehicleID) then
		outputChatBox(PlayerID,"Syntax: /getcar <Vehicle ID>",255,69,0,255)
	elseif VehiclePos == 0 then
		outputChatBox(PlayerID,"The Vehicle ID doesn't exists",255,69,0,255)
	else
		local X,Y,Z = getXYInFrontOfPlayer(PlayerID,3)
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)
		local WordPrefix = vgetWordPrefix(VehicleName)
		local Angle = getPlayerAngle(PlayerID)
		
		setVehiclePos(VehicleID,X,Y,Z)
		setVehicleAngle(VehicleID,Angle)
		outputChatBox(Nickname .. " has teleported " .. WordPrefix .. " " .. VehicleName .. " (ID " .. VehicleID .. ") to himself",100,149,237,255)
	end		
end

function GotoCar(PlayerID,VehicleID)
	local VehicleID = tonumber(VehicleID)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local VehiclePos = getVehiclePos(VehicleID) or 0
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to goto a vehicle")
	elseif not VehicleID then
		outputChatBox(PlayerID,"Syntax: /gotocar <Vehicle ID>",255,69,0,255)
	elseif VehicleID == nil then
		outputChatBox(PlayerID,"Syntax: /gotocar <Vehicle ID>",255,69,0,255)
	elseif isFloat(VehicleID) then
		outputChatBox(PlayerID,"Syntax: /gotocar <Vehicle ID>",255,69,0,255)
	elseif VehiclePos == 0 then
		outputChatBox(PlayerID,"The Vehicle ID doesnt exists",255,69,0,255)
	elseif isPlayerInAnyVehicle(PlayerID) == 1 then
		local X,Y,Z = getXYInFrontOfVehicle(VehicleID,3)
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)
		local WordPrefix = vgetWordPrefix(VehicleName)
		local Angle = getVehicleAngle(VehicleID)
		local PlayerVehicle = getPlayerVehicleID(PlayerID)
		
		setVehiclePos(PlayerVehicle,X,Y,Z)
		setVehicleAngle(PlayerVehicle,Angle)
		outputChatBox(Nickname .. " has teleported to " .. WordPrefix .. " " .. VehicleName ..  " (ID " .. VehicleID .. ")",100,149,237,255)
	else
		local X,Y,Z = getXYInFrontOfVehicle(VehicleID,3)
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)
		local WordPrefix = vgetWordPrefix(VehicleName)
		local Angle = getVehicleAngle(VehicleID)
		local PlayerVehicle = getPlayerVehicleID(PlayerID)
		
		setPlayerPos(PlayerID,X,Y,Z)
		setPlayerAngle(Angle)
		outputChatBox(Nickname .. " has teleported to " .. WordPrefix .. " " .. VehicleName ..  " (ID " .. VehicleID .. ")",100,149,237,255)		
	end	
end

function unTempBan(PlayerID,Target)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to remove a temporarly ban")
	elseif not Target then
		outputChatBox(PlayerID,"Syntax: /untempban <Target>",255,69,0,255)
	elseif not TempBanned[Target .. "_bantime"] then
		outputChatBox(PlayerID,"That player doesnt exist or isnt banned",255,69,0,255)
	elseif TempBanned[Target .. "_bantime"] == 0 then
		outputChatBox(PlayerID,"That player isnt banned",255,69,0,255)
	else
		outputChatBox(Nickname .. " has unbanned temporarly " .. Target,100,149,237,255)
		vremove("Files/Admin/TempBanned.txt",Target .. "_bantime")
		vremove("Files/Admin/TempBanned.txt",Target .. "_timestamp")
		TempBanned[Target .. "_bantime"] = 0
		TempBanned[Target .. "_timestamp"] = 0
	end	
end

function unPermBan(PlayerID,Target)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to remove a permanently ban")
	elseif not Target then
		outputChatBox(PlayerID,"Syntax: /unpban <Target>",255,69,0,255)
	elseif not PermBanned[Target] then
		outputChatBox(PlayerID,"That player doesnt exists or it isnt banned permanently",255,69,0,255)
	else
		outputChatBox(Nickname .. " has unbanned permanently " .. Target,100,149,237,255)
		removeBanIP(PermBanned[Target])
		PermBanned[Target] = nil
	end
end

function unTempWarn(PlayerID,TargetPlayer,Amount)
	local Nickname = getPlayerName(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Amount = tonumber(Amount)	
	local Level = GetAccountLevel(PlayerID)
	
	if Level < 3 then		
		merror(PlayerID,NotEnoughLevel,"3 to remove a temorarly warn")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /untwarn <Target Name> <Amount of Temp Warns>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /untwarn <Target Name> <Amount of Temp Warns>",255,69,0,255)
	elseif Amount == 0 then
		outputChatBox(PlayerID,"You cant remove 0 temporarly warns from a player",255,69,0,255)
	elseif isFloat(Amount) then
		outputChatBox(PlayerID,"You cant remove that many warns from a player",255,69,0,255)
	elseif Warns == 1 then
		outputChatBox(PlayerID,"You cant remove more warns from this player",255,69,0,255)
	elseif Warns - Amount < 0 then
		outputChatBox(PlayerID,"You cant remove that many warns from a player",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		local Warns = PlayerInfo[TargetID].twarns
		vwrite("Files/Admin/Twarns.txt",Nickname2,Warns - Amount)
		PlayerInfo[TargetID].twarns = Warns - Amount
		outputChatBox(Nickname .. " has removed " .. Amount .. " temporarly warn(s) from " .. Nickname2,100,149,237,255)
	end
end

function unPermWarn(PlayerID,TargetPlayer,Amount)
	local Nickname = getPlayerName(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Amount = tonumber(Amount)	
	local Level = GetAccountLevel(PlayerID)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to remove a permanently warn")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /unpwarn <Target Name> <Amount of Perm Warns>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /unpwarn <Target Name> <Amount of Perm Warns>",255,69,0,255)
	elseif Amount == 0 then
		outputChatBox(PlayerID,"You cant remove 0 permanently warns from a player",255,69,0,255)
	elseif isFloat(Amount) then
		outputChatBox(PlayerID,"You cant remove that many warns from a player",255,69,0,255)
	elseif Warns == 1 then
		outputChatBox(PlayerID,"You cant remove more warns from this player",255,69,0,255)
	elseif Warns - Amount < 0 then
		outputChatBox(PlayerID,"You cant remove that many warns from a player",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		local Warns = PlayerInfo[TargetID].pwarns
		vwrite("Files/Admin/Pwarns.txt",Nickname2,Warns - Amount)
		PlayerInfo[TargetID].pwarns = Warns - Amount
		outputChatBox(Nickname .. " has removed " .. Amount .. " permanently warn(s) from " .. Nickname2,100,149,237,255)
	end
end

function SetVehicleOwner(PlayerID,TargetPlayer,VehicleID)
	local Nickname = getPlayerName(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local VehicleID = tonumber(VehicleID)
	local VehiclePos = getVehiclePos(VehicleID) or 0
	local Level = GetAccountLevel(PlayerID)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to set a vehicle owner")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /setcarowner <Target Name> <VehicleID>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server",255,69,0,255)
	elseif not VehicleID then
		outputChatBox(PlayerID,"Syntax: /setcarowner <Target Name> <VehicleID>",255,69,0,255)
	elseif VehicleID == nil then
		outputChatBox(PlayerID,"Syntax: /setcarowner <Target Name> <VehicleID>",255,69,0,255)
	elseif VehiclePos == 0 then
		outputChatBox(PlayerID,"The Vehicle ID doesnt exists",255,69,0,255)
	elseif isFloat(VehicleID) then
		outputChatBox(PlayerID,"The Vehicle ID doesnt exists",255,69,0,255)
	else
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)
		local WordPrefix = vgetWordPrefix(VehicleName)
		local Nickname2 = getPlayerName(TargetID)
		
		if Vehicle[VehicleID] then
			outputChatBox(PlayerID,"Vehicle " .. VehicleName .. " is already owned by " .. Vehicle[VehicleID],255,69,0,255) 
			outputChatBox(PlayerID,"To remove an owner from a vehicle use /removecarowner",255,69,0,255)
		elseif vinTable(Vehicle,Nickname2) then
			outputChatBox(PlayerID,"That player already owns a vehicle",255,69,0,255)
		else
			Vehicle[VehicleID] = Nickname2
			vwrite("Vehicle/Owner.txt",VehicleID,Nickname2)
			outputChatBox(Nickname .. " has set vehicle " .. VehicleName .. " (ID " .. VehicleID .. ") owner to: " .. Nickname2,100,149,237,255)
		end
	end
end

function RemoveVehicleOwner(PlayerID,VehicleID)
	local Nickname = getPlayerName(PlayerID)
	local VehicleID = tonumber(VehicleID)
	local Level = GetAccountLevel(PlayerID)
	local VehiclePos = getVehiclePos(VehicleID) or 0
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to remove a vehicle owner")
	elseif not VehicleID then
		outputChatBox(PlayerID,"Syntax: /removecarowner <VehicleID>",255,69,0,255)
	elseif isFloat(VehicleID) then
		outputChatBox(PlayerID,"The Vehicle ID doesnt exists",255,69,0,255)
	elseif VehicleID == nil then
		outputChatBox(PlayerID,"Syntax: /removecarowner <VehicleID>",255,69,0,255)
	elseif VehiclePos == 0 then
		outputChatBox(PlayerID,"The Vehicle ID doesnt exists",255,69,0,255)
	elseif not Vehicle[VehicleID] then
		outputChatBox(PlayerID,"That vehicle doesnt below to any player",255,69,0,255)
	else
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)		
		outputChatBox(Nickname .. " has removed " .. Vehicle[VehicleID] .. "'s vehicle " .. VehicleName .. " (ID " .. VehicleID .. ") ownership",100,149,237,255)
		vremove("Vehicle/Owner.txt",VehicleID,Vehicle[VehicleID])
		Vehicle[VehicleID] = nil		
	end
end

function repairmgVehicle(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	
	if Level < 3 then		
		merror(PlayerID,NotEnoughLevel,"3 to repair a vehicle")
	elseif isPlayerInAnyVehicle(PlayerID) == 0 then
		outputChatBox(PlayerID,"You are not driving any vehicle",255,69,0,255)
	else
		local VehicleID = getPlayerVehicleID(PlayerID)
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)	
		local WordPrefix = vgetWordPrefix(VehicleName)
		
		repairVehicle(VehicleID)
		outputChatBox(Nickname .. " has repaired " .. WordPrefix .. " " .. VehicleName .. " (ID " .. VehicleID .. ")",100,149,237,255)
	end
end

function flipVehicle(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	
	if Level < 3 then
		outputChatBox(PlayerID,"Your level is " .. Level .. ", you need to be at least lvl 3 to flip a vehicle",255,69,0,255)
		merror(PlayerID,NotEnoughLevel,"3 to slap a player")
	elseif isPlayerInAnyVehicle(PlayerID) == 0 then
		outputChatBox(PlayerID,"You are not driving any vehicle",255,69,0,255)
	else
		local VehicleID = getPlayerVehicleID(PlayerID)
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)	
		local WordPrefix = vgetWordPrefix(VehicleName)
		local X,Y,Z = getVehiclePos(VehicleID)
		local VehicleAngle = getVehicleAngle(VehicleID)
		
		setVehicleAngle(VehicleID,VehicleAngle)
		outputChatBox(Nickname .. " has flipped " .. WordPrefix .. " " .. VehicleName .. " (ID " .. VehicleID .. ")",100,149,237,255)
	end
end


--[[ - - - - - - - - - - - ]]
--[[  Business managment   ]]
--[[ - - - - - - - - - - - ]] 

function dumpPositions(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"4 to remove points")
	else
		Points[PlayerID] = {}
		outputChatBox(Nickname .. " has removed all points for a new business",100,149,237,255)
	end
end

function countBusinesses(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to count businesses")
	else
		outputChatBox(PlayerID,"There are " .. #Business .. " businesses",100,149,237,255)
	end
end

function statsPlayer(PlayerID,TargetPlayer)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	
	if Level < 5 then	
		merror(PlayerID,NotEnoughLevel,"5 to check a player's stat")
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /stats <Target Name>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server",255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)		
		PlayerDate[TargetID] = os.date("*t",PlayerInfo[TargetID].registerts)
		
		outputChatBox(PlayerID,"Time ingame: " .. vgetTimeString(os.time() - PlayerInfo[TargetID].ingame),244,164,096,255)
		outputChatBox(PlayerID,"Register date: " .. PlayerDate[TargetID].day .. "/" .. PlayerDate[TargetID].month .. "/" .. PlayerDate[TargetID].year .. " " .. PlayerDate[TargetID].hour .. ":" .. PlayerDate[TargetID].min .. ":" .. PlayerDate[TargetID].sec .. " (Format: dd/mm/yyyy hh:mm:ss)",244,164,096,255)
		outputChatBox(PlayerID,"Time since register: " .. vgetTimeString(os.time() - PlayerInfo[TargetID].registerts),244,164,096,255)
	end
end

function addBlockedNickname(PlayerID,...)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local BlockedName = GetParams(arg)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to add a blocked nickname")
	elseif not BlockedName then
		outputChatBox(PlayerID,"Syntax: /addblockname <Blocked Nickname>",255,69,0,255)
	else
		table.insert(BlockedNames,BlockedName)
		vwrite("Files/Admin/BlockedNames.txt",BlockedName,Nickname)
		outputChatBox(Nickname .. " has added a blocked nickname to the server: " .. BlockedName,100,149,237,255)
	end
end

function removeBlockedNickname(PlayerID,...)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local BlockedName = GetParams(arg)
	
	if Level < 4 then		
		merror(PlayerID,NotEnoughLevel,"4 to remove a blocked nickname")
	elseif not BlockedName then
		outputChatBox(PlayerID,"Syntax: /removeblockedname <Blocked Nickname>",255,69,0,255)
	elseif not vinTable(BlockedNames,BlockedName) then
		outputChatBox(PlayerID,"That nickname is not currently blocked",255,69,0,255)
	else
		table.remove(BlockedNames,getTableKey(BlockedNames,BlockedName))
		vremove("Files/Admin/BlockedNames.txt",BlockedName)
		outputChatBox(Nickname .. " has removed a blocked nickname from the server: " .. BlockedName,100,149,237,255)
	end
end


function SetBusinessOwner(PlayerID,BusinessID,TargetPlayer)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local BusinessID = tonumber(BusinessID)
	
	if Level < 5 then		
		merror(PlayerID,NotEnoughLevel,"5 to set a business owner")
	elseif not BusinessID then
		outputChatBox(PlayerID,"Syntax: /setbusinessowner <BusinessID> <Player Name>",255,69,0,255)
	elseif not TargetPlayer then
		outputChatBox(PlayerID,"Syntax: /setbusinessowner <BusinessID> <Player Name>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"The player name you typed was not found in the server",255,69,0,255)
	elseif not Business[BusinessID] then
		outputChatBox(PlayerID,"That Business ID doesnt exist",255,69,0,255)
	elseif isBusinessOwned(BusinessID) then
		local MgBusinessOwner = getBusinessOwner(BusinessID)
		
		outputChatBox(PlayerID,"That business is already owned by " .. MgBusinessOwner,255,69,0,255)
	else
		local Nickname2 = getPlayerName(TargetID)
		local BusinessName = getBusinessName(BusinessID)
		outputChatBox(Nickname .. " has set business " .. BusinessName .. " (ID: " .. BusinessID .. ") owner to " .. Nickname2,100,149,237,255)
		BusinessOwner[BusinessID] = Nickname2
		vwrite("Business/Owner.txt",BusinessID,Nickname2)
		BusinessTime[BusinessID] = os.time
		vwrite("Business/Time.txt",BusinessID,os.time())
	end
end

function RemoveBusinessOwner(PlayerID,BusinessID)
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local BusinessID = tonumber(BusinessID)
	
	if Level < 5 then
		merror(PlayerID,NotEnoughLevel,"5 to remove a business owner")
	elseif not BusinessID then
		outputChatBox(PlayerID,"Syntax: /removebusinessowner <BusinessID>",255,69,0,255)
	elseif not Business[BusinessID] then
		outputChatBox(PlayerID,"That Business ID doesnt exist",255,69,0,255)
	elseif not isBusinessOwned(BusinessID) then
		outputChatBox(PlayerID,"That business isnt owned by anyone",255,69,0,255)
	else
		local MgBusinessOwner = getBusinessOwner(BusinessID)
		local MgBusinessName = getBusinessName(BusinessID)
		
		outputChatBox(Nickname .. " has removed " .. MgBusinessOwner .. "'s business " .. MgBusinessName .. " (ID: " .. BusinessID .. ") ownership",100,149,237,255)		
		vremove("Business/Owner.txt",BusinessID,MgBusinessOwner)
		vremove("Business/Time.txt",BusinessID,MgBusinessOwner)
		BusinessTime[BusinessID] = nil
		BusinessOwner[BusinessID] = nil		
	end
end


--[[ - - - - - - - - - - - ]]
--[[ 	Print loaded	   ]]
--[[ - - - - - - - - - - - ]] 


outputConsole("Admin loaded succesfuly")

