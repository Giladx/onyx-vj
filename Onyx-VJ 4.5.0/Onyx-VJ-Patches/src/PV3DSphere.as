/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 *  
 * Papervision3D example
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * 
 */
package 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import onyx.core.Console;
	import onyx.events.InteractionEvent;
	import onyx.plugin.*;
	
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.shaders.GouraudShader;
	import org.papervision3d.materials.shaders.ShadedMaterial;
	import org.papervision3d.materials.shaders.Shader;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
	
	public class PV3DSphere extends BasicView
	{
		//FPS leak!!!
		private var sphere:Sphere;
		private var light : PointLight3D;
		private var shader : Shader; 
		[Embed (source="../assets/boulePoilue.png")]
		private var EarthMap:Class; 
		
		public function PV3DSphere()
		{
			super( DISPLAY_WIDTH, DISPLAY_HEIGHT );
			var earthbmp:BitmapData = new EarthMap().bitmapData;
			var earthmaterial:BitmapMaterial = new BitmapMaterial(earthbmp);
			// a light source
			light = new PointLight3D();
			light.x = 300; 
			light.y = 300; 
			
			// the type of shader to use... 
			
			shader = new GouraudShader(light, 0xFFFFFF,0x404040)
			
			// and the shaded material. 
			var shadedmaterial:ShadedMaterial = new ShadedMaterial(earthmaterial, shader);			
			
			sphere = new Sphere(shadedmaterial, 150,16,8);
			sphere.roll( 45 );
			sphere.pitch( 3.8 );
			//sphere.useOwnContainer = true;
			camera.fov = 30;
			scene.addChild( sphere );
			addEventListener( Event.ENTER_FRAME, enterFrame );
			addEventListener( InteractionEvent.MOUSE_MOVE, mouseMove);
		}
		private function mouseMove( event:InteractionEvent ):void 
		{
			//sphere.yaw( ( DISPLAY_WIDTH - event.localX ) * 0.01 );
			//Console.output( "pitch:" +( DISPLAY_HEIGHT - event.localY ) * 0.01 );
			sphere.pitch( ( DISPLAY_HEIGHT - event.localY ) * 0.01 );
		}
		public function enterFrame( e:Event ):void
		{
			sphere.yaw( ( DISPLAY_WIDTH ) * 0.001 );
			singleRender();
		}
		
	}
}