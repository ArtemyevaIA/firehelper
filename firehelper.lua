script_name("firedep_zam_helper")
script_version("Ver.19.09.A2")

local download = getGameDirectory()..'\\moonloader\\config\\firedep_zam_helper.lua.ini'
local url = 'https://github.com/ArtemyevaIA/firedep_zam_helper/raw/refs/heads/main/firedep_zam_helper.lua.ini'

local mysql                         = require "luasql.mysql"
local env                           = assert(mysql.mysql())
local conn                          = assert(env:connect("arizona", "longames", "q2w3e4r5", "92.63.71.249", 3306))
assert(conn:execute("SET NAMES 'cp1251'"))

local ffi                           = require('ffi')
local ImGui                         = require 'imgui'
local sampev                        = require "lib.samp.events"
local requests                      = require 'requests'
local encoding                      = require 'encoding'
encoding.default                    = 'CP1251'
local u8                            = encoding.UTF8
local bit                           = require('bit')
local vkey                          = require'vkeys'
local effil_check, effil            = pcall(require, 'effil')
                                      ffi.cdef 'void __stdcall ExitProcess(unsigned int)'
                                      require "lfs"
                                      require "lib.moonloader"
local inicfg                        = require 'inicfg'
local font_flag                     = require('moonloader').font_flag
local my_font                       = renderCreateFont('Arial', 8.2, font_flag.BOLD + font_flag.SHADOW)
local mainIni                       = inicfg.load({orgs = {}})

local trstl = {['B'] = '�',['Z'] = '�',['T'] = '�',['Y'] = '�',['P'] = '�',['J'] = '��',['X'] = '��',['G'] = '�',['V'] = '�',['H'] = '�',['N'] = '�',['E'] = '�',['I'] = '�',['D'] = '�',['O'] = '�',['K'] = '�',['F'] = '�',['y`'] = '�',['e`'] = '�',['A'] = '�',['C'] = '�',['L'] = '�',['M'] = '�',['W'] = '�',['Q'] = '�',['U'] = '�',['R'] = '�',['S'] = '�',['zm'] = '���',['h'] = '�',['q'] = '�',['y'] = '�',['a'] = '�',['w'] = '�',['b'] = '�',['v'] = '�',['g'] = '�',['d'] = '�',['e'] = '�',['z'] = '�',['i'] = '�',['j'] = '�',['k'] = '�',['l'] = '�',['m'] = '�',['n'] = '�',['o'] = '�',['p'] = '�',['r'] = '�',['s'] = '�',['t'] = '�',['u'] = '�',['f'] = '�',['x'] = 'x',['c'] = '�',['``'] = '�',['`'] = '�',['_'] = ' '}
local trstl1 = {['ph'] = '�',['Ph'] = '�',['Ch'] = '�',['ch'] = '�',['Th'] = '�',['th'] = '�',['Sh'] = '�',['sh'] = '�', ['ea'] = '�',['Ae'] = '�',['ae'] = '�',['size'] = '����',['Jj'] = '��������',['Whi'] = '���',['whi'] = '���',['Ck'] = '�',['ck'] = '�',['Kh'] = '�',['kh'] = '�',['hn'] = '�',['Hen'] = '���',['Zh'] = '�',['zh'] = '�',['Yu'] = '�',['yu'] = '�',['Yo'] = '�',['yo'] = '�',['Cz'] = '�',['cz'] = '�', ['ia'] = '�', ['ea'] = '�',['Ya'] = '�', ['ya'] = '�', ['ove'] = '��',['ay'] = '��', ['rise'] = '����',['oo'] = '�', ['Oo'] = '�'}

local date = os.date('%d.%m.%Y')
local fd_helper, fd_find_fire, autoupdate_loaded, afk, start_sobes, enable_autoupdate, Update, sobes_start = false, false, false, false, false, true, nil, false
local sobes, next_fire, time_fire, time_end = ',05,�������� �����������', '�������� ����� ������', '00:00:00', '00:00:00'
local give, lvl, UTC = 0, 0, 0
local config = {}
local docs, inspect, img, inspect_1, inspect_2, inspect_3, inspect_4, inspect_5 = '','','','','', '', '', ''
local cnt_org, showorgs, showorg, isGoing = 0, true, true, true
local fm = false
local tlg_send = false
local flashminer = false
local fire_place = ''

local fires_list = {
                    {1642.4234, 2180.4091, 11.0258, 1},
                    {-871.1054, 1494.5131, 22.9384, 1},
                    {-2427.1535, 39.5095, 35.2162, 1},
                    {514.8258, -1411.5212, 16.1686, 1},
                    {1105.5765, 1884.7687, 11.0221, 2},
                    {370.7560, -1990.4370, 7.8739, 2},
                    {2316.7211, -1749.2310, 13.5672, 2},
                    {-100.9319, -55.0312, 3.1171, 2},
                    {89.8577, -262.6102, 1.7802, 3},
                    {2011.6634, -1954.3240, 13.7767, 3}
                }

local update_list = ('{FA8072}Ver.18.09.A5'..
                    '\n\t{00BFFF}1. {87CEFA}�������� ����� ��� ����� �������� ���.'..
                    '\n\t{00BFFF}2. {87CEFA}�������� ������ � �� ����������� � ����������� ��������� �� �����.'..
                    '\n\t{00BFFF}3. {87CEFA}��������������� ��������� �������� ����� ��� ��������� ������� �������.'..
                    '\n\t{00BFFF}4. {87CEFA}��������� ������� {FFD700}/ftime {87CEFA}��� ��������� ������� ����������� ������.'..
                    '\n\t{00BFFF}5. {87CEFA}��� ��������� � {32CD32}/r {87CEFA}��� {32CD32}/rb {87CEFA}����� ����� {87CEFA}��� next{87CEFA}, �� ��������� ���� ����� ��. ������.'..
                    '\n\t{00BFFF}6. {87CEFA}���������� �� ��������� �� ������� ���.'..
                    '\n\t{00BFFF}7. {87CEFA}���������� ������, ��-�� ������� �������� ��� ����� � ����� AFK �� �������� ����� ��������� � �����.'..
                    '\n\t{00BFFF}8. {87CEFA}��������� ������� ����������� ������ ����������� ������, � ��� �� ������������ ����� � ����.'..
                    '\n\t{00BFFF}9. {87CEFA}��������� ����������� ������ ������������ ������ +10% ����� ��������� ����.'..
                    '\n\t{00BFFF}10. {87CEFA}��������� ������� {FFD700}/stime {87CEFA}��� ������ �������� �����.'..
                    '\n\t{00BFFF}11. {87CEFA}��������� ������� {FFD700}/afk {87CEFA}��� ������������� ����� � ����� AFK.'..
                    '\n\t{00BFFF}12. {87CEFA}���������� ���������� ������ � ���������� ��� ��������� �������.'..
                    '\n\t{00BFFF}13. {87CEFA}���������� ������ ������� ��������������.'..
                    '\n\t{00BFFF}1. {FFD700}/ftime {87CEFA}������ ���������� ����� ���������� ��������� � ����� �� ��������� �����.'..
                    '\n\t{00BFFF}2. {87CEFA}� ��������� ���� ��������� ����������� ���������� �� �������.'..
                    '\n\t{00BFFF}3. {87CEFA}��������� ������� {FFD700}/fclean {87CEFA}��� ��������� ���������� �� �������.'..
                    '\n\t{00BFFF}4. {87CEFA}��������� ��������� ������� ����������� ���������� � ���������� PAYDAY � ��������.'..
                    '\n\t{00BFFF}5. {87CEFA}���� � ��� ���� ������ ����� � ������ �������, �� �� ������� {FFD700}/fmn {87CEFA}�� ������� ������� ����� ��� �����.'..
                    '\n{7CFC00}'..thisScript().version..
                    '\n\t{00BFFF}1. {87CEFA}��������� ������ ���������� �� ������.'..
                    '\n\t{00BFFF}2. {87CEFA}��������� ���� ������ �������� ������� �� �������� �� �����.'..
                    '\n\n{FFD700}� ����������� ���������� ����������:'..
                    '\n\t{00BFFF}1. {87CEFA}������� �������������� ����� �������, ���� ��� ����������.'..
                    '\n\t{00BFFF}2. {87CEFA}������� ������� ���������� � �� � ������� ������� (������).')

local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=0x40E0D0;
                                                        sampAddChatMessage(b..'���������� ����������. {FA8072}'..thisScript().version..' {40E0D0}�� {7CFC00}'..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then 
                                                        sampShowDialog(0, "{FFA500}����� ����������", "{FFA500}�������� ������������ ��������� ������������\n{78dbe2}��� ������������� �������� �� ����� ������.\n���������� ��������� ����� � ���� -> ��������� ������� -> ���������", "�������", "", DIALOG_STYLE_MSGBOX)
                                                        print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end

    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/ArtemyevaIA/firedep_zam_helper/refs/heads/main/firedep_zam_helper.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/ArtemyevaIA/firedep_zam_helper"
        end
    end
    
    local spisok_org=io.open(download,"r")
    if spisok_org~=nil then
        io.close(spisok_org)
    else 
        sampAddChatMessage('������ ����������� �� ������. ������ ���������.', -255)
        downloadUrlToFile(url, download)
        wait(3000)
        sampShowDialog(0, "{FFA500}������ ����������� ��", "{78dbe2}������ ���������� �� ��� ������ � ����� � ����� �����. � ������ ��� �������������.\n����������� � ����, ��� ���������� ���������.", "���������", "", DIALOG_STYLE_MSGBOX)
        while sampIsDialogActive(0) do wait(100) end
        local result, button, _, input = sampHasDialogRespond(0)
        if button == 1 then
            sampProcessChatInput('/q', -1)
        end
    end

    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

    while not isSampAvailable() do wait(0) end
    
    UTC = getpoyas() - 3

    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)
    nick_rus = trst(nick)
    nick_fire = nick_rus:match('(.)')..'.'..string.gsub(nick_rus, "(.+)(%s)", "")
    
    _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    who_nick = sampGetPlayerNickname(who_id)
    autor = nick:match('(.)')..'.'..string.gsub(nick, "(.+)_", "")

    local check_client = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM clients WHERE nick = '"..who_nick.."'"))
    local cnt_client = check_client:fetch({}, "a")
    if cnt_client['cnt'] == '0' then
        sampAddChatMessage('������ �� ��� ������ � ���� ������. ������: {ffbf00}'..who_nick, -1)
        assert(conn:execute("INSERT INTO clients (nick, tlg_id) VALUES ('"..who_nick.."', '0')"))
        assert(conn:execute("INSERT INTO firehelp (nick, give, stats) VALUES ('"..who_nick.."', '0','0')"))
    else
        local client = assert(conn:execute("select c.nick, c.tlg_id, f.give, f.stats from clients c join firehelp f on c.nick = f.nick WHERE c.nick = '"..who_nick.."'"))
        local row = client:fetch({}, "a")
        tlg_id = row['tlg_id']
        give = row['give']
        stats = row['stats']
        if tlg_id ~= '0' then tlg_send = true end
    end


    sampAddChatMessage('', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}�������� ������������ ��������� ������������ ��������', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}������ ���������: {7CFC00}'..thisScript().version..' {7FFFD4}������� ����: {FFFFFF}+'..UTC..' {FFFFFF}���', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}������� ��� �������� ���� {ffa000}/zam {7FFFD4}��� ������� {ffa000}Scroll Lock', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}�����������: {ffa000}Irin_Crown (������ ��������)', 0x7FFFD4)
    sampAddChatMessage('', 0x7FFFD4)
    
    sampRegisterChatCommand('zam', zammenu)
    sampRegisterChatCommand('upd', upd)
    sampRegisterChatCommand('stime', stime)
    sampRegisterChatCommand('ftime', function() 
        sampAddChatMessage('', 0x7FFFD4) 
        sampAddChatMessage('{7FFFD4}��������� ����� �: {FFFFFF}'..next_fire, 0x7FFFD4)
        sampAddChatMessage('', 0x7FFFD4) 
    end)
    sampRegisterChatCommand('fclean', function()
        sampAddChatMessage('{E9967A}���������� ��������� ���� �������.', 0xE9967A) 
        give = 0
        stats = 0
        assert(conn:execute("UPDATE firehelp SET give = 0, stats = 0 WHERE nick = '"..who_nick.."'"))
        assert(conn:execute("UPDATE firehelp_history SET active = 0 WHERE nick = '"..who_nick.."'"))
    end)

    sampRegisterChatCommand('afk', function()
        afk = true
        sampSetGamestate(GAMESTATE_DISCONNECTED)
        sampDisconnectWithReason(0)
        sampAddChatMessage('', 0x90EE90)
        sampAddChatMessage('{90EE90}�������� ���� � ����� ���. ���� ������ ���������.', 0x90EE90)
        sampAddChatMessage('{90EE90}�� 5 ����� �� ��������� �������� ��� ����� ��������� ������� /rec.', 0x90EE90)
        sampAddChatMessage('{90EE90}����� �������� ������������� ������ ��������� � ������� � ���� �������.', 0x90EE90)
        sampAddChatMessage('', 0x90EE90)
        sampAddChatMessage('{90EE90}������� {FFFFFF}19:55:00 {90EE90}��� ������ �� ������.', 0x90EE90)
        sampAddChatMessage('', 0x90EE90)
    end)

    sampRegisterChatCommand("co", co)
    sampRegisterChatCommand("new", neworg)
    sampRegisterChatCommand("del", delorg)
    sampRegisterChatCommand("cho", switchMod)
    sampRegisterChatCommand("coc", coc)
    sampRegisterChatCommand("fmn", flashmine)
    sampRegisterChatCommand("1", function() lvl = 1 local x,y,z = getCharCoordinates(PLAYER_PED) assert(conn:execute("INSERT INTO temp (lvl, x, y, z) VALUES ('1', '"..x.."','"..y.."','"..z.."')")) end)
    sampRegisterChatCommand("2", function() lvl = 2 local x,y,z = getCharCoordinates(PLAYER_PED) assert(conn:execute("INSERT INTO temp (lvl, x, y, z) VALUES ('2', '"..x.."','"..y.."','"..z.."')")) end)
    sampRegisterChatCommand("3", function() lvl = 3 local x,y,z = getCharCoordinates(PLAYER_PED) assert(conn:execute("INSERT INTO temp (lvl, x, y, z) VALUES ('3', '"..x.."','"..y.."','"..z.."')")) end)
    sampRegisterChatCommand("tt", function()
        -- date = os.date('%Y-%m-%d')
        -- assert(conn:execute("INSERT INTO firehelp_history (date, active) VALUES ('"..date.."', '1')"))
    end)

    sampRegisterChatCommand("fcor", function() 
        local x,y,z = getCharCoordinates(PLAYER_PED)
        count = 0
        for _ in pairs(fires_list) do 
            count = count + 1
            dist = getDistanceBetweenCoords3d(x, y, z, fires_list[count][1], fires_list[count][2], fires_list[count][3])
            if dist <= 100 then
                sampAddChatMessage("�� ���������� � ���� ������ "..fires_list[count][4].. " ������� ���������", -255)
            end
        end
    end)
            
    while true do wait(0)

        if showorgs then
            local resX, resY = getScreenResolution()
            local ADM_POS_X = resX-(resX/27*3)
            local ADM_POS_Y = resY/4
            local ADM_POS_XX = resX-(resX/27*5)
            local ADM_POS_YY = resY/4
            local PLY_POS_Y = resY/3
            local PLY_POS_X = resX/27

            local tbl_org = {}
            local y_org, n_org = 0, 0

            for id_org = 0, sampGetMaxPlayerId() do
                if sampIsPlayerConnected(id_org) then
                    local name_org, id_org = sampGetPlayerNickname(id_org)
                    if findInIni(name_org) then 
                        table.insert(tbl_org,name_org)
                    end
                end
            end

            renderFontDrawText(my_font, "{f87858}����� ����������� ������:", ADM_POS_X, ADM_POS_Y, -255)

            for cnt_org, v_org in pairs(tbl_org) do
                id_org = sampGetPlayerIdByNickname(v_org)
                color = sampGetPlayerColor(id_org)

                if showorg then
                    for _, a in pairs(getAllChars()) do
                        local result_org, uid_org = sampGetPlayerIdByCharHandle(a)
                        if result_org and id_org == uid_org then
                            y_org = y_org+1
                            renderFontDrawText(my_font, "{f87858}����� ����������� �����:", ADM_POS_XX, ADM_POS_YY, -255)
                            
                            if color == 2164212992 then
                                renderFontDrawText(my_font, cnt_org..". {33ee66}"..v_org.." {ffffff}["..id_org.."]", ADM_POS_XX+n_org*150, ADM_POS_YY+y_org*13, ((findInIni(v_org[1]) and -255) or -255))
                            else
                                renderFontDrawText(my_font, cnt_org..". {f87858}"..v_org.." {ffffff}["..id_org.."]", ADM_POS_XX+n_org*150, ADM_POS_YY+y_org*13, ((findInIni(v_org[1]) and -255) or -255))
                            end
                        end
                    end
                end

                if color == 2164212992 then
                    renderFontDrawText(my_font, cnt_org..". {33ee66}"..v_org.." {ffffff}["..id_org.."]", ADM_POS_X, ADM_POS_Y+cnt_org*13, -255)
                else
                    renderFontDrawText(my_font, cnt_org..". {f87858}"..v_org.." {ffffff}["..id_org.."]", ADM_POS_X, ADM_POS_Y+cnt_org*13, -255)
                end
            end
        end

        if afk and os.date('%H:%M:%S', os.time() - (UTC * 3600)) == "19:55:00" then
            sampAddChatMessage("{90EE90}����� �������� �� ������ ���",-1)
            wait(2000)
            sampProcessChatInput('/rec',-1)
        end

        if isKeyJustPressed(vkey.VK_SCROLL) then
           zammenu()
        end
        
        local result, button, list, input = sampHasDialogRespond(1999)
        if result then 

            -----------------------------------------------------------------------------------
            -- ������ � �������� --------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 0 then

                sostav()
                while sampIsDialogActive(2000) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(2000)
                
                -----------------------------------------------------------------------------------
                -- ������� � ����������� ----------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 0 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then

                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        invitereason()
                        while sampIsDialogActive(2002) do wait(100) end
                        local result, button, list, input = sampHasDialogRespond(2002)
                        
                        -----------------------------------------------------------------------------------
                        -- [1] ���������� �� ������������� ------------------------------------------------
                        -----------------------------------------------------------------------------------
                        if button == 1 and list == 0 then
                            sampProcessChatInput('/do ����� � ������ �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ������� ����� �� ��� � ���������',-1)
                            wait(1000)
                            sampProcessChatInput('/do ����� � �������� ���� ����� �� ����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ����� � ������� �������� ��������',-1)
                            wait(1000)
                            sampProcessChatInput('/invite '..id,-1)
                            wait(1000)
                            sampProcessChatInput('/time ',-1)
                            wait(1000)

                            waitrp(id, nick)
                            while sampIsDialogActive(2004) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2004)
                            if button == 1 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/fractionrp '..id,-1)
                                wait(2000)
                                sampProcessChatInput('/r ������������ ������ ���������� ��������� ������������ - '..nm..'.',-1)
                                wait(2000)
                                sampProcessChatInput('/new '..id,-1)
                                sampProcessChatInput('/time ',-1)
                                sampShowDialog(0, "{FFA500}����� ���� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."] {78dbe2}(�� �������������)\n\n���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."{78dbe2}", "���-��", "�������", DIALOG_STYLE_MSGBOX)

                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/��������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (invite)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end
                                                                
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[�������� � ����������� �� �������������]. ���������: '..nick.. ' ['..id..'] ���� ��������: '..date..' ����� ��������: '..time..'\n') --����� ������ ����� ���������� ����
                                file:close()


                                info = ('�������� � ����������� �� �������������. \n\n���������: '..nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239037'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end

                        -----------------------------------------------------------------------------------
                        -- [4] ���������� �� ��������� �� -------------------------------------------------
                        -----------------------------------------------------------------------------------
                        if button == 1 and list == 1 then
                            inputurl()
                            while sampIsDialogActive(2003) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2003)

                            if button == 1 then
                                url = input
                                sampProcessChatInput('/do ����� � ������ �� �����.',-1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ����� �� ��� � ���������',-1)
                                wait(1000)
                                sampProcessChatInput('/do ����� � �������� ���� ����� �� ����.',-1)
                                wait(1000)
                                sampProcessChatInput('/me ���� ����� � ������� �������� ��������',-1)
                                wait(1000)
                                sampProcessChatInput('/invite '..id,-1)
                                wait(1000)
                                sampProcessChatInput('/time ',-1)
                                wait(2000)
                                waitrp(id, nick)
                                while sampIsDialogActive(2004) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2004)
                                if button == 1 then
                                    local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                    local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))
                                    sampProcessChatInput('/fractionrp '..id,-1)
                                    wait(2000)
                                    sampProcessChatInput('/r ������������ ������ ���������� ��������� ������������ - '..nm..'.',-1)
                                    sampProcessChatInput('/new '..id,-1)
                                    wait(2000)
                                    sampProcessChatInput('/time ',-1)
                                    wait(2000)
                                    sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                    wait(1000)
                                    sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                    wait(1000)
                                    sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                    wait(1000)
                                    sampProcessChatInput('/giverank '..id..' 4', -1)
                                    wait(1000)
                                    sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - ��������.', -1)
                                    wait(2000)
                                    sampProcessChatInput('/time', -1)
                                    wait(2000)
                                    sampShowDialog(0, "{FFA500}����� ���� ����������� �� ���������.", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n{78dbe2}����� ���������: {ffa000}[4] ��������\n\n{78dbe2}���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."\n\n{78dbe2}������ �� ������: {ffa000}"..url, "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                    
                                    lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/��������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (invite 4)')

                                    while sampIsDialogActive(0) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(0)
                                    if button == 1 then
                                        inputdocs()
                                        while sampIsDialogActive(2021) do wait(100) end
                                        local result, button, _, input = sampHasDialogRespond(2021)

                                        if button == 1 then
                                            docsi = input
                                            docs = ('\n���-��: '..docsi)
                                        end
                                    end
                                                                        
                                    file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                    file:write('[�������� � ����������� �� ������]. ���������: '..nick.. ' ['..id..'] ����� ���������: [4] �������� ���� ��������: '..date..' ����� ��������: '..time..' ������ �� ������: '..url..'\n') --����� ������ ����� ���������� ����
                                    file:close()

                                    info = ('�������� � ����������� �� �������������. \n\n���������: '..nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n������: '..autor..' ['..who_id..']'..docs)
                                    docs = ''
                                    
                                    img = 'photo-232454643_456239037'
                                    sendvkimg(encodeUrl(info),img)
                                    
                                end
                            end
                        end

                        -----------------------------------------------------------------------------------
                        -- [4] �� ������������� ������ ����������� ----------------------------------------
                        -----------------------------------------------------------------------------------
                        if button == 1 and list == 3 then
                            inputidorg()
                            while sampIsDialogActive(2016) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2016)
                            if button == 1 then
                                local idorg = input
                                local nick_org = sampGetPlayerNickname(idorg)

                                sampProcessChatInput('/do ����� � ������ �� �����.',-1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ����� �� ��� � ���������',-1)
                                wait(1000)
                                sampProcessChatInput('/do ����� � �������� ���� ����� �� ����.',-1)
                                wait(1000)
                                sampProcessChatInput('/me ���� ����� � ������� �������� ��������',-1)
                                wait(1000)
                                sampProcessChatInput('/invite '..id,-1)
                                wait(1000)
                                sampProcessChatInput('/time ',-1)
                                wait(1000)

                                waitrp(id, nick)
                                while sampIsDialogActive(2004) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2004)
                                if button == 1 then
                                    local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                    local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                    sampProcessChatInput('/r ������������ ������ ���������� ��������� ������������ - '..nm..'.',-1)
                                    sampProcessChatInput('/new '..id,-1)
                                    wait(2000)
                                    sampProcessChatInput('/time ',-1)
                                    sampShowDialog(0, "{FFA500}����� ���� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."] {78dbe2}(�� �������������)\n{78dbe2}�������� �������������: {ffa000}"..nick_org.." ["..idorg.."]\n\n{78dbe2}���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."{78dbe2}", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                    
                                    lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/��������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (invite)')

                                    while sampIsDialogActive(0) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(0)
                                    if button == 1 then
                                        inputdocs()
                                        while sampIsDialogActive(2021) do wait(100) end
                                        local result, button, _, input = sampHasDialogRespond(2021)

                                        if button == 1 then
                                            docsi = input
                                            docs = ('\n���-��: '..docsi)
                                        end
                                    end
                                                                        
                                    file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                    file:write('[�������� � ����������� �� �������������]. ���������: '..nick.. ' ['..id..'] ������: '..nick_org..' ['..idorg..'] ���� ��������: '..date..' ����� ��������: '..time..'\n') --����� ������ ����� ���������� ����
                                    file:close()

                                    info = ('�������� � ����������� �� �������������. \n\n���������: '..nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n�������� �������������: '..nick_org..' ['..idorg..']\n������: '..autor..' ['..who_id..']'..docs)
                                    docs = ''

                                    img = 'photo-232454643_456239037'                                    
                                    sendvkimg(encodeUrl(info),img)
                                end
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- �������� ���������� ------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 1 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        inputurl()
                        while sampIsDialogActive(2003) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2003)

                        if button == 1 then
                            local url = input

                            ranklist()
                            while sampIsDialogActive(2007) do wait(100) end
                            local result, button, list, input = sampHasDialogRespond(2007)
                            local rank = {"������", "������� ������", "������� ��������", "��������", "������� ��������", "�������� ���������", "���������", "�������"}
                            
                            -----------------------------------------------------------------------------------
                            -- [1] ������ ---------------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 0 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}������ �� �����: {ffa000}"..url, "�������", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' ������ �� �����: '..url..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� � ���������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n����� ���������: ['..(list+1)..'] '..rank[list+1]..' \n������ �� �����: '..url..'\n�������: '..autor..' ['..who_id..']')
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [2] ������� ������ -------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 1 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}������ �� �����: {ffa000}"..url, "�������", "", DIALOG_STYLE_MSGBOX)
                                
                                                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' ������ �� �����: '..url..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� � ���������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n����� ���������: ['..(list+1)..'] '..rank[list+1]..' \n������ �� �����: '..url..'\n�������: '..autor..' ['..who_id..']')
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [3] ������� �������� -----------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 2 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}������ �� �����: {ffa000}"..url, "�������", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' ������ �� �����: '..url..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� � ���������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n����� ���������: ['..(list+1)..'] '..rank[list+1]..' \n������ �� �����: '..url..'\n�������: '..autor..' ['..who_id..']')
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [4] �������� -------------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 3 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}������ �� �����: {ffa000}"..url, "�������", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' ������ �� �����: '..url..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� � ���������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n����� ���������: ['..(list+1)..'] '..rank[list+1]..' \n������ �� �����: '..url..'\n�������: '..autor..' ['..who_id..']')
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [5] ������� �������� -----------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 4 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}������ �� �����: {ffa000}"..url, "�������", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' ������ �� �����: '..url..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� � ���������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n����� ���������: ['..(list+1)..'] '..rank[list+1]..' \n������ �� �����: '..url..'\n�������: '..autor..' ['..who_id..']')
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [6] �������� ���������� --------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 5 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}������ �� �����: {ffa000}"..url, "�������", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' ������ �� �����: '..url..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� � ���������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n����� ���������: ['..(list+1)..'] '..rank[list+1]..' \n������ �� �����: '..url..'\n�������: '..autor..' ['..who_id..']')
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [7] ��������� ------------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 6 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}������ �� �����: {ffa000}"..url, "�������", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' ������ �� �����: '..url..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� � ���������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n����� ���������: ['..(list+1)..'] '..rank[list+1]..' \n������ �� �����: '..url..'\n�������: '..autor..' ['..who_id..']')
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [8] ������� --------------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 7 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}������ �� �����: {ffa000}"..url, "�������", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' ������ �� �����: '..url..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� � ���������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n����� ���������: ['..(list+1)..'] '..rank[list+1]..' \n������ �� �����: '..url..'\n�������: '..autor..' ['..who_id..']')
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ����� ������� ------------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 2 then
                    inputid()
                    while sampIsDialogActive(2000) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2000)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ��� ����� �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ��� � ����� � ������� ���',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �������.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� � ���� ������ �����������',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� ������� ���������� � ������� ������ ����',-1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/unfwarn '..id,-1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ��� � ������� �� ����',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� ����� �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/r ���������� '..nm..' ���� ����� �������������� ���������. ������� - '..reason,-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            sampShowDialog(0, "{FFA500}����� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ������ ��������: {ffa000}"..date.."\n{78dbe2}����� ������ ��������: {ffa000}"..time.."\n\n{78dbe2}������� ������ ��������: {ffa000}"..reason, "�������", "", DIALOG_STYLE_MSGBOX)
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/������ ���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (unfwarn)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                            
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[������ ��������]. ���������: '..nick.. ' ['..id..'] ���� ������: '..date..' ����� ������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('������ ��������. \n\n���������: '..nick.. ' ['..id..'] \n���� ������: '..date..' \n����� ������: '..time..' \n�������: '..reason..'\n����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239041'
                            sendvkimg(encodeUrl(info),img)
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������ ������� -----------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 3 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then 
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        reason_fwarn()
                        while sampIsDialogActive(2013) do wait(100) end
                        local result, button, list, input = sampHasDialogRespond(2013)
                        if button == 1 and list == 0 then                                                               -- ��������� ������                    
                            local reason = "�.�."
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ��� ����� �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ��� � ����� � ������� ���',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �������.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� � ���� ������ �����������',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� ������� ���������� � ������� ������ ����',-1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ��� � ������� �� ����',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �����.',-1)
                            wait(2000)
                            sampProcessChatInput('/r ��������� '..nm..' ������� �������������� ��������� �� ������� - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            sampShowDialog(0, "{FFA500}������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."\n\n{78dbe2}������� ��������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end

                                                        
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[������ ��������]. ���������: '..nick.. ' ['..id..'] ���� ��������: '..date..' ����� ��������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()
                            
                            info = ('������ ��������. \n\n���������: '..nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                        end

                        if button == 1 and list == 1 then                                                               -- ������ �������� ���
                            local reason = "������ ��"
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ��� ����� �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ��� � ����� � ������� ���',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �������.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� � ���� ������ �����������',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� ������� ���������� � ������� ������ ����',-1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ��� � ������� �� ����',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �����.',-1)
                            wait(2000)
                            sampProcessChatInput('/r ��������� '..nm..' ������� �������������� ��������� �� ������� - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            sampShowDialog(0, "{FFA500}������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."\n\n{78dbe2}������� ��������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                                                        
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[������ ��������]. ���������: '..nick.. ' ['..id..'] ���� ��������: '..date..' ����� ��������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('������ ��������. \n\n���������: '..nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 2 then                                                               -- ��� �� �����
                            local reason = "��� �� �����"
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ��� ����� �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ��� � ����� � ������� ���',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �������.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� � ���� ������ �����������',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� ������� ���������� � ������� ������ ����',-1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ��� � ������� �� ����',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �����.',-1)
                            wait(2000)
                            sampProcessChatInput('/r ��������� '..nm..' ������� �������������� ��������� �� ������� - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)

                            sampShowDialog(0, "{FFA500}������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."\n\n{78dbe2}������� ��������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                                                        
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[������ ��������]. ���������: '..nick.. ' ['..id..'] ���� ��������: '..date..' ����� ��������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('������ ��������. \n\n���������: '..nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 3 then                                                               -- ���������� ����������
                            local reason = "�������"
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ��� ����� �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ��� � ����� � ������� ���',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �������.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� � ���� ������ �����������',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� ������� ���������� � ������� ������ ����',-1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ��� � ������� �� ����',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �����.',-1)
                            wait(2000)
                            sampProcessChatInput('/r ��������� '..nm..' ������� �������������� ��������� �� ������� - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            sampShowDialog(0, "{FFA500}������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."\n\n{78dbe2}������� ��������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end

                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[������ ��������]. ���������: '..nick.. ' ['..id..'] ���� ��������: '..date..' ����� ��������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('������ ��������. \n\n���������: '..nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 5 then

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)
                            if button == 1 then
                                local reason = input
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do ��� ����� �� �����.',-1)
                                wait(1000)
                                sampProcessChatInput('/me ���� ��� � ����� � ������� ���',-1)
                                wait(1000)
                                sampProcessChatInput('/do ��� �������.',-1)
                                wait(1000)
                                sampProcessChatInput('/me ����� � ���� ������ �����������',-1)
                                wait(1000)
                                sampProcessChatInput('/me ����� ������� ���������� � ������� ������ ����',-1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                                wait(1000)
                                sampProcessChatInput('/me �������� ��� � ������� �� ����',-1)
                                wait(1000)
                                sampProcessChatInput('/do ��� �����.',-1)
                                wait(2000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� �������������� ��������� �� ������� - '..reason..'.',-1)
                                wait(2000)
                                sampProcessChatInput('/time ',-1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."\n\n{78dbe2}������� ��������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end
                                                                
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[������ ��������]. ���������: '..nick.. ' ['..id..'] ���� ��������: '..date..' ����� ��������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('������ ��������. \n\n���������: '..nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239035'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������ ������� (������) --------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 4 then
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)
                    
                    if button == 1 then
                    
                        local nick = input
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ��� ����� �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ��� � ����� � ������� ���',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �������.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� � ���� ������ �����������',-1)
                            wait(1000)
                            sampProcessChatInput('/me ����� ������� ���������� � ������� ������ ����',-1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/fwarnoff '..nick..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ��� � ������� �� ����',-1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �����.',-1)
                            wait(2000)
                            sampProcessChatInput('/r ��������� '..nm..' ������� �������������� ��������� �� ������� - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." (������)\n\n{78dbe2}���� ��������: {ffa000}"..date.."\n{78dbe2}����� ��������: {ffa000}"..time.."\n\n{78dbe2}������� ��������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarnoff)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                            
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[������ �������� ������]. ���������: '..nick.. ' (������) ���� ��������: '..date..' ����� ��������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('������ �������� ������. \n\n���������: '..nick.. ' (������) \n���� ��������: '..date..' \n����� ��������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������� �� ���������� ----------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 5 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ��� ����� �� �����.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ��� � ����� � ������� ���', -1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �������.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ����� � ���� ������ �����������', -1)
                            wait(1000)
                            sampProcessChatInput('/me ����� ������� ���������� � ������� �� ���� ������', -1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/me �������� ��� � ������� �� ����', -1)
                            wait(1000)
                            sampProcessChatInput('/do ��� ����� �� �����.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������������ ����� ������������ ���������� '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/uninvite '..id..' '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r ��������� '..nm..' ��� ������ �� ����������� �� �������: '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}���������� ���������� �� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ����������: {ffa000}"..date.."\n{78dbe2}����� ����������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (uninvite)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end

                                                        
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[���������� ���������� �� �����������]. ���������: '..nick.. ' ['..id..'] ���� ����������: '..date..' ����� ����������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('���������� ���������� �� �����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..' \n�������: '..reason..'\n������: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239045'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������� �� ���������� (������) -------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 6 then
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)
                    
                    if button == 1 then
                    
                        local nick = input
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ��� ����� �� �����.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ��� � ����� � ������� ���', -1)
                            wait(1000)
                            sampProcessChatInput('/do ��� �������.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ����� � ���� ������ �����������', -1)
                            wait(1000)
                            sampProcessChatInput('/me ����� ������� ���������� � ������� �� ���� ������', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ��� � ������� �� ����', -1)
                            wait(1000)
                            sampProcessChatInput('/do ��� ����� �� �����.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������������ ����� ������������ ���������� '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/uninviteoff '..nick, -1)
                            wait(7000)
                            sampProcessChatInput('/r ��������� '..nm..' ��� ������ �� ����������� �� �������: '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}���������� ���������� �� �����������", "{78dbe2}���������: {ffa000}"..nick.." (������)\n\n{78dbe2}���� ����������: {ffa000}"..date.."\n{78dbe2}����� ����������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (uninviteoff)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                                                        
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[���������� ���������� �� ����������� ������]. ���������: '..nick.. ' (������) ���� ����������: '..date..' ����� ����������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('���������� ���������� �� ����������� ������. \n\n���������: '..nick.. ' (������) \n���� ����������: '..date..' \n����� ����������: '..time..' \n�������: '..reason..'\n������: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239045'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������ �������� ���� -----------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 7 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        reason_mute()
                        while sampIsDialogActive(2012) do wait(100) end
                        local result, button, list, input = sampHasDialogRespond(2012)
                        
                        if button == 1 and list == 0 then                                           -- �������: ���� ��������� � �����
                            local reason = '���� ��������� � �����'
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ����� ����� �� �����.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ����� � �����, ����� � ������ ������ ���������� ���������', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������������ ������� '..id, -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� ����� �� ����', -1)
                            wait(1000)
                            sampProcessChatInput('/do ����� ����� �� �����.', -1)
                            wait(1000)
                            sampProcessChatInput('/fmute '..id..' 15 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r ���������� '..nm..' ��� ������������ ����� ����� �� 15 ����� �� �������: '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}���������� ������������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ����������: {ffa000}"..date.."\n{78dbe2}����� ����������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fmute)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end

                            
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[���������� ������ ������������]. ���������: '..nick.. ' ['..id..'] ���� ����������: '..date..' ����� ����������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('���������� ������ ������������. \n\n���������: '..nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..' \n�������: '..reason..'\n��������: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239036'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 1 then                                           -- �������: ����������� ������
                            local reason = '����������� ������'
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do ����� ����� �� �����.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ����� � �����, ����� � ������ ������ ���������� ���������', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������������ ������� '..id, -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� ����� �� ����', -1)
                            wait(1000)
                            sampProcessChatInput('/do ����� ����� �� �����.', -1)
                            wait(1000)
                            sampProcessChatInput('/fmute '..id..' 10 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r ���������� '..nm..' ��� ������������ ����� ����� �� 10 ����� �� �������: '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}���������� ������������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ����������: {ffa000}"..date.."\n{78dbe2}����� ����������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fmute)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                            
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[���������� ������ ������������]. ���������: '..nick.. ' ['..id..'] ���� ����������: '..date..' ����� ����������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('���������� ������ ������������. \n\n���������: '..nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..' \n�������: '..reason..'\n��������: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239036'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 3 then                                           -- �������: ������ �������
                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)
                            if button == 1 then
                                local reason = input
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do ����� ����� �� �����.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ���� ����� � �����, ����� � ������ ������ ���������� ���������', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������������ ������� '..id, -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ����� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/do ����� ����� �� �����.', -1)
                                wait(1000)
                                sampProcessChatInput('/fmute '..id..' 10 '..reason, -1)
                                wait(1000)
                                sampProcessChatInput('/r ���������� '..nm..' ��� ������������ ����� ����� �� 10 ����� �� �������: '..reason..'.',-1)
                                wait(2000)
                                sampProcessChatInput('/time ',-1)
                                sampShowDialog(0, "{FFA500}���������� ������������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ����������: {ffa000}"..date.."\n{78dbe2}����� ����������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fmute)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[���������� ������ ������������]. ���������: '..nick.. ' ['..id..'] ���� ����������: '..date..' ����� ����������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('���������� ������ ������������. \n\n���������: '..nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..' \n�������: '..reason..'\n��������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239036'
                                sendvkimg(encodeUrl(info),img)
                                
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������ � ������ ������ ---------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 8 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� � ���� ������ �����������, � �������� ����� *׸���� ������*', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� � ����� �������, � ��������� ���� ��������� ��� � ������� ��������', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� �� ������ *������*', -1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ��� � ������ ������� �� ����', -1)
                            wait(2000)
                            sampProcessChatInput('/blacklist '..id.. ' -1 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ������ ������ ����������� �� ������� - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}��������� � �� ���", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (blacklist)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                            
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[��������� � �� ���]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('��������� � �� ���. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239046'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������ � ������ ������ (������) ------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 9 then
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)
                    
                    if button == 1 then
                    
                        local nick = input
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� � ���� ������ �����������, � �������� ����� *׸���� ������*', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� � ����� �������, � ��������� ���� ��������� ��� � ������� ��������', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� �� ������ *������*', -1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ��� � ������ ������� �� ����', -1)
                            wait(2000)
                            sampProcessChatInput('/blacklistoff '..nick.. ' -1 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ������ ������ ����������� �� ������� - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}��������� � �� ���", "{78dbe2}���������: {ffa000}"..nick.." (������)\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (blacklistoff)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                            
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[��������� � �� ���]. ���������: '..nick.. ' (������) ���� ���������: '..date..' ����� ���������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('��������� � �� ���. ������ \n\n���������: '..nick.. ' (������) \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239046'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- �������� ���������� ------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 10 then
                    inputid()

                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        
                        if button == 1 then
                            ranklist()
                            while sampIsDialogActive(2007) do wait(100) end
                            local reason = input
                            local result, button, list, input = sampHasDialogRespond(2007)
                            local rank = {"������", "������� ������", "������� ��������", "��������", "������� ��������", "�������� ���������", "���������", "�������"}

                            if button == 1 and list == 0 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ��������� �� '..rank[list+1]..' �� ������� - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n{78dbe2}������� ���������: {ffa000}"..reason.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� ����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 1 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ��������� �� '..rank[list+1]..' �� ������� - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n{78dbe2}������� ���������: {ffa000}"..reason.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end
                                
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� ����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 2 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ��������� �� '..rank[list+1]..' �� ������� - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n{78dbe2}������� ���������: {ffa000}"..reason.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� ����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 3 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ��������� �� '..rank[list+1]..' �� ������� - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n{78dbe2}������� ���������: {ffa000}"..reason.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� ����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 4 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ��������� �� '..rank[list+1]..' �� ������� - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n{78dbe2}������� ���������: {ffa000}"..reason.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� ����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 5 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ��������� �� '..rank[list+1]..' �� ������� - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n{78dbe2}������� ���������: {ffa000}"..reason.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� ����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 6 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ��������� �� '..rank[list+1]..' �� ������� - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n{78dbe2}������� ���������: {ffa000}"..reason.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� ����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 7 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ��� ������� � ��������� �� '..rank[list+1]..' �� ������� - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}��������� ���������� �����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n{78dbe2}������� ���������: {ffa000}"..reason.."\n\n{78dbe2}����� ���������: {ffa000}["..(list+1).."] "..rank[list+1].."", "���-��", "�������", DIALOG_STYLE_MSGBOX)
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\n���-��: '..docsi)
                                    end
                                end

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[��������� � ���������]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' ����� ���������: ['..(list+1)..'] '..rank[list+1]..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('��������� ����������. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�������: '..autor..' ['..who_id..']'..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������ ������� -----------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 11 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        
                        if button == 1 then
                            local reason = input

                            praisecount() -- !!!!!!!!!!!
                            while sampIsDialogActive(2011) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2011)                        

                            if button == 1 then
                                local prisecount = input
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                for i = 1, prisecount do
                                    sampProcessChatInput("/praise "..id.." "..reason,-1)
                                    wait(2000)
                                end
                                sampProcessChatInput('/time ',-1)

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/�������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (praise)')

                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[������ �������]. ���������: '..nick.. ' ['..id..'] ���� ������: '..date..' ����� ������: '..time..' ���������� ������: '..prisecount..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                                file:close()

                                info = ('������ �������. \n\n���������: '..nick.. ' ['..id..'] \n���� ������: '..date..' \n����� ������: '..time..'\n���������� �������: '..prisecount..'\n�������: '..reason..'\n�����: '..autor..' ['..who_id..']')
                                img = 'photo-232454643_456239040'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������� �� ������� ������ ------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 12 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� � ���� ������ �����������, � �������� ����� *׸���� ������*', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� � ����� �������, � ��������� ���� ��������� ��� � ������� ��������', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� �� ������ *�������*', -1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ��� � ������ ������� �� ����', -1)
                            wait(1000)
                            sampProcessChatInput('/unblacklist '..id.. ' -1 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r ��������� '..nm..' ��� ������� �� ������� ������ �����������.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}��������� �� �� ���", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (unblacklist)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end
                            
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[��������� �� �� ���]. ���������: '..nick.. ' ['..id..'] ���� ���������: '..date..' ����� ���������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('��������� �� �� ���. \n\n���������: '..nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239047'
                            sendvkimg(encodeUrl(info),img)
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������� �� ������ ������ (������) ----------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 13 then
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)
                    
                    if button == 1 then
                    
                        local nick = input
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������� � ���� ������ �����������, � �������� ����� *׸���� ������*', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� � ����� �������, � ��������� ���� ��������� ��� � ������� ��������', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� �� ������ *�������*', -1)
                            wait(1000)
                            sampProcessChatInput('/me ��������� ��� � ������ ������� �� ����', -1)
                            wait(1000)
                            sampProcessChatInput('/unblacklistoff '..nick.. ' -1 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r ��������� '..nm..' ��� ������� �� ������� ������ �����������.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}��������� �� �� ���", "{78dbe2}���������: {ffa000}"..nick.." (������)\n\n{78dbe2}���� ���������: {ffa000}"..date.."\n{78dbe2}����� ���������: {ffa000}"..time.."\n\n{78dbe2}������� ���������: {ffa000}"..reason, "���-��", "�������", DIALOG_STYLE_MSGBOX)

                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (unblacklistoff)')

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\n���-��: '..docsi)
                                end
                            end

                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[�������� �� �� ���]. ���������: '..nick.. ' (������) ���� ���������: '..date..' ����� ���������: '..time..' �������: '..reason..'\n') --����� ������ ����� ���������� ����
                            file:close()

                            info = ('�������� �� �� ���. ������ \n\n���������: '..nick.. ' (������) \n���� ���������: '..date..' \n����� ���������: '..time..' \n�������: '..reason..'\n�����: '..autor..' ['..who_id..']'..docs)
                            docs = ''
                            img = 'photo-232454643_456239047'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                if button == 0 then zammenu() end
            end

            -----------------------------------------------------------------------------------
            -- ��������� ������ ���������� ----------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 1 then
                inputid()
                while sampIsDialogActive(2001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2001)

                if button == 1 then
                    local id = input
                    local nick = sampGetPlayerNickname(id)
                    local nm = trst(nick)
                    local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                    local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                    sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                    wait(1000)
                    sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                    wait(1000)
                    sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
                    wait(1000)
                    sampProcessChatInput('/time', -1)
                    wait(1000)
                    sampProcessChatInput('/checkjobprogress '..id, -1)
                    wait(2000)

                    lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/����������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (jobprogress)')
                end
            end

            -----------------------------------------------------------------------------------
            -- �� ��������� (������ / ���������� / �����������) -------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 2 then
                    lec()
                    while sampIsDialogActive(2006) do wait(100) end
                    local result, button, list, input = sampHasDialogRespond(2006)
                    
                    -----------------------------------------------------------------------------------
                    -- [RB] ������� ��� ���� ----------------------------------------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 0 then
                        sampProcessChatInput('/rb ��������� �������, ������ ����� ��������� ���������:', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 1. ��������� �������� �� ������ ��� ���� ��������� ������������. ', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ����������: � ������ ��������� ���������� ������, �� ����������...', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ...�� �������, ��� �� ������� ��������� �����������.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 2. ���� ����� ������� �� ������ � ������������, �� � �� ����, ��������...', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ... ��������� � ����.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 3. ��� �������� ��������� ��, ���������� ������ ���������.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 4. ���������� ��������������� � ����. ����� ��, ������...', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ...�� ��. ������� ������������.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 5. ������ ���������� � 10 �� ���, �� ����� �������� 20 �����.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 6. ����� �������� ������ ��������� ��� � 3 ����, ��������� � ��������.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 7. ������� ����� � 9 ���, �� ���� ������� � �������� ����� �� ����������.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 8. ���� �� ������ �������� �� wbook, �� �� 5��� �����...', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ...�� ��������� ������ �� ����.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 9. ���������� �������������� ��������� ���������� ����������. ', -1)
                        wait(2000)
                        sampProcessChatInput('/rb �������� ��. ������. �� ���� ���� ��, ��������� �� ��������!', -1)
                    end

                    -----------------------------------------------------------------------------------
                    -- [R] ������ ��� ��� � ���������� ------------------------------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 1 then
                        sampProcessChatInput('/r ��������� ����������, ����� ��������� ��������...',-1)
                        wait(1000)
                        sampProcessChatInput('/r � ���� ��������� ��� � ���, ��� ����� � ����������...',-1)
                        wait(1000)
                        sampProcessChatInput('/r � ������� ����� ���������.',-1)
                        wait(1000)
                        sampProcessChatInput('/r ����� ��������� ����������� ��� ������������...',-1)
                        wait(1000)
                        sampProcessChatInput('/r � ������� �����. ���� ������� ��� �� ����...',-1)
                        wait(1000)
                        sampProcessChatInput('/r ����� ��������� �������������� ����.',-1)
                        wait(1000)
                        sampProcessChatInput('/r ����� � ���������� ����� ������ �� � ������� �����.',-1)
                        wait(1000)
                        sampProcessChatInput('/r �� ��������� ��������� �������������� ���������, ���������� ��� �����������....',-1)
                        wait(1000)
                        sampProcessChatInput('/r ... � ������ �������, ������������ �� ����������� ������� ������������.',-1)
                        wait(1000)
                        sampProcessChatInput('/r � ���������, ����������� ���������� ��������� ������������ - '..nick_fire..'.',-1)
                        wait(1000)
                        sampProcessChatInput('/r ������� ��� ���������� ��� ����������.',-1)
                        wait(1000)
                        sampProcessChatInput('/r ������� ������!',-1)
                    end

                    -----------------------------------------------------------------------------------
                    -- [D] ���������� ��� ������������ �� �������� ������������ -----------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 2 then
                        sampProcessChatInput('/d [FD] - [ALL]: ��������� �������, ����� ��������� ��������...', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: � ����� ������������� �������� �������, ������� ������� �� ������� �������...', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: ������� ��������� �� ���������� �������������. ', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: ��������� ������������ ������ �������� ���������...', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: � ����� ��������� ����������� ��������� �������������...', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: � ������� ������� �������� ������ ������.', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: � ���� �� ���� ��, ��������� �� ��������.', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: � ���������, ������������ ��������� ������������ - '..nick_fire, -1)
                    end

                    -----------------------------------------------------------------------------------
                    -- [������] �������� �������� �������� ��� ������ � ������ ------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 3 then
                        sampProcessChatInput('������������, ��������� ����������.',-1)
                        wait(1000)
                        sampProcessChatInput('/s ������� �������� ���� ������: "�������� �������� �������� ��� ������ � ������.".',-1)
                        wait(3000)
                        sampProcessChatInput('/time',-1)
                        wait(3000)
                        sampProcessChatInput('����, ������.',-1)
                        wait(1000)
                        sampProcessChatInput('������. �������� �� ����� ������: �������� �����, �������� ���������� � ���������� � ������������.',-1)
                        wait(1000)
                        sampProcessChatInput('�� �������� ������� ������� ������, ������ ��� ����� � ����������� ��������, � ����� ���������...',-1)
                        wait(1000)
                        sampProcessChatInput('...������������ ��� �������.',-1)
                        wait(2000)
                        sampProcessChatInput('������. ��������� �����: ����������� ��������� ����� �������� ��� �������� ������.',-1)
                        wait(1000)
                        sampProcessChatInput('������� ������ ������������� �����, ��������������� � ������. ���� ��������� ����������, ���������� ������...',-1)
                        wait(1000)
                        sampProcessChatInput('������� ������� � ��������� ������������.',-1)
                        wait(2000)
                        sampProcessChatInput('������. ������� ������: ����������� ���� ����������, ��������� ��������� �������� �������.',-1)
                        wait(1000)
                        sampProcessChatInput('���������� ��������������� ���� �� �������� ��������� � �����. ��� ������������� ���������...',-1)
                        wait(1000)
                        sampProcessChatInput('...�������- � �������������.',-1)
                        wait(1000)
                        sampProcessChatInput('���������. ���������� ������: ��������� ������ �� ������� ������� ������ ���������� � ����������...',-1)
                        wait(2000)
                        sampProcessChatInput('...���������� ���������.',-1)
                        wait(1000)
                        sampProcessChatInput('��������� � ���������� ������ ���������� ����������. �� ���� ������ ���������.',-1)
                        wait(2000)
                        sampProcessChatInput('������� �� ��������.',-1)
                        wait(1000)
                        sampProcessChatInput('/s ������ ��������. ������ ���� ��������.',-1)
                        wait(3000)
                        sampProcessChatInput('/time',-1)
                    end

                    -----------------------------------------------------------------------------------
                    -- �������� ��������� ���� --------------------------------------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 4 then
                        idhouse()
                        while sampIsDialogActive(2018) do wait(200) end
                        local result, button, _, input = sampHasDialogRespond(2018)

                        if button == 1 then
                            local i = 0
                            local house = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/��������� �����/'..date.. ' ' ..timed.. ' ��� �' ..house)

                            sampProcessChatInput('/me ��������� � ��������� ���� �'..house, -1)
                            wait(1000)
                            sampProcessChatInput('/me ������������ ����� ������ ���������', -1)
                            wait(1000)
                            sampProcessChatInput('/do ����� ������ ���������: '..time..'.', -1)
                            wait(2000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me ������ ����� ���������', -1)
                            wait(1000)
                            sampProcessChatInput('/do ����� ����������� ��������� � ����.', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ������� ������������ � ����', -1)
                            wait(1000)
                            sampProcessChatInput('/try ������������ �� �����?', -1) 
                            wait(1000) i = i + inspect
                            
                            if inspect == 0 then
                                inspect_1 = '{AFEEEE}1. ������� ������������: {FF4500}�����������'
                            else
                                inspect_1 = '{AFEEEE}1. ������� ������������: {7CFC00}�������'
                            end

                            sampProcessChatInput('/me ������ ������� � ������������� �����', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me �������� ������� �������', -1)
                            wait(1000)
                            sampProcessChatInput('/try ������� �� �����?', -1)
                            wait(1000) i = i + inspect

                            if inspect == 0 then
                                inspect_2 = '{AFEEEE}2. ������� �������: {FF4500}�����������'
                            else
                                inspect_2 = '{AFEEEE}2. ������� �������: {7CFC00}�������'
                            end

                            sampProcessChatInput('/me ������ ������� � ������������� �����', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me �������� ������� ������������ �����', -1)
                            wait(1000)
                            sampProcessChatInput('/try ������������ ����� �� �����?', -1)
                            wait(1000) i = i + inspect

                            if inspect == 0 then
                                inspect_3 = '{AFEEEE}3. ������� �����: {FF4500}�����������'
                            else
                                inspect_3 = '{AFEEEE}3. ������� �����: {7CFC00}�������'
                            end

                            sampProcessChatInput('/me ������ ������� � ������������� �����', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me �������� ����������� ������� �������� ������������', -1)
                            wait(1000)
                            sampProcessChatInput('/try �������� ������������ � ��������� ���������?', -1)
                            wait(1000) i = i + inspect

                            if inspect == 0 then
                                inspect_4 = '{AFEEEE}4. �������� ������������: {FF4500}�� ��������'
                            else
                                inspect_4 = '{AFEEEE}4. �������� ������������: {7CFC00}��������'
                            end

                            sampProcessChatInput('/me ������ ������� � ������������� �����', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me �������� �������� �����', -1)
                            wait(1000)
                            sampProcessChatInput('/try �������� ����� ������?', -1)
                            wait(1000) i = i + inspect

                            if inspect == 0 then
                                inspect_5 = '{AFEEEE}5. �������� �����: {FF4500}������������'
                            else
                                inspect_5 = '{AFEEEE}5. �������� �����: {7CFC00}������'
                            end

                            sampProcessChatInput('/me ������ ������� � ������������� �����', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me �������� ���������', -1)
                            wait(1000)
                            sampProcessChatInput('/do � ����� ����� ���������.', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ������ ���� �� �������� ������������', -1)
                            wait(1000)
                            local date = os.date('%d.%m.%Y')
                            sampProcessChatInput('/do ������ ���� �� ����������� ��������� �� �������� ������������ '..i..' �� 5', -1)
                            wait(2000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me �������� ������� ���� '..date..' � ���� ����', -1)
                            wait(1000)
                            sampProcessChatInput('/me �������� ���� ������� � ���� �������', -1)
                            wait(1000)
                            sampProcessChatInput('/me ������������ ����� ��������', -1)
                            wait(1000)
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            sampProcessChatInput('/do ����� ���������� ��������: '..time..'.', -1)
                            wait(2000)
                            sampProcessChatInput('/time', -1)

                            if i < 3 then
                                ocenka = ('{FF4500}'..i)
                            elseif i == 3 then
                                ocenka = ('{FFA500}'..i)
                            elseif i > 3 then
                                ocenka = ('{7CFC00}'..i)
                            end

                            sampShowDialog(0, '�������� ��������� ���� {FFA500}�'..house, '{48D1CC}���� ��������: {FFA500}'..date..'\n{48D1CC}����� ��������: {FFA500}'..time..'\n\n{7FFFD4}���������� �������� ���� �� �������� ������������:\n\n'..inspect_1..'\n'..inspect_2..'\n'..inspect_3..'\n'..inspect_4..'\n'..inspect_5..'\n\n{7FFFD4}�������� ������ ���� �� �������� ���������: '..ocenka..' �� 5', '�������', '', DIALOG_STYLE_MSGBOX)
                        end
                    end

                    -----------------------------------------------------------------------------------
                    -- �� ������� ��� ����������� -----------------------------------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 6 then
                        rp()
                        while sampIsDialogActive(2009) do wait(200) end
                        local result, button, list, input = sampHasDialogRespond(2009)

                        if button == 1 and list == 0 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' ��� ��� �������: ������ ���� � ����� ������������.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 1 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' ��� ��� �������: ������ ����� � ����� ������������.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 2 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' ��� ��� �������: ��������� ��������� ������������ � ����� ������������.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 3 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' ��� ��� �������: ��������� ��� ��������� �������� ������ �����.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 4 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' ��� ��� �������: ������������� ������ ������ ���� � ������.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 5 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' ��� ��� �������: ��������� ����� ������ �� ����.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 6 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' ��� ��� �������: ��������� ������ �� ���������� ��������� ������������.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end
                    end

                    if button == 0 then zammenu() end
            end

            -----------------------------------------------------------------------------------
            -- ������������ ���� --------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 4 then
                inputid()
                while sampIsDialogActive(2001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2001)

                if button == 1 then
                    local id = input
                    local nick = sampGetPlayerNickname(id)
                    local nm = trst(nick)

                    setClipboardText(nm)
                    sampAddChatMessage('{78dbe2}��� {ffa000}'..nm..' ['..id..'] {78dbe2}���������� � ����� ������', -1)
                end
            end

            -----------------------------------------------------------------------------------
            -- ����������� ��� ��� �������� �� ��� � ����� ------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 5 then
                inputid()
                while sampIsDialogActive(2001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2001)

                if button == 1 then
                    local id = input
                    local nick = sampGetPlayerNickname(id)

                    setClipboardText(nick)
                    sampAddChatMessage('{78dbe2}��� {ffa000}'..nick..' ['..id..'] {78dbe2}���������� � ����� ������', -1)
                end
            end

            -----------------------------------------------------------------------------------
            -- �������� �� ����� ��� ----------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 6 then
                inputid()
                while sampIsDialogActive(2001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2001)

                if button == 1 then
                    local id = input
                    local nick = '/checkrp '..sampGetPlayerNickname(id)

                    setClipboardText(nick)
                    sampAddChatMessage('{78dbe2}������� {ffa000}'..nick..' {78dbe2}����������� � ����� ������', -1)
                end
            end

            -----------------------------------------------------------------------------------
            -- ������� ------------------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 7 then
                timermenu()
                while sampIsDialogActive(2017) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(2017)

                -----------------------------------------------------------------------------------
                -- [5 ���] ������ 5 ����� ��� ���� �� ������ --------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 0 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        lua_thread.create(function()
                            local id = input
                            local nick = sampGetPlayerNickname(id)
                            local nm = trst(nick)
                            local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*5))
                            sampProcessChatInput('/r '..nm.. ', � ��� ���� 5 ����� ��� ����, ����� ������ ����� � ���������� � ������.',-1)
                            wait(1000)
                            sampProcessChatInput('/r � ������ �������������, � ��� ����� ��������� �������������� ���������. ����� �����.',-1)
                            wait(1000)
                            sampShowDialog(0, "������ ��� {FFA500}"..nick, "{78dbe2}����� �������:{FFA500} "..time.."\n{78dbe2}����� ���������:{FFA500} "..timeend.."\n\n{78dbe2}��������� {FFA500}"..nick.." ["..id.."] \n{78dbe2}����� �������: {FFA500}5 �����", "�������","", DIALOG_STYLE_MSGBOX)
                            sampProcessChatInput('/time',-1)
                            wait(1000*60*2)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "������ ��� {FFA500}"..nick, "{78dbe2}� ���������� {FFA500}"..nick.." ["..id.."] {78dbe2}�������� {FFA500}3 ������", "�������", "", DIALOG_STYLE_MSGBOX)
                            wait(1000*60*3)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "������ ��� {FFA500}"..nick, "{78dbe2}����� �������� ��� ���������� {FFA500}"..nick.." ["..id.."] {78dbe2}�����.", "�������", "", DIALOG_STYLE_MSGBOX)

                            local fire_1 = loadAudioStream("moonloader/firedep_zam_helper/alarm.mp3")
                            setAudioStreamState(fire_1, 1)
                        end)
                    end
                end
                
                -----------------------------------------------------------------------------------
                -- [1 ���] ������ �� 1 ������ -----------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 1 then
                    lua_thread.create(function()
                        local timer = 1
                        local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                        local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                        sampAddChatMessage('{FFFFFF}������ ���������� �� {FFA500}'..timer..' ���.',-1)
                        sampAddChatMessage('{FFFFFF}������� � {FFA500}'..time,-1)
                        sampAddChatMessage('{FFFFFF}����� ���������: {FFA500}'..timeend,-1)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "������", "{78dbe2}������ ������� � {FFA500}"..time.."\n\n{78dbe2}����� �������: {FFA500}"..timer.." {78dbe2}���.\n����� ���������: {FFA500}"..timeend, "�������", "", DIALOG_STYLE_MSGBOX)
                        wait(1000*60*timer)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "�������� ������", "{78dbe2}����� ������� �� {FFA500}"..timer.." {78dbe2}���. �����. {78dbe2}�����.", "�������", "", DIALOG_STYLE_MSGBOX)
                        
                        local fire_1 = loadAudioStream("moonloader/firedep_zam_helper/alarm.mp3")
                        setAudioStreamState(fire_1, 1)
                    end)
                end
                
                -----------------------------------------------------------------------------------
                -- [3 ���] ������ �� 3 ������ -----------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 2 then
                    lua_thread.create(function()
                        local timer = 3
                        local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                        local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                        sampAddChatMessage('{FFFFFF}������ ���������� �� {FFA500}'..timer..' ���.',-1)
                        sampAddChatMessage('{FFFFFF}������� � {FFA500}'..time,-1)
                        sampAddChatMessage('{FFFFFF}����� ���������: {FFA500}'..timeend,-1)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "������", "{78dbe2}������ ������� � {FFA500}"..time.."\n\n{78dbe2}����� �������: {FFA500}"..timer.." {78dbe2}���.\n����� ���������: {FFA500}"..timeend, "�������", "", DIALOG_STYLE_MSGBOX)
                        wait(1000*60*timer)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "�������� ������", "{78dbe2}����� ������� �� {FFA500}"..timer.." {78dbe2}���. �����. {78dbe2}�����.", "�������", "", DIALOG_STYLE_MSGBOX)
                    end)
                end
                
                -----------------------------------------------------------------------------------
                -- [5 ���] ������ �� 5 ����� ------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 3 then
                    lua_thread.create(function()
                        local timer = 5
                        local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                        local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                        sampAddChatMessage('{FFFFFF}������ ���������� �� {FFA500}'..timer..' ���.',-1)
                        sampAddChatMessage('{FFFFFF}������� � {FFA500}'..time,-1)
                        sampAddChatMessage('{FFFFFF}����� ���������: {FFA500}'..timeend,-1)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "������", "{78dbe2}������ ������� � {FFA500}"..time.."\n\n{78dbe2}����� �������: {FFA500}"..timer.." {78dbe2}���.\n����� ���������: {FFA500}"..timeend, "�������", "", DIALOG_STYLE_MSGBOX)
                        wait(1000*60*timer)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "�������� ������", "{78dbe2}����� ������� �� {FFA500}"..timer.." {78dbe2}���. �����. {78dbe2}�����.", "�������", "", DIALOG_STYLE_MSGBOX)
                    end)
                end
                
                -----------------------------------------------------------------------------------
                -- [��� �����] ���������� ������ ��� ������ --------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 4 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        local id = input

                        inputimer()
                        while sampIsDialogActive(2010) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2010)

                        lua_thread.create(function()
                            local timer = input
                            local nick = sampGetPlayerNickname(id)
                            local nm = trst(nick)
                            local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                            sampShowDialog(0, "������ ��� {FFA500}"..nick, "{78dbe2}����� �������:{FFA500} "..time.."\n{78dbe2}����� ���������:{FFA500} "..timeend.."\n\n{78dbe2}��������� {FFA500}"..nick.." ["..id.."] \n{78dbe2}����� �������: {FFA500}"..timer.." ���.", "�������", "", DIALOG_STYLE_MSGBOX)
                            sampProcessChatInput('/time',-1)
                            wait(1000*60*timer)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "������ ��� {FFA500}"..nick, "{78dbe2}����� �������� ��� {FFA500}"..nick.." ["..id.."] {78dbe2}�����.", "�������", "", DIALOG_STYLE_MSGBOX)
                        end)
                    end
                end
                
                -----------------------------------------------------------------------------------
                -- [��� �����] ���������� ������ ��� ���� ----------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 5 then
                    inputimer()
                    while sampIsDialogActive(2010) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2010)

                    if button == 1 then
                        lua_thread.create(function()
                            local timer = input
                            local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                            sampAddChatMessage('{FFFFFF}������ ���������� �� {FFA500}'..timer..' ���.',-1)
                            sampAddChatMessage('{FFFFFF}������� � {FFA500}'..time,-1)
                            sampAddChatMessage('{FFFFFF}����� ���������: {FFA500}'..timeend,-1)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "������", "{78dbe2}������ ������� � {FFA500}"..time.."\n\n{78dbe2}����� �������: {FFA500}"..timer.." {78dbe2}���.\n����� ���������: {FFA500}"..timeend, "�������", "", DIALOG_STYLE_MSGBOX)
                            wait(1000*60*timer)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "�������� ������", "{78dbe2}����� ������� �� {FFA500}"..timer.." {78dbe2}���. �����. {78dbe2}�����.", "�������", "", DIALOG_STYLE_MSGBOX)
                        end)
                    end
                end
                
                -----------------------------------------------------------------------------------
                -- [15 ���] ������ ������������� --------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 6 then
                    lua_thread.create(function()
                        local timer = 15
                        local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                        local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                        img = 'photo-232454643_456239043'
                        sendvkimg(encodeUrl('������������� ������.'),img)
                        sampAddChatMessage('{FFFFFF}������ �������������. ����� ������������� {FFA500}'..timer..' �����',-1)
                        sampAddChatMessage('{FFFFFF}������� � {FFA500}'..time,-1)
                        sampAddChatMessage('{FFFFFF}����� ���������: {FFA500}'..timeend,-1)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "������ �������������", "{78dbe2}������������� ������ � {FFA500}"..time.."\n\n{78dbe2}����� �������������: {FFA500}"..timer.." {78dbe2}���.\n����� ���������: {FFA500}"..timeend, "�������", "", DIALOG_STYLE_MSGBOX)
                        wait(1000*60*timer)
                        sampProcessChatInput('/do ������������� ��������.',-1)
                        wait(2000)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "������������� ��������", "{78dbe2}����� ���������� ������������� {FFA500}��������.", "���������", "�������", DIALOG_STYLE_MSGBOX)
                        
                        while sampIsDialogActive(0) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(0)
                        if button == 1 then
                           img = 'photo-232454643_456239044'
                           sendvkimg(encodeUrl('������������� ��������.'),img)
                        end

                    end)
                end

                if button == 0 then zammenu() end
            end

            -----------------------------------------------------------------------------------
            -- �������� �������� �� -----------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 9 then
                sampProcessChatInput('/r ���������� �������� ���������� ����, ������� ������ �����.', -1)
                wait(5000)
                sampProcessChatInput('/r �������� ���������� ����� 10 ������.', -1)
                wait(5000)
                sampProcessChatInput('/r �������� ���������� ����� 5 ������.', -1)
                wait(5000)
                sampProcessChatInput('/r �������� ���������� ������.', -1)
                sampProcessChatInput('/lmenu', -1)
            end

            -----------------------------------------------------------------------------------
            -- ��������� ����� �� ����. ����� -------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 10 then
                start_sobes = true
                sobes_start = true
                local hour = os.date('%H', os.time() - ((UTC) * 3600) + 3600)
                sobes = hour..',05,�������� �����������'
                sampAddChatMessage('{FFFFFF}��� �������������: {FFA500}'..sobes,-1)
                --sampAddChatMessage('{FFFFFF}��� �������������: {FFA500}'..h,-1)
                sampProcessChatInput('/lmenu', -1)
            end

            -----------------------------------------------------------------------------------
            -- ���������� ����� ������ --------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 11 then
                settag()
                while sampIsDialogActive(2020) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(2020)
                
                if button == 1 and list == 0 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                        local id = input
                        local tagname = string.gsub(string.match(sampGetPlayerNickname(id), "_%a+"), "_", "")
                        sampProcessChatInput('/settag '..id..' TD | '..tagname, -1)
                    end
                end

                if button == 1 and list == 1 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                        local id = input
                        local tagname = string.gsub(string.match(sampGetPlayerNickname(id), "_%a+"), "_", "")
                        sampProcessChatInput('/settag '..id..' ID | '..tagname, -1)
                    end
                end

                if button == 1 and list == 2 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                        local id = input
                        local tagname = string.gsub(string.match(sampGetPlayerNickname(id), "_%a+"), "_", "")
                        sampProcessChatInput('/settag '..id..' DA | '..tagname, -1)
                    end
                end

                if button == 1 and list == 3 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                        local date = (os.date('%d.%m')+1)
                        local time = (os.date('%H:%M'))
                        local id = input
                        local name = sampGetPlayerNickname(id)
                        local tagname = string.gsub(string.match(name, "_%a+"), "_", "")
                        local nm = trst(name)
                        sampProcessChatInput('/settag '..id..' ����� �� '..date, -1)
                        wait(1000)
                        sampProcessChatInput('/r '..nm.. ', ��� ���������� ������� ��� � ������� 24 �����. ����� �� ������ �������.', -1)
                        text = ('������ '..sampGetPlayerNickname(id).. ' ['..id..'] ����������� ����������:\n������� ����� ��� �� '..date..'.2025 '..time)
                        vkmsg(encodeUrl(text))
                    end
                end
            end

            -----------------------------------------------------------------------------------
            -- ��������� ��������� � ������ �� ------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 12 then
                inputmsg()
                while sampIsDialogActive(2022) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2022)
                if button == 1 then
                    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    local nick = sampGetPlayerNickname(id)
                    local text = (nick..' ['..id..']: '..input)
                    vkmsg(encodeUrl(text))
                end
            end

            -----------------------------------------------------------------------------------
            -- ��������� � ������ ���-�� �� ---------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 13 then
                inputmsg()
                while sampIsDialogActive(2022) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2022)
                if button == 1 then
                    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    local nick = sampGetPlayerNickname(id)
                    local text = (nick..' ['..id..']: '..input)

                    sendvkmsg(encodeUrl(text))
                end
            end

            -----------------------------------------------------------------------------------
            -- ���������� ������� -------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 15 then
                zadmenu()
                while sampIsDialogActive(1000) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(1000)

                -----------------------------------------------------------------------------------
                -- �������� ������� ---------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 0 then
                    zad()
                    while sampIsDialogActive(1001) do wait(100) end
                    local result, button, list, input = sampHasDialogRespond(1001)

                    if button == 1 and list == 0 then                                                                                       -- �������: ������ �������
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input

                            praisecount()
                            while sampIsDialogActive(2011) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2011)                        

                            if button == 1 then
                                local prisecount = input

                                inputreason()
                                while sampIsDialogActive(2002) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2002)

                                if button == 1 then
                                    local reason = input
                                    local zadanie = ('������ �������')
                                    for i = 1, prisecount do
                                        local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                        local rowd = test:fetch({}, "a")
                                        local num = rowd.cnt
                                        local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                        local nick_eng = sampGetPlayerNickname(who_id)
                                        local autor = nick_eng:match('(.)')..'.'..string.gsub(nick_eng, "(.+)_", "")
                                        local command = ('/praise '..nick.. ' '..reason)

                                        assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                        sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                                    end
                                end
                            end
                        end
                    end

                    if button == 1 and list == 1 then                                                                                       -- �������: �������� ����������
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('������ ���������')

                            ranklist()
                            while sampIsDialogActive(2007) do wait(100) end
                            local result, button, list, input = sampHasDialogRespond(2007)
                            
                            if button == 1 then
                                local rank = list+1

                                inputreason()
                                while sampIsDialogActive(2005) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2005)
                                
                                if button == 1 then
                                    local reason = input

                                    local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                    local rowd = test:fetch({}, "a")
                                    local num = rowd.cnt
                                    local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                    local nick_eng = sampGetPlayerNickname(who_id)
                                    local autor = nick_eng:match('(.)')..'.'..string.gsub(nick_eng, "(.+)_", "")
                                    local command = ('/giverank '..nick.. ' '..rank)

                                    assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                    sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                                end
                            end
                        end
                    end

                    if button == 1 and list == 2 then                                                                                       -- �������: ������ �����
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('������ �����')

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)

                            if button == 1 then
                                local reason = input

                                settag()
                                while sampIsDialogActive(2020) do wait(100) end
                                local result, button, list, input = sampHasDialogRespond(2020)

                                if button == 1 and list == 0 then
                                    local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                    tag = 'TD | '..tagname
                                end

                                if button == 1 and list == 1 then
                                    local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                    tag = 'ID | '..tagname
                                end

                                if button == 1 and list == 2 then
                                    local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                    tag = 'DA | '..tagname
                                end

                                local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                local rowd = test:fetch({}, "a")
                                local num = rowd.cnt
                                local command = ('/settag '..nick..' '..tag)

                                assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                            end
                        end
                    end

                    if button == 1 and list == 3 then                                                                                       -- �������: ������� � �����������
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('������� � ����������� �� ���������')

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)
                                
                            if button == 1 then
                                local reason = input
                                local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                local rowd = test:fetch({}, "a")
                                local num = rowd.cnt
                                local command = ('/invite '..nick)

                                assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                            end
                        end
                    end

                    -- if button == 1 and list == 4 then                                                                                       -- �������: ������ �������
                    --     inputnick()
                    --     while sampIsDialogActive(2008) do wait(100) end
                    --     local result, button, _, input = sampHasDialogRespond(2008)

                    --     if button == 1 then
                    --         local nick = input
                    --         local zadanie = ('������ �������')

                    --         inputreason()
                    --         while sampIsDialogActive(2005) do wait(100) end
                    --         local result, button, _, input = sampHasDialogRespond(2005)

                    --         if button == 1 then
                    --             local reason = input
                    --             local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                    --             local rowd = test:fetch({}, "a")
                    --             local num = rowd.cnt
                                    -- local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                    -- local nick_eng = sampGetPlayerNickname(who_id)
                                    -- local autor = nick_eng:match('(.)')..'.'..string.gsub(nick_eng, "(.+)_", "")
                    --             local command = ('/fwarn '..nick..' '..reason)

                    --             assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                    --             sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                    --         end
                    --     end
                    -- end

                    -- if button == 1 and list == 5 then                                                                                       -- �������: ������� �� �����������
                    --     inputnick()
                    --     while sampIsDialogActive(2008) do wait(100) end
                    --     local result, button, _, input = sampHasDialogRespond(2008)

                    --     if button == 1 then
                    --         local nick = input
                    --         local zadanie = ('������� �� �����������')

                    --         inputreason()
                    --         while sampIsDialogActive(2005) do wait(100) end
                    --         local result, button, _, input = sampHasDialogRespond(2005)

                    --         if button == 1 then
                    --             local reason = input
                    --             local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                    --             local rowd = test:fetch({}, "a")
                    --             local num = rowd.cnt
                    --local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    --local nick_eng = sampGetPlayerNickname(who_id)
                    --local autor = nick_eng:match('(.)')..'.'..string.gsub(nick_eng, "(.+)_", "")
                    --             local command = ('/uninvite '..nick..' '..reason)

                    --             assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                    --             sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                    --         end
                    --     end
                    -- end

                    -- if button == 1 and list == 6 then                                                                                       -- �������: ������� � ������ ������
                    --     inputnick()
                    --     while sampIsDialogActive(2008) do wait(100) end
                    --     local result, button, _, input = sampHasDialogRespond(2008)

                    --     if button == 1 then
                    --         local nick = input
                    --         local zadanie = ('������� � �� �����������')

                    --         inputreason()
                    --         while sampIsDialogActive(2005) do wait(100) end
                    --         local result, button, _, input = sampHasDialogRespond(2005)

                    --         if button == 1 then
                    --             local reason = input
                    --             local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                    --             local rowd = test:fetch({}, "a")
                    --             local num = rowd.cnt
                                    --local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                    --local nick_eng = sampGetPlayerNickname(who_id)
                                    --local autor = nick_eng:match('(.)')..'.'..string.gsub(nick_eng, "(.+)_", "")
                    --             local command = ('/blacklist '..nick..' '..reason)

                    --             assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                    --             sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                    --         end
                    --     end
                    -- end

                    local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                    local row = cursor:fetch({}, "a")
                    local cnt = 0
                    while row do
                        assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                        row = cursor:fetch({}, "a")
                        cnt = cnt+1
                    end

                    if button == 0 then
                        zammenu()
                    end
                end

                -----------------------------------------------------------------------------------
                -- ��������� ������� --------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 1 then
                    local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by id DESC"))
                    local row = cursor:fetch({}, "a")
                    local list = ''
                    local cnt = 0
                    
                    while row do
                        cnt = cnt+1
                        list = row.name..' {FF8C00}'..row.nick..' {FFD700}| '..row.autor..'\n'..list
                        row = cursor:fetch({}, "a")
                    end

                    zadlist(logo, list)
                    while sampIsDialogActive(9999) do wait(100) end
                    local result, button, list, input = sampHasDialogRespond(9999)

                    for i=0, cnt-1  do
                        if button == 1 and list == i then
                            local cursor = assert(conn:execute("SELECT * FROM zadlist WHERE id = '"..i.."'"))
                            local row = cursor:fetch({}, "a")

                            if row.name:match('�������') then                                                                                            -- ���� ��������� �������: ������ �������
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput("/praise "..id.." "..row.reason,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                                info_2 = ('������ �������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ������: '..date..' \n����� ������: '..time..'\n���������� �������: 1\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239040'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('���������') then                                                                                           -- ���� ��������� �������: ������ ���������
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                                info_2 = ('������ ���������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('�������') then                                                                                            -- ���� ��������� �������: ������� � �����������
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local nick = row.nick 
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')
                                local nm = trst(nick)

                                sampProcessChatInput('/do ����� � ������ �� �����.',-1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ����� �� ��� � ���������',-1)
                                wait(1000)
                                sampProcessChatInput('/do ����� � �������� ���� ����� �� ����.',-1)
                                wait(1000)
                                sampProcessChatInput('/me ���� ����� � ������� �������� ��������',-1)
                                wait(1000)
                                sampProcessChatInput(row.command,-1)
                                wait(1000)
                                sampProcessChatInput('/time ',-1)
                                wait(2000)
                                waitrp(id, nick)
                                while sampIsDialogActive(2004) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2004)
                                if button == 1 then
                                    assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                    assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))

                                    sampProcessChatInput('/fractionrp '..id,-1)
                                    wait(2000)
                                    sampProcessChatInput('/r ������������ ������ ���������� ��������� ������������ - '..nm..'.',-1)
                                    wait(2000)
                                    sampProcessChatInput('/time ',-1)
                                    wait(2000)
                                    sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                    wait(1000)
                                    sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                    wait(1000)
                                    sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                    wait(1000)
                                    sampProcessChatInput('/giverank '..id..' 4', -1)
                                    wait(1000)
                                    sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - ��������.', -1)
                                    wait(2000)
                                    sampProcessChatInput('/time', -1)

                                    info_2 = ('�������� � �����������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                                    img = 'photo-232454643_456239037'
                                    sendvkimg(encodeUrl(info_2),img)

                                    local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                    local row = cursor:fetch({}, "a")
                                    local cnt = 0
                                    while row do
                                        assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                        row = cursor:fetch({}, "a")
                                        cnt = cnt+1
                                    end
                                end
                            end

                            if row.name:match('�����') then                                                                                              -- ���� ��������� �������: ������ �����
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                                info_2 = ('������ �����. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('�������') then                                                                                            -- ���� ��������� �������: ������ �������
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                                info_2 = ('������ ��������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239035'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('�������') then                                                                                            -- ���� ��������� �������: ������� �� �����������
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                              --assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                                info_2 = ('���������� �� ����������� �����. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239045'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('������') then                                                                                             -- ���� ��������� �������: ������ � ������ ������
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                                info_2 = ('�������� � ������ ������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239046'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('������') then                                                                                             -- ���� ��������� �������: ������ � ������ ������
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                                info_2 = ('��������� �������. \n\n���� ����������: '..date..' \n����� ����������: '..time..'\n\n������ �������: '..row.autor..'\n�������� ������: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239048'
                                sendvkmsgtest(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end
                        end
                    end

                    if button == 0 then
                        zammenu()
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������� ������� ----------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 2 then
                    local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                    local date = os.date('%d.%m.%Y')
                    local datetime = (date..' '..time)
                    local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    local who_nick = sampGetPlayerNickname(who_id)
                    local who_add = (who_nick..' ['..who_id..']')

                    local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by id DESC"))
                    local row = cursor:fetch({}, "a")
                    local list = ''
                    local cnt = 0
                    
                    while row do                                                                                 
                        cnt = cnt+1
                        list = row.name..' {FF8C00}'..row.nick..' {FFD700}| '..row.autor..'\n'..list
                        row = cursor:fetch({}, "a")
                    end

                    zadlist(logo, list)
                    while sampIsDialogActive(9999) do wait(100) end
                    local result, button, list, input = sampHasDialogRespond(9999)

                    for i=0, cnt-1  do
                        if button == 1 and list == i then
                            
                            local cursor = assert(conn:execute("SELECT * FROM zadlist WHERE id = '"..i.."'"))
                            local row = cursor:fetch({}, "a")
                            while row do
                                --assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '-', '-', '-')"))
                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..i.."'"))
                                row = cursor:fetch({}, "a")
                            end
                            
                            local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                            local row = cursor:fetch({}, "a")
                            local cnt = 0
                            while row do
                                assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                row = cursor:fetch({}, "a")
                                cnt = cnt+1
                            end

                            sampAddChatMessage('������� �������',-1)
                        end
                    end

                    if button == 0 then
                        zammenu()
                    end
                end

                -----------------------------------------------------------------------------------
                -- ������� ���������� ������� -----------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 4 then
                    local cursor = assert(conn:execute("SELECT * FROM history ORDER by uid ASC"))
                    local row = cursor:fetch({}, "a")
                    info = ''

                    while row do
                        info = '{87CEFA}'..row.datetime.. ' {FF8C00}' ..row.who_nick.. ' {87CEFA}�������� �������: {FF8C00}'..row.zadanie..' '..row.nick..' {87CEFA}�������: {FF8C00}'..row.reason..' {87CEFA}| {FF8C00}'..row.autor..' \n'..info
                        row = cursor:fetch({}, "a")
                    end

                    sampShowDialog(0, "{FFA500}������� ������ � ���������", info, "�������", "", DIALOG_STYLE_MSGBOX)
                    while sampIsDialogActive(0) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(0)

                    if button == 0 or button == 1 then
                        zammenu()
                    end
                end
            end

            -----------------------------------------------------------------------------------
            -- ��������� ������� --------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 16 then
                zammenu_service()
                while sampIsDialogActive(9000) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(9000)
                
                -----------------------------------------------------------------------------------
                -- ��������� ������ ���������� ----------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 0 then
                    sampAddChatMessage('��������� ������ �������� ����������', -255)
                    upd()
                end

                -----------------------------------------------------------------------------------
                -- ������ ��������� � ������ ------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 1 then
                    sampShowDialog(0, '{FFA500}��������� � ������ {7CFC00}'..thisScript().version, update_list, '�������', '', DIALOG_STYLE_MSGBOX)
                    while sampIsDialogActive(0) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(0)
                    if button == 0 then
                        zammenu()
                    end
                end

                -----------------------------------------------------------------------------------
                -- ����� AFK ----------------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 3 then
                    if afk then
                        afk = false
                        sampAddChatMessage('����� AFK ��������.', -255)
                    else
                        afk = true
                        sampAddChatMessage('{90EE90}������� ����� AFK. ����� 30 ������ ���� ������ ����� ���������.', 0x90EE90)
                        sampAddChatMessage('{90EE90}�� 5 ����� �� ��������� �������� ��� ����� ��������� ������� /rec.', 0x90EE90)
                        sampAddChatMessage('{90EE90}����� �������� ������������� ������ ��������� � ������� � ���� �������.', 0x90EE90)
                        sampAddChatMessage('{90EE90}��� ���������� ������� ������� � ��������� ���� � ����������� �����.', 0x90EE90)
                        lua_thread.create(function()
                            if afk then
                                sampAddChatMessage('{90EE90}�� ����� � ����� AFK ��������: {FFFFFF}30 ������', 0x90EE90)
                                wait(1000*15)
                            end
                            if afk then                                
                                sampAddChatMessage('{90EE90}�� ����� � ����� AFK ��������: {FFFFFF}15 ������', 0x90EE90)
                                wait(1000*5)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}�� ����� � ����� AFK ��������: {FFFFFF}10 ������', 0x90EE90)
                                wait(1000*5)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}�� ����� � ����� AFK ��������: {FFFFFF}5 ������', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}�� ����� � ����� AFK ��������: {FFFFFF}4 �������', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}�� ����� � ����� AFK ��������: {FFFFFF}3 �������', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}�� ����� � ����� AFK ��������: {FFFFFF}2 �������', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}�� ����� � ����� AFK ��������: {FFFFFF}1 �������', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}������ � ����� AFK �� ��������� �������� ���.', 0x90EE90)
                                wait(1000)
                                sampSetGamestate(GAMESTATE_DISCONNECTED)
                                sampDisconnectWithReason(0)
                                sampAddChatMessage('', 0x90EE90)
                                sampAddChatMessage('{90EE90}�������� ���� � ����� ���.', 0x90EE90)
                                sampAddChatMessage('{90EE90}������� {FFFFFF}19:55:00 {90EE90}��� ������ �� ������.', 0x90EE90)
                                sampAddChatMessage('', 0x90EE90)
                            end
                        end)
                    end
                    zammenu()
                end

                -----------------------------------------------------------------------------------
                -- ������ ��������� ---------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 4 then
                    if fd_helper then
                        fd_helper = false
                        fd_find_fire = false
                        sampAddChatMessage('{90EE90}������ ��������� ������������ {FFA07A}��������.', 0x90EE90)
                    else
                        fd_helper = true
                        lua_thread.create(function()
                            sampAddChatMessage('{90EE90}������ ��������� ������������ {7CFC00}�������.', 0x90EE90)
                            sampAddChatMessage('{90EE90}����� ������������� ������� ������ ������������� ���������� ��������� ��.', 0x90EE90)
                            sampAddChatMessage('{90EE90}���� ����������� �� ����� ���������, ��������� �� ����� �� ����������.', 0x90EE90)
                            sampAddChatMessage('{90EE90}�� ��������� ������ �� �������� ���� ����������: ', 0x90EE90)
                            sampAddChatMessage('{90EE90}������� ������������ / ����� ������ / ����� ��������� / ������� ����������', 0x90EE90)
                            sampAddChatMessage('{7FFFD4}��� ��������� ������� ���������� ������������ �������: {ffa000}/ftime', 0x7FFFD4)
                        end)
                    end
                    zammenu()
                end

                -----------------------------------------------------------------------------------
                -- PAYDAY � �������� --------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 5 then
                    if tlg_send then
                        tlg_send = false
                        assert(conn:execute("UPDATE clients SET tlg_id = 0 WHERE nick = '"..who_nick.."'"))
                        sampAddChatMessage('{90EE90}����������� � �������� � ��������� PAYDAY {FFA07A}���������.', 0x90EE90)
                    else
                        idtlg()
                        while sampIsDialogActive(3000) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(3000)

                        if button == 1 then
                            tlg_send = true
                            tlg_id = input
                            assert(conn:execute("UPDATE clients SET tlg_id = '"..tlg_id.."' WHERE nick = '"..who_nick.."'"))
                            sampAddChatMessage('{90EE90}����������� � �������� � ��������� PAYDAY {7CFC00}��������.', 0x90EE90)
                            sampAddChatMessage('{90EE90}����������� ����� ��������� �� {ffa000}id'..tlg_id, 0x90EE90)
                        end

                    end
                    zammenu()
                end

                -----------------------------------------------------------------------------------
                -- ������� �������������� ������ +10% ---------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 7 then
                    sampProcessChatInput('/r ��������� ����������, ����� ��������� ��������...',-1)
                    wait(1000)
                    sampProcessChatInput('/r � ���� ��������� ��� � ���, ��� ����� � ����������...',-1)
                    wait(1000)
                    sampProcessChatInput('/r � ������� ����� ���������.',-1)
                    wait(1000)
                    sampProcessChatInput('/r ����� ��������� ����������� ��� ������������...',-1)
                    wait(1000)
                    sampProcessChatInput('/r � ������� �����. ���� ������� ��� �� ����...',-1)
                    wait(1000)
                    sampProcessChatInput('/r ����� ��������� �������������� ����.',-1)
                    wait(1000)
                    sampProcessChatInput('/r ����� � ���������� ����� ������ �� � ������� �����.',-1)
                    wait(1000)
                    sampProcessChatInput('/r �� ��������� ��������� �������������� ���������, ���������� ��� �����������....',-1)
                    wait(1000)
                    sampProcessChatInput('/r ... � ������ �������, ������������ �� ����������� ������� ������������.',-1)
                    wait(1000)
                    sampProcessChatInput('/r � ���������, ������������ ��������� ������������ - '..nick_fire..'.',-1)
                    wait(1000)
                    sampProcessChatInput('/r ������� ��� ���������� ��� ����������.',-1)
                    wait(1000)
                    sampProcessChatInput('/r ������� ������!',-1)
                    wait(3000)
                    sampProcessChatInput('/d [FD] - [ALL]: ��������� �������, ����� ��������� ��������...', -1)
                    wait(1000)
                    sampProcessChatInput('/d [FD] - [ALL]: � ����� ������������� �������� �������, ������� ������� �� ������� �������...', -1)
                    wait(1000)
                    sampProcessChatInput('/d [FD] - [ALL]: ������� ��������� �� ���������� �������������. ', -1)
                    wait(1000)
                    sampProcessChatInput('/d [FD] - [ALL]: ��������� ������������ ������ �������� ���������...', -1)
                    wait(1000)
                    sampProcessChatInput('/d [FD] - [ALL]: � ����� ��������� ����������� ��������� �������������...', -1)
                    wait(1000)
                    sampProcessChatInput('/d [FD] - [ALL]: � ������� ������� �������� ������ ������.', -1)
                    wait(1000)
                    sampProcessChatInput('/d [FD] - [ALL]: � ���� �� ���� ��, ��������� �� ��������.', -1)
                    wait(1000)
                    sampProcessChatInput('/d [FD] - [ALL]: � ���������, ������������ ��������� ������������ - '..nick_fire, -1)
                end

                -----------------------------------------------------------------------------------
                -- ����������� ���������� �� ������� ----------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 8 then
                    local list = ''
                    local cnt = 0
                    local week_stats = 0
                    local day_stats = 0
                    local week_number = os.date("%W")+1
                    local day_number = os.date("%d")

                    local give_firestats = assert(conn:execute("SELECT *, DATE_FORMAT(date, '%d.%m.%Y') AS date, WEEK(date,1) AS week FROM firehelp_history WHERE nick = '"..who_nick.."' AND active = 1 ORDER by id ASC LIMIT 20"))
                    local row = give_firestats:fetch({}, "a")

                    local give_day_stats = assert(conn:execute("SELECT * FROM firehelp_history WHERE nick = '"..who_nick.."' AND DATE_FORMAT(date, '%d') = '"..day_number.."' AND active = 1"))
                    local rown = give_day_stats:fetch({}, "a")

                    local give_week_stats = assert(conn:execute("SELECT * FROM firehelp_history WHERE nick = '"..who_nick.."' AND WEEK(date,1) = '"..week_number.."' AND active = 1"))
                    local rowt = give_week_stats:fetch({}, "a")

                    while rowt do
                        week_stats = week_stats + rowt.give
                        rowt = give_week_stats:fetch({}, "a")
                    end

                    while rown do
                        day_stats = day_stats + rown.give
                        rown = give_day_stats:fetch({}, "a")
                    end

                    
                    while row do
                        cnt = cnt+1

                        if row.lvl == '0' then lvl_fire = ('{FFFFFF}'..row.lvl..' c������{20B2AA}') end
                        if row.lvl == '1' then lvl_fire = ('{FFA500}'..row.lvl..' c������{20B2AA}') end
                        if row.lvl == '2' then lvl_fire = ('{FF7F50}'..row.lvl..' c������{20B2AA}') end
                        if row.lvl == '3' then lvl_fire = ('{CD5C5C}'..row.lvl..' c������{20B2AA}') end

                        list = "{20B2AA}����� "..row.date.." � "..row.time_start..' '..lvl_fire..' {FFFFFF}| {20B2AA}������� � '..row.time_end..' {FFFFFF}| {20B2AA}�����: {F0E68C}+$'..row.give.. ' ['..string.format("%2.1f", row.give/1000000)..'�]'..'\n'..list
                        row = give_firestats:fetch({}, "a")
                    end

                    sampShowDialog(0, "{FFA500}���������� �� �������", "{d5a044}���������� �� ��������� �����: {FFFFFF}+$"..give.. " ["..string.format("%2.1f", give/1000000).."�]"..
                                                                       "\n"..
                                                                       "\n{d5a044}���������� �� �������: {FFFFFF}+$"..day_stats.. " ["..string.format("%2.1f", day_stats/1000000).."�] "..
                                                                       "\n{d5a044}���������� �� ������: {FFFFFF}+$"..week_stats.. " ["..string.format("%2.1f", week_stats/1000000).."�] "..
                                                                       "\n{d5a044}���������� �����: {FFFFFF}+$"..stats.. " ["..string.format("%2.1f", stats/1000000).."�]"..
                                                                       "\n"..
                                                                       "\n{d5a044}��� ������� ���� ���������� ������� ������� {FF6347}/fclean {E9967A}(��� ���������� ����� ��������)"..
                                                                       "\n"..
                                                                       "\n{AFEEEE}���������� �� ��������� 20 �������:"..
                                                                       "\n"..list, 
                                      "�������", "")
                end

                -----------------------------------------------------------------------------------
                -- �������� � ����������� ---------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 10 then
                    sampShowDialog(0, "{FFA500}FAQ �� ������ � ��������", "{ffa000}��������� �������:"..
                        "\n\t{7CFC00}/zam {7FFFD4}- ������� ������ ������������ ��������� ������������"..
                        "\n\t{7CFC00}/ftime {7FFFD4}- ���������� ����� ���������� ������"..
                        "\n\t{7CFC00}/stime {7FFFD4}- ������ ������� � �������� � �������� �� ����� ����������"..
                        "\n\t{7CFC00}/new [id] {7FFFD4}- �������� ���������� � ������ ������������ ������ �����������"..
                        "\n\t{7CFC00}/del [id] {7FFFD4}- ������� ���������� �� ������ ������������ ������ �����������"..
                        "\n\t{7CFC00}/afk {7FFFD4}- ����������� ���� � ����� ��� �� ����� �������� ���"..
                        "\n\n{FFA07A}���������� � ������ �������.",
                        "�������", "", DIALOG_STYLE_MSGBOX)
                end

                if button == 0 then
                    zammenu()
                end
            end

            if button == 0 then
                sampCloseCurrentDialogWithButton(0)
            end
        end

        if os.date('%M:%S') == "05:00" or os.date('%M:%S') == "25:00" or os.date('%M:%S') == "45:00" then
            upd()
            wait(1000)
        end
    end
end

-- function JSONSave()
--     if doesFileExist("moonloader/firedep_zam_helper/data.json") then
--         local f = io.open("moonloader/firedep_zam_helper/data.json", 'w+')
--         if f then
--             f:write(encodeJson(config)):close()
--         end
--     end
-- end

function zammenu_service()
    
    if afk then afk_status = '{00FF7F}[�������]' else afk_status = '{FFA07A}[��������]' end
    if fd_helper then fd_helper_status = '{00FF7F}[�������]' else fd_helper_status = '{FFA07A}[��������]' end
    if tlg_send then tlg_status = '{00FF7F}[���������]' else tlg_status = '{FFA07A}[�� ���������]' end

    sampShowDialog(9000, "��������� ����", "��������� ������� ���������� �������"..
                                           "\n������ ��������� � ���������� {7CFC00}"..thisScript().version..
                                           "\n "..
                                           "\n����� AFK �� ����� �� "..afk_status..
                                           "\n������ ��������� "..fd_helper_status..
                                           "\nPAYDAY � �������� "..tlg_status..
                                           "\n "..
                                           "\n{ffa000}[+10%] {FFFFFF}������� �������������� ������"..
                                           "\n{FFE4B5}����������� ���������� �� �������"..
                                           "\n "..
                                           "\n{7FFFD4}[FAQ] �������� � �����������", '�������', '�����', 2)
end

function zammenu()
    sampShowDialog(1999, "{FFA500}���� ����������� ���������� ��������� ������������", '������ � ��������\n��������� ������ ����������\n�� ��������� (������ / ���������� / �����������)\n \n��������������� ��� � �����\n����������� ��� ��� �������� ��� � �����\n�������� �� ����� ���\n�������\n \n{e9dc7c}�������� �������� ��\n��������� ����� �� ����. �����\n���������� ����� ������\n{00EAFF}��������� � ������ ��\n{00EAFF}��������� � ������ ���-�� ��\n \n���������� �������\n��������� ����', '�������', '������', 2)
end

function zad()
    sampShowDialog(1001, "�������� ������� � �������", "������ �������\n�������� ����������\n������� � �����������\n���������� �����\n������ �������\n������� �� �����������\n������� � �� ���", '�������', '������', 2)
end

function zadmenu()
    sampShowDialog(1000, "{FFA500}���� ������� �������������", '�������� �������\n������ ������� �� ����������\n������� �������\n \n������� ����������', '�������', '������', 2)
end

function zad()
    sampShowDialog(9997, "�������� ������� � �������", "������ �������\n������ ���������\n���������� �����\n������� � ����������� �� ���������", '�������', '������', 2)
end

function addzad(logo,data)
    sampShowDialog(9998, logo, data, '�������', '������', 1)
end

function zadlist(logo,data)
    sampShowDialog(9999, logo, data, '�������', '������', 2)
end

function sostav()
    sampShowDialog(2000, "{FFA500}������ � ��������", string.format("{7ce9b1}������� � �����������\n{7ce9b1}�������� ����������\n{7ce9b1}����� �������\n������ �������\n������ ������� {f18779}(������)\n������� �� �����������\n������� �� ����������� {f18779}(������)\n������ �������� ����\n������ � ������ ������\n������ � ������ ������ {f18779}(������)\n�������� ����������\n{dd3366}������ ������� ������\n������� �� ������� ������\n������� �� ������� ������ {f18779}(������)"), "�������", "������", 2)
end

function inputid()
    sampShowDialog(2001, "{FFA500}Id ������ ��� ��������������", "������� id ������", "������", "������", 1)
end

function idtlg()
    sampShowDialog(3000, "{FFA500}����������� PAYDAY � ������", "{7ce9b1}������� ���� id ���������.\n������ PAYDAY ��� ����� ��������� ���������� ���������.\n\n����� ����, ��� �� ������� ���� id, \n�������� ���-������ ���� {FFA500}@longamesbot {7ce9b1}� ���������� ��� ���������.", "������", "������", 1)
end

function invitereason()
    sampShowDialog(2002, "{FFA500}��� ���������� � �����������", string.format("[1] ���������� �� �������������\n[4] ���������� ����� ������\n \n[1] �� ������������� �����������"), "�������", "������", 2)
end

function inputurl()
    sampShowDialog(2003, "{FFA500}������ �� �����", "������� ������ �� ����� ������", "������", "������", 1)
end

function waitrp(id, nick)
    sampShowDialog(2004, "{FFA500}������������� RP", "{78dbe2}����� ����, ��� ����� {ffa000}"..nick.." ["..id.."]\n{78dbe2}������� � �����������, ������� ���������� ����� ��������� �� ���������", "����������", "������", DIALOG_STYLE_MSGBOX)
end

function inputreason()
    sampShowDialog(2005, "{FFA500}�������� �������:", "������� �������:", "������", "������", 1)
end

function lec()
    sampShowDialog(2006, "{FFA500}������ ��� ������� ��������� ������������", string.format("[RB] ������� ��� ����\n[R] ������ ��� ��� � ����������\n[D] ���������� ��� ������������\n[������] �������� �������� �������� ��� ������ � ������\n�������� ��������� ����\n \n�� ������� ��� �����������"), "�������", "������", 2)
end

function ranklist()
    sampShowDialog(2007, "{FFA500}���������", string.format("[1] ������\n[2] ������� ������\n[3] ������� ��������\n[4] ��������\n[5] ������� ��������\n[6] �������� ���������\n[7] ���������\n[8] �������"), "�������", "������", 2)
end

function inputnick()
    sampShowDialog(2008, "{FFA500}��� ������ ��� ��������������", "������� Nick_Name ������", "������", "������", 1)
end

function rp()
    sampShowDialog(2009, "{FFA500}�� ������� ��� �����������", "������ ���� � ����� ������������\n������ ����� � ����� ������������\n��������� ��������� ������������ � ����� ������������\n��������� ��� ��������� �������� ������ �����\n������������� ������ ������ ���� � ������\n��������� ����� ������ �� ����\n��������� ������ �� ���������� ��������� ������������", "�������", "������", 2)
end

function inputimer()
    sampShowDialog(2010, "{FFA500}����� ��������� �������", "������� �������� ����� ��� �������", "������", "������", 1)
end

function praisecount()
    sampShowDialog(2011, "{FFA500}������ ������� ������", "������� �������� ������ ��� ������", "������", "������", 1)
end

function reason_mute()
    sampShowDialog(2012, "{FFA500}������� ������ ��������", string.format("���� ��������� � �����\n����������� ������\n \n������ �������"), "�������", "������", 2)
end

function reason_fwarn()
    sampShowDialog(2013, "{FFA500}������� ��������", string.format("��������� ������\n������ �������� ���\n��� �� �����\n���������� ����������\n \n������ �������"), "�������", "������", 2)
end

function reason_univite()
    sampShowDialog(2014, "{FFA500}������� ����������", string.format("[���] �� ������������ �������\n[���] ������ ��������� ������\n������� ������ ������\n\n������ �������"), "�������", "������", 2)
end

function reason_blacklist()
    sampShowDialog(2015, "{FFA500}������� �� �����������", string.format("[���] ������ ��������� ������\n������ �� 5��� �����\n������ � ���������\n\n������ �������"), "�������", "������", 2)
end

function inputidorg()
    sampShowDialog(2016, "{FFA500}Id ����������", "������� id ����������, ������������ �������������", "������", "������", 1)
end

function timermenu()
    sampShowDialog(2017, "{FFA500}���� ������� �������", "{E9967A}[5 ���] ������ 5 ����� ��� ���� �� ������\n[1 ���] ������ �� 1 ������\n[3 ���] ������ �� 3 ������\n[5 ���] ������ �� 5 �����\n{6B8E23}[��� �����] {FFFFFF}���������� ������ ��� ������\n{6B8E23}[��� �����] {FFFFFF}���������� ������ ��� ����\n{0ec9d4}[15 ���] {8df2f7}������ �������������", "������", "������", 2)
end

function idhouse()
    sampShowDialog(2018, "{FFA500}Id ����", "������� id ���� ��� ���������", "������", "������", 1)
end

function ocenka()
    sampShowDialog(2019, "{FFA500}������ ��������� ����", "������� ������ ���� �� ���������:", "������", "������", 1)
end

function settag()
    sampShowDialog(2020, "{FFA500}���������� ����� ������", "[TD] Tactical Department\n[ID] Inspection Department\n[DA] Department of Assistance\n[����� ���] ������� ���", "������", "������", 2)
end

function inputdocs()
    sampShowDialog(2021, "{FFA500}������ �� ��������������", "������� ������ �� �������������� ���������: ", "������", "������", 1)
end

function inputmsg()
    sampShowDialog(2022, "{00EAFF}��������� ��������� ��", "������� ��������� ��� ��������: ", "���������", "������", 1)
end
function trst(name)
if name:match('%a+') then
        for k, v in pairs(trstl1) do
            name = name:gsub(k, v) 
        end
        for k, v in pairs(trstl) do
            name = name:gsub(k, v) 
        end
        return name
    end
 return name
end

local code_check = '��� ��� ����������'
local nick = ''
local id = ''

function sampev.onServerMessage(color, text)
    if tlg_send and text:find('__________���������� ���__________') then
        parse = true
        message = (text:gsub("_", "")..'\n')
    elseif tlg_send and text:find('__________________________________') then
        parse = false
        img = 'https://jobers.ru/wp-content/uploads/2024/02/d83cdef6bb49668eee2b55c4f6af1a42.png'
        sendTelegramPhoto(img, message)
        message = ''
    elseif tlg_send and parse then           
        message = ('%s\n%s'):format(message, text)
        message = message:gsub("{......}", "")
    end

    if isGoing and text:find("(%W)R(%W)") then
        local nick = string.match(text,"%a+_%a+")
        if not nick then return sendCmdMsg('���-�� ����� �� ���! ��� ���������:'..text) end
        local nick = string.match(nick,"%a+_%a+")
        if not findInIni(nick) then
            sampAddChatMessage('{7FFFD4}����� ���� �����������! ��� - "'..nick..'"',0x7FFFD4)
            table.insert(mainIni.orgs, nick)
            inicfg.save(mainIni)
        end
    end

    if text:find("� ����� ��������� �����! ���� ��������� (%d+) ������") then
        lua_thread.create(function()
            time_fire = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            next_fire = os.date('%H:%M:%S', os.time() - (UTC * 3600) + (20*60)+1)
        end)
    end

    if text:find("(.+)Update.Ver") then
        lua_thread.create(function()
            local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=0x40E0D0;
                                                                    sampAddChatMessage(b..'���������� ����������. {FA8072}'..thisScript().version..' {40E0D0}�� {7CFC00}'..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then 
                                                                                                                            sampShowDialog(0, "{FFA500}����� ����������", "{FFA500}�������� ������������ ��������� ������������\n{78dbe2}��� ������������� �������� �� ����� ������.\n���������� ��������� ����� � ���� -> ��������� ������� -> ���������", "�������", "", DIALOG_STYLE_MSGBOX)
                                                                    print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
            if updater_loaded then
                autoupdate_loaded, Update = pcall(Updater)
                if autoupdate_loaded then
                    Update.json_url = "https://raw.githubusercontent.com/ArtemyevaIA/firedep_zam_helper/refs/heads/main/firedep_zam_helper.json?" .. tostring(os.clock())
                    Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
                    Update.url = "https://github.com/ArtemyevaIA/firedep_zam_helper"
                end

            end
            if autoupdate_loaded and Update then
                pcall(Update.check, Update.json_url, Update.prefix, Update.url)
            end 
        end)
    end

    if (text:find("(%W)R(%W)(.+)(%a+)_(%a+)(.+)�����") or text:find("(%W)R(%W)(.+)(%a+)_(%a+)(.+)next") or text:find("(%W)R(%W)(.+)(%a+)_(%a+)(.+)Next") or text:find("(%W)R(%W)(.+)(%a+)_(%a+)(.+)�����")) then
            lua_thread.create(function()
                wait(1000)
                sampProcessChatInput('/rb :fire: ��������� ����� � '..next_fire,-1)
            end)
        end

    --if not fd_find_fire and fd_helper and text:find("� ����� ��������� �����! ���� ��������� (%d+) ������") then
    if fd_helper and text:find("� ����� ��������� �����! ���� ��������� (%d+) ������") then
        lua_thread.create(function()
            fd_find_fire = true
            lvl = text:match('� ����� ��������� �����! ���� ��������� (%d+) ������')
            time_fire = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            next_fire = os.date('%H:%M:%S', os.time() - (UTC * 3600) + (20*60)+1)
            sampAddChatMessage('', 0x7FFFD4)
            sampAddChatMessage('��������!!!', 0xDC143C)
            sampAddChatMessage('� ����� ���������� ������������. ������� ���������: {DC143C}'..lvl, 0x7FFFD4)
            sampAddChatMessage('����� ������������: {FFFFFF}'..time_fire, 0x7FFFD4)
            sampAddChatMessage('��������� ������������ �: {FFFFFF}'..next_fire, 0x7FFFD4)
            sampAddChatMessage('', 0x7FFFD4)
            sampProcessChatInput('/time',-1)
            sampProcessChatInput('/fires',-1)
            wait(2000)
            setVirtualKeyDown(VK_RETURN, true) -- ������ �������
            wait(100)
            setVirtualKeyDown(VK_RETURN, false) -- ������ �������
            sampProcessChatInput('/engine',-1)

            sampProcessChatInput('/r ����������� '..nick_fire..': ������� �� ������������ '..lvl.. ' ������� ���������!',-1)             
        end)
    end

    -- if fd_find_fire and fd_helper and text:find("�� ������� �� ����� ������") then
    if text:find("�� ������� �� ����� ������") then
        lua_thread.create(function()
            sampProcessChatInput('/r ����������� '..nick_fire..': ������ �� ����� ������������.',-1)

            local x,y,z = getCharCoordinates(PLAYER_PED) 
            assert(conn:execute("INSERT INTO temp (lvl, x, y, z, nick, fire_place) VALUES ('"..lvl.."', '"..x.."','"..y.."','"..z.."', '"..who_nick.."', '"..fire_place.."')"))

            count = 0
            for _ in pairs(fires_list) do 
                count = count + 1
                dist = getDistanceBetweenCoords3d(x, y, z, fires_list[count][1], fires_list[count][2], fires_list[count][3])
                if dist <= 100 then
                    sampAddChatMessage("�� ������� �� ����� "..fires_list[count][4].. " ������� ���������", -255)
                end
            end
        end)
    end

    -- if fd_find_fire and fd_helper and text:find("�������� ������������� � �������") then
    if fd_helper and text:find("�������� ������������� � �������") then
        lua_thread.create(function()
            sampProcessChatInput('/r ����������� '..nick_fire..': �������� ������ �������������.',-1)
        end)
    end

    -- if fd_find_fire and fd_helper and text:find("�������! �� ������ �������������!") then
    if fd_helper and text:find("�������! �� ������ �������������!") then
        lua_thread.create(function()
            sampProcessChatInput('/r ����������� '..nick_fire..': ������������� ������� ������ ������.',-1)
        end)
    end

    -- if fd_find_fire and fd_helper and text:find("��� ����� ���������� �������������.") then
    if fd_helper and text:find("��� ����� ���������� �������������.") then
        lua_thread.create(function()
            sampProcessChatInput('/r ����������� '..nick_fire..': ��� ����� ���������� �������������.',-1)
        end)
    end

    -- if fd_find_fire and fd_helper and text:find("�� ���������� �� ������������ {90EE90}$(%d+)") then
    if fd_helper and text:find("�� ���������� �� ������������ {90EE90}$(%d+)") then
        lua_thread.create(function()
            wait(1000)
            sampProcessChatInput('/r ����������� '..nick_fire..': ����� ������� ������������. ����������� �� ����.',-1)
            time_end = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            give = text:match('�� ���������� �� ������������ {90EE90}$(%d+)')
            firedate = os.date('%Y-%m-%d')
            wait(2000)
            sampAddChatMessage('', 0x7FFFD4)
            sampAddChatMessage('{7FFFD4}������������ {DC143C}'..lvl..' ������� {7FFFD4}�������������', 0x7FFFD4)
            sampAddChatMessage('{7FFFD4}��������� ������������ �: {DC143C}'..next_fire,0x7FFFD4)
            sampAddChatMessage('{7FFFD4}���������� �� ������������: {26fc66}$'..give.. ' ['..string.format("%2.1f", give/1000000)..'�]', 0x7FFFD4)
            sampAddChatMessage('', 0x7FFFD4)
            sampProcessChatInput('/time',-1)
            sampShowDialog(0, "{FFA500}���������� ������", "{8eeaf0}����� {d54447}" ..lvl.. " ������� {8eeaf0}��� ������������.\n\n{8eeaf0}����� ������: {d5a044}" ..time_fire.. "\n{8eeaf0}����� ����������: {d5a044}" ..time_end.. "\n{8eeaf0}�����: {d5a044}+ $"..give.. " ["..string.format("%2.1f", give/1000000).."�]", "�������", "", DIALOG_STYLE_MSGBOX)
            fd_find_fire = false

            assert(conn:execute("INSERT INTO firehelp_history (lvl, nick, give, time_start, time_end, date, active) VALUES ('"..lvl.."', '"..who_nick.."', '"..give.."', '"..time_fire.."', '"..time_end.."', '"..firedate.."', '1')"))
            assert(conn:execute("UPDATE firehelp SET give = '"..give.."', stats = stats+'"..give.."' WHERE nick = '"..who_nick.."'"))
            stats = stats+give

        end)
    end


    if afk and text:find('(.+)������ �� �������� ���� �� �� �� �����/���������(.+)') then
        lua_thread.create(function()
            wait(1000)
            runToJob()
            wait(3000)
            runToCorner()
            afk = false
        end)
    end

    if text:find('(.+)����������� ���������� Irin_Crown(.+)�������� ������������� � ���� �����������') then
        local time_sobes = text:match('�� (%A+)!')
        id = sampGetPlayerIdByNickname('Irin_Crown')
        img = 'photo-232454643_456239042'
        sendvkimg(encodeUrl('��������� ������������� �� '..time_sobes.. '\n\n������������� ��������� 15 �����. � ��� ���� ����������� ��������������� � ������������ �����, ����������� ��� ��������� ��� ��������� �������.\n\n������������� ��������: Irin_Crown ['..id..']'),img)
    end

    if text:find('������') then
        lua_thread.create(function()
            inspect = 1
        end)
    end

    if text:find('��������') then
        lua_thread.create(function()
            inspect = 0
        end)
    end

    if text:find('!end') then
        lua_thread.create(function()
            sampProcessChatInput('/do ������������� ��������.',-1)
            wait(2000)
            sampProcessChatInput('/time',-1)
            sampShowDialog(0, "������������� ��������", "{78dbe2}����� ���������� ������������� {FFA500}��������.", "���������", "�������", DIALOG_STYLE_MSGBOX)
            img = 'photo-232454643_456239044'
            sendvkimg(encodeUrl('������������� ��������.'),img)
        end)
    end

    if sobes_start and text:find('������� � �������� �����������') then
        lua_thread.create(function()
            sobes_start = false
            wait(1000)
            sampProcessChatInput('/do ������������� ������.',-1)
            wait(1000)
            local timer = 15
            local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
            img = 'photo-232454643_456239043'
            sendvkimg(encodeUrl('������������� ������ � ��������� 15 �����.'),img)
            sampAddChatMessage('{FFFFFF}������ �������������. ����� ������������� {FFA500}'..timer..' �����',-1)
            sampAddChatMessage('{FFFFFF}������� � {FFA500}'..time,-1)
            sampAddChatMessage('{FFFFFF}����� ���������: {FFA500}'..timeend,-1)
            sampProcessChatInput('/time',-1)
            sampShowDialog(0, "������ �������������", "{78dbe2}������������� ������ � {FFA500}"..time.."\n\n{78dbe2}����� �������������: {FFA500}"..timer.." {78dbe2}���.\n����� ���������: {FFA500}"..timeend, "�������", "", DIALOG_STYLE_MSGBOX)
            wait(1000*60*timer)
            sampProcessChatInput('/do ������������� ��������.',-1)
            wait(2000)
            sampProcessChatInput('/time',-1)
            sampShowDialog(0, "������������� ��������", "{78dbe2}����� ���������� ������������� {FFA500}��������.", "���������", "�������", DIALOG_STYLE_MSGBOX)
            
            while sampIsDialogActive(0) do wait(100) end
            local result, button, _, input = sampHasDialogRespond(0)
            if button == 1 then
                img = 'photo-232454643_456239044'
               sendvkimg(encodeUrl('����� ���������� ������������� ��������.'),img)
            end
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)���(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb ��������� '..nm..", ��������� � /r ��� - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb ����� �������� ���� � /r, �� ������ ������������� �������.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)���(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb ��������� '..nm..", ��������� � /r ��� - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb ����� �������� ���� � /r, �� ������ ������������� �������.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)���(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb ��������� '..nm..", ��������� � /r ��� - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb ����� �������� ���� � /r, �� ������ ������������� �������.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)����(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb ��������� '..nm..", ��������� � /r ��� - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb ����� �������� ���� � /r, �� ������ ������������� �������.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)����(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb ��������� '..nm..", ��������� � /r ��� - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb ����� �������� ���� � /r, �� ������ ������������� �������.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+):(%s)'..code_check) and string.match(text,"%a+_%a+") == nick then
        lua_thread.create(function()
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)

            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))
            local nm = trst(nick)

            wait(1000)
            sampProcessChatInput('/r ��������� '..nm..' ����� �������� ���. ���������� �� ������!', -1)
            wait(1000)
            sampProcessChatInput('/do ��� ����� �� �����.', -1)
            wait(1000)
            sampProcessChatInput('/me ���� ��� � ����� � ������� ���', -1)
            wait(1000)
            sampProcessChatInput('/do ��� �������.', -1)
            wait(1000)
            sampProcessChatInput('/me ����� � ���� ������ �����������', -1)
            wait(1000)
            sampProcessChatInput('/me ����� ������� ���������� � ������� �� ���� ������', -1)
            wait(1000)
            sampProcessChatInput('/me ��������� ���� �� ����������� ������ '..nm, -1)
            wait(1000)
            sampProcessChatInput('/time', -1)
            wait(2000)
            sampProcessChatInput('/checkjobprogress '..id, -1)
            wait(2000)
            sampProcessChatInput('/me �������� ��� � ������� �� ����', -1)
            wait(1000)
            sampProcessChatInput('/do ��� ����� �� �����.', -1)
            wait(1000)
            sampProcessChatInput('/me ������������ ����� ������������ ���������� '..nm, -1)
            wait(1000)
            sampProcessChatInput('/uninvite '..id..' ���', -1)
            wait(2000)
            sampProcessChatInput('/r ��������� '..nm..' ��� ������ �� ����������� �� �������: �C� (�������).',-1)
            wait(1000)
            sampProcessChatInput('/time ',-1)
            sampShowDialog(0, "{FFA500}���������� ����������", "{78dbe2}���������: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}���� ����������: {ffa000}"..date.."\n{78dbe2}����� ����������: {ffa000}"..time.."\n\n{78dbe2}������� ����������: {ffa000}��� (�������)", "�������", "", DIALOG_STYLE_MSGBOX)

            
            lfs.mkdir('moonloader/firedep_zam_helper/������ � ����������� ������/���������/'..date.. ' ' ..timed.. ' ' ..nick.. ' (uninvite-auto)')
            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
            file:write('[�������������� ���������� ���������� �� �����������]. ���������: '..nick.. ' ['..id..'] ���� ����������: '..date..' ����� ����������: '..time..' �������: ���-�������������\n') --����� ������ ����� ���������� ����
            file:close()

            info = ('�������������� ���������� ���. \n\n���������: '..nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..'\n�������: ��� (�������������).\n��� ��� ����������: '..code_check)
            sendvkimg(encodeUrl(info),img)
        end)
    end
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
        return -1
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    if start_sobes then
        if id == 1214 then
            sampSendDialogResponse(1214, 1, 7, nil)
            sampSendDialogResponse(1336, 1, 0, nil)
            sampSendDialogResponse(1335, 1 , nil, sobes)
            return false
        end
        start_sobes = false
    end

    if afk and id == 25527 then
        if title:find("����� ����� ������") then 
            if text:find("��������� ����� ������") then
                sampSendDialogResponse(id, 1, 4, nil)
                sampProcessChatInput('/fires',-1)
                sampProcessChatInput('/fires',-1)
                sampProcessChatInput('/fires',-1)
                return false
            end
            sampSendDialogResponse(id, 1, 3, nil)
            sampProcessChatInput('/fires',-1)
            sampProcessChatInput('/fires',-1)
            sampProcessChatInput('/fires',-1)
            return false
        end
    end

    if afk and id == 27263 then
        if title:find("����������") then
            changedesk = false
            sampSendDialogResponse(id, 1, 0, nil)
            return false -- ������� ������� ����
        end
    end

    if flashminer then
        if id == 7238 then
            lua_thread.create(function()
                wait(2000)
                sampSendDialogResponse(7238, 1, 0, nil)
                
                    ----------------------------------------
                    -- ������ �1 ---------------------------
                    -- ���������� �1-4 ---------------------
                    ----------------------------------------
                    wait(100) sampSendDialogResponse(25182, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 2, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 3, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 4, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)

                    ----------------------------------------
                    -- ������ �2 ---------------------------
                    -- ���������� �5-8 ---------------------
                    ----------------------------------------
                    wait(100) sampSendDialogResponse(25182, 1, 7, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 8, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 9, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 10, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)

                    ----------------------------------------
                    -- ������ �3 ---------------------------
                    -- ���������� �9-12 --------------------
                    ----------------------------------------
                    wait(100) sampSendDialogResponse(25182, 1, 13, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 14, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 15, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 16, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)

                    ----------------------------------------
                    -- ������ �4 ---------------------------
                    -- ���������� �13-16 -------------------
                    ----------------------------------------
                    wait(100) sampSendDialogResponse(25182, 1, 19, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 20, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 21, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 22, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    
                    ----------------------------------------
                    -- ������ �5 ---------------------------
                    -- ���������� �17-20 -------------------
                    ----------------------------------------
                    wait(100) sampSendDialogResponse(25182, 1, 25, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 26, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 27, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)
                    wait(100) sampSendDialogResponse(25182, 1, 28, nil) wait(10) sampSendDialogResponse(25245, 1, 1, nil) wait(10) sampSendDialogResponse(25246, 1, 1, nil) wait(10) sampSendDialogResponse(25245, 0, 0, nil)

                    -- ��������
                    wait(1000) sampSendDialogResponse(25182, 0, 0, nil)
                    wait(1000) sampSendDialogResponse(7238, 0, 0, nil)
                    wait(500) setVirtualKeyDown(VK_ESCAPE, true)
                    wait(100) setVirtualKeyDown(VK_ESCAPE, false)
            end)
            return 
        end
        flashminer = false
    end

    if id == 25959 then
        title = title:gsub('{......}', '')
        setClipboardText(title)
        sampAddChatMessage("��� ���������� ��� �������������� � ����� ������: {FFFFFF}"..title, -255)
    end 

    if dialogId == 27259 then
        text = text:match('* ](%A+)')
        place = text:gsub('{(.+)', '')
        fire_place = place:gsub('{', '')
    end
end

function encodeUrl(str)
   str = str:gsub(' ', '%+')
   str = str:gsub('\n', '%%0A')
   return u8:encode(str, 'CP1251')
end

function threadHandle(runner, url, args, resolve, reject) -- ��������� effil ������ ��� ����������
    local t = runner(url, args)
    local r = t:get(0)
    while not r do
        r = t:get(0)
        wait(0)
    end
    local status = t:status()
    if status == 'completed' then
        local ok, result = r[1], r[2]
        --if ok then resolve(result) else reject(result) end
    elseif err then
        reject(err)
    elseif status == 'canceled' then
        reject(status)
    end
    t:cancel(0)
end

function requestRunner() -- �������� effil ������ � �������� https �������
    return effil.thread(function(u, a)
        local https = require 'ssl.https'
        local ok, result = pcall(https.request, u, a)
        if ok then
            return {true, result}
        else
            return {false, result}
        end
    end)
end

function async_http_request(url, args, resolve, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        threadHandle(runner, url, args, resolve, reject)
    end)
end

local vkerr, vkerrsend -- ��������� � ������� ������, nil ���� ��� ��

function loop_async_http_request(url, args, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        while true do
            while not key do wait(0) end
            url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --������ url ������ ����� ������ �����a, ��� ��� server/key/ts ����� ����������
            threadHandle(runner, url, args, longpollResolve, reject)
        end
    end)
end
function sendvkmsg(msg)
math.randomseed(os.time())
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000003
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&access_token='..token2..'&v=5.81')
end

function sendvkmsgtest(msg,img)
    math.randomseed(os.time())
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000003
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&attachment='..img..'&access_token='..token2..'&v=5.81')
end

function sendvkimg(msg,img)
    math.randomseed(os.time())
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000002
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&attachment='..img..'&access_token='..token2..'&v=5.81')
end
function sendvkimg_test(msg,img)
    math.randomseed(os.time())
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000001
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&attachment='..img..'&access_token='..token2..'&v=5.81')
end

function vkmsg(msg)
    math.randomseed(os.time())
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000002
    -- local peer_id = 2000000001
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&access_token='..token2..'&v=5.81')
end

function upd()
   local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=0x40E0D0;
                                                           sampAddChatMessage(b..'���������� ����������. {FA8072}'..thisScript().version..' {40E0D0}�� {7CFC00}'..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then 
                                                                                                                   sampShowDialog(0, "{FFA500}����� ����������", "{FFA500}�������� ������������ ��������� ������������\n{78dbe2}��� ������������� �������� �� ����� ������.\n���������� ��������� ����� � ���� -> ��������� ������� -> ���������", "�������", "", DIALOG_STYLE_MSGBOX)
                                                           print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
   if updater_loaded then
       autoupdate_loaded, Update = pcall(Updater)
       if autoupdate_loaded then
           Update.json_url = "https://raw.githubusercontent.com/ArtemyevaIA/firedep_zam_helper/refs/heads/main/firedep_zam_helper.json?" .. tostring(os.clock())
           Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
           Update.url = "https://github.com/ArtemyevaIA/firedep_zam_helper"
       end

   end
   if autoupdate_loaded and Update then
       pcall(Update.check, Update.json_url, Update.prefix, Update.url)
   end 
end

-- ����� ������ � ����
function runToCorner(tox, toy)
    local tox = -1282.1599
    local toy = -45.0525
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    end
end

-- ����� ����������� � �����
function runToJob(tox, toy)
    local tox, toy = -1290.1544, -48.5959
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    end

    local tox, toy = -1289.7994, -45.7143
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    end

    local tox, toy = -1288.4854, -45.5982
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    end
end

function getpoyas()
    timepc = os.date('%H:%M:%S')
    timeserver = os.date('%H:%M:%S', os.time() - (UTC * 3600))
    info = os.date("%z",os.time()) .. "\t" ..os.offset()
    info = info:gsub('0', '')
    info = info:gsub('+', '')
    return info
end

function stime()
    tt = os.date('%H:%M:%S', os.time() - (UTC * 3600))
    sampAddChatMessage('', -255)
    sampAddChatMessage('������� ����: {FFFFFF}+'..UTC..' ���', -255)
    sampAddChatMessage('����� �� ��: {FFFFFF}'..timepc, -255)
    sampAddChatMessage('����� �� �������: {FFFFFF}'..tt, -255)
    sampAddChatMessage('', -255)
end

function os.offset()
   local currenttime = os.time()
   local datetime = os.date("*t",currenttime)
   datetime.isdst = true -- ���� �������� ������� �����
   return currenttime - os.time(datetime)
end

function findInIni(nick) for _,v in pairs(mainIni.orgs) do if v == nick then return _ end end return false end

function co()
    showorgs = not showorgs
end

function ss()
    send = true
end

function coc()
    showorg = not showorg
end


function switchMod()
    isGoing = not isGoing
    sampAddChatMessage(((isGoing and "{7FFFD4}����� ��������� ���� �����������") or "{7FFFD4}������ �� ����� ��������� ������ �����������"),0x7FFFD4)
end

function neworg(arg)
    local nick = arg
    if type(tonumber(arg)) == 'number' then nick = sampGetPlayerNickname(arg) end
    local found = findInIni(nick)
    if not found then
        sampAddChatMessage('{7FFFD4}����� ���� �����������! ��� - {FFFFFF}'..nick,0x7FFFD4)
        table.insert(mainIni.orgs, nick)
        inicfg.save(mainIni)
    else
        sampAddChatMessage('{7FFFD4}���� ����������� {FFFFFF}'..nick..' {7FFFD4}��� ����������!',0x7FFFD4)
    end
end

function delorg(arg)
    if arg ~= '' then
        local nick = arg
        if type(tonumber(arg)) == 'number' then nick = sampGetPlayerNickname(arg) end
        local found = findInIni(nick)
        if not found then return sampAddChatMessage('{7FFFD4}���� ����������� {FFFFFF}'..arg..' {7FFFD4}�� ������!',0x7FFFD4) end
        arg = found
    else
        arg = #mainIni.orgs
    end
    sampAddChatMessage('{7FFFD4}���� ����������� {FFFFFF}'..mainIni.orgs[arg]..' {7FFFD4}�����!',0x7FFFD4)
    table.remove(mainIni.orgs, arg)
    inicfg.save(mainIni)
end

function sendTelegramPhoto(img, msg) -- ������� ��� �������� ��������� �����
   msg = msg:gsub('{......}', '') --��� ���� ������� ����
   msg = encodeUrl(msg) -- �� ��� �� ���������� ������
   token = '8059436647:AAFSZNM3lfxxJ5E2jFkE_D_N9iWlLdBD-ss'
   --id = '5700686218'
   async_http_request('https://api.telegram.org/bot'..token..'/sendPhoto?chat_id='..tlg_id..'&caption='..msg,'&photo='..img..'', function(result) end) -- � ��� ��� ��������
end

function flashmine ()
    flashminer = true 
    sampAddChatMessage('������� �������� ��������', -255)
    sampProcessChatInput('/flashminer', -1)
end