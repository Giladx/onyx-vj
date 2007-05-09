package filters {
	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;

	public final class MirrorFilter extends Filter implements IBitmapFilter {
		
		public var horiz:Boolean	= true;
		
		public function MirrorFilter():void {
			super(
				true,
				new ControlBoolean('horiz', 'horiz')
			);
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			if (horiz) {
				var rect:Rectangle = BITMAP_RECT.clone();
				rect.width /= 2;
	
				var matrix:Matrix = new Matrix();
				matrix.a	= -1;
				matrix.tx	= rect.width * 2;
				
				bitmapData.draw(bitmapData, matrix, null, null, rect);
			} else {
				rect = bitmapData.rect;
				rect.height /= 2;
	
				matrix		= new Matrix()
				matrix.d	= -1;
				matrix.ty	= rect.height * 2;
				
				bitmapData.draw(bitmapData, matrix, null, null, rect);
			}
		}
	}
}