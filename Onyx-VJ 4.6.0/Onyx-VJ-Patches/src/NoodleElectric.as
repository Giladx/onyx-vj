/**
* Copyright flashmafia ( http://wonderfl.net/user/flashmafia )
* MIT License ( http://www.opensource.org/licenses/mit-license.php )
* Downloaded from: http://wonderfl.net/c/6nIZ
*/

package {
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class NoodleElectric extends Patch {
		/* */
		private const NUM_BITS : uint = 1024;
		private const GURF_START : Number = 22;
		private const GURF_DECAY : Number = 0.995;
		/* */
		private var _nodes : Node;
		private var _mtx : Matrix;
		private var mx:Number = 320;
		private var my:Number = 240;
		private var sprite:Sprite;
		
		public function NoodleElectric() {
			sprite = new Sprite();
			opaqueBackground = 0x0;
			
			var node : Node = _nodes = new Node();
			var i : uint = NUM_BITS;
			while (i-- != 0) {
				node.x = DISPLAY_WIDTH * Math.random();
				node.y = DISPLAY_HEIGHT * Math.random();
				node.next = new Node();
				node.next.prev = node;
				node = node.next;
			}
			
			_mtx = new Matrix();
			_mtx.createGradientBox(DISPLAY_WIDTH, DISPLAY_HEIGHT, Math.PI);
			
			addEventListener( MouseEvent.MOUSE_DOWN, onDown );
			addEventListener( MouseEvent.MOUSE_MOVE, onDown );
		}
		private function onDown(e:MouseEvent):void {
			mx = e.localX; 
			my = e.localY; 			
		}		
		override public function render(info:RenderInfo):void {
			var gurf : Number = GURF_START;
			var gdecay : Number = GURF_DECAY;
			var pi : Number = Math.PI;
			var tx : Number = mx + Math.random();
			var ty : Number = my + Math.random();
			
			var node : Node = _nodes;
			node.a = pi + Math.atan2(ty - node.y, tx - node.x);
			node.x += (tx - node.x) * 0.11;
			node.y += (ty - node.y) * 0.11;
			
			sprite.graphics.clear();
			sprite.graphics.beginGradientFill(GradientType.RADIAL, [0x777777, 0x555555], [1.0, 1.0], [0, 255], _mtx);
			sprite.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			sprite.graphics.endFill();
			
			sprite.graphics.moveTo(node.x, node.y);
			
			node = node.next;
			while (node != null) {
				var pnode : Node = node.prev;
				node.a = pi + Math.atan2(pnode.y - node.y, pnode.x - node.x);
				node.x = pnode.x + 8 * Math.cos(pnode.a);
				node.y = pnode.y + 8 * Math.sin(pnode.a);
				
				sprite.graphics.lineStyle(gurf *= gdecay, 0xEFEFEF, 1.0, false, LineScaleMode.NONE, CapsStyle.SQUARE);
				sprite.graphics.lineTo(node.x, node.y);
				
				node = node.next;
			}
			info.render( sprite );
		}
	}
}
import flash.display.GradientType;
import flash.display.Shape;
import flash.events.Event;
import flash.geom.Matrix;

internal class Node {
	public var next : Node;
	public var prev : Node;
	public var x : Number;
	public var y : Number;
	public var a : Number;
}