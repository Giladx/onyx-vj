/**
 * Copyright GreekFellows ( http://wonderfl.net/user/GreekFellows )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rgtJ
 */

package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * ...
	 * @author Greek Fellows
	 */
	public class Orbitals extends Patch 
	{
		private var sprite:Sprite;
		private var core:Sprite;
		
		private var array:Array;
		private var colors:Array;
		private var radii:Array;
		private var zsorted:Array;
		
		private var mxs:Array;
		private var mys:Array;
		private var mzs:Array;
		
		private var axs:Array;
		private var ays:Array;
		private var azs:Array;
		
		private var release:Boolean;
		
		private var field:Number;
		private var mx:int = 0;
		private var my:int = 0;
		
		public function Orbitals():void 
		{
			array = [];
			colors = [];
			radii = [];
			zsorted = [];
			
			mxs = [];
			mys = [];
			mzs = [];
			
			axs = [];
			ays = [];
			azs = [];
			
			release = false;
			
			field = 500;
			
			init();
			
			sprite = new Sprite();
			sprite.x=DISPLAY_WIDTH/2;
			sprite.y=DISPLAY_HEIGHT/2;
			sprite.z=0;
			addChild(sprite);
			
			core=new Sprite();
			core.x=0;
			core.y=0;
			core.z=0;
			sprite.addChild(core);
			
			addEventListener(MouseEvent.MOUSE_DOWN, startRelease);
			addEventListener(MouseEvent.MOUSE_UP, stopRelease);
			
			addEventListener(Event.ENTER_FRAME, spin);
			addEventListener(Event.ENTER_FRAME, orbitalize);
		}
		override public function render(info:RenderInfo):void 
		{			
			info.render( sprite );		
		}
		private function init():void {
			// change array here
			array = [];
			
			for (var creation:int = 0; creation < 50; creation++) {
				array.push( { vector:new Vector3D(Math.floor(Math.random() * field) - field / 2, Math.floor(Math.random() * field) - field / 2, Math.floor(Math.random() * field) - field / 2), color:Math.floor(Math.random() * 0xffffff / 5) * 5, radius:Math.random() * 45 + 5 } );
				mxs.push(0);
				mys.push(0);
				mzs.push(0);
				axs.push(0);
				ays.push(0);
				azs.push(0);
			}
		}
		
		private function spin(e:Event):void {
			core.transform.matrix3D.appendRotation((mx - 300) / 100, Vector3D.X_AXIS);
			core.transform.matrix3D.appendRotation((my - 400) / 100, Vector3D.Y_AXIS);
			
			sprite.graphics.clear();
			
			sortbyZ();
			
			for (var a:int = 0; a < zsorted.length; a++) {
				sprite.graphics.beginFill(zsorted[a].color, .75);
				sprite.graphics.drawCircle(graph(zsorted[a].vector,false).x, graph(zsorted[a].vector,false).y, zsorted[a].radius);
				sprite.graphics.endFill();
			}
		}
		
		private function orbitalize(e:Event):void {
			if (!release) {
				for (var ex:int = 0; ex < array.length; ex++) {
					mxs[ex] += (0 - array[ex].vector.x) / 60;
					mys[ex] += (0 - array[ex].vector.y) / 60;
					mzs[ex] += (0 - array[ex].vector.z) / 60;
					
					array[ex].vector.x += mxs[ex];
					array[ex].vector.y += mys[ex];
					array[ex].vector.z += mzs[ex];
					
					mxs[ex] *= .95;
					mys[ex] *= .95;
					mzs[ex] *= .95;
				}
			} else {
				for (var ix:int = 0; ix < array.length; ix++) {
					axs[ix] += Math.floor(Math.random() * 100 - 50) / 100;
					ays[ix] += Math.floor(Math.random() * 100 - 50) / 100;
					azs[ix] += Math.floor(Math.random() * 100 - 50) / 100;
					
					array[ix].vector.x += axs[ix];
					array[ix].vector.y += ays[ix];
					array[ix].vector.z += azs[ix];
					
					if (axs[ix] > 5 || azs[ix] < -5) {
						axs[ix] *= (2 / 5);
					}
					if (ays[ix] > 5 || azs[ix] < -5) {
						ays[ix] *= (2 / 5);
					}
					if (azs[ix] > 5 || azs[ix] < -5) {
						azs[ix] *= (2 / 5);
					}
					
					if (array[ix].vector.x > field / 2) {
						axs[ix] *= -1;
						array[ix].vector.x = field / 2;
					}
					if (array[ix].vector.x < -field / 2) {
						axs[ix] *= -1;
						array[ix].vector.x = -field / 2;
					}
					if (array[ix].vector.y > field / 2) {
						ays[ix] *= -1;
						array[ix].vector.y = field / 2;
					}
					if (array[ix].vector.y < -field / 2) {
						ays[ix] *= -1;
						array[ix].vector.y = -field / 2;
					}
					if (array[ix].vector.z > field / 2) {
						azs[ix] *= -1;
						array[ix].vector.z = field / 2;
					}
					if (array[ix].vector.z < -field / 2) {
						azs[ix] *= -1;
						array[ix].vector.z = -field / 2;
					}
				}
			}
		}
		
		private function startRelease(me:MouseEvent):void {
			mx = me.localX; 
			my = me.localY; 
			release = true;
		}
		
		private function stopRelease(me:MouseEvent):void {
			release = false;
		}
		
		private function graph(vector:Vector3D,transformVector:Boolean=true):Vector3D {
			var mat:Matrix3D = core.transform.matrix3D.clone();
			
			var xy:Vector3D = vector;
			if (transformVector) xy = mat.transformVector(vector);
			xy.w = (750 + xy.z) / 750;
			xy.project();
			
			return xy;
		}
		
		private function sortbyZ():void {
			zsorted = [];
			var mat:Matrix3D = core.transform.matrix3D.clone();
			
			for (var b:int = 0; b < array.length; b++) {
				zsorted.push( { vector:mat.transformVector(array[b].vector), color:array[b].color, radius:array[b].radius, z:mat.transformVector(array[b].vector).z } );
			}
			
			zsorted.sortOn("z", Array.NUMERIC | Array.DESCENDING);
		}
		
	}
	
}