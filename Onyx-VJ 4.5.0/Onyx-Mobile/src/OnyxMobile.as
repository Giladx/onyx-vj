package
{
	import flash.desktop.*;
	import flash.display.*;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.html.*;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.file.writeTextFile;
	
	import ui.controls.*;
	import ui.controls.layer.*;
	import ui.core.*;
	import ui.states.*;
	import ui.text.*;
	import ui.window.*;

	[SWF(width="480", height="800", backgroundColor="#141515", frameRate='60', systemChrome='none')]
	public class OnyxMobile extends Sprite
	{
		private const STATES:Array	= [
			new FirstRunState(),
			new SettingsLoadState(),
			new InitializationState(),
			new SettingsApplyState(),
			new PauseState()
		];
		public function OnyxMobile()
		{
			super();
				
			// for autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
			Factory.registerClass(TextFieldOnyx);
			Factory.registerClass(TextFieldCenter);
			
			// init
			init();
		}
		/**
		 *	@private 
		 */
		private function init():void {
			
			// store stage
			DISPLAY_STAGE			= this.stage;
			this.stage.align		= StageAlign.TOP_LEFT;
			//BL for smartphone, I remove: 
			if (DISPLAY_STAGE.nativeWindow)
			{
				this.stage.scaleMode 	= StageScaleMode.NO_SCALE;
			}
			// turn on hardware accelleration 
			//stage.displayState			= StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			//trace(this.stage.nativeWindow is null);
			Tempo					= new TempoImplementer();
			
			// quit on close
			//BL stage.nativeWindow.addEventListener(Event.CLOSE, closeChildren);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, closeChildren);
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
			state = STATES.shift() as ApplicationState;
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
		private function start():void {
			
			const setup:ShowOnyxState = StateManager.getStates('startup')[0];
			
			// write to the startup.log file
			writeTextFile(new File(AssetFile.resolvePath('logs/start.log')), setup.getLogText());
			
			// remove the startup state
			StateManager.removeState(setup);
			
			// load default states
			StateManager.loadState(new KeyListenerState());		// listen for keyboard
			
			Display.pause(false);
		}
		
		/**
		 * 	@private
		 */
		private function closeChildren(event:Event):void {
			StateManager.loadState(new QuitState());
		}
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void {
			trace("UncaughtErrorEvent: " + event.toString());
			var errorMessage:String; 
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				errorMessage = "Global Error: " + error.message + "\nType: " + error.name + "\nStack: " + error.getStackTrace();
				Console.output( errorMessage );
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				errorMessage = "global ErrorEvent:" + errorEvent.text;
				Console.output( errorMessage );
				
			}
			else
			{
				errorMessage = "global other error:" + event.toString();
				Console.output( errorMessage );
			}
			event.preventDefault();
			writeTextFile(new File(AssetFile.resolvePath('logs/errors.log')), errorMessage);
		}
	}
}

