/**
 * Copyright Saqoosha ( http://wonderfl.net/user/Saqoosha )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/poFZ
 */

package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * @author Saqoosha
	 */
	public class ElasticImage extends Patch {
		
		
		private var _numSegments:int = 10;
		private var _segmentLength:Number = 10;
				
		private var _dragging:Anchor = null;
		private var _anchors:Vector.<Anchor>;
		
		private var _image:BitmapData;
		private var _vertices:Vector.<Number>;
		private var _indices:Vector.<int>;
		private var _uvtData:Vector.<Number>;
		private var sprite:Sprite;
		private var mx:int = 10;
		private var my:int = 10;
		
		
		public function ElasticImage() 
		{
			sprite = new Sprite();
			_image = new AssetForElasticImage(); 
			_onClickRebuild();
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		
		private function _onClickRebuild(e:Event = null):void {
			//_numSegments = _segmentsSlider.value;
			_segmentLength = 200 / (_numSegments - 1);
			_anchors = new Vector.<Anchor>();
			_vertices = new Vector.<Number>();
			_indices = new Vector.<int>();
			_uvtData = new Vector.<Number>();
			var n:int = _numSegments - 1;
			var x:int, y:int;
			for (y = 0; y < _numSegments; y++) {
				for (x = 0; x < _numSegments; x++) {
					_anchors.push(new Anchor(x * _segmentLength, y * _segmentLength));
					_vertices.push(0, 0);
					if (x > 0 && y > 0) {
						var index:int = x + y * _numSegments;
						_indices.push(index - _numSegments - 1, index - _numSegments, index - 1);
						_indices.push(index - _numSegments, index, index - 1);
					}
					_uvtData.push(x / n, y / n);
				}
			}
			_retargetAnchors(_anchors[0]);
		}
		
		
		private function _onMouseDown(e:MouseEvent):void {
			mx = e.localX;
			my = e.localY;
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			var minDist:Number = Number.MAX_VALUE;
			for each (var a:Anchor in _anchors) {
				var dx:Number = mx - a.x;
				var dy:Number = my - a.y;
				var d:Number = dx * dx + dy * dy;
				if (d < minDist) {
					_dragging = a;
					minDist = d;
				}
			}
			_retargetAnchors(_dragging);
			_dragging.x = mx;
			_dragging.y = my;
		}
		
		
		private function _onMouseMove(e:MouseEvent):void {
			mx = e.localX;
			my = e.localY;
			_dragging.x = mx;
			_dragging.y = my;
		}
		
		
		private function _onMouseUp(e:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_dragging = null;
		}
		
		
		private function _retargetAnchors(origin:Anchor):void {
			origin.target = null;
			var x:int, y:int;
			for (y = 0; y < _numSegments; y++) {
				for (x = 0; x < _numSegments; x++) {
					var index:int = y * _numSegments + x;
					if ( index >= _anchors.length ) index = _anchors.length - 1;
					var a:Anchor = _anchors[index];
					if (a == origin) continue;
					var dx:int = a.x - origin.x;
					var dy:int = a.y - origin.y;
					if (Math.abs(dx) > Math.abs(dy)) {
						if (dx > 0) {
							a.target = _anchors[index - 1];
							a.offsetX = _segmentLength;
						} else {
							a.target = _anchors[index + 1];
							a.offsetX = -_segmentLength;
						}
						a.offsetY = 0;
					} else {
						if (dy > 0) {
							if (index - _numSegments > 0)//BL
							{
								a.target = _anchors[index - _numSegments];
								a.offsetY = _segmentLength;
							}
						} else {
							if (index + _numSegments < _anchors.length-1)//BL
							{
								a.target = _anchors[index + _numSegments];
								a.offsetY = -_segmentLength;
								
							}
						}
						a.offsetX = 0;
					}
				}
			}
		}
		
		override public function render(info:RenderInfo):void 
		{
			var a:Anchor;
			var index:int = 0;
			var drag:Number = 1;//_dragSlider.value;
			if (_anchors)
			{
				for (var i:int = 0, n:int = _anchors.length; i < n; i++) {
					a = _anchors[i];
					if (a.target) {
						a.x += (a.target.x + a.offsetX - a.x) * drag;
						a.y += (a.target.y + a.offsetY - a.y) * drag;
					}
					_vertices[index++] = a.x;
					_vertices[index++] = a.y;
				}
				
			}
			if (_image)
			{
				sprite.graphics.clear();
				sprite.graphics.beginBitmapFill(_image);
				sprite.graphics.drawTriangles(_vertices, _indices, _uvtData);
				sprite.graphics.endFill();
				/*if (_debugCheckBox.selected) {
					for each (a in _anchors) {
						if (a.target) {
							graphics.lineStyle(0, 0x7c93ff);
							graphics.moveTo(a.x, a.y);
							graphics.lineTo(a.x + (a.target.x - a.x) * .5, a.y + (a.target.y - a.y) * .7);
							graphics.lineStyle();
						}
						graphics.beginFill(0xff487b);
						graphics.drawCircle(a.x, a.y, 3);
						graphics.endFill();
					}
				}*/
				info.render(sprite);
				
			}
		}
	}
}


class Anchor {
	
	
	public var x:Number;
	public var y:Number;
	public var target:Anchor = null;
	public var offsetX:Number = 0;
	public var offsetY:Number = 0;
	
	
	public function Anchor(x:Number = 0, y:Number = 0, target:Anchor = null) {
		this.y = y;
		this.x = x;
		this.target = target;
		if (target) {
			offsetX = x - target.x;
			offsetY = y - target.y;
		}
	}
}
