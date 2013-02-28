Gamestate = require "libraries.hump.gamestate"
Signals = require "libraries.hump.signal"
Vector = require ".libraries.hump.vector"
Camera = require ".libraries.hump.camera"
Timer = require "libraries.hump.timer"
MapLoader = require ".libraries.AdvancedTiledLoader.Loader"
require "libraries.Helper"

--TODO: Move these somewhere else
window = {}
window.width = love.graphics.getWidth()
window.height = love.graphics.getHeight()
window.mousePos = nil
window.center = Vector(window.width/2, window.height/2)

tilesize = 16
gravity = 200
jump_height = 300

require "states.game"
require "states.menu"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)

    cam = Camera()
end

function love.update(dt)
    Timer.update(dt)
    window.mousePos = Vector(love.mouse.getX(), love.mouse.getY())
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end