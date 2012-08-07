/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/qp4t
 */

// forked from bradsedito's LiveWarp :[ff]
/*  mouseMove : move perspective point
mouseDown : speed up
mouseUp   : speed down                    */


package 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Shimmer extends Patch 
	{
		private const  A           :Number       =  200;
		private const  P           :Number       =  800;
		private const  SY          :Number       =  2;
		private const  R           :Number       =  P*SY/(2*Math.PI);
		private const  PI          :Number       =  Math.PI    ;        
		private var    N           :uint         =  20   ;    
		private var  seed          :int          =  new  Date().time;
		private var _mode          :Boolean      =  true;
		private var    _stepX      :Number ;       
		private var    _bmds       :Array;
		private var    _ox         :Point;
		private var    _bmd        :BitmapData;
		private var    _canvas     :Sprite;
		private var   _perspective :PerspectiveProjection;
		private var    perspective :PerspectiveProjection;
		private var mx:int = 620;
		private var my:int = 440;
		
		public function Shimmer() 
		{
			// ENTRY POINT: /////////////////////////////////////////////////////////////////////////////////
			perspective = this.transform.perspectiveProjection;
			perspective.fieldOfView = 45 ;               
			
			_perspective = this.transform.perspectiveProjection;
			_perspective.fieldOfView = 175;
			
			_canvas = new Sprite();
			
			
			_bmd = new BitmapData(A, P, true, 0x000000);
			_bmds = [];
			
			for(var i : uint = 0;i < N;i++)
			{
				var bmd : BitmapData  = new BitmapData(A, P / N, true, 0xffffff);
				var bmp : Bitmap      = new Bitmap(bmd);
				bmp.x           =  R * Math.cos(i * 2 * Math.PI/N);
				bmp.y           =  R * Math.sin(i * 2 * Math.PI/N);
				bmp.z           =  2000;
				bmp.scaleX      =  20;
				bmp.scaleY      =  SY;
				bmp.rotationY   =  90;
				bmp.rotationX   =  -(i + 0.5) / N * 360;
				_bmds.push(bmd)  ;                      
				_canvas.addChild(bmp);
			}                
			
			_ox     =  new Point(int.MAX_VALUE, 0);
			_stepX  =  -5;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			addEventListener( MouseEvent.MOUSE_DOWN, startDraw );
			addEventListener( MouseEvent.MOUSE_MOVE, startDraw );
		}
		private function startDraw(evt:MouseEvent) : void 
		{
			mx = evt.localX; 
			my = evt.localY; 		
		}	
		
		private function onMouseDownHandler(e:MouseEvent):void 
		{ 
			_mode = true; 
		}
		private function   onMouseUpHandler(e:MouseEvent):void 
		{ 
			_mode = false; 
		}        
		
		override public function render(info:RenderInfo):void  
		{
			_perspective.projectionCenter = new Point(mx, my);
			//perspective.projectionCenter = new Point( W/2,H/2 )
			_bmd.perlinNoise( 100,100,1,seed, true, _mode, 5, false, [_ox]  );
			_bmd.colorTransform( _bmd.rect,new ColorTransform( 1.00,1.00,1.00,1.00 )  );
			//_bmd.colorTransform( _bmd.rect,new ColorTransform(1.2, 1.2, 1.2)  )
			
			for(var i : uint = 0;i < N;i++)
			{
				_bmds[i].copyPixels(_bmd, new Rectangle(0, i / N * P, A, P / N), new Point());
			}
			_ox.x += _stepX;
			info.render(_canvas);
		}
		
		
	}
}
