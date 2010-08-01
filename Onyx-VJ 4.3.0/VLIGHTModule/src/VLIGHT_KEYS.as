/*

THIS OBJECT LETS YOU SIMULATE - TRIGGER - TEST
YOUR PEAK FUNCTION WITH KEY-PRESSES
THE KEYS F7, F8, F9 INVOKE THE FUNCTIONS
bass(), mid() and high() 
ADJUST IT TO YOUR NEEDS

*/



onClipEvent (load) {
	
	b = 118;  // F7
	m = 119;  // F8
	h = 120;  // F9
	
	_visible = false;
	
}


onClipEvent (keyDown) {
	
	pressed = Key.getCode();
	
	
	if (pressed == b) {
		_parent.bass();
	}
	
	if (pressed == m) {
		_parent.mid();
	}
	
	if (pressed == h) {
		_parent.high();
	}	
	
}

