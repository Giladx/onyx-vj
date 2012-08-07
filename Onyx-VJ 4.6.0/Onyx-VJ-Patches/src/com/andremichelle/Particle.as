package com.andremichelle
{
	public class Particle
	{
		public var sx: Number;
		public var sy: Number;
		public static var minLife:int = 20;
		public static var maxLife:int = 120;
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var life:int = 0;
		public var maxLife:int = 0;
		public var e:Number = 0;
		public var color:int = 0;
		
		public function Particle( sx: Number = 0, sy: Number = 0 )
		{
			this.sx = sx;
			this.sy = sy;
		}
	}
}