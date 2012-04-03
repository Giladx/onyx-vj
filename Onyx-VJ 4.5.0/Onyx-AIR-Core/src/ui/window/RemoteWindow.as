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
	
	import com.reyco1.multiuser.DirectLanConnection;
	
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

		private var dlc:DirectLanConnection;
		private var tween:Tween;
		private var index:int = 0;
		private var selectedLayer:int = 0;
		private var timer:Timer = new Timer(1000);
		private var layerButtonsCreated:Boolean = false;

		/**
		 * 	@Constructor
		 */
		public function RemoteWindow(reg:WindowRegistration):void {
			
			// position & create
			super(reg, true, 260, 217);
			
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
			pane		= new ScrollPane(242, 196);
			pane.x		= 3;
			pane.y		= 18;
			addChild(pane);
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			sendBtn					= new TextButton(options, 'send'),
			sendBtn.addEventListener(MouseEvent.MOUSE_DOWN, sendMsg);
			pane.addChild(sendBtn).y = (index++ * 10);
			
			dlc = new DirectLanConnection();
			dlc.onConnect = handleConnect;
			dlc.onDataRecieve = handleGotData;
			
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
		private function handleGotData(data:Object):void
		{
			Console.output("dlc.received:");
			if ( data.type )
			{
				Console.output(data.type.toString());
				switch ( data.type.toString() ) 
				{ 
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
						for each (var layer:Layer in Display.layers) {
							layer.framerate += .5;
						}
						break;
					case "frame-rate-decrease":
						for each (var layer:Layer in Display.layers) {
							layer.framerate -= .5;
						}
						break;
					case "cycle-blendmode-down":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						layer.blendMode	= BlendModes[Math.min(BlendModes.indexOf(layer.blendMode)+1, BlendModes.length - 1)];
						break;
					case "cycle-blendmode-up":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						layer.blendMode	= BlendModes[Math.max(BlendModes.indexOf(layer.blendMode)-1,0)];						break;
					case "select-layer":
						selectedLayer = data.value;
						UILayer.selectLayer(selectedLayer);
						break;
					case "mute-layer":
						index = data.value;
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
					default: 
						
						break;
				}
				
			}
		}
		private function tweenFinish(event:Event):void {
			tween.removeEventListener(Event.COMPLETE, tweenFinish);
			var layer:Layer = Display.getLayerAt(selectedLayer);
			layer.visible = false;
		}
		private function sendMsg(event:MouseEvent):void {
			switch (event.currentTarget) {
				case sendBtn:
					dlc.sendData( {type:"msg", value:"sent from onyx"} );
					//dlc.sendData( {type:"layers", value:Display.layers.length} );
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
