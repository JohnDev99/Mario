Entity = Class{}

--Todas as entidades do jogo vao herdar desta classe

function Entity:init(def)
    --Posiçao
    self.x = def.x
    self.y = def.y
    --Velocidade 
    self.dx = def.dx
    self.dy = def.dy
    --Dimensoes 
    self.width = def.width
    self.height = def.height
    self.texture = def.texture
    --Maquina de estados
    self.stateMachine = def.stateMachine
    --Todas as entidades(enemigos) vao iniciar virados para a esquerda
    self.direction = 'left'
    --referencia para o mapa para vereficar as colisoes das entidades com os tiles
    self.map = def.map
    --Nivel do jogo(Pode ser gerados outros enemigos e objetos como pickups e powerUps largados pelas entidades)
    self.level = def.level
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)--Chamar a maquina de estados da entidade
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
    self.y > entity.y + entity.height or entity.y > self.y > self.y + self.height)
end

function Entity:render()
    love.graphics.draw(gTextures[self.texture][self.currentAnimation:getCurrentFrame()],
    math.floor(self.x) + 8, math.floor(self.y) + 10, 0, self.direction == 'right' and 1 or -1,
    1, 8, 10)
end