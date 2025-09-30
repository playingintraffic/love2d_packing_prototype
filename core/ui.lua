--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module ui
--- @description Handles all ui functions and drawing.

local ui = {}

function ui.refresh_screen_size(state)
    state.screen_w, state.screen_h = love.graphics.getDimensions()
end

return ui