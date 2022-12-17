PlayerWalkState = Class{_includes = BaseState}

function PlayerWalkState:init(player)
    self.player = player
    --Animaçao de caminhar
    self.animation = Animation{
        frames = {10, 11},
        interval = 0.1
    }

    self.player.currentAnimation = self.animation
end

function PlayerWalkState:update(dt)
    self.player.currentAnimation:update(dt)

    --Vereficar se eu nao estou a primir as teclas de movimento
    if not love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('idle')
    else
        local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
        local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

        --Temporariamente mudar o y do player para testar objetos abaixo do personagem
        self.player.y = self.player.y + 1

        local collidedObjects = self.player:checkObjectsCollisions()

        self.player.y = self.player.y - 1

        --Vereficar se existe tiles a colidir de baixo do plyer
        if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
            self.player.dy = 0
            self.playe:changeState('falling')
        elseif love.keyboard.isDown('left') then
            self.player.direction = 'left'
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
            self.player:checkLeftCollisions(dt)
        elseif love.keyboard.isDown('right') then
            self.player.direction = 'right'
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
            self.player:checkRightCollisions(dt)
        end
    end

    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end
end
