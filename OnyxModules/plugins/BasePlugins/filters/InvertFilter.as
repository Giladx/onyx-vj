package filters {
	
	import flash.display.*;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;

	public final class InvertFilter extends Filter implements IBitmapFilter {
		
		private var _arr:Array = [
			-1, 0, 0, 0, 255,
			0 ,-1, 0, 0, 255,
			0, 0, -1, 0, 255,
			0, 0, 0, 1, 0
		]
		
		public function InvertFilter():void {
			super(
				true
			);
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			bitmapData.applyFilter(bitmapData, BITMAP_RECT, POINT, new ColorMatrixFilter(_arr));
		}
		
	}
}