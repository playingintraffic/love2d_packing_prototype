--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module core.input
--- @description Handles mouse/keyboard input logic split from main.lua

--- @section Game Defs

local game_audio = require("data.audio")
local game_levels = require("data.levels")

--- @section Game Modules

local audio_mod = require("core.audio")
local containers_mod = require("core.containers")
local levels_mod = require("core.levels")

--- @section Module

local input = {}

function input.handle_title_click(state)
    state.game_state = "play"
    levels_mod.load(state, state.start_level)
    audio_mod.play_game_music("level_1")
end

function input.handle_win_click(state, x, y)
    local bw, bh = 120, 40
    local bx1, by1 = (state.screen_w - bw) / 2, state.screen_h / 2
    local bx2, by2 = (state.screen_w - bw) / 2, state.screen_h / 2 + 60

    if x >= bx1 and x <= bx1 + bw and y >= by1 and y <= by1 + bh then
        levels_mod.load(state, state.current_level_index + 1)
        state.game_state = "play"
        return true
    elseif x >= bx2 and x <= bx2 + bw and y >= by2 and y <= by2 + bh then
        state.game_state = "title"
        audio_mod.play_game_music(game_audio, "title")
        return true
    end
    return false
end

function input.handle_item_pickup(state, x, y, item)
    if item.in_container and not item.in_container.is_open then
        return
    end

    local w = #item.def.shape[1] * state.grid_size
    local h = #item.def.shape * state.grid_size
    state.held_item = item
    state.held_offset_x = w / 2
    state.held_offset_y = h / 2
    containers_mod.release_from_grid(state, item)

    if item.in_container and item.in_container.is_open then
        containers_mod.remove_item(item)
        item.x = x - state.held_offset_x
        item.y = y - state.held_offset_y
        item.local_x, item.local_y = nil, nil
    end
end

function input.handle_container_toggle(state, container)
    if state.game_state ~= "win" then
        for _, c in ipairs(state.items) do
            if c ~= container and c.def.container and c.is_open then
                containers_mod.close_recursive(c)
            end
        end

        container.is_open = not container.is_open
        for _, sub in ipairs(container.contents) do
            sub.alpha = container.is_open and 1 or 0
        end

        if not container.is_open then
            containers_mod.close_recursive(container)
        end

        if containers_mod.all_items_placed(state.items) then
            audio_mod.play_sfx("level_win")
            state.game_state = "win"
        end
    end
end

function input.handle_release_into_container(state, x, y)
    local open_container = containers_mod.get_open_container(state.items)
    if not open_container then return false end

    local cx = open_container.placed and (state.offset_x + (open_container.grid_x - 1) * state.grid_size) or open_container.x
    local cy = open_container.placed and (state.offset_y + (open_container.grid_y - 1) * state.grid_size) or open_container.y
    local cw = #open_container.def.shape[1] * state.grid_size
    local ch = #open_container.def.shape * state.grid_size

    if x >= cx and x <= cx + cw and y >= cy and y <= cy + ch then
        local gx, gy = containers_mod.pixel_to_container_grid(state.grid_size, { x = cx, y = cy }, x - state.held_offset_x, y - state.held_offset_y)

        local ok, reason = containers_mod.can_place_in_container(open_container, state.held_item, gx, gy, state.grid_size)
        if not ok then
            if reason == "occupied" then audio_mod.play_sfx("place_failed") end
            state.held_item = nil
            return false
        end

        state.held_item.in_container = open_container
        state.held_item.grid_x, state.held_item.grid_y = gx, gy
        state.held_item.placed = false
        state.held_item.x, state.held_item.y = nil, nil
        state.held_item.alpha = open_container.is_open and 1 or 0
        table.insert(open_container.contents, state.held_item)

        if state.held_item.def.container then
            state.held_item.is_open = false
            for _, sub in ipairs(state.held_item.contents) do sub.alpha = 0 end
        end

        audio_mod.play_sfx("place_item")
        if containers_mod.all_items_placed(state.items) then 
            audio_mod.play_sfx("level_win")
            state.game_state = "win" 
        end

        state.held_item = nil
        return true
    end
    return false
end

function input.handle_release_into_main(state, x, y)
    if not state.held_item or type(state.held_item) ~= "table" then return end

    local gx, gy = containers_mod.pixel_to_grid(state, x - state.held_offset_x, y - state.held_offset_y)
    local ok, reason = containers_mod.can_place(state, state.held_item, gx, gy)

    if ok then
        containers_mod.occupy_cells(state, state.held_item, gx, gy)
        audio_mod.play_sfx("place_item")

        if containers_mod.all_items_placed(state.items) then
            audio_mod.play_sfx("level_win")
            state.game_state = "win"
        end
    else
        state.held_item.x = state.offset_x + (gx - 1) * state.grid_size
        state.held_item.y = state.offset_y + (gy - 1) * state.grid_size
        state.held_item.placed = false
        state.held_item.grid_x, state.held_item.grid_y = nil, nil

        if reason == "occupied" then
            audio_mod.play_sfx("place_failed")
        end
    end

    state.held_item = nil
end

function input.handle_release(state, x, y)
    if input.handle_release_into_container(state, x, y) then
        return
    end
    input.handle_release_into_main(state, x, y)
end

return input