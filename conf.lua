--- @script conf
--- @description Standard Love2D config file: https://love2d.org/wiki/Config_Files

function love.conf(t)
    -- Identity / System
    t.identity = "packing_protoype"              -- The name of the save directory (string)
    t.appendidentity = false            -- Search files in source directory before save directory (boolean)
    t.version = "11.4"                  -- The LÖVE version this game was made for (string)
    t.console = false                    -- Attach a console (boolean, Windows only)
    t.accelerometerjoystick = false     -- Disabled (not for iOS/Android)
    t.externalstorage = false           -- True to save files to external storage on Android
    t.gammacorrect = false              -- Enable gamma-correct rendering (false here)

    -- Audio
    t.audio = {}
    t.audio.mic = false                 -- Request and use microphone (false)
    t.audio.mixwithsystem = false       -- Keep background music (not used)
    t.modules.audio = true              -- Disable audio module
    t.modules.sound = true              -- Disable sound module

    -- Window
    t.window.title = "Packing Prototype"     -- Window title (string)
    t.window.icon = nil                 -- Filepath to window icon (string)
    t.window.width = 640                -- Window width (number)
    t.window.height = 360               -- Window height (number)
    t.window.borderless = false         -- Border visuals (boolean)
    t.window.resizable = true           -- Window is user-resizable (boolean)
    t.window.minwidth = 320             -- Minimum window width (number)
    t.window.minheight = 160            -- Minimum window height (number)
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop" -- "desktop" or "exclusive" fullscreen (string)
    t.window.vsync = 0                  -- Vertical sync mode (number)
    t.window.msaa = 0                   -- Multisample antialiasing (number)
    t.window.depth = nil                -- Depth buffer bits (nil here)
    t.window.stencil = nil              -- Stencil buffer bits (nil here)
    t.window.display = 1                -- Index of monitor for window (number)
    t.window.highdpi = false            -- High-dpi mode on Retina displays (boolean)
    t.window.usedpiscale = true         -- DPI scaling when highdpi is enabled (boolean)
    t.window.x = nil                    -- Window X position
    t.window.y = nil                    -- Window Y position

    -- Modules
    t.modules.data = true               -- Enable the data module (boolean)
    t.modules.event = true              -- Enable the event module (boolean)
    t.modules.font = true               -- Enable the font module (boolean)
    t.modules.graphics = true           -- Enable the graphics module (boolean)
    t.modules.image = true              -- Disable image module (not used)
    t.modules.joystick = false          -- Disable joystick module (not used)
    t.modules.keyboard = true           -- Enable the keyboard module (boolean)
    t.modules.math = true               -- Enable the math module (boolean)
    t.modules.mouse = true              -- Enable the mouse module (boolean)
    t.modules.physics = false           -- Disable physics module (not used)
    t.modules.system = true             -- Enable the system module (boolean)
    t.modules.thread = false            -- Disable thread module (not used)
    t.modules.timer = true              -- Enable the timer module (boolean)
    t.modules.touch = false             -- Disable touch module (not used)
    t.modules.video = false             -- Disable video module (not used)
    t.modules.window = true             -- Enable the window module (boolean)
end
