extends Node2D

const TILE_SIZE := 100
const GRID_COLS := 4
const GRID_ROWS := 1
const ORIGIN := Vector2(100, 250)

# Grid: Vector2i(x,y) -> value (0=empty, >0=numbered, -1=gate)
var grid := {}
var player_pos := Vector2i(0, 0)
var history: Array[Vector2i] = []
var gate_open := false
var rewinding := false
var rewind_timer := 0.0
var rewind_idx := 0
var rewind_path: Array[Vector2i] = []
var msg := "Arrow keys to move -> reach the green EXIT!"
var won := false

func _ready() -> void:
	for x in GRID_COLS:
		for y in GRID_ROWS:
			grid[Vector2i(x, y)] = 0
	grid[Vector2i(1, 0)] = 2    # rewind tile
	grid[Vector2i(2, 0)] = -1   # gate

func _process(delta: float) -> void:
	if rewinding:
		rewind_timer -= delta
		if rewind_timer <= 0.0 and rewind_idx < rewind_path.size():
			player_pos = rewind_path[rewind_idx]
			rewind_idx += 1
			rewind_timer = 0.12
			if rewind_idx >= rewind_path.size():
				rewinding = false
				msg = "Gate is open! Reach the exit ->"
		queue_redraw()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	var font_size := 16

	# Background
	draw_rect(Rect2(Vector2.ZERO, Vector2(800, 500)), Color(0.08, 0.08, 0.12))

	# Cells
	for x in GRID_COLS:
		for y in GRID_ROWS:
			var p := ORIGIN + Vector2(x * TILE_SIZE, y * TILE_SIZE)
			var r := Rect2(p, Vector2(TILE_SIZE, TILE_SIZE))
			var v: int = grid.get(Vector2i(x, y), 0)

			if v > 0:
				# Numbered tile — pulses to draw attention
				var pulse := absf(sin(Time.get_ticks_msec() * 0.004)) * 0.3 + 0.2
				draw_rect(r, Color(0.1, 0.15, 0.45))
				draw_rect(r, Color(0.25, 0.45, 1.0, pulse), false, 4)
				var ns := str(v)
				var ns_size := font.get_string_size(ns, HORIZONTAL_ALIGNMENT_CENTER, -1, 52)
				draw_string(font, p + Vector2(TILE_SIZE * 0.5 - ns_size.x * 0.5, TILE_SIZE * 0.5 + 12), ns, HORIZONTAL_ALIGNMENT_LEFT, -1, 52)
			elif v == 0:
				draw_rect(r, Color(0.16, 0.16, 0.20))
			elif v == -1:
				if not gate_open:
					draw_rect(r, Color(0.45, 0.08, 0.08))
					draw_rect(r, Color(0.85, 0.12, 0.12), false, 4)
					var gt := "GATE"
					var gt_size := font.get_string_size(gt, HORIZONTAL_ALIGNMENT_CENTER, -1, 20)
					draw_string(font, p + Vector2(TILE_SIZE * 0.5 - gt_size.x * 0.5, TILE_SIZE * 0.5 + 6), gt, HORIZONTAL_ALIGNMENT_LEFT, -1, 20)
				else:
					draw_rect(r, Color(0.12, 0.28, 0.12))
			draw_rect(r, Color(0.30, 0.30, 0.35), false, 1)

	# Exit tile (3,0)
	var ep := ORIGIN + Vector2(3 * TILE_SIZE, 0)
	var er := Rect2(ep, Vector2(TILE_SIZE, TILE_SIZE))
	draw_rect(er, Color(0.08, 0.45, 0.12))
	draw_rect(er, Color(0.15, 0.65, 0.25), false, 3)
	var et := "EXIT"
	var et_size := font.get_string_size(et, HORIZONTAL_ALIGNMENT_CENTER, -1, 22)
	draw_string(font, ep + Vector2(TILE_SIZE * 0.5 - et_size.x * 0.5, TILE_SIZE * 0.5 + 8), et, HORIZONTAL_ALIGNMENT_LEFT, -1, 22)

	# Ghost trail
	for i in history.size():
		var a := remap(float(i), 0.0, float(history.size()), 0.08, 0.45)
		var hp := history[i]
		var hw := ORIGIN + Vector2(hp.x * TILE_SIZE, hp.y * TILE_SIZE)
		draw_circle(hw + Vector2(TILE_SIZE * 0.5, TILE_SIZE * 0.5), 10.0, Color(1.0, 0.78, 0.15, a))

	# Player
	var pw := ORIGIN + Vector2(player_pos.x * TILE_SIZE, player_pos.y * TILE_SIZE)
	var center := pw + Vector2(TILE_SIZE * 0.5, TILE_SIZE * 0.5)
	var pcol := Color(1.0, 0.85, 0.08) if not rewinding else Color(0.35, 0.65, 1.0)
	draw_circle(center, TILE_SIZE * 0.5 - 14.0, pcol)
	draw_circle(center, TILE_SIZE * 0.5 - 14.0, pcol.lightened(0.2), false, 3)

	# Step counter
	draw_string(font, Vector2(20, 20), "Steps: %d" % history.size(), HORIZONTAL_ALIGNMENT_LEFT, -1, 18)

	# Message
	if msg != "":
		var ms := font.get_string_size(msg, HORIZONTAL_ALIGNMENT_CENTER, -1, 24)
		draw_string(font, Vector2(400 - ms.x * 0.5, 440), msg, HORIZONTAL_ALIGNMENT_LEFT, -1, 24)

	# Win overlay
	if won:
		draw_rect(Rect2(Vector2.ZERO, Vector2(800, 500)), Color(0.0, 0.0, 0.0, 0.6))
		var wm := "PUZZLE COMPLETE!"
		var wms := font.get_string_size(wm, HORIZONTAL_ALIGNMENT_CENTER, -1, 56)
		draw_string(font, Vector2(400 - wms.x * 0.5, 230), wm, HORIZONTAL_ALIGNMENT_LEFT, -1, 56)
		var sub := "The rewind opened the gate."
		var subs := font.get_string_size(sub, HORIZONTAL_ALIGNMENT_CENTER, -1, 24)
		draw_string(font, Vector2(400 - subs.x * 0.5, 290), sub, HORIZONTAL_ALIGNMENT_LEFT, -1, 24)

func _input(event: InputEvent) -> void:
	if rewinding or won:
		return
	if event.is_action_pressed("ui_right"):
		_try_move(Vector2i(1, 0))
	elif event.is_action_pressed("ui_left"):
		_try_move(Vector2i(-1, 0))
	elif event.is_action_pressed("ui_up"):
		_try_move(Vector2i(0, -1))
	elif event.is_action_pressed("ui_down"):
		_try_move(Vector2i(0, 1))

func _try_move(dir: Vector2i) -> void:
	var target := player_pos + dir
	if target.x < 0 or target.x >= GRID_COLS or target.y < 0 or target.y >= GRID_ROWS:
		return
	if target == Vector2i(2, 0) and not gate_open:
		msg = "Gate blocks the way! Find another approach..."
		queue_redraw()
		return

	history.append(player_pos)
	player_pos = target

	var val: int = grid.get(target, 0)
	if val > 0:
		grid[target] = val - 1
		msg = "Tile: %d -> %d" % [val, val - 1]
		if grid[target] == 0:
			_trigger_rewind()
	else:
		msg = ""

	if target == Vector2i(3, 0):
		won = true
		msg = "You reached the exit!"

	queue_redraw()

func _trigger_rewind() -> void:
	msg = ">> REWIND! Gate opens..."
	gate_open = true
	rewinding = true

	var steps := 2
	rewind_path.clear()
	for _i in steps:
		if history.size() > 0:
			rewind_path.append(history.pop_back())
	rewind_idx = 0
	rewind_timer = 0.0
