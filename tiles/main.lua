push = require 'push'

require 'Util'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

TILE_SIZE = 16

SKY = 2
GROUND = 1

CAMERA_SCROLL_SPEED = 40


function love.load()
    math.randomseed(os.time())

    love.window.setTitle('Tiles')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    mapTiles = {}

    tileSheet = love.graphics.newImage('tiles.png')
    tileQuads = GenerateTilesQuads(tileSheet, TILE_SIZE, TILE_SIZE)

    --Tamanho do mapa
    mapWidth = 20
    mapHeight = 20

    bgRed = math.random(255) / 255
    bgGreen = math.random(255) / 255 
    bgBlue = math.random(255) / 255

    for y = 1, mapHeight do
        table.insert(mapTiles, {})
        for x = 1, mapWidth do
            table.insert(mapTiles[y], {
                id = y < 5 and SKY or GROUND
            })
        end
    end

    scroll = 0
            

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    if love.keyboard.isDown('left') then
        scroll = scroll - CAMERA_SCROLL_SPEED * dt
    elseif love.keyboard.isDown('right') then
        scroll = scroll + CAMERA_SCROLL_SPEED * dt
    end
end

function love.draw()
    push:start()

    love.graphics.translate(-math.floor(scroll), 0)
    love.graphics.clear(bgRed, bgGreen, bgBlue, 1)

    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local singleTile = mapTiles[y][x]
            love.graphics.draw(tileSheet, tileQuads[singleTile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
        end
    end
    push:finish()
end