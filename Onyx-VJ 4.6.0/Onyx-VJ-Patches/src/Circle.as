package 
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	public class Circle extends Sprite
	{
		public var realx:int;
		public var realy:int;
		public function Circle( color:uint, size:int ):void
		{
			graphics.beginFill( color );
			graphics.drawCircle( 0, 0, size );
			graphics.endFill();
			filters = [new GlowFilter(0xffffff, .5)];
		}
	}
}
