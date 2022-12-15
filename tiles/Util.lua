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