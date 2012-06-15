/**
 * Copyright su8erlemon ( http://wonderfl.net/user/su8erlemon )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/zs64
 */
package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class DrawVisualizer extends Patch {
		
		private var ACCURACY:int = 40;
		private var SPEED:int = 0;
		private var DISTANCE:Number = 30;
		private const TESTS:int = 1;        
		
		private var bmpd:BitmapData;
		private var spiderImg:Shape = new Shape();
		private var spiderBmpd:BitmapData;
		
		private var clearBmpd:BitmapData;
		private var rect:Rectangle = new Rectangle(0,0,DISPLAY_WIDTH,DISPLAY_HEIGHT);
		private var point:Point = new Point(0,0);
		
		private var spiderBmp:Bitmap;
		
		private var bmpd_w:int = 0;
		private var bmpd_h:int = 0;
		
		private var newCol:Boolean;
		
		private var rl:Number=-1.57;
		
		private var ctt:int=0;
		
		//private var urls:Array = ["001.png","002.png","003.png","004.png","005.png"];
		//private var urlss:Vector.<Loader> = new Vector.<Loader>(5,true);
		private var urlss:Vector.<Bitmap> = new Vector.<Bitmap>(1,true);
		private var urlid:int=0;
				
		private const MAX_NUM:int = 1;
		
		private var startTime:Number;
		private var prevBeat:Number;
		private var sound:Sound = new Sound();        
		private var spectBytes:ByteArray = new ByteArray();
		private var spectrum:Vector.<Number> = new Vector.<Number>(512, true);
		private var spectrumAverage:Number = 0.0;
		private var sprite:Sprite;
		private var loaded = false;
		//private var source:Bitmap;
		
		public function DrawVisualizer():void 
		{
			sprite = new Sprite();
			
			urlss[urlid] = new Bitmap(new AssetForAbstractPainting());
			
			spiderBmp = new Bitmap();
			sprite.addChild(spiderBmp);
			
			clearBmpd = new BitmapData( DISPLAY_WIDTH , DISPLAY_HEIGHT ,true , 0x05000000);
			spiderBmpd = new BitmapData( DISPLAY_WIDTH , DISPLAY_HEIGHT , true , 0x00000000);
			spiderBmp.bitmapData = spiderBmpd;
			
			urlid = 0;
			init();
			//loadImg();
		}
		
		override public function render(info:RenderInfo):void {
			
			if (loaded) {
				computeSpectrum();
				
				var interval:uint = ( 60 * 1000)/101;
				var current:Number = getTimer() - startTime;
				var beat:uint = int(current/interval*2);
				
				if(int(beat * 0.5) != int(prevBeat * 0.5)){
					changeImg(undefined);
				}
				
				//SPEED = 2000;
				if(spectrumAverage >= 0.1)SPEED += ( spectrumAverage * 20000 - SPEED ) / 2;
				else SPEED = spectrumAverage * 500;
				
				prevBeat = beat;
				
				draw(undefined);			
				
			}
				
			
			info.render(sprite);
		}
		
		override public function dispose():void {
			sprite = null;
		}

		/*private function loadCompHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,loadCompHandler);
			
			urlss[urlid] = e.target.loader;
			urlid++;
			if(urlid >= urls.length) Main2();
			else loadImg();
		}*/
		
		/*private function loadImg():void{
			var f:File = File.applicationDirectory.resolvePath( 'Onyx-VJ' + File.separator + 'assets' + urls[ urlid ]);
			var urlToLoad:String;
			if( f.exists )
			{
				urlToLoad = f.nativePath;
			
				var loader:Loader = new Loader();
				loader.load(new URLRequest( urlToLoad ));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompHandler);
			}
			
		}*/
		
		private function changeImg(e:TimerEvent):void{
			bmpd_w = urlss[ urlid ].width;
			bmpd_h = urlss[ urlid ].height;
			
			if(bmpd){
				bmpd.dispose();
				bmpd = null;
			}
			
			bmpd = new BitmapData( bmpd_w , bmpd_h );
			bmpd.draw(urlss[ urlid ]);
			
			/*urlid++;
			if(urlid >= urls.length)urlid=0;*/
			
			if(int(Math.random()*2) == 1)rl = 0;    
		}
		
		private function draw(e:Event):void{
			
			rl += 0.1;
			if( rl > 1.57 ){
				rl = 1.57;    
			}
			
			spiderBmpd.copyPixels(clearBmpd,rect,point, null, null, true);
			spiderImg.graphics.clear();
			
			var ct:int = 0;
			newCol = true;
			
			var r1x:int;
			var r1y:int;
			var r2x:int;
			var r2y:int;
			
			if( bmpd == null)return;
			for( var i:int = 0 ; i < SPEED ; i++ ){
				
				r1x = bmpd.width/2 - (bmpd.width/2 * Math.sin(rl))  + ( bmpd.width  * Math.sin(rl) ) * Math.random();
				r1y = bmpd.height/2 - (bmpd.height/2 * Math.sin(rl))+ ( bmpd.height * Math.sin(rl) ) * Math.random();                     
				
				r2x  = Math.random()*bmpd.width;
				r2y  = Math.random()*bmpd.height;
				
				if( newCol ){
					newCol = false;
					var col:uint = bmpd.getPixel( r1x , r1y );
					var col2:uint = bmpd.getPixel( r2x , r2y );
					
					var r:uint = col >> 16 & 0xFF;
					var g:uint = col >> 8 & 0xFF;
					var b:uint = col & 0xFF;
					var col_add:uint = r + g + b;
					
					r = col2 >> 16 & 0xFF;
					g = col2 >> 8 & 0xFF;
					b = col2 & 0xFF;
					
					var col2_add:uint = r + g + b;
					
					var per:Number;
					if( col_add > col2_add )per = ( col2_add / col_add ) * 100;
					else per = ( col_add / col2_add ) * 100;
				}    
				
				if( per >= ACCURACY ){
					if( distance2D( r1x , r1y , r2x , r2y ) <= DISTANCE ){
						spiderImg.graphics.lineStyle(30 - 29 * i/SPEED,col,0.4,false);
						spiderImg.graphics.moveTo( r1x + ( DISPLAY_WIDTH - bmpd_w )/2 , r1y + ( DISPLAY_HEIGHT - bmpd_h )/2 );
						spiderImg.graphics.lineTo( r2x + ( DISPLAY_WIDTH - bmpd_w )/2 , r2y + ( DISPLAY_HEIGHT - bmpd_h )/2 );
						ct++;
					}
				}
				
				if( ct >= TESTS ){
					newCol = true;    
				}
				
			}
			
			
			spiderBmpd.draw( spiderImg );
			
		}
		
		
		private function distance2D( x1:Number , y1:Number , x2:Number , y2:Number ):Number {
			var nX:Number = x2 - x1;
			var nY:Number = y2 - y1;
			var distance:Number = Math.sqrt( nX * nX + nY * nY );
			return distance;
		}
		
		private function Vec2Hermite(v1:Point,t1:Point,v2:Point,t2:Point,s:Number):Point{
			
			var xx:Number =  ( 2 * v1.x - 2 * v2.x + t1.x + t2.x ) * ( s * s * s )
				+ ( 3 * v2.x - 3 * v1.x - 2 * t1.x - t2.x ) * ( s * s )
				+ ( t1.x * s ) + v1.x;
			
			var yy:Number =  ( 2 * v1.y - 2 * v2.y + t1.y + t2.y ) * ( s * s * s )
				+ ( 3 * v2.y - 3 * v1.y - 2 * t1.y - t2.y ) * ( s * s )
				+ ( t1.y * s ) + v1.y;
			
			return new Point( xx , yy );
		}
		
		
		private function Main2():void {
			urlid = 0;
			init();
		}
		
		private function init():void{
			
			loaded = true;
			
			prevBeat = 0.0;
			startTime = getTimer();
		}
		

		
		private function computeSpectrum():void{
			var bytes:ByteArray = spectBytes;
			bytes.position = 0;
			
			SoundMixer.computeSpectrum(bytes, true , 2);
			
			var total:Number = 0;
			var plus:Number = 0;
			var pc:uint = 0;
			var minus:Number = 0;
			var mc:uint = 0;
			var numbers:Vector.<Number> = spectrum;
			for (var i:uint = 0; i < 512; ++i) {
				var n:Number = bytes.readFloat() * 2.0;
				total += Math.abs(n);
				if (n > 0) {
					plus += n;
					++pc;
				}
				else if (n < 0) {
					minus += n;
					++mc;
				}
				numbers[i] = n;
			}
			spectrumAverage = total / 512.0;
			
		}
	}    
}
