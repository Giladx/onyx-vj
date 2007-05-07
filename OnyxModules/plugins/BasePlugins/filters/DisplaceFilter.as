package filters
{
	import flash.display.BitmapData;
	import flash.filters.DisplacementMapFilter;
	
	import onyx.constants.*;
	import onyx.controls.ControlLayer;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	import onyx.layer.ILayer;

	public final class DisplaceFilter extends Filter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var _layer:ILayer;

		/**
		 * 	@private
		 */
		private var _filter:DisplacementMapFilter;
		
		/**
		 * 	@constructor
		 */
		public function DisplaceFilter():void {
			super(true,
				new ControlLayer('layer', 'layer')
			);
		}
		
		public function set layer(value:ILayer):void {
			_layer = value;
			_filter = new DisplacementMapFilter(value.rendered, POINT, 1, 1, 1, 1, 'wrap', 0xFF0000, 1);
		}
		
		public function get layer():ILayer {
			return _layer;
		}
		
		public function applyFilter(source:BitmapData):void {
			if (_filter) {
				source.applyFilter(source, BITMAP_RECT, POINT, _filter);
			}
		}
		
		override public function dispose():void {
			_layer = null;
			_filter = null;
		}
		
	}
}