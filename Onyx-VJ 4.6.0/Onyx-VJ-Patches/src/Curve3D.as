/**
 * Copyright psyark ( http://wonderfl.net/user/psyark )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/e14Z
 */

/**
 * see http://wonderfl.net/code/68080952a04c2257794d4643f6ddf3f17465c6bc
 */
package {
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Curve3D extends Patch {
		private var commands:Vector.<int>;
		private var vertices:Vector.<Number>;
		private var projected:Vector.<Number>;
		private var uvtData:Vector.<Number>;
		private var progress:Number = 0;
		private var viewport:Sprite;
		
		public function Curve3D() {
			commands = new Vector.<int>();
			vertices = new Vector.<Number>();
			projected = new Vector.<Number>();
			uvtData = new Vector.<Number>();
			
			createModel();
			
			viewport = new Sprite();
			viewport.x = DISPLAY_WIDTH / 2;
			viewport.y = DISPLAY_HEIGHT / 2;
			viewport.filters = [new GlowFilter(0x0C99FF, 0.7, 32, 32, 2, 3)];
			addChild(viewport);

		}
		
		private function createModel():void {
			commands.length = 0;
			vertices.length = 0;
			uvtData.length = 0;
			
			var x1:Number = Math.random() * 1000 - 500;
			var y1:Number = Math.random() * 1000 - 500;
			var z1:Number = Math.random() * 1000 - 500;
			commands.push(GraphicsPathCommand.MOVE_TO);
			
			vertices.push(Math.random() * 1000 - 500);
			vertices.push(Math.random() * 1000 - 500);
			vertices.push(Math.random() * 1000 - 500);
			vertices.push(x1);
			vertices.push(y1);
			vertices.push(z1);
			uvtData.push(0, 0, 0);
			uvtData.push(0, 0, 0);
			
			for (var i:int=0; i<50; i++) {
				var x2:Number = Math.random() * 1000 - 500;
				var y2:Number = Math.random() * 1000 - 500;
				var z2:Number = Math.random() * 1000 - 500;
				commands.push(GraphicsPathCommand.CURVE_TO);
				
				vertices.push((x1 + x2) / 2);
				vertices.push((y1 + y2) / 2);
				vertices.push((z1 + z2) / 2);
				vertices.push(x2);
				vertices.push(y2);
				vertices.push(z2);
				uvtData.push(0, 0, 0);
				uvtData.push(0, 0, 0);
				
				x1 = x2;
				y1 = y2;
				z1 = z2;
			}
		}
		
		override public function render(info:RenderInfo):void {
			var pers:PerspectiveProjection = new PerspectiveProjection();
			pers.fieldOfView = 60;
			
			var m:Matrix3D = new Matrix3D();
			if (Capabilities.version.indexOf("10,0,12,36") != -1) {
				m.appendScale(20, 20, 20);
			}
			
			m.appendRotation(getTimer() * 0.0059, Vector3D.Y_AXIS);
			m.appendRotation(getTimer() * 0.0071, Vector3D.X_AXIS);
			m.appendTranslation(0, 0, 1000);
			m.append(pers.toMatrix3D());
			Utils3D.projectVectors(m, vertices, projected, uvtData);
			
			progress += 0.3;
			if (progress >= commands.length - 1) {
				progress %= commands.length - 1;
				createModel();
			}
			
			var index:int = Math.floor(progress);
			if (index != progress) {
				var i:int = index * 4;
				var r:Number = progress - index;
				var s:Number = 1 - r;
				projected[i + 4] = projected[i + 0] * s * s + projected[i + 2] * 2 * r * s + projected[i + 4] * r * r;
				projected[i + 5] = projected[i + 1] * s * s + projected[i + 3] * 2 * r * s + projected[i + 5] * r * r;
				projected[i + 2] = projected[i + 2] * r + projected[i + 0] * s;
				projected[i + 3] = projected[i + 3] * r + projected[i + 1] * s;
			}
			
			var c:Vector.<int> = commands.slice(0, Math.ceil(progress + 1));
			
			viewport.graphics.clear();
			viewport.graphics.lineStyle(8, 0x0C6CFF);
			viewport.graphics.drawPath(c, projected);
			viewport.graphics.lineStyle(4, 0x78E8FF);
			viewport.graphics.drawPath(c, projected);
			viewport.graphics.lineStyle(1, 0xFFFFFF);
			viewport.graphics.drawPath(c, projected);
			info.render(viewport);
		}
	}
}
