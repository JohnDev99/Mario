BaseState = Class{}

--Todos os estados vao implementar as assinaturas destas funçoes
function BaseState:init() end
function BaseState:enter() end
function BaseState:update(dt) end
function BaseState:render() end
function BaseState:exit() end