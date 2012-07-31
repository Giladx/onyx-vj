/**
 * Copyright abakane ( http://wonderfl.net/user/abakane )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/qJpz
 */

package
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Shaaa extends Patch
	{
		/** const */
		public static const SC:Number = DISPLAY_WIDTH*0.5;
		public static const SM:Number = DISPLAY_HEIGHT*0.5;
		public static const MAX:int = 150;
		public static const DELAY:int = 100;
		
		/** display object */
		private var _container:Sprite;
		private var sprite:Sprite;
		private var _bg:Shape;
		
		/** var */
		private var lights:Vector.<Light>;
		private var timer:Timer;
		private var r:Number;
		private var ct:ColorTransform;
		
		public function Shaaa()
		{

			Light.init();
			lights = new Vector.<Light>();
			r = Math.random()*360;
			ct = new ColorTransform();
			
			var m:Matrix = new Matrix();
			var a:int = Math.min( DISPLAY_WIDTH, DISPLAY_HEIGHT);
			m.createGradientBox( a, a, 0, (DISPLAY_WIDTH-a)*0.5, (DISPLAY_HEIGHT-a)*0.5);
			_bg = new Shape();
			_bg.filters = [new GlowFilter( 0x0, 0.3, 128, 128, 1, 2, true)];
			_bg.graphics.beginGradientFill( GradientType.RADIAL, [0xFFFFFF, 0x808080], [1,1], [0x0,0xFF], m);
			_bg.graphics.drawRect( 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			_bg.graphics.endFill();
			sprite = new Sprite();
			_container = new Sprite();
			_container.x = SC;
			_container.y = SM;
			sprite.addChild( _bg );
			sprite.addChild( _container );
			
			timer = new Timer(DELAY);
			timer.addEventListener( TimerEvent.TIMER, onTimer);
			timer.start();
			onTimer();

		}
		
		/** UPDATE */
		override public function render(info:RenderInfo):void 
		{
			var l:Light;
			if( lights.length < MAX )
			{
				l = new Light();
				lights.push( l );
				_container.addChild( l );
			}
			for each( l in lights) l.update();
			info.render(sprite);
		}
		
		/** TIMER */
		private function onTimer( e:TimerEvent=null ):void
		{
			r += 1;
			ct.redMultiplier = Math.sin(r*Math.PI/180);
			ct.greenMultiplier = Math.sin((r+120)*Math.PI/180);
			ct.blueMultiplier = Math.sin((r+240)*Math.PI/180);
			this.transform.colorTransform = ct;
		}
		
		
	}
}


import flash.display.*;
import flash.geom.*;
import flash.filters.*;

class Light extends Sprite
{
	/** STATIC */
	public static const AR:int = 2;
	public static const BR:int = 10;
	public static const RADIUS:int = 225;
	public static const COL:int = 0xFFFFFF;
	public static const BLUR:int = 8;
	public static var source:BitmapData;
	
	/** Display Object */
	private var _bmp:Bitmap;
	
	/** var */
	private var rad:Number;
	private var a:Number;
	private var v:Number;
	
	public function Light()
	{
		super();
		this.x = Math.random()*800;
		this.y = Math.random()*600;
		this._bmp = new Bitmap(source);
		addChild( _bmp );
		reset();//
	}
	
	/** UPDATE */
	public function update():void
	{
		v += a;
		this.scaleX = this.scaleY += v*0.02;
		this.x += Math.cos(rad)*v;
		this.y += Math.sin(rad)*v;
		if( this.x > Shaaa.SC || this.x < -Shaaa.SC || this.y > Shaaa.SM || this.y < -Shaaa.SM) reset();
	}
	
	/** REST */
	private function reset():void
	{
		var r:Number = Math.random()*360;
		this.alpha = Math.random()*0.5 + 0.5;
		this.scaleX = this.scaleY = 0.05;
		this.rotation = r
		this.rad = r/180*Math.PI;
		this.a = Math.random()*5;
		this.x = Math.cos(rad)*RADIUS/a;
		this.y = Math.sin(rad)*RADIUS/a;
		_bmp.scaleX = _bmp.scaleY = a*0.1;
		_bmp.y = -(BR+BLUR*0.5)*_bmp.scaleX;
		v = 0;
	}
	
	/** STATIC INIT */
	public static function init():void
	{
		var m:Matrix = new Matrix();
		m.createGradientBox( RADIUS*0.5, BR*2, 0, 0, 0);
		var s:Sprite = new Sprite();
		s.filters = [new BlurFilter(BLUR,BLUR,3)];
		s.graphics.beginGradientFill( GradientType.LINEAR, [COL, COL, COL], [0, 1, 0], [0x0,0x80,0xFF], m); 
		s.graphics.moveTo( 0, -AR);
		s.graphics.lineTo( RADIUS*0.5, -BR);
		s.graphics.lineTo( RADIUS*0.5, BR);
		s.graphics.lineTo( 0, AR);
		s.graphics.lineTo( 0, -AR);
		s.graphics.endFill();
		m = new Matrix();
		m.tx = BLUR*0.5;
		m.ty = BR+BLUR*0.5;
		source = new BitmapData( s.width+BLUR, s.height+BLUR, true, 0x0);
		source.draw( s, m);
	}
	
}