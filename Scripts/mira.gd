@tool
extends Control

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4, Color.RED)
	draw_circle(Vector2.ZERO, 3, Color.RED)
	draw_line(Vector2(16, 0), Vector2(24, 0), Color.RED, 2)
	draw_line(Vector2( - 16, 0), Vector2( - 24, 0), Color.RED, 2)
	draw_line(Vector2(0, 16), Vector2(0, 24), Color.RED, 2)
	draw_line(Vector2(0, -16), Vector2(0, -24), Color.RED, 2)