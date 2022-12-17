PlayerIdleState = Class{_includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player
    --Animaçao Idle
    self.animation = Animation{
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)
    --Se primir as teclas de movimento
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walking')
    end   
    --Se primir o espaço
    if love.keyboard.isDown('space') then
        self.player:changeState('jump')
    end

    --Caso esteja parado e colidi com um enemigo
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end
end