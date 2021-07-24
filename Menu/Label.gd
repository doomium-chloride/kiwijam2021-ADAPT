extends Label

func _ready():
  get_node(label_path_here).connect("input_event", self, "label_pressed");

func label_pressed(input_event):
   if (input_event.type == input_event.MOUSE_BUTTON):
	var label_size = get_node(label_path_here).get_size();
	var label_pos = get_node(label_path_here).get_global_pos();
	var mouse_pos = get_global_mouse_pos();
   if (label_pos <= mouse_pos <= label_pos + label_size):
	print("clicked")
