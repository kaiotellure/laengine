BLIPS = {
	Garage = 27
}

SPAWNS = {
	{-702.4, 917.8, 12.3, 90},
}

FONTS = {
	Default = 'default-bold'
}

ICONS = {
	Alert = "ƀ", Radio = "Ɓ", Download = "Ƃ", R = "ƃ", ArrowRight = "Ƅ",
	MouseRightButton = "ƅ"
}

MAX_CLIPS = {
	[23] = 17, -- Silenced
	[30] = 30, -- AK
	[31] = 50, -- M4
}

COLORS = {
	gray = tocolor(125, 125, 125),
	white = tocolor(225, 225, 225),
	yellow = tocolor(255, 224, 140),
	red = tocolor(181, 22, 32),
	DarkGreen = tocolor(0, 138, 55),
	LightGreen = tocolor(0, 138, 55),
	purple = tocolor(67, 0, 135)
}

HABILITIES = {
	["auto_engineer"] = {
		name = "Engenharia Automobilística", weight = 20,
		description = "Veículos produzidos por você tem maior resistência e possuem gadgets adicionais."
	},
	["military_engineer"] = {
		name = "Engenharia Militar", weight = 1,
		description = "Armas produzidas por você tem mais letalidade e munições."
	}
}

RADIO_STATIONS = {
	{
		name = "Brazil HITS",
		source = "assets/radios/brazilhits.mp3",
		infos = "53.8 MBs", logo = "assets/radios/brazilhits.jpeg"
	},
	{
		name = "ÁrabicaFM",
		source = "assets/radios/arabica.mp3",
		infos = "130 MBs", logo = "assets/radios/arabica.jpeg"
	},
	{
		name = "ÁrabicaFM 2",
		source = "assets/radios/arabica.mp3",
		infos = "130 MBs", logo = "assets/radios/arabica.jpeg"
	},
	{
		name = "Matuê 333",
		source = "assets/radios/matue-333.mp3",
		infos = "(40 MB)", logo = "assets/radios/matue-333.jpg"
	}
}

function uuid()
    local template ='xxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

-- Merges strings separating them by spaces
function space(...)
	local result, args = "", {...}
	for i, string in ipairs(args) do
		result = result..(i == 1 and "" or " ")..string
	end
	return result
end

TIPS = {
	space(ICONS.Radio, "Pressione e segure #ffe08c"..ICONS.R.."# para alterar a #ffe08crádio# do seu veículo."),
	space(ICONS.Radio, "Portas abertas #ffe08camplificam# o som do #ffe08crádio# do veículo para ouvintes externos."),
	space("Pressione #ffe08c"..ICONS.MouseRightButton.."# para atirar pela janela.")
}

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

PI = math.pi
PI2 = PI*2
sin = math.sin
cos = math.cos
atan2 = math.atan2
ceil = math.ceil
sqrt = math.sqrt
floor = math.floor
max = math.max
min = math.min

function rot(angle, by, range)
	return (angle + by) % range
end

function format_money(money)
	money = tostring(money):reverse()
	local formated = ""

	for i = 1, #money do
		formated = formated..money:sub(i,i)..(i%3 == 0 and i ~= #money and "." or "")
	end

	return formated:reverse()
end