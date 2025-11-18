local Suffixes = {"K", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No", "Dc", "Uc"}

function FormatNumber:FormatDecimals(Num:number, Decimals:number)
	return string.format("%." .. Decimals .. "f",Num)
end

function FormatNumber:FormatCommas(Number)
	return tostring(Number):reverse():gsub("(%d%d%d)", "%1,"):gsub(",(%-?)$", "%1"):reverse()
end

function FormatNumber:Number(Num:number, Decimals:number, ForceENotation:boolean, CommasDisable:boolean)
	if Num < 1e9 then return C:FormatCommas(Num == math.floor(Num) and C:FormatDecimals(Num,0) or C:FormatDecimals(Num,2)) end
	
	local Notation = math.floor(math.log(Num,10))
	
	local kNotation = math.floor(math.log(Num,1000))
	
	local Front = Num / math.pow(1000,kNotation)
	
	Decimals = (math.floor(Front) == Front) and 0 or (Decimals or 2)
	
	return (kNotation <= #Suffixes and not ForceENotation) and (string.format("%." .. Decimals .. "f", Num / math.pow(1000, kNotation)) .. (Suffixes[kNotation] or "")) or (string.format("%." .. Decimals .. "f", Num / math.pow(10, Notation)) .. "e+" .. Notation)
end
