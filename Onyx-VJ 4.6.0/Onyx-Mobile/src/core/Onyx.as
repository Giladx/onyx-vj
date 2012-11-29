package core
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Onyx extends Sprite
	{
		private var connect:Button;
		public static var nav:ScreenNavigator;
		public static const GLOBAL:String = "Global";
		public static const LAYER:String = "Layer";
		public static const BGNDCOLOR:String = "BgndColor";
		public function Onyx()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			var theme:MetalWorksMobileTheme = new MetalWorksMobileTheme(stage);
			
			nav = new ScreenNavigator();
			addChild(nav);
			
			var globalView:ScreenNavigatorItem = new ScreenNavigatorItem(GlobalView);
			nav.addScreen(GLOBAL, globalView);
			
			var bgndColorView:ScreenNavigatorItem = new ScreenNavigatorItem(BgndColorView);
			nav.addScreen(BGNDCOLOR, bgndColorView);
			
			var layerView:ScreenNavigatorItem = new ScreenNavigatorItem(LayerView);
			nav.addScreen(LAYER, layerView);
			
			nav.showScreen(GLOBAL);
			
			var transition:ScreenSlidingStackTransitionManager = new ScreenSlidingStackTransitionManager(nav);
			/*addEventListener(Event.ENTER_FRAME, update);
			connect = new Button(Texture.fromColor(100,50,0xaf89e1), "Connect", Texture.fromColor(100,50,0x7b5aa6));
			*/

		}
		
		
		
		private function update(e:Event):void
		{
			
		}
		private function destroy(e:Event):void
		{
			// TODO add this to main as
			//true removes event listeners;
			connect.removeFromParent(true);
		}
	}
}