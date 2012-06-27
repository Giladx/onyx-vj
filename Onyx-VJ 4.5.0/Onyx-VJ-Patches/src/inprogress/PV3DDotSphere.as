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
package inprogress 
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
	
	public class PV3DDotSphere extends Patch
	{
		private var PV:DotSphere;
		private var sprite:Sprite;
		
		public function PV3DDotSphere() 
		{
			Console.output('PV3DDotSphere v 0.0.11');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			PV = new DotSphere();
			
			sprite = new Sprite();
			addChild(sprite);
			sprite.addChild(PV);

		}	
		
		override public function render(info:RenderInfo):void 
		{			
			info.render( sprite );		
		}
	}
}
import caurina.transitions.*;
import caurina.transitions.properties.*;

import flash.display.*;
import flash.events.*;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;

import onyx.core.Console;
import onyx.events.InteractionEvent;
import onyx.plugin.*;

import org.papervision3d.cameras.Camera3D;
import org.papervision3d.core.effects.BitmapLayerEffect;
import org.papervision3d.core.geom.Pixels;
import org.papervision3d.materials.WireframeMaterial;
import org.papervision3d.materials.special.ParticleMaterial;
import org.papervision3d.objects.DisplayObject3D;
import org.papervision3d.objects.primitives.Sphere;
import org.papervision3d.objects.special.ParticleField;
import org.papervision3d.render.BasicRenderEngine;
import org.papervision3d.scenes.Scene3D;
import org.papervision3d.view.Viewport3D;
import org.papervision3d.view.layer.BitmapEffectLayer;

class DotSphere extends Sprite
{
	private var scene:Scene3D;
	private var camera:Camera3D;
	private var viewport:Viewport3D;
	private var render:BasicRenderEngine;
	private var rootNode:DisplayObject3D;
	private var bfm:BitmapEffectLayer;
	private var coltrans:ColorTransform;
	private var cameraBool:Boolean;
	private var cametaPos:Object;
	private var angle:Number;

	
	public function DotSphere()
	{
		var bitmap:Bitmap = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT,false,0x000000));
		addChild(bitmap);
		
		
		scene = new Scene3D();
		viewport = new Viewport3D(0, 0, true, false);
		addChild(viewport);
		rootNode = new DisplayObject3D();
		scene.addChild(rootNode);
		camera = new Camera3D();
		camera.z = -camera.focus * camera.zoom;
		render = new BasicRenderEngine();
		
		var sphere:Sphere = new Sphere(new WireframeMaterial(0xFFFFFF, 100, 1), 100, 36, 24);
		var vmax:Number = sphere.geometry.vertices.length - 1;
		var mat:ParticleMaterial =  new ParticleMaterial(0xFFFFFF, 10, 1);
		var particles:ParticleField = new ParticleField(mat, vmax*2, 3, 2000, 2000, 2000);
		
		bfm = new BitmapEffectLayer(viewport, DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0, "clear_pre",false,false );
		bfm.addEffect(new BitmapLayerEffect(new BlurFilter(10, 10, 3), false));
		bfm.drawCommand.blendMode = BlendMode.ADD
		viewport.containerSprite.addLayer(bfm);
		bfm.addDisplayObject3D(particles);
		
		coltrans = new ColorTransform(0,0,0,1,0,0,0,0);
		rootNode.addChild(particles)
		
		for (var i:Number = 0; i <= vmax; i++) {
			var gx:Number = sphere.geometry.vertices[i].x;
			var gy:Number = sphere.geometry.vertices[i].y;
			var gz:Number = sphere.geometry.vertices[i].z;
			Tweener.addTween(particles.geometry.vertices[i], { x:gx, y:gy, z:gz, delay:i*.1,time:5, transition:"easeInOutExpo" } );
		}
		
		angle = 0;
		cameraBool = true;
		cametaPos = { b: -camera.focus * camera.zoom, f:-camera.focus * camera.zoom + 150 };
		
		update(null);
		addEventListener(Event.ENTER_FRAME, update);

		addEventListener( MouseEvent.MOUSE_DOWN, changeView);
	}
	
	//Rendering...
	private function update(e:Event):void{
		render.renderScene(scene, camera, viewport);
		rootNode.rotationY+=.5;
		rootNode.rotationX+=.3;
		rootNode.rotationZ+=.1;
		angle+=.01;
		var sin:Number = Math.sin(angle)
		var cos:Number = Math.cos(angle)
		if (sin < .1) sin = Math.abs(sin)+.1;
		if (cos < .1) cos = Math.abs(cos)+.1;
		
		coltrans.redMultiplier = sin/4;
		coltrans.greenMultiplier = cos/2;
		coltrans.blueMultiplier = sin;
		
		bfm.drawCommand.colorTransform = coltrans;
	}
	//MouseEvent...
	private function changeView(e:MouseEvent) :void {
		Tweener.removeTweens(camera);
		if (cameraBool) {
			cameraBool = false;
			Tweener.addTween(camera, { z:cametaPos.f, time:10, transition:"easeInOutQuard" } );
		}else {
			cameraBool = true;
			Tweener.addTween(camera, { z:cametaPos.b, time:10, transition:"easeInOutQuard" } );
		}
	}

}