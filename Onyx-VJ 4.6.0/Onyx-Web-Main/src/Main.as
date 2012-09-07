/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
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
package {
	
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.Security;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import services.videopong.VideoPong;
	
	import ui.controls.*;
	import ui.controls.layer.*;
	import ui.core.*;
	import ui.states.*;
	import ui.text.*;
	import ui.window.*;

	[SWF(width="762", height="839", backgroundColor="#141515", frameRate='25', systemChrome='none')]
	public final class Main extends Sprite {
		
		/**
		 * 	@private
		 */
		private const states:Array	= [
			new FirstRunState(),
			new SettingsLoadState(),
			new InitializationState(),
			new SettingsApplyState(),
			new PauseState()
		];
		
		/**
		 * 	@constructor
		 */
		public function Main():void {
			
			// register classes for re-use
			Factory.registerClass(ButtonControl);
			Factory.registerClass(ColorPicker);
			Factory.registerClass(DropDown);
			Factory.registerClass(SliderVFrameRate);
			Factory.registerClass(SliderV);
			Factory.registerClass(SliderV2);
			Factory.registerClass(TextControl);
			Factory.registerClass(Status);
			Factory.registerClass(LayerVisible);
			Factory.registerClass(TextField);
			Factory.registerClass(TextFieldCenter);
			
			// init
			init();
			
		}
		
		/**
		 *	@private 
		 */
		private function init():void {
			
			// store stage
			DISPLAY_STAGE		= this.stage;
			Tempo				= new TempoImplementer();
			
			// find originating domain where SWF was loaded
			var ldrURL:String = loaderInfo.loaderURL;
			switch ( ldrURL.substr( 0, 16 ).toLowerCase() )
			{
				case 'https://www.vide':
					ONYX_WEBSITE = 'v';
					break;
				case 'https://e-collec':
					ONYX_WEBSITE = 'e';
					break;
				case 'http://www.batch':
				case 'http://batchass.':
					ONYX_WEBSITE = 'b';
					break;
				case 'http://localhost':
					ONYX_WEBSITE = 'l';//BL put 'l'; after debug
					break;
				default:
					ONYX_WEBSITE = 'o';
					break;
			}				
			// check first run and setup
			checkFirstRun();
		}
		
		/**
		 * 	@private
		 */
		private function checkFirstRun():void {
			
			// load the initial states
			StateManager.loadState(new ShowOnyxState());
			
			// start the states
			queueState();
			
		}
		
		/**
		 * 	@private
		 */
		private function queueState(event:Event = null):void {
			
			if (event) {
				var state:ApplicationState = event.currentTarget as ApplicationState;
				state.removeEventListener(Event.COMPLETE, queueState);
			}
			
			state = states.shift() as ApplicationState;
			if (state) {
				state.addEventListener(Event.COMPLETE, queueState);
				StateManager.loadState(state);
			} else {
				
				// run the app
				start();
			}
		}
		
		/**
		 * 	@private
		 */
		private function start():void 
		{	
			const setup:ShowOnyxState = StateManager.getStates('startup')[0];
			
			// remove the startup state
			StateManager.removeState(setup);
			
			// load default states
			StateManager.loadState(new KeyListenerState());		// listen for keyboard
			Display.pause(false);
			
			//load onx mix into layers
			loadDefaultOnx();
		}
		
		/**
		 * 	@private
		 */
		private function loadDefaultOnx():void 
		{
			var path:String = '';
			const vp:VideoPong = VideoPong.getInstance();
			switch ( ONYX_WEBSITE )
			{
				case 'v':
					// get the sessiontoken from flashvars
					vp.sessiontoken = root.loaderInfo.parameters.sessiontoken;
					// load default.onx
					path = 'https://www.videopong.net/api/get_startupxml/replacethissessiontoken/default.onx';
					
					//load folders from videopong
					if ( vp.sessiontoken ) vp.loadFoldersAndAssets();
					break;
				case 'e':
					// get the sessiontoken from flashvars
					vp.sessiontoken = root.loaderInfo.parameters.sessiontoken;
					// load default.onx
					path = 'https://ecollection.fr/api/get_startupxml/replacethissessiontoken/default.onx';
					
					//load folders from videopong
					if ( vp.sessiontoken ) vp.loadFoldersAndAssets();
					break;
				case 'b':
					// load default.onx
					path = 'http://www.batchass.fr/onyx/default.onx';
					break;
				case 'l':
					// load default.onx
					path = 'http://localhost/onyx-web-main/default.onx';		
					break;
				default:
					break;
			}		
			if ( path.length > 0 )
			{
				const useTransition:Transition;
				const layer:LayerImplementor = (Display as OutputDisplay).getLayerAt(0) as LayerImplementor;			
				
				(Display as OutputDisplay).load( path, layer, useTransition );	
			}
		}
		/**
		 * 	@private
		 */
		private function closeChildren(event:Event):void {
			StateManager.loadState(new QuitState());
		}
	}
}