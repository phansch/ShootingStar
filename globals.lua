width, height, fullscreen, vsync, fsaa = love.graphics.getMode( )

window = {}
window.width = width
window.height = height
window.vsync = vsync
window.fullscreen = fullscreen
window.fsaa = fsaa
window.mousePos = nil
window.center = Vector(window.width/2, window.height/2)
window.bgColor = {to255( HSVtoRGB( 0.75, 0.3, 0.2, 1 ) ) }

globaltime = 0