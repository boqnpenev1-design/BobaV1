/* ═══════════════════════════════════════════════════════
   BobaV1 — App Core
   Settings store, tab rendering, and export logic
   ═══════════════════════════════════════════════════════ */

// ── Settings Store ────────────────────────────────────
const S = new Proxy({}, {
    get(target, key) {
        if (!(key in target)) {
            const saved = localStorage.getItem('boba_' + key);
            if (saved !== null) {
                try { target[key] = JSON.parse(saved); } catch { target[key] = saved; }
            }
        }
        return target[key];
    },
    set(target, key, value) {
        target[key] = value;
        localStorage.setItem('boba_' + key, JSON.stringify(value));
        return true;
    }
});

// ── Defaults ──────────────────────────────────────────
const DEFAULTS = {
    // Silent Aim
    silent_aim: false, silent_aim_mode: 'Always',
    silent_target_type: 'Closest', silent_bone: 'Head',
    silent_fov: 120, silent_max_dist: 800, silent_hit_chance: 100,
    silent_hitscan: false, silent_draw_fov: true, silent_fov_style: 'Circle',
    silent_target_line: false, silent_filters_team: true, silent_filters_downed: true,
    silent_filters_visible: false, silent_whitelist: '', silent_sticky: false,
    silent_fov_color: '#d4a574', silent_line_color: '#ff6b6b',
    // Bullet Manipulation
    bullet_enabled: false, bullet_mode: 'Always',
    bullet_body_peek: false, bullet_ug_resolver: false,
    thick_bullet: false, thick_bullet_mult: 2.0,
    bullet_tp: false, bullet_manip: false,
    manip_dist: 0.5, manip_extend: false, manip_extend_dist: 3.0,
    manip_status: false, manip_peek_vis: false,
    // Gun Mods
    gunmods_enabled: false, gunmods_mode: 'Always',
    gm_recoil: false, gm_recoil_pct: 0, gm_spread: false, gm_spread_pct: 0,
    gm_sway: false, gm_fire_rate: false, gm_fire_rate_mult: 2.0,
    gm_speed: false, gm_speed_mult: 2.0,
    gm_range: false, gm_range_mult: 2.0, gm_double_tap: false,
    // Tracers
    tracers_enabled: false, tracers_mode: 'Always',
    tracers_color: '#d4a574', tracers_color2: '#e8be8e',
    tracers_style: 'Line', tracers_anim: false, tracers_anim_speed: 1.0,
    tracers_lifetime: 1.0, tracers_thickness: 2, tracers_transparency: 0.8,
    tracers_segments: 12, tracers_glow: false, tracers_damage: false,
    tracers_outline: false, tracers_impact: false, tracers_rainbow: false,
    // Player ESP
    player_enabled: false, player_mode: 'Always',
    player_box_mode: '2D', player_box_color: '#d4a574',
    player_health: true, player_skeleton: true, player_skeleton_color: '#ffffff',
    player_name: true, player_name_color: '#e8e6f0', player_held: true,
    player_distance: true, player_clan: false,
    player_flag_downed: true, player_flag_safezone: true, player_flag_staff: true,
    player_flag_reviving: true, player_flag_movement: false, player_flag_vip: false,
    player_flag_cheater: true, player_flag_animation: false,
    player_range: 600,
    // Crosshair
    crosshair_enabled: false, crosshair_type: 'Cross',
    crosshair_size: 6, crosshair_gap: 3, crosshair_thickness: 2,
    crosshair_color: '#ffffff', crosshair_dot: '#ff6b6b',
    crosshair_outline: '#000000', crosshair_rainbow: false,
    crosshair_rainbow_speed: 1.0, crosshair_follow: false,
    crosshair_follow_smooth: 0.5, crosshair_spin: false,
    crosshair_spin_speed: 1.0, crosshair_pulse: false, crosshair_pulse_speed: 1.0,
    // Sound ESP
    sound_esp: false, sound_fade_in: 200, sound_fade_out: 400,
    sound_size: 20, sound_under: false, sound_screen_y: 0.8,
    sound_max_dist: 200, sound_max_per: 5,
    sound_chip: true, sound_color: '#66d9e8',
    // Aimbot (Camera)
    aimbot: false, aimbot_mode: 'Hold',
    aim_key: 'RMB', aim_key_mode: 'Hold',
    aim_target_type: 'Closest', aim_bone: 'Head',
    aim_sticky: false, aim_auto_pred: true,
    aim_draw_fov: true, aim_fov_style: 'Circle', aim_target_line: false,
    aim_max_dist: 800, aim_fov: 120, aim_smooth: 5.0,
    aim_smooth_type: 'Linear', aim_humanize: false, aim_humanize_str: 0.3,
    aim_fov_color: '#74b9ff', aim_line_color: '#74b9ff',
    // World ESP
    world_enabled: false, world_mode: 'Always',
    world_stone: true, world_metal: true, world_phosphate: true,
    world_corn: false, world_tomato: false, world_pumpkin: false,
    world_lemon: false, world_raspberry: false, world_blueberry: false,
    world_wool: false, world_deer: false, world_boar: false, world_wolf: false,
    world_boxes: true, world_name: true, world_distance: true, world_range: 300,
    // Loot ESP
    loot_enabled: false, loot_mode: 'Always',
    loot_dropped: true, loot_wooden_crate: true, loot_metal_crate: true,
    loot_steel_crate: true, loot_food_crate: true, loot_timed_crate: true,
    loot_care_package: true, loot_btr_crate: true,
    loot_body_bag: true, loot_sleeper: true, loot_trash_can: false,
    loot_oil_barrel: false, loot_small_egg: false, loot_medium_egg: false,
    loot_large_egg: false, loot_wooden_boat: false, loot_military_boat: false,
    loot_flycopter: false, loot_heli_crate: true,
    loot_boxes: true, loot_name: true, loot_distance: true, loot_range: 400,
    // NPC ESP
    npc_enabled: false, npc_mode: 'Always',
    npc_soldier: true, npc_bruno: true, npc_boris: true, npc_brutus: true,
    npc_attack_heli: true, npc_btr: true, npc_diver_dave: false, npc_pilot_pete: false,
    npc_box_mode: '2D', npc_health: true,
    npc_name: true, npc_distance: true, npc_range: 500,
    // Base ESP
    base_enabled: false, base_mode: 'Always',
    base_cabinet: true, base_storage: true, base_small_box: true, base_large_box: true,
    base_sleeping_bag: false, base_auto_turret: true, base_auto_turret_ring: true,
    base_shotgun_turret: true, base_shotgun_turret_ring: true,
    base_wooden_door: false, base_wooden_double: false, base_salvaged_door: false,
    base_metal_door: true, base_metal_double: true, base_steel_door: true,
    base_steel_double: true, base_garage_door: true, base_trap_door: false,
    base_triangle_trap: false,
    base_small_battery: false, base_medium_battery: false, base_large_battery: false,
    base_solar_panel: false, base_windmill: false,
    base_boxes: true, base_name: true, base_distance: true, base_range: 250,
    base_xray: false, base_xray_range: 100,
    // Radar / Minimap
    map_enabled: false, map_mode: 'Always',
    map_zoom: 1.5, map_size: 200, map_opacity: 0.85, map_icon_scale: 1.0,
    map_show_players: true, map_show_npcs: true, map_show_loot: true,
    map_show_world: false, map_show_base: false, map_show_waypoints: true,
    map_show_raids: true, map_labels: true,
    // Waypoints
    waypoints_enabled: false, waypoints_mode: 'Always',
    wp_dist: true, wp_beacon: true, wp_beacon_h: 90,
    // Raid Alerts
    raid_enabled: false, raid_mode: 'Always',
    raid_notifications: true, raid_range: 800,
    // Misc Movement
    fly_enabled: false, fly_mode: 'Toggle', fly_speed: 5, fly_noclip: true,
    bhop_enabled: false, bhop_mode: 'Toggle',
    spider_enabled: false, spider_mode: 'Toggle', spider_speed: 18,
    antifling_enabled: false, antifling_mode: 'Always',
    fling_enabled: false, fling_mode: 'Hold', fling_fov: 90, fling_duration: 3,
    // Anti-Aim
    antiaim_enabled: false, antiaim_mode: 'Always',
    antiaim_yaw_mode: 'Backward', antiaim_yaw_manual: 0,
    antiaim_spin_speed: 5, antiaim_jitter_step: 30, antiaim_jitter_ms: 100,
    // Desync / Fakeduck
    desync_enabled: false, desync_mode: 'Always', desync_visualizer: false,
    fakeduck_enabled: false, fakeduck_mode: 'Hold', fakeduck_height: 1.4,
    fakeduck_spam: false, fakeduck_spam_mode: 'Hold',
    fakeduck_spam_min: 0.8, fakeduck_spam_max: 1.8, fakeduck_spam_ms: 200,
    // Other Misc
    anti_afk: false,
    autofarm: false, autofarm_mode: 'Always', autofarm_search_range: 80, autofarm_debug: false,
    farm_helper: false, farm_helper_mode: 'Always', farm_radius: 30,
};

// Initialize defaults
for (const [k, v] of Object.entries(DEFAULTS)) {
    if (S[k] === undefined) S[k] = v;
}

// ── Helpers ───────────────────────────────────────────
function el(tag, attrs = {}, ...children) {
    const e = document.createElement(tag);
    for (const [k, v] of Object.entries(attrs)) {
        if (k === 'class') e.className = v;
        else if (k === 'style' && typeof v === 'object') Object.assign(e.style, v);
        else if (k.startsWith('on')) e.addEventListener(k.slice(2).toLowerCase(), v);
        else e.setAttribute(k, v);
    }
    for (const c of children) {
        if (typeof c === 'string') e.appendChild(document.createTextNode(c));
        else if (c) e.appendChild(c);
    }
    return e;
}

function toggle(key, label) {
    const row = el('div', { class: 'ctrl-row' },
        el('span', { class: 'ctrl-label' }, label),
        el('label', { class: 'toggle' },
            Object.assign(el('input', { type: 'checkbox' }), {
                checked: !!S[key],
                onchange(e) { S[key] = e.target.checked; }
            }),
            el('span', { class: 'toggle-track' }),
            el('span', { class: 'toggle-thumb' })
        )
    );
    return row;
}

function slider(key, label, min, max, step = 1, suffix = '') {
    const val = el('span', { class: 'slider-val' }, formatVal(S[key] ?? min, suffix));
    const inp = Object.assign(el('input', {
        type: 'range', class: 'slider',
        min: String(min), max: String(max), step: String(step)
    }), {
        value: S[key] ?? min,
        oninput(e) {
            S[key] = parseFloat(e.target.value);
            val.textContent = formatVal(S[key], suffix);
        }
    });
    return el('div', { class: 'ctrl-row' },
        el('span', { class: 'ctrl-label' }, label),
        el('div', { class: 'slider-wrap' }, inp, val)
    );
}

function formatVal(v, suffix) {
    if (Number.isInteger(v)) return v + suffix;
    return parseFloat(v).toFixed(1) + suffix;
}

function combo(key, label, options) {
    const sel = el('select', { class: 'combo' });
    options.forEach(opt => {
        const o = el('option', { value: opt }, opt);
        if (S[key] === opt) o.selected = true;
        sel.appendChild(o);
    });
    sel.onchange = (e) => { S[key] = e.target.value; };
    return el('div', { class: 'ctrl-row' },
        el('span', { class: 'ctrl-label' }, label),
        sel
    );
}

function colorPick(key, label) {
    const inp = Object.assign(el('input', { type: 'color', class: 'color-pick' }), {
        value: S[key] || '#ffffff',
        oninput(e) { S[key] = e.target.value; }
    });
    return el('div', { class: 'ctrl-row' },
        el('span', { class: 'ctrl-label' }, label),
        inp
    );
}

function textInput(key, label, placeholder = '') {
    const inp = Object.assign(el('input', {
        type: 'text', class: 'text-input', placeholder
    }), {
        value: S[key] || '',
        oninput(e) { S[key] = e.target.value; }
    });
    return el('div', { class: 'ctrl-row' },
        el('span', { class: 'ctrl-label' }, label),
        inp
    );
}

function bindMode(key) {
    const modes = ['Always', 'Hold', 'Toggle'];
    const group = el('div', { class: 'bind-group' });
    modes.forEach(m => {
        const pill = el('button', {
            class: 'bind-pill' + (S[key] === m ? ' active' : '')
        }, m);
        pill.onclick = () => {
            S[key] = m;
            group.querySelectorAll('.bind-pill').forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
        };
        group.appendChild(pill);
    });
    return group;
}

function masterToggle(key, modeKey, label) {
    const row = el('div', { class: 'ctrl-row' },
        el('span', { class: 'ctrl-label', style: { fontWeight: '600', color: 'var(--accent)' } }, label),
        el('div', { class: 'ctrl-right' },
            bindMode(modeKey),
            (() => {
                const t = el('label', { class: 'toggle' },
                    Object.assign(el('input', { type: 'checkbox' }), {
                        checked: !!S[key],
                        onchange(e) { S[key] = e.target.checked; }
                    }),
                    el('span', { class: 'toggle-track' }),
                    el('span', { class: 'toggle-thumb' })
                );
                return t;
            })()
        )
    );
    return row;
}

function sep() { return el('div', { class: 'sep' }); }
function subLabel(text) { return el('div', { class: 'sub-label' }, text); }

function section(title, ...children) {
    const body = el('div', { class: 'section-body' }, ...children);
    const chevron = el('span', { class: 'section-chevron' }, '▼');
    const header = el('div', { class: 'section-header' },
        el('span', { class: 'section-title' },
            el('span', { class: 'dot' }),
            title
        ),
        chevron
    );
    const sec = el('div', { class: 'section' }, header, body);
    header.onclick = () => sec.classList.toggle('collapsed');
    return sec;
}

function multiGrid(items) {
    const grid = el('div', { class: 'multi-grid' });
    items.forEach(([key, label]) => {
        grid.appendChild(el('div', { class: 'multi-item' },
            el('span', { class: 'ctrl-label' }, label),
            el('label', { class: 'toggle' },
                Object.assign(el('input', { type: 'checkbox' }), {
                    checked: !!S[key],
                    onchange(e) { S[key] = e.target.checked; }
                }),
                el('span', { class: 'toggle-track' }),
                el('span', { class: 'toggle-thumb' })
            )
        ));
    });
    return grid;
}


// ── Tab Renderers ─────────────────────────────────────

const BONES = ['Closest','Head','UpperTorso','LowerTorso','HumanoidRootPart',
    'LeftUpperArm','RightUpperArm','LeftLowerArm','RightLowerArm',
    'LeftHand','RightHand','LeftUpperLeg','RightUpperLeg',
    'LeftLowerLeg','RightLowerLeg','LeftFoot','RightFoot'];
const TARGET_TYPES = ['Closest', 'Lowest HP', 'Closest to Crosshair'];
const FOV_STYLES = ['Circle', 'Filled Circle', 'Cross'];

function tabSilentAim() {
    return el('div', { class: 'tab-content' },
        el('div', { class: 'tab-grid' },
            el('div', { class: 'tab-col' },
                section('Silent Aim',
                    masterToggle('silent_aim', 'silent_aim_mode', 'Enabled'),
                    combo('silent_target_type', 'Target Type', TARGET_TYPES),
                    combo('silent_bone', 'Target Bone', BONES),
                    slider('silent_fov', 'FOV', 10, 360, 1, '°'),
                    slider('silent_max_dist', 'Max Distance', 50, 2000, 10, 'm'),
                    slider('silent_hit_chance', 'Hit Chance', 0, 100, 1, '%'),
                    toggle('silent_hitscan', 'Hitscan'),
                    toggle('silent_sticky', 'Sticky Target'),
                    sep(),
                    subLabel('Visuals'),
                    toggle('silent_draw_fov', 'Draw FOV'),
                    combo('silent_fov_style', 'FOV Style', FOV_STYLES),
                    colorPick('silent_fov_color', 'FOV Color'),
                    toggle('silent_target_line', 'Target Line'),
                    colorPick('silent_line_color', 'Line Color'),
                    sep(),
                    subLabel('Filters'),
                    toggle('silent_filters_team', 'Ignore Teammates'),
                    toggle('silent_filters_downed', 'Ignore Downed'),
                    toggle('silent_filters_visible', 'Visible Only'),
                    textInput('silent_whitelist', 'Whitelist IDs', 'Comma-separated user IDs')
                )
            ),
            el('div', { class: 'tab-col' },
                section('Bullet Manipulation',
                    masterToggle('bullet_enabled', 'bullet_mode', 'Enabled'),
                    toggle('bullet_body_peek', 'Body Peek'),
                    toggle('bullet_ug_resolver', 'UG Resolver'),
                    sep(),
                    subLabel('Thick Bullet'),
                    toggle('thick_bullet', 'Enable'),
                    slider('thick_bullet_mult', 'Multiplier', 1.0, 5.0, 0.1, 'x'),
                    sep(),
                    subLabel('Teleport'),
                    toggle('bullet_tp', 'Silent Bullet TP'),
                    sep(),
                    subLabel('Position Manipulation'),
                    toggle('bullet_manip', 'Enable'),
                    slider('manip_dist', 'Manipulation Dist', 0.1, 3.0, 0.1, 'm'),
                    toggle('manip_extend', 'Extend Range'),
                    slider('manip_extend_dist', 'Extend Distance', 0.5, 7.0, 0.1, 'm'),
                    toggle('manip_status', 'Show Status'),
                    toggle('manip_peek_vis', 'Peek Visualizer')
                )
            )
        )
    );
}

function tabGunMods() {
    return el('div', { class: 'tab-content' },
        el('div', { class: 'tab-grid' },
            el('div', { class: 'tab-col' },
                section('Gun Modifications',
                    masterToggle('gunmods_enabled', 'gunmods_mode', 'Enabled'),
                    sep(),
                    toggle('gm_recoil', 'No Recoil'),
                    slider('gm_recoil_pct', 'Recoil Reduction', 0, 100, 1, '%'),
                    sep(),
                    toggle('gm_spread', 'No Spread'),
                    slider('gm_spread_pct', 'Spread Reduction', 0, 100, 1, '%'),
                    sep(),
                    toggle('gm_sway', 'No Sway'),
                    sep(),
                    toggle('gm_fire_rate', 'Fire Rate Mod'),
                    slider('gm_fire_rate_mult', 'Rate Multiplier', 0.5, 5.0, 0.1, 'x'),
                    sep(),
                    toggle('gm_speed', 'Bullet Speed Mod'),
                    slider('gm_speed_mult', 'Speed Multiplier', 0.5, 5.0, 0.1, 'x'),
                    sep(),
                    toggle('gm_range', 'Range Mod'),
                    slider('gm_range_mult', 'Range Multiplier', 0.5, 5.0, 0.1, 'x'),
                    sep(),
                    toggle('gm_double_tap', 'Double Tap')
                )
            ),
            el('div', { class: 'tab-col' },
                section('Tracers',
                    masterToggle('tracers_enabled', 'tracers_mode', 'Enabled'),
                    combo('tracers_style', 'Style', ['Line', 'Arc', 'Curve', 'Beam']),
                    colorPick('tracers_color', 'Primary Color'),
                    colorPick('tracers_color2', 'Secondary Color'),
                    sep(),
                    toggle('tracers_anim', 'Animated'),
                    slider('tracers_anim_speed', 'Anim Speed', 0.1, 5.0, 0.1, 'x'),
                    slider('tracers_lifetime', 'Lifetime', 0.1, 5.0, 0.1, 's'),
                    slider('tracers_thickness', 'Thickness', 1, 6, 1, 'px'),
                    slider('tracers_transparency', 'Opacity', 0.1, 1.0, 0.05, ''),
                    slider('tracers_segments', 'Segments', 4, 32, 1, ''),
                    sep(),
                    subLabel('Effects'),
                    multiGrid([
                        ['tracers_glow', 'Glow'],
                        ['tracers_damage', 'Damage #'],
                        ['tracers_outline', 'Outline'],
                        ['tracers_impact', 'Impact'],
                        ['tracers_rainbow', 'Rainbow'],
                    ])
                )
            )
        )
    );
}

function tabVisuals() {
    return el('div', { class: 'tab-content' },
        el('div', { class: 'tab-grid' },
            el('div', { class: 'tab-col' },
                section('Player ESP',
                    masterToggle('player_enabled', 'player_mode', 'Enabled'),
                    combo('player_box_mode', 'Box Mode', ['2D', 'Corner', '3D', 'None']),
                    colorPick('player_box_color', 'Box Color'),
                    slider('player_range', 'Range', 50, 2000, 10, 'm'),
                    sep(),
                    subLabel('Info'),
                    multiGrid([
                        ['player_health', 'Health Bar'],
                        ['player_skeleton', 'Skeleton'],
                        ['player_name', 'Name'],
                        ['player_held', 'Held Item'],
                        ['player_distance', 'Distance'],
                        ['player_clan', 'Clan Tag'],
                    ]),
                    colorPick('player_skeleton_color', 'Skeleton Color'),
                    colorPick('player_name_color', 'Name Color'),
                    sep(),
                    subLabel('Flags'),
                    multiGrid([
                        ['player_flag_downed', 'Downed'],
                        ['player_flag_safezone', 'Safezone'],
                        ['player_flag_staff', 'Staff'],
                        ['player_flag_reviving', 'Reviving'],
                        ['player_flag_movement', 'Movement'],
                        ['player_flag_vip', 'VIP'],
                        ['player_flag_cheater', 'Cheater'],
                        ['player_flag_animation', 'Animation'],
                    ])
                ),
                section('Sound ESP',
                    toggle('sound_esp', 'Enabled'),
                    colorPick('sound_color', 'Color'),
                    slider('sound_fade_in', 'Fade In', 50, 1000, 10, 'ms'),
                    slider('sound_fade_out', 'Fade Out', 50, 1000, 10, 'ms'),
                    slider('sound_size', 'Icon Size', 8, 48, 1, 'px'),
                    slider('sound_max_dist', 'Max Distance', 50, 500, 10, 'm'),
                    slider('sound_max_per', 'Max Per Player', 1, 10, 1, ''),
                    toggle('sound_under', 'Show Under'),
                    toggle('sound_chip', 'Chip Style'),
                )
            ),
            el('div', { class: 'tab-col' },
                section('Aimbot (Camera)',
                    masterToggle('aimbot', 'aimbot_mode', 'Enabled'),
                    combo('aim_key', 'Aim Key', ['RMB', 'LMB', 'MMB', 'Shift', 'Ctrl', 'Alt']),
                    combo('aim_key_mode', 'Key Mode', ['Hold', 'Toggle', 'Always']),
                    combo('aim_target_type', 'Target Type', TARGET_TYPES),
                    combo('aim_bone', 'Bone', BONES),
                    slider('aim_fov', 'FOV', 10, 360, 1, '°'),
                    slider('aim_max_dist', 'Max Distance', 50, 2000, 10, 'm'),
                    slider('aim_smooth', 'Smoothing', 1.0, 20.0, 0.5, ''),
                    combo('aim_smooth_type', 'Smooth Type', ['Linear', 'Exponential', 'Adaptive']),
                    sep(),
                    toggle('aim_humanize', 'Humanize'),
                    slider('aim_humanize_str', 'Humanize Strength', 0.0, 1.0, 0.05, ''),
                    toggle('aim_auto_pred', 'Auto Prediction'),
                    toggle('aim_sticky', 'Sticky Target'),
                    sep(),
                    subLabel('Visuals'),
                    toggle('aim_draw_fov', 'Draw FOV'),
                    combo('aim_fov_style', 'FOV Style', FOV_STYLES),
                    colorPick('aim_fov_color', 'FOV Color'),
                    toggle('aim_target_line', 'Target Line'),
                    colorPick('aim_line_color', 'Line Color'),
                ),
                section('Crosshair',
                    toggle('crosshair_enabled', 'Enabled'),
                    combo('crosshair_type', 'Type', ['Cross', 'Dot', 'Circle', 'T-Shape', 'Diamond']),
                    slider('crosshair_size', 'Size', 1, 20, 1, 'px'),
                    slider('crosshair_gap', 'Gap', 0, 15, 1, 'px'),
                    slider('crosshair_thickness', 'Thickness', 1, 6, 1, 'px'),
                    colorPick('crosshair_color', 'Color'),
                    colorPick('crosshair_dot', 'Dot Color'),
                    colorPick('crosshair_outline', 'Outline Color'),
                    sep(),
                    subLabel('Effects'),
                    toggle('crosshair_rainbow', 'Rainbow'),
                    slider('crosshair_rainbow_speed', 'Rainbow Speed', 0.1, 5.0, 0.1, 'x'),
                    toggle('crosshair_follow', 'Follow Aim'),
                    slider('crosshair_follow_smooth', 'Follow Smooth', 0.0, 1.0, 0.05, ''),
                    toggle('crosshair_spin', 'Spin'),
                    slider('crosshair_spin_speed', 'Spin Speed', 0.1, 5.0, 0.1, 'x'),
                    toggle('crosshair_pulse', 'Pulse'),
                    slider('crosshair_pulse_speed', 'Pulse Speed', 0.1, 5.0, 0.1, 'x'),
                )
            )
        )
    );
}

function tabWorld() {
    return el('div', { class: 'tab-content' },
        el('div', { class: 'tab-grid' },
            el('div', { class: 'tab-col' },
                section('World ESP',
                    masterToggle('world_enabled', 'world_mode', 'Enabled'),
                    toggle('world_boxes', 'Draw Boxes'),
                    toggle('world_name', 'Show Name'),
                    toggle('world_distance', 'Show Distance'),
                    slider('world_range', 'Range', 50, 1000, 10, 'm'),
                    sep(),
                    subLabel('Resources'),
                    multiGrid([
                        ['world_stone', 'Stone'],
                        ['world_metal', 'Metal'],
                        ['world_phosphate', 'Phosphate'],
                    ]),
                    subLabel('Farming'),
                    multiGrid([
                        ['world_corn', 'Corn'],
                        ['world_tomato', 'Tomato'],
                        ['world_pumpkin', 'Pumpkin'],
                        ['world_lemon', 'Lemon'],
                        ['world_raspberry', 'Raspberry'],
                        ['world_blueberry', 'Blueberry'],
                        ['world_wool', 'Wool'],
                    ]),
                    subLabel('Animals'),
                    multiGrid([
                        ['world_deer', 'Deer'],
                        ['world_boar', 'Boar'],
                        ['world_wolf', 'Wolf'],
                    ]),
                ),
                section('NPC ESP',
                    masterToggle('npc_enabled', 'npc_mode', 'Enabled'),
                    combo('npc_box_mode', 'Box Mode', ['2D', 'Corner', '3D', 'None']),
                    toggle('npc_health', 'Health Bar'),
                    toggle('npc_name', 'Show Name'),
                    toggle('npc_distance', 'Show Distance'),
                    slider('npc_range', 'Range', 50, 1000, 10, 'm'),
                    sep(),
                    subLabel('NPC Types'),
                    multiGrid([
                        ['npc_soldier', 'Soldier'],
                        ['npc_bruno', 'Bruno'],
                        ['npc_boris', 'Boris'],
                        ['npc_brutus', 'Brutus'],
                        ['npc_attack_heli', 'Attack Heli'],
                        ['npc_btr', 'BTR'],
                        ['npc_diver_dave', 'Diver Dave'],
                        ['npc_pilot_pete', 'Pilot Pete'],
                    ])
                )
            ),
            el('div', { class: 'tab-col' },
                section('Loot ESP',
                    masterToggle('loot_enabled', 'loot_mode', 'Enabled'),
                    toggle('loot_boxes', 'Draw Boxes'),
                    toggle('loot_name', 'Show Name'),
                    toggle('loot_distance', 'Show Distance'),
                    slider('loot_range', 'Range', 50, 1000, 10, 'm'),
                    sep(),
                    subLabel('Containers'),
                    multiGrid([
                        ['loot_dropped', 'Dropped Item'],
                        ['loot_wooden_crate', 'Wooden Crate'],
                        ['loot_metal_crate', 'Metal Crate'],
                        ['loot_steel_crate', 'Steel Crate'],
                        ['loot_food_crate', 'Food Crate'],
                        ['loot_timed_crate', 'Timed Crate'],
                        ['loot_care_package', 'Care Package'],
                        ['loot_btr_crate', 'BTR Crate'],
                        ['loot_heli_crate', 'Heli Crate'],
                    ]),
                    subLabel('Other'),
                    multiGrid([
                        ['loot_body_bag', 'Body Bag'],
                        ['loot_sleeper', 'Sleeper'],
                        ['loot_trash_can', 'Trash Can'],
                        ['loot_oil_barrel', 'Oil Barrel'],
                    ]),
                    subLabel('Eggs'),
                    multiGrid([
                        ['loot_small_egg', 'Small Egg'],
                        ['loot_medium_egg', 'Medium Egg'],
                        ['loot_large_egg', 'Large Egg'],
                    ]),
                    subLabel('Vehicles'),
                    multiGrid([
                        ['loot_wooden_boat', 'Wooden Boat'],
                        ['loot_military_boat', 'Military Boat'],
                        ['loot_flycopter', 'Flycopter'],
                    ])
                ),
                section('Base ESP',
                    masterToggle('base_enabled', 'base_mode', 'Enabled'),
                    toggle('base_boxes', 'Draw Boxes'),
                    toggle('base_name', 'Show Name'),
                    toggle('base_distance', 'Show Distance'),
                    slider('base_range', 'Range', 50, 500, 10, 'm'),
                    sep(),
                    subLabel('Storage'),
                    multiGrid([
                        ['base_cabinet', 'Tool Cupboard'],
                        ['base_storage', 'Storage Cabinet'],
                        ['base_small_box', 'Small Box'],
                        ['base_large_box', 'Large Box'],
                        ['base_sleeping_bag', 'Sleeping Bag'],
                    ]),
                    subLabel('Turrets'),
                    multiGrid([
                        ['base_auto_turret', 'Auto Turret'],
                        ['base_auto_turret_ring', 'Turret Ring'],
                        ['base_shotgun_turret', 'Shotgun Turret'],
                        ['base_shotgun_turret_ring', 'SG Ring'],
                    ]),
                    subLabel('Doors'),
                    multiGrid([
                        ['base_wooden_door', 'Wood Door'],
                        ['base_wooden_double', 'Wood Double'],
                        ['base_salvaged_door', 'Salvaged'],
                        ['base_metal_door', 'Metal Door'],
                        ['base_metal_double', 'Metal Double'],
                        ['base_steel_door', 'Steel Door'],
                        ['base_steel_double', 'Steel Double'],
                        ['base_garage_door', 'Garage Door'],
                        ['base_trap_door', 'Trap Door'],
                        ['base_triangle_trap', 'Tri Trap'],
                    ]),
                    subLabel('Power'),
                    multiGrid([
                        ['base_small_battery', 'Small Battery'],
                        ['base_medium_battery', 'Med Battery'],
                        ['base_large_battery', 'Large Battery'],
                        ['base_solar_panel', 'Solar Panel'],
                        ['base_windmill', 'Windmill'],
                    ]),
                    sep(),
                    toggle('base_xray', 'X-Ray Mode'),
                    slider('base_xray_range', 'X-Ray Range', 20, 300, 5, 'm'),
                )
            )
        )
    );
}

function tabRadar() {
    return el('div', { class: 'tab-content' },
        el('div', { class: 'tab-grid' },
            el('div', { class: 'tab-col' },
                section('Minimap',
                    masterToggle('map_enabled', 'map_mode', 'Enabled'),
                    slider('map_zoom', 'Zoom', 0.5, 5.0, 0.1, 'x'),
                    slider('map_size', 'Size', 100, 400, 10, 'px'),
                    slider('map_opacity', 'Opacity', 0.1, 1.0, 0.05, ''),
                    slider('map_icon_scale', 'Icon Scale', 0.5, 3.0, 0.1, 'x'),
                    toggle('map_labels', 'Show Labels'),
                    sep(),
                    subLabel('Show Layers'),
                    multiGrid([
                        ['map_show_players', 'Players'],
                        ['map_show_npcs', 'NPCs'],
                        ['map_show_loot', 'Loot'],
                        ['map_show_world', 'World'],
                        ['map_show_base', 'Base'],
                        ['map_show_waypoints', 'Waypoints'],
                        ['map_show_raids', 'Raids'],
                    ])
                ),
                section('Waypoints',
                    masterToggle('waypoints_enabled', 'waypoints_mode', 'Enabled'),
                    toggle('wp_dist', 'Show Distance'),
                    toggle('wp_beacon', 'Beacon'),
                    slider('wp_beacon_h', 'Beacon Height', 10, 200, 5, 'm'),
                )
            ),
            el('div', { class: 'tab-col' },
                section('Raid Alerts',
                    masterToggle('raid_enabled', 'raid_mode', 'Enabled'),
                    toggle('raid_notifications', 'Show Notifications'),
                    slider('raid_range', 'Alert Range', 100, 2000, 50, 'm'),
                ),
                section('Event Status',
                    toggle('event_status', 'Enabled'),
                    toggle('event_active_only', 'Active Only'),
                    toggle('event_notify', 'Notifications'),
                    toggle('event_distance', 'Show Distance'),
                    toggle('event_health', 'Show Health'),
                )
            )
        )
    );
}

function tabMisc() {
    return el('div', { class: 'tab-content' },
        el('div', { class: 'tab-grid' },
            el('div', { class: 'tab-col' },
                section('Movement',
                    subLabel('Fly'),
                    masterToggle('fly_enabled', 'fly_mode', 'Fly'),
                    slider('fly_speed', 'Speed', 1, 20, 0.5, ''),
                    toggle('fly_noclip', 'Noclip'),
                    sep(),
                    subLabel('Bunny Hop'),
                    masterToggle('bhop_enabled', 'bhop_mode', 'B-Hop'),
                    sep(),
                    subLabel('Spider Climb'),
                    masterToggle('spider_enabled', 'spider_mode', 'Spider'),
                    slider('spider_speed', 'Speed', 18, 30, 1, ''),
                    sep(),
                    subLabel('Anti-Fling'),
                    masterToggle('antifling_enabled', 'antifling_mode', 'Anti-Fling'),
                    sep(),
                    subLabel('Fling'),
                    masterToggle('fling_enabled', 'fling_mode', 'Fling'),
                    slider('fling_fov', 'FOV', 10, 180, 5, '°'),
                    slider('fling_duration', 'Duration', 1, 10, 1, 's'),
                ),
                section('Autofarm',
                    masterToggle('autofarm', 'autofarm_mode', 'Autofarm'),
                    slider('autofarm_search_range', 'Search Range', 20, 200, 5, 'm'),
                    toggle('autofarm_debug', 'Debug Path'),
                    sep(),
                    masterToggle('farm_helper', 'farm_helper_mode', 'Farm Helper'),
                    slider('farm_radius', 'Radius', 10, 100, 5, 'm'),
                )
            ),
            el('div', { class: 'tab-col' },
                section('Anti-Aim',
                    masterToggle('antiaim_enabled', 'antiaim_mode', 'Enabled'),
                    combo('antiaim_yaw_mode', 'Yaw Mode', ['Backward', 'Manual', 'Spin', 'Jitter', 'Random']),
                    slider('antiaim_yaw_manual', 'Manual Yaw', -180, 180, 1, '°'),
                    slider('antiaim_spin_speed', 'Spin Speed', 1, 20, 1, ''),
                    slider('antiaim_jitter_step', 'Jitter Step', 5, 90, 5, '°'),
                    slider('antiaim_jitter_ms', 'Jitter Interval', 50, 500, 10, 'ms'),
                ),
                section('Desync',
                    masterToggle('desync_enabled', 'desync_mode', 'Enabled'),
                    toggle('desync_visualizer', 'Visualizer'),
                ),
                section('Fake Duck',
                    masterToggle('fakeduck_enabled', 'fakeduck_mode', 'Enabled'),
                    slider('fakeduck_height', 'Height', 0.5, 2.5, 0.1, 'm'),
                    sep(),
                    toggle('fakeduck_spam', 'Spam Duck'),
                    slider('fakeduck_spam_min', 'Min Height', 0.5, 2.0, 0.1, 'm'),
                    slider('fakeduck_spam_max', 'Max Height', 1.0, 3.0, 0.1, 'm'),
                    slider('fakeduck_spam_ms', 'Interval', 50, 500, 10, 'ms'),
                ),
                section('Other',
                    toggle('anti_afk', 'Anti-AFK'),
                )
            )
        )
    );
}

function tabConfig() {
    const resetBtn = el('button', {
        class: 'export-btn',
        style: { background: 'linear-gradient(135deg, #ff6b6b, #ee5a5a)', marginTop: '8px' }
    }, 'Reset All Settings');
    resetBtn.onclick = () => {
        if (confirm('Reset all BobaV1 settings to defaults?')) {
            for (const key of Object.keys(localStorage)) {
                if (key.startsWith('boba_')) localStorage.removeItem(key);
            }
            for (const [k, v] of Object.entries(DEFAULTS)) { S[k] = v; }
            renderTab(currentTab);
        }
    };

    return el('div', { class: 'tab-content' },
        el('div', { class: 'tab-grid' },
            el('div', { class: 'tab-col' },
                section('Configuration',
                    el('div', { class: 'ctrl-row' },
                        el('span', { class: 'ctrl-label', style: { color: 'var(--text-muted)', fontSize: '11px' } },
                            'Settings are auto-saved to your browser\'s localStorage. Export a loadstring to use your configuration in-game.'
                        )
                    ),
                    sep(),
                    resetBtn,
                ),
                section('Keybinds Panel',
                    toggle('keybinds_enabled', 'Show Panel'),
                    toggle('keybinds_active_only', 'Active Only'),
                    toggle('keybinds_show_unbound', 'Show Unbound'),
                    toggle('keybinds_show_mode', 'Show Mode'),
                ),
                section('Mod Checker',
                    toggle('mod_checker', 'Enabled'),
                    slider('mod_checker_interval', 'Check Interval', 5, 60, 1, 's'),
                )
            ),
            el('div', { class: 'tab-col' },
                section('About BobaV1',
                    el('div', { style: { textAlign: 'center', padding: '10px 0' } },
                        el('img', {
                            src: 'boba.png',
                            style: { width: '64px', height: '64px', objectFit: 'contain', filter: 'drop-shadow(0 0 20px rgba(212,165,116,0.3))' }
                        }),
                        el('div', { style: { fontSize: '18px', fontWeight: '700', color: 'var(--accent)', marginTop: '12px' } }, 'BobaV1'),
                        el('div', { style: { fontSize: '12px', color: 'var(--text-dim)', marginTop: '4px' } }, 'Fallen Survival Cheat'),
                        el('div', { style: { fontSize: '10px', color: 'var(--text-muted)', marginTop: '8px', fontFamily: "'JetBrains Mono', monospace" } }, 'Based on April v4.3.0 framework'),
                        el('div', { style: { fontSize: '11px', color: 'var(--text-muted)', marginTop: '16px', lineHeight: '1.6' } },
                            'Configure your settings here, then export a loadstring to use in your executor. All settings are synced to the Lua script.'
                        )
                    )
                ),
                section('Quick Info',
                    el('div', { style: { fontSize: '11px', color: 'var(--text-dim)', lineHeight: '1.8' } },
                        '• Silent Aim → Tab 1 (left)\n• Gun Mods → Tab 2\n• Player/Sound ESP → Tab 3\n• World/Loot/NPC/Base → Tab 4\n• Radar/Map → Tab 5\n• Movement/AntiAim → Tab 6\n• All settings auto-save'
                    )
                )
            )
        )
    );
}


// ── Tab Router ────────────────────────────────────────
const TABS = {
    silentaim: { title: 'Silent Aim', render: tabSilentAim },
    gunmods: { title: 'Gun Mods', render: tabGunMods },
    visuals: { title: 'Visuals', render: tabVisuals },
    world: { title: 'World', render: tabWorld },
    radar: { title: 'Radar', render: tabRadar },
    misc: { title: 'Misc', render: tabMisc },
    config: { title: 'Config', render: tabConfig },
};

let currentTab = 'silentaim';

function renderTab(tabId) {
    currentTab = tabId;
    const tab = TABS[tabId];
    if (!tab) return;
    document.getElementById('tabTitle').textContent = tab.title;
    const body = document.getElementById('contentBody');
    body.innerHTML = '';
    body.appendChild(tab.render());
    body.scrollTop = 0;

    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.tab === tabId);
    });
}


// ── Export Logic ───────────────────────────────────────
function generateLuaConfig() {
    let lua = '-- BobaV1 Configuration\n';
    lua += '-- Generated: ' + new Date().toISOString() + '\n';
    lua += 'local cfg = {}\n';

    for (const [k, v] of Object.entries(DEFAULTS)) {
        const current = S[k];
        if (current !== v) {
            if (typeof current === 'boolean') {
                lua += `cfg["${k}"] = ${current}\n`;
            } else if (typeof current === 'number') {
                lua += `cfg["${k}"] = ${current}\n`;
            } else if (typeof current === 'string') {
                lua += `cfg["${k}"] = "${current}"\n`;
            }
        }
    }

    lua += '\n-- Apply settings\n';
    lua += 'for k, v in pairs(cfg) do\n';
    lua += '    if settings and settings.set then\n';
    lua += '        pcall(settings.set, "april_" .. k, v)\n';
    lua += '    end\n';
    lua += 'end\n';
    lua += '\n-- Load BobaV1 script\n';
    lua += '-- Replace boqnpenev1-design with your GitHub username\n';
    lua += 'utility.LoadUrl("https://raw.githubusercontent.com/boqnpenev1-design/BobaV1/main/boba.lua")\n';

    return lua;
}


// ── Init ──────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
    // Splash → Main transition
    setTimeout(() => {
        document.getElementById('splash').classList.add('hidden');
        document.getElementById('main').classList.remove('hidden');
        renderTab('silentaim');
    }, 1800);

    // Tab navigation
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', () => renderTab(btn.dataset.tab));
    });

    // Export modal
    const modal = document.getElementById('exportModal');
    document.getElementById('exportBtn').addEventListener('click', () => {
        document.getElementById('exportCode').textContent = generateLuaConfig();
        modal.classList.remove('hidden');
    });
    document.getElementById('modalClose').addEventListener('click', () => {
        modal.classList.add('hidden');
    });
    modal.addEventListener('click', (e) => {
        if (e.target === modal) modal.classList.add('hidden');
    });

    // Copy button
    document.getElementById('copyBtn').addEventListener('click', function() {
        const code = document.getElementById('exportCode').textContent;
        navigator.clipboard.writeText(code).then(() => {
            this.textContent = '✓ Copied!';
            this.classList.add('copied');
            setTimeout(() => {
                this.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg> Copy';
                this.classList.remove('copied');
            }, 2000);
        });
    });
});
