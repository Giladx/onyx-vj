/**
 * Copyright onedayitwillmake ( http://wonderfl.net/user/onedayitwillmake )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/gyLW
 */

// forked from onedayitwillmake's forked from: Lets make something pretty using papervsion partcles, in steps!
package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class CircleParticle extends Patch
	{
		private var cp:CircleParts;
		private var sprite:Sprite;
		private var _mousex:int = 320;
		private var _mousey:int = 240;
		public function CircleParticle() 
		{
			Console.output('CircleParticles');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			cp = new CircleParts();
			parameters.addParameters(
				new ParameterInteger( 'mousex', 'mousex:', 1, DISPLAY_WIDTH, _mousex ),
				new ParameterInteger( 'mousey', 'mousey:', 1, DISPLAY_HEIGHT, _mousey )
			);

			sprite = new Sprite();
			addChild(sprite);
			sprite.addChild(cp);
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}	
		
		public function get mousey():int
		{
			return _mousey;
		}

		public function set mousey(value:int):void
		{
			cp.my = _mousey = value;
		}

		public function get mousex():int
		{
			return _mousex;
		}

		public function set mousex(value:int):void
		{
			cp.mx = _mousex = value;
		}

		private function mouseDown(event:MouseEvent):void 
		{
			mousex = event.localX; 
			mousey = event.localY; 
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );		
		}
	}
}	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
	import frocessing.color.ColorHSV;
	
	import gs.TweenMax;
	import gs.easing.Sine;
	
	import onyx.plugin.DISPLAY_HEIGHT;
	import onyx.plugin.DISPLAY_WIDTH;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.cameras.SpringCamera3D;
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Particle;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.math.Sphere3D;
	import org.papervision3d.core.render.data.RenderHitData;
	import org.papervision3d.core.utils.Mouse3D;
	import org.papervision3d.materials.special.BitmapParticleMaterial;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	
	/**
	 * Papervsion Particles step 1
	 * @author Mario Gonzalez
	 */
	class CircleParts extends BasicView
	{
		private var _mouse3D			:Mouse3D;
		private var _particles			:Particles = new Particles();
		private var _currentParticle	:Particle;
		
		private var _lines				:Lines3D;
		private var _currentLine		:Line3D;
		private var _lineMaterial		:LineMaterial;
		
		private var PARTICLE_COUNT		:int = 180;
		
		private var _extraRotation		:Number = 0;
		private var _rotationSpeed		:Number = 0.001;
		private var _springCamera		:SpringCamera3D;
		
		private var _currentParticleInArray		:int = 0;
		private var _camTarget					:DisplayObject3D = new DisplayObject3D();
		private var _timer						:Timer;
		
		
		private var colorHSV					:ColorHSV = new ColorHSV(360, 1, 1);
		private var data						:BitmapData;
		
		private static const XZPLANE			:Number3D = new Number3D(0, 1, 0);
		private var plane3D						:Plane3D= new Plane3D(XZPLANE, Number3D.ZERO); 
		
		private var mouseIsDown					:Boolean
		private var sphere						:Sphere3D;
		private var shape						:Shape;
		private var _mx:Number = 20;
		private var _my:Number = 40;
		
		public function CircleParts() 
		{
			super(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, false, CameraType.TARGET);
			
			// For black background in screenshot
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0);
			s.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			s.graphics.endFill();
			s.cacheAsBitmap = true;
			addChildAt(s, 0);
			
			// This is the basis for our particles
			// Make the particle example
			shape = new Shape();
			var g:Graphics = shape.graphics; 
			g.beginFill(0xffffff, 0.5);
			g.drawCircle(16, 16, 16);
			g.beginFill(0xffffff);
			g.drawCircle(16, 16, 8);
			g.endFill();			
			
			camera.y = 700
			createParticleRing();

			startRendering();
		}
		
		public function get my():Number
		{
			return _my;
		}

		public function set my(value:Number):void
		{
			_my = value/2;
		}

		public function get mx():Number
		{
			return _mx;
		}

		public function set mx(value:Number):void
		{
			_mx = value/2;
		}

		/**
		 * Toggle the mouseIsDown property. Not used anymore
		 * @param	e
		 */
		private function onMouseUp(e:MouseEvent):void 
		{
			mouseIsDown = false;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			mouseIsDown = true;
			explode();
		}
		
		/**
		 * Apply explosive force to all the particles
		 */
		private function explode():void 
		{
			for (var i:int = 0; i < PARTICLE_COUNT; i++)
			{
				_currentParticle = _particles.particles[i] as Particle;
				var force:Number = 300;
				ParticlePhysicsInfo(_currentParticle._userData).addForce(Utils.randRange( -force, force), Utils.randRange( -force, force), Utils.randRange( -force, force));
			}
		}
		
		
		/**
		 * Make the camera focus on a new particle. (Not used anymore)
		 * @param	e
		 */
		private function changeTarget(e:TimerEvent):void 
		{
			var p:Particle = Utils.randInArray(_particles.particles) as Particle
			TweenMax.to(_camTarget, 1, { x: p.x, y: p, z: p.z, ease: Sine.easeInOut } );
		}
		
		private function createParticleRing():void
		{
			data = new BitmapData(shape.width, shape.height, true, 0xFFFFFF);
			data.draw(shape);
			
			var material:BitmapParticleMaterial = new BitmapParticleMaterial(data, 1);
			var image:BitmapData = new BitmapData(data.width, data.height, true);
			
			//Createa a few particles
			for (var i:int = 0; i < PARTICLE_COUNT; i++)
			{
				colorHSV.h = (i / PARTICLE_COUNT) * 360;
				//trace(colorHSV.h);
				colorHSV.s = Math.random() * 0.6 + 0.4;
				
				// Change the color of our particle
				image = data.clone();
				image.applyFilter(image, image.rect, image.rect.topLeft, new ColorMatrixFilter(ColorHelper.colorize(colorHSV.value)))
				material = new BitmapParticleMaterial(image)
				
				// Create the particle using the new colored material
				_currentParticle = new Particle(material, 1);
				_currentParticle._userData = new ParticlePhysicsInfo(_currentParticle);
				
				ParticlePhysicsInfo(_currentParticle._userData).setColor(colorHSV.clone());
				_particles.addParticle(_currentParticle);
			}
			
			
			scene.addChild(_particles);
		}
		
		/**
		 * Move the particles around and render
		 * @param	e
		 */
		override protected function onRenderTick(e:Event = null):void
		{
			//var ray:Number3D = camera.unproject(viewport.containerSprite.mouseX, viewport.containerSprite.mouseY);
			var ray:Number3D = camera.unproject(mx, my);
			ray = Number3D.add(ray, camera.position);
			var cameraVertex3D:Vertex3D = new Vertex3D(camera.x, camera.y, camera.z);
			var rayVertex3D:Vertex3D = new Vertex3D(ray.x, ray.y, ray.z);
			var intersectPoint:Vertex3D = plane3D.getIntersectionLine(cameraVertex3D, rayVertex3D);
			
			for (var i:int = 0; i < PARTICLE_COUNT; i++)
			{
				var theta:Number = (i / PARTICLE_COUNT) * Math.PI * 2 //+ _extraRotation;
				
				_currentParticle = _particles.particles[i] as Particle;
				var physInfo:ParticlePhysicsInfo = ParticlePhysicsInfo(_currentParticle._userData);
				physInfo.targetX = Math.cos(theta) * 100 + intersectPoint.x;
				physInfo.targetY = Math.sin(theta) * 100 + intersectPoint.y;
				
				if(intersectPoint.z < 2100) physInfo.targetZ = Math.sin(theta) * 50 + intersectPoint.z; //Math.sin(theta) * 400 + intersectPoint.z
				physInfo.update();
			}
			
			super.onRenderTick(e);
		}
		
	}


import org.papervision3d.core.data.UserData;
import org.papervision3d.core.geom.renderables.Particle;
import org.papervision3d.core.geom.Lines3D;
import org.papervision3d.core.geom.renderables.Line3D;
import org.papervision3d.materials.special.LineMaterial;
import org.papervision3d.core.geom.renderables.Vertex3D;
import frocessing.color.ColorHSV;

internal class ParticlePhysicsInfo extends UserData
{
	public var _particle:Particle;
	
	public var _vx:Number = 0;
	public var _vy:Number = 0;
	public var _vz:Number = 0;
	
	public var _ax:Number = 0;
	public var _ay:Number = 0;
	public var _az:Number = 0;
	
	public var _ix:Number;
	public var _iy:Number;
	public var _iz:Number;
	
	public var targetX:Number = 0;
	public var targetY:Number = 0;
	public var targetZ:Number = 0;
	//
	public var _lines3d		:Lines3D;
	public var _positions	:Vector.<Vertex3D> = new Vector.<Vertex3D>(0, false);
	
	public var ACC_PARAM:Number = 0.005 + Math.random() * 0.04;
	public var VELOCITY_PARAM:Number = 0.6 + Math.random() * 0.27
	
	public var _color:ColorHSV;
	private var _mat:LineMaterial;
	private var speed:Number = 0.1 + Math.random() * 0.05
	
	public function ParticlePhysicsInfo(particle:Particle, vx:Number = 0, vy:Number = 0, vz:Number = 0, ax:Number = 0, ay:Number = 0, az:Number = 0):void
	{
		_particle = particle;
		
		_ix = _particle.x
		_iy = _particle.y
		_iz = _particle.z
		
		
		_vx = vx;
		_vy = vy;
		_vz = vz;
		
		_ax = ax;
		_ay = ay;
		_az = az;
	}
	
	public function setColor(c:ColorHSV):void
	{
		_color = c;
		_mat = new LineMaterial(_color.value, 1);
	}
	public function update():void
	{
		
		_ix +=  (targetX - _particle.x) * speed;
		_iy +=  (targetY - _particle.y) * speed;
		_iz +=  (targetZ - _particle.z) * speed;
		
		_ax += (_ix - _particle.x) * ACC_PARAM;
		_ay += (_iy - _particle.y) * ACC_PARAM;
		_az += (_iz - _particle.z) * ACC_PARAM;
		
		_vx = (_vx + _ax) * VELOCITY_PARAM;
		_vy = (_vy + _ay) * VELOCITY_PARAM;
		_vz = (_vz + _az) * VELOCITY_PARAM;
		
		var min:Number = -400;
		var max:Number = 400;
		
		_vx = Math.max(min, Math.min(max, _vx));
		_vy = Math.max(min, Math.min(max, _vy));
		_vz = Math.max(min, Math.min(max, _vz));
		
		_particle.x += _vx;
		_particle.y += _vy;
		_particle.z += _vz;
		
		_ax = _ay = _az = 0;
		// remove one element
	}
	
	public function addForce(fx:Number, fy:Number, fz:Number):void
	{
		_ax += fx;
		_ay += fy;
		_az += fz;
	}
	
}

internal class Utils
{
	/**
	 * Return a random element inside an array
	 * @param	array, The array you want to get a random element from
	 * @return	*, An object in that array
	 */
	public static function randInArray(array:*):*
	{
		if (array) return array[randRange(0, array.length - 1)];
	}
	
	/**
	 * Random interger within range.
	 * @param	min
	 * @param	max
	 * @return
	 */
	public static function randRange(min:int, max:int):int
	{
		var fmin:Number = min - .4999;
		var fmax:Number = max + .4999;
		return int(Math.round(fmin + (fmax - fmin) * Math.random()));
	}
}


/**
 * Modify the color of an asset without destroying color contrast / shading in the asset.
 * Uses hue/saturation/brightness/contrast to modify a color keeping contrast between colors in the asset intact
 * @version 1.3
 */
internal class ColorHelper
{
	/**
	 * Colorize an asset based on an RGB value
	 * @param	rgb		Hex color value
	 * @param	amount	How much of the original color to keep. [0.0-1.0], 1.0 means none. Range can exceed 1.0 for experimental results
	 */
	public static function colorize(rgb:Number, amount:Number=1):Array
	{
		var r:Number;
		var g:Number;
		var b:Number;
		var inv_amount:Number;
		
		// Found after some googling - @ http://www.faqs.org/faqs/graphics/colorspace-faq/ (ctrl+f luminance)
		var LUMA_R:Number = 0.4086;
		var LUMA_G:Number = 0.7094;
		var LUMA_B:Number = 0.0920;
		
		r = (((rgb >> 16) & 0xFF) / 0xFF);
		g = (((rgb >> 8) & 0xFF) / 0xFF);
		b = ((rgb & 0xFF) / 0xFF);
		
		inv_amount = (1 - amount);
		
		return concat([(inv_amount + ((amount * r) * LUMA_R)), ((amount * r) * LUMA_G), ((amount * r) * LUMA_B), 0, 0,
			((amount * g) * LUMA_R), (inv_amount + ((amount * g) * LUMA_G)), ((amount * g) * LUMA_B), 0, 0, 
			((amount * b) * LUMA_R), ((amount * b) * LUMA_G), (inv_amount + ((amount * b) * LUMA_B)), 0, 0, 
			0, 0, 0, 1, 0]);
	}
	
	/**
	 * Concat two matrices
	 * Could be used to mix colors, but for now it only concacts with an identy matrix
	 * @param	mat	Matrix we want to concact
	 */
	public static function concat( mat:Array ):Array
	{
		// Identity matrix
		var matrix:Array = [1, 0, 0, 0, 0, // RED
			0, 1, 0, 0, 0, // GREEN
			0, 0, 1, 0, 0, // BLUE
			0, 0, 0, 1, 0]; // ALPHA
		
		var temp:Array = new Array();
		
		var i:int = 0;
		var x:int, y:int
		
		
		// Loop through the matrice
		for (y = 0; y < 4; y++ )
		{
			
			for (x = 0; x < 5; x++ )
			{
				temp[ int( i + x) ] =  Number(mat[i])      * Number(matrix[x]) + 
					Number(mat[int(i + 1)]) * Number(matrix[int(x +  5)]) + 
					Number(mat[int(i + 2)]) * Number(matrix[int(x + 10)]) + 
					Number(mat[int(i + 3)]) * Number(matrix[int(x + 15)]) +
					(x == 4 ? Number(mat[int(i + 4)]) : 0);
			}
			i+=5;
		}
		
		return temp;
	}
}
