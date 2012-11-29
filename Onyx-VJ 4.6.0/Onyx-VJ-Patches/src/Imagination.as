/**
 * Copyright (c) 2003-2012, www.onyx-vj.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * -  Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * -  Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors
 *    may be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Based on Imagination code by Paul Neave (http://www.neave.com)
 * Adapted for Onyx-VJ by Bruce LANE (http://www.batchass.fr)
 */
package 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.Console;
	import onyx.core.RenderInfo;
	import onyx.plugin.*;
	
	import services.remote.DLCEvent;
	import services.remote.DirectLanConnection;
	
	//[SWF(width='320', height='240', frameRate='24')]
	public class Imagination extends Patch
	{
		// Main constants
		private const RED_STEP:Number = 0.02;
		private const GREEN_STEP:Number = 0.015;
		private const BLUE_STEP:Number = 0.025;
		private const MAX_LENGTH:int = 80;
		private const SPREAD_MIN:int = 1;
		private const SPREAD_MAX:int = 40;
		
		// Main variables
		private var list:Array;
		private var px:Number;
		private var py:Number;
		private var size:Number;
		private var spread:int;
		private var paused:Boolean;
		private var red:Number;
		private var green:Number;
		private var blue:Number;
		private var lines:Shape;                
		private var bmp:Bitmap;
		private var blackBitmap:BitmapData;
		private var m:Matrix;
		private var p:Point;
		private var blur:BlurFilter;
		private var _sourceBD:BitmapData = createDefaultBitmap();
		private var sprite:Sprite;
		private var dlc:DirectLanConnection = DirectLanConnection.getInstance();
		
		public function Imagination()
		{
			Console.output('Imagination 4.6.1');
			Console.output('Credits to Paul NEAVE (http://www.neave.com)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			
			sprite = new Sprite();
			
			initLines();
			initBitmap();
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			dlc.addEventListener( DLCEvent.ON_RECEIVED, DataReceived );
			dlc.connect();
		}
		protected function DataReceived(dataReceived:Object):void
		{
			// received
			switch ( dataReceived.params.type.toString() ) 
			{ 
				case "xyp":
					var xyp:uint = dataReceived.params.value;
					px = xyp / 1048576;
					py = (xyp % 1048576) / 1024;
					size = (xyp % 1048576) % 1024;
					break;
				case "x-y":
					var xy:uint = dataReceived.params.value;
					px = xy / 1048576;
					py = xy % 1048576;
				default: 
					break;
			}
		}	
		/**
		 *
		 */
		override public function render(info:RenderInfo):void {
			if (paused) return;
			var source:BitmapData = info.source;
			
			// Line movement is set by how much the mouse has moved since its previous position and a random value
			var dx:Number = (px - px + Math.random() * 4 - 2) / 2;
			var dy:Number = (py - py + Math.random() * 4 - 2) / 2;
			
			// Limit the amount of movement
			if (dx < -spread) dx = -spread;
			if (dx > spread) dx = spread;
			if (dy < -spread) dy = -spread;
			if (dy > spread) dy = spread;
			
			// Store the mouse position
			//px = sprite.mouseX;
			//py = sprite.mouseY;
			
			// Line thickness varies up and down with sine
			var s:Number = Math.sin(size += 0.2) * 8 + 4;
			
			// Put the red, green and blue values together into a single hexadecimal value
			var c:uint = (Math.sin(red += RED_STEP) * 128 + 127) << 16
				| (Math.sin(green += GREEN_STEP) * 128 + 127) << 8
				| (Math.sin(blue += BLUE_STEP) * 128 + 127);
			
			// Create a new point on the line
			list.push(new ImaginationPoint(px, py, dx, dy, s, c));
			
			// Draw!
			drawLines();
			drawBitmap();
			info.render( sprite );
		}
		
		/**
		 * Sets up line variables
		 */
		private function initLines():void
		{
			list = new Array();
			px = py = size = 0;
			spread = SPREAD_MAX;
			paused = false;
			
			// Start using red
			red = 0;
			green = 255;
			blue = 255;
			
			// The main lines shape
			lines = new Shape();
		}
		
		/**
		 * Sets up the main bitmap
		 */
		private function initBitmap():void
		{
			// Stage sizes
			var sw2:int = Math.ceil(DISPLAY_WIDTH / 2);
			var sh2:int = Math.ceil(DISPLAY_HEIGHT / 2);
			
			// Create the main bitmap to draw into (and half the size to run faster)
			bmp = new Bitmap(new BitmapData(sw2, sh2, true, 0xFF000000));
			bmp.smoothing = true;
			bmp.scaleX = bmp.scaleY = 2;
			sprite.addChild(bmp);
			
			// Create bitmap data for fading into black
			blackBitmap = new BitmapData(sw2, sh2, true, 0xFF000000);
			
			// Bitmap is moved over into position then halved in size to run faster
			m = new Matrix();
			m.translate(-bmp.x, -bmp.y);
			m.scale(0.5, 0.5);
			
			// Origin and blur filter
			p = new Point(0, 0);
			blur = new BlurFilter(4, 4, 1);
		}
		
		/**
		 * Draws the line animation
		 */
		private function drawLines():void
		{
			// Clear the graphics before we draw the lines
			var g:Graphics = lines.graphics;
			g.clear();
			g.moveTo(px, py);
			
			// Draw a curve through all points in the list
			for (var i:int = list.length - 1; i > 0; i--)
			{
				// Animate the lines outwards
				list[i].x += list[i].dx;
				list[i].y += list[i].dy;
				
				// Draw the curve, fading out the last 8 points with alpha
				g.lineStyle(list[i].size, list[i].color, (list.length > (MAX_LENGTH - 8) && i < 8) ? i / 8 : 1);
				g.curveTo(list[i].x, list[i].y, (list[i].x + list[i - 1].x) / 2, (list[i].y + list[i - 1].y) / 2);
				
				// Remove the last point from the list if we've reached the maximum length
				if (list.length > MAX_LENGTH) list.splice(0, 1);
			}
		}
		
		/**
		 * Draws the lines into the bitmap with a fade effect
		 */
		private function drawBitmap():void
		{
			// Repeatedly fade out and blur the lines then draw in the new ones
			var b:BitmapData = bmp.bitmapData;
			b.lock();
			b.merge(blackBitmap, b.rect, p, 4, 4, 4, 0);
			b.applyFilter(b, b.rect, p, blur);
			b.draw(lines, m, null, BlendMode.ADD);
			b.unlock();
		}
		
		/**
		 * Listens for when the mouse re-enters the stage
		 */
		private function mouseMoveListener(e:MouseEvent):void
		{
			paused = false;
			px = e.localX;
			py = e.localY;
		}
		
		/**
		 * Listens for mouse press
		 */
		private function mouseDownListener(e:MouseEvent):void
		{
			// Allow a kind of drawing-mode when mouse is pressed
			spread = SPREAD_MIN;
		}
		
		/**
		 * Listens for mouse press
		 */
		private function mouseUpListener(e:MouseEvent):void
		{
			// Spread lines out when mouse is released
			spread = SPREAD_MAX;
		}
		
		/**
		 * Frees up memory by disposing all bitmap data
		 */
		private function disposeBitmaps():void
		{
			bmp.bitmapData.dispose();
			bmp.bitmapData = null;
			blackBitmap.dispose();
			blackBitmap = null;
		}
		
		/**
		 * Removes Neave Imagination and all other objects
		 */
		public function destroy():void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			sprite.removeChild(bmp);
			disposeBitmaps();
			
		}
	}
	
}
final class ImaginationPoint
{
	// Position variables
	internal var x:Number;
	internal var y:Number;
	
	// Movement variables
	internal var dx:Number;
	internal var dy:Number;
	
	// Other variables
	internal var size:Number;
	internal var color:uint;
	
	/**
	 * Declares a 'Neave Imagination' point, a point with extra properties
	 *
	 * @param       x               The x position
	 * @param       y               The y position
	 * @param       dx              The movement in the x-axis
	 * @param       dy              The movement in the y-axis
	 * @param       size    The size of the line
	 * @param       color   The colour of the line
	 */
	public function ImaginationPoint(x:Number, y:Number, dx:Number, dy:Number, size:Number, color:uint)
	{
		this.x = x;
		this.y = y;
		this.dx = dx;
		this.dy = dy;
		this.size = size;
		this.color = color;
	}
}

