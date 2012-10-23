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
	import flash.filesystem.File;
	import flash.ui.*;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import onyx.asset.AssetFile;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.ParameterEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.system.NativeAppLauncher;
	import onyx.tween.Tween;
	import onyx.tween.TweenProperty;
	import onyx.utils.string.*;
	
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.LayerPage;
	import ui.layer.UILayer;
	import ui.policy.*;
	import ui.states.*;
	
	/**
	 * 	Dmx Window
	 */
	public final class DmxWindow extends Window implements IParameterObject {

		private var pane:ScrollPane;
		private var connectBtn:TextButton;
		private var outputBtn:TextButton;
		private var channelSlider:SliderV;
		private var dataSlider:SliderV;

		private var appLauncher:NativeAppLauncher;		
		private var timer:Timer = new Timer(1000);
		private var pathToExe:String 	= 'onyxdmx.exe';
		private var tempText:String		= 'l';
		private var _channel:int			= 2;
		private var _data:int				= 2;

		private const parameters:Parameters	= new Parameters(this as IParameterObject,
			new ParameterInteger('channel', 'channel', 1, 20, 3),
			new ParameterInteger('data', 'data', 1, 255, 3)
		);
			
		/**
		 * 	@Constructor
		 */
		public function DmxWindow(reg:WindowRegistration):void {
			
			// position & create
			super(reg, true, 260, 217);
			
			// show controls
			init();
			
			// we are draggable
			DragManager.setDraggable(this, true);		
		}

		private function init():void 
		{
			var index:int = 0;			
			pane		= new ScrollPane(242, 100);
			pane.x		= 3;
			pane.y		= 18;
			addChild(pane);
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			connectBtn				= new TextButton(options, 'connect'),
			connectBtn.addEventListener(MouseEvent.MOUSE_DOWN, start);
			pane.addChild(connectBtn).y = (index++ * 15);		
			
			outputBtn				= new TextButton(options, 'send'),
			outputBtn.addEventListener(MouseEvent.MOUSE_DOWN, outpMsg);
			pane.addChild(outputBtn).y = (index++ * 15);
					
			dataSlider				= Factory.getNewInstance(SliderV);
			dataSlider.initialize(parameters.getParameter('data'), options);
			pane.addChild(dataSlider).y = (index++ * 30);
				
			channelSlider				= Factory.getNewInstance(SliderV);
			channelSlider.initialize(parameters.getParameter('channel'), options);
			pane.addChild(channelSlider).y = (index++ * 30);
				
			appLauncher = new NativeAppLauncher(pathToExe);
			appLauncher.addEventListener( Event.ACTIVATE, activate );
			appLauncher.addEventListener( Event.CLOSE, closed );
			//appLauncher.addEventListener( Event.CHANGE, change );

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
			appLauncher.writeData('chan 3');
			event.stopPropagation();
		}

		public function getParameters():Parameters {
			return parameters;
		}
		private function onTimer(event:TimerEvent):void 
		{					
		}

		private function activate(evt:Event):void
		{
			trace("activate");
		}
		private function closed(evt:Event):void
		{
			trace("closed");
		}
		/**
		 * 
		 */
		override public function dispose():void 
		{					
			// dispose
			super.dispose(); 
		}

		public function get data():int
		{
			return _data;
		}

		public function set data(value:int):void
		{
			_data = value;
			Console.output('sendind data',_data);
			appLauncher.writeData('data ' + _data);
		}

		public function get channel():int
		{
			return _channel;
		}

		public function set channel(value:int):void
		{
			_channel = value;
			Console.output('sendind channel',_channel);
			appLauncher.writeData('chan ' + _channel);
		}


	}
}
