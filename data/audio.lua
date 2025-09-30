--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module data.audio
--- @description Handles static defs for game audio used.

return {

    --- @section Music Definitions
    --- Background music tracks for the game.
    --- 
    --- Add more by extending this table. All files must be placed in `assets/audio/music/`.
    --- Music tracks are loaded using `love.audio.newSource(path, "stream")`
    --- See: https://love2d.org/wiki/love.audio.newSource
    music = {
        title = "assets/audio/music/title.mp3",
        level_1 = "assets/audio/music/level_1.mp3"
    },

    --- @section Sound Effects
    --- One-shot sound effects used in gameplay.
    ---
    --- SFX are loaded via `love.audio.newSource(path, "static")`, then cloned for playback.
    --- Fields:
    --- - `type`: "static" (for short SFX)
    --- - `src`: Path to audio file
    --- - `volume`: Number (0.0–1.0), optional
    --- - `loop`: Boolean, should the sound loop?
    --- - `pitch`: Boolean, if true, applies slight pitch variation
    ---
    --- See: https://love2d.org/wiki/Source
    sfx = { 
        place_item = {
            type = "static",
            src = "assets/audio/sfx/place_item.mp3",
            volume = 0.7,
            loop = false,
            pitch = true
        },
        place_failed = {
            type = "static",
            src = "assets/audio/sfx/place_failed.mp3",
            volume = 0.7,
            loop = false,
            pitch = true
        },
        level_win = {
            type = "static",
            src = "assets/audio/sfx/level_win.mp3",
            volume = 0.7,
            loop = false,
            pitch = true
        }
    }
}