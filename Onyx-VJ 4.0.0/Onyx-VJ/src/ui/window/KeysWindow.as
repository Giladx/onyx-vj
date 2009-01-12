/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
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
	
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.utils.string.*;
	
	import ui.controls.*;
	import ui.core.*;
	import ui.policy.*;
	import ui.states.*;
	import ui.text.TextField;
	
	/**
	 * 	Key Mapping Window
	 */
	public final class KeysWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var pane:ScrollPane;

		/**
		 * 	@Constructor
		 */
		public function KeysWindow(reg:WindowRegistration):void {
			
			// position & create
			super(reg, true, 260, 217);
			
			// show all keys
			init();
			
			// add listener
			addEventListener(Event.COMPLETE, handler);
			
			// we are draggable
			DragManager.setDraggable(this, true);
			
		}
		
		/**
		 * 
		 */
		private function handler(event:Event):void {
			updateKeys();
		}
		
		/**
		 * 	@private
		 */
		private function init():void {
			
			pane		= new ScrollPane(242, 196);
			pane.x		= 3;
			pane.y		= 18;
			addChild(pane);
			
			addKeys();
		}
		
		/**
		 * 	@private
		 */
		private function addKeys():void {
			
			var index:int = 0;
			
			// loop and create
			for each (var plugin:Plugin in PluginManager.macros) {
				
				var item:KeyItem = new KeyItem(plugin);
				pane.addChild(item).y = (index++ * 10);
			
			}
		}
		
		/**
		 * 
		 */
		private function clearKeys():void {
			
			while (pane.numChildren) {
				var item:KeyItem = pane.removeChildAt(0) as KeyItem;
				item.dispose();
			}
		}
		
		/**
		 * 
		 */
		public function updateKeys():void {
			for (var count:int = 0; count < pane.numChildren; count++) {
				var item:KeyItem = pane.getChildAt(count) as KeyItem;
				item.update();
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			// clear
			clearKeys();
			
			// add listener
			removeEventListener(Event.COMPLETE, handler);
			
			// dispose
			super.dispose(); 
		}
	}
}

import flash.display.Sprite;
import flash.events.*;
import flash.ui.*;

import onyx.core.*;
import onyx.plugin.*;
import onyx.utils.string.*;

import ui.controls.*;
import ui.core.*;
import ui.policy.*;
import ui.states.*;
import ui.text.TextField;
import ui.window.KeysWindow;

final class KeyItem extends Sprite implements IDisposable {
	

	/**
	 * 	@private
	 * 	Returns the string representation of a keyboard item
	 */
	private static function getKeyName(value:int):String {
		switch (value) {
			case Keyboard.SPACE:
				return 'SPACE';
			case Keyboard.UP:
				return 'UP';
			case Keyboard.DOWN:
				return 'DOWN';
			case Keyboard.LEFT:
				return 'LEFT';
			case Keyboard.RIGHT:
				return 'RIGHT';
			case Keyboard.F1:
			case Keyboard.F2:
			case Keyboard.F3:
			case Keyboard.F4:
			case Keyboard.F5:
			case Keyboard.F6:
			case Keyboard.F7:
			case Keyboard.F8:
			case Keyboard.F9:
			case Keyboard.F10:
			case Keyboard.F11:
			case Keyboard.F12:
				return 'F' + (value - 111);
			case Keyboard.BACKSPACE:
				return 'BACKSPACE';
			case Keyboard.CAPS_LOCK:
				return 'CAPSLOCK';
			case Keyboard.DELETE:
				return 'DEL';
			case Keyboard.HOME:
				return 'HOME';
			case Keyboard.END:
				return 'END';
			case Keyboard.INSERT:
				return 'INSERT';
			case Keyboard.ENTER:
				return 'ENTER';
			default:
				return String.fromCharCode(value);
		}
	}
	
	private var key:TextField;
	private var label:TextField;
	private var plugin:Plugin;
	private const button:ButtonClear		= new ButtonClear();
	private var clear:TextButton;
	
	/**
	 * 
	 */
	public function KeyItem(plugin:Plugin):void {
		
		this.plugin = plugin;
		
		init();
		
		button.addEventListener(MouseEvent.MOUSE_DOWN, handler);
		clear.addEventListener(MouseEvent.MOUSE_DOWN, clearHandler);
	}
	
	private function handler(event:MouseEvent):void {
		var state:KeyLearnState	= new KeyLearnState(plugin);
		StateManager.loadState(state);
		
		state.addEventListener(Event.COMPLETE, complete);
	}
	
	/**
	 * 
	 */
	private function clearHandler(event:MouseEvent):void {
		
		KeyListenerState.registerKey(KeyListenerState.getMacroKeys(plugin), null);
		(parent.parent.parent as KeysWindow).updateKeys();
		
	}
	
	private function complete(event:Event):void {
		var state:KeyLearnState = event.currentTarget as KeyLearnState;
		state.removeEventListener(Event.COMPLETE, complete);
		
		(parent.parent.parent as KeysWindow).updateKeys();
	}
	
	/**
	 * 
	 */
	private function init():void {
		
		var options:UIOptions = new UIOptions();
		options.width = 30;
		options.height = 10;
		
		label			= Factory.getNewInstance(TextField);
		label.width		= 150;
		label.height	= 10;
		clear			= new TextButton(options, 'CLEAR');

		key				= Factory.getNewInstance(TextField);
		key.width		= 40;
		key.height		= 10;
		key.x			= 150;
		
		button.initialize(190, 10);
		clear.x			= 190;

		addChild(clear);
		addChild(button);
		addChild(label);
		addChild(key);
		
		update();
		
	}
	
	/**
	 * 
	 */
	public function update():void {
		key.text	= getKeyName(KeyListenerState.getMacroKeys(plugin));
		label.text	= plugin.description;
	}
	
	/**
	 * 
	 */
	public function dispose():void {
		
		button.removeEventListener(MouseEvent.MOUSE_DOWN, handler);
		clear.removeEventListener(MouseEvent.MOUSE_DOWN, clearHandler);

	}
}