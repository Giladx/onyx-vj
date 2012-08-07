/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/fCiQ
 */


package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class PerfectPulse extends Patch {
		
		private static const PARTICLE_MAX:Number = 1200;  //1500;
		
		private var canvas:BitmapData;
		private var fxbmd:BitmapData;
		private var particles:Array;
		private var cTrs:ColorTransform;
		private var cTrs2:ColorTransform;
		private var blur:BlurFilter;
		private var rect:Rectangle;
		private var point:Point;
		private var testCounter:Number = 0;            
		private var mx:Number;
		private var my:Number;
		private var sprite:Sprite;
		private var _color:uint = 0xFFFFFF00;
		
		public function PerfectPulse() {
			
			parameters.addParameters(
				new ParameterColor('color', 'draw color', _color)
			)
			sprite = new Sprite();
			cTrs  = new ColorTransform(  1.0, 1.0, 1.0, 0.95  );  // 0.4, 0.0, 0.95, 0.95  );  //1, 1, 1, 0.95  );
			cTrs2 = new ColorTransform(  1.0, 1.0, 1.0, 0.95  );  //  0.6, 0.0, 0.95, 0.95  );  //1, 1, 1, 0.95  );
			blur  = new BlurFilter( 16,16,2 ); 
			rect  = new Rectangle( 0,0,DISPLAY_WIDTH,DISPLAY_HEIGHT );
			point = new Point( 0,0 );
			
			canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT,true, 0xFF000000);
			sprite.addChild(new Bitmap(canvas));
			fxbmd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT);
			sprite.addChild(new Bitmap(fxbmd));
			
			particles = [];
			createParticle();
	
		}
		
		private function createParticle():void {
			var invertNum:Number = int(Math.random()*2-1+1)-1;
			for(var i:int=0; i<PARTICLE_MAX; i++){
				var p:Particle = new Particle();
				p.x  = Math.sin(i/180)*20 + DISPLAY_WIDTH /2;  //10 + WIDTH/2;  //*130 + WIDTH/2;
				p.y  = Math.cos(i/180)*20 + DISPLAY_HEIGHT/2;  //*10 + HEIGHT/2;  //*130 + HEIGHT/2;
				p.tx = ( Math.sin(i/180) * Math.PI );
				p.ty = ( Math.cos(i/180) * Math.PI );
				//p.tx = (Math.sin(i/180)*Math.PI+Math.random()*2-1) * Math.random();
				//p.ty = (Math.cos(i/180)*Math.PI+Math.random()*2-1) * Math.random();
				//p.c = 0xff;//0xFFFFFF;// * Math.random();  //0x0;
				particles.push(p);  
			}
		}
		
		override public function render(info:RenderInfo):void 
		{			
		
			canvas.lock();
			canvas.colorTransform(rect, cTrs);
			
			for(var i:int=0; i<particles.length; i++)
			{
				particles[i].x += particles[i].tx;
				particles[i].y += particles[i].ty;
				
				//canvas.setPixel32( particles[i].x,particles[i].y,0xFF000000 );  //0xff000000*Math.random());
				canvas.setPixel32( particles[i].x,particles[i].y, 0xff000000 + color ); 
				
				if(  particles[i].x > DISPLAY_WIDTH || particles[i].x <0 || particles[i].y > DISPLAY_HEIGHT || particles[i].y < 0  ) 
				{    
					particles.splice( i,6 );
				}
			}
			canvas.lock();
			fxbmd .lock();                
			fxbmd.draw(canvas);
			fxbmd.colorTransform(rect, cTrs2);
			fxbmd.applyFilter(fxbmd, rect, point, blur);
			canvas.unlock();
			fxbmd .unlock();
			
			if(  particles.length < PARTICLE_MAX/3  )  //< PARTICLE_MAX/2  ) 
			{
				createParticle();                    
			}
			
			info.render( sprite );		
		}
		public function set color(value:uint):void 
		{
			_color = value;
		}
		public function get color():uint 
		{
			return _color;
		}
	}
}


dynamic class Particle 
{
	public var x:Number;
	public var y:Number;
	public var tx:Number;
	public var ty:Number;
	public var g:Number;
	public var c:uint;
	public function Particle()
	{
		c = 0xFFFFFF * Math.random();
	}
	
	
}
