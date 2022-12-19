PlayerJumpState = Class{_includes = BaseState}

function PlayerJumpState:init(player)
    self.player = player

    --Animaçao de salto
    self.animation = Animation{
        frames = {3},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerJumpState:enter(params)
    gSounds['jump']:play()
    self.player.dy = PLAYER_JUMP_VELOCITY
end

function PlayerJumpState:update(dt)
    self.player.currentAnimation:update(dt)

    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    --Mudar para o estado de queda quando atingir o maximo de altura
    if self.player.dy >= 0 then
        self.player:changeState('falling')
    end

    self.player.y = self.player.y + (self.player.dy * dt)

    --Vereficar tiles a colidir acima do player
    local tileTopLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y)--3 px para poder passar por zonas vazias
    local tileTopRight = self.player.map:pointToTile(self.player.x + self.play.width - 3, self.player.y)

    --Se colidirmos com algo acima, passar para o estado de queda de imediato
    if (tileTopLeft and tileTopRight) and (tileTopLeft:collidable() or tileTopRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('falling')
    elseif love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        self.player:checkLeftCollisions()
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        self.player:checkRightCollisions()
    end

    --Vereficar se colidimos com outro objeto
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then--Se o objeto a cima de nos for solido
                object.onCollide(object)

                self.player.y = object.y + object.height
                self.player.dy = 0
                self.player:changeState('falling')
            elseif object.consumable then--Caso seja um objeto consumivel
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            end
        end
    end

    --Vereficar se colidimos com alguma entidade(enemigo) que esteja acima do player
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end
end