-- This is the area where the camera stops tracking the player

Class = require ".libraries.hump.class"

DeadZone = Class{
    init = function(self)
        self.color = {0, 0, 255, 50}
        self.position = Vector(20, 20)
        self.width = player.width * 20
        self.height = player.height * 11
        self.visible = false
    end
}

function DeadZone:update(dt)
    if player.position.x + player.width >= self.position.x + self.width then
        self.position.x = player.position.x + player.width - self.width
        if (math.abs(player.velocity.x) > 0) then
            cam.offset.x = cam.offset.x + (math.abs(player.velocity.x * 1000) * dt)
            if cam.offset.x > cam.maxOffset.x then cam.offset.x = cam.maxOffset.x end
        end
    end
    if (player.position.x <= self.position.x) then
        self.position.x = player.position.x
        if (math.abs(player.velocity.x) > 0) then
            cam.offset.x = cam.offset.x - (math.abs(player.velocity.x) * dt)
            if cam.offset.x < -cam.maxOffset.x then cam.offset.x = -cam.maxOffset.x end
        end
    end

    if (player.position.y <= self.position.y) then
        self.position.y = player.position.y
    end
    if (player.position.y + player.height >= self.position.y + self.height) then
        self.position.y = player.position.y + player.height - self.height
    end

    local camX = (self.position.x + self.width/2 - window.width/2) + (cam.offset.x)
    local camY = (self.position.y + (2 * self.height/3) - window.height/2 + self.height/3 + 16) + (cam.offset.y)
    cam:lookAt(camX,camY)
end

function DeadZone:draw()
    if self.visible then
        love.graphics.setColor(self.color)
        love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)
        love.graphics.setColor(255, 255, 255)
    end
end

-- Used for debugging
function DeadZone:setVisible(boolean)
    self.visible = boolean
end