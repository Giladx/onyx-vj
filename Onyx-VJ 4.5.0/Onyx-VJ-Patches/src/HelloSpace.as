/**
 * Copyright Dreyson.Queiroz ( http://wonderfl.net/user/Dreyson.Queiroz )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/gMAn
 */

package {
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.setInterval;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
		
	public class HelloSpace extends Patch
	{
		private static const R:Number = 300;
		private static const HR:Number = R / 2;
		private var particles:Vector.<Number> = new Vector.<Number>();
		private var letterPoints:Vector.<Number> = new Vector.<Number>();
		private var colors:Vector.<uint> = new Vector.<uint>();
		
		private var canvasGlow:BitmapData;
		
		private var mtx:Matrix = new Matrix(0.25, 0, 0, 0.25);
		private var mtx3d:Matrix3D = new Matrix3D();
		private var canvas:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000);
		private var counter:int = 0;
		private var moveCounter:int = 0;
		private var f:Boolean = false;
		private var projMat:Matrix3D;
		private var proj:PerspectiveProjection = new PerspectiveProjection();
		private var particles2:Vector.<Number> = new Vector.<Number>();
		private var uvts:Vector.<Number> = new Vector.<Number>();
		private var xys:Vector.<Number>;
		private var xysRandom:Vector.<Number> = new Vector.<Number>();
		private var canvasBMP:Bitmap;
		private var _font:Font;
		private var _text:String = "batchass";
		private var _color:uint=0x005599;
		
		public function HelloSpace()
		{
			Console.output('HelloSpace (from http://wonderfl.net/c/gMAn)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterFont('font', 'font'),
				new ParameterString('text', 'text'),
				new ParameterColor('color', 'color')
			);
			font	= PluginManager.createFont('Impact') || PluginManager.fonts[0];
			refreshTextParticles();	
			
			canvasBMP = new Bitmap( canvas, "auto", true );
			addChild(canvasBMP);
			
			// é??è??æ??å??ç??ã??å??æ??è??å??ä??æ??
			proj.fieldOfView = 90;
			projMat = proj.toMatrix3D();			
			// å??ã??ã??ã??ã??ã??ã?? BitmapData ã??å??æ??å??ã??ã??
			canvasGlow = new BitmapData(DISPLAY_WIDTH / 4, DISPLAY_HEIGHT / 4, true, 0x000000);
			var bmp:Bitmap = new Bitmap(canvasGlow, PixelSnapping.NEVER, true);
			bmp.scaleX = bmp.scaleY = 4;
			bmp.smoothing = true;
			bmp.blendMode = BlendMode.ADD;
			addChild(bmp);
			
			// å®šæœŸçš„ã« f ã‚’åè»¢ã•ã›ã‚‹
			setInterval(function():void{ f = !f; }, 14000);
		}
		override public function render(info:RenderInfo):void 
		{
			if (xys.length > 0 )
			{				
				mtx3d.identity();
				mtx3d.appendRotation(counter, Vector3D.Y_AXIS);
				mtx3d.appendRotation(15, Vector3D.X_AXIS);
				mtx3d.appendTranslation(0, 0, DISPLAY_WIDTH / 2);
				mtx3d.transformVectors(particles, particles2);
				
				// é??è??æ??å??ã??ã??å??è??å??ã??åº?æ??ã??è??ç??ã??ã??
				Utils3D.projectVectors(projMat, particles2, xysRandom, uvts);
				
				// moveCounter ä??ä??ã?ªã??ã??ã??ã??ã??ã??ã??ã??æ??å??å??ã??é??ç??ã??è??ã??ã??ã??
				// ã??ã??ã??ã?ªã??å??å??ã??ã??ã??ã??ã??ã??å??ç??ã??ã??ã??ã??ã??ã??ä??ç??ã??é??ç??ã??è??ã??ã??ã??
				for (var i:int = 0; i < xysRandom.length; i++){
					if (i < moveCounter * 2){
						xys[i] += (letterPoints[i] - xys[i]) * .13;
					} else {
						xys[i] += (xysRandom[i] - xys[i]) * .12;
					}
				}
				
				// æ–‡å­—åˆ—è¡¨ç¤ºä¸­ã¯moveCounter ã‚’åŠ ç®—ã™ã‚‹
				moveCounter = (f ? moveCounter + 100 : 0);
				
				// BitmapData ã«æç”»ã™ã‚‹
				canvas.lock();
				canvas.fillRect(canvas.rect, 0x000000);
				for (var j:int = 0; j < xys.length / 2; j++){
					//canvas.setPixel32(xys[j * 2] + DISPLAY_WIDTH / 2, xys[j * 2 + 1] + DISPLAY_HEIGHT / 2, colors[j]);
					canvas.setPixel32(xys[j * 2] + DISPLAY_WIDTH / 2, xys[j * 2 + 1] + DISPLAY_HEIGHT / 2, color);
				}
				canvas.unlock();
				
				// å…‰ã‚‰ã›ã‚‹ãŸã‚ã®ã‚­ãƒ£ãƒ³ãƒã‚¹ã«ã‚³ãƒ”ãƒ¼ã™ã‚‹
				canvasGlow.fillRect(canvasGlow.rect, 0x000000);
				canvasGlow.draw(canvas, mtx);
				
				counter++;
				info.render( canvasBMP );
			}
		}		
		private function createBitmapData(letters:String):BitmapData{
			var fmt:TextFormat = new TextFormat();
			fmt.size = 50;
			fmt.font = font.fontName;
			var tf:TextField = new TextField();
			tf.defaultTextFormat = fmt;
			tf.autoSize = "left";
			tf.textColor = color;
			tf.text = letters;
			
			var bmd:BitmapData = new BitmapData(tf.textWidth, tf.textHeight, true, 0x000000);
			var mtx:Matrix = new Matrix();
			bmd.draw(tf, mtx);
			
			return bmd;
		}
		
		private function initParticles(bmd:BitmapData):void
		{
			particles = null;
			particles = new Vector.<Number>();
			for (var yy:int = 0; yy < bmd.height; yy++){
				for (var xx:int = 0; xx < bmd.width; xx++){
					var c:uint = bmd.getPixel(xx, yy);
					if (c != 0){
						letterPoints.push(xx - 220, yy - 20);
						particles.push(R * Math.random() - HR, R * Math.random() - HR, R * Math.random() - HR);
						colors.push(c);
					}
				}
			}
		}
		private function refreshTextParticles():void
		{
			particles2 = null;
			uvts = null;
			xysRandom = null;
			particles2 = new Vector.<Number>();
			uvts = new Vector.<Number>();
			xysRandom = new Vector.<Number>();
			letterPoints = new Vector.<Number>();
			var bmd:BitmapData = createBitmapData(text);
			initParticles(bmd);
			xys = new Vector.<Number>(letterPoints.length);
		}
		public function set text(value:String):void 
		{		
			_text = value;	
			if (value) 
			{
				refreshTextParticles();				
			}
		}
		public function get text():String {
			return _text;
		}
		
		public function set color(value:uint):void {
			_color = value;
			if (value) 
			{
				refreshTextParticles();				
			}
		}
		public function get color():uint {
			return _color;
		}
		public function set font(value:Font):void {
			_font = value;
			
			if (value) 
			{
				refreshTextParticles();				
			}
		}

		public function get font():Font {
			return _font;
		}
		override public function dispose():void {
			canvas.dispose();
			canvasGlow.dispose();
		}
	}
}
