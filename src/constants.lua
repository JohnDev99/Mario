WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

--escala de tiles a renderizar no ecra
SCREEN_TILE_WIDTH = VIRTUAL_WIDTH / TILE_SIZE
SCREEN_TILE_HEIGHT = VIRTUAL_HEIGHT / TILE_SIZE

--Velocidade de scroll da camera
CAMERA_SCROLL_SPEED = 100
BACKGROUND_SCROLL_SPEED = 10

TILE_SIZE = 16
--numero de tiles em cada set
TILE_SET_WIDTH = 5
TILE_SET_HEIGHT = 4
--numero de sets da imagem
TILE_SETS_WIDE = 6
TILE_SETS_TALL = 10
--numero de sets topper na imagem
TOPPER_SETS_WIDE = 6
TOPPER_SETS_TALL = 18

TILE_ID_EMPTY = 5
TILE_ID_GROUND = 3

TOPPER_SETS = TOPPER_SETS_WIDE * TOPPER_SETS_TALL
TILE_SET = TILE_SETS_WIDE * TILE_SETS_TALL

--PLAYER
PLAYER_WALK_SPEED = 60
PLAYER_JUMP_VELOCITY = -150

CHARACTER_WIDTH = 16
CHARACTER_HEIGHT = 20
CHARACTER_MOVE_SPEED = 60
CHARACTER_JUMP_VELOCITY = -200
--Valor da gravidade
GRAVITY = 7

--Snail(enemy)
SNAIL_MOVE_SPEED = 10

COLLIDABLE_TILES = {
    TILE_ID_GROUND
}

BUSH_IDS = {
    1, 2, 5, 6, 7
}

COIN_IDS = {
    1, 2, 3
}

CRATES = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
}

GEMS = {
    1, 2, 3, 4, 5, 6, 7, 8
}

JUMP_BLOCKS = {}
for i = 1, 30 do
    table.insert(JUMP_BLOCKS, i)
end