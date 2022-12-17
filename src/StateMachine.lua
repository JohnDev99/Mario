StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        enter = function() end,
        update = function() end,
        exit = function() end
    }

    self.states = states or {}
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])--Estado deve existir
    self.current:exit() --Sair do estado atual
    self.current = self.states[stateName]()--Novo estado passado
    self.current:enter(enterParams)--Iniciar novo estado
end

function StateMachine:update(dt)
    self.current:update(dt)--Update de estado atual
end

function StateMachine:render()
    self.current:render()--Renderizar
end