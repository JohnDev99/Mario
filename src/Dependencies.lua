push = require 'lib/push'
Class = require 'lib/class'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/Util'
require 'src/constants'
require 'src/Entity'
require 'src/GameLevel'
require 'src/GameObject'
require 'src/LevelMaker'
require 'src/Player'
require 'src/Snail'
require 'src/StateMachine'
require 'src/Tile'
require 'src/Tilemap'

--Estados
require 'src/states/BaseState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
--Player
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerWalkState'
--Snail
require 'src/states/entity/snail/SnailChasingState'
require 'src/states/entity/snail/SnailIdleState'
require 'src/states/entity/snail/SnailMovingState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['jump-blocks'] = love.graphics.newImage('graphics/jump_blocks.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['green-alien'] = love.graphics.newImage('graphics/green_alien.png'),
    ['creatures'] = love.graphics.newImage('graphics/creatures.png')
}

gFrames = {
    ['tiles'] = GenerateTilesQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['toppers'] = GenerateTilesQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
    ['bushes'] = GenerateTilesQuads(gTextures['bushes'], 16, 16),
    ['jump-blocks'] = GenerateTilesQuads(gTextures['jump-blocks'], 16, 16),
    ['gems'] = GenerateTilesQuads(gTextures['gems'], 16, 16),
    ['backgrounds'] = GenerateTilesQuads(gTextures['backgrounds'], 256, 128),
    ['green-alien'] = GenerateTilesQuads(gTextures['green-alien'], 16, 20),
    ['creatures'] = GenerateTilesQuads(gTextures['creatures'], 16, 16)
}

gFrames['tilesets'] = GenerateTileSets(gFrames['tiles'], TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)
gFrames['toppersets'] = GenerateTileSets(gFrames['toppers'], TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}

gSounds = {
    ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
    ['empty-block'] = love.audio.newSource('sounds/empty-block.wav', 'static'),
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['kill'] = love.audio.newSource('sounds/kill.wav', 'static'),
    ['kill2'] = love.audio.newSource('sounds/kill2.wav', 'static'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/music.wav', 'static')
}
