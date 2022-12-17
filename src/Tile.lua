Tile = Class{}

--Construtor de cada Tile
function Tile:init(x, y, id, topper, tileset, topperset)
    --Posiçao do tile
    self.x = x
    self.y = y
    --Tamanho de cada tile 16x16
    self.width = TILE_SIZE
    self.height = TILE_SIZE

    self.id = id
    self.topper = topper
    self.tileset = tileset
    self.topperset = topperSet
end

function Tile:collidable(target)
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end
    return false 
end

function Tile:render()
    love.graphics.draw(gTextures['tiles'], gFrames['tilesets'][self.tileset][self.id],
    (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)

    if self.topper then
        love.graphics.draw(gTextures['toppers'], gFrames['toppersets'][self.topperset][self.id],
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
    end
end