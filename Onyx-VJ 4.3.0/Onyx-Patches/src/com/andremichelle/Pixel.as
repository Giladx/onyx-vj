package com.andremichelle { 
	public class Pixel
	{
		public var sx: Number;
		public var sy: Number;
		public var tx: Number;
		public var ty: Number;
		
		public var vx: Number;
		public var vy: Number;
		
		public var color: int;
		
		public function Pixel( sx: Number, sy: Number, color: uint = 0xffffffff )
		{
			this.sx = tx = sx;
			this.sy = ty = sy;
			
			vx = vy = 0;
			
			this.color = color;
		}
	}
}
