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
	
	import frocessing.color.ColorRGB;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	
	public class Ground extends Patch
	{
		private var PV:PVGround;

		private var sprite:Sprite;

		public function Ground() 
		{
			PV = new PVGround();
			sprite = new Sprite();

			sprite.addChild(PV);

		}	
	

		override public function render(info:RenderInfo):void 
		{			
			info.render( sprite );		
		}
		
	
	}
}

import flash.events.Event;

import onyx.core.*;
import onyx.plugin.*;

import org.papervision3d.core.render.filter.*;
import org.papervision3d.materials.*;
import org.papervision3d.materials.special.*;
import org.papervision3d.objects.primitives.*;
import org.papervision3d.view.*;

class PVGround extends BasicView
{
	
	
	public function PVGround() 
	{
		var fg:FogMaterial =new FogMaterial(0xffffff);
		renderer.filter = new FogFilter(fg,40,2000,6000);
		
		var plane:Plane = new Plane(new ColorMaterial(0x003300),10000,10000,20,20);
		
		plane.rotationX = 90;
		scene.addChild(plane);
		addEventListener( Event.ENTER_FRAME, enterFrame );
	}	
	


	public function enterFrame( e:Event ):void
	{
		var rot:Number = mouseX / DISPLAY_WIDTH* 360;
		
		camera.x = 3000* Math.sin(rot* Math.PI/180);
		camera.y = mouseY / DISPLAY_WIDTH* 3000;
		camera.x = 3000* Math.cos(rot* Math.PI/180);

		singleRender();
	}

}