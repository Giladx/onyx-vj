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
	import onyx.display.BlendModes;
	import onyx.display.ContentCustom;
	import onyx.display.LayerImplementor;
	import onyx.display.OutputDisplay;
	import onyx.parameter.Parameter;
	import onyx.parameter.Parameters;
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
	public final class DmxWindow extends Window {

		private var pane:ScrollPane;
		private var connectBtn:TextButton;
		private var outputBtn:TextButton;

		private var timer:Timer = new Timer(1000);
		private var pathToExe:String = 'onyxdmx.exe';
		private var tempText:String	= 'l';
		private var appLauncher:NativeAppLauncher;		
		
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
			appLauncher.writeData('red');
			event.stopPropagation();
		}
		private function onTimer(event:TimerEvent):void 
		{					
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
