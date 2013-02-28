-- Starting to collect useful functions.
-- Eventually will be converted to classes

-- Returns a point (hump.vector) on a circle's circumference
function getCirclePoint(center, angle, radius)
    local x = math.cos(angle) * radius + center.x;
    local y = math.sin(angle) * radius + center.y;
    return vector.new(x, y)
end

function drawArc(x, y, r, angle1, angle2, segments)
    local i = angle1
    local j = 0
    local step = math.pi*2 / segments

    while i < angle2 do
        j = angle2 - i < step and angle2 or i + step
        love.graphics.line(x + (math.cos(i) * r), y - (math.sin(i) * r), x + (math.cos(j) * r), y - (math.sin(j) * r))
        i = j
    end
end

function shakeCamera(length, intensity)
    local orig_x, orig_y = cam:pos()
    Timer.do_for(length, function()
            cam:lookAt(orig_x + math.random(-intensity,intensity), orig_y + math.random(-intensity,intensity))
        end, function()
        -- reset camera position
        cam:lookAt(orig_x, orig_y)
    end)
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end


-- HSV > RGB color conversion
-----------------------------
-- adapted from:
-- http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript
-----------------------------

function HSVtoRGB(h, s, v, a)

  local r, g, b

  local i = math.floor(h * 6)
  local f = h * 6 - i
  local p = v * (1 - s)
  local q = v * (1 - f * s)
  local t = v * (1 - (1 - f) * s)

  local switch = i % 6
  if switch == 0 then
    r = v g = t b = p
  elseif switch == 1 then
    r = q g = v b = p
  elseif switch == 2 then
    r = p g = v b = t
  elseif switch == 3 then
    r = p g = q b = v
  elseif switch == 4 then
    r = t g = p b = v
  elseif switch == 5 then
    r = v g = p b = q
  end

  return r,g,b,a

end

function lerp(a,b,k)
    return (a + (b - a)*k)
end

function lerp3(a, b, k)
    --lerp 2 table3's by k
    return {lerp(a[1], b[1], k ),
            lerp(a[2], b[2], k ),
            lerp(a[3], b[3], k )}
end

-- util for converting image red channel to alpha channel
function rgbtoa_map( x, y, r, g, b, a )
    --return 255,255,255,255-r
    return 255,255,255,r
end

function file_rgbtoa(file)
    local id = love.image.newImageData(file)
    id:mapPixel( rgbtoa_map )
    return love.graphics.newImage(id)
end

-- convert 0-1 colour values to 0-255
function to255( r, g, b, a )
    return r*255, g*255, b*255, a*255
end
