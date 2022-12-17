require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())

    love.window.setTitle('Tiles')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    tileSheet = love.graphics.newImage('graphics/full_tiles.png')
    tileQuads = GenerateTilesQuads(tileSheet, TILE_SIZE, TILE_SIZE)

    tooperSheet = love.graphics.newImage('graphics/tile_tops.png')
    tooperQuads = GenerateTilesQuads(tooperSheet, TILE_SIZE, TILE_SIZE)

    tileSets = GenerateTileSets(tileQuads, TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)
    tooperSets = GenerateTileSets(tooperQuads, TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

    tileset = math.random(#tileSets)
    topperSet = math.random(#tooperSets)

    --Tamanho do mapa
    mapWidth = 50
    mapHeight = 20

    bgRed = math.random(255) / 255
    bgGreen = math.random(255) / 255 
    bgBlue = math.random(255) / 255

    --GERAR NIVEL
    mapTiles = generateLevel()

    scroll = 0
           
    characterSprite = love.graphics.newImage('graphics/character.png')
    characterQuads = GenerateTilesQuads(characterSprite, CHARACTER_WIDTH, CHARACTER_HEIGHT)

    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    characterY = ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT

    direction = 'right'

    characterDy = 0

    --Animaçoes do personagem
    idleAnimation = Animation{
        frames = {1},
        interval = 1
    }
    moveAnimation = Animation{
        frames = {10, 11},
        interval = 0.2
    }
    jumpAnimation = Animation{
        frames = {3},
        interval = 1
    }
    currentAnimation = idleAnimation

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' and characterDy == 0 then
        characterDy = CHARACTER_JUMP_VELOCITY
        currentAnimation = jumpAnimation
    end

    if key == 'r' then --identalao
        tileset = math.random(#tileSets)
        topperSet = math.random(#tooperSets)
    end
end

function love.update(dt)

    --Aplicar força do salto ao personagem
    characterDy = characterDy + GRAVITY 
    characterY = characterY + characterDy * dt

    --Colisao de forma manual
    if characterY > (6 * TILE_SIZE) - CHARACTER_HEIGHT then
        characterY = (6 * TILE_SIZE) - CHARACTER_HEIGHT
        characterDy = 0
    end


    currentAnimation:update(dt)

    if love.keyboard.isDown('left') then
        characterX = characterX - CHARACTER_MOVE_SPEED * dt
        if characterDy == 0 then
            currentAnimation = moveAnimation
        end
        direction = 'left'
    elseif love.keyboard.isDown('right') then
        characterX = characterX + CHARACTER_MOVE_SPEED * dt
        if characterDy == 0 then
            currentAnimation = moveAnimation
        end
        direction = 'right'
    else
        currentAnimation = idleAnimation
    end

    scroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)
end

function love.draw()
    push:start()

    love.graphics.translate(-math.floor(scroll), 0)
    love.graphics.clear(bgRed, bgGreen, bgBlue, 1)

    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local singleTile = mapTiles[y][x]
            love.graphics.draw(tileSheet, tileSets[tileset][singleTile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)

            if singleTile.topper then
                love.graphics.draw(tooperSheet, tooperSets[topperSet][singleTile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
            
        end
    end

    --Desenhar personagem
    love.graphics.draw(characterSprite, characterQuads[currentAnimation:getCurrentFrame()],
     math.floor(characterX) + CHARACTER_WIDTH / 2, math.floor(characterY) + CHARACTER_HEIGHT / 2,
     0, direction == 'left' and -1 or 1, 1, CHARACTER_WIDTH / 2, CHARACTER_HEIGHT / 2)

    push:finish()
end

function generateLevel()
    local tiles = {}


    for y = 1, mapHeight do
        table.insert(tiles, {})
        for x = 1, mapWidth do
            table.insert(tiles[y], {
                id = SKY,
                topper = false
            })
        end
    end

    for x = 1, mapWidth do--Por cada coluna em x
        if math.random(7) == 1 then--se tirar o valor 1
            goto continue--saltar uma coluna
        end

        --Criar pilar aleatorio
        local spawnPillar = math.random(5) == 1 --Se gerar o valor 1 na iteraçao
        if spawnPillar then--se gerei o valor 1
            for pillar = 4, 6 do--alem dos tiles do chao vou gerar mais dois acima
                tiles[pillar][x] = {
                    id = GROUND,
                    topper = pillar == 4 and true or false--O primeiro tile do pilar reebe um topper
                }
            end
        end

        --Gerar o resto do chao
        for ground = 7, mapHeight do
            tiles[ground][x] = {
                id = GROUND,
                --se nao for uma coluna de pilar, for chao e o tile for na posiçao 7 gerar um topper
                topper = (not spawnPillar and ground == 7) and true or false
            }
        end
        ::continue::--bloco continue em C#
    end
    return tiles
end