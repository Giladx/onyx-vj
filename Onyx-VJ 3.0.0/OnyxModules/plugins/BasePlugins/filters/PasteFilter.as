package filters {
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.plugin.*;

	public final class PasteFilter extends Filter implements IBitmapFilter {
		
		private var _source:BitmapData;
		private var _transform:ColorTransform;
		private var _count:int					= 0;
		private var _frameDelay:int				= 2;
		
		public function PasteFilter():void {
			super(
				false
			)
		}
		
		override public function initialize():void {
			_source		= BASE_BITMAP();
			_transform	= new ColorTransform();
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			
			// _source.fillRect(_source.rect, 0x00000000);
			_source.applyFilter(_source, BITMAP_RECT, POINT, new BlurFilter(4,4));
			
			var transform:ColorTransform	= new ColorTransform(1,1,1,.2);
			var orig:ColorTransform			= new ColorTransform(1,1,1,.8);
			
			_source.draw(bitmapData, null, transform, 'overlay', null);
			
			bitmapData.draw(_source, null, orig);
		}
	}
}