window = {}
window.width = love.graphics.getWidth()
window.height = love.graphics.getHeight()
window.mousePos = nil
window.center = Vector(window.width/2, window.height/2)

game = {}
game.tilesize = 16
game.gravity = 200
game.jump_height = 300