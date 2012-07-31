/**
 * Copyright otherone ( http://wonderfl.net/user/otherone )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/uIAC
 */

package plugins.filters
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * ...
	 * @author moriya
	 * 
	 * 
	 * 
	 * å‚è€ƒ
	 * http://level0.kayac.com/#!2009/11/matrix_with_getbounds.php
	 * http://d.hatena.ne.jp/habu024/20090921/1253533625
	 */
	/**
	 * 
	 */
	public final class SpiralCut extends Filter implements IBitmapFilter
	{
		private var neko:Bitmap;
		
		private var speed:Number;
		//private var radius:Number;
		private var angle:Number;
		private var xpos:Number;
		private var ypos:Number;
		private var moving:Boolean = true;//å‹•ã„ã¦ã‚‹ã‹ã©ã†ã‹
		//ã‚¹ãƒ†ãƒ¼ã‚¸ã®ä¸­å¿ƒ
		private var centerX:Number = DISPLAY_WIDTH / 2;
		private var centerY:Number = DISPLAY_HEIGHT / 2;
		
		private var nullSp:Sprite = new Sprite()
		private var base:MovieClip = new MovieClip();
		private var bmp_data:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00000000);
		private var matrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
		
		private var color:ColorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
		private var rect:Rectangle = new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
		
		private var bmp:Bitmap = new Bitmap(bmp_data);
		private var blur:BlurFilter = new BlurFilter();
		
		private var _rot:uint;
		private var _isAuto:Boolean=true;
		private var _radius:Number = 80;
		private var point:Point = new Point(0, 0);
		
		public function SpiralCut():void
		{
			parameters.addParameters(
				new ParameterNumber('radius', 'radius', 0, 100, _radius, 1),
				new ParameterBoolean('isAuto', 'isAuto')
			);
			speed = 0.2;
			
			base.x = centerX+20;
			base.y = centerY;
			base.visible = false;
			
			matrix.translate(centerX, centerY);
			bmp_data.draw(base, matrix);
			blur.blurX = 15;
			blur.blurY = 15;
			bmp.filters = [blur];
			
			
		}
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set isAuto(value:Boolean):void {
			_isAuto = value;
		}
		
		public function get isAuto():Boolean {
			return _isAuto;
		}


		public function applyFilter(source:BitmapData):void 
		{
			neko = null;
			if (isAuto) radius++;
			if (radius > 100) radius = 80;
			neko = new Bitmap(source);
			var r:Number = (_radius-50) *10; 

			base.graphics.clear();
			base.graphics.lineStyle(10, 0xffffff, 0.6);//,false,'normal',null,"round");
			base.graphics.moveTo(0, 0);
			var setNum:Number = 0;
			for (var i:int=0; i<Math.abs(r); i++)
			{
				r < 0 ? setNum = - i:setNum = i;
				angle = setNum * speed;
				base.graphics.lineTo(Math.cos(angle) * setNum,Math.sin(angle) * setNum);
			}
			bmp_data.dispose();
			bmp_data = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,true,0x000000);
			bmp.bitmapData = bmp_data;
			base.rotation =  r*1.5;
			_rot =r*1.5;
			
			var _brect:Rectangle = new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			
			matrix.translate(-(_brect.left + _brect.width / 2), -(_brect.top + _brect.height / 2));
			
			matrix.rotate(_rot / 180 * Math.PI);
			
			matrix.translate(_brect.left + _brect.width / 2, _brect.top + _brect.height / 2);
			
			bmp_data.draw(base, matrix);
			
			var displacementMapFilter:DisplacementMapFilter = new DisplacementMapFilter(bmp_data, point, 1, 1, 0, 50, "clamp", 0x00000000);
			displacementMapFilter.scaleX = Math.random() * 10;
			displacementMapFilter.scaleY = Math.random() * 10;
			
			neko.filters = [displacementMapFilter];		
			
			source.draw(neko);			
		}
		
	}
	
}

