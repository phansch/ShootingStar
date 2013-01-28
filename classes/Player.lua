Class = require ".libraries.hump.class"

Player = Class{function(self)
    self.respawnTime = 5
    self.enabled = true
    self.lives = 3
    self.width = tilesize
    self.height = tilesize

    self.position = Vector(20*16, 58*16)
    self.velocity = Vector(5, 0)
    self.jetpack_fuel = 0.5
    self.jetpack_fuel_max = 0.5
    self.maxVelocity = 5
end}

function Player:load()
    self.img = love.graphics.newImage("graphics/player.png")
    self.imgSize = Vector(self.img:getWidth(), self.img:getHeight())
end

function Player:update(dt)
    self:jump(dt)
    if love.keyboard.isDown("a") then
        if self.velocity.x < self.maxVelocity then
            self.velocity.x = self.velocity.x + 2 * dt
        end
        if self:canMove('left') then
            self.position.x = self.position.x - self.velocity.x
        end
    end
    if love.keyboard.isDown("d") then
        if self.velocity.x < self.maxVelocity then
            self.velocity.x = self.velocity.x + 2 * dt
        end
        if self:canMove('right') then
            self.position.x = self.position.x + self.velocity.x
        end
    end
end

function Player:draw()
    if self.enabled then
        love.graphics.draw(self.img, self.position:unpack())
    end
end

function Player:jump(dt)
    if self.jetpack_fuel > 0 and love.keyboard.isDown(" ") then
        self.jetpack_fuel = self.jetpack_fuel - dt -- decrease the fuel meter
        self.velocity.y = self.velocity.y + jump_height * (dt / self.jetpack_fuel_max)
    end
    if self.velocity.y ~= 0 then -- we're probably jumping
        if self:canMove('up') or self:canMove('down') then
            self.position.y = self.position.y - self.velocity.y * dt
            self.velocity.y = self.velocity.y - gravity * dt
            if not self:canMove('down') then
                self.jetpack_fuel = 0.5
                self.velocity.y = 0
            end
        end
    end
end

function Player:canMove(direction)
    -- get tiles around player
    local tile_right = map.layers["map"]:get(math.ceil(self.position.x/16), math.ceil(self.position.y/16))
    local tile_left = map.layers["map"]:get(math.ceil(self.position.x/16)-1, math.ceil(self.position.y/16))
    local tile_above = map.layers["map"]:get(math.ceil(self.position.x/16), math.ceil(self.position.y/16)-1)
    local tile_below = map.layers["map"]:get(math.ceil(self.position.x/16), math.ceil(self.position.y/16))

    --check possible directions
    if tile_right and direction == 'right' and tile_right.properties.solid then
        return false
    end

    if tile_left and direction == 'left' and tile_left.properties.solid then
        return false
    end

    if tile_above and direction == 'up' and tile_above.properties.solid then
        return false
    end

    if tile_below and direction == 'down' and tile_below.properties.solid then
        return false
    end

    return true
end