package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	final public class StopMotionOverlay extends TimePatch {
		
		/**
		 * 	@private
		 */
		private var recording:Boolean	= false;	
		
		/**
		 * 	public
		 */
		public var maxframes:int		= 28;
		public var blend:String			= 'lighten';
		
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
		public var frameDelay:int		= 6;
		public var alph:Number			= 1;
		
		/**
		 * 	@private
		 */
		private var frameCount:int		= 0;
		
		/**
		 * 	@private
		 */
		private var currentFrame:int	= 0;
		
		/**
		 * 	@constructor
		 */
		public function StopMotionOverlay():void {
			
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterExecuteFunction('start', 'start'),
				new ParameterBoolean('record', 'record', 1),
				new ParameterInteger('frameDelay', 'frameDelay', 1, 24, frameDelay),
				new ParameterInteger('maxframes', 'frames', 12, 640, maxframes),
				new ParameterInteger('totalFrames', 'recorded', 0, 0, totalFrames),
				new ParameterBlendMode('blend', 'frame blend', blend),
				new ParameterNumber('alph', 'alpha', 0, 1, 1)
			);
			
			// don't allow editing
			parameters.getParameter('totalFrames').setMetaData('editable', false);

		}
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {
			
			if (layer && recording && --frameCount <= 0) {

				if (frames.length >= maxframes) {

					currentFrame = (currentFrame + 1) % frames.length;
					bmp	= frames[currentFrame];

					var bmp2:BitmapData	= bmp.clone();
					bmp.copyPixels(layer.source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
					bmp.draw(bmp2, null, new ColorTransform(1,1,1,alph), blend);
					
				} else {
					
					frames.push(layer.source.clone());
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