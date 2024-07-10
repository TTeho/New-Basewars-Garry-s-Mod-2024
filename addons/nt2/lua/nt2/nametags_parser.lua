AddCSLuaFile()

local compileExpression
do
	local lib =
	{
		PI = math.pi,
		pi = math.pi,
		rand = math.random,
		random = math.random,
		randx = function(a,b)
			a = a or -1
			b = b or 1
			return math.Rand(a, b)
		end,

		abs = math.abs,
		sgn = function (x)
			if x < 0 then return -1 end
			if x > 0 then return  1 end
			return 0
		end,

		pwm = function(offset, w)
			w = w or 0.5
			return offset % 1 > w and 1 or 0
		end,

		square = function(x)
			x = math.sin(x)

			if x < 0 then return -1 end
			if x > 0 then return  1 end

			return 0
		end,

		acos = math.acos,
		asin = math.asin,
		atan = math.atan,
		atan2 = math.atan2,
		ceil = math.ceil,
		cos = math.cos,
		cosh = math.cosh,
		deg = math.deg,
		exp = math.exp,
		floor = math.floor,
		frexp = math.frexp,
		ldexp = math.ldexp,
		log = math.log,
		log10 = math.log10,
		max = math.max,
		min = math.min,
		rad = math.rad,
		sin = math.sin,
		sinc = function (x)
			if x == 0 then return 1 end
			return math.sin(x) / x
		end,
		sinh = math.sinh,
		sqrt = math.sqrt,
		tanh = math.tanh,
		tan = math.tan,

		clamp = math.Clamp,
		pow = math.pow,

		t = RealTime,
		time = RealTime,
	}

	local code_cache   = {}
	local bad_keywords = {
		"break",     "do",        "else",      "elseif",    "end",
		"false",     "for",       "function",  "if",        "in",
		"repeat",    "return",    "then",      "until",     "while",
		"local",
	}

	function compileExpression(exp)
		if code_cache[exp] then
			return true, code_cache[exp]
		end

		local ch = exp:match("[^=1234567890%-%+%*/%%%^%(%)%.A-z%s]")
		if ch then
			return false, "expression:1: invalid character " .. ch
		end

		for _, keyword in ipairs(bad_keywords) do
			local ch = exp:match("[^A-z]" .. keyword .. "[^A-z]") or exp:match("^" .. keyword .. "[^A-z]")
			if ch then
				return false, "expression:1: keywords are not allowed " .. ch
			end
		end

		local compiled = CompileString("return (" .. exp .. ")", "expression", false)
		if isstring(compiled) then
			compiled = CompileString(exp, "expression", false)
		end
		if isstring(compiled) then
			return false, compiled
		end
		if not isfunction(compiled) then
			return false, "expression:1: unknown error"
		end

		code_cache[exp] = setfenv(compiled, lib)
		return true, code_cache[exp]
	end
end

local tags =
{
	color = {
		default = {255, 255, 255, 255},
		callback = function(params)
			return Color(params[1], params[2], params[3], params[4])
		end,
		params = {"number", "number", "number", "number"}
	},
	hsv = {
		default = {0, 1, 1},
		callback = function(params)
			return HSVToColor(params[1] % 360, params[2], params[3])
		end,
		params = {"number", "number", "number"}
	},
}

local types =
{
	["number"] = tonumber,
	["bool"] = tobool,
	["string"] = tostring,
}

local function doArgs(tag, args)
	local internal_args = args:Split(",")
	local params = tag.params
	local def = tag.default

	local res = {}
	local static = true

	for i, v in ipairs(params) do
		local internal = internal_args[i]

		if internal then
			local arg
			local exp = internal:match("%[(.+)%]")
			if exp then
				static = false

				local ok, f = compileExpression(exp)
				if ok then
					ok, f = pcall(f)

					if ok then
						arg = f
					end
				end

				arg = types[v](arg)
			else
				arg = types[v](internal)
			end

			if arg then
				res[i] = arg
			else
				res[i] = def[i]
			end
		else
			res[i] = def[i]
		end
	end

	return res, static
end

local parser_cache = {}

nametags = nametags or {}
function nametags.parser(txt, default_color)
	default_color = default_color or Color(255, 255, 255, 255)
	local color_id = tostring(default_color)

	if parser_cache[txt] and parser_cache[txt][color_id] then
		return parser_cache[txt][color_id]
	end

	local res = {}
	local shouldEscape = true

	local cur = ""
	local inTag
	local escaped

	local colorStack = {}
	local inColors = 0

	local static = true

	for _, s in ipairs(utf8.totable(txt)) do
		if s == "<" and not inTag then
			inTag = true
			if cur ~= "" then
				table.insert(res, cur)
				cur = ""
			end
		elseif s == ">" and inTag then
			inTag = nil
			cur = cur:lower()
			if cur:sub(1, 1) == "/" then
				cur = cur:sub(2)

				if shouldEscape and escaped and cur == "noparse" then
					escaped = false
				elseif not escaped and inColors > 0 then
					table.remove(colorStack)
					inColors = inColors - 1
					if inColors > 0 then
						table.insert(res, colorStack[inColors])
					else
						table.insert(res, default_color)
					end
				else
					table.insert(res, "</" .. cur .. ">")
				end
			else
				local tag, args = cur:match("(.-)=(.+)")
				if not tag then
					tag, args = cur, ""
				end
				local tagobject = tags[tag]

				if shouldEscape and not escaped and tag == "noparse" then
					escaped = true
				elseif escaped or not tagobject then
					table.insert(res, "<" .. cur .. ">")
				else
					local args_parsed, is_static = doArgs(tagobject, args)
					if not is_static then
						static = false -- no caching, it changes
					end

					local col = tagobject.callback(args_parsed)
					table.insert(colorStack, col)
					table.insert(res, col)
					inColors = inColors + 1
				end
			end

			cur = ""
		else
			cur = cur .. s
		end
	end

	if cur ~= "" or inTag then
		local var = cur
		if inTag then
			var = "<" .. var
		end

		table.insert(res, var)
	end

	if static then
		parser_cache[txt] = parser_cache[txt] or {}
		parser_cache[txt][color_id] = res
	end

	return res, static
end
