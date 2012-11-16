/**
 * Copyright wonderwhyer ( http://wonderfl.net/user/wonderwhyer )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/9Byvt
 */

package {
	import flash.accessibility.Accessibility;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Gravias extends Patch
	{		
		public const mouseForce:Number = 20;
		public const oscillationDumper:Number = 0.05;
		public const minimalMovement   :Number = 0.001;
		
		//public var sourceBMP:BitmapData;
		public var pictureX:Number;
		public var pictureY:Number;
		public var view:BitmapData;
		public var bmp:Bitmap;
		
		public var matrix:Array;
		public var blurFilter:BlurFilter = new BlurFilter(3,3,1);
		public var trans:ColorMatrixFilter = new ColorMatrixFilter(matrix);
		public var ct:ColorTransform = new ColorTransform(1,1,1,0.95,0,0,0,0);
		
		
		public var allPoints:Array = new Array();
		public var activePoints:Array = [];
		public var c:uint=0;
		public var point:Point = new Point(0,0);
		public var currentPixel:int=0;
		
		public var mouseDown:Boolean = false;
		[Embed(source='C:/Users/b.lane/AppData/Roaming/Onyx-VJ/Local Store/Onyx-VJ/library/anabel/sola512.jpg' )]  
		private const ImageB: Class;
		private const sourceBMP:BitmapData = Bitmap( new ImageB() ).bitmapData;
		private var mx:Number = 0;
		private var my:Number = 0;
		private var _color:uint = 0xFF6c2b20;
		
		public function Gravias() 
		{			
			Console.output('Gravias');
			Console.output('Credits to Edik Ruzga ( http://wonderfl.net/user/wonderwhyer )');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			
			parameters.addParameters(
				new ParameterColor('color', 'pixel color', _color)
			)
			pictureX = (DISPLAY_WIDTH-sourceBMP.width)/2;
			pictureY = (DISPLAY_HEIGHT-sourceBMP.height)/2;
			matrix = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 0]);// red
			matrix = matrix.concat([0, 1, 0, 0, 0]);// green
			matrix = matrix.concat([0, 0, 1, 0, 0]);// blue
			matrix = matrix.concat([0, 0, 0, 1, -50]);// alpha
			
			view = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,true,0);
			bmp = new Bitmap(view);
			addEventListener( MouseEvent.MOUSE_DOWN, startDraw );
			addEventListener( MouseEvent.MOUSE_UP, stopDraw );
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		
			createPoints();
			addChild(bmp);
		}
		private function startDraw(evt:MouseEvent):void 
		{
			mx = evt.localX; 
			my = evt.localY; 
			mouseDown = true;
		}
		private function stopDraw(evt:MouseEvent):void 
		{ 
			mouseDown = false;
		}
		private function mouseMove(event:MouseEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}
		override public function render(info:RenderInfo):void 
		{
			if ( view ) 
			{
				view.lock();
				
				//adding new 30 points to active points list
				var pointsCreated:int=0;
				while(pointsCreated<30 && currentPixel<allPoints.length){
					pointsCreated++;
					var pixel:dPixel = allPoints[currentPixel];
					pixel.x=pixel.cx+Math.random()*70-55;
					pixel.y=pixel.cy+Math.random()*70-55;
					pixel.dx=0;
					pixel.dy=0;
					pixel.h=1;
					activePoints.push(pixel);
					currentPixel++;
				}
				
				
				view.applyFilter(view,view.rect,point,blurFilter);
				view.colorTransform(view.rect,ct);
				
				
				for (var i:int=0; i<activePoints.length; i++) {
					
					pixel =dPixel(activePoints[int(i)]);
					
					//var pp:Point = new Point(pixel.x-bmp.mouseX,pixel.y-bmp.mouseY);//vector from mouse to this pixel
					var pp:Point = new Point(pixel.x-mx,pixel.y-my);//vector from mouse to this pixel
					
					var l:Number=1 / pp.length;
					
					//now normalized to length of 1
					pp.x*=l;
					pp.y*=l;
					
					l=20*l;
					
					//pushing pixel from mouse based on distance
					if(mouseDown){
						pixel.dx+=pp.x*l;
						pixel.dy+=pp.y*l;
					}
					
					//calculating how far pixel is from place where it should be, momentum of pixel is included, also acceleration of pixel towards its place
					var ddx:Number = (pixel.cx-pixel.x-pixel.dx)*0.05;
					var ddy:Number = (pixel.cy-pixel.y-pixel.dy)*0.05;
					
					var dd:Number = (Math.abs(ddx)+Math.abs(ddy))*0.03;
					
					//h is how "hot" pixel is, nasicly how far it is from place where it should be
					pixel.h+=dd;
					pixel.h*=0.98;
					pixel.h=Math.min(1,pixel.h);
					
					//moving pixel
					pixel.dx+=ddx;
					pixel.dy+=ddy;
					
					pixel.x+=pixel.dx;
					pixel.y+=pixel.dy;
					
					if(Math.abs(pixel.dx)<0.001)
						pixel.x = pixel.cx;
					if(Math.abs(pixel.dy)<0.001)
						pixel.y = pixel.cy;
					
					
					
					//drawing pixel interpolating color between what it should be and yellow
					view.setPixel32(pixel.x,pixel.y,InterpolateColor(pixel.color,_color,pixel.h));
				}
			
				view.unlock();
				info.source.copyPixels( view, DISPLAY_RECT, ONYX_POINT_IDENTITY );
			}
		}
		      
		
		private function createPoints():void {
			//for (var iy:int=0; iy<sourceBMP.height; iy++) {
			for (var iy:int=sourceBMP.height; iy>0; iy--) {
				for (var ix:int=0; ix<sourceBMP.width; ix++) {
					var col:uint = sourceBMP.getPixel32(ix,iy);
					if ((col>>>24)>50) {
						allPoints.push(new dPixel(ix+pictureX,iy+pictureY,ix+pictureX,iy+pictureY,0,0,0,col));
					}
				}
			}
		}
		
		
		private function restart(evt:Event):void {
			activePoints.splice(0);
			currentPixel=0;
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
import flash.geom.ColorTransform;
class dPixel{
	public var x:Number;
	public var y:Number;
	public var cx:Number;
	public var cy:Number;
	public var dx:Number;
	public var dy:Number;
	public var h:Number;
	public var color:uint;
	public function dPixel(x:Number,y:Number,cx:Number,cy:Number,dx:Number,dy:Number,h:Number,color:uint){
		this.x=x;
		this.y=y;
		this.cx=cx;
		this.cy=cy;
		this.dx=dx;
		this.dy=dy;
		this.h=h;
		this.color=color;
	}
}
function InterpolateColor(StartColor:uint, EndColor:uint, TransitionPercent1:Number):uint
{
	var TransitionPercent2:Number = (1 - TransitionPercent1);
	
	//SC:StartColor EC:EndColor IC:InterpolateColor
	var SC1:uint = StartColor >> 24 & 0xFF;
	var SC2:uint = StartColor >> 16 & 0xFF;
	var SC3:uint = StartColor >> 8 & 0xFF;
	var SC4:uint = StartColor & 0xFF;
	
	var EC1:uint = EndColor >> 24 & 0xFF;
	var EC2:uint = EndColor >> 16 & 0xFF;
	var EC3:uint = EndColor >> 8 & 0xFF;
	var EC4:uint = EndColor & 0xFF;
	
	var IC1:uint = SC1 * TransitionPercent2 + EC1 * TransitionPercent1;
	var IC2:uint = SC2 * TransitionPercent2 + EC2 * TransitionPercent1;
	var IC3:uint = SC3 * TransitionPercent2 + EC3 * TransitionPercent1;
	var IC4:uint = SC4 * TransitionPercent2 + EC4 * TransitionPercent1;
	
	var IC:uint = IC1 << 24 | IC2 << 16 | IC3 << 8 | IC4;
	return IC;
}

