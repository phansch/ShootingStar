-- More information can be found at https://love2d.org/wiki/Config_Files
function love.conf(t)
    -- author information
    t.title = "Shooting Star"
    t.author = "Philipp Hansch"
    t.version = "0.8.0"
    t.url = "http://phansch.net"

    -- display settings
    t.screen.width = 1440
    t.screen.height = 960
    t.screen.fullscreen = false
    t.screen.vsync = false
    t.screen.fsaa = 0 -- 0 to 16 (highest)

    -- module settings
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.physics = false
    t.modules.joystick = false

    -- development settings
    t.release = false
    t.console = false -- since we use sublime text, we don't need the attached console
    t.identity = nil
end