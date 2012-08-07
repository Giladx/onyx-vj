/**
 * Copyright Aquioux ( http://wonderfl.net/user/Aquioux )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rAYK
 */

// http://aquioux.blog48.fc2.com/blog-entry-680.html ã??å??å??ã?? WebCam ã??é??ç??ã??ã?Ÿã??ã??ã??ã??ã??
package {
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * å??ç??ãƒ?ã??ãƒ?ã??ã??ä??ã??ã?Ÿã??ã??ãƒ?ã??ãƒ?ç??åƒ?ã??åŠ?å??
	 * @author YOSHIDA, Akio (Aquioux)
	 */
	[SWF(width = "465", height = "465", frameRate = "30", backgroundColor = "#FFFFFF")]
	
	public class Main extends Sprite {
		
		public function Main() {
			// Model ã??ç?Ÿæ??
			try {
				var model:Model = new Model(stage);
			} catch (err:Error) {
				trace(err.message);
				return;
			}
			
			// View ã??ç?Ÿæ??
			var view:View = new View(model);
			addChild(view);
			view.commands = model.commands;
			
			// é??å??
			model.start();
		}
	}
}


import flash.display.BitmapData;
import flash.display.GraphicsPathCommand;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filters.ConvolutionFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.Camera;
import flash.media.Video;
/**
 * Web Camera ã??æ??åƒ?ã??ã??ãƒ?ã??ã??ãƒ?ã??ã??ã??ã??ï??MVC ã?? Modelï??
 * ã??ãƒ?ã??ã??ãƒ?ãƒ?ã??ãƒƒã??ã?? effector ã??ãƒ?ã??ã??ã??ã??å??éƒ?ã??å?šç??ã??ã??
 * @author YOSHIDA, Akio (Aquioux)
 */
class Model extends EventDispatcher {
	// --------------------------------------------------
	// å?šæ??
	// --------------------------------------------------
	// æ??ç??é??éš?
	private const INTERVAL:uint = 6;
	// ã??ãƒƒã??æ?œå?ºã??å??ã??
	private const DEPTH:Number = 5.0;
	
	
	// --------------------------------------------------
	// View ã??æ??ã??ãƒ?ãƒ?ã??ï??ãƒ?ãƒ?ãƒ?ãƒ?ã??ï??
	// --------------------------------------------------
	public function get commands():Vector.<int> { return _commands; }
	private var _commands:Vector.<int>;
	
	public function get data():Vector.<Number> { return _data; }
	private var _data:Vector.<Number>;
	
	
	// --------------------------------------------------
	// å??éƒ?ã??ã??é?šä??ã??ã?Šã??ã?ªã??ãƒ?ã??ãƒƒãƒ?
	// --------------------------------------------------
	/**
	 * å?? View ç??ãƒ?ã??ãƒƒãƒ?
	 * ã??ã??ãƒ?ã??ãƒƒãƒ?ã??çµ?äº?æ??ã??ã??ãƒ?ãƒ?ãƒ?ã??ç?ºè?Œã??ã??ã??ã??ã??View ã??ã??é?šä??æ??æ?µã??ã?ªã??
	 * @private
	 */
	// ConvolutionFilter ç??ãƒžãƒ?ãƒªã??ã??
	private const HORISON_MATRIX:Array = [
		-1,     0, 1,
		-DEPTH, 0, DEPTH,
		-1,     0, 1
	];
	private const VERTICAL_MATRIX:Array = [
		-1, -DEPTH, -1,
		0,  0,      0,
		1,  DEPTH,  1
	];
	private const HORISON_FILTER:ConvolutionFilter  = new ConvolutionFilter(3, 3, HORISON_MATRIX);
	private const VERTICAL_FILTER:ConvolutionFilter = new ConvolutionFilter(3, 3, VERTICAL_MATRIX);
	private const ZERO_POINT:Point = new Point(0, 0);
	private function update():void {
		bmd.draw(video, matrix);	// ã??ã??ãƒ?ã??ãƒ?æ??åƒ?å??ã?Šè??ã??
		grayscale.applyEffect(bmd);	// ã??ãƒ?ã??ã??ã??ãƒ?ãƒ?é??ç??
		cloneBmd = bmd.clone();		// è??è??
		// ConvolutionFilter é??ç??
		bmd.applyFilter(bmd, rect, ZERO_POINT, HORISON_FILTER);
		cloneBmd.applyFilter(cloneBmd, rect, ZERO_POINT, VERTICAL_FILTER);
		// å??æ??åŒ?é??ç??
		smoothing.applyEffect(bmd);
		smoothing.applyEffect(cloneBmd);
		
		// View ç??ãƒ?ãƒ?ã?? data ã??æ?ºå?š
		var cnt:uint = 0;
		for (var i:int = 0; i < numY; i++) {
			for (var j:int = 0; j < numX; j++) {
				var startX:uint = j * INTERVAL;
				var startY:uint = i * INTERVAL;
				var colorX:uint = bmd.getPixel(startX, startY);
				var colorY:uint = cloneBmd.getPixel(startX, startY);
				var xx:uint = colorX & 0xFF;
				var yy:uint = colorY & 0xFF;
				var radian:Number = Math.atan2(yy, xx);
				var strength:Number = Math.sqrt(xx * xx + yy * yy);
				var endX:Number = Math.cos(radian) * strength / INTERVAL + startX;
				var endY:Number = Math.sin(radian) * strength / INTERVAL + startY;
				_data[cnt * 4]     = startX;
				_data[cnt * 4 + 1] = startY;
				_data[cnt * 4 + 2] = endX;
				_data[cnt * 4 + 3] = endY;
				cnt++;
			}
		}
		
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	// --------------------------------------------------
	// ãã®ä»–ã®ãƒ¡ã‚½ãƒƒãƒ‰
	// --------------------------------------------------
	/**
	 * ã‚³ãƒ³ã‚¹ãƒˆãƒ©ã‚¯ã‚¿
	 * ã‚³ãƒ³ã‚¹ãƒˆãƒ©ã‚¯ã‚¿ã®å¼•æ•°ã¯ã‚¹ãƒ†ãƒ¼ã‚¸ã¨ã™ã‚‹ã€‚å„ç¨®ãƒ‡ãƒ¼ã‚¿ã¯ã‚¢ã‚¯ã‚»ã‚µãƒ¼ã«ã‚ˆã£ã¦å–ã‚Šè¾¼ã‚€ã‚‚ã®ã¨ã™ã‚‹
	 * @param	stage	ã‚¹ãƒ†ãƒ¼ã‚¸
	 */
	private var stage:Stage;
	
	// ã‚«ãƒ¡ãƒ©ãŒè¡¨ç¤ºã™ã‚‹ã‚µã‚¤ã‚º
	private var cameraWidth:uint;
	private var cameraHeight:uint;
	// ã‚«ãƒ¡ãƒ©
	private var camera:Camera;
	private var video:Video;
	private var bmd:BitmapData;
	private var cloneBmd:BitmapData;
	private var matrix:Matrix;
	private var rect:Rectangle;
	private var numX:uint;
	private var numY:uint;
	public function Model(stage:Stage, cw:Number = 0, ch:Number = 0) {
		this.stage = stage;
		this.cameraWidth  = (cw == 0) ? stage.stageWidth  : cw;
		this.cameraHeight = (ch == 0) ? stage.stageHeight : ch;
		
		bmd      = new BitmapData(cameraWidth, cameraHeight, false);
		cloneBmd = bmd.clone();
		matrix   = new Matrix( -1, 0, 0, 1, cameraWidth, 0);
		rect     = bmd.rect;
		
		numX = cameraWidth  / INTERVAL;
		numY = cameraHeight / INTERVAL;
		// View ç”¨ãƒ‡ãƒ¼ã‚¿ã®ç”Ÿæˆ
		_commands = new Vector.<int>(numX * numY * 2, true);
		_data     = new Vector.<Number>(numX * numY * 4, true);
		// View ç”¨ãƒ‡ãƒ¼ã‚¿ commands ã®æ±ºå®š
		var n:uint = _commands.length / 2;
		for (var i:int = 0; i < n; i++) {
			_commands[i * 2]     = GraphicsPathCommand.MOVE_TO;
			_commands[i * 2 + 1] = GraphicsPathCommand.LINE_TO;
		}
		
		// ã‚«ãƒ¡ãƒ©
		camera = Camera.getCamera();
		if (camera) {
			// camera ã®ã‚»ãƒƒãƒˆã‚¢ãƒƒãƒ—
			camera.setMode(cameraWidth, cameraHeight, stage.frameRate);
			// video ã®ã‚»ãƒƒãƒˆã‚¢ãƒƒãƒ—
			video = new Video(cameraWidth, cameraHeight);
			video.attachCamera(camera);
		} else {
			throw new Error("ã‚«ãƒ¡ãƒ©ãŒã‚ã‚Šã¾ã›ã‚“ã€‚");
		}
	}
	
	/**
	 * å‡¦ç†é–‹å§‹
	 */
	private var grayscale:EffectorGrayScale;
	private var smoothing:EffectorSmoothing;
	public function start():void {
		grayscale = new EffectorGrayScale();
		smoothing = new EffectorSmoothing();
		smoothing.strength = 8;
		stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	/**
	 * ã‚¤ãƒ™ãƒ³ãƒˆãƒãƒ³ãƒ‰ãƒ©
	 * @private
	 */
	private function enterFrameHandler(event:Event):void {
		update();
	}
}


import flash.display.Graphics;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
/**
 * Web Camera ã®ã‚¹ã‚¯ãƒªãƒ¼ãƒ³ï¼ˆMVC ã® Viewï¼‰
 * @author YOSHIDA, Akio (Aquioux)
 */
class View extends Sprite {
	/**
	 * ã‚³ãƒ³ã‚¹ãƒˆãƒ©ã‚¯ã‚¿
	 * @param	model	Model
	 */
	private var model:Model;
	public function View(model:Model) {
		init();
		this.model = model;
		this.model.addEventListener(Event.CHANGE, changeHandler);
	}
	
	private var graphicsData:Vector.<IGraphicsData>;
	private var path:GraphicsPath;
	private function init():void{
		var stroke:GraphicsStroke = new GraphicsStroke();
		stroke.thickness = 0;
		stroke.fill = new GraphicsSolidFill(0x000000);
		
		var commands:Vector.<int> = new Vector.<int>();
		var data:Vector.<Number> = new Vector.<Number>();
		path = new GraphicsPath(commands, data);
		
		var endfill:GraphicsEndFill = new GraphicsEndFill();
		
		graphicsData = new Vector.<IGraphicsData>();
		graphicsData.push(stroke);
		graphicsData.push(path);
		graphicsData.push(endfill);
	}
	
	public function set commands(commands:Vector.<int>):void {
		path.commands = commands;
	}
	
	/**
	 * Model ã¨ã®é€šä¿¡æ‰‹æ®µ
	 * @param	event	ç™ºç”Ÿã—ãŸã‚¤ãƒ™ãƒ³ãƒˆ
	 */
	private function changeHandler(event:Event):void {
		// Model ã??ã??ãƒ?ãƒ?ã??ã??å??ã??å??ã?Šã??è??è?šåŒ?
		path.data = model.data;
		
		var g:Graphics = this.graphics;
		g.clear();
		g.drawGraphicsData(graphicsData);
	}
}


import flash.display.BitmapData;
import flash.geom.Point;
/**
 * BitmapData ã??ãƒ?ã??ã??ãƒ?ç??æŠ?è??ã??ãƒ?ã??
 * @author YOSHIDA, Akio
 */
class AbstractEffector {
	/*
	* BitmapData.applyFilter ã?? destPoint ã??ã??ã??ä??ç??ã??ã?? Point ã?ªãƒ?ã??ã??ã??ãƒ?
	*/
	protected const ZERO_POINT:Point = new Point(0, 0);
	
	/*
	* ã??ãƒ?ã??ãƒ?ãƒ?ã??ã??
	*/
	public function AbstractEffector() {}
	
	/*
	* åŠ?æžœã??é??ç??
	* @param	value	åŠ?æžœã??ã??ã??ã?? BitmapData
	*/
	public function applyEffect(value:BitmapData):BitmapData {
		return effect(value);
	}
	
	/*
	* åŠ?æžœå??å??ã??å??ä??çš?ã?ªã??ãƒ?ãƒ?ã??ã?µãƒ?ã??ãƒ?ã??ã??å?šç??ã??ã??
	* @param	value	åŠ?æžœã??ã??ã??ã?? BitmapData
	*/
	protected function effect(value:BitmapData):BitmapData {
		return value;
	}
}


import flash.display.BitmapData;
import flash.filters.ColorMatrixFilter;
/**
 * ColorMatrixFilter ã??ã??ã?? BitmapData ã??ã??ãƒ?ã??ã??ã??ãƒ?ãƒ?åŒ?ï??NTSC ç??åŠ?é??å??å??ã??ã??ã??ï??
 * å??è?ƒï?šFoundation ActionScript 3.0 Image Effects(P106)
 * 		http://www.amazon.co.jp/gp/product/1430218711?ie=UTF8&tag=laxcomplex-22
 * @author YOSHIDA, Akio (Aquioux)
 */
class EffectorGrayScale extends AbstractEffector {
	// ColorMatrixFilter
	private const GRAYSCALE_MATRIX:Array = [
		0.3, 0.6, 0.1, 0, 0,
		0.3, 0.6, 0.1, 0, 0,
		0.3, 0.6, 0.1, 0, 0,
		0,   0,   0,   1, 0
	];
	private const GRAYSCALE_FILTER:ColorMatrixFilter = new ColorMatrixFilter(GRAYSCALE_MATRIX);
	
	/*
	* ã??ãƒ?ã??ã??ã??ãƒ?ãƒ?å?Ÿè?Œ
	* @param	value	åŠ?æžœã??ã??ã??ã?? BitmapData
	*/
	override protected function effect(value:BitmapData):BitmapData {
		value.applyFilter(value, value.rect, ZERO_POINT, GRAYSCALE_FILTER);
		return value;
	}
}


import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
/**
 * BlurFilter ã??ã??ã??å??æ??åŒ?
 * @author YOSHIDA, Akio (Aquioux)
 */
class EffectorSmoothing extends AbstractEffector {
	/*
	* ã??ã??ã??ã??é??
	* @param	value	æ??å??
	*/
	public function set strength(value:Number):void {
		blurFilter.blurX = blurFilter.blurY = value;
	}
	/*
	* ã??ã??ã??ã??è?ª
	* @param	value	æ??å??
	*/
	public function set quality(value:int):void {
		blurFilter.quality = value;
	}
	// ãƒ?ãƒ?ãƒ?ãƒ?ã??ãƒ?ã??
	private var blurFilter:BlurFilter;
	public function EffectorSmoothing() {
		blurFilter = new BlurFilter(2, 2, BitmapFilterQuality.MEDIUM);
	}
	
	/*
	* å??æ??åŒ?å?Ÿè?Œ
	* @param	value	åŠ?æžœã??ã??ã??ã?? BitmapData
	*/
	override protected function effect(value:BitmapData):BitmapData {
		value.applyFilter(value, value.rect, ZERO_POINT, blurFilter);
		return value;
	}
}
