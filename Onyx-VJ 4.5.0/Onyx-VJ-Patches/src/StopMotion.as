package {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	final public class StopMotion extends TimePatch {
		
		/**
		 * 	@private
		 */
		private var recording:Boolean	= false;	
		
		/**
		 * 	public
		 */
		public var maxframes:int		= 250;
		
		/**
		 * 	@private
		 */
		private const frames:Array		= [];
		
		/**
		 * 
		 */
		public var layer:Layer;
		
		/**
		 * 
		 */
		public var frameDelay:int		= 3;
		
		/**
		 * 	@private
		 */
		private var frameCount:int		= 0;
		
		/**
		 * 	@constructor
		 */
		public function StopMotion():void {
			
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterExecuteFunction('start', 'start'),
				new ParameterBoolean('record', 'record', 1),
				new ParameterInteger('frameDelay', 'frameDelay', 1, 24, frameDelay),
				new ParameterInteger('maxframes', 'frames', 120, 640, maxframes),
				new ParameterInteger('totalFrames', 'recorded', 0, 0, totalFrames)
			);
			
			// don't allow editing
			parameters.getParameter('totalFrames').setMetaData('editable', false);

		}
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {
			
			if (layer && recording && --frameCount <= 0) {

				frames.push(layer.source.clone());
				
				if (frames.length >= maxframes) {
					recording = false;
				}
				
				parameters.getParameter('totalFrames').updateListeners();

				frameCount = frameDelay;
				
			}

			var bmp:BitmapData = frames[info.currentFrame];
			if (bmp) {
				info.render(bmp);
			}
		}
		
		/**
		 * 
		 */
		public function start():void {
			if (layer) {
				record = true;
			}
		}
		
		/**
		 * 
		 */
		public function set record(value:Boolean):void {
			
			if (value) {
				
				// kill existing frames
				while (frames.length) {
					var bitmapData:BitmapData = frames.shift() as BitmapData;
					bitmapData.dispose();
				}
				
			}
			
			recording = value;
		}

		/**
		 * 
		 */
		public function get record():Boolean {
			return recording;
		}
		
		/**
		 * 
		 */
		public function set totalFrames(value:int):void {
		}
		
		/**
		 * 
		 */
		override public function get totalFrames():int {
			return frames.length + 1;
		}
		
		/**
		 * 
		override public function gotoAndStop(frame:Object, scene:String = null):void {
			if (frame is int) {
				var num:int = frame as int;
				var bmp:BitmapData = frames[num];
				
				if (bmp) {
					bitmap.bitmapData = bmp;
				}
			}
		}
		 */
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			// kill existing frames
			while (frames.length) {
				var bitmapData:BitmapData = frames.shift() as BitmapData;
				bitmapData.dispose();
			}
			
		}
	}
}