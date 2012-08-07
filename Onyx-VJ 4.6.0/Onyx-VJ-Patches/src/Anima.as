/**
 * Copyright munegon ( http://wonderfl.net/user/munegon )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/ppHI
 */

package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Anima extends Patch {
		private const XMID:int = DISPLAY_WIDTH*0.5;
		private const YMID:int = DISPLAY_HEIGHT*0.5;
		private const ANIMA_R:int = 64;
		
		private var n:int = 5;
		private var theta_base:int = 0;
		private var anima_arr:Array = [];
		private var bd:BitmapData;
		private var sprite:Sprite;
		
		private var fade_ctf:ColorTransform = new ColorTransform( 1, 1, 1, 0.4 );
		private var ctf_arr:Array = [
			[ 1, 0.3, 0.5 ],
			[ 1, 1, 0.4 ],
			[ 0.4, 1, 0.4 ],
			[ 0.3, 0.8, 1 ],
			[ 0.3, 0.2, 1 ],
			[ 1, 0.4, 1 ],
			[ 1, 1, 1 ]
		];
		
		public function Anima() {
			sprite = new Sprite();
			bd = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x000000 );
			sprite.addChild( new Bitmap( bd ) );
			
			var sh:Shape = new Shape();
			var g:Graphics = sh.graphics;
			g.beginFill( 0xffffff, 0.6 );
			g.drawCircle( ANIMA_R, ANIMA_R, 48 );
			g.endFill();
			
			var anima:BitmapData = new BitmapData( ANIMA_R*2, ANIMA_R*2, true, 0x00000000 );
			anima.draw( sh );
			anima.applyFilter( anima, anima.rect, anima.rect.topLeft, new BlurFilter( 32, 32 ) );
			
			for ( var i:int = 0; i < ctf_arr.length; ++i ) {
				var a:BitmapData = anima.clone();
				var ctf:Array = ctf_arr[i];
				a.colorTransform( a.rect, new ColorTransform( ctf[0], ctf[1], ctf[2] ) );
				anima_arr.push( a );
			}
			
			anima.dispose();
			anima = null;
		}
		
		override public function render(info:RenderInfo):void {
			if ( --n == 0 ) {
				n = 5;
				theta_base = ( theta_base + 110 + 20*Math.random() ) % 360;
				createAnima();
			}
			
			bd.lock();
			bd.colorTransform( bd.rect, fade_ctf );
			bd.unlock();
			info.render(sprite);
		}

		private function createAnima():void {
			var a:BitmapData = anima_arr[ Math.floor( anima_arr.length * Math.random() ) ];
			
			var sp:Sprite = new Sprite();
			var cnt:int = 100;
			var pt:Point = new Point();
			var mtx:Matrix = new Matrix();
			var theta:int = theta_base + Math.floor( 90*Math.random() );
			var rad:Number = theta * Math.PI/180;
			var ctf:ColorTransform = new ColorTransform();
			var r:Number;
			
			var enterframe:Function = function( e:Event ):void {
				theta = ( theta + 6 ) % 360;
				r = 3*cnt;
				
				rad = ( theta - 30*( 0.5 + cnt/100 ) ) * Math.PI/180;
				mtx.identity();
				mtx.translate( -ANIMA_R, -ANIMA_R );
				mtx.scale( cnt/200, cnt/200 );
				mtx.translate( XMID + r*Math.cos( rad ), YMID + r*Math.sin( rad ) );
				ctf.alphaMultiplier = 0.6;
				bd.draw( a, mtx, ctf, BlendMode.ADD );
				
				rad = ( theta - 20*( 0.5 + cnt/100 ) ) * Math.PI/180;
				mtx.identity();
				mtx.translate( -ANIMA_R, -ANIMA_R );
				mtx.scale( 2*cnt/200, 2*cnt/200 );
				mtx.translate( XMID + r*Math.cos( rad ), YMID + r*Math.sin( rad ) );
				ctf.alphaMultiplier = 0.8;
				bd.draw( a, mtx, ctf, BlendMode.ADD );
				
				rad = theta * Math.PI/180;
				mtx.identity();
				mtx.translate( -ANIMA_R, -ANIMA_R );
				mtx.scale( 3*cnt/200, 3*cnt/200 );
				mtx.translate( XMID + r*Math.cos( rad ), YMID + r*Math.sin( rad ) );
				bd.draw( a, mtx, null, BlendMode.ADD );
				
				if ( --cnt == 0 ) {
					sp.removeEventListener( e.type, arguments.callee );
					sprite.removeChild( sp );
					sp = null;
				}
			}
			sp.addEventListener( Event.ENTER_FRAME, enterframe, false, 5 );
			sprite.addChild( sp );
		}
	}
}