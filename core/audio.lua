--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module audio
--- @description Handles loading and playing game audio.

--- @section Game Defs

local game_audio = require("data.audio")

--- @section Module

local audio = {}

audio.active_sfx = {}

--- @section Loading

function audio.preload(tbl)
    for k, v in pairs(tbl) do
        if type(v) == "table" and v.src then
            local path = v.src
            local kind = v.type or "static"
            v.source = love.audio.newSource(path, kind)
            if v.volume then
                v.source:setVolume(v.volume)
            end
        elseif type(v) == "string" then
            tbl[k] = love.audio.newSource(v, "stream")
        elseif type(v) == "table" then
            audio.preload(v)
        end
    end
end

--- @section Playing

function audio.play_game_music(which)
    if not which then return end

    for _, src in pairs(game_audio.music) do
        if type(src) == "userdata" and src:typeOf("Source") then
            src:stop()
        end
    end

    local track = game_audio.music[which]
    if track then
        track:setLooping(true)
        track:play()
    end
end

function audio.play_sfx(name)
    local s = game_audio.sfx[name]
    if not s or not s.source then return end
    local src = s.source:clone()
    if s.volume then src:setVolume(s.volume) end
    if s.pitch then src:setPitch(0.9 + love.math.random() * 0.2) end
    src:setLooping(s.loop or false)
    src:play()

    table.insert(audio.active_sfx, src)
end

function audio.update()
    for i = #audio.active_sfx, 1, -1 do
        if not audio.active_sfx[i]:isPlaying() then
            table.remove(audio.active_sfx, i)
        end
    end
end

return audio
