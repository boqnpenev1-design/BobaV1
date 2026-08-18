--[[
    BobaV1 v1.0.0 вЂ” Fallen Survival
    Custom overlay menu for Project Vector
    Press INSERT to toggle menu
    
    Load: utility.LoadUrl("https://raw.githubusercontent.com/boqnpenev1-design/BobaV1/main/boba.lua")
]]

BobaV1 = BobaV1 or {}
BobaV1._mods = {}
BobaV1.VERSION = "1.0.0"

function BobaV1.require(name)
    return BobaV1._mods[name]
end

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CORE: Environment helpers
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.env"] = (function()
    local M = {}
    function M.safe_call(fn, ...)
        if type(fn) ~= "function" then return nil end
        local ok, r = pcall(fn, ...)
        return ok and r or nil
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
    function M.get_character(p)
        return p and (p.Character or p.character)
    end
    function M.get_team(p)
        if not p then return nil end
        return M.safe_call(function() return p.Team or p.team end)
    end
    function M.same_team(a, b)
        local ta, tb = M.get_team(a), M.get_team(b)
        return ta ~= nil and ta == tb
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CORE: API aliases
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.api"] = (function()
    local M = {}
    local function alias(tbl, snake, pascal)
        if tbl then tbl[snake] = tbl[snake] or tbl[pascal] end
    end
    if utility then
        alias(utility, "get_tick_count", "GetTickCount")
        alias(utility, "get_delta_time", "GetDeltaTime")
        alias(utility, "get_mouse_pos", "GetMousePos")
    end
    if input then
        alias(input, "is_key_down", "IsKeyDown")
        alias(input, "get_mouse_position", "GetMousePosition")
        alias(input, "get_mouse_pos", "GetMousePosition")
    end
    if raycast then
        alias(raycast, "set_silent_target", "SetSilentTarget")
        alias(raycast, "stop_silent_tracking", "StopSilentTracking")
        alias(raycast, "enable_silent_hook", "EnableSilentHook")
    end
    if camera then
        alias(camera, "get_position", "GetPosition")
    end
    if draw then
        alias(draw, "text", "Text")
        alias(draw, "line", "Line")
        alias(draw, "rect", "Rect")
        alias(draw, "rect_filled", "RectFilled")
        alias(draw, "circle", "Circle")
        alias(draw, "circle_filled", "CircleFilled")
        alias(draw, "world_to_screen", "WorldToScreen")
        alias(draw, "get_screen_size", "GetScreenSize")
        alias(draw, "get_text_size", "GetTextSize")
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CORE: Settings store
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.settings"] = (function()
    local M = {}
    local _v = {}
    function M.set(key, val)
        if key then _v[key] = val end
    end
    function M.get(key, def)
        local v = _v[key]
        if v ~= nil then return v end
        return def
    end
    function M.bool(key, def)
        local v = M.get(key, def)
        return v == true or v == 1
    end
    function M.enabled(key) return M.bool(key, false) end
    function M.num(key, def) return tonumber(M.get(key, def)) or (tonumber(def) or 0) end
    function M.toggle(key)
        M.set(key, not M.bool(key, false))
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CORE: Math helpers
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.math"] = (function()
    local M = {}
    function M.clamp(v, lo, hi)
        if v < lo then return lo end
        if v > hi then return hi end
        return v
    end
    function M.lerp(a, b, t) return a + (b - a) * t end
    function M.dist3(dx, dy, dz) return math.sqrt(dx*dx + dy*dy + dz*dz) end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CORE: Entity props
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.entity"] = (function()
    local env = BobaV1.require("core.env")
    local M = {}
    function M.get_health(p)
        if not p then return nil, nil end
        local h = p.Humanoid or p.humanoid
        if not h then
            local c = env.get_character(p)
            if c then h = env.safe_call(function() return c:FindFirstChildOfClass("Humanoid") end) end
        end
        if not h then return nil, nil end
        return tonumber(h.Health or h.health), tonumber(h.MaxHealth or h.max_health or 100)
    end
    function M.is_alive(p)
        local hp = M.get_health(p)
        return hp ~= nil and hp > 0
    end
    function M.is_downed(p)
        if not p then return false end
        return env.safe_call(function()
            local c = env.get_character(p)
            if not c then return false end
            local s = c:FindFirstChild("StateController")
            return s and s:GetAttribute("IsDowned") == true
        end) == true
    end
    function M.get_pos(p)
        if not p then return nil end
        local c = env.get_character(p)
        if not c then return nil end
        return env.safe_call(function()
            local r = c:FindFirstChild("HumanoidRootPart")
            if r then
                local pos = r.Position or r.position
                if pos then return {x=pos.X or pos.x, y=pos.Y or pos.y, z=pos.Z or pos.z} end
            end
        end)
    end
    function M.get_bone(p, name)
        if not p then return nil end
        local c = env.get_character(p)
        if not c then return nil end
        return env.safe_call(function()
            local part = c:FindFirstChild(name)
            if part then
                local pos = part.Position or part.position
                if pos then return {x=pos.X or pos.x, y=pos.Y or pos.y, z=pos.Z or pos.z} end
            end
        end)
    end
    function M.get_vel(p)
        if not p then return {x=0,y=0,z=0} end
        local c = env.get_character(p)
        if not c then return {x=0,y=0,z=0} end
        return env.safe_call(function()
            local r = c:FindFirstChild("HumanoidRootPart")
            if r then
                local v = r.Velocity or r.velocity or r.AssemblyLinearVelocity
                if v then return {x=v.X or v.x or 0, y=v.Y or v.y or 0, z=v.Z or v.z or 0} end
            end
            return {x=0,y=0,z=0}
        end) or {x=0,y=0,z=0}
    end
    function M.get_name(p) return p and (p.DisplayName or p.display_name or p.Name or p.name or "?") or "?" end
    function M.get_held(p)
        if not p then return nil end
        local c = env.get_character(p)
        if not c then return nil end
        return env.safe_call(function()
            local t = c:FindFirstChildOfClass("Tool")
            return t and (t.Name or t.name)
        end)
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CORE: World-to-screen + skeleton
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.esp"] = (function()
    local M = {}
    M.BONES = {"Head","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
    M.AIM_BONES = {"Closest","Head","UpperTorso","LowerTorso","HumanoidRootPart","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
    M.SKEL = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"UpperTorso","RightUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"RightUpperArm","RightLowerArm"},{"LeftLowerArm","LeftHand"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LowerTorso","RightUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"RightUpperLeg","RightLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"RightLowerLeg","RightFoot"}}
    function M.w2s(x, y, z)
        if draw and draw.world_to_screen then
            local ok, a, b, c = pcall(draw.world_to_screen, x, y, z)
            if ok and a and type(a) == "number" then return a, b, c ~= false and c ~= 0 end
        end
        return 0, 0, false
    end
    function M.draw_skel(bones, col, thick)
        if not bones then return end
        for _, p in ipairs(M.SKEL) do
            local a, b = bones[p[1]], bones[p[2]]
            if a and b then draw.line(a.x, a.y, b.x, b.y, col, thick or 1.5) end
        end
    end
    function M.screen_size()
        if draw and draw.get_screen_size then
            local ok, w, h = pcall(draw.get_screen_size)
            if ok then return w, h end
        end
        return 1920, 1080
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CORE: Silent aim raycast
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.silent"] = (function()
    local M = {}
    local tracking = false
    local hooked = false
    local function rfn(s, p)
        if not raycast then return nil end
        local f = raycast[s] or raycast[p]
        return type(f) == "function" and f or nil
    end
    local function vec3(x,y,z)
        if Vector3 then
            local c = Vector3.New or Vector3.new
            if type(c) == "function" then local ok,v = pcall(c,x,y,z); if ok then return v end end
        end
        return {x=x,y=y,z=z}
    end
    function M.available()
        return rfn("set_silent_target","SetSilentTarget") ~= nil
    end
    function M.ensure()
        if hooked then return true end
        if not M.available() then return false end
        local e = rfn("enable_silent_hook","EnableSilentHook")
        if not e then hooked = true; return true end
        hooked = pcall(e)
        return hooked
    end
    function M.cam_origin()
        if not camera then return nil end
        local f = camera.get_position or camera.GetPosition
        if type(f) ~= "function" then return nil end
        local ok, p = pcall(f)
        if not ok or not p then return nil end
        return {x=p.x or p.X, y=p.y or p.Y, z=p.z or p.Z}
    end
    function M.stop()
        tracking = false
        local s = rfn("stop_silent_tracking","StopSilentTracking")
        if s then pcall(s) end
    end
    function M.aim(origin, target)
        if not target then return false end
        origin = origin or M.cam_origin()
        if not origin or not M.ensure() then return false end
        local f = rfn("set_silent_target","SetSilentTarget")
        if not f then return false end
        local ok = pcall(f, vec3(origin.x, origin.y, origin.z),
            vec3(target.x-origin.x, target.y-origin.y, target.z-origin.z))
        tracking = ok
        return ok
    end
    function M.is_tracking() return tracking end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CORE: Ballistic prediction
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["core.ballistic"] = (function()
    local mu = BobaV1.require("core.math")
    local M = {}
    function M.predict(speed, grav, vel, pos, origin)
        speed = math.max(speed or 950, 1)
        local d = mu.dist3(pos.x-origin.x, pos.y-origin.y, pos.z-origin.z)
        local t = d / speed
        local drop = 0.5 * (grav or 0.55) * 195 * t * t
        return {x=pos.x+(vel.x or 0)*t, y=pos.y+(vel.y or 0)*t+drop, z=pos.z+(vel.z or 0)*t}
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- UI: Input system
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["ui.input"] = (function()
    local M = {}
    local prev_keys = {}
    local prev_lmb = false
    local _lmb_pressed = false
    local _mx, _my = 0, 0

    function M.mouse() return _mx, _my end

    function M.is_down(key)
        if input then
            local fn = input.is_key_down or input.IsKeyDown
            if fn then return fn(key) == true end
        end
        return false
    end

    function M.lmb() return M.is_down(0x01) end
    function M.lmb_pressed() return _lmb_pressed end

    function M.key_pressed(key)
        local down = M.is_down(key)
        local was = prev_keys[key]
        prev_keys[key] = down
        return down and not was
    end

    function M.in_rect(x, y, w, h)
        return _mx >= x and _mx <= x + w and _my >= y and _my <= y + h
    end

    function M.update()
        if utility and (utility.get_mouse_pos or utility.GetMousePos) then
            local fn = utility.get_mouse_pos or utility.GetMousePos
            local ok, a, b = pcall(fn)
            if ok then _mx, _my = tonumber(a) or 0, tonumber(b) or 0 end
        elseif input and (input.get_mouse_position or input.get_mouse_pos or input.GetMousePosition) then
            local fn = input.get_mouse_position or input.get_mouse_pos or input.GetMousePosition
            local ok, a, b = pcall(fn)
            if ok then _mx, _my = tonumber(a) or 0, tonumber(b) or 0 end
        end
        local down = M.lmb()
        _lmb_pressed = down and not prev_lmb
        prev_lmb = down
    end

    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- UI: Custom overlay menu
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["ui.menu"] = (function()
    local inp = BobaV1.require("ui.input")
    local settings = BobaV1.require("core.settings")
    local mu = BobaV1.require("core.math")
    local esp = BobaV1.require("core.esp")
    local M = {}

    local C = {
        bg       = {0.07, 0.07, 0.10, 0.96},
        title_bg = {0.09, 0.09, 0.13, 1},
        tab_bg   = {0.08, 0.08, 0.11, 1},
        tab_act  = {0.83, 0.65, 0.46, 1},
        tab_txt  = {0.50, 0.50, 0.55, 1},
        accent   = {0.83, 0.65, 0.46, 1},
        accent2  = {0.93, 0.75, 0.56, 1},
        text     = {0.90, 0.90, 0.94, 1},
        dim      = {0.55, 0.55, 0.60, 1},
        grp_bg   = {0.10, 0.10, 0.14, 0.8},
        grp_line = {0.83, 0.65, 0.46, 0.5},
        tog_on   = {0.83, 0.65, 0.46, 1},
        tog_off  = {0.25, 0.25, 0.30, 1},
        sld_bg   = {0.18, 0.18, 0.22, 1},
        sld_fill = {0.83, 0.65, 0.46, 1},
        border   = {0.83, 0.65, 0.46, 0.12},
        combo_bg = {0.12, 0.12, 0.16, 1},
        sep      = {0.20, 0.20, 0.25, 0.4},
    }

    local visible = false
    local win_x, win_y = 180, 120
    local WIN_W, WIN_H = 540, 460
    local TITLE_H = 34
    local TAB_H = 30
    local dragging = false
    local drag_ox, drag_oy = 0, 0
    local active_tab = 1
    local slider_active = nil
    local combo_open = nil
    local prev_insert = false
    local consumed = false

    local TABS = {"Aim", "Visuals", "World", "Guns", "Misc", "Radar"}

    local cur_x, cur_y, col_w = 0, 0, 0

    local function text_w(str, sz)
        sz = sz or 12
        if draw.get_text_size then
            local ok, w = pcall(draw.get_text_size, str, sz)
            if ok and w then return w end
        end
        return #str * (sz * 0.52)
    end

    local function begin_col(x, y, w) cur_x, cur_y, col_w = x, y, w end
    local function advance(h) cur_y = cur_y + h end

    function M.w_group(label)
        draw.rect_filled(cur_x, cur_y, col_w, 22, C.grp_bg, 0)
        draw.rect_filled(cur_x, cur_y, 3, 22, C.grp_line, 0)
        draw.text(cur_x + 10, cur_y + 4, label, C.accent, 12)
        advance(26)
    end

    function M.w_label(text)
        draw.text(cur_x + 8, cur_y + 2, text, C.dim, 11)
        advance(18)
    end

    function M.w_sep()
        draw.rect_filled(cur_x + 8, cur_y + 4, col_w - 16, 1, C.sep, 0)
        advance(10)
    end

    function M.w_toggle(id, label)
        local x, y, w = cur_x, cur_y, col_w
        local val = settings.bool(id, false)
        local tw, th = 28, 14
        local tx = x + w - tw - 10
        local ty = y + 3
        draw.text(x + 12, y + 2, label, C.text, 12)
        draw.rect_filled(tx, ty, tw, th, val and C.tog_on or C.tog_off, 0)
        local cx = val and (tx + tw - th/2 - 2) or (tx + th/2 + 2)
        draw.circle_filled(cx, ty + th/2, th/2 - 2, {1,1,1,0.95}, 12)
        if inp.lmb_pressed() and inp.in_rect(x, y, w, 20) and not combo_open then
            settings.toggle(id)
            consumed = true
        end
        advance(22)
    end

    function M.w_hotkey(id, label)
        M.w_toggle(id, label)
    end

    function M.w_slider(id, label, lo, hi, default, is_float)
        local x, y, w = cur_x, cur_y, col_w
        local val = mu.clamp(settings.num(id, default), lo, hi)
        local trk_x = x + 12
        local trk_w = w - 70
        local trk_y = y + 18
        local trk_h = 6
        local disp = is_float and string.format("%.1f", val) or string.format("%d", val)
        draw.text(x + 12, y + 1, label, C.text, 11)
        draw.text(x + w - 10 - text_w(disp, 11), y + 1, disp, C.accent, 11)
        draw.rect_filled(trk_x, trk_y, trk_w, trk_h, C.sld_bg, 0)
        local pct = (val - lo) / math.max(hi - lo, 0.001)
        draw.rect_filled(trk_x, trk_y, trk_w * pct, trk_h, C.sld_fill, 0)
        draw.circle_filled(trk_x + trk_w * pct, trk_y + trk_h/2, 5, C.accent2, 12)
        local mx, my = inp.mouse()
        if inp.lmb_pressed() and mx >= trk_x - 5 and mx <= trk_x + trk_w + 5 and my >= trk_y - 8 and my <= trk_y + trk_h + 8 then
            slider_active = id
            consumed = true
        end
        if slider_active == id then
            if inp.lmb() then
                local np = mu.clamp((mx - trk_x) / math.max(trk_w, 1), 0, 1)
                local nv = lo + (hi - lo) * np
                if not is_float then nv = math.floor(nv + 0.5) end
                settings.set(id, nv)
                consumed = true
            else
                slider_active = nil
            end
        end
        advance(28)
    end

    function M.w_combo(id, label, options, default)
        local x, y, w = cur_x, cur_y, col_w
        local idx = settings.num(id, default or 0)
        local current = options[idx + 1] or options[1] or "?"
        draw.text(x + 12, y + 1, label, C.text, 11)
        advance(16)
        local bx, by = x + 12, cur_y
        local bw, bh = w - 24, 20
        draw.rect_filled(bx, by, bw, bh, C.combo_bg, 0)
        draw.rect(bx, by, bw, bh, C.border, 0, 1)
        draw.text(bx + 8, by + 4, current, C.text, 11)
        draw.text(bx + bw - 18, by + 4, "v", C.dim, 11)
        if inp.lmb_pressed() and inp.in_rect(bx, by, bw, bh) then
            combo_open = combo_open == id and nil or id
            consumed = true
        end
        advance(24)
        if combo_open == id then
            local dd_y = by + bh
            for i, opt in ipairs(options) do
                local oy = dd_y + (i-1) * 20
                local hov = inp.in_rect(bx, oy, bw, 20)
                draw.rect_filled(bx, oy, bw, 20, hov and {0.15,0.15,0.20,1} or C.combo_bg, 0)
                draw.text(bx + 8, oy + 4, opt, (i-1 == idx) and C.accent or C.text, 11)
                if hov and inp.lmb_pressed() then
                    settings.set(id, i - 1)
                    combo_open = nil
                    consumed = true
                end
            end
            draw.rect(bx, dd_y, bw, #options * 20, C.border, 0, 1)
        end
    end

    -- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ TAB CONTENTS в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

    local function tab_aim(x, y, w, h)
        local half = math.floor(w / 2) - 6
        begin_col(x + 4, y, half)
        M.w_group("Silent Aim")
        M.w_hotkey("boba_silent_aim", "Enable Silent Aim")
        M.w_combo("boba_silent_target_type", "Target Type", {"Closest","Lowest HP","Crosshair"}, 0)
        M.w_combo("boba_silent_bone", "Hitbox", esp.AIM_BONES, 1)
        M.w_slider("boba_silent_fov", "FOV", 10, 360, 120)
        M.w_slider("boba_silent_max_dist", "Max Distance", 50, 2000, 800)
        M.w_slider("boba_silent_hit_chance", "Hit Chance %", 0, 100, 100)
        M.w_toggle("boba_silent_sticky", "Sticky Target")
        M.w_sep()
        M.w_group("Filters")
        M.w_toggle("boba_silent_ignore_team", "Ignore Team")
        M.w_toggle("boba_silent_ignore_downed", "Ignore Downed")
        M.w_toggle("boba_silent_visible_only", "Visible Only")

        begin_col(x + half + 8, y, half)
        M.w_group("FOV Display")
        M.w_toggle("boba_silent_draw_fov", "Draw FOV Circle")
        M.w_combo("boba_silent_fov_style", "Style", {"Circle","Filled","Cross"}, 0)
        M.w_toggle("boba_silent_target_line", "Target Line")
        M.w_sep()
        M.w_group("Bullet")
        M.w_hotkey("boba_bullet_enabled", "Bullet Manip")
        M.w_toggle("boba_bullet_body_peek", "Body Peek")
        M.w_toggle("boba_thick_bullet", "Thick Bullet")
        M.w_slider("boba_thick_bullet_mult", "Thickness", 1, 5, 2)
        M.w_sep()
        M.w_group("Prediction")
        M.w_toggle("boba_aim_prediction", "Auto Prediction")
    end

    local function tab_visuals(x, y, w, h)
        local half = math.floor(w / 2) - 6
        begin_col(x + 4, y, half)
        M.w_group("Player ESP")
        M.w_hotkey("boba_player_esp", "Enable ESP")
        M.w_combo("boba_player_box_mode", "Box Mode", {"2D","Corner","3D","None"}, 0)
        M.w_toggle("boba_player_health", "Health Bar")
        M.w_toggle("boba_player_skeleton", "Skeleton")
        M.w_toggle("boba_player_name", "Show Name")
        M.w_toggle("boba_player_held", "Held Item")
        M.w_toggle("boba_player_distance", "Distance")
        M.w_slider("boba_player_range", "Range", 50, 2000, 600)
        M.w_sep()
        M.w_group("Flags")
        M.w_toggle("boba_flag_downed", "Downed Flag")

        begin_col(x + half + 8, y, half)
        M.w_group("Crosshair")
        M.w_toggle("boba_crosshair", "Custom Crosshair")
        M.w_combo("boba_crosshair_type", "Type", {"Cross","Dot","Circle","T-Shape"}, 0)
        M.w_slider("boba_crosshair_size", "Size", 1, 20, 6)
        M.w_slider("boba_crosshair_gap", "Gap", 0, 15, 3)
        M.w_sep()
        M.w_group("Aimbot")
        M.w_hotkey("boba_aimbot", "Enable Aimbot")
        M.w_combo("boba_aim_bone", "Bone", esp.AIM_BONES, 1)
        M.w_slider("boba_aim_fov", "FOV", 10, 360, 120)
        M.w_slider("boba_aim_smooth", "Smooth", 1, 20, 5)
    end

    local function tab_world(x, y, w, h)
        local half = math.floor(w / 2) - 6
        begin_col(x + 4, y, half)
        M.w_group("World ESP")
        M.w_hotkey("boba_world_esp", "World ESP")
        M.w_toggle("boba_world_stone", "Stone Nodes")
        M.w_toggle("boba_world_metal", "Metal Nodes")
        M.w_toggle("boba_world_phosphate", "Phosphate")
        M.w_slider("boba_world_range", "Range", 50, 1000, 300)
        M.w_sep()
        M.w_group("Loot ESP")
        M.w_hotkey("boba_loot_esp", "Loot ESP")
        M.w_toggle("boba_loot_crates", "Crates")
        M.w_toggle("boba_loot_care_package", "Care Packages")
        M.w_toggle("boba_loot_body_bag", "Body Bags")
        M.w_slider("boba_loot_range", "Range", 50, 1000, 400)

        begin_col(x + half + 8, y, half)
        M.w_group("NPC ESP")
        M.w_hotkey("boba_npc_esp", "NPC ESP")
        M.w_toggle("boba_npc_soldier", "Soldiers")
        M.w_toggle("boba_npc_bosses", "Bosses")
        M.w_toggle("boba_npc_heli", "Attack Heli")
        M.w_slider("boba_npc_range", "Range", 50, 1000, 500)
        M.w_sep()
        M.w_group("Base ESP")
        M.w_hotkey("boba_base_esp", "Base ESP")
        M.w_toggle("boba_base_tc", "Tool Cupboard")
        M.w_toggle("boba_base_turrets", "Turrets")
        M.w_toggle("boba_base_doors", "Doors")
        M.w_slider("boba_base_range", "Range", 50, 500, 250)
    end

    local function tab_guns(x, y, w, h)
        local half = math.floor(w / 2) - 6
        begin_col(x + 4, y, half)
        M.w_group("Gun Mods")
        M.w_hotkey("boba_gunmods", "Enable Gun Mods")
        M.w_toggle("boba_gm_recoil", "No Recoil")
        M.w_slider("boba_gm_recoil_pct", "Reduction %", 0, 100, 100)
        M.w_toggle("boba_gm_spread", "No Spread")
        M.w_slider("boba_gm_spread_pct", "Reduction %", 0, 100, 100)
        M.w_toggle("boba_gm_sway", "No Sway")
        M.w_sep()
        M.w_toggle("boba_gm_fire_rate", "Fire Rate Mod")
        M.w_slider("boba_gm_fire_rate_mult", "Multiplier", 1, 5, 2)
        M.w_toggle("boba_gm_speed", "Bullet Speed Mod")
        M.w_slider("boba_gm_speed_mult", "Multiplier", 1, 5, 2)
        M.w_toggle("boba_gm_range", "Range Mod")
        M.w_slider("boba_gm_range_mult", "Multiplier", 1, 5, 2)
        M.w_toggle("boba_gm_double_tap", "Double Tap")

        begin_col(x + half + 8, y, half)
        M.w_group("Tracers")
        M.w_hotkey("boba_tracers", "Enable Tracers")
        M.w_combo("boba_tracers_style", "Style", {"Line","Arc","Curve","Beam"}, 0)
        M.w_slider("boba_tracers_lifetime", "Lifetime", 0.1, 5.0, 1.0, true)
        M.w_slider("boba_tracers_thickness", "Thickness", 1, 6, 2)
        M.w_toggle("boba_tracers_rainbow", "Rainbow")
    end

    local function tab_misc(x, y, w, h)
        local half = math.floor(w / 2) - 6
        begin_col(x + 4, y, half)
        M.w_group("Movement")
        M.w_hotkey("boba_fly", "Fly")
        M.w_slider("boba_fly_speed", "Speed", 1, 20, 5)
        M.w_toggle("boba_fly_noclip", "Noclip")
        M.w_hotkey("boba_bhop", "Bunny Hop")
        M.w_hotkey("boba_spider", "Spider Climb")
        M.w_slider("boba_spider_speed", "Speed", 18, 30, 18)
        M.w_sep()
        M.w_group("Combat")
        M.w_hotkey("boba_antifling", "Anti-Fling")
        M.w_hotkey("boba_fling", "Fling")
        M.w_slider("boba_fling_fov", "FOV", 10, 180, 90)

        begin_col(x + half + 8, y, half)
        M.w_group("Anti-Aim")
        M.w_hotkey("boba_antiaim", "Anti-Aim")
        M.w_combo("boba_aa_yaw", "Yaw Mode", {"Backward","Spin","Jitter","Random"}, 0)
        M.w_slider("boba_aa_spin_speed", "Spin Speed", 1, 20, 5)
        M.w_sep()
        M.w_group("Desync")
        M.w_hotkey("boba_desync", "Desync")
        M.w_hotkey("boba_fakeduck", "Fake Duck")
        M.w_slider("boba_fakeduck_height", "Height", 0.5, 2.5, 1.4, true)
        M.w_sep()
        M.w_group("Other")
        M.w_toggle("boba_anti_afk", "Anti-AFK")
        M.w_hotkey("boba_autofarm", "Autofarm")
        M.w_slider("boba_autofarm_range", "Range", 20, 200, 80)
    end

    local function tab_radar(x, y, w, h)
        local half = math.floor(w / 2) - 6
        begin_col(x + 4, y, half)
        M.w_group("Minimap")
        M.w_hotkey("boba_map", "Enable Minimap")
        M.w_slider("boba_map_zoom", "Zoom", 1, 5, 2)
        M.w_slider("boba_map_size", "Size", 100, 400, 200)
        M.w_slider("boba_map_opacity", "Opacity %", 10, 100, 85)
        M.w_toggle("boba_map_players", "Show Players")
        M.w_toggle("boba_map_npcs", "Show NPCs")
        M.w_toggle("boba_map_loot", "Show Loot")

        begin_col(x + half + 8, y, half)
        M.w_group("Raid Alerts")
        M.w_hotkey("boba_raid_alerts", "Enable Alerts")
        M.w_slider("boba_raid_range", "Alert Range", 100, 2000, 800)
    end

    local TAB_FNS = {tab_aim, tab_visuals, tab_world, tab_guns, tab_misc, tab_radar}

    function M.is_visible() return visible end

    function M.draw()
        inp.update()
        consumed = false

        local ins = inp.is_down(0x2D)
        if ins and not prev_insert then
            visible = not visible
            combo_open = nil
            slider_active = nil
        end
        prev_insert = ins

        if not visible then return false end

        local mx, my = inp.mouse()
        local x, y = win_x, win_y

        if inp.lmb_pressed() and mx >= x and mx <= x + WIN_W and my >= y and my <= y + TITLE_H then
            dragging = true
            drag_ox = mx - x
            drag_oy = my - y
        end
        if dragging then
            if inp.lmb() then
                win_x = mx - drag_ox
                win_y = my - drag_oy
                x, y = win_x, win_y
            else
                dragging = false
            end
        end

        draw.rect_filled(x, y, WIN_W, WIN_H, C.bg, 0)
        draw.rect_filled(x, y, WIN_W, TITLE_H, C.title_bg, 0)
        draw.rect_filled(x, y + TITLE_H - 2, WIN_W, 2, C.accent, 0)
        draw.text(x + 14, y + 9, "BobaV1", C.accent, 14)
        draw.text(x + 14 + text_w("BobaV1", 14) + 8, y + 11, "v" .. BobaV1.VERSION, C.dim, 11)

        local tab_y = y + TITLE_H
        draw.rect_filled(x, tab_y, WIN_W, TAB_H, C.tab_bg, 0)
        local tw = math.floor(WIN_W / #TABS)
        for i, name in ipairs(TABS) do
            local tx = x + (i-1) * tw
            local act = i == active_tab
            local hov = mx >= tx and mx <= tx + tw and my >= tab_y and my <= tab_y + TAB_H
            if act then draw.rect_filled(tx, tab_y + TAB_H - 3, tw, 3, C.accent, 0) end
            local tc = act and C.accent or (hov and C.accent2 or C.tab_txt)
            local ntw = text_w(name, 12)
            draw.text(tx + (tw - ntw) / 2, tab_y + 8, name, tc, 12)
            if hov and inp.lmb_pressed() then
                active_tab = i
                combo_open = nil
                consumed = true
            end
        end

        local cy = tab_y + TAB_H + 6
        local ch = WIN_H - TITLE_H - TAB_H - 6
        local fn = TAB_FNS[active_tab]
        if fn then fn(x, cy, WIN_W, ch) end

        draw.rect(x, y, WIN_W, WIN_H, C.border, 0, 1)

        if combo_open and inp.lmb_pressed() and not consumed then
            combo_open = nil
        end

        return true
    end

    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- UI: Notification toasts
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["ui.notify"] = (function()
    local esp = BobaV1.require("core.esp")
    local M = {}
    local queue = {}
    local function tick()
        return utility and utility.get_tick_count and utility.get_tick_count() or 0
    end
    local function lerp(a,b,t) return a+(b-a)*t end
    local COLORS = {
        success={0.32,0.81,0.40,1}, warning={1,0.83,0.23,1},
        danger={1,0.42,0.42,1}, info={0.83,0.65,0.46,1},
    }
    function M.toast(msg, ntype, dur)
        if not msg or msg == "" then return end
        ntype = ntype or "info"; dur = dur or 4000
        for _, n in ipairs(queue) do
            if n.msg == msg and (tick()-n.time) < 2000 then return end
        end
        queue[#queue+1] = {msg=msg, type=ntype, time=tick(), duration=dur, alpha=0, x_off=60, y=0}
        while #queue > 5 do table.remove(queue, 1) end
    end
    function M.success(m,d) M.toast(m,"success",d) end
    function M.info(m,d) M.toast(m,"info",d) end
    function M.draw()
        if #queue == 0 then return end
        local now = tick()
        local ty = 16
        for i = #queue, 1, -1 do
            local n = queue[i]
            local el = now - n.time
            if el > n.duration then table.remove(queue, i)
            else
                local fade = 300
                local ta = 1
                if el < fade then ta = el/fade elseif el > n.duration-fade then ta = (n.duration-el)/fade end
                n.alpha = lerp(n.alpha or 0, ta, 0.2)
                n.x_off = lerp(n.x_off or 60, 0, 0.18)
                if n.y == 0 then n.y = ty end
                n.y = lerp(n.y, ty, 0.2)
                local ac = COLORS[n.type] or COLORS.info
                local tw = #n.msg * 7
                local bw = tw + 24
                local bh = 28
                local sw = select(1, esp.screen_size())
                local bx = sw - bw - 14 + (n.x_off or 0)
                local by = n.y
                local a = n.alpha
                draw.rect_filled(bx, by, bw, bh, {0.06,0.06,0.09,0.94*a}, 0)
                draw.rect_filled(bx+2, by, bw-3, 2, {ac[1],ac[2],ac[3],a}, 0)
                draw.text(bx+12, by+7, n.msg, {0.91,0.90,0.94,a}, 12)
                ty = ty + bh + 6
            end
        end
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- FEATURE: Silent Aim
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["feat.silent"] = (function()
    local s = BobaV1.require("core.settings")
    local env = BobaV1.require("core.env")
    local ep = BobaV1.require("core.entity")
    local esp = BobaV1.require("core.esp")
    local sr = BobaV1.require("core.silent")
    local bal = BobaV1.require("core.ballistic")
    local mu = BobaV1.require("core.math")
    local M = {}
    local target = nil

    local function find()
        if not s.enabled("boba_silent_aim") or not sr.available() then return nil end
        local lp = env.get_local_player()
        if not lp then return nil end
        local sw, sh = esp.screen_size()
        local cx, cy = sw*0.5, sh*0.5
        local mf = s.num("boba_silent_fov", 120)
        local md = s.num("boba_silent_max_dist", 800)
        local bi = s.num("boba_silent_bone", 1) + 1
        local bone = esp.AIM_BONES[bi] or "Head"
        local best, bf = nil, mf
        for _, p in ipairs(env.get_players()) do
            if p ~= lp and ep.is_alive(p) then
                if not (s.bool("boba_silent_ignore_team",true) and env.same_team(lp,p)) then
                    if not (s.bool("boba_silent_ignore_downed",true) and ep.is_downed(p)) then
                        local pos = ep.get_bone(p, bone) or ep.get_pos(p)
                        if pos then
                            local my = ep.get_pos(lp)
                            if my then
                                local d = mu.dist3(pos.x-my.x, pos.y-my.y, pos.z-my.z)
                                if d <= md then
                                    local sx,sy,vis = esp.w2s(pos.x, pos.y, pos.z)
                                    if vis then
                                        local f = math.sqrt((sx-cx)^2+(sy-cy)^2)
                                        if f < bf then bf=f; best={player=p,pos=pos,dist=d} end
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
        if not s.enabled("boba_silent_aim") then
            if sr.is_tracking() then sr.stop() end
            target = nil; return
        end
        local t = find()
        if not t then
            if sr.is_tracking() then sr.stop() end
            target = nil; return
        end
        local hc = s.num("boba_silent_hit_chance",100)
        if hc < 100 and math.random(1,100) > hc then sr.stop(); return end
        local aim = t.pos
        if s.bool("boba_aim_prediction",true) then
            local v = ep.get_vel(t.player)
            aim = bal.predict(950, 0.55, v, t.pos, ep.get_pos(env.get_local_player()) or {x=0,y=0,z=0})
        end
        sr.aim(nil, aim)
        target = t
    end

    function M.draw()
        if not s.enabled("boba_silent_aim") then return end
        local sw, sh = esp.screen_size()
        local cx, cy = sw*0.5, sh*0.5
        if s.bool("boba_silent_draw_fov",true) then
            draw.circle(cx, cy, s.num("boba_silent_fov",120), {0.83,0.65,0.46,0.5}, 48, 1)
        end
        if target and s.bool("boba_silent_target_line",false) then
            local sx,sy,v = esp.w2s(target.pos.x, target.pos.y, target.pos.z)
            if v then draw.line(cx,cy,sx,sy,{1,0.42,0.42,0.6},1.5) end
        end
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- FEATURE: Player ESP
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
BobaV1._mods["feat.esp"] = (function()
    local s = BobaV1.require("core.settings")
    local env = BobaV1.require("core.env")
    local ep = BobaV1.require("core.entity")
    local esp = BobaV1.require("core.esp")
    local mu = BobaV1.require("core.math")
    local M = {}
    local A={0.83,0.65,0.46,1} local W={1,1,1,1} local R={1,0.42,0.42,1}
    local G={0.32,0.81,0.40,1} local Y={1,0.83,0.23,1}

    function M.draw()
        if not s.enabled("boba_player_esp") then return end
        local lp = env.get_local_player()
        if not lp then return end
        local my = ep.get_pos(lp)
        if not my then return end
        local mr = s.num("boba_player_range",600)
        for _, p in ipairs(env.get_players()) do
            if p ~= lp and ep.is_alive(p) then
                local pos = ep.get_pos(p)
                if pos then
                    local d = mu.dist3(pos.x-my.x, pos.y-my.y, pos.z-my.z)
                    if d <= mr then
                        local hp = ep.get_bone(p,"Head") or {x=pos.x,y=pos.y+2.5,z=pos.z}
                        local sx1,sy1,v1 = esp.w2s(hp.x, hp.y+0.35, hp.z)
                        local sx2,sy2,v2 = esp.w2s(pos.x, pos.y-2.5, pos.z)
                        if v1 or v2 then
                            local h = math.abs(sy2-sy1)
                            local w = h * 0.55
                            local cx = (sx1+sx2)*0.5
                            local top = math.min(sy1,sy2)
                            local col = env.same_team(lp,p) and G or A
                            local bm = s.num("boba_player_box_mode",0)
                            if bm == 0 then
                                draw.rect(cx-w*0.5, top, w, h, col, 0, 1)
                            elseif bm == 1 then
                                local c = math.max(4, h*0.2)
                                local x1,y1 = cx-w*0.5, top
                                local x2,y2 = cx+w*0.5, top+h
                                draw.line(x1,y1,x1+c,y1,col,1) draw.line(x1,y1,x1,y1+c,col,1)
                                draw.line(x2,y1,x2-c,y1,col,1) draw.line(x2,y1,x2,y1+c,col,1)
                                draw.line(x1,y2,x1+c,y2,col,1) draw.line(x1,y2,x1,y2-c,col,1)
                                draw.line(x2,y2,x2-c,y2,col,1) draw.line(x2,y2,x2,y2-c,col,1)
                            end
                            if s.bool("boba_player_health",true) then
                                local hp2,mhp = ep.get_health(p)
                                if hp2 and mhp and mhp > 0 then
                                    local pct = mu.clamp(hp2/mhp,0,1)
                                    local bx = cx-w*0.5-4
                                    draw.rect_filled(bx, top, 2, h, {0.15,0.15,0.15,0.7}, 0)
                                    draw.rect_filled(bx, top+h-h*pct, 2, h*pct, pct>0.5 and G or (pct>0.25 and Y or R), 0)
                                end
                            end
                            if s.bool("boba_player_name",true) then
                                local nm = ep.get_name(p)
                                local ntw = #nm * 6.5
                                draw.text(cx-ntw*0.5, top-14, nm, W, 12)
                            end
                            if s.bool("boba_player_distance",true) then
                                local dt = string.format("%.0fm", d)
                                local dtw = #dt * 6
                                draw.text(cx-dtw*0.5, top+h+3, dt, {0.55,0.54,0.60,1}, 11)
                            end
                            if s.bool("boba_player_held",true) then
                                local held = ep.get_held(p)
                                if held then
                                    local htw = #held * 6
                                    draw.text(cx-htw*0.5, top+h+15, held, A, 11)
                                end
                            end
                            if s.bool("boba_flag_downed",true) and ep.is_downed(p) then
                                draw.text(cx-22, top-26, "DOWNED", R, 10)
                            end
                            if s.bool("boba_player_skeleton",true) then
                                local bones = {}
                                local char = env.get_character(p)
                                if char then
                                    for _, bn in ipairs(esp.BONES) do
                                        local bp = ep.get_bone(p, bn)
                                        if bp then
                                            local bx,by,bv = esp.w2s(bp.x, bp.y, bp.z)
                                            if bv then bones[bn] = {x=bx,y=by} end
                                        end
                                    end
                                end
                                esp.draw_skel(bones, {1,1,1,0.7}, 1.5)
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
BobaV1._mods["feat.crosshair"] = (function()
    local s = BobaV1.require("core.settings")
    local esp = BobaV1.require("core.esp")
    local M = {}
    function M.draw()
        if not s.enabled("boba_crosshair") then return end
        local sw,sh = esp.screen_size()
        local cx,cy = sw*0.5, sh*0.5
        local sz = s.num("boba_crosshair_size",6)
        local g = s.num("boba_crosshair_gap",3)
        local c = {0.83,0.65,0.46,1}
        draw.line(cx-sz-g,cy,cx-g,cy,c,2)
        draw.line(cx+g,cy,cx+sz+g,cy,c,2)
        draw.line(cx,cy-sz-g,cx,cy-g,c,2)
        draw.line(cx,cy+g,cx,cy+sz+g,c,2)
        draw.circle_filled(cx,cy,1.5,c,8)
    end
    return M
end)()

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- BOOT
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
do
    local ui_menu = BobaV1.require("ui.menu")
    local notify = BobaV1.require("ui.notify")
    local feat_silent = BobaV1.require("feat.silent")
    local feat_esp = BobaV1.require("feat.esp")
    local feat_xhair = BobaV1.require("feat.crosshair")

    local function render()
        local ok, err = pcall(function()
            feat_silent.draw()
            feat_esp.draw()
            feat_xhair.draw()
            feat_silent.tick()
            notify.draw()
            ui_menu.draw()
        end)
        if not ok then
            draw.text(10, 10, "[BobaV1] " .. tostring(err), {1,0.3,0.3,1}, 13)
        end
    end

    local s = BobaV1.require("core.settings")
    s.set("boba_silent_ignore_team", true)
    s.set("boba_silent_ignore_downed", true)
    s.set("boba_silent_draw_fov", true)
    s.set("boba_aim_prediction", true)
    s.set("boba_player_health", true)
    s.set("boba_player_skeleton", true)
    s.set("boba_player_name", true)
    s.set("boba_player_held", true)
    s.set("boba_player_distance", true)
    s.set("boba_flag_downed", true)
    s.set("boba_fly_noclip", true)
    s.set("boba_map_players", true)
    s.set("boba_map_npcs", true)
    s.set("boba_map_loot", true)
    s.set("boba_world_stone", true)
    s.set("boba_world_metal", true)
    s.set("boba_loot_crates", true)
    s.set("boba_loot_care_package", true)
    s.set("boba_npc_soldier", true)
    s.set("boba_npc_bosses", true)
    s.set("boba_base_tc", true)

    _G.OnFrame = render
    _G.onFrame = render
    _G.on_frame = render
    if draw then draw.callback = render end

    notify.success("BobaV1 v" .. BobaV1.VERSION .. " loaded!")
    print("[BobaV1] v" .. BobaV1.VERSION .. " | Fallen Survival")
    print("[BobaV1] Press INSERT to toggle menu")
    print("[BobaV1] Render hook active")
end
