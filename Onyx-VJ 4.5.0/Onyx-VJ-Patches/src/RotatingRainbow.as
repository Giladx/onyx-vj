/**
 * Copyright hasandurmaz44 ( http://wonderfl.net/user/hasandurmaz44 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/gpgV
 */

package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class RotatingRainbow extends Patch 
	{
		
		private var _num:Number = 100;
		private var _rad:Number = 100;
		private var _balls:Array = [];
		private var _addRot:Number = 0;
		private var _vector:int = 1;
		private var _canvas:Bitmap;
		private var _bmpData:BitmapData;
		private var _colorTransform:ColorTransform;
		private var sprite:Sprite;
		
		public function RotatingRainbow() 
		{
			_bmpData = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0 );
			_canvas = new Bitmap(_bmpData,"auto",true);
			_colorTransform = new ColorTransform(0.99,0.959,0.99);
			sprite = new Sprite();
			addChild(sprite);
			sprite.addChild(_canvas);
			
			for (var i:int = 0; i < _num; i++) 
			{
				var sh:Shape = new Shape();
				var theta:Number = (i * Math.PI * 2.0 * ((1 + Math.sqrt(5)) / 2)) * Math.PI / 180;
				var h:Number = i * 360 / _num * 2;
				var s:Number = 30;
				var v:Number = 99;    
				sh.graphics.beginFill(HSVtoRGB(h,s,v));
				sh.graphics.drawCircle(0, 0, 10);
				sh.graphics.endFill();
				sh.x = (_rad + i*2) * Math.sin(theta) + DISPLAY_WIDTH / 2;
				sh.y = (_rad + i*2) * Math.cos(theta) + DISPLAY_HEIGHT / 2;
				sh.blendMode = "add";
				sprite.addChild(sh);
				_balls.push(sh);
			}
			addEventListener(MouseEvent.MOUSE_DOWN, stageClick);
		}
		
		override public function render(info:RenderInfo):void 
		{
			for (var i:int = 0; i < _num; i++) 
			{
				var theta:Number = (i * Math.PI * 2.0 * ((1 + Math.sqrt(5)) / 2) + _addRot) * Math.PI / 180 * _vector ;
				var myRad:Number = _rad * Math.cos(getTimer() / 2000) + 110 ; 
				_balls[i].scaleX = _balls[i].scaleY = 1 * Math.sin(getTimer() / 2000) ;
				_balls[i].x = (myRad + i*2) * Math.sin(theta) + DISPLAY_WIDTH / 2;
				_balls[i].y = (myRad + i*2) * Math.cos(theta) + DISPLAY_HEIGHT / 2;
			}
			_bmpData.draw(sprite);
			_bmpData.colorTransform(_bmpData.rect, _colorTransform);
			_addRot++; 
			info.render( sprite );	
		}
		
		private function stageClick(e:MouseEvent):void{
			
			_vector = _vector*-1;
			
		}
		
		private function HSVtoRGB(h:Number, s:Number, v:Number):uint
		{
			var tmpR:uint = 0;
			var tmpG:uint = 0;
			var tmpB:uint = 0;
			
			h = (h % 360.0 + 360.0) % 360.0;
			
			s = Math.min( Math.max(s, 0.0) , 1.0);
			v = Math.min( Math.max(v, 0.0) , 1.0);
			
			if(s == 0.0)
			{
				tmpR = v;
				tmpG = v;
				tmpB = v;
			}
			else
			{
				var hi:uint = (h / 60) % 6;
				var f:Number = h / 60 - hi;
				var p:Number = v * (1.0 - s);
				var q:Number = v * (1.0 - f * s);
				var t:Number = v * (1.0 - (1.0 - f) * s);
				
				switch(hi)
				{
					case 0:
					{
						tmpR = v * 255;
						tmpG = t * 255;
						tmpB = p * 255;
						break;
					}
					case 1:
					{
						tmpR = q * 255;
						tmpG = v * 255;
						tmpB = p * 255;
						break;
					}
					case 2:
					{
						tmpR = p * 255;
						tmpG = v * 255;
						tmpB = t * 255;
						break;
					}
					case 3:
					{
						tmpR = p * 255;
						tmpG = q * 255;
						tmpB = v * 255;
						break;
					}
					case 4:
					{
						tmpR = t * 255;
						tmpG = p * 255;
						tmpB = v * 255;
						break;
					}
					case 5:
					{
						tmpR = v * 255;
						tmpG = p * 255;
						tmpB = q * 255;
						break;
					}
					default:
					{
						tmpR = 0;
						tmpG = 0;
						tmpB = 0;
						break;
					}    
				}        
			}
			return tmpR << 16 | tmpG << 8 | tmpB;
		}
	}
}