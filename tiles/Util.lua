function GenerateTilesQuads(atlas, width, height)
    local spriteWidth = atlas:getWidth() / width
    local spriteHeight = atlas:getHeight() / height

    local counter = 1
    local tiles = {}

    for y = 0, spriteHeight - 1 do
        for x = 0, spriteWidth - 1 do
            tiles[counter] = love.graphics.newQuad(x * width, y * height, width, height,
            atlas:getDimensions())
            counter = counter + 1
        end
    end

    return tiles
end

function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tileSets = {}
    local counter = 0
    local sheetWidth = setsX * sizeX
    local sheetHeight = setsY * sizeY

    for tileSetY = 1, setsY do
        for tileSetX = 1, setsX do
            table.insert(tileSets, {})
            counter = counter + 1
            for y = sizeY * (tileSetY - 1) + 1, sizeY * (tileSetY - 1) + 1 + sizeY do
                for x = sizeX * (tileSetX - 1) + 1, sizeX * (tileSetX - 1) + 1 + sizeX do
                    table.insert(tileSets[counter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end
    return tileSets
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
