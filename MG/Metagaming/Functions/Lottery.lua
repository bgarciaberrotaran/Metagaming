function BuyLotteryTicket(PlayerID,Number,Prize)
	local Number = tonumber(Number)
	local Prize = tonumber(Prize)
	local Area = getPlayerArea(PlayerID)
	local Cash = mgGetPlayerCash(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	if Area ~= SuperMarket then
		outputChatBox(PlayerID,"You need to go to the supermarket to buy a lottery ticket",255,69,0,255)
	elseif Area == SuperMarket then
		if not Number then
			outputChatBox(PlayerID,"Syntax: /buyticket <Number> <Prize>",255,69,0,255)
			outputChatBox(PlayerID,"You must choose a number that has 3 digits. For example: " .. math.random(001,999),255,69,0,255)
		elseif not Prize then
			outputChatBox(PlayerID,"Syntax: /buyticket <Number> <Prize>",255,69,0,255)
			outputChatBox(PlayerID,"You must choose a prize, for example $100",255,69,0,255)
		elseif Prize > 300 then
			outputChatBox(PlayerID,"Syntax: /buyticket <Number> <Prize>",255,69,0,255)
			outputChatBox(PlayerID,"The prize has to be between $100 and $300",255,69,0,255)
		elseif Prize < 100 then
			outputChatBox(PlayerID,"Syntax: /buyticket <Number> <Prize>",255,69,0,255)
			outputChatBox(PlayerID,"The prize has to be between $100 and $300",255,69,0,255)
		elseif Number > 999 or Number < 001 then
			outputChatBox(PlayerID,"Syntax: /buyticket <Number> <Prize>",255,69,0,255)
			outputChatBox(PlayerID,"You must choose a number that has 3 digits. For example: " .. math.random(001,999),255,69,0,255)
		elseif not Prize then
			outputChatBox(PlayerID,"Syntax: /buyticket <Number> <Prize>",255,69,0,255)
			outputChatBox(PlayerID,"You must insert a prize, for example $100, up to $300",255,69,0,255)
		elseif Cash < Prize then
			outputChatBox(PlayerID,"You don't have enough money to buy a lottery ticket",255,69,0,255)
		elseif Lottery[PlayerID].number ~= nil then
			outputChatBox(PlayerID,"You already bought a lottery ticket",255,69,0,255)
		elseif Number < 10 then
			Lottery[PlayerID].number = Number
			Lottery[PlayerID].prize = Prize
			outputChatBox(PlayerID,"You bought a lottery ticket with the number: 00" .. Number .. ", Good luck!",50,200,80,255)
			outputChatBox(PlayerID,"The lottery runs every 30 mins (Real time), the winning number will be announced",50,200,80,255)
			mgTakeCash(PlayerID,Prize)
		elseif Number < 100 and Number >= 10 then
			Lottery[PlayerID].number = Number
			Lottery[PlayerID].prize = Prize
			outputChatBox(PlayerID,"You bought a lottery ticket with the number: 0" .. Number .. ", Good luck!",50,200,80,255)
			outputChatBox(PlayerID,"The lottery runs every 30 mins (Real time), the winning number will be announced",50,200,80,255)
			mgTakeCash(PlayerID,Prize)
		else
			Lottery[PlayerID].number = Number
			Lottery[PlayerID].prize = Prize
			outputChatBox(PlayerID,"You bought a lottery ticket with the number: " .. Number .. ", Good luck!",50,200,80,255)
			outputChatBox(PlayerID,"The lottery runs every 30 mins (Real time), the winning number will be announced",50,200,80,255)
			mgTakeCash(PlayerID,Prize)
		end
	end
end


vtimer("CheckOnLotterY",0,1800000,"CheckLottery")

function CheckLottery()
	math.randomseed(os.time())
	local Number = math.random(1,999)
	if Number < 10 then
		outputChatBox("[Lottery] And the winning number is ... 00" .. Number .. ", Congratulations to the winner ",50,200,80,255)		
	elseif Number < 100 and Number >= 10 then
		outputChatBox("[Lottery] And the winning number is ... 0" .. Number .. ", Congratulations to the winner ",50,200,80,255)		
	else
		outputChatBox("[Lottery] And the winning number is ... " .. Number .. ", Congratulations to the winner ",50,200,80,255)		
	end
	local b = getMaxPlayers()-1
	for a=0, b do
		if isPlayerConnected(a) == 1 then
			if Lottery[a].number ~= nil then
				if Lottery[a].number == Number then
					if isPlayerConnected(a) == 1 then
						outputChatBox(a,"You have won the lottery! Congratulations!",50,200,80,255)
						outputChatBox(a,"You can go to the supermarket to claim your prize with /claimlottery",50,200,80,255)
						Lottery[a].winned = Lottery[a].prize
						Lottery[a].number = nil
						Lottery[a].prize = nil
					else
						outputChatBox("[Lottery] The winner of the lottery has disconnected from the server",50,200,80,255)
					end
				else
					--outputChatBox("[Loterry] All tickets have been destroyed",50,200,80,255)
					Lottery[a].number = nil
					Lottery[a].prize = nil
				end
			end
		end
	end
end

function PrizeClaim(PlayerID)
	local Area = getPlayerArea(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Prize = Lottery[PlayerID].winned
	local Cash = mgGetPlayerCash(PlayerID)
	
	if not Prize then
		outputChatBox(PlayerID,"You havent won the lottery yet, use /buyticket to get a chance!",255,69,0,255)
	elseif Area ~= SuperMarket then
		outputChatBox(PlayerID,"You need to go to the supermarket to claim your prize",255,69,0,255)
	else
		outputChatBox(PlayerID,"So, you've won the lottery, Congratulations! Here's your prize!",50,200,80,255)
		if Prize >= 300 then
			outputChatBox(PlayerID,"You've won $" .. Prize*7000 .. ", thats 7 thousand times what you've bet",50,200,80,255)
			mgAddCash(PlayerID, Prize*7000)
			Lottery[PlayerID].winned = nil
		elseif Prize >= 200 and Prize < 300 then
			mgAddCash(PlayerID, Prize*700)
			outputChatBox(PlayerID,"You've won $" .. Prize*700 .. ", thats 7 houndred times what you've bet",50,200,80,255)
			Lottery[PlayerID].winned = nil
		elseif Prize >= 100 and Prize < 200 then
			mgAddCash(PlayerID, Prize*70)		
			outputChatBox(PlayerID,"You've won $" .. Prize*70 .. ", thats 70 times what you've bet",50,200,80,255)
			Lottery[PlayerID].winned = nil
		end
	end
end

function CheckTicket(PlayerID)
	local Number = Lottery[PlayerID].number
	local Prize =  Lottery[PlayerID].prize
	local Winned = Lottery[PlayerID].winned	
	if Number and Prize then
		outputChatBox(PlayerID,"Lottery ticket number : " .. Number,50,200,80,255)
		outputChatBox(PlayerID,"Prize bet : " .. Prize,50,200,80,255)
	elseif Winned then
		outputChatBox(PlayerID,"You have won the lottery ! Congratulations!",50,200,80,255)
		outputChatBox(PlayerID,"Go to the supermarket and use /claimlottery to get your prize",50,200,80,255)
	else
		outputChatBox(PlayerID,"You havent bought a lottery ticket yet, use /buyticket to get a chance!",255,69,0,255)
	end		
end

--[[ Print Loading results ]]
outputConsole("		Lottery Functions Loaded")