/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */

package ui.window {
		
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.display.BlendModes;
	import onyx.display.OutputDisplay;
	import onyx.plugin.*;
	import onyx.tween.Tween;
	import onyx.tween.TweenProperty;
	import onyx.utils.string.*;
	
	import services.remote.DirectLanConnection;
	
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.UILayer;
	import ui.policy.*;
	import ui.states.*;
	
	/**
	 * 	Remote Mapping Window
	 */
	public final class RemoteWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var pane:ScrollPane;
		private var sendBtn:TextButton;
		private var layersBtn:TextButton;

		private var dlc:DirectLanConnection;
		private var tween:Tween;
		private var index:int = 0;
		private var selectedLayer:int = 0;
		private var timer:Timer = new Timer(1000);
		private var layerButtonsCreated:Boolean = false;
		private var l:Layer;
		/**
		 * 	@Constructor
		 */
		public function RemoteWindow(reg:WindowRegistration):void {
			
			// position & create
			super(reg, true, 160, 117);
			
			// show controls
			init();
			
			// we are draggable
			DragManager.setDraggable(this, true);
			
		}
		
		/**
		 * 	@private
		 */
		private function init():void 
		{
			var index:int = 0;			
			pane		= new ScrollPane(242, 100);
			pane.x		= 3;
			pane.y		= 18;
			addChild(pane);
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			sendBtn					= new TextButton(options, 'send'),
			sendBtn.addEventListener(MouseEvent.MOUSE_DOWN, sendMsg);
			pane.addChild(sendBtn).y = (index++ * 30);
			
			
			layersBtn				= new TextButton(options, 'layers'),
			layersBtn.addEventListener(MouseEvent.MOUSE_DOWN, layersMsg);
			pane.addChild(layersBtn).y = (index++ * 30);
			
			dlc = new DirectLanConnection();
			dlc.onConnect = handleConnect;
			dlc.onDataReceive = handleGotData;
			
			dlc.connect("60000");
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		private function handleConnect(info:Object):void
		{
			trace(dlc.port);
			Console.output("dlc.port:" + dlc.port);
			
		}
		private function onTimer(event:TimerEvent):void 
		{
			if ( !layerButtonsCreated ) dlc.sendData( {type:"layers", value:Display.layers.length} );
			var layer:Layer	= (UIObject.selection as UILayer).layer;
			dlc.sendData( {type:"layer", value:layer.index} );
		}
		private function handleGotData(dataReceived:Object):void
		{
			Console.output("dlc.received:");
			if ( dataReceived.type && dataReceived.value )
			{
				Console.output(dataReceived.type.toString(),":", dataReceived.value.toString());
				switch ( dataReceived.type.toString() ) 
				{ 
					case "exitbtn":
						layerButtonsCreated = false;
						break;
					case "layerbtn":
						layerButtonsCreated = true;
						break;
					case "cnx":
						dlc.sendData( {type:"layers", value:Display.layers.length} );
						break;
					case "toggle-cross-fader":
						const property:TweenProperty = (Display.channelMix > .5) ? new TweenProperty('channelMix', Display.channelMix, 0) : new TweenProperty('channelMix', Display.channelMix, 1);
						
						new Tween( Display, 4000, property );
						break;
					case "frame-rate-increase":
						for each (l in Display.layers) {
							l.framerate += .5;
						}
						break;
					case "frame-rate-decrease":
						for each (l in Display.layers) {
							l.framerate -= .5;
						}
						break;
					case "cycle-blendmode-down":
						l	= (UIObject.selection as UILayer).layer;
						l.blendMode	= BlendModes[Math.min(BlendModes.indexOf(l.blendMode)+1, BlendModes.length - 1)];
						break;
					case "cycle-blendmode-up":
						l	= (UIObject.selection as UILayer).layer;
						l.blendMode	= BlendModes[Math.max(BlendModes.indexOf(l.blendMode)-1,0)];	
						break;
					case "select-layer":
						selectedLayer = dataReceived.value;
						UILayer.selectLayer(selectedLayer);
						l = Display.getLayerAt(selectedLayer);
						dlc.sendData( {type:"path", value:l.path} );
						dlc.sendData( {type:"filters", value:l.filters.length} );
						//layer.filters.length>0
						//layer.filters[0].name = "BOUNCE"
						//layer.filters[0].
						break;
					case "fade-black":
						new Tween(
							Display,
							500,
							new TweenProperty('brightness', Display.brightness, (Display.brightness < 0) ? 0 : -1)
						)
						break;
					case "mute-layer":
						index = dataReceived.value;
						selectedLayer = index;
						var layer:Layer = Display.getLayerAt(selectedLayer);
						if (layer.visible) {
							tween = new Tween(
								layer,
								250,
								new TweenProperty('alpha', layer.alpha, 0)
							);
							tween.addEventListener(Event.COMPLETE, tweenFinish);
						} else {
							layer.visible = true;
							tween = new Tween(
								layer,
								250,
								new TweenProperty('alpha', 0, 1)
							);
						}
						break;
					case "rotation":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							layer,
							250,
							new TweenProperty('rotation', layer.rotation, dataReceived.value)
						);
						break;
					case "alpha":
						l	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							l,
							25,
							new TweenProperty('alpha', l.alpha, dataReceived.value/100)
						);
						break;
					case "bounce":
						l	= (UIObject.selection as UILayer).layer;
						l.framerate	*= -1;

						break;
					case "x":
						l	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							l,
							25,
							new TweenProperty('x', l.x, dataReceived.value)
						);
						break;
					case "y":
						l	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							l,
							25,
							new TweenProperty('y', l.y, dataReceived.value)
						);
						break;
					case "brightness":
						l	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							l,
							25,
							new TweenProperty('brightness', l.brightness, dataReceived.value/100)
						);
						break;
					case "contrast":
						l	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							l,
							25,
							new TweenProperty('contrast', l.contrast, dataReceived.value/100)
						);
						break;
					case "saturation":
						l	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							l,
							25,
							new TweenProperty('saturation', l.saturation, dataReceived.value/100)
						);
						break;
					default: 
						
						break;
				}
				
			}
		}
		private function tweenFinish(event:Event):void {
			tween.removeEventListener(Event.COMPLETE, tweenFinish);
			l = Display.getLayerAt(selectedLayer);
			l.visible = false;
		}
		private function sendMsg(event:MouseEvent):void {
			switch (event.currentTarget) {
				case sendBtn:
					dlc.sendData( {type:"msg", value:"sent from onyx"} );
					break;
			}
			event.stopPropagation();
		}
		private function layersMsg(event:MouseEvent):void {
			switch (event.currentTarget) {
				case sendBtn:
					dlc.sendData( {type:"layers", value:Display.layers.length} );
					break;
			}
			event.stopPropagation();
		}
		
		/**
		 * 
		 */
		override public function dispose():void 
		{					
			// dispose
			super.dispose(); 
		}
	}
}
