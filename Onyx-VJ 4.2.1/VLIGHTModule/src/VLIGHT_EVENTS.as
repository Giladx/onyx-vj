/*

USE THIS OBJECT IF YOU WANT TO TRIGGER
MULTIPLE OR SPECIFIC FUNCTIONS ON SOUND EVENTS
EVENTS ARE BASS PEAK, MID PEAK, HIGH PEAK AND SILENCE.
NOTE: YOU MUST HAVE FUNCTIONS CALLED mybass(); mymid(); myhigh(); mysilence();
WHICH HAVE TO BE ON _root
ADJUST IT TO YOUR NEEDS

*/

onClipEvent (load) {
	_visible = false;
}
onClipEvent (enterFrame) {
	if (_root.VXML.peakbass) {
		_parent.mybass();
	}
	if (_root.VXML.peakmid) {
		_parent.mymid();
	}
	if (_root.VXML.peakhigh) {
		_parent.myhigh();
	}
	if (_root.VXML.silence) {
		_parent.mysilence();
	}
}
