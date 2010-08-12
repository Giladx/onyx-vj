// translated and modified this from Don Relyea's Open Frameworks Hair Particle Drawing Project:
// http://www.donrelyea.com/hair_particle_drawing_OF.htm
// www.donrelyea.com
// July 22 2008

package com.donrelyea
{
	
	// Import Adobe classes.
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
		
	/**
	 * hair particle drawing class by don relyea ported to AS3 by Lucas Swick
	 * www.donrelyea.com
	 * July 22 2008
	 * @class			HairParticle
	 * @author			
	 * @date			25.11.2008
	 * @version			0.1
	 **/
	public class HairParticle extends EventDispatcher {
		
		public static const CLASS_NAME:String = "HairParticle";
		
		
		private var _active:Boolean;
		private var _angle:Number;
		private var _speed:Number;
		private var _scale:Number;
		private var _decay:Number;
		private var _alpha:Number;
		private var _x:Number;
		private var _y:Number;
		private var _color:Number;
		private var _delta:Number;
		private var _kink:Number;
		
		private var _bmRect:Rectangle;
		private static var _circle:Sprite;
		private var _mtx:Matrix;
		private var _ct:ColorTransform;
		
		/**
		 * Constructor.
		 * @param		verbosity	int. Optional, defaults to 0. The verbosity level.
		 **/
		public function HairParticle(circle:Sprite) {
			_circle = circle;
			init();
			
		}
		
		// INITIALIZATION ============================================================================================================
		private function init():void 
		{
			_decay = 1;
			_angle = Math.random() * 360;
			_speed = Math.random() * 1;
			_delta = -10 + Math.random() * 20;
			
			_bmRect = new Rectangle();
			
			_mtx = new Matrix();
			_ct = new ColorTransform();
		}
		
		// ACTIONS ===================================================================================================================
		/**
		 * draw.
		 * @description	
		 **/
		public function draw(canvas:BitmapData) : void {
			
			//if im active lets draw
			if (_active) {
				
				getAngle();  //decide which way to grow
				goForward(); //grow 
				
				_scale *= _decay; //Decay the scale
				
				if (_scale < -10) {
					_scale = -10;
				} else if (_scale > 10){
					_scale = 10;
				}
				
				if (Math.abs(_scale) < 1) _scale = 1;
				
				_alpha *= _decay;
				
				_mtx.identity();
				_mtx.scale(_scale, _scale)
				_mtx.translate(_x, _y);
				
				_ct.color = _color;
				_ct.alphaMultiplier = _alpha;
				
				canvas.draw( _circle, _mtx, _ct );
				
				//reset if particle gets so transparent as to not be visible
				if (_alpha < .1){ 
					reset(); //reset particle
				}
			}
		}
		
		/**
		 * reset.
		 * @description	
		 **/
		private function reset() : void {
			_active = false;
		}
		
		/**
		 * getAngle.
		 * @description	
		 **/
		private function getAngle() : void {
			_x += Math.cos(_angle) * _speed;
			_y += Math.sin(_angle) * _speed;
		}
		
		/**
		 * goForward.
		 * @description	
		 **/
		private function goForward() : void {
			//which way am I going during my brief existence
			_delta = _delta - _kink + Math.random() * (_kink * 2);
			
			var aDelta:Number = _delta / 57.2958;
			
			_angle = _angle + aDelta; //increment the angle
			
			//keep the angle between 0 and 360
			_angle = Math.max(0, Math.min(_angle, 360));
			
		}
		
		/**
		 * drawCircle.
		 * @param			target:BitmapData
		 * @param			cX:Number
		 * @param			cY:Number
		 * @param			r:Number
		 * @param			color:Number
		 * @description	
		 **/
		private function drawCircle(target:BitmapData, cX:Number, cY:Number, r:Number, color:uint) : void {
			var x:Number = 0;
			var y:Number = 0;
			var r2:Number = r*r;
			
			for (x=1; x<r; x++) {
				y = Math.ceil(Math.sqrt(r2 - x*x));
				_bmRect.topLeft = new Point(cX-x, cY-y);
				_bmRect.size = new Point(2*x, 2*y);
				target.fillRect(_bmRect, color);
				
			}
		}
		
		// SETTERS AND GETTERS =======================================================================================================
		
		public function get active() : Boolean { 
			return _active; 
		}
		
		public function activate( blend:Number, size:Number, x:Number, y:Number, color:uint, angle:Number ) : void {
			
			//----this code initializes the particle------//
			_active = true; //its alive!
			_kink = Math.random() * 3;
			_x = x; 
			_y = y; 
			// _angle = Math.random() * 360 //grow hair in random direction
			_angle = angle;
			_speed = 1;//Math.random() * 3; //move one pixel a frame
			
			if (blend > 210){
				//_color=0; //black hair, _color=255; for white hair
				// _color=255-blend;  //greyscale hair
				_scale=size*3.50;  //root of hair is thicker, drypoint print effect
				_decay=.98; // how fast the particle decays
				
			} else if(blend > 100 && blend < 210){
				//_color=(255-blend)/2; //greyscale hair tweaked darker
				_scale=size*1.25;
				_decay=.95;
				
			} else if(blend > 65 && blend < 100){
				//_color=(255-blend)/3; //greyscale hair tweaked darker
				_scale=size*0.45;
				_decay=.9;
				
			} else if(blend > 35 && blend < 65){
				//_color=(255-blend)/4; //greyscale hair tweaked darker
				_scale=size*0.35;
				_decay=.88;
				
			} else if(blend > 2 && blend < 35){
				//_color=(255-blend)/5; //greyscale hair tweaked darker
				_scale=size*0.35;
				_decay=.88;
				
			} else {
				//_color=0;
				_scale=0.15;
				_decay=0.8;
				
			}
			
			_color = color;
			_alpha = size;
			_delta = -10 + Math.random() * 20; //initial hair kink
			_angle = _color % 360;
			
			if (color < 0x333333) {
				_angle = Math.PI / 2;
				_scale = 3;
				_decay = Math.random() * .95
				_delta = 0;
				_kink = 0;
			}		
		}
	}
}
