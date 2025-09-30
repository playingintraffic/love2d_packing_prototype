--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module containers
--- @description Handles all container functions.

local containers = {}

--- @section Helpers

local function validate_item(it)
    if not containers.is_stowed(it) then
        return false
    end

    if it.def.container and it.is_open then
        return false
    end

    for _, sub in ipairs(it.contents or {}) do
        if not validate_item(sub) then
            return false
        end
    end

    return true
end

--- @section API

function containers.init_main_container(state)
    state.main_container = {}
    for y=1,state.rows do
        state.main_container[y] = {}
        for x=1,state.cols do
            state.main_container[y][x] = nil
        end
    end
end

function containers.pixel_to_grid(state, x, y)
    local gx = math.floor((x - state.offset_x) / state.grid_size) + 1
    local gy = math.floor((y - state.offset_y) / state.grid_size) + 1
    return gx, gy
end

function containers.pixel_to_container_grid(grid_size, container, x, y)
    local gx = math.floor((x - container.x) / grid_size) + 1
    local gy = math.floor((y - container.y) / grid_size) + 1
    return gx, gy
end

function containers.occupy_cells(state, item, gx, gy)
    for y = 1, state.rows do 
        for x = 1, state.cols do
            if state.main_container[y][x] == item then state.main_container[y][x] = nil end
        end 
    end
    for j, row in ipairs(item.def.shape) do
        for i, cell in ipairs(row) do
            if cell == 1 then
                local x, y = gx + i - 1, gy + j - 1
                state.main_container[y][x] = item
            end
        end
    end
    item.placed = true
    item.grid_x, item.grid_y = gx, gy
end

function containers.release_from_grid(state, item)
    for y = 1, state.rows do 
        for x = 1, state.cols do
            if state.main_container[y][x] == item then state.main_container[y][x] = nil end
        end 
    end
    item.placed = false
    item.grid_x, item.grid_y = nil, nil
end

function containers.is_stowed(item)
    return (item.placed and item.grid_x and item.grid_y) or (item.in_container ~= nil)
end

function containers.all_items_placed(items)
    for _, it in ipairs(items) do
        if not validate_item(it) then
            return false
        end
    end
    return true
end

function containers.can_place(state, item, gx, gy)
    for j, row in ipairs(item.def.shape) do
        for i, cell in ipairs(row) do
            if cell == 1 then
                local x, y = gx + i - 1, gy + j - 1
                if x < 1 or y < 1 or x > state.cols or y > state.rows then
                    return false, "out_of_bounds"
                end
                if state.main_container[y][x] and state.main_container[y][x] ~= item then
                    return false, "occupied"
                end
            end
        end
    end
    return true
end

function containers.can_place_in_container(container, item, gx, gy, grid_size)
    for j, row in ipairs(item.def.shape) do
        for i, cell in ipairs(row) do
            if cell == 1 then
                local x, y = gx + i - 1, gy + j - 1
                if x < 1 or y < 1 or x > #container.def.shape[1] or y > #container.def.shape then
                    return false, "out_of_bounds"
                end
                for _, other in ipairs(container.contents) do
                    if other ~= item and other.grid_x and other.grid_y then
                        for jj, r2 in ipairs(other.def.shape) do
                            for ii, c2 in ipairs(r2) do
                                if c2 == 1 then
                                    local ox, oy = other.grid_x + ii - 1, other.grid_y + jj - 1
                                    if ox == x and oy == y then
                                        return false, "occupied"
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return true
end

function containers.close_recursive(container)
    if not (container and container.def and container.def.container) then return end
    container.is_open = false
    for _, sub in ipairs(container.contents or {}) do
        sub.alpha = 0
        if sub.def and sub.def.container then
            containers.close_recursive(sub)
        end
    end
end

function containers.get_open_container(items)
    for _, item in ipairs(items) do
        if item.def.container and item.is_open then
            return item
        end
    end
    return nil
end

function containers.remove_item(item)
    if item.in_container then
        local c = item.in_container
        for i = #c.contents, 1, -1 do
            if c.contents[i] == item then
                table.remove(c.contents, i)
                break
            end
        end
        item.in_container = nil
    end
end

return containers