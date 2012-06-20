/**
 * Copyright agenda23 ( http://wonderfl.net/user/agenda23 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/zSTr
 */

/*
ã‚¯ãƒªãƒƒã‚¯ã§ã‚²ã‚¸ã‚²ã‚¸
â†‘â†“ã§ã‚²ã‚¸ã‚²ã‚¸ãƒã‚¤ãƒ³ãƒˆå¤‰æ›´
*/

package 
{    
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import frocessing.color.ColorRGB;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	
	public class DeathStar extends Patch
	{
		private var PV:PVDeathStar;
		private var _depth:Number = .0005;
		private var _scale:Number = 6;
		private var sprite:Sprite;
		private var _scanStep:int = 2;
		private var _factor:int = 3;
		private var _size:int = 4;
		private var _soundMultiplier:int = 15;
		private var _rx:int = 22;
		private var _ry:int = 150;
		private var _rz:int = 150;
		
		public function DeathStar() 
		{
			Console.output('DeathStar v 0.0.1');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			PV = new PVDeathStar();
			parameters.addParameters(
				new ParameterNumber( 'scale', 'scale:', 1, 30, _scale ),
				new ParameterInteger( 'size', 'size:', 1, 10, _size ),
				new ParameterInteger( 'scanStep', 'scanStep:', 1, 10, _scanStep ),
				new ParameterInteger( 'factor', 'factor:', 1, 10, _factor ),
				new ParameterNumber( 'depth', 'depth:', .0001, 3, _depth ),
				new ParameterInteger( 'rx', 'rotation x', 0, 360, _rx ),
				new ParameterInteger( 'ry', 'rotation y', 0, 360, _ry ),
				new ParameterInteger( 'rz', 'rotation z', 0, 360, _rz ),
				new ParameterInteger( 'soundMultiplier', 'sound multiplier:', 1, 600, _soundMultiplier ),
				new ParameterExecuteFunction('draw', 'draw')
			);
			sprite = new Sprite();
			addChild(sprite);
			sprite.addChild(PV);
			
		}	
		
		public function get soundMultiplier():int
		{
			return _soundMultiplier;
		}
		
		public function set soundMultiplier(value:int):void
		{
			//PV.soundMultiplier = _soundMultiplier = value;
		}
		
		public function draw():void
		{
			PV.clickObj();
		}
		public function get rz():int
		{
			return _rz;
		}
		
		public function set rz(value:int):void
		{
			_rz = value;
			//PV.rz = _rz;
		}
		
		public function get ry():int
		{
			return _ry;
		}
		
		public function set ry(value:int):void
		{
			_ry = value;
			//PV.ry = _ry;
		}
		
		public function get rx():int
		{
			return _rx;
		}
		
		public function set rx(value:int):void
		{
			_rx = value;
			//PV.rx = _rx;
		}
		
		public function get size():int
		{
			return _size;
		}
		
		public function set size(value:int):void
		{
			//PV.size = 
				_size = value;
		}
		
		public function get scanStep():int
		{
			return _scanStep;
		}
		
		public function set scanStep(value:int):void
		{
			//PV.scanStep =
			_scanStep = value;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			//PV.scale = 
			_scale = value;
		}
		
		public function get depth():Number
		{
			return _depth;
		}
		
		public function set depth(value:Number):void
		{
			//PV.depth = 
			_depth = value;		
		}
		
		override public function render(info:RenderInfo):void 
		{			
			//PV.onEnterFrame(null);
			info.render( sprite );		
		}
		
		public function get factor():int
		{
			return _factor;
		}
		
		public function set factor(value:int):void
		{
			//PV.factor = 
			_factor = value;
		}
		
	}
}

//PV deathstar
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.filters.*;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.System;
import flash.text.StyleSheet;
import flash.text.*;
import flash.utils.getTimer;
import flash.ui.Keyboard;
import org.papervision3d.core.effects.*;
import org.papervision3d.core.effects.utils.*;
import org.papervision3d.cameras.Camera3D;
import org.papervision3d.render.BasicRenderEngine;
import org.papervision3d.scenes.Scene3D;
import org.papervision3d.view.*;
import org.papervision3d.view.layer.*;
import org.papervision3d.objects.primitives.*;
import org.papervision3d.materials.*;
import org.papervision3d.materials.special.CompositeMaterial;

import caurina.transitions.*;

class PVDeathStar extends Sprite
{
	private var scene:Scene3D;
	private var viewport:Viewport3D;
	private var camera:Camera3D;
	private var renderer:BasicRenderEngine;
	private var objSphere:Sphere;
	private var gx:Number = 16;
	private var gy:Number = 16;
	private var grad:Number = 80;
	
	private var isTween:Boolean;
	
	private var key_value:Boolean;
	private var val:Number = 7;
	private var tf:TextField;
	private var str:String = "ekkosystem";
	
	
	
	
	public function PVDeathStar()
	{

		init3D();
		
		tf = new TextField();
		addChild(tf);
		tf.x = 5;
		tf.y = 120;
		tf.width  = 100;
		tf.height = 20;
		tf.textColor = 0xFFFFFF;
		tf.multiline = true;
		tf.type = TextFieldType.DYNAMIC;
		tf.text = str;
	}

	private function init3D():void
	{
		viewport = new Viewport3D(0,0,true);
		viewport.opaqueBackground = 0x000000;
		addChild(viewport);
		
		var effectLayer:BitmapEffectLayer = new BitmapEffectLayer(viewport, 800, 800,false,0x000000,"crear_pre",true);
		effectLayer.addEffect(new BitmapLayerEffect(new BlurFilter(1.2, 1.2, 1)));
		effectLayer.drawCommand = new BitmapDrawCommand(null, new ColorTransform(1, 1, 1, 0.1,0,0,0,-5), BlendMode.SHADER,false);
		viewport.containerSprite.addLayer(effectLayer);
		
		
		
		renderer = new BasicRenderEngine();
		
		camera = new Camera3D();
		camera.z = -450;
		camera.focus = 500;
		camera.zoom = 1;
		
		scene = new Scene3D();
		
		var colorMat:ColorMaterial = new ColorMaterial( 0x000000, 1 );
		var wireMat:WireframeMaterial = new WireframeMaterial( 0x08FF10 );
		var compoMat:CompositeMaterial = new CompositeMaterial();
		compoMat.addMaterial(colorMat);
		compoMat.addMaterial(wireMat);
		compoMat.doubleSided = false;
		
		objSphere = new Sphere(compoMat, grad, gx, gy );
		scene.addChild(objSphere);
		
		
		effectLayer.addDisplayObject3D(objSphere);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame); 
		
	}
	
	public function onEnterFrame(event:Event):void
	{	
		//    objSphere.rotationY += 2;
		objSphere.rotationY = mouseX;
		objSphere.rotationX = mouseY;
		objSphere.rotationZ += 0.2;
		
		renderer.renderScene(scene, camera, viewport);		
		
	}
	public function clickObj():void {
		var vertex_selection:Number;
		var num:Number = 1;
		for each(var i:* in objSphere.geometry.vertices) {
			//é ‚ç‚¹é¸æŠž
			if(num%val == 0) {
				if(isTween) {
					Tweener.addTween(i, { x:i.x*0.5, 
						y:i.y*0.5,
						z:i.z*0.5,
						time:0.5,
						delay:0,
						transition:"easeInOutElastic"
					});
				} else {
					Tweener.addTween(i, { x:i.x*2, 
						y:i.y*2,
						z:i.z*2,
						time:Math.random(),
						//    time:0.3,
						//   delay:Math.random(),
						delay:0.3,
						transition:"easeInOutElastic"
					});
				}
			}
			num++;
		}
		
		
		tf.text = ""	    
		isTween = !isTween;
		renderer.renderScene(scene,camera,viewport);
	}
}

