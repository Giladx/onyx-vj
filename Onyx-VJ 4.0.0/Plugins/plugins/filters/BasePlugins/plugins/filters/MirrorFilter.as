package plugins.filters {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;


	public final class MirrorFilter extends Filter implements IBitmapFilter {
		
		public var horiz:Boolean	= true;
		
		public function MirrorFilter():void {
			parameters.addParameters(
				new ParameterBoolean('horiz', 'horiz')
			);
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			if (horiz) {
				var rect:Rectangle = DISPLAY_RECT.clone();
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