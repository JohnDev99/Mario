SnailChasingState = Class{_includes = BaseState}

function SnailChasingState:init(tilemap, player, snail)
    --Objeto snail, uma posiçao no meu mapa e um player que deve perseguir e dar dano
    self.tilemap = tilemap
    self.player = player
    self.snail = snail

    self.animation = Animation{
        framses = {49, 50},
        interval = 0.5
    }

    self.snail.currentAnimation = self.animation
end

function SnailChasingState:update(dt)
    self.snail.currentAnimation:update(dt)

    --Perseguir o player se a minha distancia for menor que 5 tiles
    local diffX = math.abs(self.player.x - self.snail.x)

    if diffX > 5 * TILE_SIZE then
        self.snail:changeState('moving')
    elseif self.player.x < self.snail.x then
        self.snail.direction = 'left'
        self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt

        --Parar se existir um pilar ou nao houver blocos por onde caminhar, reverter direçao
        local tileTopLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y + self.snail.height)

        if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or not tileBottomLeft:collidable()) then
            --Virar para a direita
            self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt
        end
    else
        self.snail.direction = 'right'
        self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt

        local tileTopRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y)
        local tileBottomRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y + self.snail.height)

        if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or not tileBottomRight:collidable()) then
            self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt
        end
    end
end