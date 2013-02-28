Gamestate = require "libraries.hump.gamestate"
Signals = require "libraries.hump.signal"
Vector = require ".libraries.hump.vector"
Camera = require ".libraries.hump.camera"
Timer = require "libraries.hump.timer"
MapLoader = require ".libraries.AdvancedTiledLoader.Loader"
require "libraries.Helper"
require "states.game"
require "states.menu"
require "globals"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)

    cam = Camera()
end

function love.update(dt)
    globaltime = globaltime + dt
    Timer.update(dt)
    window.mousePos = Vector(love.mouse.getX(), love.mouse.getY())
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end