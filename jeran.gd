extends Sprite2D
var lastClicks=[0];
var clickCount=6;
@onready var label: Label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Time.get_ticks_msec()-lastClicks[lastClicks.size()-1]>3000):
		label.text=""

func _on_button_pressed() -> void:
	lastClicks.append(Time.get_ticks_msec());
	while(lastClicks.size()>clickCount):
		lastClicks.pop_front();
	if(lastClicks.size()==clickCount):
		var delta=lastClicks[clickCount-1]-lastClicks[0]
		if(delta<2000):
			label.text="Please,\nstop clicking\non me so much!";
			#print("please stop clicking on me so much!")
