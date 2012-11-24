package 
{
	import core.Onyx;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	[SWF(width=640, height=960,backgroundColor=0xffff11)]
	public class OnyxMobile extends Sprite
	{
		public function OnyxMobile()
		{
			super();
			
			// autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			Starling.handleLostContext = true;//TRUE on android, FALSE on iOs
			var star:Starling = new Starling(Onyx, stage);
			star.showStats = true;
			star.start();
		}
	}
}