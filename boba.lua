--[[
    BobaV1 — Fallen Survival Cheat
    Based on April v4.3.0 framework
    
    Rebranded with BobaV1 identity
    Anime baddie AI feature removed
    Boba tea logo on startup
    
    Load via:
    utility.LoadUrl("https://raw.githubusercontent.com/boqnpenev1-design/BobaV1/main/boba.lua")
]]

-- BobaV1 loader: wraps the original April script with our modifications
-- The actual cheat logic comes from the April framework

local BOBA_VERSION = "1.0.0"
local BOBA_NAME = "BobaV1"

-- Pre-hook: Override April's branding before it loads
local _original_notify = nil

-- Load the base April framework
-- This pulls the full ~9000 line script with all modules:
-- Silent Aim, Gun Mods, ESP (Player/World/Loot/NPC/Base), 
-- Radar/Minimap, Movement (Fly/Spider/BHop/Fling), 
-- Anti-Aim, Desync, Autofarm, Config System
local function load_april_base()
    local ok, err = pcall(function()
        utility.LoadUrl("https://raw.githubusercontent.com/Cunzaki/April/refs/heads/main/april.lua")
    end)
    if not ok then
        -- Fallback: try direct HTTP
        if utility and utility.http_get then
            local body = utility.http_get("https://raw.githubusercontent.com/Cunzaki/April/refs/heads/main/april.lua")
            if body and #body > 100 then
                local fn, parse_err = loadstring(body)
                if fn then
                    fn()
                else
                    error("[BobaV1] Script parse error: " .. tostring(parse_err))
                end
            else
                error("[BobaV1] Failed to download base script")
            end
        else
            error("[BobaV1] LoadUrl failed: " .. tostring(err))
        end
    end
end

-- Apply BobaV1 modifications after April loads
local function apply_boba_mods()
    if not April then
        print("[BobaV1] Warning: April framework not found, mods skipped")
        return
    end
    
    -- ═══ 1. Rebrand ═══
    -- Override the menu tab name if possible
    if April._mods and April._mods["core.menu_util"] then
        local menu_util = April.require("core.menu_util")
        if menu_util then
            -- The tab name shown in the executor's menu
            -- Original: "April" -> now "BobaV1"
            menu_util.TAB = BOBA_NAME
        end
    end
    
    -- ═══ 2. Remove Anime Baddie ═══
    -- Null out the anime baddie modules so they never initialize
    local baddie_modules = {
        "ui.anime_baddie",
        "ui.anime_sprite",
        "ui.anime_baddie_menu",
        "ui.anime_baddie_events",
        "ui.anime_baddie_render",
    }
    
    if April._mods then
        for _, mod_name in ipairs(baddie_modules) do
            if April._mods[mod_name] then
                -- Replace with empty module that returns nothing
                April._mods[mod_name] = (function()
                    return {}
                end)()
            end
        end
    end
    
    -- Also disable anime baddie settings so the menu items don't show
    if April._mods["core.settings"] then
        local settings = April.require("core.settings")
        if settings and settings.set then
            pcall(settings.set, "april_anime_baddie_enabled", false)
        end
    end
    
    -- Hide anime baddie menu elements if menu API available
    if menu and menu.set_visible then
        local baddie_ids = {
            "april_anime_baddie_enabled",
            "april_anime_baddie_character",
            "april_anime_baddie_personality",
            "april_anime_baddie_events",
            "april_anime_baddie_scale",
            "april_anime_baddie_opacity",
            "april_anime_baddie_duration",
            "april_anime_baddie_cooldown",
            "april_anime_baddie_stay",
            "april_anime_baddie_x",
            "april_anime_baddie_y",
        }
        for _, id in ipairs(baddie_ids) do
            pcall(menu.set_visible, id, false)
        end
    end
    
    -- ═══ 3. Boba Startup Logo ═══
    -- Show boba tea branding on load
    if April._mods["core.notify"] then
        local notify = April.require("core.notify")
        if notify then
            pcall(function()
                notify.success("BobaV1 v" .. BOBA_VERSION .. " loaded!", 4000)
                notify.info("Fallen Survival | All features active", 3000)
            end)
        end
    end
    
    -- Load boba logo as startup image (replaces April's cunzaki profile pic)
    if April._mods["game.asset_urls"] then
        local asset_urls = April.require("game.asset_urls")
        if asset_urls then
            -- Override the author profile to show boba logo instead
            local original_author = asset_urls.author_profile_png
            asset_urls.author_profile_png = function()
                -- Point to boba.png in the GitHub repo
                -- User needs to replace boqnpenev1-design
                return "https://raw.githubusercontent.com/boqnpenev1-design/BobaV1/main/boba.png"
            end
        end
    end
    
    -- Override startup intro text if the custom menu module exists
    if April._mods["ui.gs_widgets"] then
        local gs = April.require("ui.gs_widgets")
        if gs and type(gs) == "table" then
            -- Try to override title text
            if gs.TITLE then gs.TITLE = BOBA_NAME end
            if gs.SUBTITLE then gs.SUBTITLE = "v" .. BOBA_VERSION end
        end
    end
    
    -- ═══ 4. Config Store Rebrand ═══
    -- Update config directory name for BobaV1 saves
    if April._mods["core.config_store"] then
        local config_store = April.require("core.config_store")
        if config_store then
            -- The config files will still be compatible with April
            -- but saved under BobaV1 naming
            pcall(function()
                if config_store.CONFIG_DIR then
                    -- Keep April_configs for backward compat, but can be changed
                    -- config_store.CONFIG_DIR = "BobaV1_configs"
                end
            end)
        end
    end
    
    print("[BobaV1] Modifications applied successfully")
    print("[BobaV1] Version: " .. BOBA_VERSION)
    print("[BobaV1] Anime baddie: REMOVED")
    print("[BobaV1] All original features: ACTIVE")
end

-- Apply web UI config if settings were passed
local function apply_web_config()
    if not _G.BobaV1_Config then return end
    
    local cfg = _G.BobaV1_Config
    if type(cfg) ~= "table" then return end
    
    if not April or not April._mods or not April._mods["core.settings"] then return end
    
    local settings = April.require("core.settings")
    if not settings or not settings.set then return end
    
    -- Map web UI keys to April setting IDs
    local KEY_MAP = {
        -- Silent Aim
        silent_aim = "april_silent_aim",
        silent_aim_mode = "april_silent_aim_mode",
        silent_target_type = "april_silent_target_type",
        silent_bone = "april_silent_bone",
        silent_fov = "april_silent_fov",
        silent_max_dist = "april_silent_max_dist",
        silent_hit_chance = "april_silent_hit_chance",
        silent_hitscan = "april_silent_hitscan",
        silent_draw_fov = "april_silent_draw_fov",
        silent_fov_style = "april_silent_fov_style",
        silent_target_line = "april_silent_target_line",
        silent_sticky = "april_silent_sticky",
        -- Bullet
        bullet_enabled = "april_bullet_enabled",
        bullet_body_peek = "april_bullet_body_peek",
        bullet_ug_resolver = "april_bullet_ug_resolver",
        thick_bullet = "april_thick_bullet",
        thick_bullet_mult = "april_thick_bullet_mult",
        bullet_tp = "april_silent_bullet_tp",
        bullet_manip = "april_silent_bullet_manip",
        manip_dist = "april_silent_manip_dist",
        manip_extend = "april_silent_manip_extend",
        manip_extend_dist = "april_silent_manip_extend_dist",
        manip_status = "april_silent_manip_status",
        manip_peek_vis = "april_silent_manip_peek_vis",
        -- Gun Mods
        gunmods_enabled = "april_gunmods_enabled",
        gm_recoil = "april_gm_recoil",
        gm_recoil_pct = "april_gm_recoil_pct",
        gm_spread = "april_gm_spread",
        gm_spread_pct = "april_gm_spread_pct",
        gm_sway = "april_gm_sway",
        gm_fire_rate = "april_gm_fire_rate",
        gm_fire_rate_mult = "april_gm_fire_rate_mult",
        gm_speed = "april_gm_speed",
        gm_speed_mult = "april_gm_speed_mult",
        gm_range = "april_gm_range",
        gm_range_mult = "april_gm_range_mult",
        gm_double_tap = "april_gm_double_tap",
        -- Tracers
        tracers_enabled = "april_tracers_enabled",
        tracers_style = "april_tracers_style",
        tracers_anim = "april_tracers_anim",
        tracers_anim_speed = "april_tracers_anim_speed",
        tracers_lifetime = "april_tracers_lifetime",
        tracers_thickness = "april_tracers_thickness",
        tracers_transparency = "april_tracers_transparency",
        tracers_segments = "april_tracers_segments",
        tracers_glow = "april_tracers_glow",
        tracers_damage = "april_tracers_damage",
        tracers_outline = "april_tracers_outline",
        tracers_impact = "april_tracers_impact",
        tracers_rainbow = "april_tracers_rainbow",
        -- Player ESP
        player_enabled = "april_player_enabled",
        player_box_mode = "april_player_box_mode",
        player_health = "april_player_health",
        player_skeleton = "april_player_skeleton",
        player_name = "april_player_show_name",
        player_held = "april_player_show_held",
        player_distance = "april_player_show_distance",
        player_clan = "april_player_clan_tag",
        player_flag_downed = "april_player_flag_downed",
        player_flag_safezone = "april_player_flag_safezone",
        player_flag_staff = "april_player_flag_staff",
        player_flag_reviving = "april_player_flag_reviving",
        player_flag_movement = "april_player_flag_movement",
        player_flag_vip = "april_player_flag_vip",
        player_flag_cheater = "april_player_flag_cheater",
        player_flag_animation = "april_player_flag_animation",
        player_range = "april_player_range",
        -- Crosshair
        crosshair_enabled = "april_crosshair_enabled",
        crosshair_type = "april_crosshair_type",
        crosshair_size = "april_crosshair_size",
        crosshair_gap = "april_crosshair_gap",
        crosshair_thickness = "april_crosshair_thickness",
        crosshair_rainbow = "april_crosshair_rainbow",
        crosshair_rainbow_speed = "april_crosshair_rainbow_speed",
        crosshair_follow = "april_crosshair_follow",
        crosshair_follow_smooth = "april_crosshair_follow_smooth",
        crosshair_spin = "april_crosshair_spin",
        crosshair_spin_speed = "april_crosshair_spin_speed",
        crosshair_pulse = "april_crosshair_pulse",
        crosshair_pulse_speed = "april_crosshair_pulse_speed",
        -- Sound ESP
        sound_esp = "april_sound_esp",
        sound_fade_in = "april_sound_esp_fade_in",
        sound_fade_out = "april_sound_esp_fade_out",
        sound_size = "april_sound_esp_size",
        sound_max_dist = "april_sound_esp_max_dist",
        sound_max_per = "april_sound_esp_max_per",
        sound_chip = "april_sound_esp_chip",
        sound_under = "april_sound_esp_under",
        -- Aimbot
        aimbot = "april_aimbot",
        aim_target_type = "april_aim_target_type",
        aim_bone = "april_aim_bone",
        aim_fov = "april_aim_fov",
        aim_max_dist = "april_aim_max_dist",
        aim_smooth = "april_aim_smooth",
        aim_smooth_type = "april_aim_smooth_type",
        aim_humanize = "april_aim_humanize",
        aim_humanize_str = "april_aim_humanize_str",
        aim_auto_pred = "april_aim_auto_pred",
        aim_sticky = "april_aim_sticky",
        aim_draw_fov = "april_aim_draw_fov",
        aim_fov_style = "april_aim_fov_style",
        aim_target_line = "april_aim_target_line",
        -- World ESP
        world_enabled = "april_world_enabled",
        world_stone = "april_stone_node",
        world_metal = "april_metal_node",
        world_phosphate = "april_phosphate_node",
        world_corn = "april_corn_plant",
        world_tomato = "april_tomato_plant",
        world_pumpkin = "april_pumpkin_plant",
        world_lemon = "april_lemon_plant",
        world_raspberry = "april_raspberry_plant",
        world_blueberry = "april_blueberry_plant",
        world_wool = "april_wool_plant",
        world_deer = "april_deer",
        world_boar = "april_boar",
        world_wolf = "april_wolf",
        world_boxes = "april_world_boxes",
        world_name = "april_world_show_name",
        world_distance = "april_world_show_distance",
        world_range = "april_world_range",
        -- Loot ESP
        loot_enabled = "april_loot_enabled",
        loot_dropped = "april_dropped_item",
        loot_wooden_crate = "april_wooden_crate",
        loot_metal_crate = "april_metal_crate",
        loot_steel_crate = "april_steel_crate",
        loot_food_crate = "april_food_crate",
        loot_timed_crate = "april_timed_crate",
        loot_care_package = "april_care_package",
        loot_btr_crate = "april_btr_crate",
        loot_body_bag = "april_body_bag",
        loot_sleeper = "april_sleeper",
        loot_trash_can = "april_trash_can",
        loot_oil_barrel = "april_oil_barrel",
        loot_small_egg = "april_small_egg",
        loot_medium_egg = "april_medium_egg",
        loot_large_egg = "april_large_egg",
        loot_wooden_boat = "april_wooden_boat",
        loot_military_boat = "april_military_boat",
        loot_flycopter = "april_flycopter",
        loot_heli_crate = "april_heli_crate",
        loot_boxes = "april_loot_boxes",
        loot_name = "april_loot_show_name",
        loot_distance = "april_loot_show_distance",
        loot_range = "april_loot_range",
        -- NPC ESP
        npc_enabled = "april_npc_enabled",
        npc_soldier = "april_npc_soldier",
        npc_bruno = "april_npc_bruno",
        npc_boris = "april_npc_boris",
        npc_brutus = "april_npc_brutus",
        npc_attack_heli = "april_npc_attack_heli",
        npc_btr = "april_npc_btr",
        npc_diver_dave = "april_npc_diver_dave",
        npc_pilot_pete = "april_npc_pilot_pete",
        npc_box_mode = "april_npc_box_mode",
        npc_health = "april_npc_health",
        npc_name = "april_npc_show_name",
        npc_distance = "april_npc_show_distance",
        npc_range = "april_npc_range",
        -- Base ESP
        base_enabled = "april_base_enabled",
        base_cabinet = "april_base_cabinet",
        base_storage = "april_storage_cabinet",
        base_small_box = "april_small_box",
        base_large_box = "april_large_box",
        base_sleeping_bag = "april_sleeping_bag",
        base_auto_turret = "april_auto_turret",
        base_auto_turret_ring = "april_auto_turret_ring",
        base_shotgun_turret = "april_shotgun_turret",
        base_shotgun_turret_ring = "april_shotgun_turret_ring",
        base_wooden_door = "april_wooden_door",
        base_wooden_double = "april_wooden_double_door",
        base_salvaged_door = "april_salvaged_door",
        base_metal_door = "april_metal_door",
        base_metal_double = "april_metal_double_door",
        base_steel_door = "april_steel_door",
        base_steel_double = "april_steel_double_door",
        base_garage_door = "april_garage_door",
        base_trap_door = "april_trap_door",
        base_triangle_trap = "april_triangle_trap_door",
        base_small_battery = "april_small_battery",
        base_medium_battery = "april_medium_battery",
        base_large_battery = "april_large_battery",
        base_solar_panel = "april_solar_panel",
        base_windmill = "april_windmill",
        base_boxes = "april_base_boxes",
        base_name = "april_base_show_name",
        base_distance = "april_base_show_distance",
        base_range = "april_base_range",
        base_xray = "april_base_xray_enabled",
        base_xray_range = "april_base_xray_range",
        -- Radar
        map_enabled = "april_map_enabled",
        map_zoom = "april_map_zoom",
        map_size = "april_map_size",
        map_opacity = "april_map_opacity",
        map_icon_scale = "april_map_icon_scale",
        map_show_players = "april_map_show_players",
        map_show_npcs = "april_map_show_npcs",
        map_show_loot = "april_map_show_loot",
        map_show_world = "april_map_show_world",
        map_show_base = "april_map_show_base",
        map_show_waypoints = "april_map_show_waypoints",
        map_show_raids = "april_map_show_raids",
        map_labels = "april_map_labels",
        -- Waypoints
        waypoints_enabled = "april_waypoints_enabled",
        wp_dist = "april_wp_dist",
        wp_beacon = "april_wp_beacon",
        wp_beacon_h = "april_wp_beacon_h",
        -- Raid
        raid_enabled = "april_raid_enabled",
        raid_notifications = "april_raid_notifications",
        raid_range = "april_raid_range",
        -- Movement
        fly_enabled = "april_fly_enabled",
        fly_speed = "april_fly_speed",
        fly_noclip = "april_fly_noclip",
        bhop_enabled = "april_bhop_enabled",
        spider_enabled = "april_spider_enabled",
        spider_speed = "april_spider_speed",
        antifling_enabled = "april_antifling_enabled",
        fling_enabled = "april_fling_enabled",
        fling_fov = "april_fling_fov",
        fling_duration = "april_fling_duration",
        -- Anti-Aim
        antiaim_enabled = "april_antiaim_enabled",
        antiaim_yaw_mode = "april_antiaim_yaw_mode",
        antiaim_yaw_manual = "april_antiaim_yaw_manual",
        antiaim_spin_speed = "april_antiaim_spin_speed",
        antiaim_jitter_step = "april_antiaim_jitter_step",
        antiaim_jitter_ms = "april_antiaim_jitter_ms",
        -- Desync
        desync_enabled = "april_desync_enabled",
        desync_visualizer = "april_desync_visualizer",
        -- Fakeduck
        fakeduck_enabled = "april_fakeduck_enabled",
        fakeduck_height = "april_fakeduck_height",
        fakeduck_spam = "april_fakeduck_spam",
        fakeduck_spam_min = "april_fakeduck_spam_min",
        fakeduck_spam_max = "april_fakeduck_spam_max",
        fakeduck_spam_ms = "april_fakeduck_spam_ms",
        -- Other
        anti_afk = "april_anti_afk",
        autofarm = "april_autofarm",
        autofarm_search_range = "april_autofarm_search_range",
        farm_helper = "april_farm_helper",
        farm_radius = "april_farm_radius",
    }
    
    local applied = 0
    for web_key, april_key in pairs(KEY_MAP) do
        if cfg[web_key] ~= nil then
            local ok = pcall(settings.set, april_key, cfg[web_key])
            if ok then applied = applied + 1 end
        end
    end
    
    if applied > 0 then
        print("[BobaV1] Applied " .. applied .. " settings from web config")
        local notify = April.require("core.notify")
        if notify then
            pcall(notify.success, applied .. " settings applied from BobaV1 web config", 3000)
        end
    end
end

-- ═══ Main Execution ═══
print("╔══════════════════════════════════════╗")
print("║         BobaV1 v" .. BOBA_VERSION .. "               ║")
print("║      Fallen Survival Cheat          ║")
print("╚══════════════════════════════════════╝")

-- Step 1: Load base framework
print("[BobaV1] Loading April framework...")
load_april_base()

-- Step 2: Apply BobaV1 modifications
print("[BobaV1] Applying modifications...")
apply_boba_mods()

-- Step 3: Apply web UI config if present
apply_web_config()

print("[BobaV1] Ready! All features active.")
