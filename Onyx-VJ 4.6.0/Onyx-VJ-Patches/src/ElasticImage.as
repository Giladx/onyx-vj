/**
 * Copyright late4 ( http://wonderfl.net/user/late4 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/bx5A
 */

package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * @author Saqoosha
	 */
	public class ElasticImage extends Patch {
		
		private const SEGMENT_W:uint = 7;
		private const SEGMENT_H:uint = 5;
		
		// BitmapData
		private var imageBitmapData:BitmapData;
		
		private var segmentation:Segmentation;
		
		private var anchorContainer:Sprite;
		private var jointContainer:Sprite;
		private var imageContainer:Sprite;
		private var anchorVector:Vector.<Anchor>;
		private var jointVector:Vector.<Joint>;
		
		private var anchorPairVector:Vector.<int>;
		
		private var imageGraphicsData:Vector.<IGraphicsData>;
		private var trianglePath:GraphicsTrianglePath;
		private var jointGraphicsData:Vector.<IGraphicsData>;
		private var jointPath:GraphicsPath;
		
		private var draggingAnchor:Anchor;
		private var anchorVisible:Boolean = false;
		private var jointVisible:Boolean  = false;
		private var camera:Camera;
		private var video:Video;
		private const CAMERA_WIDTH:uint  = 180;
		private const CAMERA_HEIGHT:uint = 280;
		
		private var sprite:Sprite;
		private var mx:int = 10;
		private var my:int = 10;
		private var av:int = 0;
		
		
		public function ElasticImage() 
		{
			sprite = new Sprite();
			camera = Camera.getCamera();
			if (camera != null) {
				setup();
			} else {
				Console.output("camera problem");
			}

			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		private function setup():void {
			// camera 
			camera.setMode(CAMERA_WIDTH, CAMERA_HEIGHT, 60);
			
			// video 
			video = new Video(CAMERA_WIDTH, CAMERA_HEIGHT);
			video.attachCamera(camera);
			imageBitmapData = new BitmapData(CAMERA_WIDTH, CAMERA_HEIGHT);
			imageBitmapData.draw(video);
			
			next();
		}
		private function next():void {
			// ã??ã??ã??ã??ã??å??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ç??æ??
			segmentation = new Segmentation(SEGMENT_W, SEGMENT_H);
			
			// å??ã??ã??ã??ã??ã??ç??æ??
			initStage();
			// GraphicsTrianglePath ç?? Vector ã??ç??æ??
			var verticies:Vector.<Number> = new Vector.<Number>();        // vertics ã®ç”Ÿæˆ
			var indicies:Vector.<int>   = segmentation.getIndicies();    // inducides ã®ç”Ÿæˆ
			var uvDatas:Vector.<Number> = segmentation.getUvDatas();    // uvDatas ã®ç”Ÿæˆ
			
			// imageGraphicsData ã®ç”Ÿæˆ
			imageGraphicsData = new Vector.<IGraphicsData>(3);
			imageGraphicsData.push(new GraphicsBitmapFill(imageBitmapData));
			imageGraphicsData.push(trianglePath = new GraphicsTrianglePath(verticies, indicies, uvDatas));
			imageGraphicsData.push(new GraphicsEndFill());
			
			// ã‚¢ãƒ³ã‚«ãƒ¼ã®ç”Ÿæˆï¼ˆâ†‘ã§ä½œã£ãŸ uvDatas ã‚’ä½¿ã†ï¼‰
			createAnchor(uvDatas);
			// ã‚¢ãƒ³ã‚«ãƒ¼ã®ãƒšã‚¢ãƒªãƒ³ã‚°
			anchorPairVector = segmentation.getVertexPair();
			
			// ã‚¸ãƒ§ã‚¤ãƒ³ãƒˆã®ç”Ÿæˆ
			createJoint();
			// å›ºå®šã‚¢ãƒ³ã‚«ãƒ¼ã®è¨­å®š
			var anchor:Anchor = anchorVector[0];
			anchor.isFix = true;
			anchor.x = 20;
			anchor = anchorVector[SEGMENT_W];
			anchor.isFix = true;
			anchor.x = DISPLAY_WIDTH - 20;
			
			// ã‚¸ãƒ§ã‚¤ãƒ³ãƒˆè¡¨ç¤ºç”¨ graphicsData ã®ç”Ÿæˆ
			// ç·šã®çŠ¶æ…‹
			var stroke:GraphicsStroke = new GraphicsStroke(0);
			stroke.fill = new GraphicsSolidFill(0xFF0000, 0.5);
			// ãƒ‘ã‚¹
			var commands:Vector.<int> = segmentation.getPathCommands(anchorPairVector);            // ã‚³ãƒžãƒ³ãƒ‰
			var data:Vector.<Number> = segmentation.getPathData(anchorVector, anchorPairVector);// ãƒ‡ãƒ¼ã‚¿
			jointPath = new GraphicsPath(commands, data);
			// GraphicsData
			jointGraphicsData = new Vector.<IGraphicsData>(2);
			jointGraphicsData.push(stroke);
			jointGraphicsData.push(jointPath);
			
			// ã‚¤ãƒ™ãƒ³ãƒˆãƒãƒ³ãƒ‰ãƒ©
			anchorContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			anchorContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
		}
		
		// å„ã‚³ãƒ³ãƒ†ãƒŠã®ç”Ÿæˆ
		private function initStage():void {
			imageContainer  = new Sprite();
			jointContainer  = new Sprite();
			anchorContainer = new Sprite();
			sprite.addChild(imageContainer);
			sprite.addChild(jointContainer);
			sprite.addChild(anchorContainer);
		}
		
		// ã‚¢ãƒ³ã‚«ãƒ¼ã®ç”Ÿæˆ
		private function createAnchor(uvData:Vector.<Number>):void {
			Anchor.left   = 0;
			Anchor.right  = DISPLAY_WIDTH;
			Anchor.top    = 0;
			Anchor.bottom = DISPLAY_HEIGHT;
			var n:uint = uvData.length / 2;
			anchorVector = new Vector.<Anchor>(n);
			var imageWidth:uint  = imageBitmapData.width;
			var imageHeight:uint = imageBitmapData.height;
			var offsetX:Number = (DISPLAY_WIDTH  - imageWidth)  / 2;
			var offsetY:Number = 20;//(stage.stageHeight - imageHeight) / 2;
			for (var i:uint = 0; i < n; i++) {
				var anchor:Anchor = new Anchor(15, 0xFFFFFF);
				anchor.x = imageWidth  * uvData[i * 2]     + offsetX;
				anchor.y = imageHeight * uvData[i * 2 + 1] + offsetY;
				anchorContainer.addChild(anchor);
				anchorVector[i] = anchor;
			}
		}
		
		// ã‚¸ãƒ§ã‚¤ãƒ³ãƒˆã®ç”Ÿæˆ
		private function createJoint():void {
			var n:uint = anchorPairVector.length / 2;
			jointVector = new Vector.<Joint>(n);
			for (var i:uint = 0; i < n; i++) {
				var a:uint = anchorPairVector[i * 2];
				var b:uint = anchorPairVector[i * 2 + 1];
				var joint:Joint = new Joint(anchorVector[a], anchorVector[b]);
				jointVector[i] = joint;
			}
		}
		private function keyDownHandler(event:KeyboardEvent):void {
			if (event.charCode == 97) {        // "a" ã??ã??ã??ã??ã??ã??ã??è??ç?º
				anchorVisible = !anchorVisible;
				for each (var anchor:Anchor in anchorVector) {
					anchor.isVisible = anchorVisible;
				}
			}
			if (event.charCode == 106) {    // "j" ã??ã??ã??ã??ã??ã??ã??ã??è??ç?º
				jointVisible = !jointVisible;
				if (!jointVisible) {
					jointContainer.graphics.clear();
				}
			}
		}
		
		// ã??ã??ã??ã??ã??ã??ã??
		private function onMouseDown(event:MouseEvent):void {
			mx = event.localX;
			my = event.localY;
			
			if (av++ > anchorVector.length - 1) av = 0;
			draggingAnchor = anchorVector[av];
			draggingAnchor.mouseDown(mx, my, true);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		private function mouseDownHandler(event:MouseEvent):void {
			mx = event.localX;
			my = event.localY;
			draggingAnchor = Anchor(event.target);
			draggingAnchor.mouseDown(mx, my, true);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		private function mouseUpHandler(event:MouseEvent):void {
			if (draggingAnchor != null) {
				draggingAnchor.mouseDown(mx, my, false);
			}
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);		
		}	
		private function mouseMove(event:MouseEvent):void {
			mx = event.localX;
			my = event.localY;	
			draggingAnchor.mouseDown(mx, my, true);
		}

		override public function render(info:RenderInfo):void 
		{
			for each (var joint:Joint in jointVector) {
				joint.update();
			}
			for each (var anchor:Anchor in anchorVector) {
				anchor.update();
			}
			
			// ã??ã??ã??æ??å??æ??æ??
			imageBitmapData.draw(video);
			
			// ã??ã??ã??ã??ã??è??ç?º
			// vertics ã??æ??æ??
			trianglePath.vertices = segmentation.getVerticies(anchorVector);
			// æ??ç??
			imageContainer.graphics.clear();
			imageContainer.graphics.drawGraphicsData(imageGraphicsData);
			
			// ã??ã??ã??ã??ã??ã??è??ç?º
			if (jointVisible) {
				// data ã??æ??æ??
				jointPath.data = segmentation.getPathData(anchorVector, anchorPairVector);
				// æ??ç??
				jointContainer.graphics.clear();
				jointContainer.graphics.drawGraphicsData(jointGraphicsData);
			}

			info.render(sprite);
		}
	}
}
import flash.display.GraphicsPathCommand;
class Segmentation {
	private var segW:uint;        // ã??ã??ã??ã??ã??æ??ï??å??ï??
	private var segH:uint;        // ã??ã??ã??ã??ã??æ??ï??é??ï??
	private var numOfVertex:uint;    // é??ç??æ??
	private var pairVector:Vector.<int>;
	
	// ã??ã??ã??ã??ã??ã??ã??
	public function Segmentation(segW:uint, segH:uint) {
		this.segW = segW;
		this.segH = segH;
		numOfVertex = (segW + 1) * (segH + 1);
	}
	
	// ---- drawTriangle ç?? -----
	// verticies ã??ç??æ??ï??updata ã??ã??ã??ã??å??ã??ã??ã??ï??
	public function getVerticies(anchorVector:Vector.<Anchor>):Vector.<Number> {
		var n:uint = numOfVertex;
		var verticies:Vector.<Number> = new Vector.<Number>(n * 2);
		for (var i:int = 0; i < n; i++) {
			verticies[i * 2]     = anchorVector[i].x;
			verticies[i * 2 + 1] = anchorVector[i].y;
		}
		return verticies;
	}
	// indicies ã??ç??æ??ï??æ??å??ã??ä??åº?ã??ã??å??ã??ã??ã??ï??
	public function getIndicies():Vector.<int> {
		var sW:uint = segW;
		var sH:uint = segH;
		var indicies:Vector.<int> = new Vector.<int>(sW * sH * 6);
		var cnt:uint = 0;
		for (var i:uint = 0; i < sH; i++) {
			for (var j:uint = 0; j < sW; j++) {
				var leftTop:uint  = i * (sW + 1) + j;
				var rightTop:uint = i * (sW + 1) + j + 1;
				var leftBottom:uint  = (i + 1) * (sW + 1) + j;
				var rightBottom:uint = (i + 1) * (sW + 1) + j + 1;
				indicies[cnt]     = leftTop;
				indicies[cnt + 1] = rightTop;
				indicies[cnt + 2] = leftBottom;
				indicies[cnt + 3] = rightTop;
				indicies[cnt + 4] = rightBottom;
				indicies[cnt + 5] = leftBottom;
				cnt += 6;
			}
		}
		return indicies;
	}
	// uvDatas ã??ç”Ÿæˆï¼ˆæœ€åˆã«ä¸€åº¦ã ã‘å‘¼ã°ã‚Œã‚‹ï¼‰
	public function getUvDatas():Vector.<Number> {
		var sW:uint = segW;
		var sH:uint = segH;
		var uvDatas:Vector.<Number> = new Vector.<Number>(numOfVertex * 2);
		var cnt:uint = 0;
		for (var i:uint = 0; i < sH + 1; i++) {
			for (var j:uint = 0; j < sW + 1; j++) {
				uvDatas[cnt++] = j / sW;
				uvDatas[cnt++] = i / sH;
			}
		}
		return uvDatas;
	}
	
	// ----- ã‚¸ãƒ§ã‚¤ãƒ³ãƒˆç”¨ -----
	// ãƒ‘ã‚¹ã® commands ã®ç”Ÿæˆï¼ˆæœ€åˆã«ä¸€åº¦ã ã‘å‘¼ã°ã‚Œã‚‹ï¼‰
	public function getPathCommands(pair:Vector.<int>):Vector.<int> {
		var n:uint = pair.length;
		var commands:Vector.<int> = new Vector.<int>(n);
		n /= 2;
		for (var i:uint = 0; i < n; i++) {
			commands[i * 2]     = GraphicsPathCommand.MOVE_TO;
			commands[i * 2 + 1] = GraphicsPathCommand.LINE_TO;
		}
		return commands;
	}
	// ãƒ‘ã‚¹ã® data ã®ç”Ÿæˆï¼ˆupdata ã®ãŸã³ã«å‘¼ã°ã‚Œã‚‹ï¼‰
	public function getPathData(anchors:Vector.<Anchor>, pair:Vector.<int>):Vector.<Number> {
		var n:uint = pair.length;
		var data:Vector.<Number> = new Vector.<Number>(n * 2);
		for (var i:uint = 0; i < n; i++) {
			var anchor:Anchor = anchors[pair[i]];
			data[i * 2]     = anchor.x;
			data[i * 2 + 1] = anchor.y;
		}
		return data;
	}
	
	// ----- é ‚ç‚¹ã®ãƒšã‚¢ãƒªãƒ³ã‚° -----
	public function getVertexPair():Vector.<int> {
		var sW:uint = segW;
		var sH:uint = segH;
		pairVector = new Vector.<int>();
		// æ¨ª
		for (var i:uint = 0; i < sH + 1; i++) {
			for (var j:uint = 0; j < sW; j++) {
				var a:uint = i * (sW + 1) + j;
				var b:uint = i * (sW + 1) + j + 1;
				pairVector.push(a, b);
			}
		}
		// ç¸¦
		for (i = 0; i < sH; i++) {
			for (j = 0; j < sW+1; j++) {
				a =  i      * (sW + 1) + j;
				b = (i + 1) * (sW + 1) + j;
				pairVector.push(a, b);
			}
		}
		
		// æ–œã‚ï¼ˆå·¦ä¸Šã‹ã‚‰å³ä¸‹ï¼‰
		for (i = 0; i < sH; i++) {
			for (j = 0; j < sW; j++) {
				a = i * (sW + 1) + j;
				b = (i + 1) * (sW + 1) + j + 1;
				pairVector.push(a, b);
			}
		}
		// æ–œã‚ï¼ˆå³ä¸Šã‹ã‚‰å·¦ä¸‹ï¼‰
		for (i = 0; i < sH; i++) {
			for (j = 0; j < sW; j++) {
				a =  i      * (sW + 1) + j + 1;
				b = (i + 1) * (sW + 1) + j;
				pairVector.push(a, b);
			}
		}
		
		if (sW % 2 == 0) {
			// æ¨ªæ–œã‚ï¼ˆå·¦ä¸Šã‹ã‚‰å³ä¸‹ï¼‰
			for (i = 0; i < sH; i++) {
				for (j = 0; j < sW - 1; j += 2) {
					a = i * (sW + 1) + j;
					b = (i + 1) * (sW + 1) + j + 2;
					pairVector.push(a, b);
				}
			}
			// æ¨ªæ–œã‚ï¼ˆå³ä¸Šã‹ã‚‰å·¦ä¸‹ï¼‰
			for (i = 0; i < sH; i++) {
				for (j = 0; j < sW; j+=2) {
					a =  i      * (sW + 1) + j + 2;
					b = (i + 1) * (sW + 1) + j;
					pairVector.push(a, b);
				}
			}
		}
		if (sH % 2 == 0) {
			// ç¸¦æ–œã‚ï¼ˆå·¦ä¸Šã‹ã‚‰å³ä¸‹ï¼‰
			for (i = 0; i < sH; i += 2) {
				for (j = 0; j < sW; j++) {
					a = i * (sW + 1) + j;
					b = (i + 2) * (sW + 1) + j + 1;
					pairVector.push(a, b);
				}
			}
			// ç¸¦æ–œã‚ï¼ˆå³ä¸Šã‹ã‚‰å·¦ä¸‹ï¼‰
			for (i = 0; i < sH; i+=2) {
				for (j = 0; j < sW; j++) {
					a =  i      * (sW + 1) + j + 1;
					b = (i + 2) * (sW + 1) + j;
					pairVector.push(a, b);
				}
			}
		}
		return pairVector;
	}
}
import flash.display.Sprite;
class Anchor extends Sprite {
	// ç??ç??ç??æ??å??
	static public var gravity:Number  = 0.47;    // é??å??
	static public var friction:Number = 0.92;    // ç?ºæ??æ?µæ??
	static public var floorFriction:Number = 1;    // åº?é??æ?µæ??
	static public var bounce:Number = 1;        // è??ã??è??ã??
	// å??é??å??
	static public var left:Number;
	static public var right:Number;
	static public var top:Number;
	static public var bottom:Number;
	
	// å?ºå??ã??ã??ã??
	private var _isFix:Boolean = false;
	public function set isFix(value:Boolean):void {
		this.isVisible = _isFix = value;
		circleDraw(true);
	}
	
	private var _isVisible:Boolean = false;
	public function set isVisible(value:Boolean):void {
		if(!_isFix){
			_isVisible = value;
			circleDraw(_isVisible);
		}
	}
	
	// è??ç??ç??å??æ??
	// é??åº?
	private var vx:Number = 0;
	private var vy:Number = 0;
	// å??ã??ã??ã??ã??ã??åº?æ??å??
	private var prevX:Number = 0;
	private var prevY:Number = 0;
	// å??æ??å??æ??ç??ã??å??
	private var sx:Number = 0;
	private var sy:Number = 0;
	// ã??ã??ã??ã??å??å??
	private var isMouseDown:Boolean = false;
	
	private var radius:Number;
	private var color:uint;
	
	private const LIMIT:Number = 10.0;
	public function Anchor(radius:Number = 10.0, color:uint = 0x0000FF):void {
		this.radius = radius;
		this.color  = color;
		circleDraw(_isVisible);
		buttonMode = true;
	}
	
	// å??æ??ç??
	private function circleDraw(flg:Boolean):void {
		var a:Number = flg ? 0.25 : 0.0;
		graphics.clear();
		graphics.beginFill(color, a);
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();
	}
	// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ä??ã??å??ã??
	public function mouseDown(mx:int, my:int, flg:Boolean):void {//
		x = mx;
		y = my;
		isMouseDown = flg;
		//(isMouseDown) ? startDrag() : stopDrag();
	}
	public function mouseMove(mx:int, my:int):void {
		x = mx;
		y = my;
	}
	// ã??ã??ã??ã??
	public function accelalete(valX:Number, valY:Number):void {
		vx = valX;
		vy = valY;
	}
	// ã??ã??ã??ã??ã??ã??å??æ??å??ã??å??æ??
	public function setStiffness(valX:Number, valY:Number):void {
		sx += valX;
		sy += valY;
	}
	public function update():void {
		if (isMouseDown) {    // ã??ã??ã??ã??ã??ã??ã??ã??å??å??
			// å??å??ç??
			if (x < left) { x = left; }        // å??å??é??
			if (x > right) { x = right; }    // å??å??é??
			if (y < top) { y = top; }        // å??äº?
			if (y > bottom) { y = bottom; }    // åº?
			// è??ç??
			var tmpX:Number = x;
			var tmpY:Number = y;
			vx = x - prevX;
			vy = y - prevY;
			prevX = tmpX;
			prevY = tmpY;
		} else {            // ã??ã??ã??ã??ã??ã??ã??ã?ªã??å??å??
			if(!_isFix){
				// å??å??ç??
				if (x < left) {
					x = left;
					vx *= floorFriction;
					vx *= bounce;
				} else if (x > right) {
					x = right;
					vx *= floorFriction;
					vx *= bounce;
				}
				if (y < top) {
					y = top;
					vy *= floorFriction;
					vy *= bounce;
				} else if (y > bottom) {
					y = bottom;
					vy *= floorFriction;
					vy *= bounce;
				}
				// è??ç??
				vx = Math.max( -LIMIT, Math.min(LIMIT, vx));
				vy = Math.max( -LIMIT, Math.min(LIMIT, vy));
				vx += sx;
				vy += sy;
				vx *= friction;
				vy *= friction;
				vy += gravity;
				x += vx;
				y += vy;
			}
			// å??æ??å??ã??å??æ??å??
			sx = 0;
			sy = 0;
		}
	}
}
class Joint {
	// ç??ç??ç??æ??å??
	static public var stiffness:Number = 0.025;// å??æ??å??
	// ä??ç??ã??ã??ã??ã??ã??
	private var a:Anchor;    // ç??ç??ã??ã??ã??ã??ã??
	private var b:Anchor;    // ã??ã??ç??ç??ã??ã??ã??ã??ã??
	// ã??ã??ã??ã??é??ã??å??
	private var defaultDistance:Number = 0;    // ã??ã??ã??ã??é??ã??è??é??ï??æ??å??å??ï??
	private var distanceXY:Number;            // ã??ã??ã??ã??é??ã??è??é??ï??å??é??ã??å??ï??
	private var distanceX:Number;    // distanceXY ã??æ??ã??ã??ã??ã??ã?? Xåº?æ??å??
	private var distanceY:Number;    // distanceXY ã??æ??ã??ã??ã??ã??ã?? Yåº?æ??å??
	public function Joint(a:Anchor, b:Anchor):void {
		this.a = a;
		this.b = b;
		getAnchorData();
		defaultDistance = distanceXY;
	}
	// ã??ã??ã??ã??ã??ã??å??æ??è??ç??ã??ã??ã??ã?ªã??ã??å??è??ã??ã??ã??ã??ã??å??æ??ã??ã??ã??
	public function update():void {
		getAnchorData();
		var s:Number  = stiffness * (distanceXY - defaultDistance);
		var sx:Number = s * distanceX / distanceXY;
		var sy:Number = s * distanceY / distanceXY;
		a.setStiffness(-sx, -sy);
		b.setStiffness( sx,  sy);
	}
	// ã??ã??ã??ã??é??ã??å??ã??æ??æ??
	private function getAnchorData():void {
		var x:Number = a.x - b.x;
		var y:Number = a.y - b.y;
		distanceXY = Math.sqrt(x * x + y * y);
		distanceX = x;
		distanceY = y;
	}
}