/**
 * Copyright aki12800jp ( http://wonderfl.net/user/aki12800jp )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/Acw5
 */

// forked from enok's ä??è??é?? - Kaleidoscope
// ä??è??é?? (KaleidoscopeController) by enok
//
// ç??å??ã??JPG, GIF, PNGã??å??å??ã??ã??ã??ã??ã??ã?µã??ã?ºã??200KBã??ã??ã??ã??ã??
// ç??å??ã?µã??ã?ºã??400ï??600pxã??ã??ã??ã??ã??ã??ã??ã??ã??æ??ã??ã??ç??æ?ªã??é??ã??ã??é??ã??ã??å??æ??ã??ã??ã??ã??ã??
//
// ã??ã??ä??è??ç??ã??ã??ã??ã?? http://linkalink.jp/enok/?p=573

package plugins.filters
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class CenterKaleidoscope extends Filter implements IBitmapFilter {

		protected var _centerX:Number; //ä??å??X
		protected var _centerY:Number; //ä??å??Y
		protected var _imgBmp:Bitmap; //èª?è??ç??å??ã??ã??ã??ã??ã??ã??
		protected var _sec:Sector; //æ??ã??ã??ã??
		protected var _partsBmpArray:Array; //ä??è??é??ã??ã??ã??ã??é??å??
		protected var _partsAngle:Number = 30; //ä??ã??ã??ä??è??é??ã??è??åº?
		protected var _ksRadius:Number = 0; //ä??è??é??ã??å??å??
		protected var _imgParam:Object = new Object(); //ç??å??ã??ã??ã??ã??ã??ã??é??å??
		protected var _maskBmpData:BitmapData; //æ??å??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??
		protected var _viewSp:Sprite; //ä??è??é??ã??ã??ã??ã??ã??
		private var imgBmpData:BitmapData;
		private var _vx:Number = 0.1; //ä??å??X
		
		public function CenterKaleidoscope():void {
			parameters.addParameters(
				new ParameterNumber('vx', 'vx', 0, 40, _vx)
			);
			_centerX = DISPLAY_WIDTH / 2;
			_centerY = DISPLAY_HEIGHT / 2;
			
			_imgParam["angle"] = 0.0;
			_imgParam["scale"] = 1.0;
			_imgParam["vec"] = 1;
			
			imgBmpData = createDefaultBitmap();
			_imgBmp = new Bitmap(imgBmpData);
			
			//_ksRadius = Math.min(Math.max(DISPLAY_WIDTH, DISPLAY_HEIGHT), 420) / 2;
			_ksRadius = Math.min(DISPLAY_WIDTH, DISPLAY_HEIGHT) / 2;
					
			_sec = new Sector(0, 0, _partsAngle, 0, _ksRadius);

			_maskBmpData = new BitmapData(_imgBmp.width, _imgBmp.height, true, 0x00000000);
			_maskBmpData.draw(_sec);
			
			_viewSp = new Sprite();
			_partsBmpArray = new Array()
			for (var i:uint = 0; i < Math.ceil(360 / _partsAngle); i++ ) {
				var partsBmp:Bitmap = new Bitmap();
				_partsBmpArray.push(partsBmp);
				_viewSp.addChild(partsBmp);
			}

		}
		
		public function applyFilter(source:BitmapData):void {
			imgBmpData.draw(source);
			copyKsParts( createKsParts() );
			source.draw(_viewSp);
		}
		

		protected function createKsParts():BitmapData {       

			var mat:Matrix = new Matrix();
			mat.translate( -_ksRadius, -_ksRadius);
			if (_ksRadius > 0) {//- mouseX 
				_imgParam["vec"] = 1.0;
			}else {
				_imgParam["vec"] = -1.0;
			}
			//var dist:Number = Math.sqrt(Math.pow(_centerX - mouseX, 2) + Math.pow(_centerY - mouseY, 2))
			var dist:Number = Math.sqrt(Math.pow(_centerX, 2) + Math.pow(_centerY, 2))
			//_imgParam["vx"] = dist / _ksRadius * Math.PI * _imgParam["vec"];
			_imgParam["angle"] += vx * 0.02;
			mat.rotate(_imgParam["angle"]);
			_imgParam["scale"] = Math.min(1 / (dist / _ksRadius), 1.0);
			mat.scale(_imgParam["scale"], _imgParam["scale"]);
			
			var imgBmpData:BitmapData = new BitmapData(_imgBmp.height, _imgBmp.height, true, 0x00000000);
			imgBmpData.draw(_imgBmp, mat);
			
			imgBmpData.copyChannel(_maskBmpData, new Rectangle(0, 0, _imgBmp.width, _imgBmp.height), new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			return imgBmpData;
		}

		protected function copyKsParts(imgBmpData:BitmapData):void {
			for (var i:uint = 0; i < _partsBmpArray.length; i++) {
				var mat:Matrix = new Matrix();
		
				if (i % 2 != 0) {
					mat.scale( 1.0, -1.0);
					mat.rotate(_partsAngle * Math.PI / 180);
				}
				mat.rotate((i * _partsAngle - 90) * Math.PI / 180);
				mat.translate(_centerX, _centerY);
				
				_partsBmpArray[i].transform.matrix = mat;
				_partsBmpArray[i].bitmapData = imgBmpData;
			}
		}

		public function get vx():Number
		{
			return _vx;
		}

		public function set vx(value:Number):void
		{
			_vx = value;
		}


	}
}
import flash.display.Sprite;
import flash.geom.Point;

class Sector extends Sprite {
	public function Sector(px:Number, py:Number, partsRotate:Number, startAngle:Number, ksRadius:Number):void {
		var points:Array = getArcPoints(px, py, ksRadius, partsRotate, startAngle, 180);
		points.unshift( new Point(x, y) );
		drawLines(points);
	}

	private function getArcPoints(x:Number, y:Number, radius:Number, degree:Number, fromDegree:Number=0, split:Number=36):Array{
		var points:Array = new Array();
		var fromRad:Number = fromDegree * Math.PI / 180;
		var dr:Number = (degree * Math.PI / 180) / split;
		
		for(var i:int=0; i<split + 1; i++){
			var pt:Point = new Point();
			var rad:Number = fromRad + dr * i;
			pt.x = Math.cos(rad) * radius + x;
			pt.y = Math.sin(rad) * radius + y;
			points.push(pt);
		}
		
		return points;
	}
	
	//æ??ã??æ??ç??
	public function drawLines(points:Array):void {
		graphics.lineStyle(1, 0xffffff);
		graphics.beginFill(0xffffff);
		graphics.moveTo(points[0].x, points[0].y);
		for(var i:Number=1; i<points.length; i++){
			graphics.lineTo(points[i].x, points[i].y);
		}
	}
}
