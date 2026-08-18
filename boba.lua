--[[
    BobaV1 v1.0.0 — Fallen Survival
    Standalone cheat script for Project Vector
    
    Paste into Vector:
    utility.LoadUrl("https://raw.githubusercontent.com/boqnpenev1-design/BobaV1/main/boba.lua")
]]

BobaV1 = BobaV1 or {}
BobaV1._mods = {}
BobaV1.VERSION = "1.0.0"
BobaV1.NAME = "BobaV1"

function BobaV1.require(name)
    local mod = BobaV1._mods[name]
    if mod then return mod end
    return nil
end

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
        return nil
    end
    function M.get_players()
        if entity and entity.get_players then
            local ok, list = pcall(entity.get_players)
            if ok and type(list) == "table" then return list end
        end
        return {}
    end
    function M.get_character(player)
        if not player then return nil end
        return player.Character or player.character
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

BobaV1._mods["core.api_aliases"] = (function()
    local M = {}
    M._applied = false
    function M.apply()
        if M._applied then return end
        M._applied = true
        if utility then
            utility.get_tick_count = utility.get_tick_count or utility.GetTickCount
            utility.get_delta_time = utility.get_delta_time or utility.GetDeltaTime
        end
        if raycast then
            raycast.is_visible = raycast.is_visible or raycast.IsVisible
            raycast.set_silent_target = raycast.set_silent_target or raycast.SetSilentTarget
            raycast.stop_silent_tracking = raycast.stop_silent_tracking or raycast.StopSilentTracking
            raycast.enable_silent_hook = raycast.enable_silent_hook or raycast.EnableSilentHook
        end
        if camera then
            camera.get_position = camera.get_position or camera.GetPosition
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
        end
    end
    M.apply()
    return M
end)()

BobaV1._mods["core.settings"] = (function()
    local M = {}
    local _values = {}
    local _callbacks = {}
    function M.set(key, value)
        if key == nil then return end
        local old = _values[key]
        _values[key] = value
        if old ~= value and _callbacks[key] then
            for _, fn in ipairs(_callbacks[key]) do pcall(fn, value, old) end
        end
    end
    function M.get(key, default)
        local v = _values[key]
        if v ~= nil then return v end
        if menu and menu.get then
            local ok, mv = pcall(menu.get, key)
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
    function M.enabled(key) return M.bool(key, false) end
    function M.num(key, default)
        return tonumber(M.get(key, default)) or (tonumber(default) or 0)
    end
    function M.on_change(key, fn)
        if not key or type(fn) ~= "function" then return end
        _callbacks[key] = _callbacks[key] or {}
        _callbacks[key][#_callbacks[key]+1] = fn
    end
    if menu and menu.set_callback then
        pcall(menu.set_callback, "on_value_changed", function(id, value)
            _values[id] = value
            if _callbacks[id] then
                for _, fn in ipairs(_callbacks[id]) do pcall(fn, value) end
            end
        end)
    end
    return M
end)()

BobaV1._mods["core.math_util"] = (function()
    local M = {}
    function M.clamp(v, lo, hi)
        if v < lo then return lo end
        if v > hi then return hi end
        return v
    end
    function M.lerp(a, b, t) return a + (b - a) * t end
    function M.distance3(dx, dy, dz) return math.sqrt(dx*dx + dy*dy + dz*dz) end
    function M.distance2(dx, dy) return math.sqrt(dx*dx + dy*dy) end
    return M
end)()

BobaV1._mods["core.draw_util"] = (function()
    local M = {}
    function M.screen_size()
        if draw and draw.get_screen_size then
            local ok, w, h = pcall(draw.get_screen_size)
            if ok then return w, h end
        end
        return 1920, 1080
    end
    function M.line(x1, y1, x2, y2, col, thick)
        if draw and draw.line then draw.line(x1, y1, x2, y2, col, thick or 1) end
    end
    function M.rect(x, y, w, h, col, rounding, thick)
        if draw and draw.rect then draw.rect(x, y, w, h, col, rounding or 0, thick or 1) end
    end
    function M.rect_filled(x, y, w, h, col, rounding)
        if draw and draw.rect_filled then draw.rect_filled(x, y, w, h, col, rounding or 0) end
    end
    function M.text(x, y, msg, col, size)
        if draw and draw.text then draw.text(x, y, msg, col, size or 13) end
    end
    function M.text_centered(x, y, msg, col, size)
        size = size or 13
        if draw and draw.text then
            local tw = #msg * (size * 0.55)
            if draw.get_text_size then
                local ok, w = pcall(draw.get_text_size, msg, size)
                if ok and w then tw = w end
            end
            draw.text(x - tw * 0.5, y, msg, col, size)
        end
    end
    function M.circle(x, y, r, col, filled, segments)
        segments = segments or 24
        if filled and draw and draw.circle_filled then
            draw.circle_filled(x, y, r, col, segments)
        elseif draw and draw.circle then
            draw.circle(x, y, r, col, segments, 1)
        end
    end
    return M
end)()

BobaV1._mods["core.text_util"] = (function()
    local M = {}
    function M.sanitize(text)
        if type(text) ~= "string" then return tostring(text or "") end
        text = text:gsub("[\r\n\t]", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
        if #text > 256 then text = text:sub(1, 256) .. "..." end
        return text
    end
    return M
end)()

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
        queue[#queue+1] = {
            msg = msg, type = ntype, time = tick(),
            duration = duration_ms, alpha = 0, x_off = 80, y = 0,
        }
        while #queue > 6 do table.remove(queue, 1) end
    end
    function M.success(msg, dur) M.toast(msg, "success", dur) end
    function M.warning(msg, dur) M.toast(msg, "warning", dur) end
    function M.error(msg, dur) M.toast(msg, "danger", dur) end
    function M.info(msg, dur) M.toast(msg, "info", dur) end
    local COLORS = {
        success = {0.32, 0.81, 0.40, 1},
        warning = {1.0, 0.83, 0.23, 1},
        danger = {1.0, 0.42, 0.42, 1},
        info = {0.83, 0.65, 0.46, 1},
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
                local ta = 1
                if elapsed < fade then ta = elapsed / fade
                elseif elapsed > n.duration - fade then ta = (n.duration - elapsed) / fade end
                n.alpha = lerp(n.alpha or 0, ta, 0.18)
                local slide = 0
                if elapsed > n.duration - fade then slide = 60 end
                n.x_off = lerp(n.x_off or 80, slide, 0.15)
                if n.y == 0 then n.y = target_y end
                n.y = lerp(n.y, target_y, 0.2)
                local accent = COLORS[n.type] or COLORS.info
                local tw = #n.msg * (font * 0.55)
                local box_w = tw + pad * 2 + 4
                local box_h = font + pad * 2
                local sw = select(1, draw_util.screen_size())
                local x = sw - box_w - 16 + (n.x_off or 0)
                local y = n.y
                local a = n.alpha or 1
                draw_util.rect_filled(x, y, box_w, box_h, {0.06, 0.06, 0.09, 0.94 * a}, 0)
                draw_util.rect_filled(x + 2, y, box_w - 3, 2, {accent[1], accent[2], accent[3], a}, 0)
                draw_util.rect(x, y, box_w, box_h, {0.83, 0.65, 0.46, 0.15 * a}, 0, 1)
                draw_util.text(x + pad, y + pad - 1, n.msg, {0.91, 0.90, 0.94, a}, font)
                target_y = target_y + box_h + gap
            end
        end
    end
    return M
end)()

BobaV1._mods["core.esp_util"] = (function()
    local draw_util = BobaV1.require("core.draw_util")
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
            if ok and a and type(a) == "number" then
                return a, b, c ~= false and c ~= 0
            end
        end
        return 0, 0, false
    end
    function M.draw_skeleton_bones(bones, col, thick)
        if not bones then return end
        for _, pair in ipairs(M.SKELETON_PAIRS) do
            local a = bones[pair[1]]
            local b = bones[pair[2]]
            if a and b and a.x and b.x then
                draw_util.line(a.x, a.y, b.x, b.y, col, thick or 1.5)
            end
        end
    end
    return M
end)()

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
                end)
            end
        end
        if not hum then return nil, nil end
        return tonumber(hum.Health or hum.health), tonumber(hum.MaxHealth or hum.max_health or 100)
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
            if state then return state:GetAttribute("IsDowned") == true end
            return false
        end) == true
    end
    function M.get_position(player)
        if not player then return nil end
        local char = env.get_character(player)
        if not char then return nil end
        return env.safe_call(function()
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position or root.position
                if pos then return {x = pos.X or pos.x, y = pos.Y or pos.y, z = pos.Z or pos.z} end
            end
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
                if pos then return {x = pos.X or pos.x, y = pos.Y or pos.y, z = pos.Z or pos.z} end
            end
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
                if vel then return {x = vel.X or vel.x or 0, y = vel.Y or vel.y or 0, z = vel.Z or vel.z or 0} end
            end
            return {x=0,y=0,z=0}
        end)
    end
    function M.get_name(player)
        return player and (player.Name or player.name or "?") or "?"
    end
    function M.get_display_name(player)
        return player and (player.DisplayName or player.display_name or M.get_name(player)) or "?"
    end
    function M.get_held_item(player)
        if not player then return nil end
        local char = env.get_character(player)
        if not char then return nil end
        return env.safe_call(function()
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then return tool.Name or tool.name end
        end)
    end
    return M
end)()

BobaV1._mods["core.silent_ray"] = (function()
    local M = {}
    local hook_ready = false
    local tracking = false
    local function ray_fn(snake, pascal)
        if not raycast then return nil end
        local fn = raycast[snake] or raycast[pascal]
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
        return ray_fn("set_silent_target", "SetSilentTarget") ~= nil
    end
    function M.ensure_hook()
        if not M.available() then return false end
        if hook_ready then return true end
        local enable = ray_fn("enable_silent_hook", "EnableSilentHook")
        if not enable then hook_ready = true; return true end
        local ok = pcall(enable)
        hook_ready = ok
        return hook_ready
    end
    function M.get_camera_origin()
        if not camera then return nil end
        local get_pos = camera.get_position or camera.GetPosition
        if type(get_pos) ~= "function" then return nil end
        local ok, pos = pcall(get_pos)
        if not ok or not pos then return nil end
        return {x = pos.x or pos.X, y = pos.y or pos.Y, z = pos.z or pos.Z}
    end
    function M.stop()
        tracking = false
        local stop = ray_fn("stop_silent_tracking", "StopSilentTracking")
        if stop then pcall(stop) end
    end
    function M.set_target(origin, aim_point)
        if not aim_point then return false end
        origin = origin or M.get_camera_origin()
        if not origin then return false end
        if not M.ensure_hook() then return false end
        local set_fn = ray_fn("set_silent_target", "SetSilentTarget")
        if not set_fn then return false end
        local ok = pcall(set_fn, make_vec3(origin.x, origin.y, origin.z),
            make_vec3(aim_point.x - origin.x, aim_point.y - origin.y, aim_point.z - origin.z))
        tracking = ok
        return ok
    end
    function M.is_tracking() return tracking end
    return M
end)()

BobaV1._mods["core.ballistic"] = (function()
    local math_util = BobaV1.require("core.math_util")
    local M = {}
    function M.predict_position(bullet_speed, bullet_gravity, velocity, position, origin)
        local speed = math.max(bullet_speed or 950, 1)
        local dist = math_util.distance3(position.x - origin.x, position.y - origin.y, position.z - origin.z)
        local time = dist / speed
        local grav = bullet_gravity or 0.55
        local drop = 0.5 * grav * 195 * time * time
        return {
            x = position.x + (velocity.x or 0) * time,
            y = position.y + (velocity.y or 0) * time + drop,
            z = position.z + (velocity.z or 0) * time,
        }
    end
    return M
end)()

-- ═══════════════════════════════════════════════════════
-- MENU SYSTEM
-- ═══════════════════════════════════════════════════════
BobaV1._mods["boba.menu"] = (function()
    local M = {}
    M.TAB = "BobaV1"
    M.G = {
        SILENT_AIM = "Silent Aim", GUN_MODS = "Gun Mods",
        VISUALS = "Visuals", WORLD = "World",
        RADAR = "Radar", MISC = "Misc",
    }
    local _tab_ready = false
    local _groups = {}

    function M.init()
        if _tab_ready or not menu then return end
        if menu.add_tab then menu.add_tab(M.TAB) end
        _tab_ready = true
        local layout = {
            {M.G.SILENT_AIM, "left"}, {M.G.GUN_MODS, "right"},
            {M.G.VISUALS, "left"}, {M.G.WORLD, "right"},
            {M.G.RADAR, "left"}, {M.G.MISC, "right"},
        }
        for _, row in ipairs(layout) do
            local name, side = row[1], row[2]
            if not _groups[name] and menu.add_group then
                if side == "right" then
                    menu.add_group(M.TAB, name, 0, true)
                else
                    menu.add_group(M.TAB, name)
                end
                _groups[name] = true
            end
        end
    end

    function M.toggle(group, id, label, default)
        if menu and menu.add_checkbox then menu.add_checkbox(M.TAB, group, id, label, default or false) end
    end
    function M.slider(group, id, label, min, max, default, is_float)
        if not menu then return end
        if is_float or (type(default) == "number" and default ~= math.floor(default)) then
            if menu.add_slider_float then menu.add_slider_float(M.TAB, group, id, label, min, max, default or min) end
        else
            if menu.add_slider_int then menu.add_slider_int(M.TAB, group, id, label, min, max, default or min) end
        end
    end
    function M.combo(group, id, label, options, default)
        if menu and menu.add_combo then menu.add_combo(M.TAB, group, id, label, options, default or 0) end
    end
    function M.color(group, id, label, default)
        if menu and menu.add_colorpicker then menu.add_colorpicker(M.TAB, group, id, label, default or {1,1,1,1}) end
    end
    function M.button(group, id, label, callback)
        if menu and menu.add_button then menu.add_button(M.TAB, group, id, label, callback) end
    end
    function M.label(group, text)
        if menu and menu.add_label then menu.add_label(M.TAB, group, text) end
    end
    function M.sep(group)
        if menu and menu.add_separator then menu.add_separator(M.TAB, group) end
    end
    function M.hotkey(group, id, label, default)
        if menu and menu.add_hotkey then
            menu.add_hotkey(M.TAB, group, id, label, default or 0)
        else
            M.toggle(group, id, label, false)
        end
    end
    return M
end)()

-- ═══════════════════════════════════════════════════════
-- REGISTER MENU
-- ═══════════════════════════════════════════════════════
BobaV1._mods["boba.register_menu"] = (function()
    local M = {}
    local bm = BobaV1.require("boba.menu")
    local G = bm.G
    local BONES = BobaV1.require("core.esp_util").AIM_BONES

    function M.register()
        bm.init()

        bm.hotkey(G.SILENT_AIM, "boba_silent_aim", "Silent Aim")
        bm.combo(G.SILENT_AIM, "boba_silent_target_type", "Target Type", {"Closest","Lowest HP","Closest to Crosshair"}, 0)
        bm.combo(G.SILENT_AIM, "boba_silent_bone", "Target Bone", BONES, 1)
        bm.slider(G.SILENT_AIM, "boba_silent_fov", "FOV", 10, 360, 120)
        bm.slider(G.SILENT_AIM, "boba_silent_max_dist", "Max Distance", 50, 2000, 800)
        bm.slider(G.SILENT_AIM, "boba_silent_hit_chance", "Hit Chance", 0, 100, 100)
        bm.toggle(G.SILENT_AIM, "boba_silent_hitscan", "Hitscan", false)
        bm.toggle(G.SILENT_AIM, "boba_silent_sticky", "Sticky Target", false)
        bm.sep(G.SILENT_AIM)
        bm.label(G.SILENT_AIM, "── Visuals ──")
        bm.toggle(G.SILENT_AIM, "boba_silent_draw_fov", "Draw FOV", true)
        bm.combo(G.SILENT_AIM, "boba_silent_fov_style", "FOV Style", {"Circle","Filled Circle","Cross"}, 0)
        bm.toggle(G.SILENT_AIM, "boba_silent_target_line", "Target Line", false)
        bm.sep(G.SILENT_AIM)
        bm.label(G.SILENT_AIM, "── Filters ──")
        bm.toggle(G.SILENT_AIM, "boba_silent_ignore_team", "Ignore Teammates", true)
        bm.toggle(G.SILENT_AIM, "boba_silent_ignore_downed", "Ignore Downed", true)
        bm.toggle(G.SILENT_AIM, "boba_silent_visible_only", "Visible Only", false)
        bm.sep(G.SILENT_AIM)
        bm.label(G.SILENT_AIM, "── Bullet ──")
        bm.hotkey(G.SILENT_AIM, "boba_bullet_enabled", "Bullet Manip")
        bm.toggle(G.SILENT_AIM, "boba_bullet_body_peek", "Body Peek", false)
        bm.toggle(G.SILENT_AIM, "boba_thick_bullet", "Thick Bullet", false)
        bm.slider(G.SILENT_AIM, "boba_thick_bullet_mult", "Thick Multiplier", 1, 5, 2)

        bm.hotkey(G.GUN_MODS, "boba_gunmods", "Gun Mods")
        bm.toggle(G.GUN_MODS, "boba_gm_recoil", "No Recoil", false)
        bm.slider(G.GUN_MODS, "boba_gm_recoil_pct", "Recoil Reduction %", 0, 100, 100)
        bm.toggle(G.GUN_MODS, "boba_gm_spread", "No Spread", false)
        bm.slider(G.GUN_MODS, "boba_gm_spread_pct", "Spread Reduction %", 0, 100, 100)
        bm.toggle(G.GUN_MODS, "boba_gm_sway", "No Sway", false)
        bm.toggle(G.GUN_MODS, "boba_gm_fire_rate", "Fire Rate Mod", false)
        bm.slider(G.GUN_MODS, "boba_gm_fire_rate_mult", "Rate Multiplier", 1, 5, 2)
        bm.toggle(G.GUN_MODS, "boba_gm_speed", "Bullet Speed Mod", false)
        bm.slider(G.GUN_MODS, "boba_gm_speed_mult", "Speed Multiplier", 1, 5, 2)
        bm.toggle(G.GUN_MODS, "boba_gm_range", "Range Mod", false)
        bm.slider(G.GUN_MODS, "boba_gm_range_mult", "Range Multiplier", 1, 5, 2)
        bm.toggle(G.GUN_MODS, "boba_gm_double_tap", "Double Tap", false)
        bm.sep(G.GUN_MODS)
        bm.label(G.GUN_MODS, "── Tracers ──")
        bm.hotkey(G.GUN_MODS, "boba_tracers", "Tracers")
        bm.combo(G.GUN_MODS, "boba_tracers_style", "Style", {"Line","Arc","Curve","Beam"}, 0)
        bm.slider(G.GUN_MODS, "boba_tracers_lifetime", "Lifetime", 0.1, 5, 1, true)
        bm.slider(G.GUN_MODS, "boba_tracers_thickness", "Thickness", 1, 6, 2)
        bm.toggle(G.GUN_MODS, "boba_tracers_rainbow", "Rainbow", false)

        bm.hotkey(G.VISUALS, "boba_player_esp", "Player ESP")
        bm.combo(G.VISUALS, "boba_player_box_mode", "Box Mode", {"2D","Corner","3D","None"}, 0)
        bm.toggle(G.VISUALS, "boba_player_health", "Health Bar", true)
        bm.toggle(G.VISUALS, "boba_player_skeleton", "Skeleton", true)
        bm.toggle(G.VISUALS, "boba_player_name", "Show Name", true)
        bm.toggle(G.VISUALS, "boba_player_held", "Show Held Item", true)
        bm.toggle(G.VISUALS, "boba_player_distance", "Show Distance", true)
        bm.slider(G.VISUALS, "boba_player_range", "Range", 50, 2000, 600)
        bm.sep(G.VISUALS)
        bm.label(G.VISUALS, "── Crosshair ──")
        bm.toggle(G.VISUALS, "boba_crosshair", "Custom Crosshair", false)
        bm.combo(G.VISUALS, "boba_crosshair_type", "Type", {"Cross","Dot","Circle","T-Shape"}, 0)
        bm.slider(G.VISUALS, "boba_crosshair_size", "Size", 1, 20, 6)
        bm.slider(G.VISUALS, "boba_crosshair_gap", "Gap", 0, 15, 3)
        bm.sep(G.VISUALS)
        bm.label(G.VISUALS, "── Aimbot ──")
        bm.hotkey(G.VISUALS, "boba_aimbot", "Aimbot")
        bm.combo(G.VISUALS, "boba_aim_bone", "Bone", BONES, 1)
        bm.slider(G.VISUALS, "boba_aim_fov", "FOV", 10, 360, 120)
        bm.slider(G.VISUALS, "boba_aim_smooth", "Smooth", 1, 20, 5)
        bm.toggle(G.VISUALS, "boba_aim_prediction", "Auto Prediction", true)

        bm.hotkey(G.WORLD, "boba_world_esp", "World ESP")
        bm.toggle(G.WORLD, "boba_world_stone", "Stone Nodes", true)
        bm.toggle(G.WORLD, "boba_world_metal", "Metal Nodes", true)
        bm.toggle(G.WORLD, "boba_world_phosphate", "Phosphate", true)
        bm.slider(G.WORLD, "boba_world_range", "Range", 50, 1000, 300)
        bm.sep(G.WORLD)
        bm.label(G.WORLD, "── Loot ──")
        bm.hotkey(G.WORLD, "boba_loot_esp", "Loot ESP")
        bm.toggle(G.WORLD, "boba_loot_crates", "Crates", true)
        bm.toggle(G.WORLD, "boba_loot_care_package", "Care Packages", true)
        bm.toggle(G.WORLD, "boba_loot_body_bag", "Body Bags", true)
        bm.slider(G.WORLD, "boba_loot_range", "Range", 50, 1000, 400)
        bm.sep(G.WORLD)
        bm.label(G.WORLD, "── NPC ──")
        bm.hotkey(G.WORLD, "boba_npc_esp", "NPC ESP")
        bm.toggle(G.WORLD, "boba_npc_soldier", "Soldiers", true)
        bm.toggle(G.WORLD, "boba_npc_bosses", "Bosses", true)
        bm.toggle(G.WORLD, "boba_npc_heli", "Attack Heli", true)
        bm.slider(G.WORLD, "boba_npc_range", "Range", 50, 1000, 500)
        bm.sep(G.WORLD)
        bm.label(G.WORLD, "── Base ──")
        bm.hotkey(G.WORLD, "boba_base_esp", "Base ESP")
        bm.toggle(G.WORLD, "boba_base_tc", "Tool Cupboard", true)
        bm.toggle(G.WORLD, "boba_base_turrets", "Turrets", true)
        bm.toggle(G.WORLD, "boba_base_doors", "Doors", true)
        bm.slider(G.WORLD, "boba_base_range", "Range", 50, 500, 250)

        bm.hotkey(G.RADAR, "boba_map", "Minimap")
        bm.slider(G.RADAR, "boba_map_zoom", "Zoom", 1, 5, 2)
        bm.slider(G.RADAR, "boba_map_size", "Size", 100, 400, 200)
        bm.slider(G.RADAR, "boba_map_opacity", "Opacity %", 10, 100, 85)
        bm.toggle(G.RADAR, "boba_map_players", "Show Players", true)
        bm.toggle(G.RADAR, "boba_map_npcs", "Show NPCs", true)
        bm.toggle(G.RADAR, "boba_map_loot", "Show Loot", true)
        bm.sep(G.RADAR)
        bm.hotkey(G.RADAR, "boba_raid_alerts", "Raid Alerts")
        bm.slider(G.RADAR, "boba_raid_range", "Alert Range", 100, 2000, 800)

        bm.label(G.MISC, "── Movement ──")
        bm.hotkey(G.MISC, "boba_fly", "Fly")
        bm.slider(G.MISC, "boba_fly_speed", "Fly Speed", 1, 20, 5)
        bm.toggle(G.MISC, "boba_fly_noclip", "Noclip", true)
        bm.hotkey(G.MISC, "boba_bhop", "Bunny Hop")
        bm.hotkey(G.MISC, "boba_spider", "Spider Climb")
        bm.slider(G.MISC, "boba_spider_speed", "Spider Speed", 18, 30, 18)
        bm.sep(G.MISC)
        bm.label(G.MISC, "── Combat ──")
        bm.hotkey(G.MISC, "boba_antifling", "Anti-Fling")
        bm.hotkey(G.MISC, "boba_fling", "Fling")
        bm.slider(G.MISC, "boba_fling_fov", "Fling FOV", 10, 180, 90)
        bm.sep(G.MISC)
        bm.label(G.MISC, "── Anti-Aim ──")
        bm.hotkey(G.MISC, "boba_antiaim", "Anti-Aim")
        bm.combo(G.MISC, "boba_aa_yaw", "Yaw Mode", {"Backward","Spin","Jitter","Random"}, 0)
        bm.slider(G.MISC, "boba_aa_spin_speed", "Spin Speed", 1, 20, 5)
        bm.sep(G.MISC)
        bm.hotkey(G.MISC, "boba_desync", "Desync")
        bm.hotkey(G.MISC, "boba_fakeduck", "Fake Duck")
        bm.slider(G.MISC, "boba_fakeduck_height", "Duck Height", 0.5, 2.5, 1.4, true)
        bm.sep(G.MISC)
        bm.toggle(G.MISC, "boba_anti_afk", "Anti-AFK", false)
        bm.hotkey(G.MISC, "boba_autofarm", "Autofarm")
        bm.slider(G.MISC, "boba_autofarm_range", "Farm Range", 20, 200, 80)
    end

    return M
end)()

-- ═══════════════════════════════════════════════════════
-- FEATURES
-- ═══════════════════════════════════════════════════════
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
        local best, best_fov = nil, max_fov
        for _, player in ipairs(players) do
            if player ~= lp and entity_props.is_alive(player) then
                if not (settings.bool("boba_silent_ignore_team", true) and env.same_team(lp, player)) then
                    if not (settings.bool("boba_silent_ignore_downed", true) and entity_props.is_downed(player)) then
                        local pos = entity_props.get_bone_position(player, bone_name) or entity_props.get_position(player)
                        if pos then
                            local my_pos = entity_props.get_position(lp)
                            if my_pos then
                                local dist = math_util.distance3(pos.x-my_pos.x, pos.y-my_pos.y, pos.z-my_pos.z)
                                if dist <= max_dist then
                                    local sx, sy, vis = esp_util.w2s(pos.x, pos.y, pos.z)
                                    if vis then
                                        local fov = math.sqrt((sx-cx)*(sx-cx) + (sy-cy)*(sy-cy))
                                        if fov < best_fov then
                                            best_fov = fov
                                            best = {player=player, pos=pos, dist=dist, fov=fov}
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
        local hc = settings.num("boba_silent_hit_chance", 100)
        if hc < 100 and math.random(1,100) > hc then silent_ray.stop(); return end
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
        if settings.bool("boba_silent_draw_fov", true) then
            draw_util.circle(cx, cy, settings.num("boba_silent_fov", 120), {0.83, 0.65, 0.46, 0.6}, false, 48)
        end
        if current_target and settings.bool("boba_silent_target_line", false) then
            local sx, sy, vis = esp_util.w2s(current_target.pos.x, current_target.pos.y, current_target.pos.z)
            if vis then draw_util.line(cx, cy, sx, sy, {1, 0.42, 0.42, 0.7}, 1.5) end
        end
    end
    return M
end)()

BobaV1._mods["features.player_esp"] = (function()
    local settings = BobaV1.require("core.settings")
    local env = BobaV1.require("core.env")
    local ep = BobaV1.require("core.entity_props")
    local esp = BobaV1.require("core.esp_util")
    local du = BobaV1.require("core.draw_util")
    local mu = BobaV1.require("core.math_util")
    local M = {}
    local BOBA={0.83,0.65,0.46,1} local WHITE={1,1,1,1} local RED={1,0.42,0.42,1}
    local GREEN={0.32,0.81,0.40,1} local YELLOW={1,0.83,0.23,1}

    function M.draw()
        if not settings.enabled("boba_player_esp") then return end
        local lp = env.get_local_player()
        if not lp then return end
        local my_pos = ep.get_position(lp)
        if not my_pos then return end
        local max_range = settings.num("boba_player_range", 600)
        for _, player in ipairs(env.get_players()) do
            if player ~= lp and ep.is_alive(player) then
                local pos = ep.get_position(player)
                if pos then
                    local dist = mu.distance3(pos.x-my_pos.x, pos.y-my_pos.y, pos.z-my_pos.z)
                    if dist <= max_range then
                        local hp = ep.get_bone_position(player,"Head") or {x=pos.x,y=pos.y+2.5,z=pos.z}
                        local _,sy_top,vt = esp.w2s(hp.x, hp.y+0.35, hp.z)
                        local _2,sy_bot,vb = esp.w2s(pos.x, pos.y-2.5, pos.z)
                        local sx_top = _
                        local sx_bot = _2
                        if vt or vb then
                            local h = math.abs(sy_bot - sy_top)
                            local w = h * 0.55
                            local cx = (sx_top + sx_bot) * 0.5
                            local top = math.min(sy_top, sy_bot)
                            local col = env.same_team(lp, player) and GREEN or BOBA
                            local bm = settings.num("boba_player_box_mode", 0)
                            if bm == 0 then
                                du.rect(cx-w*0.5, top, w, h, col, 0, 1)
                            elseif bm == 1 then
                                local c = math.max(4, h*0.2)
                                local x1,y1 = cx-w*0.5, top
                                local x2,y2 = cx+w*0.5, top+h
                                du.line(x1,y1,x1+c,y1,col,1) du.line(x1,y1,x1,y1+c,col,1)
                                du.line(x2,y1,x2-c,y1,col,1) du.line(x2,y1,x2,y1+c,col,1)
                                du.line(x1,y2,x1+c,y2,col,1) du.line(x1,y2,x1,y2-c,col,1)
                                du.line(x2,y2,x2-c,y2,col,1) du.line(x2,y2,x2,y2-c,col,1)
                            end
                            if settings.bool("boba_player_health", true) then
                                local hp2, mhp = ep.get_health(player)
                                if hp2 and mhp and mhp > 0 then
                                    local pct = mu.clamp(hp2/mhp, 0, 1)
                                    local bh = h * pct
                                    local bx = cx - w*0.5 - 4
                                    du.rect_filled(bx, top, 2, h, {0.15,0.15,0.15,0.7}, 0)
                                    du.rect_filled(bx, top+h-bh, 2, bh, pct>0.5 and GREEN or (pct>0.25 and YELLOW or RED), 0)
                                end
                            end
                            if settings.bool("boba_player_name", true) then
                                du.text_centered(cx, top-14, ep.get_display_name(player), WHITE, 12)
                            end
                            if settings.bool("boba_player_distance", true) then
                                du.text_centered(cx, top+h+3, string.format("%.0fm", dist), {0.55,0.54,0.60,1}, 11)
                            end
                            if settings.bool("boba_player_held", true) then
                                local held = ep.get_held_item(player)
                                if held then du.text_centered(cx, top+h+15, held, BOBA, 11) end
                            end
                            if settings.bool("boba_flag_downed", true) and ep.is_downed(player) then
                                du.text_centered(cx, top-26, "DOWNED", RED, 10)
                            end
                            if settings.bool("boba_player_skeleton", true) then
                                local bones = {}
                                local char = env.get_character(player)
                                if char then
                                    for _, bn in ipairs({"Head","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}) do
                                        local bp = ep.get_bone_position(player, bn)
                                        if bp then
                                            local bsx,bsy,bvis = esp.w2s(bp.x, bp.y, bp.z)
                                            if bvis then bones[bn] = {x=bsx, y=bsy} end
                                        end
                                    end
                                end
                                esp.draw_skeleton_bones(bones, {1,1,1,0.7}, 1.5)
                            end
                        end
                    end
                end
            end
        end
    end
    return M
end)()

BobaV1._mods["features.crosshair"] = (function()
    local settings = BobaV1.require("core.settings")
    local du = BobaV1.require("core.draw_util")
    local M = {}
    function M.draw()
        if not settings.enabled("boba_crosshair") then return end
        local sw, sh = du.screen_size()
        local cx, cy = sw*0.5, sh*0.5
        local size = settings.num("boba_crosshair_size", 6)
        local gap = settings.num("boba_crosshair_gap", 3)
        local col = {0.83, 0.65, 0.46, 1}
        du.line(cx-size-gap, cy, cx-gap, cy, col, 2)
        du.line(cx+gap, cy, cx+size+gap, cy, col, 2)
        du.line(cx, cy-size-gap, cx, cy-gap, col, 2)
        du.line(cx, cy+gap, cx, cy+size+gap, col, 2)
        du.circle(cx, cy, 1.5, col, true)
    end
    return M
end)()

-- ═══════════════════════════════════════════════════════
-- BOOT
-- ═══════════════════════════════════════════════════════
BobaV1._mods["boba.main"] = (function()
    local M = {}
    local notify = BobaV1.require("core.notify")
    local silent_aim = BobaV1.require("features.silent_aim")
    local player_esp = BobaV1.require("features.player_esp")
    local crosshair = BobaV1.require("features.crosshair")
    local register_menu = BobaV1.require("boba.register_menu")

    local function render_frame()
        local ok, err = pcall(function()
            notify.draw()
            silent_aim.draw()
            player_esp.draw()
            crosshair.draw()
            silent_aim.tick()
        end)
        if not ok then
            draw.text(10, 10, "[BobaV1 ERROR] " .. tostring(err), {1,0.3,0.3,1}, 12)
        end
    end

    function M.boot()
        register_menu.register()
        print("[BobaV1] Menu registered")
        notify.success("BobaV1 v" .. BobaV1.VERSION .. " loaded!", 4000)

        _G.OnFrame = render_frame
        _G.onFrame = render_frame
        _G.on_frame = render_frame
        if draw then draw.callback = render_frame end

        print("[BobaV1] Render hook active")
        print("[BobaV1] All features registered and active")
    end
    return M
end)()

print("[BobaV1] v" .. BobaV1.VERSION .. " | Fallen Survival")
BobaV1.require("boba.main").boot()
