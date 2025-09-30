--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module update
--- @description Handles update logic for hover + previews.

local containers_mod = require("core.containers")

local update = {}

function update.update_held_item_preview(state)
    local mx, my = love.mouse.getPosition()
    local gx, gy = containers_mod.pixel_to_grid(state, mx - state.held_offset_x, my - state.held_offset_y)
    state.preview_gx, state.preview_gy = gx, gy
    state.can_snap = containers_mod.can_place(state, state.held_item, gx, gy)
end

function update.update_hovered_container(state, mx, my)
    for _, c in ipairs(state.items) do
        if c.def.container then
            local cx = c.placed and (state.offset_x + (c.grid_x-1)*state.grid_size) or c.x or 0
            local cy = c.placed and (state.offset_y + (c.grid_y-1)*state.grid_size) or c.y or 0
            local cw = #c.def.shape[1] * state.grid_size
            local ch = #c.def.shape * state.grid_size

            if mx >= cx and mx <= cx + cw and my >= cy and my <= cy + ch then
                state.hovered_container = c
            end

            if c.is_open then
                for i = #c.contents, 1, -1 do
                    if c.contents[i].in_container ~= c then
                        table.remove(c.contents, i)
                    end
                end

                for _, sub in ipairs(c.contents) do
                    local w = #sub.def.shape[1] * state.grid_size
                    local h = #sub.def.shape * state.grid_size

                    local ix, iy
                    if sub.grid_x and sub.grid_y then
                        ix = cx + (sub.grid_x - 1) * state.grid_size
                        iy = cy + (sub.grid_y - 1) * state.grid_size
                    else
                        ix = cx + (sub.local_x or 0)
                        iy = cy + (sub.local_y or 0)
                    end

                    if ix and iy then
                        if mx >= ix and mx <= ix+w and my >= iy and my <= iy+h then
                            state.hovered_item = sub
                            return true
                        end
                    else
                        print("Skipped sub item (no coords):", sub.def.name)
                    end
                end
            end
        end
    end
    return false
end

function update.update_hovered_item(state, mx, my)
    for _, item in ipairs(state.items) do
        if not item.in_container then
            local w = #item.def.shape[1] * state.grid_size
            local h = #item.def.shape * state.grid_size
            local ix, iy

            if item.placed and item.grid_x and item.grid_y then
                ix = state.offset_x + (item.grid_x - 1) * state.grid_size
                iy = state.offset_y + (item.grid_y - 1) * state.grid_size
            else
                ix = item.x or 0
                iy = item.y or 0
            end

            if mx >= ix and mx <= ix+w and my >= iy and my <= iy+h then
                state.hovered_item = item
                break
            end
        end
    end
end

return update