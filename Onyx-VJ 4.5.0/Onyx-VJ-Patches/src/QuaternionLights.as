/**
 * Copyright John_Blackburne ( http://wonderfl.net/user/John_Blackburne )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/3nhD
 */

// forked from John_Blackburne's Quaternion rotation shader
// circular gradient filter with a shader
// http://johnblackburne.blogspot.co.uk/2012/04/circular-gradient-shader.html
package {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class QuaternionLights extends Patch {
		public static const asShader:Vector.<String> = Vector.<String>([
			"pQEAAACkBQB0d2lybKAMbmFtZXNwYWNlADEAoAx2ZW5kb3IASldCAKAIdmVyc2lv",
			"bgABAKAMZGVzY3JpcHRpb24AZ3JhZGllbnQgaW50ZXJwb2xhdGlvbgChAQIAAAxf",
			"T3V0Q29vcmQAoQEDAQAOY29sMQCiA2RlZmF1bHRWYWx1ZQAAAAAAAAAAAAAAAACh",
			"AQMCAA5jb2wyAKIDZGVmYXVsdFZhbHVlAAAAAAA/gAAAAAAAAKEBAwMADmNvbDMA",
			"ogNkZWZhdWx0VmFsdWUAAAAAAAAAAAA/gAAAoQEDBAAOY29sNACiA2RlZmF1bHRW",
			"YWx1ZQA/gAAAP4AAAAAAAAChAQIAAANjZW50ZXIAogJtaW5WYWx1ZQAAAAAAAAAA",
			"AKICbWF4VmFsdWUAQ/oAAEP6AACiAmRlZmF1bHRWYWx1ZQBDegAAQ3oAAKEBAQEA",
			"AXN0YXJ0QW5nbGUAogFtaW5WYWx1ZQAAAAAAogFtYXhWYWx1ZQBAyQ/bogFkZWZh",
			"dWx0VmFsdWUAAAAAAKECBAUAD2RzdAAdBgDBAAAQAAIGAMEAALAAHQYAMQYAEAAd",
			"AgAQBgDAAAYCABAGAIAAHQMAEAIAwAAdAgAQAwDAAAICABABAMAAHQMAEAIAwAAy",
			"AgAQQMkP2x0EABADAMAAAQQAEAIAwAAdAgAQBADAADIEABDASQ/bKgMAEAQAwAAd",
			"AYCAAIAAADMEABABgAAAAgDAAAMAwAAdAwAQBADAADIEABBAgAAAHQYAgAMAwAAD",
			"BgCABADAADIEABBAyQ/bBAYAQAQAwAADBgBABgAAAB0DABAGAEAAMgQAEAAAAAAq",
			"AwAQBADAAB0BgIAAgAAANAAAAAGAAAAyBAAQv4AAACoDABAEAMAAHQGAQACAAAA0",
			"AAAAAYBAADIEABBAAAAAHQYAgAMAwAABBgCABADAAB0CABAGAAAAHQcA4gEAGAAd",
			"CADiAgAYADUAAAAAAAAAMgQAED+AAAAdBgCAAwDAAAEGAIAEAMAAHQIAEAYAAAAd",
			"BwDiAgAYAB0IAOIDABgANgAAAAAAAAA1AAAAAAAAADIEABA/gAAAKgMAEAQAwAAd",
			"AYBAAIAAADQAAAABgEAAHQIAEAMAwAAdBwDiAwAYAB0IAOIEABgANQAAAAAAAAAy",
			"BAAQP4AAAB0GAIADAMAAAgYAgAQAwAAdAgAQBgAAAB0HAOIEABgAHQgA4gEAGAA2",
			"AAAAAAAAADYAAAAAAAAAHQkAgAIAwAAdCQBAAgDAAB0JACACAMAAMgoA4D+AAAAC",
			"CgDiCQAYAB0LAOIHABgAAwsA4goAGAAdDADiCAAYAAMMAOIJABgAAQsA4gwAGAAd",
			"CQDiCwAYAB0KAOIIABgAAgoA4gcAGAAyCwDgAAAAADIMAOA/gAAAHQ0A4gkAGAAC",
			"DQDiBwAYAB0OAOIIABgAAg4A4gcAGAAEDwDiDgAYAAMNAOIPABgACg0A4gsAGAAJ",
			"DQDiDAAYADIOAOBAAAAAAw4A4g0AGAAyDwDgQEAAAAIPAOIOABgAHQ4A4g0AGAAD",
			"DgDiDQAYAAMOAOIPABgAHQsA4goAGAADCwDiDgAYAB0KAOIHABgAAQoA4gsAGAAd",
			"CQDiCgAYAB0KAIAJAAAAHQoAQAkAQAAdCgAgCQCAADIEABA/gAAAHQoAEAQAwAAd",
			"BQDzCgAbAA=="])
		public var shader:Shader;
		public var bd:BitmapData, fAngle:Number;		
		
		function QuaternionLights() {
			
			bd = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT, true, 0xff8080ff);
			var bitmap :Bitmap = new Bitmap( bd );
			addChild( bitmap );

			var dec:Base64Decoder = new Base64Decoder;
			dec.decode(asShader.join(""));
			shader = new Shader(dec.drain());
			addEventListener(MouseEvent.MOUSE_MOVE, Move);
			addEventListener(MouseEvent.MOUSE_DOWN, Down);
			fAngle = 0;
		}
		
		public function UpdateShader():void {
			var shape:Shape = new Shape();
			shape.graphics.beginShaderFill(shader);
			shape.graphics.drawRect(0, 0, DISPLAY_WIDTH,DISPLAY_HEIGHT);
			bd.draw(shape);
		}
		
		public function Move(ev:MouseEvent):void {
			shader.data.center.value = [ev.localX, ev.localY];
			UpdateShader();
		}
		
		public function Down(ev:MouseEvent):void {
			shader.data.startAngle.value = [fAngle];
			fAngle += 0.5;
			if (fAngle > 6.283) fAngle -= 6.283;
			UpdateShader();
		}
		
		override public function render(info:RenderInfo):void 
		{
			info.render( bd );		
		} 
	}
}
import flash.utils.ByteArray;

class Base64Decoder
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function Base64Decoder()
	{
		super();
		data = new ByteArray();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Decodes a Base64 encoded String and adds the result to an internal
	 * buffer. Subsequent calls to this method add on to the internal
	 * buffer. After all data have been encoded, call <code>toByteArray()</code>
	 * to obtain a decoded <code>flash.utils.ByteArray</code>.
	 * 
	 * @param encoded The Base64 encoded String to decode.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function decode(encoded:String):void
	{
		for (var i:uint = 0; i < encoded.length; ++i)
		{
			var c:Number = encoded.charCodeAt(i);
			
			if (c == ESCAPE_CHAR_CODE)
				work[count++] = -1;
			else if (inverse[c] != 64)
				work[count++] = inverse[c];
			else
				continue;
			
			if (count == 4)
			{
				count = 0;
				data.writeByte((work[0] << 2) | ((work[1] & 0xFF) >> 4));
				filled++;
				
				if (work[2] == -1)
					break;
				
				data.writeByte((work[1] << 4) | ((work[2] & 0xFF) >> 2));
				filled++;
				
				if (work[3] == -1)
					break;
				
				data.writeByte((work[2] << 6) | work[3]);
				filled++;
			}
		}
	}
	
	/**
	 * @private
	 */
	public function drain():ByteArray
	{
		var result:ByteArray = new ByteArray();
		
		var oldPosition:uint = data.position;    
		data.position = 0;      // technically, shouldn't need to set this, but carrying over from previous implementation
		result.writeBytes(data, 0, data.length);                
		data.position = oldPosition;
		result.position = 0;
		
		filled = 0;
		return result;
	}
	
	/**
	 * @private
	 */
	public function flush():ByteArray
	{
		if (count > 0)
		{
			throw new Error("partialBlockDropped:"+[ count ]);
		}
		return drain();
	}
	
	/**
	 * Clears all buffers and resets the decoder to its initial state.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function reset():void
	{
		data = new ByteArray();
		count = 0;
		filled = 0;
	}
	
	/**
	 * Returns the current buffer as a decoded <code>flash.utils.ByteArray</code>.
	 * Note that calling this method also clears the buffer and resets the 
	 * decoder to its initial state.
	 * 
	 * @return The decoded <code>flash.utils.ByteArray</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function toByteArray():ByteArray
	{
		var result:ByteArray = flush();
		reset();
		return result;
	}
	
	public function toString():String
	{
		var result:ByteArray = flush();
		reset();
		return result.toString();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private Variables
	//
	//--------------------------------------------------------------------------
	
	private var count:int = 0;
	private var data:ByteArray;
	private var filled:int = 0;
	private var work:Array = [0, 0, 0, 0];
	
	private static const ESCAPE_CHAR_CODE:Number = 61; // The '=' char
	
	private static const inverse:Array =
		[
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62, 64, 64, 64, 63,
			52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 64, 64, 64, 64, 64, 64,
			64, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
			15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 64,
			64, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
			41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
			64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64
		];

}
