/*

USE THIS MOVIECLIP:
- IF YOU ARE USING VLIGHT.CTRL
- IF YOU WANT TO HAVE SOUNDREACTIVITY OUTSIDE THE VLIGHT.MXR ENVIRONMENT

ON A WINDOWS-PC:
MAKE SURE THAT THE FILE 'VCTRL.dat' IS LOCATED 
IN THE SAME FOLDER AS THE FLASH FILE (*.swf) YOU ARE WORKING ON.
EITHER VMXRCTRL.exe OR VCTRL.exe MUST BE RUNNING.

ON A MAC:
MAKE SURE THAT THE FILE 'VMIC.dat' IS LOCATED 
IN THE SAME FOLDER AS THE FLASH FILE (*.swf) YOU ARE WORKING ON.


THIS OBJECT IS ALSO VERY USEFUL DURING THE DEVELOPMENT PROCESS,
IF YOU ARE PREPARING VISUALS FOR THE VLIGHT.MXR
TO PREVENT DOUBLE CONNECTIONS THIS OBJECT WILL CHECK FIRST IF THERE IS
ALREADY A CONNECTION TROUGH THE VLIGHT.MXR BEFORE MAKING A CONNECTION ITSELF. 
WE WANT TO MAKE SURE THAT YOUR SOUNDREACTIVE PIECES WILL WORK AS STANDALONE AND WITHIN THE VLIGHT.MXR.
NOTE: IF YOU LOAD YOUR FILE INTO THE VLIGHT.MXR ALL INITITAL VALUES WILL BE OVERWRITTEN
BY THE VLIGHT.MXR SETTINGS

*/

//xmlPort = 2048;
//xmlPortSave = 2049;
//xmlPortMidi = 2050;

package {
	
	import module.VLIGHTModuleItem;
	
	import onyx.plugin.PluginManager;
	
	
	public final class VLIGHT_CONNECT {
		
		// INITIAL VALUES
		// ON A PC SET THE GAIN VALUE FROM 0.1 TO 5 
		gain = 50;	
		// SET THESE TO VALUES FROM 1 TO 100
		triggerbass = 60;
		triggermid  = 40;
		triggerhigh = 20;		
		// IF THE MAIN AMPLITUDE (VXML.a) FALLS UNDER THIS VALUE SILENCE (VXML.silence) IS CONSIDERED TO BE TRUE
		silenceamp = 10;	
		// SET THESE TO VALUES FROM 0 TO 999 THIS IS THE MINIMUM TIME IN MILLISECONDS BETWEEN TO PEAKS
		bassdelay = 500;
		middelay  = 250;
		highdelay = 125;
		
		(PluginManager.modules['VLIGHT'] as VLIGHTModuleItem).;
	}
}


function VXML()
{
	this.host = "";
	this.port = "";
	this.socket = null;
	this.connected = false;
	this.eventcounter = 0;
	this.gain = 1;
	this.a = 0;
	this.ab = 0;
	this.am = 0;
	this.ah = 0;
	this.triggerbass = 60;
	this.triggermid = 40;
	this.triggerhigh = 20;
	this.bassdelay = 500;
	this.middelay = 250;
	this.highdelay = 125;
	this.bd = 0;
	this.md = 0;
	this.hd = 0;
	this.silenceamp = 10;
	this.silence = false;
	this.peakbass = false;
	this.peakmid = false;
	this.peakhigh = false;
	this.a0 = 0;
	this.a1 = 0;
	this.a2 = 0;
	this.a3 = 0;
	this.a4 = 0;
	this.a5 = 0;
	this.a6 = 0;
	this.a7 = 0;
	this.a8 = 0;
	this.a9 = 0;
	this.a10 = 0;
	this.a11 = 0;
	this.a12 = 0;
	this.a13 = 0;
	this.a14 = 0;
	this.a15 = 0;
	this.objecttype = "vxml";
} // End of the function


function xmlOnXML(doc) {

	if (e != null && e.nodeName == "sound")
	{
		_root.VXML.a = e.attributes.a * _root.VXML.gain;
		_root.VXML.ab = e.attributes.ab * _root.VXML.gain;
		_root.VXML.am = e.attributes.am * _root.VXML.gain;
		_root.VXML.ah = e.attributes.ah * _root.VXML.gain;
		_root.VXML.a0 = e.attributes.a0 * _root.VXML.gain;
		_root.VXML.a1 = e.attributes.a1 * _root.VXML.gain;
		_root.VXML.a2 = e.attributes.a2 * _root.VXML.gain;
		_root.VXML.a3 = e.attributes.a3 * _root.VXML.gain;
		_root.VXML.a4 = e.attributes.a4 * _root.VXML.gain;
		_root.VXML.a5 = e.attributes.a5 * _root.VXML.gain;
		_root.VXML.a6 = e.attributes.a6 * _root.VXML.gain;
		_root.VXML.a7 = e.attributes.a7 * _root.VXML.gain;
		_root.VXML.a8 = e.attributes.a8 * _root.VXML.gain;
		_root.VXML.a9 = e.attributes.a9 * _root.VXML.gain;
		_root.VXML.a10 = e.attributes.a10 * _root.VXML.gain;
		_root.VXML.a11 = e.attributes.a11 * _root.VXML.gain;
		_root.VXML.a12 = e.attributes.a12 * _root.VXML.gain;
		_root.VXML.a13 = e.attributes.a13 * _root.VXML.gain;
		_root.VXML.a14 = e.attributes.a14 * _root.VXML.gain;
		_root.VXML.a15 = e.attributes.a15 * _root.VXML.gain;
		if (_root.VXML.triggerbass < _root.VXML.ab && _root.VXML.preab < _root.VXML.ab && _root.VXML.bassdelay < _root.VXML.bd)
		{
			_root.VXML.peakbass = true;
			_root.VXML.bdt = getTimer();
		}
		else
		{
			_root.VXML.peakbass = false;
		} // end else if
		_root.VXML.preab = _root.VXML.ab;
		_root.VXML.bd = getTimer() - _root.VXML.bdt;
		if (_root.VXML.triggermid < _root.VXML.am && _root.VXML.pream < _root.VXML.am && _root.VXML.middelay < _root.VXML.md)
		{
			_root.VXML.peakmid = true;
			_root.VXML.mdt = getTimer();
		}
		else
		{
			_root.VXML.peakmid = false;
		} // end else if
		_root.VXML.pream = _root.VXML.am;
		_root.VXML.md = getTimer() - _root.VXML.mdt;
		if (_root.VXML.triggerhigh < _root.VXML.ah && _root.VXML.preah < _root.VXML.ah && _root.VXML.highdelay < _root.VXML.hd)
		{
			_root.VXML.peakhigh = true;
			_root.VXML.hdt = getTimer();
		}
		else
		{
			_root.VXML.peakhigh = false;
		} // end else if
		_root.VXML.preah = _root.VXML.ah;
		_root.VXML.hd = getTimer() - _root.VXML.hdt;
		if (_root.VXML.a < _root.VXML.silenceamp)
		{
			_root.VXML.silence = true;
		}
		else
		{
			_root.VXML.silence = false;
		} // end if
	} // end else if
	delete doc;
} // End of the function
_root.VXML = new VXML();
_root.VXML.host = xmlHost;
_root.VXML.port = xmlPort;
_root.VXML.portmidi = xmlPortMidi;
socket = new XMLSocket();
socket.onConnect = xmlOnConnect;
socket.onXML = xmlOnXML;
midiSocket = new XMLSocket();
midiSocket.onConnect = xmlMidiOnConnect;
midiSocket.onXML = xmlMidiOnXML;
_root.VXML.socket = socket;
_root.VXML.midiSocket = midiSocket;
if (!socket.connect(xmlHost, xmlPort))
{
	_root.VXML.ConnectionString = "TCP/IP Connection: Verbindungsaufbau fehlgeschlagen.";
} // end if
if (!midiSocket.connect(xmlHost, xmlPortMidi))
{
	_root.VXML.ConnectionString = "TCP/IP Connection: Verbindungsaufbau fehlgeschlagen.";
} // end if


// [Action in Frame 11]
_root.VXML.triggerbass = _root.triggerbass;
_root.VXML.triggermid = _root.triggermid;
_root.VXML.triggerhigh = _root.triggerhigh;
_root.VXML.silenceamp = _root.silenceamp;
_root.VXML.bassdelay = _root.bassdelay;
_root.VXML.middelay = _root.middelay;
_root.VXML.highdelay = _root.highdelay;
_root.VXML.gain = _root.gain;
if (_root.gain > 5)
{
	_root.VXML.gain = 1;
} // end if

// [Action in Frame 12]
if (_root.VXML.peakbass)
{
	_parent.bass();
} // end if
if (_root.VXML.peakmid)
{
	_parent.mid();
} // end if
if (_root.VXML.peakhigh)
{
	_parent.high();
} // end if
