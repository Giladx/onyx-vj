/**
 * Copyright Matt_Wakeling ( http://wonderfl.net/user/Matt_Wakeling )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/5vUN
 * 
 * Name           : Main
 * Coded By       : Matt Wakeling
 * Date           : 08th May 2012
 * Description    : Main Class for the Application.
 *                  ActionScript 3 Tree Roots - based on code from Roger Bagula and Paul Bourke.
 *
 * @author Matt Wakeling
 */

package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class TreeRoots extends Patch 
	{
		public  var retang:Shape;
		public  var circs:uint;
		public  var circulos:Array;
		public  var alt:int, larg:int;
		public  var blur:Array;
		private var sprite:Sprite;
		private var timer:Timer;
		private var resolution:int = 4;
		
		public function TreeRoots() 
		{
			sprite = new Sprite();
			var scrTreeRoots:TreeRoot = new TreeRoot(DISPLAY_WIDTH, DISPLAY_HEIGHT, resolution);
			scrTreeRoots.cacheAsBitmap = true;
			scrTreeRoots.scaleX = 1 / resolution;
			scrTreeRoots.scaleY = 1 / resolution;
			sprite.addChild(scrTreeRoots);

		}
		
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import frocessing.color.ColorHSV;

class TreeRoot extends Sprite
{
	private var Width:int = 0;
	private var Height:int = 0;
	private var Scale:int = 10;
	
	private var Points:int     = 10000;
	private var Iterations:int = 10000000;
	
	private var FrameCounter:int = 0;
	
	private var bmpd:BitmapData;
	private var bmp:Bitmap;
	
	private var XCoord1:Number = 0;
	private var YCoord1:Number = 0;
	
	private var XCoord2:Number = 0;
	private var YCoord2:Number = 0;
	
	private var DisplayX:Number = 0;
	private var DisplayY:Number = 0;
	
	// TreeRoots Constructor
	public function TreeRoot(StageWidth:int, StageHeight:int, StageResolution:int)
	{
		
		Width = StageWidth * StageResolution;
		Height = StageHeight * StageResolution;
		
		bmpd = new BitmapData(Width, Height, false, 0x000000);
		bmp = new Bitmap(bmpd);
		
		addChild(bmp);
		
		addEventListener(Event.ENTER_FRAME, FrameEvent);
	}
	
	// FrameEvent Method
	private function FrameEvent(e:Event):void
	{
		bmpd.lock();
		
		for (var i:Number = 0; i < Points; i++)
		{
			switch (Math.round(Math.random() % 1))
			{
				case 0: 
					XCoord1 = YCoord2 / Math.SQRT2 + 1.5;
					YCoord1 = -XCoord2 / Math.SQRT2 + 1.5;
					break;
				case 1: 
					XCoord1 = -YCoord2 / Math.SQRT2 + 0.5;
					YCoord1 = XCoord2 / Math.SQRT2 + 0.5;
					break;
			}
			
			
			switch (Math.round(Math.random() % 1))
			{
				case 0: 
					XCoord2 = XCoord1 - 2;
					YCoord2 = YCoord1;
					break;
				case 1: 
					var Denominator:Number = (XCoord1 - 2) * (XCoord1 - 2) + YCoord1 * YCoord1;
					XCoord2 = (XCoord1 - 2) / Denominator;
					YCoord2 = YCoord1 / Denominator;
					break;
			}
			
			DisplayX = (XCoord2 + 1.0) * (Width / Scale) + Width / 2;
			DisplayY = (YCoord2 - 0.75) * (Height / Scale) + Height / 2;
			
			if ((DisplayX >= 0 && DisplayX <= Width) && (DisplayY >= 0 && DisplayY <= Height))
			{
				bmpd.setPixel(DisplayX, DisplayY, 0xFFFFFF);
			}
			
			FrameCounter ++;
		}
		
		bmpd.unlock();
		
		if (FrameCounter++ >= Iterations)
		{
			removeEventListener(Event.ENTER_FRAME, FrameEvent)            
		}
	}
	
}


