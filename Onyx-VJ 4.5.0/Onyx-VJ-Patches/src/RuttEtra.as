package 
{    
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;	
	
	public class RuttEtra extends Patch
	{
		private var A3DRuttEtra:Test35_AlphaSorting;
		private var _depth:Number = .0005;
		private var _scale:Number = 6;
		private var sprite:Sprite;
		private var _scanStep:Number = 1;
		private var _size:int = 4;
		private var timer:Timer;
		
		public function RuttEtra() 
		{
			Console.output('RuttEtra');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			A3DRuttEtra = new Test35_AlphaSorting();
			
			sprite = new Sprite();
			addChild(sprite);
			sprite.addChild(A3DRuttEtra);
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			timer = new Timer(2000);
			timer.addEventListener(TimerEvent.TIMER, loop);
			timer.start();
		}	
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );		
		}
		private function loop(evt:TimerEvent):void 
		{
			//A3DRuttEtra.start();
			
		}
		public function get size():int
		{
			return _size;
		}
		
		public function set size(value:int):void
		{
			//A3DRuttEtra.size = _size = value;
		}
		
		public function get scanStep():Number
		{
			return _scanStep;
		}
		
		public function set scanStep(value:Number):void
		{
			//A3DRuttEtra.scanStep = _scanStep = value;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			//A3DRuttEtra.scale = _scale = value;
		}
		
		public function get depth():Number
		{
			return _depth;
		}
		
		public function set depth(value:Number):void
		{
			//A3DRuttEtra.depth = _depth = value;		
		}
		
		private function mouseDown(event:MouseEvent):void 
		{
			//A3DRuttEtra.mx = event.localX; 
			//A3DRuttEtra.my = event.localY; 
		}
		
	}
}
//import base.*;
import flare.basic.*;
import flare.core.*;
import flare.loaders.Flare3DLoader1;
import flare.materials.*;
import flare.materials.filters.*;
import flare.primitives.*;
import flare.system.*;
import flare.utils.*;

import flash.display.*;
import flash.events.*;
import flash.text.*;

/**
 * Alpha sorting test.
 * 
 * @author Ariel Nehmad
 */
class Test35_AlphaSorting extends Sprite//Base
{
	private var scene:Viewer3D;
	private var mode:int;
	private var info:TextField;
	
	public function Test35_AlphaSorting() 
	{
		//super( "Alpha sort test: Press SPACE to change the sort mode." );
		Flare3DLoader1;
		info = new TextField();
		info.textColor = 0xffffff;
		info.autoSize = "left";
		info.y = 15;
		addChild( info );
		info.text = "Sort mode: NONE";
		scene = new Viewer3D(this);
		scene.camera = new Camera3D();
		scene.camera.setPosition( 0, 0, -200 );
		scene.autoResize = true;
		scene.antialias = 2;
		scene.setLayerSortMode(10, Scene3D.SORT_NONE);
		
		var mat:Shader3D = new Shader3D( "", [new ColorFilter(0xff0000, 0.2)]);
		var cube:Cube = new Cube( "cube", 10, 10, 10, 1, mat )
		
		for ( var i:int = 0; i < 300; i++ )
		{
			var d:Mesh3D = cube.clone() as Mesh3D;
			d.x = Math.random() * 100 - 50;
			d.y = Math.random() * 100 - 50;
			d.z = Math.random() * 100 - 50;
			d.setLayer( 10 );
			scene.addChild( d );
		}
		
		scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
	}
	
	private function updateEvent(e:Event):void 
	{
		if ( Input3D.keyHit( Input3D.SPACE ) )
		{
			if ( ++mode > 2 ) mode = 0;
			
			switch(mode)
			{
				case 0: scene.setLayerSortMode(10, Scene3D.SORT_NONE); break;
				case 1: scene.setLayerSortMode(10, Scene3D.SORT_FRONT_TO_BACK); break;
				case 2: scene.setLayerSortMode(10, Scene3D.SORT_BACK_TO_FRONT); break;
			}
		}
		
		if ( !Input3D.mouseDown ) scene.camera.rotateY( 1, false, Vector3DUtils.ZERO );
		
		if (mode == 0) info.text = "Sort mode: NONE";
		else if (mode == 1) info.text = "Sort mode: SORT_FRONT_TO_BACK";
		else if (mode == 2) info.text = "Sort mode: SORT_BACK_TO_FRONT";
	}
}