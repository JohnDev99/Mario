Animation = Class{}

function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.timer = 0
    self.currentFrame = 1
end

function Animation:update(dt)
    --Criar animaçao se o numero de frames for maior que 1
    if #self.frames > 1 then
        self.timer = self.timer + dt
        if self.timer > self.interval then
            self.timer = self.timer % self.interval
            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
        end
    end
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end