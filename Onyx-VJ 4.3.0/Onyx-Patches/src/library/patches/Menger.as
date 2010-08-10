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
 * To recompile the cpp file, follow instructions on:
 * http://insideria.com/2009/04/setting-up-adobe-alchemy.html
 * 
 * ray tracing a menger sponge
 * author 	   : frank reitberger
 * contact    : frank@prinzipiell.com
 * blog 	   : http://www.prinzipiell.com
 * copyright 2010
 * 
 * Adapted by Bruce LANE (http://www.batchass.fr)
 */

package library.patches
{
	
	import cmodule.menger.CLibInit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.PixelSnapping;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	// --------------------------------------------------------------------------------------------------
	
	///////////////////////////////////
	// class
	///////////////////////////////////
	
	public final class Menger extends Patch {
		
		protected var bmd 			:BitmapData;
		private var fs				:int;
		private var ms				:int;		

		protected var alchemyMemory :ByteArray;

		protected var rayLib		:Object;
		private var mode            :int       = 1;
		private var size            :int       = 230;
		private var mtr             :Matrix    = new Matrix( 1, 0, 0, -1 );
		private var rect            :Rectangle = new Rectangle( 0, 0, size, size );
		private var upRect          :Rectangle = new Rectangle( 0, 0, 480, 480 );
        private var time			:Number    = 0;
		private var prevTime		:int       = 0;
		private var acc				:Number    = 0.1;
		
        private var sn				:Number;
        private var cn				:Number; 		
		private var sin             :Function  = Math.sin;
		private var cos             :Function  = Math.cos;
		
		private var mult            :String    = BlendMode.MULTIPLY
		private var over            :String    = BlendMode.OVERLAY;		
		private var add             :String    = BlendMode.ADD;	
		private var drk             :String    = BlendMode.DARKEN;	
		private var hlt             :String    = BlendMode.HARDLIGHT;	
		private var ltn             :String    = BlendMode.LIGHTEN;	
		
		
		// --------------------------------------------------------------------------------------------------
		
		///////////////////////////////////
		// class constructor
		///////////////////////////////////	
		
		public function Menger() {
			
			bmd 			  = new BitmapData( size, size, false, 0xFF0000 );
			var bitmap:Bitmap = new Bitmap( bmd, PixelSnapping.AUTO, true );
			bitmap.scaleX = bitmap.scaleY = 2.2;
			
			addChild( bitmap );
			
			///////////////////////////////////
			// setup: raytracer
			///////////////////////////////////	
			
			setupRaytracer();			
		}
		
		///////////////////////////////////
		// setup: raytracer
		///////////////////////////////////	
		
		protected function setupRaytracer():void {
			
			var loader:CLibInit = new CLibInit();
			rayLib = loader.init();
			
			var ns :Namespace = new Namespace( "cmodule.menger");
			alchemyMemory = (ns::gstate).ds;

			var memPointer :int    = rayLib.allocMem( size, size );
			alchemyMemory.position = memPointer;
			
		}

		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {
			if (bmd)
			{
				var tStamp:Number = time * 0.1;
				
	            sn    = sin(tStamp);
	            cn    = cos(tStamp);
	            time  = time + 0.01666667 * (getTimer() - prevTime) / ( 30.30303030303030303030303030303 );
	
	            prevTime = getTimer();
				
				var ex:Number = 0.5 + sin(time * 0.5)  * acc;
				var ey:Number = 0.5 + cos(time * 0.47) * acc;
				var ez:Number = -time * 0.3 + sin(time * 0.3 - 0.01);
				
				
				bmd.lock();
				
				alchemyMemory.position = rayLib.shootRays( sn, cn, time, prevTime, ex, ey, ez );
				bmd.setPixels( rect, alchemyMemory );
				bmd.draw( bmd, null, null, null );
				bmd.draw( bmd, null, null, hlt );
				bmd.draw( bmd, null, null, ltn );
				
				bmd.unlock( rect );
				
				info.source.draw(bmd, info.matrix, null, null, null, true);
			}
			
		}
		
	}
}
