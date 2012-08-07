/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/6Hhv
 */






package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	final public class HardStir extends Patch
	{
		public static const GRAVITY:Number = 0.0;
		public static const RANGE:Number = 36;//å½±éŸ¿åŠå¾„
		public static const RANGE2:Number = RANGE * RANGE;//å½±éŸ¿åŠå¾„ã®äºŒä¹—
		public static const DENSITY:Number = 0.3;//æµä½“ã®å¯†åº¦
		public static const PRESSURE:Number = 2;//åœ§åŠ›ä¿‚æ•°
		public static const VISCOSITY:Number = 0.08;
		
		public static const DIV:uint = Math.ceil(DISPLAY_WIDTH / RANGE ); //æ¨ªæ–¹å‘ã®åˆ†å‰²æ•°
		public static const DIV2:uint = DIV * DIV;
		private var map:Vector.<Vector.<Particle>>;
		private var imgIn:BitmapData;
		private var imgOut:BitmapData;
		
		private var first:Particle;
		private var last:Particle;
		private var mouseParticle:Particle;
		private var lastX:int;
		private var lastY:int;
		private var brush:BitmapData;
		private var dsp:BitmapData;
		private var tmp:BitmapData;
		
		private var imgVec:Vector.<uint>;
		private const blur1:BlurFilter = new BlurFilter(6,6,2);

		private var press:Boolean;
		private var dmf:DisplacementMapFilter;
		
		private const origin:Point = new Point();
		private var rect:Rectangle;
		private var vecSize:int;
		
		public function HardStir() 
		{
			opaqueBackground = 0;
			scrollRect = new Rectangle(0,0,DISPLAY_WIDTH,DISPLAY_HEIGHT);
			imgIn = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0);
			imgIn.perlinNoise(120,120,3,0xbada55 * Math.random(),false,true,5,true);
			
			brush = new BitmapData(32,32,true,0);
			brush.fillRect( new Rectangle(8,8,16,16),0xffffffff);
			brush.applyFilter( brush,brush.rect,origin,new BlurFilter(6,6,2));
			
			imgOut = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0);
			
			rect = imgOut.rect;
			
			// dmf = new DisplacementMapFilter(dsp, origin,1,2,-256,-256,"clamp");
			//imgVec = new Vector.<uint>() 
			addChild( new Bitmap(imgIn) ).opaqueBackground = 0;
			//addChild( new Bitmap(brush) );
			// vecSize = img.width * img.height;
			
			//addChild( new Bitmap(dsp) ).blendMode = "difference";
			
			
			addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {press = true;});
			addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {press = false;});
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			tabChildren = false;
			mouseChildren = false;
			
			map = new Vector.<Vector.<Particle>>(DIV2,true);
			for(var i:int = DIV2; --i>-1; ) map[i] = new Vector.<Particle>();
			
			//mouseParticle = new Particle( mouseX, mouseY);
			mouseParticle = new Particle( 320, 240);
			mouseParticle.density = DENSITY * 0.4;
			mouseParticle.pressure = 1;
			addParticles(800);       
			
		}
		
		override public function render(info:RenderInfo):void 
		{
			
			//  imgVec.length = 0;
			// imgVec.length = vecSize;
			
			// if(press)
			//    pour();
			
			setNeighbors();
			
			setDensity();
			setForce();
			imgIn.lock(); 
			//imgOPut.fillReccopyPixel
			//imgOut.copyPixels(imgIn,rect,origin);
			move();
			//tmp.setVector( rect, imgVec );
			//dsp.draw(tmp);
			// dsp.applyFilter( dsp,rect,origin,blur1);
			
			
			//img.applyFilter(img,rect,origin,dmf);
			
			
			//imgOut.applyFilter( imgOut, rect, origin, blur1);
			
			/*
			img.colorTransform( rect, ct );
			img.applyFilter( img, rect, origin, blur2);
			//img.draw(img,null,null,"add");
			*/
			
			imgIn.draw(imgOut,null,null,"layer");
			this.filters = [blur1]
			imgIn.unlock();
			info.render(imgIn);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			mouseParticle.x = event.localX;
			mouseParticle.y = event.localY;
			mouseParticle.vx = event.localX - lastX;
			mouseParticle.vy = event.localY - lastY;
			lastX = event.localX;
			lastY = event.localY;
			
		}
		
		
		
		private function addParticles( count:int ):void {
			if ( last == null )
			{
				first = new Particle(DISPLAY_WIDTH * Math.random(), DISPLAY_HEIGHT * Math.random());
				last = first;
			} else {
				last = last.next = new Particle(DISPLAY_WIDTH * Math.random(), DISPLAY_HEIGHT * Math.random());
			}
			//last.move();
			
			while ( count-- > 0 )
			{
				last = last.next = new Particle(DISPLAY_WIDTH * Math.random(), DISPLAY_HEIGHT * Math.random());
				//last.move();
			}
			//  text.text = "numParticles: " + numParticles;
		}
		
		private function setNeighbors():void 
		{
			var mp:Vector.<Vector.<Particle>> = map;
			var a:int, b:int, i:int, j:int;
			var m1:Vector.<Particle>, m2:Vector.<Particle>;
			
			for(  i = DIV2; --i >-1; ) 
			{
				m1 = mp[i];
				for ( a = m1.length; --a > 0;   )
				{
					if ( press ) m1[a].addNeighbor(mouseParticle);
					
					for ( b = a; --b > -1;  )
					{    
						m1[a].addNeighbor(m1[b]);
					}
				}
			}
			
			for( i = 0; i < DIV - 1; i++) 
			{
				for( j = 0; j < DIV; j++)
				{
					m1 = mp[int(j*DIV+i)];
					m2 = mp[int(j*DIV+i+1)];
					for ( a = m1.length; --a > -1;   )
					{
						for ( b = m2.length; --b > -1;  )
						{    
							m1[a].addNeighbor(m2[b]);
						}
					}
				}
			}
			
			for(  i= 0; i < DIV; i++) 
			{
				for( j = 0; j < DIV-1; j++)
				{
					m1 = mp[int(j*DIV+i)];
					m2 = mp[int((j+1)*DIV+i)];
					for ( a = m1.length; --a > -1;   )
					{
						for ( b = m2.length; --b > -1;  )
						{    
							m1[a].addNeighbor(m2[b]);
						}
					}
				}
			}
			
			for( i = 0; i < DIV - 1; i++) 
			{
				for( j = 0; j < DIV -1; j++)
				{
					
					m1 = mp[int(j*DIV+i)];
					m2 = mp[int((j+1)*DIV+i+1)];
					for ( a = m1.length; --a > -1;   )
					{
						for ( b = m2.length; --b > -1;  )
						{    
							m1[a].addNeighbor(m2[b]);
						}
					}
					
					m1 = mp[int(j*DIV+i+1)];
					m2 = mp[int((j+1)*DIV+i)];
					for ( a = m1.length; --a > -1;   )
					{
						for ( b = m2.length; --b > -1;  )
						{    
							m1[a].addNeighbor(m2[b]);
						}
					}
				}
			}
		}
		
		
		private function setDensity():void{
			var p:Particle = first;
			while ( p != null )
			{
				p.setDensity();
				p = p.next;
			}
		}
		
		
		private function setForce():void{
			var p:Particle = first;
			while ( p != null )
			{
				p.setForce();
				p = p.next;
			}
		}
		
		
		private function move():void 
		{
			//count++;
			//const img:BitmapData = this.img;
			
			var p:Particle = first;
			while ( p != null )
			{
				p.move();
				p.moveMap( map );
				p.draw( imgIn, imgOut, brush );
				
				
				p = p.next;
			}
			
		}
	}
}

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import onyx.plugin.DISPLAY_HEIGHT;
import onyx.plugin.DISPLAY_WIDTH;


final class Neighbor {
	public var next:Neighbor;
	
	public var particle:Particle;
	
	private static var reuse:Vector.<Neighbor> = new Vector.<Neighbor>();
	private static var count:int = 0;
	
	public static function getNeighbor( p:Particle ):Neighbor
	{
		var n:Neighbor;
		if ( count > 0 )
			n = reuse[int(--count)];
		else 
			n = new Neighbor();
		n.particle = p;
		n.next = null;
		
		return n;
	}
	
	public static function recycleNeighbors( list:Neighbor ):void
	{
		while ( list != null )
		{
			reuse[int(count++)] = list;
			list = list.next;
		}
		
	}
	
	public function Neighbor()
	{}
	
	
}


final class Particle {
	public var next:Particle;
	public var nextInZone:Particle;
	
	public var x:Number;    //xæ–¹å‘ã®ä½ç½®
	public var y:Number;    //yæ–¹å‘ã®ä½ç½®
	private var mapX:uint;    //xæ–¹å‘ã®ä½ç½®
	private var mapY:uint;    //yæ–¹å‘ã®ä½ç½®
	public var vx:Number;    //vxæ–¹å‘ã®ä½ç½®
	public var vy:Number;    //vyæ–¹å‘ã®ä½ç½®
	private var fx:Number; //xæ–¹å‘ã®åŠ é€Ÿåº¦
	private var fy:Number; //yæ–¹å‘ã®åŠ é€Ÿ
	public var density:Number; //å‘¨è¾ºã®ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«å¯†åº¦
	public var pressure:Number; //ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã«ã‹ã‹ã‚‹åœ§åŠ›
	
	private var color:uint;
	private var rect:Rectangle;
	private var targetPoint:Point;
	private var brushPoint:Point;
	
	public var firstNeighbor:Neighbor;
	public var lastNeighbor:Neighbor;
	
	public function Particle(x:Number, y:Number) {
		this.x = x;
		this.y = y;
		vx = fx = fy = 0;
		vy = 0;//5 * Math.random();
		mapX = uint(-1);
		
		var clr:int = 0xa0 + Math.random() * 0x40;
		color = 0xff000000 | (clr<<16) | (clr << 8) | clr;
		
		rect = new Rectangle(0,0,32,32);
		targetPoint = new Point();
		brushPoint = new Point(0,0);
		//color = 0xeeffff;
	}
	
	public function addNeighbor( p:Particle ):void
	{
		
		const dx:Number = x - p.x;
		const dy:Number = y - p.y;
		if( dx * dx + dy * dy < HardStir.RANGE2) {
			if ( lastNeighbor == null )
			{
				lastNeighbor = firstNeighbor = Neighbor.getNeighbor(p);
			} else {
				lastNeighbor = lastNeighbor.next = Neighbor.getNeighbor(p);
			}
			
			if ( p.lastNeighbor == null )
			{
				p.lastNeighbor = p.firstNeighbor = Neighbor.getNeighbor(this);
			} else {
				p.lastNeighbor = p.lastNeighbor.next = Neighbor.getNeighbor(this);
			}
			
		}
		
	}
	
	public function setDensity():void{
		const px:Number = x;
		const py:Number = y;
		var rg:Number = HardStir.RANGE;
		var d:Number = 0;
		var n:Neighbor = firstNeighbor;
		while ( n != null )
		{
			const pj:Particle = n.particle;
			const dx:Number = px - pj.x;
			const dy:Number = py - pj.y;
			const weight:Number = 1 - Math.sqrt(dx * dx + dy * dy) / rg;
			d += weight * weight;
			// pj.density += weight2;
			n = n.next;
			
		}
		
		if( d < HardStir.DENSITY) d = HardStir.DENSITY;
		density = d;
		pressure = density - HardStir.DENSITY;
		
	}
	
	
	public function setForce():void{
		const px:Number = this.x;
		const py:Number = this.y;
		const pvx:Number = this.vx;
		const pvy:Number = this.vy;
		
		const pressure:Number = this.pressure;
		const density:Number = this.density;
		
		var weight:Number, pw:Number, vw:Number, pj:Particle, dx:Number, dy:Number, dist:Number; 
		var pr:Number = HardStir.PRESSURE;
		var vs:Number = HardStir.VISCOSITY;
		var rg:Number = HardStir.RANGE;
		
		var ffx:Number = 0;
		var ffy:Number = 0;
		var n:Neighbor = firstNeighbor;
		while ( n != null )
		{
			pj = n.particle;
			dx = px - pj.x;
			dy = py - pj.y;
			dist = Math.sqrt(dx * dx + dy * dy);
			if ( dist == 0 )
			{
				dx = 0.001 * (Math.random() - 0.5);
				dy = 0.001 * (Math.random() - 0.5);
				dist = Math.sqrt(dx * dx + dy * dy);
			}
			
			weight = 1 - dist / rg;
			pw = weight * (pressure + pj.pressure) / (2 * pr * pj.density);
			vw = weight / pj.density * vs;
			dist = 1 / dist;
			ffx += dx * dist * pw - (pvx - pj.vx) * vw;
			ffy += dy * dist * pw - (pvy - pj.vy) * vw;
			
			n = n.next;       
		}
		fx = ffx;
		fy = ffy;
		
		Neighbor.recycleNeighbors( firstNeighbor );
		lastNeighbor =  firstNeighbor = null;
	}
	
	public function move():void {
		x += vx += fx;
		y += vy += fy + HardStir.GRAVITY;
		
		//  vx *= 0.99;
		//  vy *= 0.99;
		if(x < 0){ vx = -vx; x = 0 }
		else if(x > DISPLAY_WIDTH-2){ vx = -vx; x = DISPLAY_WIDTH-2 }
		//while(x < 0){ x += 464 }
		//while(x > 464){ x -= 464 }
		
		
		if(y < 0){ vy = -vy; y = 0 }
		else if(y > DISPLAY_HEIGHT-2){ vy = - vy; y = DISPLAY_HEIGHT-2 }    
		
		// mapX = x / SPH.RANGE;
		// mapY = y / SPH.RANGE;    
	}
	
	public function moveMap( map:Vector.<Vector.<Particle>> ):void {
		const mx:int = this.x / HardStir.RANGE;
		const my:int = this.y / HardStir.RANGE;
		const pmx:int = this.mapX;
		const pmy:int = this.mapY;
		
		
		if( mx != pmx || my != pmy )
		{
			if ( pmx != -1 )
			{
				var m:Vector.<Particle> = map[ int(pmx * HardStir.DIV + pmy) ];
				m.splice( m.indexOf(this),1);
			}
			map[ int(mx * HardStir.DIV + my) ].push( this );
			this.mapY = my; this.mapX = mx;
		}
		
	}
	
	public function draw( imgIn:BitmapData, imgOut:BitmapData, brush:BitmapData ):void{ 
		//var idx:int = int(x)
		rect.x = int( x - 16 - vx);
		rect.y = int(y - 16 - vy);
		targetPoint.x = int(x) -16;
		targetPoint.y = int(y) -16;
		
		//imgOut.copyPixels( imgIn, rect, targetPoint, brush, brushPoint, true );
		
		imgOut.copyPixels( imgIn, rect, targetPoint);
		
		
		
		// imgVec[idx] = imgVec[int(idx+1)] = imgVec[int(idx+w)] = imgVec[int(idx+w+1)] = 0xff000000 | ((vx+129)<<16) | ((vy+129)<<8);
		//  imgVec[idx] = color;
		
	}
}
