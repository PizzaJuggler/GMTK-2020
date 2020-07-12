extends Node2D

onready var tilemap = $TileMap
onready var player = $Player
export var rng_seed : String
export var level_num : int
var rng = RandomNumberGenerator.new()

var rooms : int
var max_room : int
var grid_size : int

const min_room := 8

const WALL = Vector2(2, 1)
const FLOOR = Vector2(1, 4)
# tilemap.set_cell(x, y, 0, false, false, false, Vector2(x, y))

var dungeon = {}

func _ready():
    if rng_seed != "":
        rng.seed = rng_seed.hash()
    else:
        rng.randomize()

    rooms = rng.randi_range(3 + level_num, 5 + level_num)
    max_room = level_num * 4 + 12
    grid_size = rooms * max_room
    
    
    for x in range(grid_size):
        dungeon[x] = {}
        for y in range(grid_size):
            dungeon[x][y] = Vector2.ZERO

    var rooms_list = create_rooms()

    add_walls()
    populate_tilemap()
    

func create_rooms():
    var rooms_list = []
    for _room in range(rooms):
        var x = rng.randi_range(0, grid_size - max_room)
        var y = rng.randi_range(0, grid_size - max_room)
        var dx = rng.randi_range(min_room, max_room)
        var dy = rng.randi_range(min_room, max_room)
        for a in range(x, x + dx):
            for b in range(y, y + dy):
                dungeon[a][b] = FLOOR
        rooms_list.append({
            "x": x,
            "y": y,
            "dx": dx,
            "dy": dy
        })
    return rooms_list
    
func add_walls():
    for x in range(grid_size):
        for y in range(grid_size):
            if dungeon[x][y] == FLOOR:
                if dungeon[x][y + 1] != FLOOR:
                    dungeon[x][y + 1] = WALL
                if dungeon[x][y - 1] != FLOOR:
                    dungeon[x][y - 1] = WALL
                if dungeon[x + 1][y] != FLOOR:
                    dungeon[x + 1][y] = WALL
                if dungeon[x - 1][y] != FLOOR:
                    dungeon[x - 1][y] = WALL

func populate_tilemap():
    for x in range(grid_size):
        for y in range(grid_size):
            tilemap.set_cell(x, y, 0, false, false, false, dungeon[x][y])
