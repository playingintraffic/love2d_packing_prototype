--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module core.state
--- @description Handles default state mutable globals.

local defaults = {
    screen_w = 0,
    screen_h = 0,
    grid_size = 32,

    game_state = "title",
    start_level = 1,
    current_level = {},
    current_level_index = 1,

    main_container = {},
    items = {},
    held_item = false,
    held_offset_x = 0,
    held_offset_y = 0,

    preview_gx = 0,
    preview_gy = 0,
    can_snap = false,
    hovered_item = false,
    hovered_container = false,

    cols = 0,
    rows = 0,
    main_container_w = 0,
    main_container_h = 0,
    offset_x = 0,
    offset_y = 0,

    help_icon = false,
    show_help = false,
    show_fps = false,
    show_version_text = true,

    start_music_on_load = true,
    mute_icon = false,
    music_muted = false
}

local state = {}
setmetatable(state, {
    __index = defaults,
    __newindex = function(t, key, value)
        if rawget(defaults, key) == nil then
            error(("Invalid state key: %s"):format(tostring(key)), 2)
        end
        rawset(t, key, value)
    end
})

return state