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
var rooms_list = []

func _ready():
    if rng_seed != "":
        rng.seed = rng_seed.hash()
    else:
        rng.randomize()

    rooms = rng.randi_range(3 + level_num, 5 + level_num)
    max_room = level_num * 4 + 12
    grid_size = rooms * max_room * 2
    
    
    for x in range(grid_size):
        dungeon[x] = {}
        for y in range(grid_size):
            dungeon[x][y] = Vector2.ZERO

    create_rooms()
    connect_rooms()
    add_walls()
    populate_tilemap()
    place_player_in_room(rooms_list)
    

func create_rooms():
    for _room in range(rooms):
        var x = rng.randi_range(1, grid_size - max_room)
        var y = rng.randi_range(1, grid_size - max_room)
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
    rooms_list.sort_custom(self, "sort_rooms_by_y")


# lowest y is first
func sort_rooms_by_y(a, b):
    return a.y > b.y 
    
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
            
func place_object(object):
    pass          

func connect_rooms():
    for i in range(rooms_list.size() - 1):
        
        create_path_between_rooms(rooms_list[i], rooms_list[i + 1])

func do_rooms_overlap(a, b):
    return abs(a.x - b.x) > a.dx + b.dx or abs(a.y - b.y) > a.dy + b.dy
    
func create_path_between_rooms(a, b):
    var coord = {}
    coord = {"x": clamp(b.x + b.dx / 2, a.x - 1, a.x + a.dx + 1), "y": a.y + a.dy / 2}
    var dx
    var signed_distance =  b.x - coord.x
    if signed_distance > 0:
        dx = 1
    else:
        dx = -1
    print(a) 
    print(b) 
    while not is_above_or_below_room(coord, b):
        add_path_piece(coord, true, 5)
        coord.x += dx

    add_path_piece(coord, true, 5)
    
    while not is_left_or_right_room(coord, b):
        add_path_piece(coord, false, 5)
        coord.y -= 1
    

func add_path_piece(coord, is_horizontal, width):
    for i in range(-width / 2, width / 2 + 1):

        if is_horizontal:
            dungeon[coord.x][coord.y + i] = FLOOR
        else:
            dungeon[coord.x + i][coord.y] = FLOOR
    
func is_above_or_below_room(coord, room):
    return room.x < coord.x and coord.x < room.x + room.dx

func is_left_or_right_room(coord, room):
    return room.y < coord.y and coord.y < room.y + room.dy


func place_player_in_room(rooms_list):
    var lowest_room = rooms_list[0]
    
    var room_position = tilemap.map_to_world(Vector2(lowest_room.x, lowest_room.y))
    var room_center = room_position + .5 * Vector2(lowest_room.dx, lowest_room.dy) * tilemap.cell_size
    player.position = room_center
