PlayState = Class{_includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.level = LevelMaker.generate(100, 10)
    self.tilemap = self.level.tilemap
    --Fundo aleatorio
    self.background = math.random(3)
    self.backgroundX = 0

    --Inicio do nivel
    self.gravityOn = true
    self.gravityAmount = 6

    self.player = Player({
        x = 0, y = 0, width = 16, height = 20, texture = 'green-alien',
        stateMachine = StateMachine{
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
        map = self.tilemap,
        level = self.level
    })

    --Instanciar enemigos 
    self.spawEnemies()
    --Iniciar player no ar
    self.player:changeState('falling')
end

function PlayState:update(dt)
    Timer.update(dt)

    self.level.clear()

    self.player:update(dt)
    self.level:update(dt)
    --Atualizar posiçao da camera
    self.updateCamera()

    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tilemap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tilemap.width - self.player.width
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 
    gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
    gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)

    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.level:render()
    self.player:render()
    love.graphics.pop()

    --Pontuaçao
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(self.player.score), 4, 4)
end

function PlayState:updateCamera()
    --Posiçao da camera nao deve passar dos limites laterais co nivel nem dos Verticais
    self.camX = math.max(0, math.min(TILE_SIZE * self.tilemap.width - VIRTUAL_WIDTH, 
    self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    --Fundo move a 1/3 da velocidade da camera
    self.backgroundX = (self.camX / 3) % 256
end

function PlayState:spawEnemies()
    --Instanciar enemigos na extensao do mapa
    for x = 1, self.tilemap.width do

        --Instanciar enemigos no chao
        local groundFound = false

        for y = 1, self.tilemap.height do
            if not groundFound then--Se nao encontrei chao
                if self.tilemap.tiles[y][x].id == TILE_ID_GROUND then--Pecorrer as colunas e linhas ate achar um tile GROUND
                    groundFound = true--Achei chao

                    if math.random(20) == 1 then--De 1 a 20 chance de instanciar um enemigo
                        --Instanciar enemigo
                        local snail
                        --Criaçao de instancia de snail
                        snail = Snail{
                            texture = 'creatures',
                            x = (x - 1) * TILE_SIZE, y = (y - 2) * TILE_SIZE + 2,
                            width = 16, height = 16,
                            stateMachine = StateMachine{
                                ['idle'] = function() return SnailIdleState(self.tilemap, self.player, snail) end,
                                ['moving'] = function() return SnailMovingState(self.tilemap, self.player, snail) end,
                                ['chasing'] = function() return SnailChasingState(self.tilemap, self.player, snail) end
                            }
                        }
                        --Iniciar snail(enemigo) no estado parado
                        snail:changeState('idle', {
                            wait = math.random(5)
                        })
                        --Inserir objeto na minha lista de entidades do nivel
                        table.insert(self.level.entities, snail)
                    end
                end
            end
        end
    end
end