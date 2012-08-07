/**
 * Copyright TAK.S ( http://wonderfl.net/user/TAK.S )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rHtc
 */

// forked from TAK.S's forked from: forked from: forked from: Dumping Graphics
// forked from Takayuki.Yamazaki's forked from: forked from: Dumping Graphics
// forked from ratch's forked from: Dumping Graphics
// forked from clockmaker's Dumping Graphics
/**
 *    å¤‰æ›´ç‚¹ã¯è‰²ãŒå°‘ã—ãšã¤æ·¡ããªã‚‹ã ã‘ã€‚
 **/
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	import frocessing.color.ColorHSV;
	import flash.geom.ColorTransform;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * Dumping Graphics
	 * ãƒžã‚¦ã‚¹ã‚¯ãƒªãƒƒã‚¯ã™ã‚‹ã¨æ‹¡å¤§ã™ã‚‹ã‚ˆ
	 * @author yasu
	 */
	public class DumpingGraphics extends Patch
	{
		private static const MAX:int = 2;
		private var mx:int = 320;
		private var my:int = 240;
		private var ac:Number = 0.02;
		private var bmd:BitmapData;
		
		private var bmp:Bitmap;
		private var canvas:Vector.<Sprite> = new Vector.<Sprite>(MAX, true);
		private var captureMatrix:Matrix = new Matrix();
		private var colors:Vector.<Array> = new Vector.<Array>(MAX, true);
		private var de:Number = 0.95;
		private var nowX:Vector.<Number> = new Vector.<Number>(MAX, true);
		private var nowY:Vector.<Number> = new Vector.<Number>(MAX, true);
		
		private var oldP:Point = new Point(DISPLAY_WIDTH, DISPLAY_HEIGHT);
//		private var oldP:Point = new Point(DISPLAY_WIDTH / 2, DISPLAY_HEIGHT / 2);
		private var speed:Number = 1;
		private var stack:Vector.<Array> = new Vector.<Array>(MAX, true);
		private var target:Vector.<Point> = new Vector.<Point>(MAX, true);
		private var timer:Vector.<Timer> = new Vector.<Timer>(MAX, true);
		private var vx:Vector.<Number> = new Vector.<Number>(MAX, true);
		private var vy:Vector.<Number> = new Vector.<Number>(MAX, true);
		//private var zoom:Number = 1;
		
		//private var bmpClrTransform:ColorTransform = new ColorTransform( 1, 1, 1, 1, -1, -1, -1 );
		private var bmpClrTransform:ColorTransform = new ColorTransform( 0.9999, 0.9999, 0.9999 );
		
		
		public function DumpingGraphics()
		{
			bmp = new Bitmap(bmd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0xFFfffff));
			//bmp.scaleX = bmp.scaleY = 1 / 2;
/*			addChild(bmp = new Bitmap(bmd = new BitmapData(DISPLAY_WIDTH * 2, DISPLAY_HEIGHT * 2, true, 0xFFfffff)));
			bmp.scaleX = bmp.scaleY = 1 / 2;*/
			
			for (var i:int = 0; i < MAX; i++)
			{
				addChild(canvas[ i ] = new Sprite);
				
				colors[ i ] = [];
				var j:int = 10;
				while (j--)
				{
					var color:ColorHSV = new ColorHSV(Math.random() * 30 + i * 15 + 180, Math.random(), 1);
					colors[ i ].push(color.value);
				}
				
				target[ i ] = new Point(DISPLAY_WIDTH * Math.random(), DISPLAY_HEIGHT * Math.random());
				
				stack[ i ] = [];
				
				vx[ i ] = 0;
				vy[ i ] = 0;
				
				nowX[ i ] = DISPLAY_WIDTH;// / 2;
				nowY[ i ] = DISPLAY_HEIGHT;// / 2;
				
				timer[ i ] = new Timer(30 * i + 50);
				timer[ i ].addEventListener(TimerEvent.TIMER, tick);
				timer[ i ].start();
			}
			
			captureMatrix.scale(2, 2);
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onDown);
			addEventListener(MouseEvent.MOUSE_MOVE, _onMove);
			addEventListener(MouseEvent.MOUSE_UP, _onUp);
		}
		
		private function _onMove(e:MouseEvent):void
		{
			mx = e.localX; 
			my = e.localY;
		}
		
		private function _onDown(e:MouseEvent):void
		{
			mx = e.localX; 
			my = e.localY;
			//zoom = 2;
		}
		
		private function _onUp(e:MouseEvent):void
		{
			mx = e.localX; 
			my = e.localY;
			//zoom = 1;
		}
		
		override public function render(info:RenderInfo):void 
		{
			bmd.lock();
			
			for (var i:int = 0; i < MAX; i++)
			{
				var oldX:Number = nowX[ i ];
				var oldY:Number = nowY[ i ];
				
				//åŠ é€Ÿåº¦é‹å‹•
				vx[ i ] += (target[ i ].x - nowX[ i ]) * ac;
				vy[ i ] += (target[ i ].y - nowY[ i ]) * ac;
				
				nowX[ i ] += vx[ i ];
				nowY[ i ] += vy[ i ];
				
				//æ¸›è¡°å‡¦ç†
				vx[ i ] *= de;
				vy[ i ] *= de;
				
				stack[ i ].push([ nowX[ i ], nowY[ i ], oldX, oldY ]);
				if (stack[ i ].length > 10)
					stack[ i ].shift();
				
				canvas[ i ].graphics.clear();
				
				for (var j:int = 0; j < stack[ i ].length; j++)
				{
					var o:Array = stack[ i ][ j ];
					var rand:Number = Math.random();
					
					canvas[ i ].graphics.beginFill(colors[ i ][(colors.length * Math.random()) >> 0 ], 0.5 * rand);
					
					var r:Number = Math.sqrt((o[ 0 ] - o[ 2 ]) * (o[ 0 ] - o[ 2 ]) + (o[ 1 ] - o[ 3 ]) * (o[ 1 ] - o[ 3 ]))
					r *= 0.75;
					r *= rand * rand;
					canvas[ i ].graphics.drawCircle(o[ 0 ], o[ 1 ], r);
				}
				
				target[ i ].x += (DISPLAY_WIDTH  - target[ i ].x) * ac;
				target[ i ].y += (DISPLAY_HEIGHT - target[ i ].y) * ac;
/*				target[ i ].x += (DISPLAY_WIDTH / 2 - target[ i ].x) * ac;
				target[ i ].y += (DISPLAY_HEIGHT / 2 - target[ i ].y) * ac;*/
				
				bmd.draw(canvas[ i ], captureMatrix);
			}
			bmd.colorTransform( bmd.rect, bmpClrTransform );
			bmd.unlock();
			
			oldP.x += (target[ 0 ].x - oldP.x) * 0.05;
			oldP.y += (target[ 0 ].y - oldP.y) * 0.05;
			
			speed += (1 - speed) * 0.1;
			//speed += (zoom - speed) * 0.1;
			
			var mt:Matrix = new Matrix();
			mt.translate(-oldP.x, -oldP.y);
			mt.scale(speed, speed);
			mt.translate(oldP.x, oldP.y);
			this.transform.matrix = mt;
			info.render(bmp);
		}
		
		private function tick(e:TimerEvent):void
		{
			for (var i:int = 0; i < MAX; i++)
			{
				if (timer[ i ] == e.currentTarget)
					break;
			}
			
			target[ i ].x = mx;
			target[ i ].y = my;
		}
	}
}