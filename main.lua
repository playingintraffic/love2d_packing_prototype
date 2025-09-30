--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @script main.lua
--- @description Handles main love functions, rest is through modules.

--- @section Data Defs

local game_audio = require("data.audio")
local game_levels = require("data.levels")

--- @section Game State

local state = require("core.state")

--- @section Game Modules

local audio_mod = require("core.audio")
local containers_mod = require("core.containers")
local levels_mod = require("core.levels")
local ui_mod = require("core.ui")
local draw_mod = require("core.draw")
local update_mod = require("core.update")
local input_mod = require("core.input")

--- @section Load

function love.load()
    love.window.setTitle("Packing Prototype")
    ui_mod.refresh_screen_size(state)
    audio_mod.preload(game_audio)
    if state.start_music_on_load then
        audio_mod.play_game_music("title")
    end
end

--- @section Draw

function love.draw()
    draw_mod.draw_background(state)
    draw_mod.draw_overlay(state)

    if state.game_state=="title" then
        return draw_mod.draw_title(state)
    elseif state.game_state=="win" then
        return draw_mod.draw_win(state)
    end

    draw_mod.draw_main_container(state)
    draw_mod.draw_containers(state)
    draw_mod.draw_items(state)
    draw_mod.draw_preview(state)
    draw_mod.draw_mute_icon(state)
    draw_mod.draw_help_icon(state)
    if state.show_help then
        draw_mod.draw_help_tooltip(state)
    end

    draw_mod.draw_held_item(state)
    draw_mod.draw_tooltip(state)

end

--- @section Update

function love.update(dt)
    if state.game_state == "play" and state.held_item then
        update_mod.update_held_item_preview(state)
    else
        state.preview_gx, state.preview_gy = nil, nil
    end

    if state.game_state == "play" and not state.held_item then
        state.hovered_item = nil
        state.hovered_container = nil
        local mx, my = love.mouse.getPosition()

        if not update_mod.update_hovered_container(state, mx, my) and not state.hovered_item then
            update_mod.update_hovered_item(state, mx, my)
        end
    end

    if state.help_icon then
        local mx, my = love.mouse.getPosition()
        local icon = state.help_icon
        state.show_help = mx >= icon.x and mx <= icon.x + icon.w and my >= icon.y and my <= icon.y + icon.h
    else
        state.show_help = false
    end

    audio_mod.update()
end

--- @section Inputs

function love.mousepressed(x, y, button)
    if button == 1 and state.mute_icon then
        local icon = state.mute_icon
        local inside_mute = x >= icon.x and x <= icon.x + icon.w and y >= icon.y and y <= icon.y + icon.h
        if inside_mute then
            state.music_muted = not state.music_muted
            love.audio.setVolume(state.music_muted and 0 or 1)
            return
        end
    end

    if button == 1 and state.game_state == "title" then
        input_mod.handle_title_click(state)
        return
    end

    if state.game_state == "win" then
        if input_mod.handle_win_click(state, x, y) then
            return
        end
    end

    if button == 1 and state.hovered_item then
        input_mod.handle_item_pickup(state, x, y, state.hovered_item)
        return
    end

    if button == 2 and (state.hovered_container or (state.hovered_item and state.hovered_item.def.container)) then
        local container = state.hovered_container or state.hovered_item
        input_mod.handle_container_toggle(state, container)
    end
end

function love.mousereleased(x, y, button)
    if state.game_state ~= "play" then return end
    if button == 1 and state.held_item then
        input_mod.handle_release(state, x, y)
    end
end

--- @section System

function love.resize(w,h)
    ui_mod.refresh_screen_size(state)
    if state.current_level_index then levels_mod.load(state, state.current_level_index) end
end