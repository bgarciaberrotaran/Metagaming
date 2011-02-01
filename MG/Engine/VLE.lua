--[[ - - - - - - - - - - - ]]
--[[ 	Engine functions   ]]
--[[ - - - - - - - - - - - ]]
--[[ 	VLE functions      ]]
--[[ - - - - - - - - - - - ]]
--[[ Special thanks to Mex ]]
--[[ - - - - - - - - - - - ]]

function vsplit(Line, Separator)
	-- local a, b, c, d = vsplit("18.210.41.95", ".")
	-- a = '18',    b = '210',    c = '41',    d = '95'
	if not Line or not Separator then return end
	local Tokens, TokenStartPos = {}
	local SeparatorPos = string.find(Line, Separator, 1, true)
	local TokenEndPos = (SeparatorPos) and SeparatorPos - 1 or -1
	table.insert(Tokens, string.sub(Line, 1, TokenEndPos))
	while SeparatorPos do
		TokenStartPos = SeparatorPos + 1
		SeparatorPos = string.find(Line, Separator, SeparatorPos + 1, true)
		TokenEndPos = (SeparatorPos) and SeparatorPos - 1 or -1
		table.insert(Tokens, string.sub(Line, TokenStartPos, TokenEndPos))
	end
	return unpack(Tokens)
end

function vreadSub( Path, ItemSub )
	local ItemSubLen = string.len(ItemSub)
	for i,v in vfile( Path ) do
		if string.sub(i, 1, ItemSubLen) == ItemSub then return i,v end
	end
	return
end

function vgetWordPrefix(Word)
    local a = string.sub(Word, 1, 1)
    local b = string.lower(a)
    local Vowels = { 'a', 'e', 'i', 'o', 'u' }
    for i,v in ipairs(Vowels) do
        if b == v then return "an" end
    end
    return "a"
end

function vgetDistance(X1, X2, Y1, Y2, Z1, Z2, DontRound)
    -- thanks to MTAmA GRS for this function (in mIRC)
    local a = X1 - X2
    local b = Y1 - Y2
    local c = Z1 - Z2
    local x = math.abs(a)
    local y = math.abs(b)
    local z = math.abs(c)
    local Distance = math.sqrt(x * x + y * y + z * z)
    return (DontRound) and Distance or round(Distance, 2)
end

function vreplace(String, LookFor, ReplaceWith)
    if not String or not LookFor or not ReplaceWith then return end
    String, LookFor, ReplaceWith = tostring(String), tostring(LookFor), tostring(ReplaceWith)
    
    local NewString = ""
    local OccuranceStartPos = string.find(String, LookFor, 1, true)
    if not OccuranceStartPos then return String end
    
    if OccuranceStartPos > 1 then
        NewString = NewString..string.sub(String, 1, OccuranceStartPos - 1)
    end
    
    local OccuranceEndPos
    while OccuranceStartPos do
        OccuranceEndPos = OccuranceStartPos + (string.len(LookFor) - 1)
        NewString = NewString..ReplaceWith
        OccuranceStartPos = string.find(String, LookFor, OccuranceEndPos + 1, true)
        if (OccuranceStartPos or 0) - 1 > OccuranceEndPos then
            NewString = NewString..string.sub(String, OccuranceEndPos + 1, OccuranceStartPos - 1)
        end
    end
    
    if OccuranceEndPos < string.len(String) then
        NewString = NewString..string.sub(String, OccuranceEndPos + 1)
    end
    
    return NewString
end

function vgetTimeString(Seconds)
    if not Seconds or Seconds == 0 then return "0 secs" end
    
    local a = {
        Seconds % 60,
        math.floor((Seconds / 60) % 60),
        math.floor((Seconds / 3600) % 24),
        math.floor(Seconds / 86400)
    }
    
    local TimeUnits = { "Secs", "Mins", "Hours", "Days" }
    local TimeString, b, Part = {}
    for i,v in ipairs(TimeUnits) do
        b = a[i]
        if b ~= 0 then
            Part = b.." "..string.lower(((b ~= 1) and v or string.sub(v, 1, -2)))
            table.insert(TimeString, Part)
        end
    end
    
    local b, c, TimeString2 = #TimeString
    for a=1, b do
        c = TimeString[a]
        if a == 1 then TimeString2 = c
        elseif a == 2 then TimeString2 = c.." and "..TimeString2
        else TimeString2 = c..", "..TimeString2
        end
    end
    
    return TimeString2
end

function vgetArgsString(...)
    local Values, Value, Type = {}
    for i,v in ipairs(arg) do
        Type = type(v)
        if     Type == "number"   then Value = v
        elseif Type == "boolean"  then Value = (v) and "true" or "false"
        elseif Type == "string"   then Value = [[']]..vreplace(vreplace(v, [[\]], [[\\]]), [[']], [[\']])..[[']]
        elseif Type == "table"    then Value = vgetTableString(v)
        elseif Type == "function" then Value = "function() <body> end"
        elseif Type == "nil"      then Value = "nil"
        else                           Value = (Type) and "<"..Type..">" or "(unknown data type)"
        end
        table.insert(Values, Value)
    end
    return table.concat(Values, ", ")
end

function GetParams(arg)
	local a
	for i,v in ipairs(arg) do
		if not a then a = tostring(v)
		else a = a .. " " .. tostring(v)
		end
	end
	return a
end

--[[ Print Loading results ]]
outputConsole("		Engine VLE Functions Loaded")
