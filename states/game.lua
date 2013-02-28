game = {}
game.tilesize = 16
game.gravity = 200
game.jump_height = 300

require '.classes.Player'
require '.classes.DeadZone'
require ".graphics.pixeleffects"

function game:enter(previous)
    if previous == menu or previous == gameover then
        self:startGame()
    end
end

function game:startGame()
    -- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
    MapLoader.path = "maps/"

    -- Loads the map file and returns it
    map = MapLoader.load("map.tmx")

    cam:setBounds(window.width/2, 0, map.width*map.tileWidth - window.width/2, map.height*map.tileHeight)

    player = Player()
    player:load()

    deadZone = DeadZone()
    deadZone:setVisible(false)

    Timer.clear()

    love.mouse.setVisible(true)

    canvasdisplay = "result"
    bgcanvas = love.graphics.newCanvas()
    rayscanvas = love.graphics.newCanvas(window.width/2, window.height/2)

    -- pixeleffect parameters
    pe_exposure = 0.7--1
    pe_decay = 0.8
    pe_density = 0.4--1
    pe_weight = 0.29--0.1
    pe_lightPositionOnScreen = {0.5,0.5}
    pe_NUM_SAMPLES = 70--100
end

function game:update(dt)
    player:update(dt)
    deadZone:update(dt)
end

function game:draw()
    -- reset and clear
    love.graphics.reset()
    love.graphics.setPixelEffect()
    bgcanvas:clear()
    rayscanvas:clear()


    -- draw to the skycanvas
    love.graphics.setCanvas(bgcanvas)

    cam:attach()
    --draw the map, based on the players position
    map:autoDrawRange(player.position.x, player.position.y, 0, 0)

    map:draw()

    player:draw()

    deadZone:draw()
    cam:detach()

    -- draw 'sun' at mouse pos
    love.graphics.setColor(255,255,255,0)
    sinm = math.sin( globaltime * 60 )
    sunr = 20 + sinm * 0.75 -- add some life to the sun's size
    love.graphics.circle( "fill", window.mousePos.x, window.mousePos.y, sunr + 0.5, 64)
    love.graphics.circle( "line", window.mousePos.x, window.mousePos.y, sunr, 64)

    -- this is where the pixeleffect is engaged ..
    -- draw bgcanvas into rayscanvas, using the pixeleffect
    love.graphics.setColor(255,255,255,255)

    -- set the rayscanvas to recieve the draw
    love.graphics.setCanvas( rayscanvas )

    -- activate the rays pixeleffect
    love.graphics.setPixelEffect(fx.lightrays)

    -- send parameters to the pixeleffect
    -- (these should rather be in the keyboard events)
    fx.lightrays:send( "exposure", pe_exposure  )
    fx.lightrays:send( "decay", pe_decay )
    fx.lightrays:send( "density", pe_density + sinm * 0.02  )
    fx.lightrays:send( "weight", pe_weight  )
    fx.lightrays:send( "lightPositionOnScreen", {window.mousePos.x/window.width,1-window.mousePos.y/window.height}  )
    fx.lightrays:send( "NUM_SAMPLES", pe_NUM_SAMPLES  )

    -- draw the background, this draw command is where the pixeleffect is actually used
    -- the bg is drawn at half size because the rayscanvas is half window-resolution
    -- rayscanvas is finally drawn double sized to compensate
    -- love.graphics.draw( bgcanvas )
    love.graphics.draw( bgcanvas, 0, 0, 0, 0.5, 0.5 )
    -- reset the pixeleffect back to none.
    love.graphics.setPixelEffect()

    -- display according to canvasdisplay mode
    love.graphics.setCanvas()
    love.graphics.setColor(255,255,255,255)
    if canvasdisplay == "result" then
        -- this combines the whole effect
        -- draw the background canvas first ..
        love.graphics.draw(bgcanvas)

        -- then draw the rays canvas (the one with the pixeleffect)
        -- (draw rayscanvas twice for extra additive deluxeness)
        --love.graphics.setBlendMode("additive")
        love.graphics.draw(rayscanvas, 0, 0, 0, 2, 2)
        love.graphics.draw(rayscanvas, 0, 0, 0, 2, 2)
    end




    self:printDebug()
end

function game:printDebug()

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