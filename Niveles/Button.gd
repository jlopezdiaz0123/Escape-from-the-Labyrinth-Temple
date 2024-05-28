extends Button

# La ruta a la escena que deseas cargar
@export var target_scene_path: String = "res://Niveles/Laberinto1.tscn"

func _ready() -> void:
    # Conectar la señal 'pressed' al método '_on_button_pressed' usando Callable
    connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
    # Cambiar a la escena especificada
    get_tree().change_scene_to_file(target_scene_path)

