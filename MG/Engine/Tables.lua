--[[ - - - - - - - - - - - ]]
--[[ 	Engine functions   ]]
--[[ - - - - - - - - - - - ]]
--[[ 	Table functions    ]]
--[[ - - - - - - - - - - - ]]

function vtonumberTable(Table, Keys)
    local Table2 = {}
    for i,v in pairs(Table) do
        if Keys then Table2[tonumber(i)] = v
        else Table2[i] = tonumber(v)
        end
    end
    return Table2
end

function vinTable(Table, Value)
    for i,v in pairs(Table) do
        if v == Value then
            return true
        end
    end
    return false
end

function getTableKey(Table, Value)
	for i,v in pairs(Table) do
		if v == Value then return i end
	end
	return
end

function vgetTableString(Table)
    local String, IntKey, Element = {}, (visTableIntKey(Table)) and true or false
    table.insert(String, '{')
    for i,v in _G[((IntKey) and 'i' or '')..'pairs'](Table) do
        Element = { i, v }
        for j,w in ipairs(Element) do
            if j == 1 then table.insert(String, ((#String > 1) and ',' or '')..((IntKey) and '' or '[')) end
            
            if not IntKey or j == 2 then
                Type = type(w)
                if Type == 'number' then table.insert(String, w)
                elseif Type == 'boolean' then table.insert(String, ((w) and 'true' or 'false'))
                elseif Type == 'string' then table.insert(String, [[']]..vreplace(vreplace(w, [[\]], [[\\]]), [[']], [[\']])..[[']])
                elseif Type == 'table' then table.insert(String, vgetTableString(w))
                elseif Type == 'function' then table.insert(String, 'function() <body> end')
                elseif Type == 'userdata' then table.insert(String, '<userdata>')
                elseif Type == 'nil' then table.insert(String, 'nil')
                else table.insert(String, '<unknown data type>')
                end
            end
            
            if j == 1 then table.insert(String, ((IntKey) and '' or ']=')) end
        end
    end
    table.insert(String, '}')
    return table.concat(String)
end

function visTableIntKey(Table)
    local b = 0
    for i,v in pairs(Table) do b = b + 1 end
    for a=1, b do
        if not Table[a] then return false end
    end
    return true
end

function vfileTable(Path)
    if not Path then return end
    
    local Table = {}
    local Handle = io.open(Path, "r")
    if Handle then
        io.close(Handle)
        
        local SpacePos
        for Line in io.lines(Path) do
            if Line ~= "" then
                SpacePos = string.find(Line, " ", 1, true)
                if SpacePos then
                    Table[string.sub(Line, 1, SpacePos - 1)] = string.sub(Line, SpacePos + 1)
                end
            end
        end
    end
    
    return Table
end

--[[ Print Loading results ]]
outputConsole("		Engine Table Functions Loaded")
