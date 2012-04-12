/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/iUXg
 */

// forked from katapad's ã‚¯ãƒªãƒƒã‚¯ã§unkoã‚’çˆ†ç™ºã•ã›ãŸã‚Šæˆ»ã—ãŸã‚Šã™ã‚‹ã‚³ãƒ¼ãƒ‰
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
	
	public class UnkoField extends Patch
	{
		private var PV:PVUnkoField;
		private var sprite:Sprite;
		private var _size:int = 15;
		private var _rx:int = 270;
		private var _ry:int = 270;
		private var _rz:int = 270;
		private var _text:String = "EKKOSYSTEM";

		public function UnkoField() 
		{
			Console.output('UnkoField');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			PV = new PVUnkoField();
			
			parameters.addParameters(
				new ParameterString('text', 'text'),
				new ParameterInteger( 'size', 'size:', 1, 300, _size ),
				new ParameterInteger( 'rx', 'rotation x', 0, 360, _rx ),
				new ParameterInteger( 'ry', 'rotation y', 0, 360, _ry ),
				new ParameterInteger( 'rz', 'rotation z', 0, 360, _rz ),
				new ParameterExecuteFunction('run', 'run'),
				new ParameterExecuteFunction('explode', 'explode')
			);
			sprite = new Sprite();
			addChild(sprite);
			sprite.addChild(PV);
			PV.rx = _rx;
			PV.ry = _ry;
			PV.rz = _rz;
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}	

		public function get rz():int
		{
			return _rz;
		}

		public function set rz(value:int):void
		{
			_rz = value;
			PV.rz = _rz;
		}

		public function get ry():int
		{
			return _ry;
		}

		public function set ry(value:int):void
		{
			_ry = value;
			PV.ry = _ry;
		}

		public function get rx():int
		{
			return _rx;
		}

		public function set rx(value:int):void
		{
			_rx = value;
			PV.rx = _rx;
		}

		public function explode():void
		{
			PV.explode();
		}
		public function run():void
		{
			PV.createText();
		}
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			PV.text = _text;
		}

		public function get size():int
		{
			return _size;
		}
		
		public function set size(value:int):void
		{
			_size = value;
			PV.size = _size;
		}		

		
		private function mouseDown(event:MouseEvent):void 
		{
			PV.mx = event.localX; 
			PV.my = event.localY; 
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );		
		}
	}
}
//import fl.motion.easing.*;
import flash.display.*;
import flash.events.*;
import flash.filters.*;
import flash.geom.Point;
import flash.text.*;

import gs.TweenMax;

import onyx.core.Console;
import onyx.plugin.*;
import onyx.tween.easing.Quintic;

import org.papervision3d.core.effects.BitmapLayerEffect;
import org.papervision3d.core.geom.Pixels;
import org.papervision3d.core.geom.renderables.Pixel3D;
import org.papervision3d.objects.DisplayObject3D;
import org.papervision3d.view.BasicView;
import org.papervision3d.view.layer.BitmapEffectLayer;

class PVUnkoField extends BasicView 
{
	private var _size:int = 15;
	private var _text:String = "EKKOSYSTEM";
	private var _root:DisplayObject3D;
	private var _defaultForm:Boolean;
	private var _pixelList:Array;
	private var _textPosList:Array;
	private var _mx:Number = 0;
	private var _my:Number = 0;
	private var middle:int = DISPLAY_WIDTH/2;
	private var _rx:int = 270;
	private var _ry:int = 270;
	private var _rz:int = 270;
	
	public function PVUnkoField() 
	{
		_defaultForm = true;
		initScene();

		startRendering();
	}
	public function get rz():int
	{
		return _rz;
	}
	
	public function set rz(value:int):void
	{
		_rz = value;
		_root.rotationZ = _rz;
	}
	
	public function get ry():int
	{
		return _ry;
	}
	
	public function set ry(value:int):void
	{
		_ry = value;
		_root.rotationY = _ry;
	}
	
	public function get rx():int
	{
		return _rx;
	}	
	public function set rx(value:int):void
	{
		_rx = value;
		_root.rotationX = _rx;
	}
	public function get size():int
	{
		return _size;
	}

	public function set size(value:int):void
	{
		_size = value;
	}
	public function get text():String
	{
		return _text;
	}
	
	public function set text(value:String):void
	{
		_text = value;
	}
	override protected function onRenderTick(event:Event = null):void 
	{
		super.onRenderTick(event);
		//Console.output("rx " + _root.rotationX + " ry " + _root.rotationY + " rz " + _root.rotationZ + " mx " + mx + " my " + my);
		//_root.rotationX = 270;
		/*_root.rotationY = 270;
		_root.rotationZ = 270;
		_root.rotationX += ( -mx - _root.rotationX) * 0.001; */
		//_root.rotationY += ( -my - _root.rotationY) * 0.1;
		//_root.rotationZ += ( -my - _root.rotationZ) * 0.005;
	}
	
	private function initScene():void
	{
		_root = scene.addChild(new DisplayObject3D());
		_camera.x = middle/4;
		_camera.z = -70;
	}
	
	public function createText():void
	{
		_textPosList = getTextPos();
		
		var bfx:BitmapEffectLayer = new BitmapEffectLayer(viewport, DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0, "clear_pre", false, false);
		bfx.drawCommand.blendMode = BlendMode.ADD;
		bfx.addEffect(new BitmapLayerEffect(new BlurFilter(8, 8, BitmapFilterQuality.MEDIUM), false));
		viewport.containerSprite.addLayer(bfx);
		
		var pixels:Pixels  = new Pixels(bfx);
		_pixelList = [];
		_root.addChild(pixels);
		for (var i:int = 0, n:int = _textPosList.length; i < n; ++i) 
		{
			var pxd:PxData = _textPosList[i];
			var px:Pixel3D = new Pixel3D(pxd.color, pxd.x, pxd.y, 0);
			pixels.addPixel3D(px);
			_pixelList[i] = px;
		}
		
		bfx.addDisplayObject3D(pixels);
	}
	
	private function getTextPos():Array
	{
		var tf:TextField = new TextField();
		tf.defaultTextFormat = new TextFormat("_sans", _size, 0xFFFFFF, true);
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = text;
		
		var bmd:BitmapData = new BitmapData(tf.textWidth + 2, tf.textHeight, true, 0x00000000);
		bmd.draw(tf);
		
		var result:Array = [];
		for (var i:int = 0, n:int = bmd.width; i < n; ++i) 
		{
			for (var j:int = 0, m:int = bmd.height; j < m; ++j) 
			{
				var color:uint = bmd.getPixel(i, j);
				if (color)
				{
					switch (i % 3) 
					{
						case 0:
							color = 0xFFFFFFFF;
							//color = 0xFFEF8080;
							break;
						case 1:
							color = 0xFF444444;
							//color = 0xFF80EF80;
							break;
						case 2:
							color = 0xFF8080EF;
							//color = 0xFF8080EF;
							break;
					}
					result.push(new PxData(i  - n * 0.5, j - m * 0.5, color));
				}
			}
		}
		return result;
	}
	
	public function explode():void 
	{
		if (_defaultForm)
			explosion();
		else
			defaultPosition();
	}
	
	private function explosion():void
	{
		_defaultForm = false;
		if (_pixelList)
		{
			for (var i:int = 0, n:int = _pixelList.length; i < n; ++i) 
			{
				var px:Pixel3D = _pixelList[i];
				TweenMax.to(px, 1.5, { x: Math.random() * DISPLAY_WIDTH - middle, y: Math.random() * DISPLAY_WIDTH - middle, z: Math.random() * DISPLAY_WIDTH - middle, ease: Quintic.easeOut, delay: 0.0001 * i, overwrite: true});
			}
			
		}
	}
	
	private function defaultPosition():void
	{
		_defaultForm = true;
		if (_pixelList)
		{
			for (var i:int = 0, n:int = _pixelList.length; i < n; ++i) 
			{
				var px:Pixel3D = _pixelList[i];
				var pxd:PxData = _textPosList[i];
				TweenMax.to(px, 0.7, { x: pxd.x, y: pxd.y, z: 0, ease: Quintic.easeOut, delay: 0.0005 * i, overwrite: true });
			}
			
		}
	}
	public function get my():Number
	{
		return _my;
	}
	
	public function set my(value:Number):void
	{
		_my = value;
	}
	
	public function get mx():Number
	{
		return _mx;
	}
	
	public function set mx(value:Number):void
	{
		_mx = value;
	}
}
	

class PxData
{
	public var x:Number;
	public var y:Number;
	public var color:uint;
	function PxData(x:Number, y:Number, color:uint)
	{
		this.x = x;
		this.y = y;
		this.color = color;
	}
	
}
