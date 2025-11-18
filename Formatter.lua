local Formatter = {} 
local Suffixes = {"K", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No", "Dc", "Uc"}

function Formatter:FormatDecimals(Num:number, Decimals:number)
	return string.format("%." .. Decimals .. "f",Num)
end

function Formatter:FormatCommas(Number)
	return tostring(Number):reverse():gsub("(%d%d%d)", "%1,"):gsub(",(%-?)$", "%1"):reverse()
end

function Formatter:Number(Num:number, Decimals:number, ForceENotation:boolean, CommasDisable:boolean)
    
	if Num < 1e9 then 
        local formattedNum = Num == math.floor(Num) and Formatter:FormatDecimals(Num, 0) or Formatter:FormatDecimals(Num, Decimals or 2)
                return CommasDisable and formattedNum or Formatter:FormatCommas(formattedNum)
    end
	
	local Notation = math.floor(math.log(Num,10))
	local kNotation = math.floor(math.log(Num,1000))
	local Front = Num / math.pow(1000,kNotation)
	
	Decimals = (math.floor(Front) == Front) and 0 or (Decimals or 2)
	
	return (kNotation <= #Suffixes and not ForceENotation) and (string.format("%." .. Decimals .. "f", Num / math.pow(1000, kNotation)) .. (Suffixes[kNotation] or "")) or (string.format("%." .. Decimals .. "f", Num / math.pow(10, Notation)) .. "e+" .. Notation)
end


function Formatter:Time(TotalSeconds: number): string
    if TotalSeconds < 0 then TotalSeconds = 0 end 
    
    local SECONDS_PER_DAY = 86400
        local Days = math.floor(TotalSeconds / SECONDS_PER_DAY)
    local RemainingSeconds = TotalSeconds % SECONDS_PER_DAY
        
    local Seconds = RemainingSeconds % 60
    local TotalMinutes = math.floor(RemainingSeconds / 60)
    
    local Minutes = TotalMinutes % 60
    local Hours = math.floor(TotalMinutes / 60)

    local formattedSeconds = string.format("%02d", Seconds)
    local formattedMinutes = string.format("%02d", Minutes)
    local formattedHours = string.format("%02d", Hours)
    
    local formattedDays = string.format("%d", Days) 

    return formattedDays .. "j " .. formattedHours .. ":" .. formattedMinutes .. ":" .. formattedSeconds
end

return Formatter
