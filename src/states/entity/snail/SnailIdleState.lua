SnailIdleState = Class{_includes = BaseState}

function SnailIdleState:init(tilemap, player, snail)
    self.tilemap = tilemap
    self.player = player
    self.snail = snail

    self.waitTimer = 0
    self.animation = Animation{
        frames = {51},
        interval = 1
    }
    self.snail.currentAnimation = self.animation
end

function SnailIdleState:enter(params)
    self.waitPeriod = params.waitPeriod
end

function SnailIdleState:update(dt)
    -- Transitar entre parado e a rondar
    if self.waitTimer < self.waitPeriod then
        self.waitTimer = self.waitTimer + dt
    else
        self.snail:changeState('moving')
    end
    --Veredicar a minha distancia ao player
    local diffX = math.abs(self.player.x - self.snail.x)
    if diffX < 5 * TILE_SIZE then
        self.snail:changeState('chasing')
    end
end