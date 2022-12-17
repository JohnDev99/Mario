Player = Class{_includes = Entity}

function Player:init(def)
    Entity.init(self, def)--Herdar construtor base da classe
    self.score = 0
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:render()
    Entity.render(self)
end

function Player:checkLeftCollisions(dt)
    --Vereficar colisao com os 2 tiles de cima e de baixo lado esquerdo
    local tileTopLeft = self.map:pointToTile(self.x + 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)

    --coloque o jogador fora dos limites X em uma das peças para redefinir qualquer sobreposição
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        self.x = (tileTopLeft.x - 1) * TILE_SIZE + tileTopLeft.width - 1
    else
        self.y = self.y - 1
        local collidedObjects = self:checkObjectsCollisions()
        self.y = self.y + 1

        if #collidedObjects > 0 then
            self.x = self.x + PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkRightCollisions(dt)
    --Vereficar colisao com 2 tiles de cima e de baixo lado direito
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

    --
    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        self.x = (tileTopRight.x - 1) * TILE_SIZE - self.width
    else
        self.y = self.y - 1
        local collidedObjects = self.checkObjectsCollisions()
        self.y = self.y + 1

        if #collidedObjects > 0 then
            self.x = self.x -PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkObjectsCollisions()
    local collidedObjects = {}
    
    for k, object in pairs(self.level.objects) do--Objetos de cada cena
        if object:collides(self) then--Se o objeto colidiu com o player
            if object.solid then--SE for solido
                table.insert(collidedObjects, object)--Objeto com colisao
            elseif object.consumable then--CASO SEJA Consumivel vou remover objeto da cena
                object.onConsume(self)
                table.remove(self.level.objects, k)
            end
        end
    end

    --Retorna a minha lista de objetos com colisores
    return collidedObjects
end