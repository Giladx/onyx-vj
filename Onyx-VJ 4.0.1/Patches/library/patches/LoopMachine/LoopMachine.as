package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	[SWF(width='320', height='240', frameRate='24')]
	final public class LoopMachine extends MovieClip implements IParameterObject {
		
		/**
		 * 	@private
		 */
		private var parameters:Parameters	= new Parameters(this as IParameterObject);
		
		/**
		 * 	maxframes
		 */
		public var maxframes:int			= 120;
		
		/**
		 * 	@private
		 */
		private var _currentFrame:int		= 0;
		
		/**
		 * 	@private
		 */
		private var _frames:Array			= [];
		
		/**
		 * 	@private
		 */
		private var _recording:Boolean		= false;
		
		/**
		 * 	@private
		 */
		private const bitmap:Bitmap			= new Bitmap();
		
		/**
		 * 	@constructor
		 */
		public function LoopMachine():void {
			
			addChild(bitmap);
			
			parameters.addParameters(
				new ParameterExecuteFunction('start', 'start'),
				new ParameterBoolean('record', 'record', 1),
				new ParameterInteger('maxframes', 'frames', 40, 640, maxframes)
			);
			
		}
		
		/**
		 * 
		 */
		public function getParameters():Parameters {
			return parameters;
		}
		
		/**
		 * 
		 */
		public function start():void {
			record = true;
		}
		
		/**
		 * 	Starts recording
		 */
		public function set record(value:Boolean):void {
			
			if (value) {
				
				for each (var bitmapData:BitmapData in _frames) {
					bitmapData.dispose();
				}
	
				// clear the frames
				_frames = [];
				
				// listen for the display to blend the channels together
				Display.addEventListener(DisplayEvent.DISPLAY_RENDER, _record);
				
				// set the current frame to 0
				_currentFrame	= 0;
			} else {
				
				// stop recording
				Display.removeEventListener(DisplayEvent.DISPLAY_RENDER, _record);
			}
			
			// set ourselves to record mode
			_recording = value;
		}
		
		/**
		 * 	@private
		 */
		private function _record(event:Event):void {
			
			// stop recording?
			if (_currentFrame >= maxframes) {
				parameters.getParameter('record').value = false;
				return;
			}

			// copy frame			
			_frames[_currentFrame++] = Display.source.clone();
		}

		/**
		 * 	Returns whether we are recording or not
		 */
		public function get record():Boolean {
			return _recording;
		}
		
		/**
		 * 
		 */
		public function dispose():void {
			
			Display.removeEventListener(DisplayEvent.DISPLAY_RENDER, _record);

			for each (var bitmapData:BitmapData in _frames) {
				bitmapData.dispose();
			}

		}
		
		/**
		 * 
		 */
		override public function gotoAndStop(frame:Object, scene:String = null):void {

			var data:BitmapData	= _frames[int(frame)];
			bitmap.bitmapData	= data;

		}
		
		/**
		 * 
		 */
		override public function get totalFrames():int {
			return _frames.length + 1;
		}
	}
}
