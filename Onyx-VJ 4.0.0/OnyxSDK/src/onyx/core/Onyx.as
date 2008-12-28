package onyx.core {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.asset.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	public final class Onyx {
		
		/**
		 * 
		 */
		public static function initialize(stage:Stage, width:int, height:int, display:Class, adapter:IAssetAdapter):DisplayObject {
			
			// store stage
			DISPLAY_STAGE		= stage;
			
			// set width and height
			setDisplayDimensions(width, height);
			
			// create tempo
			Tempo				= new TempoImplementer();
			
			// create display
			Display				= new display();
			
			return Display as DisplayObject;
		}
		
		/**
		 * 
		 */
		public static function registerPlugin(plugin:Plugin):void {
			
		}
		
		/**
		 * 
		 */
		public static function registerFont(font:Class):void {
			
		}
		
		/**
		 * 	Sets the display dimensions
		 */
		public static function setDisplayDimensions(width:int, height:int):void {
			DISPLAY_RECT.width	= DISPLAY_WIDTH		= width;
			DISPLAY_RECT.height	= DISPLAY_HEIGHT	= height
		}
	}
}