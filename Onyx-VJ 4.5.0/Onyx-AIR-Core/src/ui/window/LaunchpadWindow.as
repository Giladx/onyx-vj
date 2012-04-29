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
	import onyx.system.NativeAppLauncher;
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
	public final class LaunchpadWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var pane:ScrollPane;
		private var connectBtn:TextButton;
		private var outputBtn:TextButton;
		
		private var tween:Tween;
		private var index:int = 0;
		private var selectedLayer:int = 0;
		private var timer:Timer = new Timer(1000);
		private var pathToExe:String = 'MidiPipe.exe';
		private var tempText:String	= 'outp launchpad';
		private var appLauncher:NativeAppLauncher;		
		private var numerator:uint = 1;
		private var denominator:uint = 3;

		/**
		 * 	@Constructor
		 */
		public function LaunchpadWindow(reg:WindowRegistration):void {
			
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
			pane		= new ScrollPane(242, 100);
			pane.x		= 3;
			pane.y		= 18;
			addChild(pane);
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			connectBtn					= new TextButton(options, 'connect'),
			connectBtn.addEventListener(MouseEvent.MOUSE_DOWN, start);
			pane.addChild(connectBtn).y = (index++ * 30);
			
			
			outputBtn				= new TextButton(options, 'outp launchpad'),
			outputBtn.addEventListener(MouseEvent.MOUSE_DOWN, outpMsg);
			pane.addChild(outputBtn).y = (index++ * 30);
			
			appLauncher = new NativeAppLauncher(pathToExe);
			appLauncher.addEventListener( Event.ACTIVATE, activate );
			appLauncher.addEventListener( Event.CLOSE, closed );
			appLauncher.addEventListener( Event.CHANGE, change );
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		public function start(event:MouseEvent):void 
		{
			appLauncher.launchExe();
			event.stopPropagation();
		}
		private function outpMsg(event:MouseEvent):void 
		{
			appLauncher.writeData('outp launchpad');
			appLauncher.writeData('inpt launchpad');
			appLauncher.writeData('176,0,127');
			event.stopPropagation();
		}
		/*public function write():void 
		{			
			appLauncher.writeData(tempText);
			if (tempText == 'outp launchpad') tempText = 'inpt loop';
		}*/
		public function reset():void 
		{			
			appLauncher.writeData('176,0,0');
		}
		public function lightAll():void 
		{			
			appLauncher.writeData('176,0,127');
		}
		public function dutyCycle():void 
		{	
			if (numerator++>7) numerator = 1;
			if (denominator++>17) denominator = 3;
			var duty:uint = (16 * (numerator - 1)) + (denominator - 3);
			//if (duty > 127) duty = 0;
			appLauncher.writeData('176,30,' + duty);
		}
		public function gradient():void
		{
			for (var red:uint=0;red<8;red++)
			{
				for (var green:uint=0;green<8;green++)
				{
					var colour:uint = 12 + red + (green*16);
					var pos:uint = red + ((green)*16);
					appLauncher.writeData('144,' + pos + ',' + colour);
				}	
			}
		}
		private function lightPad( padIndex:uint, color:uint):void
		{
			appLauncher.writeData('144,' + padIndex + ',' + color);
		}
		private function onTimer(event:TimerEvent):void 
		{
			
			var layer:Layer	= (UIObject.selection as UILayer).layer;
			
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
						
						break;
					case "layerbtn":
						
						break;
					case "cnx":
						//dlc.sendData( {type:"layers", value:Display.layers.length} );
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
						layer.blendMode	= BlendModes[Math.max(BlendModes.indexOf(layer.blendMode)-1,0)];	
						break;
					case "select-layer":
						selectedLayer = dataReceived.value;
						UILayer.selectLayer(selectedLayer);
						var layer:Layer = Display.getLayerAt(selectedLayer);
						
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
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							layer,
							25,
							new TweenProperty('alpha', layer.alpha, dataReceived.value/100)
						);
						break;
					case "bounce":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						
						/*const totalTime:int	= layer.totalTime;
						const time:int		= layer.time * totalTime;
						const start:int		= layer.loopStart * totalTime;
						const end:int		= layer.loopEnd	* totalTime;
						const frame:int		= layer.framerate * Display.frameRate * 2;
						
						if (time + frame > end || time + frame < start) {*/
						layer.framerate	*= -1;
						//}
						break;
					case "x":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							layer,
							25,
							new TweenProperty('x', layer.x, dataReceived.value)
						);
						break;
					//layer.content onyx.display.ContentCustom
					//layer.content.customParameters
					//layer.content.customParameters.length
					//layer.content.customParameters[6].value //6 rotx
					case "y":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							layer,
							25,
							new TweenProperty('y', layer.y, dataReceived.value)
						);
						break;
					case "brightness":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							layer,
							25,
							new TweenProperty('brightness', layer.brightness, dataReceived.value/100)
						);
						break;
					case "contrast":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							layer,
							25,
							new TweenProperty('contrast', layer.contrast, dataReceived.value/100)
						);
						break;
					case "saturation":
						var layer:Layer	= (UIObject.selection as UILayer).layer;
						
						var rTween:Tween = new Tween(
							layer,
							25,
							new TweenProperty('saturation', layer.saturation, dataReceived.value/100)
						);
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
				case connectBtn:
					
					break;
			}
			event.stopPropagation();
		}
		public function change(evt:Event):void 
		{
			var cmd:String = appLauncher.readAppOutput();
			var data1:uint = uint(cmd);
			trace("change" + data1);	
		}
		
		private function activate(evt:Event):void
		{
			trace("activate");
			//running = true;
		}
		private function closed(evt:Event):void
		{
			trace("closed");
			//running = false;
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
