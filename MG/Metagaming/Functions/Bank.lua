function CreateBankAccount(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Money = mgGetPlayerCash(PlayerID)
	local Interior = getPlayerInterior (PlayerID)	
	local Bank = PlayerInfo[PlayerID].bank
	
	if Interior ~= 3 then
		outputChatBox(PlayerID,"Go to El Banco Corrupto Grande to register your bank account",255,69,0,255) return
	end
	if Bank and Interior == 3 then
		outputChatBox (PlayerID,"You already own a bank account",255,69,0,255) return
	end
	if Interior == 3 then		
		outputChatBox (PlayerID,"Welcome to El Banco Corrupto Grande",255,127,0,255)						
		outputChatBox (PlayerID,"A reminder: To check your bank account status use /bank",255,127,0,255)					
		vwrite("Files/Account/Bank.txt",Nickname,250)
		PlayerInfo[PlayerID].bank = 250
		outputChatBox (PlayerID,"Your account has been created!, Thank you for waiting",255,127,0,255)					
		outputChatBox (PlayerID,"El Banco Corrupto Grande has deposited $250 into your bank account as a loan.",255,127,0,255)						
	end
end

function DepositMoney(PlayerID,Amount)
	local Amount = tonumber(Amount)
	local Interior = getPlayerInterior(PlayerID)
	local Money = mgGetPlayerCash(PlayerID)
	local Nickname = getPlayerName(PlayerID)	
	local Bank = PlayerInfo[PlayerID].bank
	
	if not Bank then			
		outputChatBox(PlayerID,"You must register first. Use /newbankacc",255,69,0,255) 
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /deposit [Amount]",255,69,0,255)
	elseif Interior ~= 3 then
		outputChatBox(PlayerID,"You must be at El Banco Corrupto Grande to deposit money",255,69,0,255)
	elseif Amount < 0 then
		outputChatBox(PlayerID,"You can't deposit negative money!",255,69,0,255)  
	elseif Amount == 0 then
		outputChatBox(PlayerID,"You must deposit a number bigger than 0",255,69,0,255) 
	elseif Amount > Money then
		outputChatBox(PlayerID,"You don't have enough cash to deposit",255,69,0,255)
	elseif Interior == 3 then		
		outputChatBox(PlayerID,"You've deposited $" .. Amount .. " into your bank acount",50,205,050,255)
		local AddAmount = Bank + Amount
		vwrite("Files\\Bank.txt",Nickname,AddAmount )
		PlayerInfo[PlayerID].bank = AddAmount		
		mgTakeCash(PlayerID,Amount)
	end
end
	
	
function WitdrawMoney(PlayerID,Amount)
	local Amount = tonumber(Amount)
	local Interior = getPlayerInterior (PlayerID)
	local Money = mgGetPlayerCash(PlayerID)
	local Nickname = getPlayerName(PlayerID)		
	local Bank = PlayerInfo[PlayerID].bank

	
	if not Bank then			
		outputChatBox(PlayerID,"You must register first. Use /newbankacc",255,69,0,255)
	elseif Interior ~= 3 then
		outputChatBox(PlayerID,"You must be at El Banco Corrupto Grande to withdraw money",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax /withdraw [Amount]",255,69,0,255)
	elseif Amount < 0 then
		outputChatBox(PlayerID,"You cant withdraw negative money!",255,69,0,255)
	elseif Amount == 0 then
		outputChatBox(PlayerID,"You must withdraw a number bigger than 0",255,69,0,255)
	elseif Amount > Bank then
		outputChatBox(PlayerID,"You dont have enaugh cash to withdraw",255,69,0,255)
	elseif Interior == 3 then		
		outputChatBox(PlayerID,"You've withdraw $" .. Amount .. " from your bank acount",50,200,80,255)
		local TakeAmount = Bank - Amount
		vwrite("Files\\Bank.txt",Nickname,TakeAmount )
		mgAddCash(PlayerID,Amount)
		PlayerInfo[PlayerID].bank = TakeAmount
	end		
end

function CurrentMoney(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Money = mgGetPlayerCash(PlayerID)
	local Bank = PlayerInfo[PlayerID].bank
	
	if not Bank then			
		outputChatBox(PlayerID,"You must register your bank account first. Use /newbankacc at El Banco Corrupto Grande",255,69,0,255)
	else			
		outputChatBox(PlayerID,"You have $" .. Bank .. " in your bank account",50,200,80,255)
		outputChatBox(PlayerID,"You have $" .. Money .. " in your pocket",50,200,80,255)
	end
end

function WireTransfer(PlayerID,TargetPlayer,Amount)
	local TargetID = mgGetPlayerID(PlayerID,TargetPlayer)
	local Nickname = getPlayerName(PlayerID)
	local Nickname2 = getPlayerName(TargetID)
	local Amount = tonumber(Amount)
	local CurrentMoneyInA = PlayerInfo[PlayerID].bank
	local CurrentMoneyInB = vread("Files/Account/Bank.txt",Nickname2)
	CurrentMoneyInB = (CurrentMoneyInB) and tonumber(CurrentMoneyInB)
	PlayerInfo[TargetID].bank = CurrentMoneyInB
	local Interior = getPlayerInterior(PlayerID)
	
	if Interior ~= 3  then
		outputChatBox(PlayerID,"You must be at El Banco Corrupto Grande to do a wiretransfer",255,69,0,255)
	elseif not isPlayerConnected(TargetID) == 0 then
		outputChatBox(PlayerID,"That player is not connected to the server",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /wiretransfer <Partial or Full name> <Amount>",255,69,0,255)
	elseif not TargetID then
		outputChatBox(PlayerID,"Syntax: /wiretransfer <Partial or Full name> <Amount>",255,69,0,255)		
	elseif not PlayerInfo[TargetID].bank then
		outputChatBox(PlayerID,"That player hasnt registered a bank account yet or is offline",255,69,0,255)	
	elseif Amount > CurrentMoneyInA then
		outputChatBox(PlayerID,"You dont have that enough cash in your bank account",255,69,0,255)
	elseif Amount <= 0 then
		outputChatBox(PlayerID,"You can't wiretransfer that amount of money",255,69,0,255)
	elseif TargetID == PlayerID then
		outputChatBox(PlayerID,"You can't wiretransfer money to yourself",255,69,0,255)
	else
		outputChatBox(PlayerID,"You've wiretransfered $" .. Amount .. " to " .. Nickname2,50,200,80,255)
		outputChatBox(TargetID,Nickname .. " has wiretransfered $" .. Amount .. " to your bank account",50,200,80,255)
		local AddToB = CurrentMoneyInB + Amount
		vwrite("Files/Account/Bank.txt",Nickname2,AddToB)
		PlayerInfo[TargetID].bank = AddToB
		local TakeFromA = CurrentMoneyInA - Amount
		vwrite("Files/Account/Bank.txt",Nickname,TakeFromA)
		PlayerInfo[PlayerID].bank = TakeFromA
	end
end

--[[ Print Loading results ]]
outputConsole("		Bank Functions Loaded")