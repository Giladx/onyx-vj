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
	
	public class RuttEtraIzer extends Patch
	{
		private var PV:PVRuttEtraIzer;
		private var _depth:Number = .0005;
		private var _scale:Number = 6;
		private var sprite:Sprite;
		private var _scanStep:int = 2;
		private var _size:int = 4;
		private var _soundMultiplier:int = 15;
		private var _rx:int = 22;
		private var _ry:int = 150;
		private var _rz:int = 150;

		public function RuttEtraIzer() 
		{
			Console.output('RuttEtraIzer v 0.0.8');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			PV = new PVRuttEtraIzer();
			parameters.addParameters(
				new ParameterNumber( 'scale', 'scale:', 1, 30, _scale ),
				new ParameterInteger( 'size', 'size:', 1, 10, _size ),
				new ParameterInteger( 'scanStep', 'scanStep:', 1, 10, _scanStep ),
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
			PV.rx = _rx;
			PV.ry = _ry;
			PV.rz = _rz;
		}	

		public function get soundMultiplier():int
		{
			return _soundMultiplier;
		}

		public function set soundMultiplier(value:int):void
		{
			PV.soundMultiplier = _soundMultiplier = value;
		}

		public function draw():void
		{
			PV.drawLines();
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
		
		public function get size():int
		{
			return _size;
		}
		
		public function set size(value:int):void
		{
			PV.size = _size = value;
		}
		
		public function get scanStep():int
		{
			return _scanStep;
		}
		
		public function set scanStep(value:int):void
		{
			PV.scanStep = _scanStep = value;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			PV.scale = _scale = value;
		}
		
		public function get depth():Number
		{
			return _depth;
		}
		
		public function set depth(value:Number):void
		{
			PV.depth = _depth = value;		
		}
		
		override public function render(info:RenderInfo):void 
		{			
			info.render( sprite );		
		}
	}
}

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import onyx.core.*;
import onyx.plugin.*;

import org.papervision3d.core.geom.Lines3D;
import org.papervision3d.core.geom.renderables.Line3D;
import org.papervision3d.core.geom.renderables.Vertex3D;
import org.papervision3d.lights.PointLight3D;
import org.papervision3d.materials.BitmapMaterial;
import org.papervision3d.materials.shaders.GouraudShader;
import org.papervision3d.materials.shaders.ShadedMaterial;
import org.papervision3d.materials.shaders.Shader;
import org.papervision3d.materials.special.LineMaterial;
import org.papervision3d.objects.primitives.Sphere;
import org.papervision3d.view.BasicView;

class PVRuttEtraIzer extends BasicView
{
	private var light : PointLight3D;
	private var shader : Shader; 
	private var bmpd:BitmapData;
	private var stageSize:Number = 0.8;
	private var _scale:Number = 5.0;
	private var _scanStep:int = 1;
	private var _size:int = 2;
	private var lineThickness:Number = 2.0;
	private var opacity:Number = 1.0;
	private var _depth:Number = .02;
	private var autoRotate:Boolean = false;
	private var _soundMultiplier:int = 15;
	private var _imageWidth:int = 50;
	private var _imageHeight:int = 50;
	private var line:Line3D;
	private var startVertex3D:Vertex3D;
	private var endVertex3D:Vertex3D;
	private var lines:Lines3D;
	private var yaw:Number = 0;
	private var pitch:Number = 0;
	private var roll:Number = 0;
	private var xrot:Number = 0;	
	private var yrot:Number = 0;
	private var timer:Timer;
	private var analysis:Array;
	private var al:int;
	private var fct:int;
	private var yr:int = 0;
	private var _rx:int = 270;
	private var _ry:int = 270;
	private var _rz:int = 270;
	private var i:int;
	private var j:int;

	public function PVRuttEtraIzer() 
	{
		timer = new Timer(1);
		timer.addEventListener(TimerEvent.TIMER, loop);
		light = new PointLight3D();
		light.x = 300; 
		light.y = 300; 
		
		shader = new GouraudShader(light, 0xFFFFFF,0x404040)
		
		bmpd = new AssetForRuttEtraIzer();
		_imageWidth = bmpd.width;
		_imageHeight = bmpd.height;
		//addChild(new Bitmap(bmpd, 'auto', true));
		lines = new Lines3D();
		
		drawLines();
		camera.fov = 30;
		//lines.pitch(180);
		scene.addChild( lines );
		analysis = SpectrumAnalyzer.getSpectrum(true);
		al = analysis.length;
		addEventListener( Event.ENTER_FRAME, enterFrame );
	}	

	private function loop(evt:TimerEvent):void 
	{
		
		for(var xr:int = 0; xr < _imageWidth ; xr++)// xr+= scanStep) 
		{
			var color:Number = bmpd.getPixel(xr, yr);
			var red:int = (color >> 16 & 0xFF);					
			var green:int = (color >> 8 & 0xFF);
			var blue:int = (color & 0xFF);
			
			var lineMaterial:LineMaterial = new LineMaterial(color);
			var brightness:Number = getBrightness(red,green,blue);
			
			startVertex3D = new Vertex3D((xr + scanStep -_imageWidth/2)*scale, (yr - _imageHeight/2)*scale, -brightness * depth + depth/2);
			endVertex3D = new Vertex3D((xr -_imageWidth/2)*scale, (yr - _imageHeight/2)*scale, -brightness * depth + depth/2);
			line = new Line3D(lines, lineMaterial, size, startVertex3D, endVertex3D);
			//add a line
			lines.addLine(line);
			
		}
		yr += scanStep;
		//Console.output("lines:" + lines.lines.length + " yr:" + yr + " xr:" + xr);
		if ( yr >= _imageHeight )
		{
			timer.stop();
		}
	}	
	public function drawLines():void
	{
		timer.stop();
		lines.removeAllLines();
		yr = 0;
		timer.start();
		//Console.output("timer started");
	}
	//return pixel brightness between 0 and 1 based on human perceptual bias
	public function get depth():Number
	{
		return _depth;
	}
	
	public function set depth(value:Number):void
	{
		_depth = value;
		drawLines();
	}
	
	private function getBrightness(r:int,g:int,b:int):Number 
	{
		return ( 0.34 * r + 0.5 * g + 0.16 * b );
	}
	public function enterFrame( e:Event ):void
	{
		analysis = SpectrumAnalyzer.getSpectrum(true);
		i = 0;
		j = 0;
		var nbLinesHoriz:int = _imageWidth / scanStep;
		var factor:int = nbLinesHoriz / (al + 1);
		
		var count:Number = SpectrumAnalyzer.leftPeak + SpectrumAnalyzer.rightPeak;
		//var fct:int = analysis.length / (lines.lines.length + 1);
		for each ( var line:Line3D in lines.lines) 
		{
			var a:Number = analysis[j];
			if (count<0.1) 
			{
				count = Math.random();
				a = Math.random();
			}
			
			line.v0.z = a * count * _soundMultiplier;
			line.v1.z = a * count * _soundMultiplier;
			
			/*if ( i++ > factor ) 
			{
				i = 0;
				if ( j < analysis.length - 1 ) j++ else j = 1;
			}*/
			
			if ( j < al - 1 ) j++ else j = 0;
			if ( j > _imageWidth - 1 ) j = 0;			
		}
		lines.rotationX = rx;
		lines.rotationY = ry;
		lines.rotationZ = rz;
		singleRender();
	}
	public function get rz():int
	{
		return _rz;
	}
	
	public function set rz(value:int):void
	{
		_rz = value;
		roll = _rz;
	}
	
	public function get ry():int
	{
		return _ry;
	}
	
	public function set ry(value:int):void
	{
		_ry = value;
	}
	
	public function get rx():int
	{
		return _rx;
	}	
	public function set rx(value:int):void
	{
		_rx = value;
	}
	
	public function get scanStep():int
	{
		return _scanStep;
	}
	
	public function set scanStep(value:int):void
	{
		_scanStep = value;
	}
	
	public function get size():int
	{
		return _size;
	}
	
	public function set size(value:int):void
	{
		_size = value;
	}
	public function get soundMultiplier():int
	{
		return _soundMultiplier;
	}
	
	public function set soundMultiplier(value:int):void
	{
		_soundMultiplier = value;
	}	
	public function get scale():Number
	{
		return _scale;
	}
	
	public function set scale(value:Number):void
	{
		_scale = value;
		drawLines();
	}
}
