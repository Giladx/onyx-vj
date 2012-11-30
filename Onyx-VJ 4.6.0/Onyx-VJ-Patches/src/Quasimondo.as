package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Quasimondo extends Patch {
		private var triangles:Vector.<Point> = new Vector.<Point>;
		private var cornerNum:int = 3;
		private var defaultLength:Number = 200;
		private var centerX:Number = 232;
		private var centerY:Number = 232;
		private var s1:Sprite = new Sprite();
		private var g1:Graphics = s1.graphics;
		private var bitmapData:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x0);
		private var b1:Bitmap = new Bitmap(bitmapData);
		public function Quasimondo() {
			// write as3 code here..
			for( var i:int = 0; i < cornerNum; i++ ){
				triangles.push( new Point(
					defaultLength * Math.cos( 2 * Math.PI * i / cornerNum ) + centerX,
					defaultLength * Math.sin( 2 * Math.PI * i / cornerNum ) + centerY
				) );
			}
			g1.lineStyle(0, 0, 0.3);
			g1.beginFill(0xFFFFFFFF * Math.random(), 0.2);
			g1.moveTo(triangles[cornerNum-1].x, triangles[cornerNum-1].y);
			for( i = 0; i < cornerNum; i++ ){
				g1.lineTo(triangles[i].x, triangles[i].y);
			}
			//this.addChild( b1 );
			s1.x = s1.y = 232;
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			
		}
		private function onMouseDown(e: MouseEvent):void{
		
		
			divideTriangle();
		}
		override public function render(info:RenderInfo):void		
		{			
			info.render(b1);
		}
		private function divideTriangle():void{
			var n:int = Math.random() * (triangles.length/3);
			n *= Math.random() * Math.random(); // weight on bigger triangles
			n *= 3;
			var pointA:Point = triangles[n];
			var pointB:Point = triangles[n+1];
			var pointC:Point = triangles[n+2];
			var s:Number = Math.random();
			var t:Number = Math.random();
			var u:Number = Math.random();
			s = t = u = 0.5;
			var pointAB:Point = pointB.subtract(pointA);
			var pointBC:Point = pointC.subtract(pointB);
			var pointCA:Point = pointA.subtract(pointC);
			var pointP:Point = new Point( pointA.x + s * pointAB.x, pointA.y + s * pointAB.y );
			var pointQ:Point = new Point( pointB.x + t * pointBC.x, pointB.y + t * pointBC.y );
			var pointR:Point = new Point( pointC.x + u * pointCA.x, pointC.y + u * pointCA.y );
			var color:uint = 0xFFFFFFFF * Math.random();
			g1.lineStyle(0, color);
			g1.beginFill(color, 0.5);
			g1.moveTo( pointR.x, pointR.y );
			g1.lineTo( pointP.x, pointP.y );
			g1.lineTo( pointQ.x, pointQ.y );
			g1.lineTo( pointR.x, pointR.y );
			bitmapData.draw(s1);
			g1.clear();
			
			triangles.splice( n, 3 );
			triangles.push( pointA );
			triangles.push( pointP );
			triangles.push( pointR );
			triangles.push( pointB );
			triangles.push( pointQ );
			triangles.push( pointP );
			triangles.push( pointC );
			triangles.push( pointR );
			triangles.push( pointQ );
			triangles.push( pointP );
			triangles.push( pointQ );
			triangles.push( pointR );
		}
	}
}