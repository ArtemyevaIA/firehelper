script_name("firedep_zam_helper")
script_version("Ver.FH.06")

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

local trstl = {['B'] = 'Б',['Z'] = 'З',['T'] = 'Т',['Y'] = 'Й',['P'] = 'П',['J'] = 'Дж',['X'] = 'Кс',['G'] = 'Г',['V'] = 'В',['H'] = 'Х',['N'] = 'Н',['E'] = 'Е',['I'] = 'И',['D'] = 'Д',['O'] = 'О',['K'] = 'К',['F'] = 'Ф',['y`'] = 'ы',['e`'] = 'э',['A'] = 'А',['C'] = 'К',['L'] = 'Л',['M'] = 'М',['W'] = 'В',['Q'] = 'К',['U'] = 'А',['R'] = 'Р',['S'] = 'С',['zm'] = 'зьм',['h'] = 'х',['q'] = 'к',['y'] = 'и',['a'] = 'а',['w'] = 'в',['b'] = 'б',['v'] = 'в',['g'] = 'г',['d'] = 'д',['e'] = 'е',['z'] = 'з',['i'] = 'и',['j'] = 'ж',['k'] = 'к',['l'] = 'л',['m'] = 'м',['n'] = 'н',['o'] = 'о',['p'] = 'п',['r'] = 'р',['s'] = 'с',['t'] = 'т',['u'] = 'у',['f'] = 'ф',['x'] = 'x',['c'] = 'к',['``'] = 'ъ',['`'] = 'ь',['_'] = ' '}
local trstl1 = {['ph'] = 'ф',['Ph'] = 'Ф',['Ch'] = 'Ч',['ch'] = 'ч',['Th'] = 'Т',['th'] = 'т',['Sh'] = 'Ш',['sh'] = 'ш', ['ea'] = 'и',['Ae'] = 'Э',['ae'] = 'э',['size'] = 'сайз',['Jj'] = 'Джейджей',['Whi'] = 'Вай',['whi'] = 'вай',['Ck'] = 'К',['ck'] = 'к',['Kh'] = 'Х',['kh'] = 'х',['hn'] = 'н',['Hen'] = 'Ген',['Zh'] = 'Ж',['zh'] = 'ж',['Yu'] = 'Ю',['yu'] = 'ю',['Yo'] = 'Ё',['yo'] = 'ё',['Cz'] = 'Ц',['cz'] = 'ц', ['ia'] = 'я', ['ea'] = 'и',['Ya'] = 'Я', ['ya'] = 'я', ['ove'] = 'ав',['ay'] = 'эй', ['rise'] = 'райз',['oo'] = 'у', ['Oo'] = 'У'}

local date = os.date('%d.%m.%Y')
local fd_helper, fd_find_fire, autoupdate_loaded, afk, start_sobes, enable_autoupdate, Update, sobes_start = false, false, false, false, false, true, nil, false
local sobes, next_fire, time_fire, time_end = ',05,Пожарный департамент', 'появится после пожара', '00:00:00', '00:00:00'
local give, stats, lvl, UTC = 0, 0, 0, 0
local img = ''
local tlg_send = false
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

local update_list = ('\n{7CFC00}'..thisScript().version..
                     '\n\t{00BFFF}1. {87CEFA}Вам необходимо включить хелпер.'..
                     '\n\t{00BFFF}2. {87CEFA}После происхожедния первого пожара со включенным хелпером, вы сможете через команду /ftime посмотреть, когда произойдет следующий пожар.'..
                     '\n\t{00BFFF}3. {87CEFA}После того, как произойдет происшествие, у Вас произойдет следующее:'..
                     '\n\t\t{00BFFF}- {87CEFA}автоматически отправится отыгровка о выезде на происшествие;'..
                     '\n\t\t{00BFFF}- {87CEFA}автоматически введется команда /time;'..
                     '\n\t\t{00BFFF}- {87CEFA}автоматисчеки откроется меню происшействий /fires на 2 секунды;'..
                     '\n\t\t{00BFFF}- {87CEFA}автоматически примется происшествие;'..
                     '\n\t\t{00BFFF}- {87CEFA}заведётся двигатель пожарной машины;'..
                     '\n\t{00BFFF}4. {87CEFA}После того, как Вы прибудете на место происшествия, будут происходить все отыгровки.'..
                     '\n\t{00BFFF}5. {87CEFA}После того, как происшествие будет завершено, Вам вылезет информационное окно с информацией о пожаре.'..
                     '\n'..
                     '\n{FA8072}ВНИМАНИЕ!'..
                     '\n{00BFFF}Вся статистика собирается только при включенном хелпере. Если вы не завершили происшествие, новое происшествие и данные по нему записыватсья не будут.'..
                     '\nДля сброса необходимо выключить и включить хелпер.')

local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=0x40E0D0;
                                                        sampAddChatMessage(b..'Обнаружено обновление. {FA8072}'..thisScript().version..' {40E0D0}на {7CFC00}'..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then 
                                                        print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end

    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://github.com/ArtemyevaIA/firehelper/raw/refs/heads/main/firehelper.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/ArtemyevaIA/firehelper"
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
        lastlogin = os.date('%d.%m.%Y %H:%M:%S')
        assert(conn:execute("INSERT INTO clients (nick, tlg_id, firehelper, lastlogin) VALUES ('"..who_nick.."', '0', '1', '"..lastlogin.."')"))
        assert(conn:execute("INSERT INTO firehelp (nick, give, stats) VALUES ('"..who_nick.."', '0','0')"))
    else
        local client = assert(conn:execute("select c.nick, c.tlg_id, f.give, f.stats from clients c join firehelp f on c.nick = f.nick WHERE c.nick = '"..who_nick.."'"))
        local row = client:fetch({}, "a")
        tlg_id = row['tlg_id']
        give = row['give']
        stats = row['stats']
        if tlg_id ~= '0' then tlg_send = true end

        lastlogin = os.date('%d.%m.%Y %H:%M:%S')
        assert(conn:execute("UPDATE clients SET lastlogin = '"..lastlogin.."' WHERE nick = '"..who_nick.."'"))
    end

    sampAddChatMessage('', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}Хелпер пожарного департамента загружен', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}Версия хелпера: {7CFC00}'..thisScript().version..' {7FFFD4}Часовой пояс: {FFFFFF}+'..UTC..' {FFFFFF}мск', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}Команда для открытия меню {ffa000}/fh {7FFFD4}или клавиша {ffa000}Scroll Lock', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}Разработчик: {ffa000}Irin_Crown (Никита Артемьев)', 0x7FFFD4)
    sampAddChatMessage('', 0x7FFFD4)
    
    sampRegisterChatCommand('fh', fhmenu)
    sampRegisterChatCommand('stime', stime)
    sampRegisterChatCommand('ftime', function() 
        sampAddChatMessage('', 0x7FFFD4) 
        sampAddChatMessage('{7FFFD4}Следующий пожар в: {FFFFFF}'..next_fire, 0x7FFFD4)
        sampAddChatMessage('', 0x7FFFD4) 
    end)
    sampRegisterChatCommand('fclean', function()
        sampAddChatMessage('{E9967A}Статистика заработка была очищена.', 0xE9967A) 
        give = 0
        stats = 0
        assert(conn:execute("UPDATE firehelp SET give = 0, stats = 0 WHERE nick = '"..who_nick.."'"))
        assert(conn:execute("UPDATE firehelp_history SET active = 0 WHERE nick = '"..who_nick.."'"))
    end)
            
    while true do wait(0)

        if isKeyJustPressed(vkey.VK_SCROLL) then
           fhmenu()
        end
        
        local result, button, list, input = sampHasDialogRespond(9000)
        if result then 

            while sampIsDialogActive(9000) do wait(100) end
            local result, button, list, input = sampHasDialogRespond(9000)
                
            -----------------------------------------------------------------------------------
            -- Хелпер пожарника ---------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 0 then
                if fd_helper then
                    fd_helper = false
                    fd_find_fire = false
                    sampAddChatMessage('{90EE90}Хелпер пожарного департамента {FFA07A}выключен.', 0x90EE90)
                else
                    fd_helper = true
                    lua_thread.create(function()
                        sampAddChatMessage('{90EE90}Хелпер пожарного департамента {7CFC00}включен.', 0x90EE90)
                        sampAddChatMessage('{90EE90}После происхождения первого пожара автоматически запустится отыгровка РП.', 0x90EE90)
                        sampAddChatMessage('{90EE90}Пока проишествие не будет завершено, отыгровки по новой не запустятся.', 0x90EE90)
                        sampAddChatMessage('{90EE90}По окончанию пожара вы получите окно статистики: ', 0x90EE90)
                        sampAddChatMessage('{90EE90}Степень происшествия / Время начала / Время окончания / Сколько заработано', 0x90EE90)
                        sampAddChatMessage('{7FFFD4}Для просмотра времени следующего происшествия введите: {ffa000}/ftime', 0x7FFFD4)
                    end)
                end
                fhmenu()
            end

            -----------------------------------------------------------------------------------
            -- Развернутая статистика по пожарам ----------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 1 then
                local list = ''
                local cnt = 0
                local week_stats = 0
                local day_stats = 0
                local month_stats = 0
                local day_number = os.date("%d")
                local week_number = os.date("%W")+1
                local month_number = os.date("%m")

                local give_firestats = assert(conn:execute("SELECT *, DATE_FORMAT(date, '%d.%m.%Y') AS date, WEEK(date,1) AS week FROM firehelp_history WHERE nick = '"..who_nick.."' AND active = 1 ORDER by id ASC LIMIT 20"))
                local row = give_firestats:fetch({}, "a")

                local give_day_stats = assert(conn:execute("SELECT * FROM firehelp_history WHERE nick = '"..who_nick.."' AND DATE_FORMAT(date, '%d') = '"..day_number.."' AND active = 1"))
                local rowb = give_day_stats:fetch({}, "a")

                local give_week_stats = assert(conn:execute("SELECT * FROM firehelp_history WHERE nick = '"..who_nick.."' AND WEEK(date,1) = '"..week_number.."' AND active = 1"))
                local rowa = give_week_stats:fetch({}, "a")

                local give_month_stats = assert(conn:execute("SELECT * FROM firehelp_history WHERE nick = '"..who_nick.."' AND month(date) = '"..month_number.."' AND active = 1"))
                local rowc = give_month_stats:fetch({}, "a")

                while rowa do
                    week_stats = week_stats + rowa.give
                    rowa = give_week_stats:fetch({}, "a")
                end

                while rowb do
                    day_stats = day_stats + rowb.give
                    rowb = give_day_stats:fetch({}, "a")
                end

                while rowc do
                    month_stats = month_stats + rowc.give
                    rowc = give_month_stats:fetch({}, "a")
                end

                
                while row do
                    cnt = cnt+1

                    if row.lvl == '0' then lvl_fire = ('{FFFFFF}'..row.lvl..' cтепени{20B2AA}') end
                    if row.lvl == '1' then lvl_fire = ('{FFA500}'..row.lvl..' cтепени{20B2AA}') end
                    if row.lvl == '2' then lvl_fire = ('{FF7F50}'..row.lvl..' cтепени{20B2AA}') end
                    if row.lvl == '3' then lvl_fire = ('{CD5C5C}'..row.lvl..' cтепени{20B2AA}') end

                    list = "{20B2AA}Пожар "..row.date.." в "..row.time_start..' '..lvl_fire..' {FFFFFF}| {20B2AA}Потушен в '..row.time_end..' {FFFFFF}| {20B2AA}Доход: {F0E68C}+$'..row.give.. ' ['..string.format("%2.1f", row.give/1000000)..'М]'..'\n'..list
                    row = give_firestats:fetch({}, "a")
                end

                sampShowDialog(0, "{FFA500}Статистика по пожарам", "{d5a044}Заработано за последний пожар: {FFFFFF}+$"..give.. " ["..string.format("%2.1f", give/1000000).."М]"..
                                                                   "\n"..
                                                                   "\n{d5a044}Заработано за сегодня: {FFFFFF}+$"..day_stats.. " ["..string.format("%2.1f", day_stats/1000000).."М] "..
                                                                   "\n{d5a044}Заработано за неделю: {FFFFFF}+$"..week_stats.. " ["..string.format("%2.1f", week_stats/1000000).."М] "..
                                                                   "\n{d5a044}Заработано за месяц: {FFFFFF}+$"..month_stats.. " ["..string.format("%2.1f", month_stats/1000000).."М] "..
                                                                   "\n{d5a044}Заработано всего: {FFFFFF}+$"..stats.. " ["..string.format("%2.1f", stats/1000000).."М]"..
                                                                   "\n"..
                                                                   "\n{d5a044}Для очистки всей статистики введите команду {FF6347}/fclean {E9967A}(вся статистика будет сброшена)"..
                                                                   "\n"..
                                                                   "\n{AFEEEE}Статистика за последние 20 пожаров:"..
                                                                   "\n"..list, 
                                  "Закрыть", "")
            end

            -----------------------------------------------------------------------------------
            -- PAYDAY в телеграм --------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 3 then
                if tlg_send then
                    tlg_send = false
                    assert(conn:execute("UPDATE clients SET tlg_id = 0 WHERE nick = '"..who_nick.."'"))
                    sampAddChatMessage('{90EE90}Уведомление в телеграм о получении PAYDAY {FFA07A}выключено.', 0x90EE90)
                else
                    idtlg()
                    while sampIsDialogActive(3000) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(3000)

                    if button == 1 then
                        tlg_send = true
                        tlg_id = input
                        assert(conn:execute("UPDATE clients SET tlg_id = '"..tlg_id.."' WHERE nick = '"..who_nick.."'"))
                        sampAddChatMessage('{90EE90}Уведомление в телеграм о получении PAYDAY {7CFC00}включено.', 0x90EE90)
                        sampAddChatMessage('{90EE90}Уведомления будут приходить по {ffa000}id'..tlg_id, 0x90EE90)
                    end

                end
                fhmenu()
            end

            -----------------------------------------------------------------------------------
            -- Список изменений в версии ------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 5 then
                sampShowDialog(0, '{FFA500}Хелпер пожарника {7CFC00}'..thisScript().version, update_list, 'Закрыть', '', DIALOG_STYLE_MSGBOX)
                while sampIsDialogActive(0) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(0)
                if button == 0 then
                    fhmenu()
                end
            end

            -----------------------------------------------------------------------------------
            -- Список изменений в версии ------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 7 then
                local timestampt = os.date('%d.%m.%Y %H:%M:%S')
                report()

                while sampIsDialogActive(3001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(3001)
                
                if button == 1 then
                    sampAddChatMessage('Ваше обращение отправлено.', -255)
                    assert(conn:execute("INSERT INTO report (nick, timestampt, text, status) VALUES ('"..who_nick.."', '"..timestampt.."', '"..input.."', '0')"))
                end

                if button == 0 then
                    fhmenu()
                end
            end

            if button == 0 then
                sampCloseCurrentDialogWithButton(0)
            end
        end

        if os.date('%M:%S') == "25:00" then
            upd()
            wait(1000)
        end
    end
end

function fhmenu()
    
    if afk then afk_status = '{00FF7F}[Включен]' else afk_status = '{FFA07A}[Выключен]' end
    if fd_helper then fd_helper_status = '{00FF7F}[Включен]' else fd_helper_status = '{FFA07A}[Выключен]' end
    if tlg_send then tlg_status = '{00FF7F}[Подключен]' else tlg_status = '{FFA07A}[Не подключен]' end

    sampShowDialog(9000, "Сервисное меню", "Хелпер пожарника "..fd_helper_status..
                                           "\n{FFE4B5}Развернутая статистика по пожарам"..
                                           "\n "..
                                           "\nPAYDAY в телеграм "..tlg_status..
                                           "\n "..
                                           "\nИнформация по хелперу версии {7CFC00}"..thisScript().version..
                                           "\n "..
                                           "\n{FFA500}Написать разработчику", 'Выбрать', 'Назад', 2)
end

function idtlg()
    sampShowDialog(3000, "{FFA500}Подключение PAYDAY в телегу", "{7ce9b1}Введите свой id телеграмм.\nКаждый PAYDAY Вам будет приходить статистика заработка.\n\nПосле того, как Вы укажете свой id, \nнапишите что-нибудь боту {FFA500}@longamesbot {7ce9b1}в телеграмме для активации.", "Ввести", "Отмена", 1)
end

function report()
    sampShowDialog(3001, '{FFA500}Отправить письмо разработчику', 'Если вы нашли какой-то баг или у Вас есть предложение, напишите его здесь.', "Отправить", "Отмена", 1)
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

function sampev.onServerMessage(color, text)
    if tlg_send and text:find('__________Банковский чек__________') then
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

    if text:find("В штате произошел пожар! Ранг опасности (%d+) звезды") then
        lua_thread.create(function()
            time_fire = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            next_fire = os.date('%H:%M:%S', os.time() - (UTC * 3600) + (20*60)+1)
        end)
    end

    if not fd_find_fire and fd_helper and text:find("В штате произошел пожар! Ранг опасности (%d+) звезды") then
        lua_thread.create(function()
            fd_find_fire = true
            lvl = text:match('В штате произошел пожар! Ранг опасности (%d+) звезды')
            time_fire = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            next_fire = os.date('%H:%M:%S', os.time() - (UTC * 3600) + (20*60)+1)
            sampAddChatMessage('', 0x7FFFD4)
            sampAddChatMessage('ВНИМАНИЕ!!!', 0xDC143C)
            sampAddChatMessage('В штате произошлоа происшествие. Степень опасности: {DC143C}'..lvl, 0x7FFFD4)
            sampAddChatMessage('Время происшествия: {FFFFFF}'..time_fire, 0x7FFFD4)
            sampAddChatMessage('Следующее происшествие в: {FFFFFF}'..next_fire, 0x7FFFD4)
            sampAddChatMessage('', 0x7FFFD4)
            sampProcessChatInput('/time',-1)
            sampProcessChatInput('/fires',-1)
            wait(2000)
            setVirtualKeyDown(VK_RETURN, true) -- зажать клавишу
            wait(100)
            setVirtualKeyDown(VK_RETURN, false) -- отжать клавишу
            sampProcessChatInput('/engine',-1)

            sampProcessChatInput('/r Докладывает '..nick_fire..': выезжаю на происшествие '..lvl.. ' степени опасности!',-1)             
        end)
    end

    if text:find("Вы прибыли на место пожара") then
        lua_thread.create(function()
            sampProcessChatInput('/r Докладывает '..nick_fire..': прыбыл на место происшествия.',-1)

            local x,y,z = getCharCoordinates(PLAYER_PED) 
            assert(conn:execute("INSERT INTO temp (lvl, x, y, z, nick, fire_place) VALUES ('"..lvl.."', '"..x.."','"..y.."','"..z.."', '"..who_nick.."', '"..fire_place.."')"))

            count = 0
            for _ in pairs(fires_list) do 
                count = count + 1
                dist = getDistanceBetweenCoords3d(x, y, z, fires_list[count][1], fires_list[count][2], fires_list[count][3])
                if dist <= 100 then
                    sampAddChatMessage("Вы прибыли на пожар "..fires_list[count][4].. " степени опасности", -255)
                end
            end
        end)
    end

    if text:find("Отнесите пострадавшего в палатку") then
        lua_thread.create(function()
            sampProcessChatInput('/r Докладывает '..nick_fire..': оказываю помощь пострадавшему.',-1)
        end)
    end

    if text:find("Отлично! Вы спасли пострадавшего!") then
        lua_thread.create(function()
            sampProcessChatInput('/r Докладывает '..nick_fire..': пострадавшему оказана первая помощь.',-1)
        end)
    end

    if text:find("Все очаги возгорания ликвидированы.") then
        lua_thread.create(function()
            sampProcessChatInput('/r Докладывает '..nick_fire..': все очаги возгарания ликвидированы.',-1)
        end)
    end

    if text:find("Вы заработали на происшествие {90EE90}$(%d+)") then
        lua_thread.create(function()
            wait(1000)
            sampProcessChatInput('/r Докладывает '..nick_fire..': пожар успешно ликвидирован. Возвращаюсь на базу.',-1)
            time_end = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            give = text:match('Вы заработали на происшествие {90EE90}$(%d+)')
            firedate = os.date('%Y-%m-%d')
            wait(2000)
            sampAddChatMessage('', 0x7FFFD4)
            sampAddChatMessage('{7FFFD4}Происшествие {DC143C}'..lvl..' степени {7FFFD4}ликвидировано', 0x7FFFD4)
            sampAddChatMessage('{7FFFD4}Следующее происшествие в: {DC143C}'..next_fire,0x7FFFD4)
            sampAddChatMessage('{7FFFD4}Заработано за происшествие: {26fc66}$'..give.. ' ['..string.format("%2.1f", give/1000000)..'М]', 0x7FFFD4)
            sampAddChatMessage('', 0x7FFFD4)
            sampProcessChatInput('/time',-1)
            sampShowDialog(0, "{FFA500}Завершение пожара", "{8eeaf0}Пожар {d54447}" ..lvl.. " степени {8eeaf0}был ликвидирован.\n\n{8eeaf0}Время начала: {d5a044}" ..time_fire.. "\n{8eeaf0}Время ликвидации: {d5a044}" ..time_end.. "\n{8eeaf0}Доход: {d5a044}+ $"..give.. " ["..string.format("%2.1f", give/1000000).."М]", "Закрыть", "", DIALOG_STYLE_MSGBOX)
            fd_find_fire = false

            assert(conn:execute("INSERT INTO firehelp_history (lvl, nick, give, time_start, time_end, date, active) VALUES ('"..lvl.."', '"..who_nick.."', '"..give.."', '"..time_fire.."', '"..time_end.."', '"..firedate.."', '1')"))
            assert(conn:execute("UPDATE firehelp SET give = '"..give.."', stats = stats+'"..give.."' WHERE nick = '"..who_nick.."'"))
            stats = stats+give
        end)
    end
end

-- function sampev.onShowDialog(id, style, title, button1, button2, text)
--     if dialogId == 27259 then
--         text = text:match('* ](%A+)')
--         place = text:gsub('{(.+)', '')
--         fire_place = place:gsub('{', '')
--     end
-- end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
        return -1
end

function encodeUrl(str)
   str = str:gsub(' ', '%+')
   str = str:gsub('\n', '%%0A')
   return u8:encode(str, 'CP1251')
end

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
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

function requestRunner() -- создание effil потока с функцией https запроса
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

local vkerr, vkerrsend -- сообщение с текстом ошибки, nil если все ок

function loop_async_http_request(url, args, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        while true do
            while not key do wait(0) end
            url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --меняем url каждый новый запрос потокa, так как server/key/ts могут изменяться
            threadHandle(runner, url, args, longpollResolve, reject)
        end
    end)
end

function upd()
   local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=0x40E0D0;
                                                           sampAddChatMessage(b..'Обнаружено обновление. {FA8072}'..thisScript().version..' {40E0D0}на {7CFC00}'..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then 
                                                           print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
   if updater_loaded then
       autoupdate_loaded, Update = pcall(Updater)
       if autoupdate_loaded then
           Update.json_url = "https://github.com/ArtemyevaIA/firehelper/raw/refs/heads/main/firehelper.json?" .. tostring(os.clock())
           Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
           Update.url = "https://github.com/ArtemyevaIA/firehelper"
       end

   end
   if autoupdate_loaded and Update then
       pcall(Update.check, Update.json_url, Update.prefix, Update.url)
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
    sampAddChatMessage('Часовой пояс: {FFFFFF}+'..UTC..' мск', -255)
    sampAddChatMessage('Время на ПК: {FFFFFF}'..timepc, -255)
    sampAddChatMessage('Время на сервере: {FFFFFF}'..tt, -255)
    sampAddChatMessage('', -255)
end

function os.offset()
   local currenttime = os.time()
   local datetime = os.date("*t",currenttime)
   datetime.isdst = true -- Флаг дневного времени суток
   return currenttime - os.time(datetime)
end

function sendTelegramPhoto(img, msg) -- функция для отправки сообщения юзеру
   msg = msg:gsub('{......}', '') --тут типо убираем цвет
   msg = encodeUrl(msg) -- ну тут мы закодируем строку
   token = '8059436647:AAFSZNM3lfxxJ5E2jFkE_D_N9iWlLdBD-ss'
   --id = '5700686218'
   async_http_request('https://api.telegram.org/bot'..token..'/sendPhoto?chat_id='..tlg_id..'&caption='..msg,'&photo='..img..'', function(result) end) -- а тут уже отправка
end