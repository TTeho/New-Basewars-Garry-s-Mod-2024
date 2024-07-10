local function charbytes(str, pos)
	local c = string.byte(str, pos)

	if c > 0 and c <= 127 then
		return 1
	elseif c >= 194 and c <= 223 then
		return 2
	elseif c >= 224 and c <= 239 then
		return 3
	elseif c >= 240 and c <= 244 then
		return 4
	end

	return -1
end

function utf8.sub(str, start, send)
  local send = send or -1

	local pos = 1
	local bytes = string.len(str)
	local len = 0

	local a = (start >= 0 and send >= 0) or utf8.len(str)
	local startChar = (start >= 0) and start or a + start + 1
	local endChar = (send >= 0) and send or a + send + 1

	if startChar > endChar then
		return ""
	end

	local startByte, endByte = 1, bytes

	while pos <= bytes do
		len = len + 1

		if len == startChar then
			startByte = pos
		end

		pos = pos + charbytes(str, pos)

		if len == endChar then
			endByte = pos - 1
			break
		end
	end

	return string.sub(str, startByte, endByte)
end

function utf8.totable(str)
	local tbl = {}

	for uchar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		tbl[#tbl+1] = uchar
	end

	return tbl
end
