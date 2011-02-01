--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]
--[[ VCO Lua Extensions 1.06                                                 ]]
--[[ Created by Mex                                                          ]]
--[[                                                                         ]]
--[[ Website    http://vle.vicecityonline.com/                               ]]
--[[ Need help? http://vle.vicecityonline.com/help/                          ]]
--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]

--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]
--[[ Files.lua                                                               ]]
--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]


--[[ - - - - - - - - - - - ]]
--[[ Run Time Setup        ]]
--[[ - - - - - - - - - - - ]]

--[[ Mark this script as loaded, other scripts can then check if this script is loaded ]]
vloaded_files = true




--[[ - - - - - - - - - - - ]]
--[[ Command Functions     ]]
--[[ - - - - - - - - - - - ]]




--[[ - - - - - - - - - - - ]]
--[[ Callbacks             ]]
--[[ - - - - - - - - - - - ]]




--[[ - - - - - - - - - - - ]]
--[[ Functions             ]]
--[[ - - - - - - - - - - - ]]

function vexists(Path)
	if not Path then return end
	
	local Handle = io.open(Path, "r")
	if not Handle then return false end
	io.close(Handle)
	
	return true
end
function vwrite(Path, Item, Value)
	if not Path or not Item or not Value then return end
	Item = tostring(Item)
	
	local Handle, NewData = io.open(Path, "r")
	if Handle then
		io.close(Handle)
		local SpacePos, StopOriginalLine, LineAdded
		for Line in io.lines(Path) do
			StopOriginalLine = nil
			
			if Line ~= "" then
				SpacePos = string.find(Line, " ", 1, true)
				if SpacePos and string.sub(Line, 1, SpacePos-1) == Item then
					NewData = ((NewData) and NewData.."\n" or "")..Item.." "..Value
					StopOriginalLine = true
					LineAdded = true
				end
			end
			
			if not StopOriginalLine then NewData = ((NewData) and NewData.."\n" or "")..Line end
		end
		
		if not LineAdded then NewData = ((NewData) and NewData.."\n" or "")..Item.." "..Value end
	else
		NewData = Item.." "..Value
	end
	if not NewData then return end
	
	local Handle = io.open(Path, "w+")
	if not Handle then return end
	Handle:write(NewData)
	io.close(Handle)
	
	return true
end
function vread(Path, Item)
	if not Path or not Item then return end
	local Handle = io.open(Path, "r")
	if not Handle then return end
	io.close(Handle)
	Item = tostring(Item)
	
	local SpacePos, Value
	for Line in io.lines(Path) do
		if Line ~= "" then
			SpacePos = string.find(Line, " ", 1, true)
			if SpacePos and string.sub(Line, 1, SpacePos-1) == Item then
				Value = string.sub(Line, SpacePos+1)
				break
			end
		end
	end
	
	if Value then return Value end
	return
end
function vremove(Path, Item)
	if not Path or not Item then return end
	local Handle = io.open(Path, "r")
	if not Handle then return end
	io.close(Handle)
	Item = tostring(Item)
	
	local NewData, SpacePos, StopOriginalLine
	for Line in io.lines(Path) do
		StopOriginalLine = nil
		
		if Line ~= "" then
			SpacePos = string.find(Line, " ", 1, true)
			if SpacePos and string.sub(Line, 1, SpacePos-1) == Item then
				StopOriginalLine = true
			end
		end
		
		if not StopOriginalLine then NewData = ((NewData) and NewData.."\n" or "")..Line end
	end
	if not NewData then NewData = "" end
	
	local Handle = io.open(Path, "w+")
	if not Handle then return end
	Handle:write(NewData)
	io.close(Handle)
	
	return true
end
function vremoveSeveral(Path, ItemsTable)
	if not Path or not ItemsTable then return end
	local Handle = io.open(Path, "r")
	if not Handle then return end
	io.close(Handle)
	
	local a = function(b) for i,v in ipairs(ItemsTable) do if v == b then return true end end return false end
	
	local NewData, SpacePos, Skip
	for Line in io.lines(Path) do
		Skip = nil
		
		if Line ~= "" then
			SpacePos = string.find(Line, " ", 1, true)
			if SpacePos then
				if a(string.sub(Line, 1, SpacePos-1)) then Skip = true end
			end
		end
		
		if not Skip then NewData = ((NewData) and NewData.."\n" or "")..Line end
	end
	
	local FileHandle = io.open(Path, "w+")
	if FileHandle then
		if NewData then FileHandle:write(NewData) end
		io.close(FileHandle)
	end
	
	return true
end
function vclear(Path)
	if not Path then return end
	local Handle = io.open(Path, "r")
	if not Handle then return end
	io.close(Handle)
	
	local Handle = io.open(Path, "w+")
	if not Handle then return end
	io.close(Handle)
	
	return true
end
function vfile(Path)
	-- used for looping around a file's lines that are in VLE format, for example:
	-- for item,value in vfile("file.txt") do
	--     outputConsole(item.." "..value)
	-- end
	
	local Handle, a, b, c, t, e, s = io.open(Path), {}, 1, 0, {}
	if Handle then
		io.close(Handle)
		for d in io.lines(Path) do
			if d ~= "" then
				s = string.find(d," ", 1, true)
				if s then
					a[b] = d
					t[b] = s
					b = b + 1
				end
			end
		end
	end
	
	local function vfile2(p, q)
		c = c + 1
		if c ~= b then
			e = a[c]
			return string.sub(e, 1, t[c]-1), string.sub(e, t[c]+1)
		end
		return
	end
	
	return vfile2, nil, nil
end
function vlines(Path)
	if not Path then return end
	local Handle = io.open(Path, "r")
	if not Handle then return 0 end
	io.close(Handle)
	
	local Amount, SpacePos = 0
	for Line in io.lines(Path) do
		if Line ~= "" then
			SpacePos = string.find(Line, " ", 1, true)
			if SpacePos then Amount = Amount + 1 end
		end
	end
	
	return Amount
end
function vmergeFile(Path, Path2)
	if not Path or not Path2 then return end
	
	local Handle = io.open(Path2, "r")
	if not Handle then return end
	io.close(Handle)
	
	local Path2Data, SpacePos, Item, Value = {}
	for Line in io.lines(Path2) do
		if Line ~= "" then
			SpacePos = string.find(Line, " ", 1, true)
			if SpacePos then
				Item = string.sub(Line, 1, SpacePos-1)
				Value = string.sub(Line, SpacePos+1)
				table.insert(Path2Data, { Item, Value } )
			end
		end
	end
	
	local a = function(b) for i,v in ipairs(Path2Data) do if v[1] == b then return i, v[1], v[2] end end return end
	
	local Handle, NewData, TablePos, NewItem, NewValue = io.open(Path, "r")
	if Handle then
		io.close(Handle)
		local SpacePos, StopOriginalLine
		for Line in io.lines(Path) do
			StopOriginalLine = nil
			
			if Line ~= "" then
				SpacePos = string.find(Line, " ", 1, true)
				if SpacePos then
					TablePos, NewItem, NewValue = a(string.sub(Line, 1, SpacePos-1))
					if TablePos then
						NewData = ((NewData) and NewData.."\n" or "")..NewItem.." "..NewValue
						StopOriginalLine = true
						table.remove(Path2Data, TablePos)
					end
				end
			end
			
			if not StopOriginalLine then NewData = ((NewData) and NewData.."\n" or "")..Line end
		end
		
		for i,v in ipairs(Path2Data) do
			NewData = ((NewData) and NewData.."\n" or "")..v[1].." "..v[2]
		end
	end
	if not NewData then return end
	
	local Handle = io.open(Path, "w+")
	if not Handle then return end
	Handle:write(NewData)
	io.close(Handle)
	
	return true
end

function vreadLine(File, LineNumber)
	local Line = 1
	for i,v in vfile(File) do
		if Line == LineNumber then return i, v end
		Line = Line + 1
	end
	return
end --item, value = vreadLine(path,1)


function vcompactChar(String, ...)
    for i,v in ipairs(arg) do
        while string.find(String, v..v, 1, true) do
            String = vreplace(String, v..v, v)
        end
    end
    return String
end

function vexplode(String, Separator, ConvertTokenToNumber)
    -- { "aa", "bb", "cc", "dd" } = vexplode("aa bb cc dd", " ")
    -- { 49, 72.1, -548, -3.142 } = vexplode("49 72.1 -548 -3.142", " ", true)
    if not String or not Separator then return end
    
    String = vcompactChar(String, Separator)
    
    if string.sub(String, 1, 1) == Separator then String = string.sub(String, 2) end
    if string.sub(String, -1) == Separator then String = string.sub(String, 1, -2) end
    
    local Table, SearchPos, SeparatorPos, SeparatorPos2, Token = {}, 1
    repeat
        SeparatorPos2 = string.find(String, Separator, SearchPos, true)
        if SeparatorPos2 then
            Token = string.sub(String, SearchPos, SeparatorPos2 - 1)
            if ConvertTokenToNumber then Token = tonumber(Token) end
            table.insert(Table, Token)
            SearchPos = SeparatorPos2 + 1
            SeparatorPos = SeparatorPos2
        else
            Token = string.sub(String, SearchPos)
            if Token then
                if ConvertTokenToNumber then Token = tonumber(Token) end
                table.insert(Table, Token)
            end
        end
    until
        not SeparatorPos2
    
    return Table
end




--[[ - - - - - - - - - - - ]]
--[[ Run Time Calls        ]]
--[[ - - - - - - - - - - - ]]

outputConsole("File Functions loaded")
