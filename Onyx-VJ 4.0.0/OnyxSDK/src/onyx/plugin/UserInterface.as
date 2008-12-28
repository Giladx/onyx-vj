package onyx.plugin {
	
	import flash.display.*;
	
	import onyx.parameter.*;
	
	/**
	 * 
	 */
	public final class UserInterface {
		
		/**
		 * 	@private
		 */
		private static var api:UserInterfaceAPIImplementor;
		
		/**
		 * 
		 */
		public static function initializeAPI(inAPI:UserInterfaceAPIImplementor):void {
			api = inAPI;
		}
		
		/**
		 * 
		 */
		public static function createControl(param:Parameter):DisplayObject {
			return new Sprite();
		}
		
		/**
		 * 
		 */
		public static function openSaveDialog(handler:Function):void {
			api.openSaveDialog(handler);
		}
	}
}