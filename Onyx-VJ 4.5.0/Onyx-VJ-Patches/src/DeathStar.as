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
	
	public class DeathStar extends Sprite
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
		private var str:String = "";
		
		
		
		
		public function DeathStar()
		{

			init3D();
			
			addEventListener(MouseEvent.CLICK, clickObj);
			
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
			
			
			
			
			function keyDownHandler (event:KeyboardEvent):void {
				
				
				if (event.keyCode == Keyboard.UP) {
					key_value = true;
					val ++;
					tf.text = String(val);
				} else if (event.keyCode == Keyboard.DOWN) {
					key_value = false;
					val --;
					tf.text = String(val);
				} 
				
				event.updateAfterEvent();  
			}
			addEventListener (KeyboardEvent.KEY_DOWN, keyDownHandler);	
			
			
			
			
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
		
		private function onEnterFrame(event:Event):void
		{
			
			
			//    objSphere.rotationY += 2;
			objSphere.rotationY = mouseX;
			objSphere.rotationX = mouseY;
			objSphere.rotationZ += 0.2;
			
			
			
			
			renderer.renderScene(scene, camera, viewport);
			
			
		}
		private function clickObj (e:MouseEvent):void {
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
	
}
