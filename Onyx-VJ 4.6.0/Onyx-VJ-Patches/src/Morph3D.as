package 
{    
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Morph3D extends Patch
	{
		private var PV:PVMorph;
		private var sprite:Sprite;
		private var _depth:int = 24;
		
		public function Morph3D() 
		{
			Console.output('Morph3D v 0.0.8');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterInteger( 'depth', 'depth:', 1, 300, _depth )
			);
			PV = new PVMorph();
			
			sprite = new Sprite();
			//addChild(sprite);
			sprite.addChild(PV);
		}	
		override public function render(info:RenderInfo):void 
		{			
			info.render( sprite );		
		}		

		public function get depth():int
		{
			return _depth;
		}

		public function set depth(value:int):void
		{
			_depth = value;
			PV.depth = _depth;
		}
		override public function dispose():void {
			PV.dispose();
			sprite.removeChildren();
			sprite = null;
		}
	}
}

import EmbeddedAssets.AssetForMorph3D;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.filters.BlurFilter;
import flash.utils.Timer;
import flash.utils.getTimer;

import onyx.core.*;
import onyx.plugin.*;

import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.core.easing.*;
import org.libspark.betweenas3.easing.Bounce;
import org.libspark.betweenas3.easing.Expo;
import org.libspark.betweenas3.tweens.ITween;
import org.papervision3d.core.geom.Lines3D;
import org.papervision3d.core.geom.renderables.Line3D;
import org.papervision3d.core.geom.renderables.Vertex3D;
import org.papervision3d.core.math.Number3D;
import org.papervision3d.core.proto.MaterialObject3D;
import org.papervision3d.lights.PointLight3D;
import org.papervision3d.materials.BitmapMaterial;
import org.papervision3d.materials.shaders.GouraudShader;
import org.papervision3d.materials.shaders.ShadedMaterial;
import org.papervision3d.materials.shaders.Shader;
import org.papervision3d.materials.special.LineMaterial;
import org.papervision3d.materials.utils.MaterialsList;
import org.papervision3d.objects.DisplayObject3D;
import org.papervision3d.objects.primitives.Cube;
import org.papervision3d.objects.primitives.Cylinder;
import org.papervision3d.objects.primitives.Plane;
import org.papervision3d.objects.primitives.Sphere;
import org.papervision3d.view.BasicView;

class PVMorph extends BasicView
{
	private static const FOCUS_POSITION:int = 1000;
	private static const MAX_NUM:int = 150;
	//private static const SNOW_MAX_DEPTH:int = 24;
	private var _blurs:Vector.<BitmapData>;
	private var _particles:Vector.<Plane>;
	private var _targetVertexs:Vector.<Vertex3D>;
	private var _pitch:Number = 0;
	private var _radius:Number = 1000;
	private var _yaw:Number = 0;
	private var _depth:int = 24;
	private var sp:Sprite = new Sprite();
	private var bmd:BitmapData = new AssetForMorph3D();
	
	public function PVMorph() 
	{
		// bmp
		// create blur field material
		_blurs = new Vector.<BitmapData>(depth, true);
		for (var i:int = 0; i < depth; i++) {
			sp.addChild(new Bitmap(bmd));
			// ã¼ã‹ã—ã®é©ç”¨å€¤
			var blurFilter:BlurFilter = new BlurFilter(i, i, 4);
			// add Fileter
			sp.filters = [ blurFilter ];
			// copy bitmapdata
			var bitmapData:BitmapData = new BitmapData(100, 100, true, 0x00000000);
			bitmapData.draw(sp);
			// save
			_blurs[ i ] = bitmapData;
		}
		var vertexts:Array = [];
		// sphere
		vertexts[ 0 ] = [];
		var w:MaterialObject3D = new MaterialObject3D();
		var d:DisplayObject3D = new Sphere(w, 700, 13, 13);
		vertexts[ 0 ] = d.geometry.vertices;
		// cube
		d = new Cube(new MaterialsList({ all: w }), 1000, 1000, 1000, 5, 5, 5);
		vertexts[ 1 ] = d.geometry.vertices;
		// random
		vertexts[ 2 ] = [];
		for (i = 0; i < MAX_NUM; i++)
			vertexts[ 2 ][ i ] = new Vertex3D((Math.random() - 0.5) * 3000, (Math.random() - 0.5) * 3000, (Math.random() - 0.5) * 3000);
		// earth
		vertexts[ 3 ] = [];
		for (i = 0; i < MAX_NUM; i++) {
			vertexts[ 3 ][ i ] = vertexts[ 2 ][ i ].clone();
			vertexts[ 3 ][ i ].y = -1500;
		}
		// cylinder
		d = new Cylinder(w, 500, 1500, 15, 9);
		vertexts[ 4 ] = d.geometry.vertices;
		// init particle 
		_particles = new Vector.<Plane>(MAX_NUM, true);
		for (i = 0; i < MAX_NUM; i++) {
			// ãƒœãƒ¼ãƒ«
			var mt:MaterialObject3D = new BitmapMaterial(_blurs[ 0 ]);
			var ball:Plane = new Plane(mt, 100, 100);
			scene.addChild(ball);
			_particles[ i ] = ball;
		}
		// init tween
		_targetVertexs = new Vector.<Vertex3D>(MAX_NUM, true);
		var tweenArr:Array = [];
		var ease:IEasing = new CubicEaseIn();
		for (i = 0; i < MAX_NUM; i++) {
			var t1:Vertex3D = vertexts[ 0 ][ i ];
			var t2:Vertex3D = vertexts[ 1 ][ i ];
			var t3:Vertex3D = vertexts[ 2 ][ i ];
			var t4:Vertex3D = vertexts[ 3 ][ i ];
			var t5:Vertex3D = vertexts[ 4 ][ i ];
			// init
			_targetVertexs[ i ] = t4;
			// sphere
			var tw1:ITween = BetweenAS3.delay(BetweenAS3.tween(_targetVertexs[ i ],
				{ x: t1.x, y: t1.y, z: t1.z },
				{ x: t5.x, y: t5.y, z: t5.z },
				4, Expo.easeInOut), 1);
			// cube
			var tw2:ITween = BetweenAS3.delay(BetweenAS3.tween(_targetVertexs[ i ],
				{ x: t2.x, y: t2.y, z: t2.z },
				{ x: t1.x, y: t1.y, z: t1.z },
				4, Expo.easeInOut), 1);
			// random
			var tw3:ITween = BetweenAS3.delay(BetweenAS3.tween(_targetVertexs[ i ],
				{ x: t3.x, y: t3.y, z: t3.z },
				{ x: t2.x, y: t2.y, z: t2.z },
				3, Expo.easeInOut), 0.5);
			// earth
			var tw4:ITween = BetweenAS3.delay(BetweenAS3.tween(_targetVertexs[ i ],
				{ x: t4.x, y: t4.y, z: t4.z },
				{ x: t3.x, y: t3.y, z: t3.z },
				1, Bounce.easeOut), 1);
			// cylinder
			var tw5:ITween = BetweenAS3.delay(BetweenAS3.tween(_targetVertexs[ i ],
				{ x: t5.x, y: t5.y, z: t5.z },
				{ x: t4.x, y: t4.y, z: t4.z },
				4, Expo.easeInOut), 1);
			tweenArr[ i ] = BetweenAS3.delay(BetweenAS3.serial(tw1, tw2, tw3, tw4, tw5), ease.calculate(i, 0, 0.75, MAX_NUM));
		}
		var masterTw:ITween = BetweenAS3.parallelTweens(tweenArr);
		masterTw.stopOnComplete = false;
		masterTw.play();
		// start render
		startRendering();
	}	
	
	override protected function onRenderTick(event:Event = null):void {
		// camera
		/*_pitch += (mouseY / DISPLAY_WIDTH - 0.5) * 1;
		_yaw += (mouseX / DISPLAY_HEIGHT - 0.5) * 4;
		camera.x = Math.sin(_yaw * Number3D.toRADIANS) * _radius;
		camera.z = Math.cos(_yaw * Number3D.toRADIANS) * _radius;
		camera.y = _pitch * _radius * 0.01;*/
		// particle
		for (var i:int = 0; i < MAX_NUM; i++) {
			var p:Plane = _particles[ i ];
			p.x = _targetVertexs[ i ].x;
			p.y = _targetVertexs[ i ].y;
			p.z = _targetVertexs[ i ].z;
			p.scale = Math.sin(getTimer() / 150 + i * 0.04) * 0.5 + 1.1;
			// calc distance
			var f:Number = Math.abs(camera.distanceTo(p) - FOCUS_POSITION);
			var deg:Number = (f ^ (f >> 31)) - (f >> 31); // Math.abs(f)ã¨åŒç­‰
			// calc blur val
			var blurVal:int = deg * .02 << 1; //ã‚³ã‚³ã®èª¿æ•´ãŒçµ¶å¦™
			blurVal = blurVal > depth - 1 ? depth - 1 : blurVal;
			p.material.bitmap = _blurs[ blurVal ];
			// lookat camera
			p.lookAt(camera);
			p.yaw(180);
		}
		super.onRenderTick(event);
	}

	public function get depth():int
	{
		return _depth;
	}

	public function set depth(value:int):void
	{
		_depth = value;
		_blurs = null;
		_blurs = new Vector.<BitmapData>(depth, true);
		sp.removeChildren();
		for (var i:int = 0; i < depth; i++) {
			sp.addChild(new Bitmap(bmd));
			// ã¼ã‹ã—ã®é©ç”¨å€¤
			var blurFilter:BlurFilter = new BlurFilter(i, i, 4);
			// add Fileter
			sp.filters = [ blurFilter ];
			// copy bitmapdata
			var bitmapData:BitmapData = new BitmapData(100, 100, true, 0x00000000);
			bitmapData.draw(sp);
			// save
			_blurs[ i ] = bitmapData;
		}
	}
	public function dispose():void
	{
		stopRendering();
		_blurs = null;
		sp.removeChildren();
		_particles = null;
		_targetVertexs = null;

	}

}
