import flash.desktop.NativeApplication;
import flash.events.AccelerometerEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.sensors.Accelerometer;
import flash.ui.Keyboard;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import mx.core.FlexGlobals;
import mx.events.FlexEvent;

import services.remote.DirectLanConnection;

import spark.components.Application;

import views.GlobalView;
import views.LayersView;

private var app:Application = FlexGlobals.topLevelApplication as Application;

private var currentScreen:String = "";
private static const MENU:String = "menu";
private static const ABOUT:String = "about";

private var accel:Accelerometer;

protected function applicationCompleteHandler(event:FlexEvent):void
{
	if (Multitouch.supportsTouchEvents)
	{
		Multitouch.inputMode = MultitouchInputMode.GESTURE;
		Multitouch.mapTouchToMouse = true;
	}
	//cnx.connect();
	this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	accel = new Accelerometer();
	//accel.addEventListener(AccelerometerEvent.UPDATE, handleAccelUpdate);

}

protected function handleExitApp(event:MouseEvent):void
{
	/*cnx.sendData({type:"exitbtn", value:1 });
	if( cnx ) cnx.close();*/
	NativeApplication.nativeApplication.exit();
}
private function onKeyDown(e:KeyboardEvent):void {
	trace("keycode: " + e.keyCode);
	switch (e.keyCode) { //Back button pressed
		case Keyboard.BACK:
			switch (currentScreen) {
				case ABOUT:
					e.preventDefault();
					//aboutUI.visible = false;
					currentScreen = "";
					break;
				default:
					break;
			}
			break;
		case Keyboard.MENU: //Menu button pressed
			
			break;
	}
}

protected function handleAccelUpdate(evt:AccelerometerEvent):void
{
	var aX:Number = evt.accelerationX;
	var aY:Number = evt.accelerationY;
	var aZ:Number = evt.accelerationZ;
	
	//cnx.sendData( {type:"rotation", value:Math.round(aX * 100)} );
}		


