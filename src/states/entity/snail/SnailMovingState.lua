SnailMovingState = Class{_includes = BaseState}

function SnailMovingState:init(tilemap, player, snail)
    self.tilemap = tilemap
    self.player = player
    self.snail = snail

    self.animation = Animation{
        frames = {49, 50},
        interval = 0.2
    }

    self.snail.currentAnimation = self.animation

    self.snail.movingDirection = math.random(2) == 1 and 'left' or 'right' --Alternar a minha diraçao(imprevisivel)
    self.snail.direction = self.snail.movingDirection --a minha direçao
    self.movingDuration = math.random(5) --Vou mover entre direçoes num espaço de tempo entre 1 a 5
    self.movingTimer = 0
end

function SnailMovingState:update(dt)
    self.movingTimer = self.movingTimer + dt
    self.snail.currentAnimation:update(dt)

    if self.movingTimer > self.movingDuration then
        --Chance de parar em Idle
        if math.random(4) == 1 then
            self.snail.changeState('idle', {
                wait = math.random(5)
            })
        else
            self.snail.movingDirection = math.random(2) == 1 and 'left' or 'right' --Alternar a minha diraçao(imprevisivel)
            self.snail.direction = self.snail.movingDirection --a minha direçao
            self.movingDuration = math.random(5) --Vou mover entre direçoes num espaço de tempo entre 1 a 5
            self.movingTimer = 0
        end
    elseif self.snail.direction == 'left' then
        --Mover para a esquerda
        self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt
        --Vereficar se existe tiles no topo e fundo esquerdo
        local tileTopLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y + self.snail.height)
        if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or not tileBottomLeft:collidable()) then
            self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt

            self.snail.movingDirection = 'right'
            self.snail.direction = self.snail.movingDirection --a minha direçao
            self.movingDuration = math.random(5) --Vou mover entre direçoes num espaço de tempo entre 1 a 5
            self.movingTimer = 0
        end
    else
        self.snail.direction = 'right'
        self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt
        local tileTopRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y)
        local tileBottomRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y + self.snail.height)

        if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or not tileBottomRight:collidable()) then
            self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt

            self.snail.movingDirection = 'left'
            self.snail.direction = self.snail.movingDirection --a minha direçao
            self.movingDuration = math.random(5) --Vou mover entre direçoes num espaço de tempo entre 1 a 5
            self.movingTimer = 0
        end
    end

    local diffX = math.abs(self.player.x - self.snail.x)
    if diffX < 5 * TILE_SIZE then
        self.snail:changeState('chasing')
    end
end