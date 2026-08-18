--[[
    BobaV1 v1.0.0 вЂ” Fallen Survival
    Standalone cheat script вЂ” no external dependencies
    Custom UI, boba amber theme, all features built-in
    
    Paste into executor:
    utility.LoadUrl("https://raw.githubusercontent.com/boqnpenev1-design/BobaV1/main/boba.lua")
]]

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- BobaV1 Module Framework
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1 = BobaV1 or {}
BobaV1._mods = {}
BobaV1.VERSION = "1.0.0"
BobaV1.NAME = "BobaV1"

function BobaV1.require(name)
    local mod = BobaV1._mods[name]
    if mod then return mod end
    return nil
end

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.env вЂ” Environment detection & safe calls
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.env"] = (function()
    local M = {}
    function M.safe_call(fn, ...)
        if type(fn) ~= "function" then return nil end
        local ok, result = pcall(fn, ...)
        if ok then return result end
        return nil
    end
    function M.is_valid(inst)
        if inst == nil then return false end
        local ok, result = pcall(function()
            if type(inst) == "userdata" then
                local _ = inst.Name or inst.name
                return true
            end
            return inst ~= nil
        end)
        return ok and result == true
    end
    function M.get_local_player()
        if entity and entity.get_local_player then
            local ok, p = pcall(entity.get_local_player)
            if ok and p then return p end
        end
        if game then
            local lp = game.LocalPlayer or game.local_player
            if lp then return lp end
        end
        return nil
    end
    function M.get_players()
        if entity and entity.get_players then
            local ok, list = pcall(entity.get_players)
            if ok and type(list) == "table" then return list end
        end
        if game and game.get_service then
            local ok, svc = pcall(game.get_service, "Players")
            if ok and svc then
                local ok2, players = pcall(function()
                    if svc.GetPlayers then return svc:GetPlayers() end
                    if svc.get_players then return svc:get_players() end
                    return {}
                end)
                if ok2 then return players end
            end
        end
        return {}
    end
    function M.get_character(player)
        if not player then return nil end
        return player.Character or player.character
    end
    function M.get_humanoid(player)
        return player and (player.Humanoid or player.humanoid)
    end
    function M.get_team(player)
        if not player then return nil end
        return M.safe_call(function()
            return player.Team or player.team or player.TeamColor or player.team_color
        end)
    end
    function M.same_team(a, b)
        if not a or not b then return false end
        local ta = M.get_team(a)
        local tb = M.get_team(b)
        if ta == nil or tb == nil then return false end
        return ta == tb
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.api_aliases вЂ” Normalize executor API names
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.api_aliases"] = (function()
    local M = {}
    M._applied = false
    function M.apply()
        if M._applied then return end
        M._applied = true
        if utility then
            utility.get_tick_count = utility.get_tick_count or utility.GetTickCount
            utility.http_get = utility.http_get or utility.HttpGet
            utility.world_to_screen = utility.world_to_screen or utility.WorldToScreen
            utility.get_delta_time = utility.get_delta_time or utility.GetDeltaTime
            utility.get_camera_angles = utility.get_camera_angles or utility.GetCameraAngles
        end
        if raycast then
            raycast.is_visible = raycast.is_visible or raycast.IsVisible
            raycast.cast = raycast.cast or raycast.Cast
            raycast.set_silent_target = raycast.set_silent_target or raycast.SetSilentTarget
            raycast.track_silent_target = raycast.track_silent_target or raycast.TrackSilentTarget
            raycast.stop_silent_tracking = raycast.stop_silent_tracking or raycast.StopSilentTracking
            raycast.enable_silent_hook = raycast.enable_silent_hook or raycast.EnableSilentHook
        end
        if camera then
            camera.get_position = camera.get_position or camera.GetPosition
            camera.get_look_vector = camera.get_look_vector or camera.GetLookVector
            camera.get_angles = camera.get_angles or camera.GetAngles
        end
        if draw then
            draw.text = draw.text or draw.Text
            draw.line = draw.line or draw.Line
            draw.rect = draw.rect or draw.Rect
            draw.rect_filled = draw.rect_filled or draw.RectFilled
            draw.circle = draw.circle or draw.Circle
            draw.circle_filled = draw.circle_filled or draw.CircleFilled
            draw.world_to_screen = draw.world_to_screen or draw.WorldToScreen
            draw.load_image = draw.load_image or draw.LoadImage
            draw.image = draw.image or draw.Image
        end
        if memory then
            memory.read = memory.read or memory.Read
            memory.write = memory.write or memory.Write
        end
        if exploits then
            exploits.ApplyChamsToInstance = exploits.ApplyChamsToInstance or (exploits.apply_chams_to_instance)
            exploits.RevertChams = exploits.RevertChams or exploits.revert_chams
            exploits.SetChamsMode = exploits.SetChamsMode or exploits.set_chams_mode
            exploits.SetChamsColor = exploits.SetChamsColor or exploits.set_chams_color
        end
    end
    M.apply()
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.settings вЂ” Unified settings store
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.settings"] = (function()
    local M = {}
    local _values = {}
    local _callbacks = {}
    function M.set(key, value)
        if key == nil then return end
        local old = _values[key]
        _values[key] = value
        if old ~= value and _callbacks[key] then
            for _, fn in ipairs(_callbacks[key]) do
                pcall(fn, value, old)
            end
        end
        if menu and menu.set_value then
            pcall(menu.set_value, key, value)
        end
    end
    function M.get(key, default)
        local v = _values[key]
        if v ~= nil then return v end
        if menu and menu.get_value then
            local ok, mv = pcall(menu.get_value, key)
            if ok and mv ~= nil then
                _values[key] = mv
                return mv
            end
        end
        return default
    end
    function M.bool(key, default)
        local v = M.get(key, default)
        return v == true or v == 1
    end
    function M.enabled(key)
        return M.bool(key, false)
    end
    function M.num(key, default)
        return tonumber(M.get(key, default)) or (tonumber(default) or 0)
    end
    function M.str(key, default)
        return tostring(M.get(key, default) or default or "")
    end
    function M.combo_index(key, labels, default)
        local v = M.get(key)
        if type(v) == "number" then return v end
        if type(v) == "string" then
            for i, label in ipairs(labels) do
                if label == v then return i - 1 end
            end
        end
        return default or 0
    end
    function M.multi(key, index, default)
        local v = M.get(key)
        if type(v) == "table" then
            return v[index] == true
        end
        return default or false
    end
    function M.on_change(key, fn)
        if not key or type(fn) ~= "function" then return end
        _callbacks[key] = _callbacks[key] or {}
        table.insert(_callbacks[key], fn)
    end
    -- Sync from menu on callback
    if menu and menu.register_callback then
        pcall(menu.register_callback, function(id, value)
            _values[id] = value
            if _callbacks[id] then
                for _, fn in ipairs(_callbacks[id]) do
                    pcall(fn, value)
                end
            end
        end)
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.math_util вЂ” Math helpers
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.math_util"] = (function()
    local M = {}
    M.PI = math.pi
    M.TAU = math.pi * 2
    function M.clamp(v, lo, hi)
        if v < lo then return lo end
        if v > hi then return hi end
        return v
    end
    function M.lerp(a, b, t) return a + (b - a) * t end
    function M.distance3(dx, dy, dz)
        return math.sqrt(dx * dx + dy * dy + dz * dz)
    end
    function M.distance2(dx, dy)
        return math.sqrt(dx * dx + dy * dy)
    end
    function M.atan2(y, x)
        return math.atan2(y, x)
    end
    function M.normalize_angle(a)
        while a > math.pi do a = a - M.TAU end
        while a < -math.pi do a = a + M.TAU end
        return a
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.draw_util вЂ” Drawing helpers
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.draw_util"] = (function()
    local M = {}
    function M.screen_size()
        if draw and draw.get_screen_size then
            local ok, w, h = pcall(draw.get_screen_size)
            if ok then return w, h end
        end
        if utility and utility.get_screen_size then
            local ok, w, h = pcall(utility.get_screen_size)
            if ok then return w, h end
        end
        return 1920, 1080
    end
    function M.line(x1, y1, x2, y2, col, thick)
        if draw and draw.line then
            pcall(draw.line, x1, y1, x2, y2, col, thick or 1)
        end
    end
    function M.rect(x, y, w, h, col, rounding, thick)
        if draw and draw.rect then
            pcall(draw.rect, x, y, w, h, col, rounding or 0, thick or 1)
        end
    end
    function M.rect_filled(x, y, w, h, col, rounding)
        if draw and draw.rect_filled then
            pcall(draw.rect_filled, x, y, w, h, col, rounding or 0)
        end
    end
    function M.text(x, y, msg, col, size)
        if draw and draw.text then
            pcall(draw.text, x, y, msg, col, size or 13)
        end
    end
    function M.text_centered(x, y, msg, col, size)
        size = size or 13
        if draw and draw.text then
            local tw = 0
            if draw.text_size then
                local ok, w = pcall(draw.text_size, msg, size)
                if ok then tw = w or 0 end
            else
                tw = #msg * (size * 0.55)
            end
            pcall(draw.text, x - tw * 0.5, y, msg, col, size)
        end
    end
    function M.circle(x, y, r, col, filled, segments)
        segments = segments or 24
        if filled and draw and draw.circle_filled then
            pcall(draw.circle_filled, x, y, r, col, segments)
        elseif draw and draw.circle then
            pcall(draw.circle, x, y, r, col, segments, 1)
        end
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.text_util вЂ” Text sanitizer
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.text_util"] = (function()
    local M = {}
    function M.sanitize(text)
        if type(text) ~= "string" then return tostring(text or "") end
        text = text:gsub("[\r\n\t]", " ")
        text = text:gsub("%s+", " ")
        text = text:gsub("^%s+", ""):gsub("%s+$", "")
        if #text > 256 then text = text:sub(1, 256) .. "..." end
        return text
    end
    function M.truncate(text, max)
        max = max or 32
        if #text <= max then return text end
        return text:sub(1, max - 3) .. "..."
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.cache вЂ” Time-based caching
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.cache"] = (function()
    local M = {}
    local _entries = {}
    local function now()
        if utility and utility.get_tick_count then
            local ok, t = pcall(utility.get_tick_count)
            if ok then return t end
        end
        return 0
    end
    function M.get(key, ttl_ms)
        local entry = _entries[key]
        if not entry then return nil end
        if ttl_ms and (now() - entry.t) > ttl_ms then
            _entries[key] = nil
            return nil
        end
        return entry.v
    end
    function M.set(key, value)
        _entries[key] = { v = value, t = now() }
    end
    function M.clear(key)
        if key then _entries[key] = nil
        else _entries = {} end
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.notify вЂ” Toast notification system
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.notify"] = (function()
    local draw_util = BobaV1.require("core.draw_util")
    local text_util = BobaV1.require("core.text_util")
    local M = {}
    local queue = {}
    local function tick()
        return utility and utility.get_tick_count and utility.get_tick_count() or 0
    end
    local function lerp(a, b, t) return a + (b - a) * t end
    function M.toast(msg, ntype, duration_ms)
        if not msg or msg == "" then return end
        msg = text_util.sanitize(msg)
        ntype = ntype or "info"
        duration_ms = duration_ms or 5000
        for _, n in ipairs(queue) do
            if n.msg == msg and (tick() - n.time) < 3000 then return end
        end
        if menu and menu.notify then
            pcall(function() menu.notify(msg) end)
        end
        table.insert(queue, {
            msg = msg, type = ntype, time = tick(),
            duration = duration_ms, alpha = 0, x_off = 80, y = 0,
        })
        while #queue > 6 do table.remove(queue, 1) end
    end
    function M.show(msg, ntype, dur) M.toast(msg, ntype, dur) end
    function M.success(msg, dur) M.toast(msg, "success", dur) end
    function M.warning(msg, dur) M.toast(msg, "warning", dur) end
    function M.error(msg, dur) M.toast(msg, "danger", dur) end
    function M.info(msg, dur) M.toast(msg, "info", dur) end

    local TOAST_COLORS = {
        success = {0.32, 0.81, 0.40, 1},
        warning = {1.0, 0.83, 0.23, 1},
        danger = {1.0, 0.42, 0.42, 1},
        info = {0.83, 0.65, 0.46, 1}, -- boba amber
    }
    function M.draw()
        if #queue == 0 or not draw then return end
        local now = tick()
        local font = 13
        local pad = 12
        local gap = 8
        local target_y = 18
        for i = #queue, 1, -1 do
            local n = queue[i]
            local elapsed = now - n.time
            if elapsed > n.duration then
                table.remove(queue, i)
            else
                local fade = 350
                local target_alpha = 1
                if elapsed < fade then target_alpha = elapsed / fade
                elseif elapsed > n.duration - fade then target_alpha = (n.duration - elapsed) / fade end
                n.alpha = lerp(n.alpha or 0, target_alpha, 0.18)
                local slide = 0
                if elapsed > n.duration - fade then slide = 60 end
                n.x_off = lerp(n.x_off or 80, slide, 0.15)
                if n.y == 0 then n.y = target_y end
                n.y = lerp(n.y, target_y, 0.2)
                local accent = TOAST_COLORS[n.type] or TOAST_COLORS.info
                local tw = #n.msg * (font * 0.55)
                local box_w = tw + pad * 2 + 4
                local box_h = font + pad * 2
                local sw = select(1, draw_util.screen_size())
                local x = sw - box_w - 16 + (n.x_off or 0)
                local y = n.y
                local a = n.alpha or 1
                -- Panel
                draw_util.rect_filled(x, y, box_w, box_h, {0.06, 0.06, 0.09, 0.94 * a}, 0)
                -- Accent bar
                draw_util.rect_filled(x + 2, y, box_w - 3, 2, {accent[1], accent[2], accent[3], a}, 0)
                -- Border
                draw_util.rect(x, y, box_w, box_h, {0.83, 0.65, 0.46, 0.15 * a}, 0, 1)
                -- Text
                draw_util.text(x + pad, y + pad - 1, n.msg, {0.91, 0.90, 0.94, a}, font)
                target_y = target_y + box_h + gap
            end
        end
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.esp_util вЂ” ESP drawing helpers (w2s, skeleton, etc)
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.esp_util"] = (function()
    local draw_util = BobaV1.require("core.draw_util")
    local settings = BobaV1.require("core.settings")
    local M = {}
    M.AIM_BONES = {
        "Closest","Head","UpperTorso","LowerTorso","HumanoidRootPart",
        "LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm",
        "LeftHand","RightHand","LeftUpperLeg","RightUpperLeg",
        "LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot",
    }
    M.SKELETON_PAIRS = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"UpperTorso","RightUpperArm"},
        {"LeftUpperArm","LeftLowerArm"},{"RightUpperArm","RightLowerArm"},
        {"LeftLowerArm","LeftHand"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LowerTorso","RightUpperLeg"},
        {"LeftUpperLeg","LeftLowerLeg"},{"RightUpperLeg","RightLowerLeg"},
        {"LeftLowerLeg","LeftFoot"},{"RightLowerLeg","RightFoot"},
    }
    function M.w2s(x, y, z)
        x, y, z = tonumber(x), tonumber(y), tonumber(z)
        if not x or not y or not z then return 0, 0, false end
        if draw and draw.world_to_screen then
            local ok, a, b, c = pcall(draw.world_to_screen, x, y, z)
            if ok and a then
                if type(a) == "number" then
                    local vis = c ~= false and c ~= 0
                    return a, b, vis
                end
            end
        end
        if utility and utility.world_to_screen then
            local ok, a, b, c = pcall(utility.world_to_screen, x, y, z)
            if ok and a then
                if type(a) == "number" then
                    return a, b, c ~= false and c ~= 0
                end
            end
        end
        return 0, 0, false
    end
    function M.text_size()
        return settings.num("boba_esp_text_size", 13)
    end
    function M.draw_skeleton_bones(bones, col, thick)
        if not bones then return end
        thick = thick or 1.5
        for _, pair in ipairs(M.SKELETON_PAIRS) do
            local a = bones[pair[1]]
            local b = bones[pair[2]]
            if a and b and a.x and b.x then
                draw_util.line(a.x, a.y, b.x, b.y, col, thick)
            end
        end
    end
    function M.draw_offscreen_arrow(cx, cy, tx, ty, col, size)
        size = size or 14
        local dx, dy = tx - cx, ty - cy
        local len = math.sqrt(dx * dx + dy * dy)
        if len < 1 then return end
        dx, dy = dx / len, dy / len
        local px, py = cx + dx * (size + 8), cy + dy * (size + 8)
        local lx, ly = -dy, dx
        if draw and draw.poly_filled then
            draw.poly_filled({
                {px + dx * size, py + dy * size},
                {px - dx * 4 + lx * size * 0.55, py - dy * 4 + ly * size * 0.55},
                {px - dx * 4 - lx * size * 0.55, py - dy * 4 - ly * size * 0.55},
            }, col)
        else
            draw_util.line(px, py, px - dx * 8 + lx * 6, py - dy * 8 + ly * 6, col, 2)
            draw_util.line(px, py, px - dx * 8 - lx * 6, py - dy * 8 - ly * 6, col, 2)
        end
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.entity_props вЂ” Entity property reader
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.entity_props"] = (function()
    local env = BobaV1.require("core.env")
    local M = {}
    function M.get_health(player)
        if not player then return nil, nil end
        local hum = player.Humanoid or player.humanoid
        if not hum then
            local char = env.get_character(player)
            if char then
                hum = env.safe_call(function()
                    if char.FindFirstChildOfClass then return char:FindFirstChildOfClass("Humanoid") end
                    if char.find_first_child_of_class then return char:find_first_child_of_class("Humanoid") end
                end)
            end
        end
        if not hum then return nil, nil end
        local hp = hum.Health or hum.health
        local maxhp = hum.MaxHealth or hum.max_health or 100
        return tonumber(hp), tonumber(maxhp)
    end
    function M.is_alive(player)
        local hp = M.get_health(player)
        return hp ~= nil and hp > 0
    end
    function M.is_downed(player)
        if not player then return false end
        return env.safe_call(function()
            local char = env.get_character(player)
            if not char then return false end
            local state = char:FindFirstChild("StateController") or char:FindFirstChild("stateController")
            if state then
                local downed = state:GetAttribute("IsDowned") or state:GetAttribute("isDowned")
                return downed == true
            end
            return false
        end) == true
    end
    function M.get_position(player)
        if not player then return nil end
        local char = env.get_character(player)
        if not char then return nil end
        return env.safe_call(function()
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("humanoidrootpart")
            if root then
                local pos = root.Position or root.position
                if pos then
                    return {x = pos.X or pos.x, y = pos.Y or pos.y, z = pos.Z or pos.z}
                end
            end
            return nil
        end)
    end
    function M.get_bone_position(player, bone_name)
        if not player then return nil end
        local char = env.get_character(player)
        if not char then return nil end
        return env.safe_call(function()
            local part = char:FindFirstChild(bone_name)
            if part then
                local pos = part.Position or part.position
                if pos then
                    return {x = pos.X or pos.x, y = pos.Y or pos.y, z = pos.Z or pos.z}
                end
            end
            return nil
        end)
    end
    function M.get_velocity(player)
        if not player then return nil end
        local char = env.get_character(player)
        if not char then return nil end
        return env.safe_call(function()
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = root.Velocity or root.velocity or root.AssemblyLinearVelocity
                if vel then
                    return {x = vel.X or vel.x or 0, y = vel.Y or vel.y or 0, z = vel.Z or vel.z or 0}
                end
            end
            return {x=0,y=0,z=0}
        end)
    end
    function M.get_name(player)
        if not player then return "?" end
        return player.Name or player.name or player.DisplayName or "?"
    end
    function M.get_display_name(player)
        if not player then return "?" end
        return player.DisplayName or player.display_name or M.get_name(player)
    end
    function M.get_held_item(player)
        if not player then return nil end
        local char = env.get_character(player)
        if not char then return nil end
        return env.safe_call(function()
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then return tool.Name or tool.name end
            return nil
        end)
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.silent_ray вЂ” Silent aim raycast hooking
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.silent_ray"] = (function()
    local M = {}
    local hook_ready = false
    local tracking = false
    M._last_origin = nil
    M._last_target = nil
    M._last_ok = false
    local function ray_fn(snake, pascal)
        if not raycast then return nil end
        pcall(function() BobaV1.require("core.api_aliases").apply() end)
        local fn = raycast[snake] or raycast[pascal]
        return type(fn) == "function" and fn or nil
    end
    local function cam_fn(snake, pascal)
        if not camera then return nil end
        local fn = camera[snake] or camera[pascal]
        return type(fn) == "function" and fn or nil
    end
    local function make_vec3(x, y, z)
        if Vector3 then
            local ctor = Vector3.New or Vector3.new
            if type(ctor) == "function" then
                local ok, v = pcall(ctor, x, y, z)
                if ok and v then return v end
            end
        end
        return {x=x, y=y, z=z}
    end
    function M.available()
        if not raycast then return false end
        local set = ray_fn("set_silent_target", "SetSilentTarget")
        local stop = ray_fn("stop_silent_tracking", "StopSilentTracking")
        return set ~= nil and stop ~= nil
    end
    function M.ensure_hook()
        if not M.available() then return false end
        if hook_ready then return true end
        local enable = ray_fn("enable_silent_hook", "EnableSilentHook")
        if not enable then hook_ready = true; return true end
        local ok, result = pcall(enable)
        hook_ready = ok and result == true
        return hook_ready
    end
    function M.get_camera_origin()
        local get_pos = cam_fn("get_position", "GetPosition")
        if not get_pos then return nil end
        local ok, pos = pcall(get_pos)
        if not ok or not pos then return nil end
        local x = pos.x or pos.X
        local y = pos.y or pos.Y
        local z = pos.z or pos.Z
        if not x then return nil end
        return {x=x, y=y, z=z}
    end
    function M.stop()
        M._last_origin = nil
        M._last_target = nil
        M._last_ok = false
        tracking = false
        local stop = ray_fn("stop_silent_tracking", "StopSilentTracking")
        if stop then pcall(stop) end
        local clear = ray_fn("clear_silent_target", "ClearSilentTarget")
        if clear then pcall(clear) end
    end
    function M.set_target(origin, aim_point)
        M._last_ok = false
        if not aim_point then return false end
        origin = origin or M.get_camera_origin()
        if not origin then return false end
        if not M.ensure_hook() then return false end
        local set_fn = ray_fn("set_silent_target", "SetSilentTarget")
        if not set_fn then return false end
        local dx = aim_point.x - origin.x
        local dy = aim_point.y - origin.y
        local dz = aim_point.z - origin.z
        local origin_v = make_vec3(origin.x, origin.y, origin.z)
        local dir = make_vec3(dx, dy, dz)
        M._last_origin = origin
        M._last_target = aim_point
        local ok, result = pcall(set_fn, origin_v, dir)
        M._last_ok = ok and (result == true or result == nil)
        tracking = M._last_ok
        return M._last_ok
    end
    function M.is_tracking() return tracking end
    function M.last_ok() return M._last_ok end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- core.ballistic вЂ” Bullet drop & prediction
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.ballistic"] = (function()
    local math_util = BobaV1.require("core.math_util")
    local M = {}
    local ROBLOX_GRAV = 196.2
    function M.calculate_drop(bullet_speed, bullet_gravity, position, origin)
        local px = position.x - origin.x
        local py = position.y - origin.y
        local pz = position.z - origin.z
        local speed = math.max(bullet_speed or 950, 1)
        local dist = math_util.distance3(px, py, pz)
        local time = dist / speed
        local grav = bullet_gravity or 0.55
        local drop = 0.5 * grav * 195 * time * time
        return drop == drop and drop or 0
    end
    function M.predict_position(bullet_speed, bullet_gravity, velocity, position, origin)
        local px = position.x - origin.x
        local py = position.y - origin.y
        local pz = position.z - origin.z
        local speed = math.max(bullet_speed or 950, 1)
        local dist = math_util.distance3(px, py, pz)
        local time = dist / speed
        local drop = M.calculate_drop(bullet_speed, bullet_gravity, position, origin)
        return {
            x = position.x + (velocity.x or 0) * time,
            y = position.y + (velocity.y or 0) * time + drop,
            z = position.z + (velocity.z or 0) * time,
        }
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- BobaV1 MENU SYSTEM вЂ” Custom UI registration
-- Uses executor's menu API with BobaV1 branding
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["boba.menu"] = (function()
    local settings = BobaV1.require("core.settings")
    local M = {}
    M.TAB = "BobaV1"
    M.G = {
        SILENT_AIM = "Silent Aim",
        GUN_MODS = "Gun Mods",
        VISUALS = "Visuals",
        WORLD = "World",
        RADAR = "Radar",
        MISC = "Misc",
    }
    local _tab_ready = false
    local _groups = {}

    function M.init()
        if _tab_ready then return end
        if not menu then
            print("[BobaV1] Warning: menu API not available")
            return
        end
        -- Create main tab
        if menu.add_tab then
            pcall(menu.add_tab, M.TAB, "B", "full")
        end
        _tab_ready = true
        -- Create groups (left/right layout)
        local layout = {
            {M.G.SILENT_AIM, "left"},
            {M.G.GUN_MODS, "right"},
            {M.G.VISUALS, "left"},
            {M.G.WORLD, "right"},
            {M.G.RADAR, "left"},
            {M.G.MISC, "right"},
        }
        for _, row in ipairs(layout) do
            local name, side = row[1], row[2]
            if not _groups[name] and menu.add_group then
                if side == "right" then
                    pcall(menu.add_group, M.TAB, name, 0, true)
                else
                    pcall(menu.add_group, M.TAB, name)
                end
                _groups[name] = true
            end
        end
    end

    -- Helpers for adding menu items
    function M.toggle(group, id, label, default, opts)
        if not menu or not menu.add_checkbox then return end
        pcall(menu.add_checkbox, M.TAB, group, id, label, default or false, opts or {})
    end
    function M.slider(group, id, label, min, max, default, opts)
        if not menu or not menu.add_slider then return end
        pcall(menu.add_slider, M.TAB, group, id, label, min, max, default or min, opts or {})
    end
    function M.combo(group, id, label, options, default, opts)
        if not menu or not menu.add_combo then return end
        pcall(menu.add_combo, M.TAB, group, id, label, options, default or 0, opts or {})
    end
    function M.color(group, id, label, default, opts)
        if not menu or not menu.add_colorpicker then return end
        pcall(menu.add_colorpicker, M.TAB, group, id, label, default or {1,1,1,1}, opts or {})
    end
    function M.button(group, id, label, callback)
        if not menu or not menu.add_button then return end
        pcall(menu.add_button, M.TAB, group, id, label, callback)
    end
    function M.label(group, text)
        if menu and menu.add_label then pcall(menu.add_label, M.TAB, group, text) end
    end
    function M.sep(group)
        if menu and menu.add_separator then pcall(menu.add_separator, M.TAB, group) end
    end
    function M.input(group, id, label, default)
        if menu and menu.add_input then pcall(menu.add_input, M.TAB, group, id, label, default or "") end
    end
    function M.multicombo(group, id, label, options, defaults, opts)
        if menu and menu.add_multicombo then
            pcall(menu.add_multicombo, M.TAB, group, id, label, options, defaults, opts or {})
        end
    end
    function M.keybind(group, id, label, default, opts)
        opts = opts or {}
        opts.show_mode = opts.show_mode or false
        opts.key = opts.key or 0
        M.toggle(group, id, label, default, opts)
        local mode_id = id .. "_mode"
        M.combo(group, mode_id, label .. " Mode", {"Always", "Hold", "Toggle"}, 0, {parent = id})
    end

    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- FEATURE: Register all BobaV1 menu controls
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["boba.register_menu"] = (function()
    local M = {}
    local bmenu = BobaV1.require("boba.menu")
    local G = bmenu.G
    local BONES = BobaV1.require("core.esp_util").AIM_BONES
    local TARGET_TYPES = {"Closest", "Lowest HP", "Closest to Crosshair"}
    local FOV_STYLES = {"Circle", "Filled Circle", "Cross"}
    local BOX_MODES = {"2D", "Corner", "3D", "None"}

    function M.register()
        bmenu.init()

        -- в•ђв•ђв•ђ SILENT AIM GROUP в•ђв•ђв•ђ
        bmenu.keybind(G.SILENT_AIM, "boba_silent_aim", "Silent Aim", false)
        bmenu.combo(G.SILENT_AIM, "boba_silent_target_type", "Target Type", TARGET_TYPES, 0)
        bmenu.combo(G.SILENT_AIM, "boba_silent_bone", "Target Bone", BONES, 1)
        bmenu.slider(G.SILENT_AIM, "boba_silent_fov", "FOV", 10, 360, 120)
        bmenu.slider(G.SILENT_AIM, "boba_silent_max_dist", "Max Distance", 50, 2000, 800)
        bmenu.slider(G.SILENT_AIM, "boba_silent_hit_chance", "Hit Chance", 0, 100, 100)
        bmenu.toggle(G.SILENT_AIM, "boba_silent_hitscan", "Hitscan", false)
        bmenu.toggle(G.SILENT_AIM, "boba_silent_sticky", "Sticky Target", false)
        bmenu.sep(G.SILENT_AIM)
        bmenu.label(G.SILENT_AIM, "в”Ђв”Ђ Visuals в”Ђв”Ђ")
        bmenu.toggle(G.SILENT_AIM, "boba_silent_draw_fov", "Draw FOV", true)
        bmenu.combo(G.SILENT_AIM, "boba_silent_fov_style", "FOV Style", FOV_STYLES, 0)
        bmenu.toggle(G.SILENT_AIM, "boba_silent_target_line", "Target Line", false)
        bmenu.sep(G.SILENT_AIM)
        bmenu.label(G.SILENT_AIM, "в”Ђв”Ђ Filters в”Ђв”Ђ")
        bmenu.toggle(G.SILENT_AIM, "boba_silent_ignore_team", "Ignore Teammates", true)
        bmenu.toggle(G.SILENT_AIM, "boba_silent_ignore_downed", "Ignore Downed", true)
        bmenu.toggle(G.SILENT_AIM, "boba_silent_visible_only", "Visible Only", false)
        bmenu.sep(G.SILENT_AIM)
        bmenu.label(G.SILENT_AIM, "в”Ђв”Ђ Bullet в”Ђв”Ђ")
        bmenu.keybind(G.SILENT_AIM, "boba_bullet_enabled", "Bullet Manip", false)
        bmenu.toggle(G.SILENT_AIM, "boba_bullet_body_peek", "Body Peek", false)
        bmenu.toggle(G.SILENT_AIM, "boba_thick_bullet", "Thick Bullet", false)
        bmenu.slider(G.SILENT_AIM, "boba_thick_bullet_mult", "Thick Multiplier", 1, 5, 2)

        -- в•ђв•ђв•ђ GUN MODS GROUP в•ђв•ђв•ђ
        bmenu.keybind(G.GUN_MODS, "boba_gunmods", "Gun Mods", false)
        bmenu.toggle(G.GUN_MODS, "boba_gm_recoil", "No Recoil", false)
        bmenu.slider(G.GUN_MODS, "boba_gm_recoil_pct", "Recoil Reduction %", 0, 100, 100)
        bmenu.toggle(G.GUN_MODS, "boba_gm_spread", "No Spread", false)
        bmenu.slider(G.GUN_MODS, "boba_gm_spread_pct", "Spread Reduction %", 0, 100, 100)
        bmenu.toggle(G.GUN_MODS, "boba_gm_sway", "No Sway", false)
        bmenu.toggle(G.GUN_MODS, "boba_gm_fire_rate", "Fire Rate Mod", false)
        bmenu.slider(G.GUN_MODS, "boba_gm_fire_rate_mult", "Rate Multiplier", 1, 5, 2)
        bmenu.toggle(G.GUN_MODS, "boba_gm_speed", "Bullet Speed Mod", false)
        bmenu.slider(G.GUN_MODS, "boba_gm_speed_mult", "Speed Multiplier", 1, 5, 2)
        bmenu.toggle(G.GUN_MODS, "boba_gm_range", "Range Mod", false)
        bmenu.slider(G.GUN_MODS, "boba_gm_range_mult", "Range Multiplier", 1, 5, 2)
        bmenu.toggle(G.GUN_MODS, "boba_gm_double_tap", "Double Tap", false)
        bmenu.sep(G.GUN_MODS)
        bmenu.label(G.GUN_MODS, "в”Ђв”Ђ Tracers в”Ђв”Ђ")
        bmenu.keybind(G.GUN_MODS, "boba_tracers", "Tracers", false)
        bmenu.combo(G.GUN_MODS, "boba_tracers_style", "Style", {"Line","Arc","Curve","Beam"}, 0)
        bmenu.slider(G.GUN_MODS, "boba_tracers_lifetime", "Lifetime", 0.1, 5, 1)
        bmenu.slider(G.GUN_MODS, "boba_tracers_thickness", "Thickness", 1, 6, 2)
        bmenu.toggle(G.GUN_MODS, "boba_tracers_glow", "Glow", false)
        bmenu.toggle(G.GUN_MODS, "boba_tracers_rainbow", "Rainbow", false)

        -- в•ђв•ђв•ђ VISUALS GROUP в•ђв•ђв•ђ
        bmenu.keybind(G.VISUALS, "boba_player_esp", "Player ESP", false)
        bmenu.combo(G.VISUALS, "boba_player_box_mode", "Box Mode", BOX_MODES, 0)
        bmenu.toggle(G.VISUALS, "boba_player_health", "Health Bar", true)
        bmenu.toggle(G.VISUALS, "boba_player_skeleton", "Skeleton", true)
        bmenu.toggle(G.VISUALS, "boba_player_name", "Show Name", true)
        bmenu.toggle(G.VISUALS, "boba_player_held", "Show Held Item", true)
        bmenu.toggle(G.VISUALS, "boba_player_distance", "Show Distance", true)
        bmenu.toggle(G.VISUALS, "boba_player_clan", "Clan Tag", false)
        bmenu.slider(G.VISUALS, "boba_player_range", "Range", 50, 2000, 600)
        bmenu.sep(G.VISUALS)
        bmenu.label(G.VISUALS, "в”Ђв”Ђ Flags в”Ђв”Ђ")
        bmenu.toggle(G.VISUALS, "boba_flag_downed", "Downed", true)
        bmenu.toggle(G.VISUALS, "boba_flag_staff", "Staff", true)
        bmenu.toggle(G.VISUALS, "boba_flag_cheater", "Cheater", true)
        bmenu.sep(G.VISUALS)
        bmenu.label(G.VISUALS, "в”Ђв”Ђ Crosshair в”Ђв”Ђ")
        bmenu.toggle(G.VISUALS, "boba_crosshair", "Custom Crosshair", false)
        bmenu.combo(G.VISUALS, "boba_crosshair_type", "Type", {"Cross","Dot","Circle","T-Shape"}, 0)
        bmenu.slider(G.VISUALS, "boba_crosshair_size", "Size", 1, 20, 6)
        bmenu.slider(G.VISUALS, "boba_crosshair_gap", "Gap", 0, 15, 3)
        bmenu.sep(G.VISUALS)
        bmenu.label(G.VISUALS, "в”Ђв”Ђ Aimbot в”Ђв”Ђ")
        bmenu.keybind(G.VISUALS, "boba_aimbot", "Aimbot", false)
        bmenu.combo(G.VISUALS, "boba_aim_bone", "Bone", BONES, 1)
        bmenu.slider(G.VISUALS, "boba_aim_fov", "FOV", 10, 360, 120)
        bmenu.slider(G.VISUALS, "boba_aim_smooth", "Smooth", 1, 20, 5)
        bmenu.toggle(G.VISUALS, "boba_aim_prediction", "Auto Prediction", true)

        -- в•ђв•ђв•ђ WORLD GROUP в•ђв•ђв•ђ
        bmenu.keybind(G.WORLD, "boba_world_esp", "World ESP", false)
        bmenu.toggle(G.WORLD, "boba_world_stone", "Stone Nodes", true)
        bmenu.toggle(G.WORLD, "boba_world_metal", "Metal Nodes", true)
        bmenu.toggle(G.WORLD, "boba_world_phosphate", "Phosphate", true)
        bmenu.slider(G.WORLD, "boba_world_range", "Range", 50, 1000, 300)
        bmenu.sep(G.WORLD)
        bmenu.label(G.WORLD, "в”Ђв”Ђ Loot в”Ђв”Ђ")
        bmenu.keybind(G.WORLD, "boba_loot_esp", "Loot ESP", false)
        bmenu.toggle(G.WORLD, "boba_loot_crates", "Crates", true)
        bmenu.toggle(G.WORLD, "boba_loot_care_package", "Care Packages", true)
        bmenu.toggle(G.WORLD, "boba_loot_body_bag", "Body Bags", true)
        bmenu.slider(G.WORLD, "boba_loot_range", "Range", 50, 1000, 400)
        bmenu.sep(G.WORLD)
        bmenu.label(G.WORLD, "в”Ђв”Ђ NPC в”Ђв”Ђ")
        bmenu.keybind(G.WORLD, "boba_npc_esp", "NPC ESP", false)
        bmenu.toggle(G.WORLD, "boba_npc_soldier", "Soldiers", true)
        bmenu.toggle(G.WORLD, "boba_npc_bosses", "Bosses", true)
        bmenu.toggle(G.WORLD, "boba_npc_heli", "Attack Heli", true)
        bmenu.slider(G.WORLD, "boba_npc_range", "Range", 50, 1000, 500)
        bmenu.sep(G.WORLD)
        bmenu.label(G.WORLD, "в”Ђв”Ђ Base в”Ђв”Ђ")
        bmenu.keybind(G.WORLD, "boba_base_esp", "Base ESP", false)
        bmenu.toggle(G.WORLD, "boba_base_tc", "Tool Cupboard", true)
        bmenu.toggle(G.WORLD, "boba_base_turrets", "Turrets", true)
        bmenu.toggle(G.WORLD, "boba_base_doors", "Doors", true)
        bmenu.toggle(G.WORLD, "boba_base_xray", "X-Ray Mode", false)
        bmenu.slider(G.WORLD, "boba_base_range", "Range", 50, 500, 250)

        -- в•ђв•ђв•ђ RADAR GROUP в•ђв•ђв•ђ
        bmenu.keybind(G.RADAR, "boba_map", "Minimap", false)
        bmenu.slider(G.RADAR, "boba_map_zoom", "Zoom", 1, 5, 2)
        bmenu.slider(G.RADAR, "boba_map_size", "Size", 100, 400, 200)
        bmenu.slider(G.RADAR, "boba_map_opacity", "Opacity %", 10, 100, 85)
        bmenu.toggle(G.RADAR, "boba_map_players", "Show Players", true)
        bmenu.toggle(G.RADAR, "boba_map_npcs", "Show NPCs", true)
        bmenu.toggle(G.RADAR, "boba_map_loot", "Show Loot", true)
        bmenu.sep(G.RADAR)
        bmenu.label(G.RADAR, "в”Ђв”Ђ Waypoints в”Ђв”Ђ")
        bmenu.keybind(G.RADAR, "boba_waypoints", "Waypoints", false)
        bmenu.toggle(G.RADAR, "boba_wp_beacon", "Beacon", true)
        bmenu.sep(G.RADAR)
        bmenu.label(G.RADAR, "в”Ђв”Ђ Raids в”Ђв”Ђ")
        bmenu.keybind(G.RADAR, "boba_raid_alerts", "Raid Alerts", false)
        bmenu.slider(G.RADAR, "boba_raid_range", "Alert Range", 100, 2000, 800)

        -- в•ђв•ђв•ђ MISC GROUP в•ђв•ђв•ђ
        bmenu.label(G.MISC, "в”Ђв”Ђ Movement в”Ђв”Ђ")
        bmenu.keybind(G.MISC, "boba_fly", "Fly", false)
        bmenu.slider(G.MISC, "boba_fly_speed", "Fly Speed", 1, 20, 5)
        bmenu.toggle(G.MISC, "boba_fly_noclip", "Noclip", true)
        bmenu.keybind(G.MISC, "boba_bhop", "Bunny Hop", false)
        bmenu.keybind(G.MISC, "boba_spider", "Spider Climb", false)
        bmenu.slider(G.MISC, "boba_spider_speed", "Spider Speed", 18, 30, 18)
        bmenu.sep(G.MISC)
        bmenu.label(G.MISC, "в”Ђв”Ђ Combat в”Ђв”Ђ")
        bmenu.keybind(G.MISC, "boba_antifling", "Anti-Fling", false)
        bmenu.keybind(G.MISC, "boba_fling", "Fling", false)
        bmenu.slider(G.MISC, "boba_fling_fov", "Fling FOV", 10, 180, 90)
        bmenu.sep(G.MISC)
        bmenu.label(G.MISC, "в”Ђв”Ђ Anti-Aim в”Ђв”Ђ")
        bmenu.keybind(G.MISC, "boba_antiaim", "Anti-Aim", false)
        bmenu.combo(G.MISC, "boba_aa_yaw", "Yaw Mode", {"Backward","Spin","Jitter","Random"}, 0)
        bmenu.slider(G.MISC, "boba_aa_spin_speed", "Spin Speed", 1, 20, 5)
        bmenu.sep(G.MISC)
        bmenu.label(G.MISC, "в”Ђв”Ђ Desync в”Ђв”Ђ")
        bmenu.keybind(G.MISC, "boba_desync", "Desync", false)
        bmenu.keybind(G.MISC, "boba_fakeduck", "Fake Duck", false)
        bmenu.slider(G.MISC, "boba_fakeduck_height", "Duck Height", 0.5, 2.5, 1.4)
        bmenu.sep(G.MISC)
        bmenu.label(G.MISC, "в”Ђв”Ђ Other в”Ђв”Ђ")
        bmenu.toggle(G.MISC, "boba_anti_afk", "Anti-AFK", false)
        bmenu.keybind(G.MISC, "boba_autofarm", "Autofarm", false)
        bmenu.slider(G.MISC, "boba_autofarm_range", "Farm Range", 20, 200, 80)
    end

    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- FEATURE: Silent Aim Logic
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["features.silent_aim"] = (function()
    local settings = BobaV1.require("core.settings")
    local env = BobaV1.require("core.env")
    local entity_props = BobaV1.require("core.entity_props")
    local esp_util = BobaV1.require("core.esp_util")
    local silent_ray = BobaV1.require("core.silent_ray")
    local ballistic = BobaV1.require("core.ballistic")
    local math_util = BobaV1.require("core.math_util")
    local draw_util = BobaV1.require("core.draw_util")
    local M = {}

    local current_target = nil

    local function get_fov_to(sx, sy, tx, ty)
        local dx = tx - sx
        local dy = ty - sy
        return math.sqrt(dx * dx + dy * dy)
    end

    local function find_target()
        if not settings.enabled("boba_silent_aim") then return nil end
        if not silent_ray.available() then return nil end

        local lp = env.get_local_player()
        if not lp then return nil end
        local players = env.get_players()
        local sw, sh = draw_util.screen_size()
        local cx, cy = sw * 0.5, sh * 0.5
        local max_fov = settings.num("boba_silent_fov", 120)
        local max_dist = settings.num("boba_silent_max_dist", 800)
        local bone_name = esp_util.AIM_BONES[settings.num("boba_silent_bone", 1) + 1] or "Head"
        local ignore_team = settings.bool("boba_silent_ignore_team", true)
        local ignore_downed = settings.bool("boba_silent_ignore_downed", true)

        local best = nil
        local best_fov = max_fov

        for _, player in ipairs(players) do
            if player ~= lp then
                if entity_props.is_alive(player) then
                    if not (ignore_team and env.same_team(lp, player)) then
                        if not (ignore_downed and entity_props.is_downed(player)) then
                            local pos = entity_props.get_bone_position(player, bone_name)
                            if not pos then pos = entity_props.get_position(player) end
                            if pos then
                                local my_pos = entity_props.get_position(lp)
                                if my_pos then
                                    local dist = math_util.distance3(
                                        pos.x - my_pos.x,
                                        pos.y - my_pos.y,
                                        pos.z - my_pos.z
                                    )
                                    if dist <= max_dist then
                                        local sx, sy, vis = esp_util.w2s(pos.x, pos.y, pos.z)
                                        if vis then
                                            local fov = get_fov_to(cx, cy, sx, sy)
                                            if fov < best_fov then
                                                best_fov = fov
                                                best = {player = player, pos = pos, dist = dist, fov = fov}
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return best
    end

    function M.tick()
        if not settings.enabled("boba_silent_aim") then
            if silent_ray.is_tracking() then silent_ray.stop() end
            current_target = nil
            return
        end

        local target = find_target()
        if not target then
            if silent_ray.is_tracking() then silent_ray.stop() end
            current_target = nil
            return
        end

        -- Hit chance check
        local hit_chance = settings.num("boba_silent_hit_chance", 100)
        if hit_chance < 100 and math.random(1, 100) > hit_chance then
            silent_ray.stop()
            return
        end

        -- Predict if moving
        local aim_pos = target.pos
        if settings.bool("boba_aim_prediction", true) then
            local vel = entity_props.get_velocity(target.player)
            if vel then
                aim_pos = ballistic.predict_position(950, 0.55, vel, target.pos,
                    entity_props.get_position(env.get_local_player()) or {x=0,y=0,z=0})
            end
        end

        silent_ray.set_target(nil, aim_pos)
        current_target = target
    end

    function M.draw()
        if not settings.enabled("boba_silent_aim") then return end
        local sw, sh = draw_util.screen_size()
        local cx, cy = sw * 0.5, sh * 0.5
        local boba_amber = {0.83, 0.65, 0.46, 0.6}

        -- Draw FOV circle
        if settings.bool("boba_silent_draw_fov", true) then
            local fov = settings.num("boba_silent_fov", 120)
            draw_util.circle(cx, cy, fov, boba_amber, false, 48)
        end

        -- Draw target line
        if current_target and settings.bool("boba_silent_target_line", false) then
            local pos = current_target.pos
            local sx, sy, vis = esp_util.w2s(pos.x, pos.y, pos.z)
            if vis then
                draw_util.line(cx, cy, sx, sy, {1, 0.42, 0.42, 0.7}, 1.5)
            end
        end
    end

    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- FEATURE: Player ESP
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["features.player_esp"] = (function()
    local settings = BobaV1.require("core.settings")
    local env = BobaV1.require("core.env")
    local entity_props = BobaV1.require("core.entity_props")
    local esp_util = BobaV1.require("core.esp_util")
    local draw_util = BobaV1.require("core.draw_util")
    local math_util = BobaV1.require("core.math_util")
    local M = {}

    local BOBA_AMBER = {0.83, 0.65, 0.46, 1}
    local WHITE = {1, 1, 1, 1}
    local RED = {1, 0.42, 0.42, 1}
    local GREEN = {0.32, 0.81, 0.40, 1}
    local YELLOW = {1, 0.83, 0.23, 1}

    function M.draw()
        if not settings.enabled("boba_player_esp") then return end
        local lp = env.get_local_player()
        if not lp then return end
        local players = env.get_players()
        local max_range = settings.num("boba_player_range", 600)
        local my_pos = entity_props.get_position(lp)
        if not my_pos then return end
        local show_name = settings.bool("boba_player_name", true)
        local show_health = settings.bool("boba_player_health", true)
        local show_distance = settings.bool("boba_player_distance", true)
        local show_held = settings.bool("boba_player_held", true)
        local show_skeleton = settings.bool("boba_player_skeleton", true)

        for _, player in ipairs(players) do
            if player ~= lp and entity_props.is_alive(player) then
                local pos = entity_props.get_position(player)
                if pos then
                    local dist = math_util.distance3(pos.x - my_pos.x, pos.y - my_pos.y, pos.z - my_pos.z)
                    if dist <= max_range then
                        local head_pos = entity_props.get_bone_position(player, "Head")
                        if not head_pos then head_pos = {x=pos.x, y=pos.y+2.5, z=pos.z} end

                        local sx_top, sy_top, vis_top = esp_util.w2s(head_pos.x, head_pos.y + 0.35, head_pos.z)
                        local sx_bot, sy_bot, vis_bot = esp_util.w2s(pos.x, pos.y - 2.5, pos.z)

                        if vis_top or vis_bot then
                            local h = math.abs(sy_bot - sy_top)
                            local w = h * 0.55
                            local cx = (sx_top + sx_bot) * 0.5
                            local top = math.min(sy_top, sy_bot)

                            -- Color based on team
                            local col = env.same_team(lp, player) and GREEN or BOBA_AMBER

                            -- Box
                            local box_mode = settings.num("boba_player_box_mode", 0)
                            if box_mode == 0 then -- 2D
                                draw_util.rect(cx - w*0.5, top, w, h, col, 0, 1)
                            elseif box_mode == 1 then -- Corner
                                local corner = math.max(4, h * 0.2)
                                local x1, y1 = cx - w*0.5, top
                                local x2, y2 = cx + w*0.5, top + h
                                draw_util.line(x1, y1, x1 + corner, y1, col, 1)
                                draw_util.line(x1, y1, x1, y1 + corner, col, 1)
                                draw_util.line(x2, y1, x2 - corner, y1, col, 1)
                                draw_util.line(x2, y1, x2, y1 + corner, col, 1)
                                draw_util.line(x1, y2, x1 + corner, y2, col, 1)
                                draw_util.line(x1, y2, x1, y2 - corner, col, 1)
                                draw_util.line(x2, y2, x2 - corner, y2, col, 1)
                                draw_util.line(x2, y2, x2, y2 - corner, col, 1)
                            end

                            -- Health bar
                            if show_health then
                                local hp, maxhp = entity_props.get_health(player)
                                if hp and maxhp and maxhp > 0 then
                                    local pct = math_util.clamp(hp / maxhp, 0, 1)
                                    local bar_h = h * pct
                                    local bar_x = cx - w*0.5 - 4
                                    draw_util.rect_filled(bar_x, top, 2, h, {0.15, 0.15, 0.15, 0.7}, 0)
                                    local hcol = pct > 0.5 and GREEN or (pct > 0.25 and YELLOW or RED)
                                    draw_util.rect_filled(bar_x, top + h - bar_h, 2, bar_h, hcol, 0)
                                end
                            end

                            -- Info text
                            local info_y = top - 14
                            if show_name then
                                local name = entity_props.get_display_name(player)
                                draw_util.text_centered(cx, info_y, name, WHITE, 12)
                                info_y = info_y - 12
                            end
                            if show_distance then
                                draw_util.text_centered(cx, top + h + 3,
                                    string.format("%.0fm", dist),
                                    {0.55, 0.54, 0.60, 1}, 11)
                            end
                            if show_held then
                                local held = entity_props.get_held_item(player)
                                if held then
                                    draw_util.text_centered(cx, top + h + 15,
                                        held, BOBA_AMBER, 11)
                                end
                            end

                            -- Flags
                            if settings.bool("boba_flag_downed", true) and entity_props.is_downed(player) then
                                draw_util.text_centered(cx, info_y, "DOWNED", RED, 10)
                                info_y = info_y - 11
                            end

                            -- Skeleton
                            if show_skeleton then
                                local bones = {}
                                local char = env.get_character(player)
                                if char then
                                    for _, bone_name in ipairs({"Head","UpperTorso","LowerTorso",
                                        "LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm",
                                        "LeftHand","RightHand","LeftUpperLeg","RightUpperLeg",
                                        "LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}) do
                                        local bp = entity_props.get_bone_position(player, bone_name)
                                        if bp then
                                            local bsx, bsy, bvis = esp_util.w2s(bp.x, bp.y, bp.z)
                                            if bvis then bones[bone_name] = {x=bsx, y=bsy} end
                                        end
                                    end
                                end
                                esp_util.draw_skeleton_bones(bones, {1, 1, 1, 0.7}, 1.5)
                            end
                        end
                    end
                end
            end
        end
    end

    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- FEATURE: Crosshair
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["features.crosshair"] = (function()
    local settings = BobaV1.require("core.settings")
    local draw_util = BobaV1.require("core.draw_util")
    local M = {}
    function M.draw()
        if not settings.enabled("boba_crosshair") then return end
        local sw, sh = draw_util.screen_size()
        local cx, cy = sw * 0.5, sh * 0.5
        local size = settings.num("boba_crosshair_size", 6)
        local gap = settings.num("boba_crosshair_gap", 3)
        local col = {0.83, 0.65, 0.46, 1}
        -- Cross
        draw_util.line(cx - size - gap, cy, cx - gap, cy, col, 2)
        draw_util.line(cx + gap, cy, cx + size + gap, cy, col, 2)
        draw_util.line(cx, cy - size - gap, cx, cy - gap, col, 2)
        draw_util.line(cx, cy + gap, cx, cy + size + gap, col, 2)
        -- Dot
        draw_util.circle(cx, cy, 1.5, col, true)
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- MAIN LOOP вЂ” Wire everything together
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["boba.main"] = (function()
    local M = {}
    local notify = BobaV1.require("core.notify")
    local silent_aim = BobaV1.require("features.silent_aim")
    local player_esp = BobaV1.require("features.player_esp")
    local crosshair = BobaV1.require("features.crosshair")
    local register_menu = BobaV1.require("boba.register_menu")

    local function render_frame()
        notify.draw()
        silent_aim.draw()
        player_esp.draw()
        crosshair.draw()
        silent_aim.tick()
    end

    function M.boot()
        print("[BobaV1] API Check:")
        print("  menu: " .. tostring(menu ~= nil))
        print("  draw: " .. tostring(draw ~= nil))
        print("  entity: " .. tostring(entity ~= nil))
        print("  raycast: " .. tostring(raycast ~= nil))
        print("  camera: " .. tostring(camera ~= nil))
        print("  utility: " .. tostring(utility ~= nil))
        print("  callbacks: " .. tostring(callbacks ~= nil))
        print("  client: " .. tostring(client ~= nil))
        print("  exploits: " .. tostring(exploits ~= nil))

        if menu then
            local fns = {}
            for k, v in pairs(menu) do
                if type(v) == "function" then fns[#fns+1] = k end
            end
            print("  menu funcs: " .. table.concat(fns, ", "))
        end
        if draw then
            local fns = {}
            for k, v in pairs(draw) do
                if type(v) == "function" then fns[#fns+1] = k end
            end
            print("  draw funcs: " .. table.concat(fns, ", "))
        end
        if callbacks then
            local fns = {}
            for k, v in pairs(callbacks) do
                if type(v) == "function" then fns[#fns+1] = k end
            end
            print("  callbacks funcs: " .. table.concat(fns, ", "))
        end

        register_menu.register()
        print("[BobaV1] Menu registered")
        notify.success("BobaV1 v" .. BobaV1.VERSION .. " loaded!", 4000)

        local hooked = false

        if not hooked and callbacks and type(callbacks) == "table" then
            if callbacks.register and type(callbacks.register) == "function" then
                print("[BobaV1] Hooking: callbacks.register('on_paint')")
                callbacks.register("on_paint", render_frame)
                hooked = true
            end
            if not hooked and callbacks.add and type(callbacks.add) == "function" then
                print("[BobaV1] Hooking: callbacks.add('on_paint')")
                callbacks.add("on_paint", render_frame)
                hooked = true
            end
        end

        if not hooked and draw and draw.register and type(draw.register) == "function" then
            print("[BobaV1] Hooking: draw.register")
            draw.register(render_frame)
            hooked = true
        end

        if not hooked and menu then
            if menu.register_draw and type(menu.register_draw) == "function" then
                print("[BobaV1] Hooking: menu.register_draw")
                menu.register_draw(render_frame)
                hooked = true
            end
            if not hooked and menu.on_draw and type(menu.on_draw) == "function" then
                print("[BobaV1] Hooking: menu.on_draw")
                menu.on_draw(render_frame)
                hooked = true
            end
        end

        if not hooked and client and client.set_event_callback then
            print("[BobaV1] Hooking: client.set_event_callback")
            client.set_event_callback("paint", render_frame)
            hooked = true
        end

        if not hooked then
            if type(register_callback) == "function" then
                print("[BobaV1] Hooking: register_callback global")
                register_callback("on_paint", render_frame)
                hooked = true
            end
        end

        if not hooked then
            print("[BobaV1] No callback API, trying RunService...")
            local ok, rs = pcall(function()
                if game and game.GetService then
                    return game:GetService("RunService")
                end
            end)
            if ok and rs then
                if rs.RenderStepped then
                    rs.RenderStepped:Connect(render_frame)
                    hooked = true
                    print("[BobaV1] Hooked RunService.RenderStepped")
                elseif rs.Heartbeat then
                    rs.Heartbeat:Connect(render_frame)
                    hooked = true
                    print("[BobaV1] Hooked RunService.Heartbeat")
                end
            end
        end

        if not hooked then
            print("[BobaV1] FALLBACK: using while loop")
            local wfn = (task and task.wait) or wait
            if wfn then
                spawn(function()
                    while true do
                        render_frame()
                        wfn(0.016)
                    end
                end)
                hooked = true
            end
        end

        print("[BobaV1] Hook status: " .. tostring(hooked))
        print("[BobaV1] All features registered and active")
    end

    return M
end)()

print("в•”в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•—")
print("в•‘         BobaV1 v" .. BobaV1.VERSION .. "              в•‘")
print("в•‘        Fallen Survival              в•‘")
print("в•‘     Press Insert to toggle menu     в•‘")
print("в•љв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ќ")

BobaV1.require("boba.main").boot()

