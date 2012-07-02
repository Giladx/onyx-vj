/**
 * Copyright demouth ( http://wonderfl.net/user/demouth )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/t6QL
 */

// forked from demouth's mosha mosha
// forked from demouth's ã‚¯ãƒªã‚¹ãƒžã‚¹ãƒªãƒ¼ã‚¹çš„ãªä½•ã‹
package 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Dopa extends Patch
	{
		
		public var numPc:int = 400;
		public var pc:Vector.<Particle> = new Vector.<Particle>();
		public var bitmap:Bitmap = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT , true , 0xFFFFFFFF));
		public var shape:Shape = new Shape();
		
		private var snd:Sound;
		private var FFTswitch:Boolean = true;
		private var vol:Number;
		private var bytes:ByteArray;
		private var sprite:Sprite;
		
		public function Dopa () 
		{
			sprite = new Sprite();
			bytes = new ByteArray();
			//play("http://level0.kayac.com/images/murai/Digi_GAlessio_-_08_-_ekiti_son_feat_valeska_-_april_deegee_rmx.mp3");
			
			
			sprite.addChild(bitmap);
			sprite.addChild(shape);

			
		}
		
		/*private function play(sndUrl:String):void {
			snd = new Sound();
			var context:SoundLoaderContext = new SoundLoaderContext(10, true);
			var req:URLRequest = new URLRequest(sndUrl);
			snd.load(req, context);
			var sndChannel:SoundChannel = new SoundChannel();
			sndChannel = snd.play(0, 0);
		}*/
		
		override public function render(info:RenderInfo):void
		{
			
			deletePc();
			
			bytes.clear();
			SoundMixer.computeSpectrum(bytes, FFTswitch, 0);
			vol = bytes.readFloat();
			if(vol > 1)createPc()
			else pc.push(getPc());
			
			move();
			rendering(shape.graphics);
			bitmap.bitmapData.applyFilter( bitmap.bitmapData,bitmap.bitmapData.rect,new Point(),new BlurFilter(20 , 20));
			draw(getMatrix(0));
			draw(getMatrix(Math.PI));
			draw(getMatrix(Math.PI / 2));
			draw(getMatrix(Math.PI / 2 + Math.PI));
			
			info.render(sprite);
		}
		
		private function draw(matrix:Matrix):void
		{
			bitmap.bitmapData.draw(shape , matrix);
		}
		
		private function getMatrix(rotate:Number):Matrix
		{
			var mat:Matrix = new Matrix();
			mat.translate(-232, -232);
			mat.rotate(rotate);
			mat.translate(232, 232);
			return mat;
		}
		
		private function rendering(g:Graphics):void
		{
			var g:Graphics = g;
			g.clear();
			
			var t:Number = Math.abs( Math.sin(getTimer() / 1000) ) ;
			var c:ColorHSV = new ColorHSV( getTimer()*0.01 , 0.9, t );
			
			var l:int = pc.length - 1;
			var i:int = 0;
			for (i = 0; i < l; i++) 
			{
				var p:Particle = pc[i];
				var radius:Number = ( Math.abs(p.sx) + Math.abs(p.sy) ) * 0.5 ;
				
				g.beginFill(c.value , 1);
				g.drawCircle(p.x , p.y , radius + 1 );
				g.endFill();
			}
		}
		
		private function move():void
		{
			var l:int = pc.length - 1;
			var i:int = 0;
			for (i = 0; i < l; i++) 
			{
				var p:Particle = pc[i];
				var pw:Number = Math.sqrt( p.sx * p.sx + p.sy * p.sy ) ;
				p.sx += p.ax;
				p.sy += p.ay;
				p.ax = 0;
				p.ay = 0;
				p.x += p.sx + Math.sin(getTimer()*0.005)*(pw+1)*0.4;
				p.y += p.sy + Math.cos(getTimer()*0.005)*(pw+1)*0.4;
				p.sx *= 0.9;
				p.sy *= 0.9;
				
				if (
					(Math.abs(p.sx) < 0.05)
					&&
					(Math.abs(p.sy) < 0.05)
				)
				{
					p.end = true;
				}
			}
		}
		
		private function createPc():void
		{
			var l:int = numPc;
			var i:int = 0;
			for (i = pc.length; i < l; i++) pc.push(getPc());
		}
		
		private function getPc():Particle
		{
			var p:Particle = new Particle();
			
			var pow:Number = Math.random() * 10;
			var angle:Number = Math.PI * 2 * Math.random();
			var x:Number = Math.sin(angle) * pow;
			var y:Number = Math.cos(angle) * pow;
			
			p.x = Math.cos(getTimer()*0.0008)*200 + DISPLAY_WIDTH/2;
			p.y = Math.sin(getTimer()*0.0010)*200 + DISPLAY_HEIGHT/2;
			p.ax = x;
			p.ay = y;
			p.sx = 0;
			p.sy = 0;
			
			p.end = false;
			return p;
		}
		
		
		private function deletePc():void
		{
			var l:int = pc.length - 1;
			var i:int = 0;
			for (i = l; i >= 0; i--) 
			{
				var p:Particle = pc[i];
				if (p.end)
				{
					pc.splice(i, 1);
					p = null;
				}
			}
		}
		
	}
	
}
class Particle
{
	
	public var x:Number = 0;
	public var y:Number = 0;
	public var ax:Number = 0;
	public var ay:Number = 0;
	public var sx:Number = 0;
	public var sy:Number = 0;
	
	public var end:Boolean = false;
	
}