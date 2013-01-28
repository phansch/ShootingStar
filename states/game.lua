Gamestate.game = Gamestate.new()
local state = Gamestate.game

require '.classes.Player'
require '.classes.DeadZone'

function state:enter(previous)
    if previous == Gamestate.menu or previous == Gamestate.gameover then
        self:startGame()
    end
end

function state:startGame()
    -- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
    MapLoader.path = "maps/"

    -- Loads the map file and returns it
    map = MapLoader.load("map.tmx")

    cam:setBounds(window.width/2, 0, map.width*map.tileWidth - window.width/2, map.height*map.tileHeight)

    player = Player()
    player:load()

    deadZone = DeadZone()

    Timer.clear()

    love.mouse.setVisible(true)
end

function state:update(dt)
    player:update(dt)
    deadZone:update(dt)
end

function state:draw()
    cam:attach()

    --draw the map, based on the players position
    map:autoDrawRange(player.position.x, player.position.y, 0, 0)

    map:draw()
    player:draw()
    deadZone:draw()

    cam:detach()

    self:printDebug()
end

function state:printDebug()

    local tile = map.layers["map"]:get(math.ceil(window.mousePos.x/16)-1,math.ceil(window.mousePos.y/16)-1)
    local xcam, ycam = cam:pos()

    -- current tile the mouse is hovering voer
    if tile then
        love.graphics.print("Tile MouseOver: "..tile.id, 10, 10)
    end

    -- player position
    love.graphics.print("player.position: "..math.ceil((player.position.x/16))..":"..math.ceil((player.position.y/16)), 10, 30)

    --player velocity.x
    love.graphics.print("player.velocity.x: "..player.velocity.x, 10, 50)


    --print camera offset
    love.graphics.print("Cam offset: "..cam.offset.x.." / "..cam.offset.y, 10, 70)
end