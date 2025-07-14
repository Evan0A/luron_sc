print("VERSION: 10")
---[=== CONFIG ===]---
auto_rest_many_mods = true
minimum_many_mods = 5

auto_rest_specific_mod = true
specific_mod_list = {"kailyx", "misthios", "windyplay"} -- uppercase is not nessesary

auto_rest_schedule = true
schedule_zone = "UTC+7"
schedule_list = {
    "14:00 - 15:00",
    "23:00 - 02:00",
    "10:00 - 11:00"
}

auto_rest_player = true 
minimum_player = 30000
maximum_player = 130000

auto_rest_banrate = true 
minimum_banrate = 1.0

---[=== SETTINGS ===]---

use_webhook = true
webhook_link = "https://discord.com/api/webhooks/1114483839444729936/yQzzCt22cCIF3Wz9XdhGMSmD78yCx3UxyzZNGThl01kbmM34Z2ern42Sy3slDjPI3xto"
edit_message_reconnect = false -- true if edit message rest to reconnect/false if send new message

hide_bot_identity = false
reconnect_after_rest = true
check_delay = 2
execute_delay = 1000 -- milisecond
delay_many_mods = 5 --minutes 
delay_specific_mod = 5 -- minutes
delay_schedule = 2 -- minutes
delay_banrate = 5
delay_player = 5

-----[===== CUSTOM AREA =====]-----

custom_mode = true
turn_on_rotation = true

spam_messages = {
    "ghugasdjads",
    "asdkshjdknm", 
    "czbxmnbmzcx", 
    "xzbmmio", 
    "buhgasa", 
    "nbahuia"
}

webhook_malady = "https://discord.com/api/webhooks/1114483559114215476/HO4ARS2PrtmvRPO1_T2pvKAdJocqcx9u_K_4ZNMl4nR-H6a5Tl_yIdfk8TGcV6TOR0C3"

auto_take_vial = false
world_vial = "world|door"

auto_take_pickaxe = false
world_pickaxe = "world|door"

delay_warp = 10000



-----[===== CODE AREA =====]-----
cpu_stopper = false
cpu_minimum = 100
custom_captain = false 
captain_index = 1
-- Module options:
local always_try_using_lpeg = true
local register_global_module_table = false
local global_module_name = 'json'

-- global dependencies:
local pairs, type, tostring, tonumber, getmetatable, setmetatable, rawset =
      pairs, type, tostring, tonumber, getmetatable, setmetatable, rawset
local error, require, pcall, select = error, require, pcall, select
local floor, huge = math.floor, math.huge
local strrep, gsub, strsub, strbyte, strchar, strfind, strlen, strformat =
      string.rep, string.gsub, string.sub, string.byte, string.char,
      string.find, string.len, string.format
local strmatch = string.match
local concat = table.concat

local json = { version = "dkjson 2.5" }

if register_global_module_table then
  _G[global_module_name] = json
end

pcall (function()
  -- Enable access to blocked metatables.
  -- Don't worry, this module doesn't change anything in them.
  local debmeta = require "debug".getmetatable
  if debmeta then getmetatable = debmeta end
end)

json.null = setmetatable ({}, {
  __tojson = function () return "null" end
})

local function isarray (tbl)
  local max, n, arraylen = 0, 0, 0
  for k,v in pairs (tbl) do
    if k == 'n' and type(v) == 'number' then
      arraylen = v
      if v > max then
        max = v
      end
    else
      if type(k) ~= 'number' or k < 1 or floor(k) ~= k then
        return false
      end
      if k > max then
        max = k
      end
      n = n + 1
    end
  end
  if max > 10 and max > arraylen and max > n * 2 then
    return false -- don't create an array with too many holes
  end
  return true, max
end

local escapecodes = {
  ["\""] = "\\\"", ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f",
  ["\n"] = "\\n",  ["\r"] = "\\r",  ["\t"] = "\\t"
}

local function escapeutf8 (uchar)
  local value = escapecodes[uchar]
  if value then
    return value
  end
  local a, b, c, d = strbyte (uchar, 1, 4)
  a, b, c, d = a or 0, b or 0, c or 0, d or 0
  if a <= 0x7f then
    value = a
  elseif 0xc0 <= a and a <= 0xdf and b >= 0x80 then
    value = (a - 0xc0) * 0x40 + b - 0x80
  elseif 0xe0 <= a and a <= 0xef and b >= 0x80 and c >= 0x80 then
    value = ((a - 0xe0) * 0x40 + b - 0x80) * 0x40 + c - 0x80
  elseif 0xf0 <= a and a <= 0xf7 and b >= 0x80 and c >= 0x80 and d >= 0x80 then
    value = (((a - 0xf0) * 0x40 + b - 0x80) * 0x40 + c - 0x80) * 0x40 + d - 0x80
  else
    return ""
  end
  if value <= 0xffff then
    return strformat ("\\u%.4x", value)
  elseif value <= 0x10ffff then
    -- encode as UTF-16 surrogate pair
    value = value - 0x10000
    local highsur, lowsur = 0xD800 + floor (value/0x400), 0xDC00 + (value % 0x400)
    return strformat ("\\u%.4x\\u%.4x", highsur, lowsur)
  else
    return ""
  end
end

local function fsub (str, pattern, repl)
  -- gsub always builds a new string in a buffer, even when no match
  -- exists. First using find should be more efficient when most strings
  -- don't contain the pattern.
  if strfind (str, pattern) then
    return gsub (str, pattern, repl)
  else
    return str
  end
end

local function quotestring (value)
  -- based on the regexp "escapable" in https://github.com/douglascrockford/JSON-js
  value = fsub (value, "[%z\1-\31\"\\\127]", escapeutf8)
  if strfind (value, "[\194\216\220\225\226\239]") then
    value = fsub (value, "\194[\128-\159\173]", escapeutf8)
    value = fsub (value, "\216[\128-\132]", escapeutf8)
    value = fsub (value, "\220\143", escapeutf8)
    value = fsub (value, "\225\158[\180\181]", escapeutf8)
    value = fsub (value, "\226\128[\140-\143\168-\175]", escapeutf8)
    value = fsub (value, "\226\129[\160-\175]", escapeutf8)
    value = fsub (value, "\239\187\191", escapeutf8)
    value = fsub (value, "\239\191[\176-\191]", escapeutf8)
  end
  return "\"" .. value .. "\""
end
json.quotestring = quotestring

local function replace(str, o, n)
  local i, j = strfind (str, o, 1, true)
  if i then
    return strsub(str, 1, i-1) .. n .. strsub(str, j+1, -1)
  else
    return str
  end
end

-- locale independent num2str and str2num functions
local decpoint, numfilter

local function updatedecpoint ()
  decpoint = strmatch(tostring(0.5), "([^05+])")
  -- build a filter that can be used to remove group separators
  numfilter = "[^0-9%-%+eE" .. gsub(decpoint, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "]+"
end

updatedecpoint()

local function num2str (num)
  return replace(fsub(tostring(num), numfilter, ""), decpoint, ".")
end

local function str2num (str)
  local num = tonumber(replace(str, ".", decpoint))
  if not num then
    updatedecpoint()
    num = tonumber(replace(str, ".", decpoint))
  end
  return num
end

local function addnewline2 (level, buffer, buflen)
  buffer[buflen+1] = "\n"
  buffer[buflen+2] = strrep ("  ", level)
  buflen = buflen + 2
  return buflen
end

function json.addnewline (state)
  if state.indent then
    state.bufferlen = addnewline2 (state.level or 0,
                           state.buffer, state.bufferlen or #(state.buffer))
  end
end

local encode2 -- forward declaration

local function addpair (key, value, prev, indent, level, buffer, buflen, tables, globalorder, state)
  local kt = type (key)
  if kt ~= 'string' and kt ~= 'number' then
    return nil, "type '" .. kt .. "' is not supported as a key by JSON."
  end
  if prev then
    buflen = buflen + 1
    buffer[buflen] = ","
  end
  if indent then
    buflen = addnewline2 (level, buffer, buflen)
  end
  buffer[buflen+1] = quotestring (key)
  buffer[buflen+2] = ":"
  return encode2 (value, indent, level, buffer, buflen + 2, tables, globalorder, state)
end

local function appendcustom(res, buffer, state)
  local buflen = state.bufferlen
  if type (res) == 'string' then
    buflen = buflen + 1
    buffer[buflen] = res
  end
  return buflen
end

local function exception(reason, value, state, buffer, buflen, defaultmessage)
  defaultmessage = defaultmessage or reason
  local handler = state.exception
  if not handler then
    return nil, defaultmessage
  else
    state.bufferlen = buflen
    local ret, msg = handler (reason, value, state, defaultmessage)
    if not ret then return nil, msg or defaultmessage end
    return appendcustom(ret, buffer, state)
  end
end

function json.encodeexception(reason, value, state, defaultmessage)
  return quotestring("<" .. defaultmessage .. ">")
end

encode2 = function (value, indent, level, buffer, buflen, tables, globalorder, state)
  local valtype = type (value)
  local valmeta = getmetatable (value)
  valmeta = type (valmeta) == 'table' and valmeta -- only tables
  local valtojson = valmeta and valmeta.__tojson
  if valtojson then
    if tables[value] then
      return exception('reference cycle', value, state, buffer, buflen)
    end
    tables[value] = true
    state.bufferlen = buflen
    local ret, msg = valtojson (value, state)
    if not ret then return exception('custom encoder failed', value, state, buffer, buflen, msg) end
    tables[value] = nil
    buflen = appendcustom(ret, buffer, state)
  elseif value == nil then
    buflen = buflen + 1
    buffer[buflen] = "null"
  elseif valtype == 'number' then
    local s
    if value ~= value or value >= huge or -value >= huge then
      -- This is the behaviour of the original JSON implementation.
      s = "null"
    else
      s = num2str (value)
    end
    buflen = buflen + 1
    buffer[buflen] = s
  elseif valtype == 'boolean' then
    buflen = buflen + 1
    buffer[buflen] = value and "true" or "false"
  elseif valtype == 'string' then
    buflen = buflen + 1
    buffer[buflen] = quotestring (value)
  elseif valtype == 'table' then
    if tables[value] then
      return exception('reference cycle', value, state, buffer, buflen)
    end
    tables[value] = true
    level = level + 1
    local isa, n = isarray (value)
    if n == 0 and valmeta and valmeta.__jsontype == 'object' then
      isa = false
    end
    local msg
    if isa then -- JSON array
      buflen = buflen + 1
      buffer[buflen] = "["
      for i = 1, n do
        buflen, msg = encode2 (value[i], indent, level, buffer, buflen, tables, globalorder, state)
        if not buflen then return nil, msg end
        if i < n then
          buflen = buflen + 1
          buffer[buflen] = ","
        end
      end
      buflen = buflen + 1
      buffer[buflen] = "]"
    else -- JSON object
      local prev = false
      buflen = buflen + 1
      buffer[buflen] = "{"
      local order = valmeta and valmeta.__jsonorder or globalorder
      if order then
        local used = {}
        n = #order
        for i = 1, n do
          local k = order[i]
          local v = value[k]
          if v then
            used[k] = true
            buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder, state)
            prev = true -- add a seperator before the next element
          end
        end
        for k,v in pairs (value) do
          if not used[k] then
            buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder, state)
            if not buflen then return nil, msg end
            prev = true -- add a seperator before the next element
          end
        end
      else -- unordered
        for k,v in pairs (value) do
          buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder, state)
          if not buflen then return nil, msg end
          prev = true -- add a seperator before the next element
        end
      end
      if indent then
        buflen = addnewline2 (level - 1, buffer, buflen)
      end
      buflen = buflen + 1
      buffer[buflen] = "}"
    end
    tables[value] = nil
  else
    return exception ('unsupported type', value, state, buffer, buflen,
      "type '" .. valtype .. "' is not supported by JSON.")
  end
  return buflen
end

function json.encode (value, state)
  state = state or {}
  local oldbuffer = state.buffer
  local buffer = oldbuffer or {}
  state.buffer = buffer
  updatedecpoint()
  local ret, msg = encode2 (value, state.indent, state.level or 0,
                   buffer, state.bufferlen or 0, state.tables or {}, state.keyorder, state)
  if not ret then
    error (msg, 2)
  elseif oldbuffer == buffer then
    state.bufferlen = ret
    return true
  else
    state.bufferlen = nil
    state.buffer = nil
    return concat (buffer)
  end
end

local function loc (str, where)
  local line, pos, linepos = 1, 1, 0
  while true do
    pos = strfind (str, "\n", pos, true)
    if pos and pos < where then
      line = line + 1
      linepos = pos
      pos = pos + 1
    else
      break
    end
  end
  return "line " .. line .. ", column " .. (where - linepos)
end

local function unterminated (str, what, where)
  return nil, strlen (str) + 1, "unterminated " .. what .. " at " .. loc (str, where)
end

local function scanwhite (str, pos)
  while true do
    pos = strfind (str, "%S", pos)
    if not pos then return nil end
    local sub2 = strsub (str, pos, pos + 1)
    if sub2 == "\239\187" and strsub (str, pos + 2, pos + 2) == "\191" then
      -- UTF-8 Byte Order Mark
      pos = pos + 3
    elseif sub2 == "//" then
      pos = strfind (str, "[\n\r]", pos + 2)
      if not pos then return nil end
    elseif sub2 == "/*" then
      pos = strfind (str, "*/", pos + 2)
      if not pos then return nil end
      pos = pos + 2
    else
      return pos
    end
  end
end

local escapechars = {
  ["\""] = "\"", ["\\"] = "\\", ["/"] = "/", ["b"] = "\b", ["f"] = "\f",
  ["n"] = "\n", ["r"] = "\r", ["t"] = "\t"
}

local function unichar (value)
  if value < 0 then
    return nil
  elseif value <= 0x007f then
    return strchar (value)
  elseif value <= 0x07ff then
    return strchar (0xc0 + floor(value/0x40),
                    0x80 + (floor(value) % 0x40))
  elseif value <= 0xffff then
    return strchar (0xe0 + floor(value/0x1000),
                    0x80 + (floor(value/0x40) % 0x40),
                    0x80 + (floor(value) % 0x40))
  elseif value <= 0x10ffff then
    return strchar (0xf0 + floor(value/0x40000),
                    0x80 + (floor(value/0x1000) % 0x40),
                    0x80 + (floor(value/0x40) % 0x40),
                    0x80 + (floor(value) % 0x40))
  else
    return nil
  end
end

local function scanstring (str, pos)
  local lastpos = pos + 1
  local buffer, n = {}, 0
  while true do
    local nextpos = strfind (str, "[\"\\]", lastpos)
    if not nextpos then
      return unterminated (str, "string", pos)
    end
    if nextpos > lastpos then
      n = n + 1
      buffer[n] = strsub (str, lastpos, nextpos - 1)
    end
    if strsub (str, nextpos, nextpos) == "\"" then
      lastpos = nextpos + 1
      break
    else
      local escchar = strsub (str, nextpos + 1, nextpos + 1)
      local value
      if escchar == "u" then
        value = tonumber (strsub (str, nextpos + 2, nextpos + 5), 16)
        if value then
          local value2
          if 0xD800 <= value and value <= 0xDBff then
            -- we have the high surrogate of UTF-16. Check if there is a
            -- low surrogate escaped nearby to combine them.
            if strsub (str, nextpos + 6, nextpos + 7) == "\\u" then
              value2 = tonumber (strsub (str, nextpos + 8, nextpos + 11), 16)
              if value2 and 0xDC00 <= value2 and value2 <= 0xDFFF then
                value = (value - 0xD800)  * 0x400 + (value2 - 0xDC00) + 0x10000
              else
                value2 = nil -- in case it was out of range for a low surrogate
              end
            end
          end
          value = value and unichar (value)
          if value then
            if value2 then
              lastpos = nextpos + 12
            else
              lastpos = nextpos + 6
            end
          end
        end
      end
      if not value then
        value = escapechars[escchar] or escchar
        lastpos = nextpos + 2
      end
      n = n + 1
      buffer[n] = value
    end
  end
  if n == 1 then
    return buffer[1], lastpos
  elseif n > 1 then
    return concat (buffer), lastpos
  else
    return "", lastpos
  end
end

local scanvalue -- forward declaration

local function scantable (what, closechar, str, startpos, nullval, objectmeta, arraymeta)
  local len = strlen (str)
  local tbl, n = {}, 0
  local pos = startpos + 1
  if what == 'object' then
    setmetatable (tbl, objectmeta)
  else
    setmetatable (tbl, arraymeta)
  end
  while true do
    pos = scanwhite (str, pos)
    if not pos then return unterminated (str, what, startpos) end
    local char = strsub (str, pos, pos)
    if char == closechar then
      return tbl, pos + 1
    end
    local val1, err
    val1, pos, err = scanvalue (str, pos, nullval, objectmeta, arraymeta)
    if err then return nil, pos, err end
    pos = scanwhite (str, pos)
    if not pos then return unterminated (str, what, startpos) end
    char = strsub (str, pos, pos)
    if char == ":" then
      if val1 == nil then
        return nil, pos, "cannot use nil as table index (at " .. loc (str, pos) .. ")"
      end
      pos = scanwhite (str, pos + 1)
      if not pos then return unterminated (str, what, startpos) end
      local val2
      val2, pos, err = scanvalue (str, pos, nullval, objectmeta, arraymeta)
      if err then return nil, pos, err end
      tbl[val1] = val2
      pos = scanwhite (str, pos)
      if not pos then return unterminated (str, what, startpos) end
      char = strsub (str, pos, pos)
    else
      n = n + 1
      tbl[n] = val1
    end
    if char == "," then
      pos = pos + 1
    end
  end
end

scanvalue = function (str, pos, nullval, objectmeta, arraymeta)
  pos = pos or 1
  pos = scanwhite (str, pos)
  if not pos then
    return nil, strlen (str) + 1, "no valid JSON value (reached the end)"
  end
  local char = strsub (str, pos, pos)
  if char == "{" then
    return scantable ('object', "}", str, pos, nullval, objectmeta, arraymeta)
  elseif char == "[" then
    return scantable ('array', "]", str, pos, nullval, objectmeta, arraymeta)
  elseif char == "\"" then
    return scanstring (str, pos)
  else
    local pstart, pend = strfind (str, "^%-?[%d%.]+[eE]?[%+%-]?%d*", pos)
    if pstart then
      local number = str2num (strsub (str, pstart, pend))
      if number then
        return number, pend + 1
      end
    end
    pstart, pend = strfind (str, "^%a%w*", pos)
    if pstart then
      local name = strsub (str, pstart, pend)
      if name == "true" then
        return true, pend + 1
      elseif name == "false" then
        return false, pend + 1
      elseif name == "null" then
        return nullval, pend + 1
      end
    end
    return nil, pos, "no valid JSON value at " .. loc (str, pos)
  end
end

local function optionalmetatables(...)
  if select("#", ...) > 0 then
    return ...
  else
    return {__jsontype = 'object'}, {__jsontype = 'array'}
  end
end

function json.decode (str, pos, nullval, ...)
  local objectmeta, arraymeta = optionalmetatables(...)
  return scanvalue (str, pos, nullval, objectmeta, arraymeta)
end

function json.use_lpeg ()
  local g = require ("lpeg")

  if g.version() == "0.11" then
    error "due to a bug in LPeg 0.11, it cannot be used for JSON matching"
  end

  local pegmatch = g.match
  local P, S, R = g.P, g.S, g.R

  local function ErrorCall (str, pos, msg, state)
    if not state.msg then
      state.msg = msg .. " at " .. loc (str, pos)
      state.pos = pos
    end
    return false
  end

  local function Err (msg)
    return g.Cmt (g.Cc (msg) * g.Carg (2), ErrorCall)
  end

  local SingleLineComment = P"//" * (1 - S"\n\r")^0
  local MultiLineComment = P"/*" * (1 - P"*/")^0 * P"*/"
  local Space = (S" \n\r\t" + P"\239\187\191" + SingleLineComment + MultiLineComment)^0

  local PlainChar = 1 - S"\"\\\n\r"
  local EscapeSequence = (P"\\" * g.C (S"\"\\/bfnrt" + Err "unsupported escape sequence")) / escapechars
  local HexDigit = R("09", "af", "AF")
  local function UTF16Surrogate (match, pos, high, low)
    high, low = tonumber (high, 16), tonumber (low, 16)
    if 0xD800 <= high and high <= 0xDBff and 0xDC00 <= low and low <= 0xDFFF then
      return true, unichar ((high - 0xD800)  * 0x400 + (low - 0xDC00) + 0x10000)
    else
      return false
    end
  end
  local function UTF16BMP (hex)
    return unichar (tonumber (hex, 16))
  end
  local U16Sequence = (P"\\u" * g.C (HexDigit * HexDigit * HexDigit * HexDigit))
  local UnicodeEscape = g.Cmt (U16Sequence * U16Sequence, UTF16Surrogate) + U16Sequence/UTF16BMP
  local Char = UnicodeEscape + EscapeSequence + PlainChar
  local String = P"\"" * g.Cs (Char ^ 0) * (P"\"" + Err "unterminated string")
  local Integer = P"-"^(-1) * (P"0" + (R"19" * R"09"^0))
  local Fractal = P"." * R"09"^0
  local Exponent = (S"eE") * (S"+-")^(-1) * R"09"^1
  local Number = (Integer * Fractal^(-1) * Exponent^(-1))/str2num
  local Constant = P"true" * g.Cc (true) + P"false" * g.Cc (false) + P"null" * g.Carg (1)
  local SimpleValue = Number + String + Constant
  local ArrayContent, ObjectContent

  -- The functions parsearray and parseobject parse only a single value/pair
  -- at a time and store them directly to avoid hitting the LPeg limits.
  local function parsearray (str, pos, nullval, state)
    local obj, cont
    local npos
    local t, nt = {}, 0
    repeat
      obj, cont, npos = pegmatch (ArrayContent, str, pos, nullval, state)
      if not npos then break end
      pos = npos
      nt = nt + 1
      t[nt] = obj
    until cont == 'last'
    return pos, setmetatable (t, state.arraymeta)
  end

  local function parseobject (str, pos, nullval, state)
    local obj, key, cont
    local npos
    local t = {}
    repeat
      key, obj, cont, npos = pegmatch (ObjectContent, str, pos, nullval, state)
      if not npos then break end
      pos = npos
      t[key] = obj
    until cont == 'last'
    return pos, setmetatable (t, state.objectmeta)
  end

  local Array = P"[" * g.Cmt (g.Carg(1) * g.Carg(2), parsearray) * Space * (P"]" + Err "']' expected")
  local Object = P"{" * g.Cmt (g.Carg(1) * g.Carg(2), parseobject) * Space * (P"}" + Err "'}' expected")
  local Value = Space * (Array + Object + SimpleValue)
  local ExpectedValue = Value + Space * Err "value expected"
  ArrayContent = Value * Space * (P"," * g.Cc'cont' + g.Cc'last') * g.Cp()
  local Pair = g.Cg (Space * String * Space * (P":" + Err "colon expected") * ExpectedValue)
  ObjectContent = Pair * Space * (P"," * g.Cc'cont' + g.Cc'last') * g.Cp()
  local DecodeValue = ExpectedValue * g.Cp ()

  function json.decode (str, pos, nullval, ...)
    local state = {}
    state.objectmeta, state.arraymeta = optionalmetatables(...)
    local obj, retpos = pegmatch (DecodeValue, str, pos, nullval, state)
    if state.msg then
      return nil, state.pos, state.msg
    else
      return obj, retpos
    end
  end

  -- use this function only once:
  json.use_lpeg = function () return json end

  json.using_lpeg = true

  return json -- so you can get the module using json = require "dkjson".use_lpeg()
end

if always_try_using_lpeg then
  pcall (json.use_lpeg)
end

script_mode = "ANY"
api = ""
api_mods = ""
api_player = ""
api_use = ""
image_url = ""
access_url = "https://raw.githubusercontent.com/Evan0A/Nuron_access/refs/heads/main/Rest_Script?t="..os.time()
myUsername = getUsername() 
myExpired = ""
enable = true
reason = ""
start_utc = 0
bot_indexs = {}
captain = 1 
midrest = 0
whrestdone = false
lastrestid = 0
restmode = false
first = true
rotation = getBot().rotation
mod_detected = ""
mods_list = {}
player_count = 0
banrate = 0.0
last_banrate = 0.0 
last_player = 0
captainStatus = {"Online", "ManyMod", "SpecificMod", "Banrate", "Schedule", "Player"}

--http catch -- 
total_521 = 0

--webhook 
wh_mod_detected = ""
wh_many_mod = -1 
wh_player = -1 
wh_banrate = -1

function getHttp(url)
    local client = HttpClient.new()
    client.url = url
    local result = client:request()
    if result.error ~= 0 then
        return true
    else
        if result.status == 200 then
            local success, data = pcall(json.decode, result.body)
            if success and type(data) == "table" then
                return data
            else
                webhookAny("Error decoding http data, status: "..success.." data: "..data)
                getBot().custom_status = "stopped"
                getBot():stopScript()
            end
        else
            if result.status == 521 then
                total_521 = total_521 + 1
                if total_521 >= 10 then
                    webhookAny("API currently down, script stopped")
                    getBot().custom_status = "stopped"
                    getBot():stopScript()
                end
            else
                webhookAny("Something wrong with API, ask owner for fix. code: "..result.status)
                getBot().custom_status = "stopped"
                getBot():stopScript()
            end
        end
    end
end

local function get_cpu_usage()
    local status, result = 
    pcall(function() 
        local handle = io.popen("powershell -Command \"(Get-Counter '\\Processor(_Total)\\% Processor Time').CounterSamples.CookedValue\"")
        local result = handle:read("*a")
        handle:close()
    
        local usage = result:match("(%d+%.?%d*)")
        return math.floor(tonumber(usage))
    end)
    if status then 
        return result
    else 
        return -1
    end 
end

function selisih(var1, var2, diff)
    local sum = 0 
    if var1 > var2 then 
        sum = var1 - var2 
    else 
        sum = var2 - var1
    end 
    if sum >= diff then
        return true 
    end 
    return false
end 

function webhookRest(nameBot, from)
    if use_webhook then 
        wh = Webhook.new(webhook_link)
        local reason_emoji = {
            ["1"] = "🛡️",--many mod
            ["2"] = "🚨", -- specific mod 
            ["3"] = "⏰", --schedule
            ["4"] = "🚫", -- banrate 
            ["5"] = "😳" -- player
        }
        local fromS = {
            ["1"] = "MANY MODS DETECTED",
            ["2"] = "SPECIFIC MOD DETECTED",
            ["3"] = "SCHEDULE REST DETECTED",
            ["4"] = "BAN-RATE DETECTED",
            ["5"] = "PLAYER ONLINE DETECTED"
        }
        if hide_bot_identity then 
            nameBot = "HIDDEN"
        else 
            nameBot = nameBot.."(CAPTAIN)"
        end
        local emoji = reason_emoji[tostring(from)] or "❓"
        local utc_time = os.date("!%Y-%m-%d %H:%M UTC")

        -- Info tambahan
        local extra_info = ""
        if from == 1 then
            extra_info = string.format("👥 Mods Online: %d / %d", #mods_list, minimum_many_mods)
            wh_many_mod = #mods_list
            lastrestid = 1
        elseif from == 2 then
            extra_info = string.format("Mod detected: **%s**", mod_detected)
            wh_mod_detected = mod_detected
            lastrestid = 2
        elseif from  == 3 then 
            extra_info = string.format("Rest until: %s (%s)", end_schedule, schedule_zone)
            lastrestid = 3
        elseif from  == 4 then 
            extra_info = string.format("Rest until Ban-rate lower, ban-rate: %f", banrate)
            wh_banrate = banrate
            lastrestid = 4
        elseif from  == 5 then 
            extra_info = ""
            if player_count >= maximum_player then 
                extra_info = string.format("Rest until player count get lower: %d / %d", player_count, maximum_player)
            else 
                extra_info = string.format("Rest until player count get higher: %d / %d", player_count, minimum_player)
            end
            wh_player = player_count
            lastrestid = 5
        end
        wh.embed1.use = true
        wh.embed1.title = string.format("[%s]REST DETECTED", emoji)
        wh.embed1.color = 16711680
        wh.embed1:addField("<:bot_gradient:1389670917755375746> | BOT NAME: ", nameBot, true)
        wh.embed1:addField("<a:offline:1365647922330603611> | REASON: ", fromS[tostring(from)], true)
        wh.embed1:addField(" <:animated_clock:1389671974552469524> | TIME (UTC): ", utc_time, true)
        wh.embed1:addField("<:emojigg_CPU:1390949692317106196> | CPU USAGE: ", (get_cpu_usage()), true)
        wh.embed1:addField("<:star:1389672145839329360> | EXTRA INFO: ", (string.format("%s", extra_info)), true)
        wh.embed1.footer.text = "Made with love by NEXORA"
        wh.embed1.footer.icon_url = image_url
        if getBot().index == captain then 
            if not whrestdone then 
                wh:send()
                whrestdone = true 
                midrest = wh.message_id
            elseif whrestdone and from ~= lastrestid then 
                wh:edit(midrest)
            elseif whrestdone and from == lastrestid and lastrestid == 1 and wh_many_mod ~= #mods_list then 
                wh:edit(midrest)
                wh_many_mod = #mods_list
            elseif whrestdone and from == lastrestid and lastrestid == 2 and wh_mod_detected ~= mod_detected then 
                wh:edit(midrest)
                wh_mod_detected = mod_detected
            elseif whrestdone and from == lastrestid and lastrestid == 5 and selisih(wh_player, player_count, 2000) then wh:edit(midrest)
                wh_player = player_count
            end
        end 
    end 
end

function webhookRecon(nameBot, from)
    if use_webhook and whrestdone then 
        local wh = Webhook.new(webhook_link)
        local reason_emoji = {
            ["1"] = "🛡️",--many mod
            ["2"] = "🚨", -- specific mod 
            ["3"] = "⏰", -- schedule
            ["4"] = "✅", -- banrate
            ["5"] = "🤠" -- player
        }
        local fromS = {
            ["1"] = "MANY MODS REST ENDED",
            ["2"] = "SPECIFIC MOD REST ENDED",
            ["3"] = "SCHEDULE REST ENDED",
            ["4"] = "BANRATE DROPPED",
            ["5"] = "PLAYER ACTIVE"
        }
        if hide_bot_identity then 
            nameBot = "HIDDEN"
        else
            nameBot = nameBot.."(CAPTAIN)"
        end
        local emoji = "✅"
        local utc_time = os.date("!%Y-%m-%d %H:%M UTC")

        -- Info tambahan
        local extra_info = ""
        if from == 1 then
            extra_info = string.format("Mods Online: %d / %d", #mods_list, minimum_many_mods)
        elseif from == 2 then
            extra_info = "Previous mod: **" .. mod_detected .. "**"
        elseif from == 3 then 
            extra_info = string.format("Schedule ended at: %s (%s)", end_schedule, schedule_zone)
        elseif from == 4 then 
            extra_info = string.format("Last ban-rate: "..last_banrate)
        elseif from == 5 then 
            extra_info = string.format("Last player online: "..last_player)
        end

        wh.embed1.use = true
        wh.embed1.title = string.format("[%s]REST TIME DONE", emoji)
        wh.embed1.color = 3066993 -- warna hijau
        wh.embed1:addField("<:bot_gradient:1389670917755375746> | BOT NAME: ", nameBot, true)
        wh.embed1:addField("<a:Online1:1365647772468117636> | STATUS: ", fromS[tostring(from)], true)
        wh.embed1:addField("<:animated_clock:1389671974552469524> | TIME (UTC): ", utc_time, true)
        wh.embed1:addField("<:emojigg_CPU:1390949692317106196> | CPU USAGE: ", (get_cpu_usage()), true)
        wh.embed1:addField("🔍 | EXTRA INFO: ", (string.format("%s", extra_info)), true)
        wh.embed1.footer.text = "Made with love by NEXORA"
        wh.embed1.footer.icon_url = image_url
        if getBot().index == captain then 
            if edit_message_reconnect then 
                wh:edit(midrest)
                whrestdone = false
            else
                wh:send()
                whrestdone = false
            end 
        end 
    end 
end

function webhookAny(cont)
    if getBot().index == captain then
        wh = Webhook.new(webhook_link)
        wh.content = cont 
        wh:send()
    end
end

function webhookMalady(cont)
    wh = Webhook.new(webhook_malady)
    wh.content = cont 
    wh:send() 
end

function cpuStopper() 
    if cpu_stopper then 
        local mycpu = get_cpu_usage()
        if mycpu >= cpu_minimum then 
            if getBot().index == captain then 
                webhookAny("CPU too high, script stopped. CPU: "..mycpu.."/"..cpu_minimum)
            end 
            getBot().custom_status = ""
            getBot():stopScript()
        elseif mycpu == -1 then 
            cpu_stopper = false 
            webhookAny("Cannot get CPU percentage")
        end 
    end 
end 

function haveSame(arr1, arr2)
    for _, a1 in pairs(arr1) do 
        for _, a2 in pairs(arr2) do 
            if a1:upper() == a2:upper() then 
                return true, a1
            end 
        end 
    end 
    return false 
end

function isIn(arr, val)
    for _, key in pairs(arr) do 
        if key:upper() == val:upper() then 
            return true 
        end 
    end 
    return false 
end

function cekDouble(arr, val) 
    local available = false
    for i = 1, #arr do 
        if arr[i] == val then 
            available = false
        end 
    end 
    if not available then 
        table.insert(arr, val) 
        return true 
    end 
    return false 
end
 
function getCaptain(bool)
    bool = bool or false
    local botCount = #getBots()
    local function cekRunning()
        for i = 1, botCount do
            local Cstatus = tostring(getBot(i).custom_status)
            if isIn(captainStatus, Cstatus) and getBot(i):isRunningScript() and getBot(i).name ~= getBot().name then 
                getBot().custom_status = string.format("Following captain(%s)", getBot(i).name)
                return true, i
            end
        end 
        return false, 0
    end
    local status, num = cekRunning()
    if status then 
        captain = num
        return true
    end
    sleep(10000)
    getBot().custom_status = "REST VERIFICATION 1"
    sleep(10000)
    for i = 1, botCount do 
        if getBot(i).custom_status == "REST VERIFICATION 1" and getBot(i):isRunningScript() then 
            cekDouble(bot_indexs, tonumber(getBot(i).index))
        end 
    end
    sleep(5000)
    captain = bot_indexs[math.ceil(#bot_indexs / 2)]
    if getBot().index == captain then 
        print("changed captain rest: "..getBot(captain).name)
        if bool then
            getUserData(true)
            getModList()
        end
    else 
        getBot().custom_status = string.format("Following captain(%s)", getBot(captain).name)
    end
end

function getUserData(bool)
    bool = bool or false
    local data = getHttp(access_url)
    local found = false
    if bool then 
        api = data.api
        return true
    end
    for _, users in pairs(data.access_list) do
        if users.name == myUsername then
            found = true
            local now_utc = os.time(os.date("!*t"))
            if users.expired == "never" then 
                enable = true
                api = tostring(data.api)
                reason = "License approved, welcome "..myUsername
                if not bool then
                    webhookAny("Username valid, Thanks for buying NEXORA Script!<:pepeheart:1368523385755144223>")
                    print(reason)
                end
                return true 
            else
                local year, month, day = users.expired:match("(%d+)%-(%d+)%-(%d+)")
                local epoch_utc = os.time({
                    year = tonumber(year),
                    month = tonumber(month),
                    day = tonumber(day),
                    hour = 0,
                    min = 0,
                    sec = 0
                }) 
                if epoch_utc < now_utc then 
                    enable = false
                    reason = "Expired script license"
                    print(reason)
                    webhookAny("It seem your license has been expired, script expired from: "..users.expired..", with user: "..myUsername)
                    return false
                else 
                    enable = true
                    api = tostring(data.api)
                    reason = "License approved, welcome "..myUsername
                    if not bool then 
                        webhookAny("Username valid, Thanks for buying NEXORA Script!<:pepeheart:1368523385755144223>")
                        print(reason)
                    end 
                    return true 
                end
            end 
        end
    end
    if not found then 
        enable = false
        reason = "Cannot find your username"
        print(reason)
        webhookAny(reason)
        return false
    end
end 
function cekModInput()
    local pair_mods = {
        MISHTHIOS = "JACKBOWE",
        JACKBOWE = "MISHTHIOS",
        KAILYX = "SOLABOWE",
        SOLABOWE = "KAILYX",
        PINUSKI = "CAITRIONA",
        CAITRIONA = "PINUSKI",
        MONIUET = "OILLA",
        OILLA = "MONIUET",
        WINDYPLAY = "IPLAYFULS",
        IPLAYFULS = "WINDYPLAY",
        ZOHROS = "STYX",
        STYX = "ZOHROS",
    }

    for _, mod in pairs(mods_list) do
        local mod_upper = mod:upper()
        local pasangannya = pair_mods[mod_upper]
        if pasangannya and not isIn(mods_list, pasangannya) then
            table.insert(mods_list, pasangannya)
        end
    end
end

function cekStop()
    if getBot(captain).custom_status == "stopped" then 
        getBot():stopScript()
    end 
end

function getModList()
    if getBot().index == captain then 
        local data = getHttp(api)
        if data then 
            player_count = data.playerData.online_user
            banrate = data.playerData.ban_rate
            image_url = data.image_url
            local tempmod = {}
            for _, datas in pairs(data.modData.mods) do 
                table.insert(tempmod, datas.name)
            end 
            mods_list = tempmod
        end
    end 
end 

function disconnectBot()
    getBot().auto_reconnect = false
    if getBot().status == 1 then 
        getBot():disconnect()
    end 
end
    
function reconnect() 
    if reconnect_after_rest then 
        if getBot().index == captain then 
            webhookRecon(getBot().name, lastrestid)
            getBot().custom_status = "Online"
            getBot().auto_reconnect = true
        else 
            sleep(500)
            if getBot(captain).custom_status == "Online" then 
                getBot().auto_reconnect = true
            end 
        end
    end 
end

function restManyMods()
    if auto_rest_many_mods then 
        if getBot().index == captain then 
            while #mods_list >= minimum_many_mods do
                webhookRest(getBot().name, 1)
                getBot().custom_status = "ManyMod"
                disconnectBot()
                sleep(delay_many_mods * 60 * 1000)
                getModList()
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
            end
        else 
            while isIn(captainStatus, getBot(captain).custom_status) and getBot(captain).custom_status ~= "Online" and getBot(captain):isRunningScript() do 
                disconnectBot()
                sleep(delay_many_mods * 60 * 1000)
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
            end
            cekStop()
            if getBot(captain).custom_status == "ManyMod" and not getBot(captain):isRunningScript() then 
                getBot().custom_status = "Getting new captain"
                sleep(1000)
                getCaptain()
            end
        end
    end
    return true
end 

function restSpecificMod()
    if auto_rest_specific_mod then 
        if getBot().index == captain then 
            local status, value = haveSame(specific_mod_list, mods_list)
            while status do 
                getBot(captain).custom_status = "SpecificMod"
                mod_detected = value
                webhookRest(getBot().name, 2)
                disconnectBot()
                sleep(delay_specific_mod * 60 * 1000)
                getModList()
                status, value = haveSame(specific_mod_list, mods_list)
            end 
        else 
            while isIn(captainStatus, getBot(captain).custom_status) and getBot(captain).custom_status ~= "Online" and getBot(captain):isRunningScript() do 
                disconnectBot()
                sleep(delay_specific_mod * 61 * 1000)
            end 
            cekStop()
            if getBot(captain).custom_status == "SpecificMod" and not getBot(captain):isRunningScript() then 
                getBot().custom_status = "Getting new captain"
                sleep(1000)
                getCaptain(true)
            end
        end
    end 
    return true
end 

function restPlayer() 
    if auto_rest_player then 
        if getBot().index == captain then 
            while player_count > maximum_player or player_count < minimum_player do 
                webhookRest(getBot().name, 5)
                last_player = player_count
                getBot().custom_status = "Player" 
                disconnectBot()
                sleep(delay_player * 60 * 1000)
                getModList()
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end 
            end
        else 
            while isIn(captainStatus, getBot(captain).custom_status) and getBot(captain).custom_status ~= "Online" and getBot(captain):isRunningScript() do 
                disconnectBot()
                sleep(delay_player* 60 * 1000)
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
            end
            cekStop()
            if getBot(captain).custom_status == "Player" and not getBot(captain):isRunningScript() then
                getBot().custom_status = "Getting new captain"
                
                sleep(1000)
                getCaptain()
            end
        end 
    end 
    return true
end 

function restBanrate()
    if auto_rest_banrate then 
        if getBot().index == captain then 
            while banrate >= minimum_banrate do
                webhookRest(getBot().name, 4)
                last_banrate = banrate
                getBot().custom_status = "Banrate" 
                disconnectBot()
                sleep(delay_specific_mod * 60 * 1000)
                getModList()
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end 
            end
        else 
            while isIn(captainStatus, getBot(captain).custom_status) and getBot(captain).custom_status ~= "Online" and getBot(captain):isRunningScript() do 
                disconnectBot()
                sleep(delay_specific_mod * 62 * 1000)
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
            end
            cekStop()
            if getBot(captain).custom_status == "Banrate" and not getBot(captain):isRunningScript() then 
                getBot().custom_status = "Getting new captain"
                sleep(1000)
                getCaptain()
            end
        end 
    end
    return true
end

-- Helper function: parse UTC offset
local function parse_utc_offset(zone)
    local sign = zone:sub(4,4)
    local hours = tonumber(zone:sub(5,6))
    return (sign == "-" and -hours) or hours
end

local function time_to_minutes(time_str)
    if not time_str then
        return nil
    end
    local hour, min = time_str:match("(%d+):(%d+)")
    if not hour or not min then
        error("Format waktu salah: " .. tostring(time_str))
    end
    return tonumber(hour) * 60 + tonumber(min)
end

-- Helper function: convert minutes to time string
local function minutes_to_time(minutes)
    minutes = (minutes + 1440) % 1440 -- biar tetap di 0-1439 menit
    local hour = math.floor(minutes / 60)
    local min = minutes % 60
    return string.format("%02d:%02d", hour, min)
end

-- Convert schedule ke UTC
local function convert_schedule_to_utc(schedule, zone)
    local offset = parse_utc_offset(zone)
    local utc_schedule = {}

    for _, period in ipairs(schedule) do
        local start_time, end_time = period:match("([^%-]+)%s*%-%s*([^%-]+)")
        local start_minutes = time_to_minutes(start_time)
        local end_minutes = time_to_minutes(end_time)
        end_schedule = end_time

        local start_utc = minutes_to_time(start_minutes - offset * 60)
        local end_utc = minutes_to_time(end_minutes - offset * 60)

        table.insert(utc_schedule, start_utc .. " - " .. end_utc)
    end

    return utc_schedule
end

-- Check apakah sekarang waktu rest
local function is_rest_now(utc_schedule)
    local now = os.date("!*t") -- waktu UTC
    local current_minutes = now.hour * 60 + now.min

    for _, period in ipairs(utc_schedule) do
        local start_time, end_time = period:match("([^%-]+)%s*%-%s*([^%-]+)")
        local start_minutes = time_to_minutes(start_time)
        local end_minutes = time_to_minutes(end_time)

        if start_minutes <= end_minutes then
            -- normal case
            if start_minutes <= current_minutes and current_minutes <= end_minutes then
                return true
            end
        else
            -- nyebrang hari
            if current_minutes >= start_minutes or current_minutes <= end_minutes then
                return true
            end
        end
    end
    return false
end

function restSchedule()
    if auto_rest_schedule then
        local utc_schedule = convert_schedule_to_utc(schedule_list, schedule_zone)
        
        -- Cek apakah sekarang waktu rest
        while is_rest_now(utc_schedule) do
            if getBot().index == captain then 
                webhookRest(getBot().name, 3)
                getBot(captain).custom_status = "Schedule"
            end
            disconnectBot()
            sleep(delay_schedule * 1000 * 60)
        end
    end
    return true
end

function restAll()
    if getBot().index == captain then 
        getModList()
        restManyMods()
        restSpecificMod()
        restPlayer()
        restBanrate()
        restSchedule()
    else
        sleep(1000)
        if first then 
            sleep(3000)
            first = false
        end 
        restManyMods()
        restSpecificMod()
        restPlayer()
        restBanrate()
        restSchedule()
        cekStop()
    end
    if restManyMods() and restSpecificMod() and restSchedule() and restBanrate() and restPlayer() then 
        reconnect()
    end
end

function sare(varlist, netid)
    sleep(check_delay * 60 * 1000)
    unlistenEvents()
end 

addEvent(Event.varianlist, sare)

local nuked, stuck = 0, false
function warp(world, id)
    world = world:upper()
    id = id or ''
    nuked = false
    stuck = false
    if not getBot():isInWorld(world) then
        getBot():leaveWorld()
        sleep(2000)
        while not getBot():isInWorld(world) do
            while getBot().status ~= BotStatus.online do
                getBot().auto_reconnect = true
                sleep(5000)
            end
            getBot():warp(world, id)
            sleep(delay_warp)
            nuked = nuked + 1
            if nuked == 5 then 
                return false
            end
        end
        removeEvent(Event.variantlist)
    end
    if getBot():isInWorld(world) and id ~= '' and getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 then
        local count = 0
        while getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 and not stuck do
            getBot():warp(world, id)
            sleep(delay_warp)
            count = count + 1
            if count == 3 then
                stuck = true
            end
        end
    end
    return true
end

local function generateWorld(length)
    local chars = "abcdefghijklmnopqrstuvwxyz"
    local result = ""
    for i = 1, length do
        local randIndex = math.random(#chars)
        result = result .. chars:sub(randIndex, randIndex)
    end
    return result
end

local function FirstWork()
    local tutorial = getBot().auto_tutorial
    tutorial.enabled = true
    tutorial.auto_quest = true
    tutorial.set_as_home = true
    tutorial.set_high_level = true
    tutorial.detect_tutorial = true
    tutorial.set_random_skin = false
    tutorial.set_random_profile = false

    while getBot().level < 6 do 
        sleep(2500)
    end


    local malady = getBot().auto_malady
    malady.enabled = true
    malady.auto_grumbleteeth = true
    malady.auto_refresh = true
    malady.auto_chicken_feet = true

    if auto_take_vial then 
        getBot().auto_malady.auto_vial = true
        getBot().auto_malady.storage = world_vial
    end

    local spam = getBot().auto_spam
    spam.random_interval = true
    spam.show_emote = false
    spam.randomizer = true
    spam.interval = 3.1
    spam.use_color = false

    local messages = spam.messages
    for _, msg in pairs(spam_messages) do
        messages:add(msg)
        sleep(50)
    end

end

FirstWork()
function takePickaxe()
    if getBot():getInventory():getItemCount(98) == 0 and auto_take_pickaxe then 
        getBot().wear_storage = world_pickaxe
        getBot().auto_wear = true 
        sleep(3000)
    end
end

malady_world_now = ""

function removeSickness()
    if getBot().malady == 1 or getBot().malady == 2 then 
        if turn_on_rotation then 
            getBot().rotation.enabled = false
        end
        math.randomseed(os.time())
        local randomStr = generateWorld(8)
        warp(randomStr, "")
        if malady_world_now == "" then 
            malady_world_now = randomStr
        end
        webhookMalady(getBot().name.." Got gems cut/torn punching, removing it now")
        while getBot().malady == 1 and getBot().malady == 2 do 
            restAll()
            listenEvents(1000)
            if getBot():getWorld().name ~= malady_world_now and getBot().status == 1 then 
                warp(malady_world_now, "")
            end 
        end
    end
    world_malady_now = ""
    return true
end

function turnOnRotation()
    if turn_on_rotation then 
        getBot().rotation.enabled = true
    end
end
 -- 1, 2 = torn, gems / sick
 -- 3, 4 = grumble, chicken / safe

function cekMalady() 
    removeSickness()
    math.randomseed(os.time())
    if getBot().malady ~= 4 or getBot().malady ~= 3 or getBot().malady == 0 then 
        if turn_on_rotation then 
            getBot().rotation.enabled = false 
        end
        webhookMalady("Bot trying to get grumbleteeth/chicken feet, bot: "..getBot().name..")
        local randomStr = generateWorld(8)
        warp(randomStr, "")
        malady_world_now = randomStr
        while getBot().malady ~= 4 and getBot().malady ~= 3 or getBot().malady == 0 do 
            restAll()
            listenEvents(100)
            if getBot():getWorld().name ~= malady_world_now and getBot().status == 1 then 
                warp(malady_world_now)
            end
        end
        webhookMalady("Bot finally got grumbleteeth/chicken feet, bot: "..getBot().name..", Continue working...")
    end
    turnOnRotation()
    malady_world_now = ""
    return true
end

function startThisSoGoodScriptAnjayy()
    if getBot().index == captain then 
        getBot().custom_status = "wait"
        sleep(2000)
        if not getUserData(false) then 
            getBot().custom_status = "invalid"
            sleep(2000)
            enable = false
            getBot():stopScript()
        end
    else 
        sleep(1000)
        while getBot(captain).custom_status == "wait" do 
            sleep(100)
        end 
        if getBot(captain).custom_status == "invalid" then 
            enable = false
            getBot():stopScript()
        end 
    end 
    
    if enable then 
        sleep(execute_delay * getBot().index)
        if auto_take_pickaxe then 
            takePickaxe()
        end
        while true do
            if custom_mode then 
                cekMalady()
                turnOnRotation()
            end
            restAll()
            print("cpu check: " ..get_cpu_usage())
            listenEvents(1000)
        end
    end
end

function wow()
    print("hi nigga")
end

getCaptain()
startThisSoGoodScriptAnjayy()

------------------------------
