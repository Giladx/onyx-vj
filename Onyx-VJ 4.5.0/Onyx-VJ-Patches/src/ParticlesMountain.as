/**
 * Copyright lagash ( http://wonderfl.net/user/lagash )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/hm0p
 */

// å‚¾æ–œãƒ—ãƒ©ã‚¯ãƒ†ã‚£ã‚¹ ver.6ã€€boidsåŒ–ã—ãŸ
// 
// 
// mouse drag	åœ°å½¢ã‚¹ã‚¯ãƒ­ãƒ¼ãƒ«
// click		åœ°å½¢éš†èµ·/æ²ˆé™
// [space]		ä¸Šè¨˜éš†èµ·/æ²ˆé™ãƒˆã‚°ãƒ«
// [enter]		åœ°å½¢ãƒªã‚»ãƒƒãƒˆ
// [r]			ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ãƒªã‚»ãƒƒãƒˆ
//--------------------------------------------

// ä¸‹ã®ã‚°ãƒ©ãƒ•ã¯æŠ˜ã‚Œç·šãŒæ¶ˆæ»…ã—ãŸæ•°ã§ã€æ£’ãŒæ®‹å­˜æ•°ã€‚
// 

//ã€€----------------------------------ã€€

package {
	import adobe.utils.CustomActions;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class ParticlesMountain extends Patch {
		
		var main_bmp:Bitmap;
		var groups_bmp:Bitmap;
		var clearDisplay_bmd:BitmapData;
		var bgbmp:Bitmap;
		var bgbmp_source:Bitmap;
		var rotateBmp:Bitmap;
		
		var groupsContainer:Sprite;
		var shape1:Shape;
		var curves:Object;
		var rotationColor:Number;
		
		var baseMatrix: Matrix = new Matrix();
		var baseRect:Rectangle;
		var basePoint:Point;
		var baseColorTransform:ColorTransform;
		var baseColorTransform2:ColorTransform;
		var ColorMatrixFilter1:ColorMatrixFilter;
		var ColorMatrixFilter2:ColorMatrixFilter;
		var keishaMap:BitmapData;
		
		const maxParticles = 600;
		
		var slopeData_bmd:BitmapData;
		static public var landformData_bmd: BitmapData;
		//private var COLOR: uint = 0xFFFFFF;
		private var seed: int;
		private var mw: int;
		private var mh: int;
		private var arr: Array;
		private var point: Point;
		private var point2: Point;
		
		var centerX:uint;
		var centerY:uint;
		var onDrag:Boolean=false;
		var onDragX:int=0;
		var onDragY:int = 0;
		var onDragStartX:int = 0;
		var onDragStartY:int = 0;
		var toggleBW:Boolean = true;
		
		private var wholeParticles:Vector.<Particle>=new Vector.<Particle>();
		private var sidesVec=wholeParticles;
		private var groups:Vector.<GroupObject> = new Vector.<GroupObject>();
		
		private var textDisp:TextField;
		private var bottomBar:Shape;
		private var dyingLate:Bitmap;
		private var yDlShape:Shape;
		private var cDlShape:Shape;
		
		
		public function ParticlesMountain() {
			
			
			
			//this.buttonMode=this.useHandCursor = true;
			
			landformData_bmd = new BitmapData(DISPLAY_WIDTH / 2+1, DISPLAY_HEIGHT / 2+1);
			main_bmp = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0xff000000), "auto", true);//bitmapå‡¦ç†ç”¨
			main_bmp.alpha = 1;
			main_bmp.blendMode=BlendMode.ADD;
			groups_bmp = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00000000), "auto", true);//bitmapå‡¦ç†ç”¨
			groups_bmp.alpha = 1;
			//groups_bmp.filters = [new BlurFilter(32, 32, 2)];
			groups_bmp.blendMode = BlendMode.ADD;
			clearDisplay_bmd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x01000000);
			slopeData_bmd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0xff000000);//bitmapå‡¦ç†ç”¨
			bgbmp = new Bitmap(new BitmapData(DISPLAY_WIDTH * 3, DISPLAY_HEIGHT * 3), "auto", true);//bitmapå‡¦ç†ç”¨
			bgbmp.x = -DISPLAY_WIDTH;
			bgbmp.y = -DISPLAY_HEIGHT;
			bgbmp_source = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT), "auto", true);//bitmapå‡¦ç†ç”¨
			rotateBmp = new Bitmap(new BitmapData(DISPLAY_WIDTH * 3, DISPLAY_HEIGHT * 3), "auto", true);//bitmapå‡¦ç†ç”¨
			groupsContainer = new Sprite();
			shape1 = new Shape();
			shape1.filters = [new BlurFilter(64, 64, 2)];
			
			textDisp = new TextField();
			textDisp.width=DISPLAY_WIDTH;
			textDisp.y = DISPLAY_HEIGHT-20;
			textDisp.textColor = 0xffffff;
			textDisp.cacheAsBitmap;
			
			bottomBar = new Shape();
			bottomBar.y = DISPLAY_HEIGHT - 10;
			
			dyingLate = new Bitmap(new BitmapData(DISPLAY_WIDTH * .8, 100,true,0x00000000));
			dyingLate.x = (DISPLAY_WIDTH - DISPLAY_WIDTH * .8) / 2;
			dyingLate.y = DISPLAY_HEIGHT - 115;
			yDlShape = new Shape();
			cDlShape = new Shape();
			//dyingLate.alpha = .5;
			
			basePoint = new Point(0, 0);
			baseRect = new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			baseColorTransform = new ColorTransform;
			baseColorTransform.redMultiplier = .03;
			baseColorTransform.greenMultiplier = .06;
			baseColorTransform.blueMultiplier = .02;
			//baseColorTransform.redOffset = baseColorTransform.greenOffset = baseColorTransform.blueOffset = -10;
			baseColorTransform2 = new ColorTransform;
			baseColorTransform2.redMultiplier = baseColorTransform2.greenMultiplier = baseColorTransform2.blueMultiplier = 5;
			//baseColorTransform2.redOffset = 
			baseColorTransform2.greenOffset = 20;
			//baseColorTransform2.blueOffset = 20;
			
			ColorMatrixFilter1 = new ColorMatrixFilter([
				.03, 0, 0, 0, 0,
				0, .06, 0, 0, 0,
				0, 0, .02, 0, 0,
				0, 0, 0, 1, 0
			]);
			ColorMatrixFilter2 = new ColorMatrixFilter([
				5, 0, 0, 0, 0,
				0, 5, 0, 0, 20,
				0, 0, 5, 0, 0,
				0, 0, 0, 1, 0
			]);
			bgbmp.filters = [ColorMatrixFilter1,ColorMatrixFilter2];
			
			baseMatrix.identity();
			baseMatrix.scale(2,2);
						
			addChild(bgbmp);
			addChild(groups_bmp);
			addChild(main_bmp);
			addChild(dyingLate);
			addChild(bottomBar);
			addChild(textDisp);
			
			init();
			setMap();
			
			//ã‚¤ãƒ™ãƒ³ãƒˆç™»éŒ²
			//stage.addEventListener(MouseEvent.DOUBLE_CLICK, mouseClickHandlr);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandlr);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandlr);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandlr);
			//stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandlr);
			addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) {
				if (e.charCode == 32) toggleBW = (!toggleBW);
				if (e.charCode == 13) setMap();
				if (e.charCode == 114) init();
			} );
			
		}
		
		private function mouseClickHandlr(e) {
			setMap();
		}
		
		private function mouseDownHandlr(e:MouseEvent) {
			onDragX=onDragStartX=e.localX;
			onDragY=onDragStartY=e.localY;
			onDrag=true;
		}
		
		private function mouseUpHandlr(e) {
			onDrag = false;
			if (onDragStartX == e.localX && onDragStartY == e.localY) {
				bgbmp.bitmapData.lock();
				shape1.graphics.clear();
				shape1.graphics.beginFill(0xffffff * uint(toggleBW), .2);
				for (var i = -1; i < 2; i++) for (var j = -1; j < 2; j++) shape1.graphics.drawCircle(e.currentTarget.mouseX+i*DISPLAY_WIDTH, e.currentTarget.mouseY+j*DISPLAY_HEIGHT, 32);
				bgbmp_source.bitmapData.draw(shape1);
				landformData_bmd.draw(bgbmp_source.bitmapData, new Matrix(.5, 0, 0, .5, 0, 0));
				for (i = 0; i < 3; i++) for (j = 0; j < 3; j++) bgbmp.bitmapData.copyPixels( bgbmp_source.bitmapData, baseRect, new Point(i * DISPLAY_WIDTH, j * DISPLAY_HEIGHT));
				bgbmp.bitmapData.unlock();
				
			}
		}
		
		private function mouseMoveHandlr(e) {
			if (!onDrag) return;
			
			bgbmp.x -=onDragX-e.currentTarget.mouseX;
			bgbmp.y -=onDragY-e.currentTarget.mouseY;
			onDragX = e.currentTarget.mouseX;
			onDragY = e.currentTarget.mouseY;
			
			bgbmp_source.bitmapData.copyPixels(bgbmp.bitmapData, new Rectangle(-bgbmp.x, -bgbmp.y,DISPLAY_WIDTH,DISPLAY_HEIGHT), basePoint);
			landformData_bmd.draw(bgbmp_source.bitmapData, new Matrix(.5, 0, 0, .5, 0, 0));
			for (var i = 0; i < 3; i++) for (var j = 0; j < 3; j++) bgbmp.bitmapData.copyPixels( bgbmp_source.bitmapData, baseRect, new Point(i * DISPLAY_WIDTH, j * DISPLAY_HEIGHT));
			bgbmp.x = -DISPLAY_WIDTH;
			bgbmp.y = -DISPLAY_HEIGHT;
			
		}
		
		private function mouseWheelHandlr(e:MouseEvent) {
			return;
		}
		
		//åˆæœŸåŒ–
		private function init() {
			
			var sidePer=0;
			if(sidesVec){
				var tmpYellow=sidesVec.length;
				var tmpCyan=wholeParticles.length-sidesVec.length;
				sidePer=(tmpCyan-tmpYellow)/2;
			}
			
			var currentParticlesLength = wholeParticles.length;
			var px = DISPLAY_WIDTH * Math.random();
			var py = DISPLAY_HEIGHT * Math.random();
			var ppx:Number;
			var ppy:Number;
			for (var i = 0; i < maxParticles-currentParticlesLength; i++) {
				if (Math.random() < .06) {
					px = DISPLAY_WIDTH * Math.random();
					py = DISPLAY_HEIGHT * Math.random();
				}
				do {
					ppx = px + Math.random() * 70 - 35;
					ppy = py + Math.random() * 70 - 35;
				}while((ppx<0 || ppx>DISPLAY_WIDTH) && (ppy<0 || ppy>DISPLAY_HEIGHT))
				wholeParticles.push(new Particle(ppx, ppy));
				wholeParticles[wholeParticles.length-1].side = (wholeParticles[wholeParticles.length-1].yy<DISPLAY_HEIGHT/2+sidePer)?true:false;
			}
			
		}
		
		function setMap():void{
			landformData_bmd.perlinNoise(mw = landformData_bmd.width >> 2, mh = landformData_bmd.height >> 2, 3, 
				seed = Math.random() * 0xFFFF, true, true, 1,true);
			arr = [point = new Point(), point2 = new Point()];
			
			bgbmp_source.bitmapData.draw(landformData_bmd,baseMatrix);
			for (var i = 0; i < 3; i++)for (var j = 0; j < 3; j++)bgbmp.bitmapData.copyPixels( bgbmp_source.bitmapData, baseRect,new Point(i*DISPLAY_WIDTH,j*DISPLAY_HEIGHT));
			rotateBmp.bitmapData.copyPixels(bgbmp.bitmapData, new Rectangle(0, 0, bgbmp.bitmapData.width, bgbmp.bitmapData.height), basePoint);
			
			keishaMap = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00000000);//å‚¾æ–œãƒ‡ãƒ¼ã‚¿ä¿å­˜ç”¨
			
		}
		
		//ãƒ¡ã‚¤ãƒ³
		override public function render(info:RenderInfo):void {
			var flg_2 = 0;
			textDisp.text = "";
			main_bmp.bitmapData.lock();
			groups_bmp.bitmapData.lock();
			
			majesticLoop();
			//configureGroup();
			//movingByGroups();
			particlesCollision();
			movingParticles();
			
			drawParticles();
			
			
			//ç”»é¢è¡¨ç¤ºç³»å‡¦ç†
			main_bmp.bitmapData.applyFilter(main_bmp.bitmapData, baseRect, basePoint, new BlurFilter(2, 2, 2));
			main_bmp.bitmapData.unlock();
			groups_bmp.bitmapData.unlock();
			
			info.render( shape1 );
		}
		//---------------------------------------------------------------------------
		
		//å¤§ãƒ«ãƒ¼ãƒ—ã€€ï½žå…¨ã‚ªãƒ–ã‚¸ã‚§ã‚¯ãƒˆã®å„å€‹å˜ä½“å‡¦ç†ã‚’çºã‚ã‚‹
		private function majesticLoop():void {
			wholeParticles.sort(sortParticles);
			function sortParticles(x, y):Number {
				if (x.xx > y.xx) { return 1; } else { return -1; }
				return 0;
			}
			
			var pl=wholeParticles.length;
			for (var i = 0; i < pl; i++) {
				var tmpObj = wholeParticles[i];
				//ã“ã“ã‹ã‚‰å‘¼ã¶
				//flocking(tmpObj);
				flocking2(tmpObj,i);
				moveBySlope(tmpObj);
			}
		}
		
		//---------------------------------------------------------------------------
		
		//ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«è¡¨ç¤º
		private function drawParticles():void {
			var pl = wholeParticles.length;
			var tmpObj:Particle;
			var col:uint;
			for (var i = 0; i < pl; i++) {
				tmpObj = wholeParticles[i];
				
				var sideColor = 0xee * int(tmpObj.side);
				col = 0xee;// * i / maxParticles;
				col = (0x10000 * sideColor) + (0x100 * col) + (col-sideColor);
				main_bmp.bitmapData.setPixel(tmpObj.xx, tmpObj.yy, col );
				/*	main_bmp.bitmapData.setPixel(tmpObj.xx+2, tmpObj.yy, col );
				main_bmp.bitmapData.setPixel(tmpObj.xx-2, tmpObj.yy, col );
				main_bmp.bitmapData.setPixel(tmpObj.xx, tmpObj.yy+2, col );
				main_bmp.bitmapData.setPixel(tmpObj.xx, tmpObj.yy-2, col );
				*/
			}
		}
		
		//ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ç§»å‹•
		private function movingParticles():void {
			var spdLim = 3;
			
			var pl=wholeParticles.length;
			for (var i = 0; i < pl; i++) {
				var tmpObj = wholeParticles[i];
				var tl=getLineLength(0,0,tmpObj.tx,tmpObj.ty);
				if(tl>spdLim){tmpObj.tx=tmpObj.tx/tl*spdLim;tmpObj.ty=tmpObj.ty/tl*spdLim;}
				
				tmpObj.xx += tmpObj.tx;
				tmpObj.yy += tmpObj.ty;
				
				//tmpObj.tx *= .99;
				//tmpObj.ty *= .99;
				
				//ç”»é¢ç«¯ã¯ãƒ«ãƒ¼ãƒ—
				if (tmpObj.xx < 0 || tmpObj.xx >= DISPLAY_WIDTH) { tmpObj.xx = uint(tmpObj.tx < 0) * (DISPLAY_WIDTH-1);}
				if (tmpObj.yy < 0 || tmpObj.yy >= DISPLAY_HEIGHT) { tmpObj.yy = uint(tmpObj.ty < 0) * (DISPLAY_HEIGHT-1);}
			}
		}
		
		//è¦–é‡Žã«ã‚ã‚‹ã‚ªãƒ–ã‚¸ã‚§ã‚¯ãƒˆã«è¿½å¾“(boids)
		var PI:Number = Math.PI;
		
		private function flocking2(refObj:Particle,num:int):void {
			var tmpGroups:Vector.<Particle> = new Vector.<Particle>();
			var flg1 = true;
			var flg2 = true;
			var i = 1;
			var tmpObj:Particle;
			while( flg1 || flg2 ) {
				if (flg1 && wholeParticles.length - 1 < num + i) flg1 = false;
				if (flg2 && num - i < 0) flg2 = false;
				
				if (flg1) {
					tmpObj = wholeParticles[num + i];
					if(tmpObj.side==refObj.side){
						tmpObj.utilNum = getLineLength(tmpObj.xx, tmpObj.yy, refObj.xx, refObj.yy);
						if (tmpObj.utilNum < 30){
							if(tmpObj.utilNum > 0)tmpGroups.push(tmpObj);
						}else if(tmpObj.xx-refObj.xx>30){flg1 = false;}
					}
				}
				if (flg2) {
					tmpObj = wholeParticles[num - i];
					if(tmpObj.side==refObj.side){
						tmpObj.utilNum = getLineLength(tmpObj.xx, tmpObj.yy, refObj.xx, refObj.yy);
						if (tmpObj.utilNum < 30){
							if(tmpObj.utilNum > 0)tmpGroups.push(tmpObj);
						}else if(refObj.xx-tmpObj.xx>30){flg2 = false;}
					}
				}
				i++;
			}
			
			var refRad = Math.atan2(refObj.ty, refObj.tx);
			var px = 0;
			var py = 0;
			var pcount = 0;
			var pl = tmpGroups.length;
			for (var i = 0; i < pl; i++) {
				var tmpObj = tmpGroups[i];
				var tmpRad = Math.atan2(tmpObj.yy - refObj.yy, tmpObj.xx - refObj.xx);
				var agl_Rad = tmpRad - refRad;
				var norm_Rad = (Math.abs(agl_Rad) > PI)?(PI * 2) - Math.abs(agl_Rad):Math.abs(agl_Rad);
				if (norm_Rad < PI / 2) {
					var a = (tmpObj.utilNum>18)?1:-1;
					px += a*(tmpObj.xx - refObj.xx)/tmpObj.utilNum;
					py += a*(tmpObj.yy - refObj.yy)/tmpObj.utilNum;
					pcount++;
				}
			}
			if (pcount == 0) { return };
			refObj.tx += px / pcount;
			refObj.ty += py / pcount;
		}
		
		private function flocking(refObj:Particle):void {
			var tmpGroups = wholeParticles.filter(sideCheck, null);
			function sideCheck(item:Particle, index:int, vector:Vector.<Particle>):Boolean {
				return (item.side == refObj.side);
			}
			
			tmpGroups=wholeParticles.filter(tmpGroupsCheck,null);
			function tmpGroupsCheck(item:Particle, index:int, vector:Vector.<Particle>):Boolean {
				item.utilNum = getLineLength(item.xx, item.yy, refObj.xx, refObj.yy);
				if (item.utilNum<50 && item.utilNum>0 && item.side==refObj.side) { 
					return true;
				}
				return false;
			}
			
			
			//return;
			
			var refRad = Math.atan2(refObj.ty, refObj.tx);
			var px = 0;
			var py = 0;
			var pcount = 0;
			var pl = tmpGroups.length;
			for (var i = 0; i < pl; i++) {
				var tmpObj = tmpGroups[i];
				var tmpRad = Math.atan2(tmpObj.yy - refObj.yy, tmpObj.xx - refObj.xx);
				var agl_Rad = tmpRad - refRad;
				var norm_Rad = (Math.abs(agl_Rad) > PI)?(PI * 2) - Math.abs(agl_Rad):Math.abs(agl_Rad);
				if (norm_Rad < PI / 1.5) {
					var a = (tmpObj.utilNum>20)?1:-1;
					px += a*(tmpObj.xx - refObj.xx)/tmpObj.utilNum;
					py += a*(tmpObj.yy - refObj.yy)/tmpObj.utilNum;
					pcount++;
				}
			}
			if (pcount == 0) { return };
			refObj.tx += px / pcount;
			refObj.ty += py / pcount;
		}
		
		//å‚¾æ–œã«ã‚ˆã‚‹å½±éŸ¿
		private function moveBySlope(tmpObj:Particle):void {
			var sideColor = 0xee * int(tmpObj.side);
			var col = 0xee;// * i / maxParticles;
			col = (0x10000 * sideColor) + (0x100 * col) + (col-sideColor);
			
			//å‚¾æ–œå€¤ã‚’å–å¾—
			var vec = getSlopeVector(tmpObj.xx, tmpObj.yy);
			tmpObj.vec = vec;
			
			tmpObj.tx += vec.x*.5;
			tmpObj.ty += vec.y*.5;
			
			
		}
		
		//å‚¾æ–œãƒžãƒƒãƒ—ã‹ã‚‰å‚¾ããƒ™ã‚¯ãƒˆãƒ«ã‚’å–å¾—
		private function getSlopeVector(xx:int, yy:int):Point {
			var tmpCol = slopeData_bmd.getPixel32(xx, yy);
			if (landformData_bmd.getPixel32(xx>>1, yy>>1)!=slopeData_bmd.getPixel32(xx, yy)) tmpCol=setMapPoint(xx,yy);
			var bX = tmpCol >>> 16;
			var bY = tmpCol & 0xffff;
			
			var dx = int(uint((((bX&0x8000)<<16)>>16)+(bX&0x7fff)))*.00001;
			var dy = int(uint((((bY & 0x8000) << 16) >> 16) + (bY & 0x7fff))) * .00001;
			
			return new Point(dx, dy);
		}
		
		//è¡çªåˆ¤å®šã¨å½±éŸ¿
		var	frameCnt:uint = 0;
		var yDl:uint = 0;
		var cDl:uint = 0;
		var beforeY:uint = 0;
		var beforeC:uint = 0;
		private function particlesCollision():void {
			var col;
			var tmpTx;
			var tmpTy;
			
			
			var pl = wholeParticles.length;
			var mHP = 0;
			
			for (var i = 0; i < pl; i++) {
				var tmpObj = wholeParticles[i];
				
				var sideColor = 0xee * int(tmpObj.side);
				col = 0xee;// * i / maxParticles;
				col = (0x10000 * sideColor) + (0x100 * col) + (col-sideColor);
				
				
				//å½“ãŸã‚Šåˆ¤å®š
				if (i != 0) {
					var hitcnt = i;
					while (hitcnt) {
						hitcnt--;
						if ( tmpObj.xx - wholeParticles[hitcnt].xx > 3) {
							break;
						}
						if( Math.abs(tmpObj.yy - wholeParticles[hitcnt].yy) < 3){// && tmpObj.side!=wholeParticles[hitcnt].side) {
							var tmpCol=0x666666;
							if (tmpObj.side != wholeParticles[hitcnt].side) {
								
								tmpObj.hp = getHP(tmpObj);
								wholeParticles[hitcnt].hp = getHP(wholeParticles[hitcnt]);
								
								var dm = tmpObj.getTl() - wholeParticles[hitcnt].getTl();
								if (dm > 0) { wholeParticles[hitcnt].hp -= dm; } else { tmpObj.hp += dm; }
								tmpCol=0xff0000;
								
							}
							for (var exp = 1; exp < 4;exp++){
								main_bmp.bitmapData.setPixel(tmpObj.xx - exp, tmpObj.yy-exp, tmpCol );
								main_bmp.bitmapData.setPixel(tmpObj.xx + exp, tmpObj.yy+exp, tmpCol );
								main_bmp.bitmapData.setPixel(tmpObj.xx-exp, tmpObj.yy + exp, tmpCol );
								main_bmp.bitmapData.setPixel(tmpObj.xx+exp, tmpObj.yy - exp, tmpCol );
							}
							
							//var tmpTl = tmpObj.getTl()+wholeParticles[hitcnt].getTl();
							tmpTx = (tmpObj.tx*tmpObj.hp - wholeParticles[hitcnt].tx*wholeParticles[hitcnt].hp);///tmpTl;
							tmpTy = (tmpObj.ty*tmpObj.hp - wholeParticles[hitcnt].ty*wholeParticles[hitcnt].hp);///tmpTl;
							tmpObj.tx += tmpTx / tmpObj.hp;
							tmpObj.ty += tmpTy / tmpObj.hp;
							wholeParticles[hitcnt].tx -= tmpTx / wholeParticles[hitcnt].hp;
							wholeParticles[hitcnt].ty -= tmpTy / wholeParticles[hitcnt].hp;
							
						}
						break;
					}
				}
				
				mHP = (tmpObj.hp > mHP)?tmpObj.hp:mHP;
			}
			
			
			centerX /= wholeParticles.length;
			centerY /= wholeParticles.length;
			
			var yHp:Number=0;
			var cHp:Number = 0;
			
			//ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã®æ•´ç†
			wholeParticles=wholeParticles.filter(hpCheck,null);
			function hpCheck(item:Particle, index:int, vector:Vector.<Particle>):Boolean {
				
				if (item.hp<=0) {
					if (item.groupFlg) item.group.removeMember(item);
					yDl += (tmpObj.side)?1:0;
					cDl += (!tmpObj.side)?1:0;
					sideColor = 0xee * int(tmpObj.side);
					col = 0xee;// * i / maxParticles;
					col = (0x10000 * sideColor) + (0x100 * col) + (col-sideColor);
					for ( exp = 1; exp < 20;exp++){
						main_bmp.bitmapData.setPixel(item.xx - exp, item.yy, col );
						main_bmp.bitmapData.setPixel(item.xx + exp, item.yy, col );
						main_bmp.bitmapData.setPixel(item.xx, item.yy + exp, col );
						main_bmp.bitmapData.setPixel(item.xx, item.yy - exp, col );
					}
					return false; 
				}
				return true;
			}
			frameCnt++;
			if(frameCnt>8){
				dyingLate.bitmapData.scroll(5, 0);
				yDlShape.graphics.clear();
				cDlShape.graphics.clear();
				
				yDlShape.graphics.beginFill(0xffff00, .3);
				//yDlShape.graphics.lineStyle(.5, 0xffff00, .5);
				yDlShape.graphics.moveTo(5, 100-beforeY*3);
				yDlShape.graphics.lineTo(0, 100-yDl*3);
				yDlShape.graphics.lineTo(0, 100);
				yDlShape.graphics.lineTo(5, 100);
				cDlShape.graphics.beginFill(0x00ffff, .3);
				//cDlShape.graphics.lineStyle(.5, 0x00ffff, .5);
				cDlShape.graphics.moveTo(5, 100-beforeC*3);
				cDlShape.graphics.lineTo(0, 100-cDl * 3);
				cDlShape.graphics.lineTo(0, 100);
				cDlShape.graphics.lineTo(5, 100);
				beforeY = yDl;
				beforeC = cDl;
				dyingLate.bitmapData.draw(yDlShape,new Matrix(1,0,0,1,5,0));
				dyingLate.bitmapData.draw(cDlShape,new Matrix(1,0,0,1,5,0));
				//for (i = 100; i > 100 - yDl*3 ;i--)dyingLate.bitmapData.setPixel32(1, i, 0x3000ffff);
				//for (i = 100; i > 100 - cDl*3 ;i--) dyingLate.bitmapData.setPixel32(1, i, 0x30ffff00);
				yDl=cDl=frameCnt = 0;
			}
			
			sidesVec=wholeParticles.filter(sideCheck,null);
			function sideCheck(item:Particle, index:int, vector:Vector.<Particle>):Boolean {
				if (item.side==false) { return false; }
				return true;
			}
			
			
			bottomBar.graphics.clear();
			bottomBar.graphics.beginFill(0xeeee00, .5);
			bottomBar.graphics.drawRect((DISPLAY_WIDTH-DISPLAY_WIDTH * .8)/2, 0, (sidesVec.length / maxParticles) * (DISPLAY_WIDTH), 3);
			bottomBar.graphics.beginFill(0x00eeee, .5);
			bottomBar.graphics.drawRect((DISPLAY_WIDTH-DISPLAY_WIDTH * .8)/2, 6, ((wholeParticles.length - sidesVec.length) / maxParticles) * (DISPLAY_WIDTH), 3);
			bottomBar.graphics.endFill();
			
			//ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã®ãƒªã‚»ãƒƒãƒˆåˆ¤å®š
			//if(wholeParticles.length<maxParticles*.1 || sidesVec.length<10 || wholeParticles.length-sidesVec.length<10)init();
			//textDisp.appendText(mHP);
			
			
		}
		
		private function getHP(tmpObj:Particle):Number {
			var v1 = new Point(tmpObj.tx, tmpObj.ty);
			var v2 = new Point(tmpObj.vec.x, tmpObj.vec.y);
			var v3 = v1.add(v2);
			var at1 = Math.atan2(tmpObj.ty, tmpObj.tx);
			var at2 = Math.atan2(v3.y, v3.x);
			
			var ret= (Math.abs(at1 - at2) < Math.PI / 2)?v3.length:(v1.length - v3.length);
			ret = (ret > 0)?ret:1;
			
			return ret;
			//return (v1.add(v2)).length;
		}
		
		//ã‚°ãƒ«ãƒ¼ãƒ—åŒ–åˆ¤å®š
		private function configureGroup():void {
			
			var pl=wholeParticles.length;
			for (var i = 0; i < pl; i++) {
				
				var tmpObj = wholeParticles[i];
				
				//æ‰€å±žã‚°ãƒ«ãƒ¼ãƒ—ãƒã‚§ãƒƒã‚¯
				if(tmpObj.groupFlg){
					if (getLineLength(tmpObj.group.ox, tmpObj.group.oy, tmpObj.xx, tmpObj.yy) > 80) {
						tmpObj.group.removeMember(tmpObj);
						tmpObj.groupFlg = false;
					}
				}else if (!tmpObj.groupFlg) {
					if (groups.length == 0) {
						var newGrp = new GroupObject();
						newGrp.side = tmpObj.side;
						newGrp.addMember(tmpObj);
						tmpObj.group = newGrp;
						tmpObj.groupFlg = true;
						groups.push(newGrp);
					}else {
						var mostNearGroup;
						var mNGLength=70;
						var gl = groups.length;
						for (var gId = 0; gId < gl; gId++) {
							var tmpGrp = groups[gId];
							var tmpLength = getLineLength(tmpGrp.ox, tmpGrp.oy, tmpObj.xx, tmpObj.yy);
							if ((!mNGLength || mNGLength > tmpLength) && tmpGrp.side==tmpObj.side) {
								mNGLength = tmpLength;
								mostNearGroup = tmpGrp;
							}
						}
						
						if (mNGLength < 70) {
							mostNearGroup.addMember(tmpObj);
							tmpObj.group = mostNearGroup;
							tmpObj.groupFlg = true;
						}else {
							newGrp = new GroupObject();
							newGrp.side = tmpObj.side;
							newGrp.addMember(tmpObj);
							tmpObj.group = newGrp;
							tmpObj.groupFlg = true;
							groups.push(newGrp);
						}
					}
				}
			}
		}
		
		//ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã®ã‚°ãƒ«ãƒ¼ãƒ—ã«ã‚ˆã‚‹å½±éŸ¿
		private function movingByGroups():void {
			var vec;
			var tmpTx;
			var tmpTy;
			
			groups_bmp.bitmapData.copyPixels(clearDisplay_bmd, baseRect, basePoint);
			
			//ã‚°ãƒ«ãƒ¼ãƒ—ã®æ•´ç†
			groups=groups.filter(groupsCheck,null);
			function groupsCheck(item:GroupObject, index:int, vector:Vector.<GroupObject>):Boolean {
				item.calc();
				
				if (item.length<=4) { 
					for (var gId in item.members) item.members[gId].groupFlg = false;
					if (item.shape.root) groupsContainer.removeChild(item.shape);
					return false;
				}
				if (!item.shape.root) groupsContainer.addChild(item.shape);
				return true;
			}
			
			var gmLength=0;
			//ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã®ã‚°ãƒ«ãƒ¼ãƒ—åŒ–å‹•ä½œ
			for (var gId in groups) {
				var tmpGrp = groups[gId];
				gmLength += tmpGrp.length;
				
				vec = getSlopeVector(tmpGrp.ox, tmpGrp.oy);
				tmpGrp.tx += vec.x;
				tmpGrp.ty += vec.y;
				
				//ã‚°ãƒ«ãƒ¼ãƒ—åŒå£«ã®å½“ãŸã‚Šåˆ¤å®š
				for(var hitId in groups) {
					if (gId == hitId) break;
					if ( tmpGrp.shape.hitTestObject(groups[hitId].shape)) {// && tmpObj.side!=wholeParticles[hitcnt].side) {
						var tmpTl = getLineLength(tmpGrp.ox, tmpGrp.oy, groups[hitId].ox, groups[hitId].oy);
						tmpTx = (tmpGrp.ox*tmpGrp.length - groups[hitId].ox*groups[hitId].length)/(tmpTl*tmpTl);
						tmpTy = (tmpGrp.oy*tmpGrp.length - groups[hitId].oy*groups[hitId].length)/(tmpTl*tmpTl);
						tmpGrp.tx += tmpTx/tmpGrp.length;
						tmpGrp.ty += tmpTy/tmpGrp.length;
						groups[hitId].tx -= tmpTx/groups[hitId].length;
						groups[hitId].ty -= tmpTy/groups[hitId].length;
						
					}
				}
				//var spdLim = 1000;
				//tl=getLineLength(0,0,tmpGrp.tx,tmpGrp.ty);
				//if (tl > spdLim) { tmpGrp.tx = (tmpGrp.tx / tl) * spdLim; tmpGrp.ty = (tmpGrp.ty / tl) * spdLim; }
				
				var tmpLx;
				var tmpLy;
				var tmpL;
				for ( var i in tmpGrp.members) {
					var tmpObj = tmpGrp.members[i];
					
					//	ã‚°ãƒ«ãƒ¼ãƒ—ä¸­å¿ƒç‚¹ã¸å¯„ã£ã¦ã„ãå‡¦ç†
					/*	tmpLx=tmpGrp.ox - tmpObj.xx;
					tmpLy=tmpGrp.oy - tmpObj.yy;
					tmpL=Math.sqrt(Math.pow(tmpLx, 2) + Math.pow(tmpLy, 2));
					tmpObj.tx += (tmpLx / tmpL) >> 4;
					tmpObj.ty += (tmpLy / tmpL) >> 4;
					*/	
					//ã‚°ãƒ«ãƒ¼ãƒ—é€²è¡Œæ–¹å‘ã¨ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã®é€²è¡Œæ–¹å‘ãŒç•°ãªã‚‹æ™‚ã«ã€ä½œç”¨ã•ã›ã‚‹
					if (tmpObj.tx * tmpGrp.tx < 0) tmpObj.tx += tmpGrp.tx;
					if (tmpObj.ty * tmpGrp.ty < 0) tmpObj.ty += tmpGrp.ty;
				}
				
				//å‡¸åŒ…è¨ˆç®—
				//tmpGrp.Compute();				
				//groups_bmp.bitmapData.draw(tmpGrp.shape);
			}
		}
		
		
		
		//---------------------------------------------------------------------------
		function setMapPoint(tmpX,tmpY):uint{
			var col = landformData_bmd.getPixel(tmpX >> 1, tmpY >> 1);
			
			var dx = 0;
			var dy = 0;
			
			for (var py = -1; py < 2; py++){
				for (var px = -1; px < 2; px++) {
					
					if (px == 0 && py == 0) continue;
					
					var ppx = tmpX + px;
					var ppy = tmpY + py;
					
					if (ppx < 0 || ppx >= DISPLAY_WIDTH) { ppx = int(ppx<0)* (DISPLAY_WIDTH-1); }
					if (ppy < 0 || ppy >= DISPLAY_HEIGHT){ ppy = int(ppy<0)* (DISPLAY_HEIGHT-1);}
					
					var tmpcol = landformData_bmd.getPixel(ppx >> 1, ppy >> 1);
					//slopeData_bmd.setPixel(ppx, ppy, tmpcol);
					
					if (px*px + py*py == 1) {
						dx += (col - tmpcol) * px;
						dy += (col - tmpcol) * py;
					}else {
						dx += (col - tmpcol) * px*.7;
						dy += (col - tmpcol) * py*.7;
					}
				}
			}
			slopeData_bmd.setPixel(tmpX, tmpY, col);
			col = uint((uint((uint(dx/5)&0x80000000)>>>16)+(uint(dx/5)&0x7fff)<<16)+uint((uint(dy/5) & 0x80000000) >>> 16) + (uint(dy/5) & 0x7fff));
			keishaMap.setPixel32(tmpX, tmpY, col);
			return col;
		}
		
		
		//
		function getLineLength(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			var vx=x1-x2;
			var vy=y1-y2;
			var vl=Math.sqrt(Math.pow(vx,2)+Math.pow(vy,2));
			return vl;
		}
		
		
	}
}

class bugfix {
	function bugfix():void {
	}
}

import adobe.utils.ProductManager;
import flash.display.Shader;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.display.Shape;
import flash.utils.ByteArray;

class Particle extends bugfix{
	
	var xx:Number=0;
	var yy:Number=0;
	var tx:Number=0;
	var ty:Number=0;
	var dl:Number = 0;
	var hp:int;
	var side:Boolean;
	var group:GroupObject;
	var groupFlg:Boolean;
	var vec:Point;
	var utilNum:Number;
	
	function Particle(... args):void {
		xx = args[0];
		yy = args[1];
		var sd;
		tx = Math.cos(sd=Math.random() * Math.PI * 2);
		ty = Math.sin(sd);
		groupFlg = false;
		vec = new Point();
		hp = 1;
	}
	
	function getTl():Number {
		return Math.sqrt(Math.pow(tx,2)+Math.pow(ty,2));
	}
}

class GroupObject extends bugfix{
	var members:Vector.<Particle> = new Vector.<Particle>();
	var mLength:uint;
	var px:Number;
	var py:Number;
	var ox:Number;
	var oy:Number;
	var ttx:Number;
	var tty:Number;
	var tx:Number;
	var ty:Number;
	var side:Boolean;
	var shape:Shape;
	
	function GroupObject():void {
		mLength = px = py = ox = oy = tx = ty = 0;
		shape = new Shape();
		shape.cacheAsBitmap = true;
	}
	
	function calc() {
		mLength = members.length;
		//if (mLength < 1) return;
		
		px = py = ttx = tty = 0;
		for (var i in members) {
			px += members[i].xx;
			py += members[i].yy;
			ttx += members[i].tx;
			tty += members[i].ty;
		}
		ox = px / mLength;
		oy = py / mLength;
		tx = ttx / mLength;
		ty = tty / mLength;
		//Compute();
	}
	
	function addMember(p:Particle) {
		members.push(p);
		mLength = members.length;
		
		px += p.xx;
		py += p.yy;
		ox = px / mLength;
		oy = py / mLength;
		
		ttx += p.tx;
		tty += p.ty;
		tx = ttx / mLength;
		ty = tty / mLength;
		//Compute();
	}
	
	function removeMember(p:Particle) {
		members.splice(members.indexOf(p), 1);
		mLength = members.length;
		
		px -= p.xx;
		py -= p.yy;
		ox = px / mLength;
		oy = py / mLength;
		
		ttx -= p.tx;
		tty -= p.ty;
		tx = ttx / mLength;
		ty = tty / mLength;
		//Compute();
	}
	
	function get length():uint {
		mLength = members.length;
		return mLength;
	}
	
	//------------------------------------------------------------------------------------------------
	//QuickHullã€€ã€€ã€€via http://asura.iaigiri.com/OpenGL/gl50.htmlã®ã‚³ãƒ¼ãƒ‰ã‚’å…ƒã«ã•ã›ã¦ã„ãŸã ã„ã¦ã¾ã™
	//------------------------------------------------------------------------------------------------
	
	var m_Points:Vector.<Point> = new Vector.<Point>();
	var m_Ignore:Vector.<Boolean> = new Vector.<Boolean>();
	var m_UpperHull:Vector.<Boolean> = new Vector.<Boolean>();
	var m_EdgeIndex:Vector.<Array> = new Vector.<Array>();
	
	//-------------------------------------------------------------------------------------------------
	// Desc : å‡¸åŒ…ã‚’æ±‚ã‚ã‚‹
	function Compute():void
	{
		shape.graphics.clear();
		
		m_Points.length = m_Ignore.length = m_UpperHull.length = m_EdgeIndex.length = 0;
		members.forEach(setMPoints, null);
		function setMPoints(item:Particle, idx:int, vect:Vector.<Particle>) {
			m_Points.push(new Point(item.xx,item.yy));
		}
		m_Ignore.length = m_UpperHull.length = m_Points.length;
		
		if (m_Points.length < 3) return;
		
		//ã€€æœ€åˆã®ç¨œç·šã‚’æ±‚ã‚ã‚‹
		var axis:Array = FindFirstEdge();
		
		//ã€€ç¨œç·šãŒè¦‹ã¤ã‹ã‚‰ãªã‹ã£ãŸã‚‰çµ‚äº†
		if ( axis[0] == -1 && axis[1] == -1 ) return;
		
		//ã€€ç¨œç·šã‚’è¿½åŠ 
		//m_RenderingFlag.push( false );
		//axis[2] = false;
		m_EdgeIndex.push( axis ) ;
		
		//ã??ä??å??ã??é??å??ã??ä??å??ã??é??å??ã??å??ã??ã??
		CheckUpperOrLower( axis );
		
		//ã??å??å??å??ã??å?ºã??ã??ã??ã??ã??å??å??ã??æ??ã??ã??
		RecursiveCallCompute( axis, true );		//ã??ä??å??ã??é??å??
		RecursiveCallCompute( axis, false );	//ã??ä??å??ã??é??å??
		
		//shape.graphics.lineStyle(2, 0x0000ff,1);
		//shape.graphics.moveTo(m_Points[axis[0]].x, m_Points[axis[0]].y);
		//shape.graphics.lineTo(m_Points[axis[1]].x, m_Points[axis[1]].y);
		
		RenderConvexHull();
	}
	
	//------------------------------------------------------------------------------------------------
	// Desc : æ??å??ã??ç??ç??ã??æ??ã??ã??
	function FindFirstEdge():Array
	{
		var index:Array=[0, 0];
		var max:Point, min:Point;
		
		//ã??ç??ã??æ??ã??2ã??ã??ã??å??ã??ã??å??å??ã??-1ã??è??ã??ã??çµ?äº?
		if ( m_Points.length < 4 ) 
			return [ -1, -1 ];
		
		//ã??å??æ??å??
		max = min  = m_Points[0];
		
		//ã??xåº?æ??ã??æ??å??ã??æ??å??ã??ã?ªã??äº?ã??ã??ç??ã??æ??ã??ã??
		for ( var i=0; i<m_Points.length; i++ )
		{
			//ã??æ??å??å??
			if ( m_Points[i].x < min.x ) 
			{
				index[0] = i;
				min = m_Points[i];
			}
			//ã??æ??å??å??
			if ( m_Points[i].x > max.x )
			{
				index[1] = i;
				max = m_Points[i];
			}
		}
		
		//ã??ç??å?ºçµ?æ??
		return index;
	}
	
	//-------------------------------------------------------------------------------------------------
	// Desc : è??ç??é??æ??ã??å??å??å??ã??å?ºã??
	function RecursiveCallCompute( index:Array, uh:Boolean ):void
	{
		var edge1:Array = [];
		var edge2:Array = [];
		var UpperHull = uh;
		
		//ã??æ??ã??é??ã??ç??ã??æ??ã??ã??
		var farestPoint:int = FarestPointFromEdge( index, UpperHull );
		
		//ã??ç??ã??è??ã??ã??ã??ã?ªã??ã??ã??å??å??ã??çµ?äº?
		if ( farestPoint == -1 ) { return;}
		
		//ã??ä??è??å??ã??å??æ??ã??ã??3ç??ã??å??ç??ã??ã??å??ã??
		m_Ignore[index[0]] = true;
		m_Ignore[index[1]] = true;
		m_Ignore[farestPoint] = true;
		
		//ã??ã??ã??ã??ã??ç??
		//m_Colors[farestPoint] = Vector4f( 0.0f, 1.0f, 1.0f, 1.0f );
		
		//ã??ä??è??å??å??é??ã??ã??ã??ç??ã??å??ç??ã??å??è??ã??ã??å??ã??
		for ( var i=0; i<m_Points.length; i++ )
		{
			if (m_Ignore[i] == true) continue;
			
			var result:Boolean = IsInsideOfTriangle( 
				m_Points[index[0]],
				m_Points[index[1]],
				m_Points[farestPoint],
				m_Points[i] );
			
			//ã??å??é??ã??ã??ã??ã??å??å??
			if ( result ) { m_Ignore[i] = true;}
		}
		
		//ã??å??å??ã??æ??ç??ç??
		if (m_EdgeIndex.indexOf([index[0], index[1], true]) > -1) { trace("!"); m_EdgeIndex[m_EdgeIndex.indexOf([index[0], index[1], true])][2] = false; }
		if (m_EdgeIndex.indexOf([index[1], index[0], true]) > -1){ trace("!");m_EdgeIndex[m_EdgeIndex.indexOf([index[1], index[0], true])][2] = false;}
		index[2] = false;
		
		//ã??ç??ç??ã??è??å??
		edge1 = [index[0], farestPoint, true];
		edge2 = [farestPoint, index[1], true];
		m_EdgeIndex.push( edge1 );
		m_EdgeIndex.push( edge2 );
		
		//ã??å??å??å??ã??å?ºã??
		RecursiveCallCompute( edge1, UpperHull ); 
		RecursiveCallCompute( edge2, UpperHull ); 
		
		return;
	}
	
	//-------------------------------------------------------------------------------------------------
	// Desc : ç??ç??ã??å??ã??ã??ã??å??ç??ã??ä??ã??ã??ã??ã??ã??ï??å??ç??ã??é??ã??ã??æ??å??ã??ã?ªã??ç??ã??ã??ã??ã??ã??ã??ã??ã??è??ã??
	function FarestPointFromEdge( index:Array, UpperHull:Boolean ):int
	{
		var t = 0;
		var v1:Point, v2:Point, v3:Point, v:Point;
		var max = -1;
		var result:int = -1;
		
		//ã??ç??ç??
		v1 = m_Points[index[0]];
		v2 = m_Points[index[1]];
		v = new Point();
		var mv1 = new Point();
		
		for ( var i=0; i<m_Points.length; i++ )
		{
			//ã??ç??ç??ã??å??æ??ã??ã??ç??ã??å??ç??ã??å??è??å??
			if ( index[0] == i ) continue;
			if ( index[1] == i ) continue;
			
			//ã??é??å??ã??ç??ã?ªã??å??å??ã??å??ç??ã??å??è??å??
			if ( m_UpperHull[i] != UpperHull ) continue;
			
			//ã??ã??ã??ã??å??ç??ã??ã??ã??ã??ã??å??å??ã??å??ç??ã??å??è??å??
			if ( m_Ignore[i] ) continue;
			
			v3 = m_Points[i];
			
			//ã??ä??å??ã??é??å??ã??å??å??
			if ( UpperHull )
			{
				if ( LineQuation(v1, v2, v3) < 0 ) continue;
			}else{//ã??ä??å??ã??é??å??ã??å??å??
				if ( LineQuation(v1, v2, v3) > 0 ) continue;	
			}
			
			//ã??å??ç??ã??è??ã??åº?æ??
			var Line_v1v2:Point = getLine(v1, v2);
			var CrossLine_v1v2v3 = getCrossLine(v1, v2, v3);
			v = getCrossPoint2Lines(Line_v1v2.x, Line_v1v2.y, CrossLine_v1v2v3.x, CrossLine_v1v2v3.y);
			
			//ã??å??ç??ã??é??ã??ã??æ??ã??ã??
			var d = Point.distance(v, v3);
			
			//ã??æ??å??å??ã??ã??ã??ã??ã??ã??ã??ã??æ??æ??
			if ( d > max )
			{
				max = d;
				mv1 = v;
				result = i;
			}
		}
		
		/*å??ç??è??ç?º
		if (result != -1) {
		shape.graphics.lineStyle(1,0xffffff,.5);
		//shape.graphics.drawCircle(mv1.x, mv1.y,2);
		shape.graphics.moveTo(mv1.x, mv1.y);
		shape.graphics.lineTo(m_Points[result].x, m_Points[result].y);
		//shape.graphics.lineStyle(.5, 0xffffff,.2);
		//shape.graphics.drawCircle(m_Points[index[0]].x, m_Points[index[0]].y,1);
		//shape.graphics.lineTo(m_Points[index[1]].x, m_Points[index[1]].y);
		//shape.graphics.drawCircle(m_Points[index[1]].x, m_Points[index[1]].y,1);
		//shape.graphics.lineTo(m_Points[result].x, m_Points[result].y);
		//shape.graphics.lineTo(m_Points[index[0]].x, m_Points[index[0]].y);
		}
		*/
		
		//ã??ã??ã??ã??ã??ã??ã??ã??è??ã??
		return result;
	}
	
	//------------------------------------------------------------------------------------------------
	// Desc : ç??ç??ã??æ??ç??å??
	function LineQuation( v1:Point, v2:Point, v3:Point ):Number
	{
		
		var ma = (v2.x - v1.x);
		var mb = (v2.y - v1.y);
		
		//ã??å??ã??
		var m = 0.0;
		if ( ma != 0 ) m = mb/ma;
		
		//ã??ç??ç??ã??æ??ç??å??ã??3ç??ã??åº?æ??ã??ä??å??ã??ã??çµ?æ??ã??è??ã??
		//return (( v3.y - v1.y ) -  m * (v3.x - v1.x));
		
		
		//å??ç??ã??ã??ã??ã??
		return -((v3.x - v1.x) * (v2.y - v1.y) - (v2.x - v1.x) * (v3.y - v1.y));
	}
	//x1*y2-x2*y1 
	//------------------------------------------------------------------------------------------------
	// Desc : ä??å??ã??é??å??ã??ä??å??ã??é??å??ã??ã??ã??ã??ã??ã??ã??ã??
	function CheckUpperOrLower( index:Array ):void
	{
		var a:Point = m_Points[index[0]];
		var b:Point = m_Points[index[1]];
		
		//ã??ã??ã??ã??ã??ç??ã??èª?ã??ã??
		var c:Point;
		for ( var i=0; i<m_Points.length; i++ )
		{
			c = m_Points[i];
			
			
			//ã??ä??å??ã??é??å??
			if ( LineQuation(a, b, c) > 0 )
			{
				m_UpperHull[i] = true;
			}
				//ã??ä??å??ã??é??å??
			else
			{
				m_UpperHull[i] = false;
			}
		}
	}
	
	//-------------------------------------------------------------------------------------------------
	// Desc : ä??è??å??å??é??ã??ç??ã??ã??ã??ã??ã?ªã??ã??ã??å??å??ã??å??é??ã?ªã??ã??tureï??å??é??ã?ªã??ã??falseã??è??ã??
	function IsInsideOfTriangle( v1:Point, v2:Point, v3:Point, point:Point ):Boolean
	{
		var d0:Vector3D, d1:Vector3D;
		var cr:Number;
		var result:Array=[ 0, -1, 1 ];
		
		//ã??ä??è??å??ã??å??æ??ã??ã??3ç??a, b, c
		var a:Vector3D=new Vector3D(v1.x, v1.y, 0);
		var b:Vector3D=new Vector3D(v2.x, v2.y, 0);
		var c:Vector3D=new Vector3D(v3.x, v3.y, 0);
		
		//ã??å??å??ç??p
		var p:Vector3D=new Vector3D(point.x, point.y, 0);
		
		//ã??æ??ç??ã??ã??ã??ã??ã??ç??å?º
		var n:Vector3D = a.crossProduct( b );
		n.normalize();
		
		///ã??ç??å??ã??èª?ã??ã??
		// 1
		d0 = p;d0.decrementBy(a);
		d1 = b;d1.decrementBy(a);
		cr = n.dotProduct(d0.crossProduct( d1 ));
		result[0] = (cr==0)?0:cr/Math.abs(cr);
		
		// 2
		d0 = p;d0.decrementBy(b);
		d1 = c;d1.decrementBy(b);
		cr = n.dotProduct(d0.crossProduct( d1 ));
		result[1] = (cr==0)?0:cr/Math.abs(cr);
		
		// 3
		d0 = p;d0.decrementBy(c);
		d1 = a;d1.decrementBy(c);
		cr = n.dotProduct(d0.crossProduct( d1 ));
		result[2] = (cr==0)?0:cr/Math.abs(cr);
		
		//ã??ç??å??ã??ã??ã??ã??å??ã??ã??ã??ã??å??å??ã??å??é??
		if ( result[0] == result[1] == result[2])return true;
		
		//ã??ç??å??ã??ä??ã??æ??ã??ã??é??ã??ã??å??é??
		return false;
	}
	
	//------------------------------------------------------------------------------------------------
	// Desc : å??å??ã??æ??ç??
	function RenderConvexHull():void
	{
		if(m_EdgeIndex.length<3)return;
		shape.graphics.beginFill((0x10000 * 0xee * int(side)) + (0x100 * 0xee) + (0xee-0xee * int(side)), .04);
		shape.graphics.lineStyle(.1, (0x10000 * 0xee * int(side)) + (0x100 * 0xee) + (0xee-0xee * int(side)), .01);
		
		var drawPoint:Object = new Object();
		for ( var i:int=0; i<m_EdgeIndex.length-1; i++ )
		{
			if ( m_EdgeIndex[i][2] )
			{
				drawPoint[String(m_EdgeIndex[i][0])]=m_Points[m_EdgeIndex[i][0]];
				drawPoint[String(m_EdgeIndex[i][1])]=m_Points[m_EdgeIndex[i][1]];
			}
		}
		var dPoints:Vector.<Point> = new Vector.<Point>();
		for (var j:String in drawPoint) {
			dPoints.push(drawPoint[j]);
		}
		
		dPoints.sort(sortDP);
		function sortDP(a,b) {
			if (Math.atan2(a.x-ox,a.y-oy) < Math.atan2(b.x-ox,b.y-oy)) return -1;
			if (Math.atan2(a.x-ox,a.y-oy) > Math.atan2(b.x-ox,b.y-oy)) return 1;
			return 0;
		}
		
		shape.graphics.moveTo((dPoints[0].x + dPoints[dPoints.length-1].x) / 2, (dPoints[0].y + dPoints[dPoints.length-1].y) / 2);
		for (i = 0; i < dPoints.length-1; i++) {
			shape.graphics.curveTo(dPoints[i].x, dPoints[i].y,(dPoints[i].x + dPoints[i + 1].x) / 2, (dPoints[i].y + dPoints[i+ 1].y) / 2);
		}
		shape.graphics.curveTo(dPoints[i].x, dPoints[i].y, (dPoints[0].x + dPoints[dPoints.length - 1].x) / 2, (dPoints[0].y + dPoints[dPoints.length - 1].y) / 2);
		
		shape.graphics.endFill();
		shape.graphics.lineStyle(.1, (0x10000 * 0xee * int(side)) + (0x100 * 0xee) + (0xee-0xee * int(side)), .05);
		shape.graphics.moveTo(dPoints[dPoints.length-1].x, dPoints[dPoints.length-1].y);
		for (i = 0; i < dPoints.length; i++) {
			shape.graphics.lineTo(dPoints[i].x, dPoints[i].y);
		}
		
		shape.graphics.lineStyle(1.5, (0x10000 * 0xee * int(side)) + (0x100 * 0xee) + (0xee-0xee * int(side)), .05);
		for (i = 0; i < dPoints.length; i++) {
			shape.graphics.drawCircle(dPoints[i].x, dPoints[i].y,4);
		}
		for (i = 0; i < m_Points.length; i++) {
			shape.graphics.drawCircle(m_Points[i].x, m_Points[i].y,1);
		}
		
	}
	
	function getLine(p1:Point,p2:Point):Point	//ç›´ç·š y=[ts.x]x+[ts.y]ã‚’è¿”ã™
	{
		var vx=p1.x-p2.x;
		var vy=p1.y-p2.y;
		var ts=new Point();
		ts.x=vy/vx;
		ts.y=p2.y-ts.x*p2.x;
		return ts;
	}
	
	function getCrossLine(p1:Point,p2:Point,p3:Point):Point	//ç‚¹p1-p2ã«ç›´äº¤ã—ã€p3ã‚’é€šã‚‹ç›´ç·š y=[ts.x]x+[ts.y]ã‚’è¿”ã™
	{
		var vx=p1.x-p2.x;
		var vy=p1.y-p2.y;
		var ts=new Point();
		ts.x=-vx/vy;
		ts.y=p3.y-ts.x*p3.x;
		return ts;
	}
	
	function getCrossPoint2Lines(l1a:Number,l1b:Number,l2a:Number,l2b:Number):Point	//y=[l1a]x+[l1b],y=[l2a]x+[l2b]ã®äº¤ç‚¹ã‚’è¿”ã™
	{
		var x = (l2b - l1b) / (l1a - l2a);
		return new Point(x, l1a * x + l1b);
	}
	
	
}
