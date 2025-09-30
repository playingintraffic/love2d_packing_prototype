--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module draw
--- @description Handles draw functions and uses UI module to add components.

--- @section Game Modules

local containers_mod = require("core.containers")

--- @section Module

local draw = {}

--- @section API

function draw.draw_background(state)
    local top = {0.95, 0.9, 0.85}
    local bottom = {0.7, 0.8, 0.9}
    for i = 0, state.screen_h - 1 do
        local t = i / state.screen_h
        love.graphics.setColor(top[1] * (1 - t) + bottom[1] * t, top[2] * (1 - t) + bottom[2] * t, top[3] * (1 - t) + bottom[3] * t)
        love.graphics.rectangle("fill", 0, i, state.screen_w, 1)
    end
end

function draw.draw_overlay(state)
    local sw, sh = state.screen_w, state.screen_h

    if state.show_version_text then
        local version_text = "ALPHA V0.1.0"
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.print(version_text, 7, sh - 19)
        love.graphics.setColor(1, 1, 1, 0.9)
        love.graphics.print(version_text, 6, sh - 20)
    end

    if state.show_fps then
        local fps = love.timer.getFPS()
        local fps_text = "FPS: " .. fps
        local colour = (fps > 50 and {0, 1, 0}) or (fps > 30 and {1, 1, 0}) or {1, 0, 0}
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.print(fps_text, 7, sh - 34)
        love.graphics.setColor(colour)
        love.graphics.print(fps_text, 6, sh - 35)
    end

end

function draw.draw_title(state)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.printf("Packing Prototype", 0, state.screen_h / 2 - 40, state.screen_w, "center")
    love.graphics.printf("Click to Start", 0, state.screen_h / 2 + 20, state.screen_w, "center")
    draw.draw_mute_icon(state)
end

function draw.draw_win(state)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.printf("You Win!", 0, state.screen_h / 2 - 60, state.screen_w, "center")

    local bw, bh = 120, 40
    local bx1, by1 = (state.screen_w - bw) / 2, state.screen_h / 2
    local bx2, by2 = (state.screen_w - bw) / 2, state.screen_h / 2 + 60

    love.graphics.setColor(0.3, 0.7, 0.3)
    love.graphics.rectangle("fill", bx1, by1, bw, bh)
    love.graphics.setColor(1,1,1)
    love.graphics.printf("Next Level", bx1, by1 + 10, bw, "center")

    love.graphics.setColor(0.7, 0.3, 0.3)
    love.graphics.rectangle("fill", bx2, by2, bw, bh)
    love.graphics.setColor(1,1,1)
    love.graphics.printf("Quit", bx2, by2 + 10, bw, "center")
end

function draw.draw_main_container(state)
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("line", state.offset_x, state.offset_y, state.main_container_w, state.main_container_h)
    for y = 1, state.rows do
        for x = 1, state.cols do
            love.graphics.rectangle("line", state.offset_x + (x - 1) * state.grid_size, state.offset_y + (y - 1) * state.grid_size, state.grid_size, state.grid_size)
        end
    end
end

function draw.draw_shape(state, item, x, y)
    local colour = { item.def.colour[1], item.def.colour[2], item.def.colour[3], item.alpha or 1 }
    if item.def.container and item.is_open then
        colour = { colour[1] * 0.6 + 0.4, colour[2] * 0.6 + 0.4, colour[3] * 0.6 + 0.4, colour[4] }
    end
    love.graphics.setColor(colour)
    for j, row in ipairs(item.def.shape) do
        for i, cell in ipairs(row) do
            if cell == 1 then
                local cx = x + (i - 1) * state.grid_size
                local cy = y + (j - 1) * state.grid_size
                love.graphics.rectangle("fill", cx, cy, state.grid_size, state.grid_size)
                love.graphics.setColor(0, 0, 0, colour[4])
                love.graphics.rectangle("line", cx, cy, state.grid_size, state.grid_size)
                love.graphics.setColor(colour)
            end
        end
    end
end

function draw.draw_container_recursive(state, container, base_x, base_y)
    if not base_x or not base_y then return end

    draw.draw_shape(state, container, base_x, base_y)

    if container.is_open and container.contents then
        for _, sub in ipairs(container.contents) do
            if sub.alpha > 0 then
                local sub_x, sub_y

                if sub.grid_x and sub.grid_y then
                    sub_x = base_x + (sub.grid_x - 1) * state.grid_size
                    sub_y = base_y + (sub.grid_y - 1) * state.grid_size
                elseif sub.local_x and sub.local_y then
                    sub_x = base_x + sub.local_x
                    sub_y = base_y + sub.local_y
                end

                if sub_x and sub_y then
                    draw.draw_shape(state, sub, sub_x, sub_y)

                    if sub.def.container then
                        draw.draw_container_recursive(state, sub, sub_x, sub_y)
                    end
                end
            end
        end
    end
end

function draw.draw_containers(state)
    for _, c in ipairs(state.items) do
        if c.def.container then
            local cx = c.placed and (state.offset_x + (c.grid_x - 1) * state.grid_size) or c.x
            local cy = c.placed and (state.offset_y + (c.grid_y - 1) * state.grid_size) or c.y
            if cx and cy then
                draw.draw_container_recursive(state, c, cx, cy)
            end
        end
    end
end

function draw.draw_items(state)
    for _,it in ipairs(state.items) do
        if not it.def.container and not it.in_container then
            if it.placed then
                draw.draw_shape(state, it, state.offset_x + (it.grid_x - 1) * state.grid_size, state.offset_y + (it.grid_y - 1) * state.grid_size)
            else
                draw.draw_shape(state, it, it.x, it.y)
            end
        end
    end
end

function draw.draw_preview(state)
    if state.preview_gx and state.preview_gy and state.held_item then
        local px = state.offset_x + (state.preview_gx - 1) * state.grid_size
        local py = state.offset_y + (state.preview_gy - 1) * state.grid_size
        love.graphics.setColor(state.can_snap and { 0, 1, 0, 0.3 } or { 1, 0, 0, 0.3 })
        local w = #state.held_item.def.shape[1] * state.grid_size
        local h = #state.held_item.def.shape * state.grid_size
        love.graphics.rectangle("fill", px, py, w, h)
    end
end

function draw.draw_held_item(state)
    if state.held_item then
        local mx,my = love.mouse.getPosition()
        local open_container = containers_mod.get_open_container(state.items)

        local gx, gy
        if open_container then
            local cx = open_container.placed and (state.offset_x + (open_container.grid_x - 1) * state.grid_size) or open_container.x
            local cy = open_container.placed and (state.offset_y + (open_container.grid_y - 1) * state.grid_size) or open_container.y

            gx, gy = containers_mod.pixel_to_container_grid(state.grid_size, { x = cx, y = cy }, mx - state.held_offset_x, my - state.held_offset_y )
            local px = cx + (gx - 1) * state.grid_size
            local py = cy + (gy - 1) * state.grid_size
            draw.draw_shape(state, state.held_item, px, py)
        else
            gx, gy = containers_mod.pixel_to_grid(state, mx - state.held_offset_x, my - state.held_offset_y)
            local px = state.offset_x + (gx - 1) * state.grid_size
            local py = state.offset_y + (gy - 1) * state.grid_size
            draw.draw_shape(state, state.held_item, px, py)
        end
    end
end

function draw.draw_tooltip(state)
    if state.hovered_item and not state.held_item then
        local mx,my = love.mouse.getPosition()
        local text = "Left Click to pick up"

        if state.hovered_item.def.container then
            text = text .. (state.hovered_item.is_open and "\nRight Click to close" or "\nRight Click to open")
        end

        if state.hovered_item.in_container and state.hovered_item.in_container.is_open then
            local c = state.hovered_item.in_container
            text = text .. (c.is_open and "\nRight Click to close container" or "\nRight Click to open container")
        end

        local lines, tw, font = {}, 0, love.graphics.getFont()
        for line in text:gmatch("[^\n]+") do
            table.insert(lines, line)
            local lw = font:getWidth(line)
            if lw > tw then tw = lw end
        end
        local lh, pad = font:getHeight(), 6
        local th = lh * #lines
        local bx, by = mx + 12, my + 12
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", bx, by, tw + pad * 2, th + pad * 2)
        love.graphics.setColor(1,1,1)
        for i,line in ipairs(lines) do
            love.graphics.print(line, bx + pad, by + pad + (i - 1) * lh)
        end
    end
end

function draw.draw_help_icon(state)
    local w, h = 24, 24
    local bx, by = 5 + 90 + 8, 5
    state.help_icon = {x = bx, y = by, w = w, h = h}

    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", bx, by, w, h, 3, 3)

    love.graphics.setColor(1, 1, 1, 1)
    local font = love.graphics.getFont()
    local tw = font:getWidth("?")
    local th = font:getHeight()
    love.graphics.print("?", bx + (w - tw)/2, by + (h - th)/2)
end

function draw.draw_help_tooltip(state)
    if not state.help_icon then return end

    local mx, my = love.mouse.getPosition()
    local icon = state.help_icon
    local hovering = mx >= icon.x and mx <= icon.x + icon.w and my >= icon.y and my <= icon.y + icon.h

    if not hovering then return end

    local lines = {
        "How to play:",
        "- Drag and fit all shapes into the grid.",
        "- Some shapes are 'containers', they can hold other shapes inside.",
        "- Click RMB to open/close containers.",
        "- Only one container can be open at a time.",
        "- All containers must be closed to trigger win condition.",
        "",
        "Note: This is a prototype.. obviously xD.",
        "Item placing can be a little wonky but it works :)",
        "",
        "Relax, take your time, and enjoy!",
        "Thanks for playing!"
    }

    local font = love.graphics.getFont()
    local lh, pad = font:getHeight(), 10

    local box_w = 0
    for _, line in ipairs(lines) do
        local lw = font:getWidth(line)
        if lw > box_w then box_w = lw end
    end
    box_w = box_w + pad * 2
    local box_h = #lines * lh + pad * 2

    local bx = icon.x + icon.w + 8
    local by = icon.y

    love.graphics.setColor(0, 0, 0, 0.75)
    love.graphics.rectangle("fill", bx, by, box_w, box_h, 4, 4)

    love.graphics.setColor(1, 1, 1, 1)
    for i, line in ipairs(lines) do
        love.graphics.print(line, bx + pad, by + pad + (i - 1) * lh)
    end
end

function draw.draw_mute_icon(state)
    local w, h = 90, 24
    local bx, by = 5, 5
    state.mute_icon = {x = bx, y = by, w = w, h = h}

    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", bx, by, w, h, 3, 3)

    love.graphics.setColor(1, 1, 1, 1)
    local font = love.graphics.getFont()
    local label = state.music_muted and "Audio: Off" or "Audio: On"
    local tw = font:getWidth(label)
    local th = font:getHeight()
    love.graphics.print(label, bx + (w - tw)/2, by + (h - th)/2)
end

return draw