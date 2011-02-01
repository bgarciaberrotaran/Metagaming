--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]
--[[ VCO Lua Extensions 1.06                                                 ]]
--[[ Created by Mex                                                          ]]
--[[                                                                         ]]
--[[ Website    http://vle.vicecityonline.com/                               ]]
--[[ Need help? http://vle.vicecityonline.com/help/                          ]]
--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]

--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]
--[[ Timers.lua                                                              ]]
--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]


--[[ - - - - - - - - - - - ]]
--[[ Run Time Setup        ]]
--[[ - - - - - - - - - - - ]]

--[[ Mark this script as loaded, other scripts can then check if this script is loaded ]]
vloaded_timers = true

--[[ Create empty tables ]]
vtimers = {}




--[[ - - - - - - - - - - - ]]
--[[ Command Functions     ]]
--[[ - - - - - - - - - - - ]]




--[[ - - - - - - - - - - - ]]
--[[ Callbacks             ]]
--[[ - - - - - - - - - - - ]]




--[[ - - - - - - - - - - - ]]
--[[ Functions             ]]
--[[ - - - - - - - - - - - ]]

function vtimer(TimerName, Repetitions, Interval, Function, ...)
	-- this function requires: visTimer(), vkillTimer() and vcallTimer()
	-- vtimers[i] = { [1]=EndTicks, [2]=TimerID, [3]=TimerName, [4]=RepetitionsLeft, [5]=IntervalMS, [6]=FunctionName, [7]=ParametersTable }
	if not TimerName or not Repetitions or not Interval or not Function then return end
	if visTimer(TimerName) then vkillTimer(TimerName) end
	local TimerID = createTimer("vcallTimer", Interval, Repetitions)
	table.insert(vtimers, { (os.clock() * 1000) + Interval, TimerID, TimerName, Repetitions - 1, Interval, Function, arg })
	table.sort(vtimers, function(a,b) return a[1]<b[1] end)
	return TimerID
end
function vcallTimer()
	local Function, Parameters = vtimers[1][6], vtimers[1][7]
	if vtimers[1][4] == 0 then table.remove(vtimers, 1) -- 0 repetitions remaining, remove timer from table
	else
		if vtimers[1][4] ~= -1 then vtimers[1][4] = vtimers[1][4] - 1 end -- not unlimited repetitions, take 1 off
		vtimers[1][1] = (os.clock() * 1000) + vtimers[1][5] -- update EndTicks in table
		table.sort(vtimers, function(a,b) return a[1]<b[1] end)
	end
	_G[Function](unpack(Parameters))
end
function vkillTimer(TimerNameOrID)
	if not TimerNameOrID then return end
	local Type, TablePos = type(TimerNameOrID)
	if Type == "string" then
		for i,v in ipairs(vtimers) do
			if v[3] == TimerNameOrID then TablePos = i break end
		end
	elseif Type == "number" then
		for i,v in ipairs(vtimers) do
			if v[2] == TimerNameOrID then TablePos = i break end
		end
	end
	if TablePos then
		destroyTimer(vtimers[TablePos][2])
		table.remove(vtimers, TablePos)
		return true
	end
	return false
end
function visTimer(TimerName, SubMatch)
	if not SubMatch then
		for i,v in ipairs(vtimers) do
			if v[3] == TimerName then return true end
		end
	else
		local SubLength = string.len(TimerName)
		for i,v in ipairs(vtimers) do
			if string.sub(v[3], 1, SubLength) == TimerName then return true end
		end
	end
	return false
end
function vgetTimers()
	return #vtimers
end

--[[ - - - - - - - - - - - ]]
--[[ Run Time Calls        ]]
--[[ - - - - - - - - - - - ]]

--[[ - - - - - - - - - - - ]]
--[[ 	Print loaded	   ]]
--[[ - - - - - - - - - - - ]]

outputConsole("Timers Functions loaded")

