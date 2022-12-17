LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileId = TILE_ID_GROUND--todos os tiles vao ser do tipo ground

    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    --Iniciar com colunas em branco
    for x = 1, height do
        table.insert(tiles, {})
    end

    --Gerar de coluna em coluna
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        for y = 1, 6 do
            table.insert(tiles[y],
            Tile(x, y, tileID, nil, tileset, topperset))
        end

        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y], 
                Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND
            --Jump block --comprimento onde o bloco(plataforma) vai ser colocado
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end
            --Chance de gerar um pilar
            if math.random(8) == 1 then
                blockHeight = 2 --pilar com 2 de altura
                --Chance de gerar pilar com arbusto no topo
                if math.random(8) == 1 then
                    table.insert(objects, GameObject{
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (y - 4) * TILE_SIZE,
                        width = 16, height = 16,
                        --Variedade na escolha de arbustos
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    })
                end

                --Tiles dos pilares 
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperSet)
                tiles[7][x].topper = nil

                --Chance de gerar arbustos no res do chao
            elseif math.random(8) == 1 then
                table.insert(object, GameObject{
                    texture = 'bushes',
                    x = (x - 1) * TILE_SIZE,
                    y = (6 - 1) * TILE_SIZE,
                    width = 16, height = 16,
                    frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                    collidable = false
                })
            end
            --Chance de gerar apenas um bloco para servir como plataforma
            if math.random(10) == 1 then
                table.insert(objects, GameObject{
                    texture = 'jump-blocks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16, height = 16,
                    frame = math.random(#JUMP_BLOCKS),
                    collidable = true,
                    hit = false,
                    solid = true, 
                    --Metodo de colisao
                    onCollide = function(obj)
                        if not obj.hit then
                            --Gerar uma gema(pickup)
                            if math.random(5) == 1 then
                                --Instanciar gema
                                local gem = GameObject{
                                    texture = 'gems',
                                    x = (x - 1) * TILE_SIZE,
                                    y = (blockHeight - 1) * TILE_SIZE - 4,
                                    width = 16, height = 16,
                                    frame = math.random(#GEMS),
                                    collidable = true,
                                    consumable = true,
                                    solid = false,
                                    onConsume = function(player, obj)
                                        gSounds['pickup']:play()
                                        player.score = player.score + 100
                                    end
                                }
                                --Movimento da gema saltar do bloco
                                Timer.tween(0.1, {
                                    [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                })
                                gSounds['powerup-reveal']:play()
                                table.insert(objects, gem)
                            end
                            obj.hit = true
                        end
                        gSounds['empty-block']:play()
                    end
                })
            end
        end
    end

    local map = Tilemap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end