--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module levels
--- @description Handles setting levels for the game.

--- @section Game Defs

local game_audio = require("data.audio")
local game_levels = require("data.levels")

--- @section Game Modules

local containers_mod = require("core.containers")
local audio_mod = require("core.audio")

local levels = {}

--- @section Helpers

local function get_level(state, index)
    local level = game_levels[tonumber(index)]
    if not level then
        state.current_level_index = 1
        return game_levels[1]
    end
    state.current_level_index = tonumber(index)
    return level
end

local function setup_grid(state, level)
    state.cols = level.main_container.cols
    state.rows = level.main_container.rows

    state.main_container_w = state.cols * state.grid_size
    state.main_container_h = state.rows * state.grid_size

    state.offset_x = (state.screen_w - state.main_container_w) / 2
    state.offset_y = (state.screen_h - state.main_container_h) / 2

    containers_mod.init_main_container(state)
end

local function spawn_items(state, level)
    state.items = {}

    local grid = state.grid_size
    local cx, cy = state.offset_x, state.offset_y
    local cw, ch = state.main_container_w, state.main_container_h
    local screen_w, screen_h = state.screen_w, state.screen_h

    local bounds = {
        top = { x = grid, y = grid, w = screen_w - 2 * grid, h = cy - grid },
        bottom = { x = grid, y = cy + ch + grid, w = screen_w - 2 * grid, h = screen_h - (cy + ch + 2 * grid) },
        left = { x = grid, y = cy, w = cx - grid, h = ch },
        right = { x = cx + cw + grid, y = cy, w = screen_w - (cx + cw + 2 * grid), h = ch },
    }

    local directions = { "top", "bottom", "left", "right" }
    local dir_counts = { top = 0, bottom = 0, left = 0, right = 0 }

    for i = 1, #level.items do
        local dir = directions[((i - 1) % #directions) + 1]
        dir_counts[dir] = dir_counts[dir] + 1
    end

    local slots = {}

    for _, dir in ipairs(directions) do
        local area = bounds[dir]
        local count = dir_counts[dir]

        if count > 0 then
            local cells_x = math.floor(area.w / grid)
            local cells_y = math.floor(area.h / grid)

            local step_x = math.max(1, math.floor(cells_x / count))
            local step_y = math.max(1, math.floor(cells_y / count))

            local placed = 0
            for y = 0, cells_y - 1, step_y do
                for x = 0, cells_x - 1, step_x do
                    local sx = area.x + x * grid
                    local sy = area.y + y * grid
                    slots[#slots + 1] = { dir = dir, x = sx, y = sy, gx = x, gy = y }
                    placed = placed + 1
                    if placed >= count then break end
                end
                if placed >= count then break end
            end
        end
    end

    for i, def in ipairs(level.items) do
        local slot = slots[i]
        if slot then
            state.items[#state.items + 1] = {
                def = def,
                x = slot.x,
                y = slot.y,
                placed = false,
                is_open = false,
                contents = {},
                in_container = nil,
                alpha = 1
            }
        else
            state.items[#state.items + 1] = {
                def = def,
                x = state.screen_w / 2,
                y = state.screen_h / 2,
                placed = false,
                is_open = false,
                contents = {},
                in_container = nil,
                alpha = 1
            }
            print("No slot available for item '" .. (def.name or "unnamed") .. "', placed at center")
        end
    end

end

local function play_music(index)
    local key = "level_" .. tostring(index)
    if game_audio.music[key] then
        audio_mod.play_game_music(key)
    else
        audio_mod.play_game_music("level_1")
    end
end

--- @section API

function levels.load(state, index)
    state.screen_w, state.screen_h = love.graphics.getDimensions()

    local level = get_level(state, index)
    state.current_level = level

    setup_grid(state, level)
    spawn_items(state, level)
    play_music(state.current_level_index)
end

return levels