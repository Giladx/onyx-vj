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
private var numLayers:int = 0;
public var lv:LayersView;
private var cnx:DirectLanConnection;

protected function applicationCompleteHandler(event:FlexEvent):void
{
	if (Multitouch.supportsTouchEvents)
	{
		Multitouch.inputMode = MultitouchInputMode.GESTURE;
		Multitouch.mapTouchToMouse = true;
	}
	cnx = new DirectLanConnection();
	cnx.onConnect = handleConnectToService;
	cnx.onDataReceive = handleGetObject;
	//cnx.connect("60000");
	this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
}

protected function handleExitApp(event:MouseEvent):void
{
	cnx.sendData({type:"exitbtn", value:1 });
	if( cnx ) cnx.close();
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

protected function handleConnectToService(user:Object):void
{
	connStatus.connected = true;
	connStatus.connectedTo = "";
	accel = new Accelerometer();
	//accel.addEventListener(AccelerometerEvent.UPDATE, handleAccelUpdate);
	cnx.sendData({type:"cnx", value:"mobile" });			
}
protected function handleAccelUpdate(evt:AccelerometerEvent):void
{
	var aX:Number = evt.accelerationX;
	var aY:Number = evt.accelerationY;
	var aZ:Number = evt.accelerationZ;
	
	cnx.sendData( {type:"rotation", value:Math.round(aX * 100)} );
}		
protected function handleGetObject(dataReceived:Object):void
{
	// received
	switch ( dataReceived.type.toString() ) 
	{ 
		case "msg":
			//navigator.activeView.status.text 	= dataReceived.value;
			break;
		case "path":
			if ( lv ) lv.path.text = dataReceived.value;		
			break;
		case "layer":
			if ( numLayers == 0 )
			{
				//cnx.sendData({type:"cnx", value:"mobile" });
			}
			else
			{
				if ( lv ) lv.selectedLayer = dataReceived.value;
			}
			break;
		case "layers":
			numLayers = dataReceived.value;
			navigator.pushView( LayersView, dataReceived );
			
			cnx.sendData( {type:"layerbtn", value:"created" }  );
			break;
		default: 
			
			break;
	}
}

