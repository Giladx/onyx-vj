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
package library.patches
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import onyx.events.InteractionEvent;
	import onyx.plugin.*;
	
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
	
	public class PV3DSphere extends BasicView
	{
		private var sphere:Sphere;
		
		public function PV3DSphere()
		{
			super( DISPLAY_WIDTH, DISPLAY_HEIGHT );
			sphere = new Sphere( null, 100, 15, 12 );
			
			camera.fov = 30;
			scene.addChild( sphere );
			addEventListener( Event.ENTER_FRAME, enterFrame );
			addEventListener( InteractionEvent.MOUSE_MOVE, mouseMove);
		}
		private function mouseMove( event:InteractionEvent ):void 
		{
			sphere.yaw( ( DISPLAY_WIDTH - event.localX ) * 0.01 );
			sphere.pitch( ( DISPLAY_HEIGHT - event.localY ) * 0.01 );
		}
		public function enterFrame( e:Event ):void
		{
			
			singleRender();
		}
	}
}