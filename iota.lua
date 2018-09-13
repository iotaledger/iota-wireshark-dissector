-- IOTA transaction decoder for UDP/TCP
local debug_level = {
    DISABLED = 0,
    LEVEL_1  = 1,
    LEVEL_2  = 2
}

local DEBUG = debug_level.LEVEL_1

local default_settings =
{
    debug_level  = DEBUG,
    udp_port         = 14600,
    tcp_port         = 15600,
	testnet = true
}

local trytesTrits = {
    [0] = "9",	
    [1] = "A", 	
    [2] = "B",	
    [3] = "C",	
    [4] = "D",	
    [5] = "E",	
    [6] = "F",	
    [7] = "G",
    [8] = "H",	
    [9] = "I",	
    [10] = "J",	
    [11] = "K",	
    [12] = "L",	
    [13] = "M",	
    [-13] =	"N",	
    [-12] =	"O",	
    [-11] =	"P",	
    [-10] =	"Q",	
    [-9] = "R",	
    [-8] = "S",	
    [-7] = "T",	
    [-6] = "U",	
    [-5] = "V",	
    [-4] = "W",	
    [-3] = "X",	
    [-2] = "Y",	
    [-1] = "Z"	

}


local bytes2trits = {
{ 0, 0, 0, 0, 0 },
{ 1, 0, 0, 0, 0 },
{ -1, 1, 0, 0, 0 },
{ 0, 1, 0, 0, 0 },
{ 1, 1, 0, 0, 0 },
{ -1, -1, 1, 0, 0 },
{ 0, -1, 1, 0, 0 },
{ 1, -1, 1, 0, 0 },
{ -1, 0, 1, 0, 0 },
{ 0, 0, 1, 0, 0 },
{ 1, 0, 1, 0, 0 },
{ -1, 1, 1, 0, 0 },
{ 0, 1, 1, 0, 0 },
{ 1, 1, 1, 0, 0 },
{ -1, -1, -1, 1, 0 },
{ 0, -1, -1, 1, 0 },
{ 1, -1, -1, 1, 0 },
{ -1, 0, -1, 1, 0 },
{ 0, 0, -1, 1, 0 },
{ 1, 0, -1, 1, 0 },
{ -1, 1, -1, 1, 0 },
{ 0, 1, -1, 1, 0 },
{ 1, 1, -1, 1, 0 },
{ -1, -1, 0, 1, 0 },
{ 0, -1, 0, 1, 0 },
{ 1, -1, 0, 1, 0 },
{ -1, 0, 0, 1, 0 },
{ 0, 0, 0, 1, 0 },
{ 1, 0, 0, 1, 0 },
{ -1, 1, 0, 1, 0 },
{ 0, 1, 0, 1, 0 },
{ 1, 1, 0, 1, 0 },
{ -1, -1, 1, 1, 0 },
{ 0, -1, 1, 1, 0 },
{ 1, -1, 1, 1, 0 },
{ -1, 0, 1, 1, 0 },
{ 0, 0, 1, 1, 0 },
{ 1, 0, 1, 1, 0 },
{ -1, 1, 1, 1, 0 },
{ 0, 1, 1, 1, 0 },
{ 1, 1, 1, 1, 0 },
{ -1, -1, -1, -1, 1 },
{ 0, -1, -1, -1, 1 },
{ 1, -1, -1, -1, 1 },
{ -1, 0, -1, -1, 1 },
{ 0, 0, -1, -1, 1 },
{ 1, 0, -1, -1, 1 },
{ -1, 1, -1, -1, 1 },
{ 0, 1, -1, -1, 1 },
{ 1, 1, -1, -1, 1 },
{ -1, -1, 0, -1, 1 },
{ 0, -1, 0, -1, 1 },
{ 1, -1, 0, -1, 1 },
{ -1, 0, 0, -1, 1 },
{ 0, 0, 0, -1, 1 },
{ 1, 0, 0, -1, 1 },
{ -1, 1, 0, -1, 1 },
{ 0, 1, 0, -1, 1 },
{ 1, 1, 0, -1, 1 },
{ -1, -1, 1, -1, 1 },
{ 0, -1, 1, -1, 1 },
{ 1, -1, 1, -1, 1 },
{ -1, 0, 1, -1, 1 },
{ 0, 0, 1, -1, 1 },
{ 1, 0, 1, -1, 1 },
{ -1, 1, 1, -1, 1 },
{ 0, 1, 1, -1, 1 },
{ 1, 1, 1, -1, 1 },
{ -1, -1, -1, 0, 1 },
{ 0, -1, -1, 0, 1 },
{ 1, -1, -1, 0, 1 },
{ -1, 0, -1, 0, 1 },
{ 0, 0, -1, 0, 1 },
{ 1, 0, -1, 0, 1 },
{ -1, 1, -1, 0, 1 },
{ 0, 1, -1, 0, 1 },
{ 1, 1, -1, 0, 1 },
{ -1, -1, 0, 0, 1 },
{ 0, -1, 0, 0, 1 },
{ 1, -1, 0, 0, 1 },
{ -1, 0, 0, 0, 1 },
{ 0, 0, 0, 0, 1 },
{ 1, 0, 0, 0, 1 },
{ -1, 1, 0, 0, 1 },
{ 0, 1, 0, 0, 1 },
{ 1, 1, 0, 0, 1 },
{ -1, -1, 1, 0, 1 },
{ 0, -1, 1, 0, 1 },
{ 1, -1, 1, 0, 1 },
{ -1, 0, 1, 0, 1 },
{ 0, 0, 1, 0, 1 },
{ 1, 0, 1, 0, 1 },
{ -1, 1, 1, 0, 1 },
{ 0, 1, 1, 0, 1 },
{ 1, 1, 1, 0, 1 },
{ -1, -1, -1, 1, 1 },
{ 0, -1, -1, 1, 1 },
{ 1, -1, -1, 1, 1 },
{ -1, 0, -1, 1, 1 },
{ 0, 0, -1, 1, 1 },
{ 1, 0, -1, 1, 1 },
{ -1, 1, -1, 1, 1 },
{ 0, 1, -1, 1, 1 },
{ 1, 1, -1, 1, 1 },
{ -1, -1, 0, 1, 1 },
{ 0, -1, 0, 1, 1 },
{ 1, -1, 0, 1, 1 },
{ -1, 0, 0, 1, 1 },
{ 0, 0, 0, 1, 1 },
{ 1, 0, 0, 1, 1 },
{ -1, 1, 0, 1, 1 },
{ 0, 1, 0, 1, 1 },
{ 1, 1, 0, 1, 1 },
{ -1, -1, 1, 1, 1 },
{ 0, -1, 1, 1, 1 },
{ 1, -1, 1, 1, 1 },
{ -1, 0, 1, 1, 1 },
{ 0, 0, 1, 1, 1 },
{ 1, 0, 1, 1, 1 },
{ -1, 1, 1, 1, 1 },
{ 0, 1, 1, 1, 1 },
{ 1, 1, 1, 1, 1 },
{ },
{ },
{ },
{ },
{ },
{ },
{ },
{ },
{ },
{ },
{ },
{ },
{ },
{ -1, -1, -1, -1, -1 },
{ 0, -1, -1, -1, -1 },
{ 1, -1, -1, -1, -1 },
{ -1, 0, -1, -1, -1 },
{ 0, 0, -1, -1, -1 },
{ 1, 0, -1, -1, -1 },
{ -1, 1, -1, -1, -1 },
{ 0, 1, -1, -1, -1 },
{ 1, 1, -1, -1, -1 },
{ -1, -1, 0, -1, -1 },
{ 0, -1, 0, -1, -1 },
{ 1, -1, 0, -1, -1 },
{ -1, 0, 0, -1, -1 },
{ 0, 0, 0, -1, -1 },
{ 1, 0, 0, -1, -1 },
{ -1, 1, 0, -1, -1 },
{ 0, 1, 0, -1, -1 },
{ 1, 1, 0, -1, -1 },
{ -1, -1, 1, -1, -1 },
{ 0, -1, 1, -1, -1 },
{ 1, -1, 1, -1, -1 },
{ -1, 0, 1, -1, -1 },
{ 0, 0, 1, -1, -1 },
{ 1, 0, 1, -1, -1 },
{ -1, 1, 1, -1, -1 },
{ 0, 1, 1, -1, -1 },
{ 1, 1, 1, -1, -1 },
{ -1, -1, -1, 0, -1 },
{ 0, -1, -1, 0, -1 },
{ 1, -1, -1, 0, -1 },
{ -1, 0, -1, 0, -1 },
{ 0, 0, -1, 0, -1 },
{ 1, 0, -1, 0, -1 },
{ -1, 1, -1, 0, -1 },
{ 0, 1, -1, 0, -1 },
{ 1, 1, -1, 0, -1 },
{ -1, -1, 0, 0, -1 },
{ 0, -1, 0, 0, -1 },
{ 1, -1, 0, 0, -1 },
{ -1, 0, 0, 0, -1 },
{ 0, 0, 0, 0, -1 },
{ 1, 0, 0, 0, -1 },
{ -1, 1, 0, 0, -1 },
{ 0, 1, 0, 0, -1 },
{ 1, 1, 0, 0, -1 },
{ -1, -1, 1, 0, -1 },
{ 0, -1, 1, 0, -1 },
{ 1, -1, 1, 0, -1 },
{ -1, 0, 1, 0, -1 },
{ 0, 0, 1, 0, -1 },
{ 1, 0, 1, 0, -1 },
{ -1, 1, 1, 0, -1 },
{ 0, 1, 1, 0, -1 },
{ 1, 1, 1, 0, -1 },
{ -1, -1, -1, 1, -1 },
{ 0, -1, -1, 1, -1 },
{ 1, -1, -1, 1, -1 },
{ -1, 0, -1, 1, -1 },
{ 0, 0, -1, 1, -1 },
{ 1, 0, -1, 1, -1 },
{ -1, 1, -1, 1, -1 },
{ 0, 1, -1, 1, -1 },
{ 1, 1, -1, 1, -1 },
{ -1, -1, 0, 1, -1 },
{ 0, -1, 0, 1, -1 },
{ 1, -1, 0, 1, -1 },
{ -1, 0, 0, 1, -1 },
{ 0, 0, 0, 1, -1 },
{ 1, 0, 0, 1, -1 },
{ -1, 1, 0, 1, -1 },
{ 0, 1, 0, 1, -1 },
{ 1, 1, 0, 1, -1 },
{ -1, -1, 1, 1, -1 },
{ 0, -1, 1, 1, -1 },
{ 1, -1, 1, 1, -1 },
{ -1, 0, 1, 1, -1 },
{ 0, 0, 1, 1, -1 },
{ 1, 0, 1, 1, -1 },
{ -1, 1, 1, 1, -1 },
{ 0, 1, 1, 1, -1 },
{ 1, 1, 1, 1, -1 },
{ -1, -1, -1, -1, 0 },
{ 0, -1, -1, -1, 0 },
{ 1, -1, -1, -1, 0 },
{ -1, 0, -1, -1, 0 },
{ 0, 0, -1, -1, 0 },
{ 1, 0, -1, -1, 0 },
{ -1, 1, -1, -1, 0 },
{ 0, 1, -1, -1, 0 },
{ 1, 1, -1, -1, 0 },
{ -1, -1, 0, -1, 0 },
{ 0, -1, 0, -1, 0 },
{ 1, -1, 0, -1, 0 },
{ -1, 0, 0, -1, 0 },
{ 0, 0, 0, -1, 0 },
{ 1, 0, 0, -1, 0 },
{ -1, 1, 0, -1, 0 },
{ 0, 1, 0, -1, 0 },
{ 1, 1, 0, -1, 0 },
{ -1, -1, 1, -1, 0 },
{ 0, -1, 1, -1, 0 },
{ 1, -1, 1, -1, 0 },
{ -1, 0, 1, -1, 0 },
{ 0, 0, 1, -1, 0 },
{ 1, 0, 1, -1, 0 },
{ -1, 1, 1, -1, 0 },
{ 0, 1, 1, -1, 0 },
{ 1, 1, 1, -1, 0 },
{ -1, -1, -1, 0, 0 },
{ 0, -1, -1, 0, 0 },
{ 1, -1, -1, 0, 0 },
{ -1, 0, -1, 0, 0 },
{ 0, 0, -1, 0, 0 },
{ 1, 0, -1, 0, 0 },
{ -1, 1, -1, 0, 0 },
{ 0, 1, -1, 0, 0 },
{ 1, 1, -1, 0, 0 },
{ -1, -1, 0, 0, 0 },
{ 0, -1, 0, 0, 0 },
{ 1, -1, 0, 0, 0 },
{ -1, 0, 0, 0, 0 }
}



local args={...} -- get passed-in args
if args and #args > 0 then
    for _, arg in ipairs(args) do
        local name, value = arg:match("(.+)=(.+)")
        if name and value then
            if tonumber(value) then
                value = tonumber(value)
            elseif value == "true" or value == "TRUE" then
                value = true
            elseif value == "false" or value == "FALSE" then
                value = false
            elseif value == "DISABLED" then
                value = debug_level.DISABLED
            elseif value == "LEVEL_1" then
                value = debug_level.LEVEL_1
            elseif value == "LEVEL_2" then
                value = debug_level.LEVEL_2
            else
                error("invalid commandline argument value")
            end
        else
            error("invalid commandline argument syntax")
        end

        default_settings[name] = value
    end
end

local dprint = function() end
local dprint2 = function() end
local function reset_debug_level()
    if default_settings.debug_level > debug_level.DISABLED then
        dprint = function(...)
            print(table.concat({"Lua:", ...}," "))
        end

        if default_settings.debug_level > debug_level.LEVEL_1 then
            dprint2 = dprint
        end
    end
end
-- call it now
reset_debug_level()

dprint2("Wireshark version = ", get_version())
dprint2("Lua version = ", _VERSION)

----------------------------------------

local major, minor, micro = get_version():match("(%d+)%.(%d+)%.(%d+)")
if major and tonumber(major) <= 1 and ((tonumber(minor) <= 10) or (tonumber(minor) == 11 and tonumber(micro) < 3)) then
        error(  "Sorry, but your Wireshark/Tshark version ("..get_version()..") is too old for this script!\n"..
                "This script needs Wireshark/Tshark version 1.11.3 or higher.\n" )
end

-- more sanity checking
-- verify we have the ProtoExpert class in wireshark, as that's the newest thing this file uses
assert(ProtoExpert.new, "Wireshark does not have the ProtoExpert class, so it's too old - get the latest 1.11.3 or higher")

----------------------------------------


----------------------------------------
-- creates a Proto object, but doesn't register it yet
local iota = Proto("iota","IOTA Gossip Protocol")

local pf_signature          = ProtoField.new("Signature", "iota.sign", ftypes.STRING)
local pf_address            = ProtoField.new("Address", "iota.addr", ftypes.STRING)
local pf_value              = ProtoField.new("Value", "iota.value", ftypes.UINT32)    
local pf_cur_index          = ProtoField.new("CurrentIndex", "iota.curindex", ftypes.UINT32)    
local pf_last_index         = ProtoField.new("LastIndex", "iota.lastindex", ftypes.UINT32)
local pf_timestamp          = ProtoField.new("Timestamp", "iota.timestamp", ftypes.UINT32)    
local pf_bundle             = ProtoField.new("Bundle", "iota.bundle", ftypes.STRING)    
local pf_attach_timestamp   = ProtoField.new("AttachmentTimestamp", "iota.attach_ts", ftypes.UINT32)    
local pf_nonce              = ProtoField.new("Nonce", "iota.nonce", ftypes.STRING)    
local pf_trunk              = ProtoField.new("TrunkTransaction", "iota.trunk", ftypes.STRING)    
local pf_branch             = ProtoField.new("BranchTransaction", "iota.branch", ftypes.STRING)  
local pf_tag                = ProtoField.new("Tag", "iota.tag", ftypes.STRING)  
local pf_request_hash       = ProtoField.new("Requested Hash", "iota.reqhash", ftypes.STRING) 
----------------------------------------

iota.fields = { pf_signature, pf_address, pf_value, pf_cur_index, pf_last_index, pf_timestamp,
    pf_bundle, pf_attach_timestamp, pf_nonce, pf_trunk, pf_branch, pf_tag, pf_request_hash }



--------------------------------------------------------------------------------
-- preferences handling stuff
--------------------------------------------------------------------------------

-- a "enum" table for our enum pref, as required by Pref.enum()
-- having the "index" number makes ZERO sense, and is completely illogical
-- but it's what the code has expected it to be for a long time. Ugh.
local debug_pref_enum = {
    { 1,  "Disabled", debug_level.DISABLED },
    { 2,  "Level 1",  debug_level.LEVEL_1  },
    { 3,  "Level 2",  debug_level.LEVEL_2  },
}

iota.prefs.debug = Pref.enum("Debug", default_settings.debug_level,
                            "The debug printing level", debug_pref_enum)

iota.prefs.udp_port  = Pref.uint("UDP Port number", default_settings.udp_port,
                            "The UDP port number for IOTA")

iota.prefs.tcp_port  = Pref.uint("TCP Port number", default_settings.tcp_port,
"The TCP port number for IOTA")

----------------------------------------
-- a function for handling prefs being changed
function iota.prefs_changed()
    dprint2("prefs_changed called")

    default_settings.debug_level  = iota.prefs.debug
    reset_debug_level()

    if default_settings.udp_port ~= iota.prefs.udp_port then
        -- remove old one, if not 0
        if default_settings.udp_port ~= 0 then
            dprint2("removing IOTA UDP port",default_settings.udp_port)
            DissectorTable.get("udp.port"):remove(default_settings.udp_port, iota)
        end
        -- set our new default
        default_settings.udp_port = iota.prefs.udp_port
        -- add new one, if not 0
        if default_settings.udp_port ~= 0 then
            dprint2("adding IOTA to port",default_settings.udp_port)
            DissectorTable.get("udp.port"):add(default_settings.udp_port, iota)
        end
    end


    if default_settings.tcp_port ~= iota.prefs.tcp_port then
        -- remove old one, if not 0
        if default_settings.tcp_port ~= 0 then
            dprint2("removing IOTA TCP port",default_settings.tcp_port)
            DissectorTable.get("tcp.port"):remove(default_settings.tcp_port, iota)
        end
        -- set our new default
        default_settings.tcp_port = iota.prefs.tcp_port
        -- add new one, if not 0
        if default_settings.tcp_port ~= 0 then
            dprint2("adding IOTA to port",default_settings.tcp_port)
            DissectorTable.get("tcp.port"):add(default_settings.tcp_port, iota)
        end
    end	
	
end

dprint2("IOTA Prefs registered")


----------------------------------------
---- some constants for later use ----
local IOTA_SIG_LEN = 2187
local IOTA_PKT_LEN = 1653


function value(trits)
    returnValue = 0

    for i = #trits, 1, -1 do
        returnValue = returnValue * 3 + trits[i]
    end

    return returnValue
end


function iota.dissector(tvbuf,pktinfo,root)
    dprint2("iota.dissector called")

    -- set the protocol column to show our protocol name
    pktinfo.cols.protocol:set("IOTA")

    local pktlen = tvbuf:reported_length_remaining()


    -- now let's check it's not too short
    if pktlen < IOTA_PKT_LEN then
        dprint("packet length",pktlen,"too short")
        return
    end
	
	-- print("packet length",pktlen)
	buffer =  tvbuf:bytes(0,pktlen);
	
	trits = {}
    logs = "" 
	
	
	for i=1,pktlen,1 do
	    id = buffer:get_index(i-1)
		if id == nil then
		    logs = logs .. ";id is nill " .. id
			break 
		end
		if id > #bytes2trits then
		    logs = logs .. ";id is invalid " .. id
			break 
		end
		
		for j=1,5 do
			trits[#trits+1] = bytes2trits[id+1][j]
		end

    end

	pad = 3 - math.fmod(#trits,3)

	for i = 1,pad,1 do
		trits[#trits+1] = 0
	end

	trytes = {}
    tryteStr = ""
	
	for i = 1,#trits,3
	do 
	   x = trits[i] + 3*trits[i+1] + 9*trits[i+2]
	   trytes[#trytes+1] = trytesTrits[x]
	   tryteStr = tryteStr .. trytesTrits[x]
	end
	
	local tree = root:add(iota, tvbuf:range(0,pktlen))
	
    -- Now let's add our transaction id under our dns protocol tree we just created.
    -- The transaction id starts at offset 0, for 2 bytes length.
	
	amount = 
	
    tree:add(pf_signature, string.sub(tryteStr, 1,2187))	
    tree:add(pf_address, string.sub(tryteStr, 2188,2268))	
    tree:add(pf_value,   value({ unpack( trits, 6805, 6837 ) }))	
    tree:add(pf_cur_index,   value({ unpack( trits, 6994, 7020 ) }))	
    tree:add(pf_last_index,   value({ unpack( trits, 7021, 7047) }))	
    tree:add(pf_timestamp,   value({ unpack( trits, 6967, 6993) }))	
    tree:add(pf_bundle,   string.sub(tryteStr, 2350, 2430))		
    tree:add(pf_trunk,   string.sub(tryteStr, 2431, 2511))		
    tree:add(pf_branch,   string.sub(tryteStr, 2512, 2592))		
    tree:add(pf_attach_timestamp,   value({ unpack( trits, 7858, 7884) }))	
    tree:add(pf_nonce,   string.sub(tryteStr, 2647, 2673))		
    tree:add(pf_tag,   string.sub(tryteStr, 2593, 2619))		
    tree:add(pf_tag,   string.sub(tryteStr, 2593, 2619))		
    tree:add(pf_request_hash,   string.sub(tryteStr, 2674, #tryteStr))	 
 

    return pktlen
end

----------------------------------------
-- we want to have our protocol dissection invoked for a specific UDP port,
-- so get the udp dissector table and add our protocol to it
DissectorTable.get("udp.port"):add(default_settings.udp_port, iota)
DissectorTable.get("tcp.port"):add(default_settings.tcp_port, iota)

