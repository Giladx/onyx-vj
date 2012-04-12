/**
 * Copyright John_Blackburne ( http://wonderfl.net/user/John_Blackburne )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/5ls1
 */

package {
    import flash.display.*;
    import flash.events.*;
    import flash.filters.ShaderFilter;
    import flash.net.*;
    import flash.system.LoaderContext;

	public class Main extends Sprite {

		public static const asShader:Vector.<String> = Vector.<String>([
			"pQEAAACkEgBDb2xvdXJSb3RhdGVGaWx0ZXKgDG5hbWVzcGFjZQAAoAx2ZW5kb3IA",
			"SldCIFNvZnR3YXJlAKAIdmVyc2lvbgACAKAMZGVzY3JpcHRpb24AY29sb3VyIHJv",
			"dGF0aW9uIHNoYWRlcgChAQIAAAxfT3V0Q29vcmQAoQECAAADY2VudGVyAKICbWlu",
			"VmFsdWUAAAAAAAAAAACiAm1heFZhbHVlAEPogABD6IAAogJkZWZhdWx0VmFsdWUA",
			"Q2iAAENogAChAQEBAAhtYWduaXR1ZGUAogFtaW5WYWx1ZQAAAAAAogFtYXhWYWx1",
			"ZQBAoAAAogFkZWZhdWx0VmFsdWUAP4AAAKMABHNyYwChAgQCAA9kc3QAMAMA8QAA",
			"EAAdBADzAwAbAB0BAGEAALAAAgEAYQAAEAAdAwDBAQBgACQBAEEDABAAHQEAIAEA",
			"QAAyAQBAP4AAAAQBABABAIAAAwEAEAEAQAAdAQBAAQDAAB0DADEDABAAAwMAMQEA",
			"UAAdAwDBAwCwADIBABA7AxJvHQMAIAEAgAADAwAgAQDAAB0BABADAIAAAwEAEAEA",
			"AAAdAQAgAQDAAA0BABABAIAAHQMAIAEAwAAMAQAQAQCAAB0DABABAMAAHQUA4gQA",
			"GAAyAQAQQAAAAB0GAOIFABgAAwYA4gEA/AAyBwCAP4AAADIHAEA/gAAAMgcAID+A",
			"AAAdCADiBgAYAAIIAOIHABgAHQUA4ggAGAAdAQAQAwDAAAMBABADAAAAHQYAgAEA",
			"wAAdAQAQAwDAAAMBABADAEAAHQYAQAEAwAAyAQAQAAAAAB0GACABAMAAHQcA4gYA",
			"GAAdBgDiBQAYACcGAOIHABgAHQgA4gYAGAAdBgDiBQAYACYGAOIHABgAHQEAEAYA",
			"AAAyBQAQAAAAAAIFABABAMAAHQYAgAUAwAAdBgByAwCoAAMGAHIFABgAHQkA4gYA",
			"bAABCQDiCAAYAB0GAHIJABgAHQkA4gYAAAADCQDiBwAYAB0KAOIDAKgAAwoA4gYA",
			"bAAdCwDiCQAYAAELAOIKABgAHQkA4gcAGAAnCQDiBgBsAB0KAOILABgAAgoA4gkA",
			"GAAdBQDiCgAYADIJAIA/gAAAMgkAQD+AAAAyCQAgP4AAAB0KAOIFABgAAQoA4gkA",
			"GAAyBQAQPwAAAB0JAOIKABgAAwkA4gUA/AAdBQDiCQAYAB0JAIAFAAAAHQkAQAUA",
			"QAAdCQAgBQCAADIFABA/gAAAHQkAEAUAwAAdAgDzCQAbAA=="]);
		public var filter:ShaderFilter, shader:Shader;
		public var bIncreasing:Boolean, fMagnitude:Number;
		
		public function Main():void {

			var bd:BitmapData=new AssetForPixelDistortion();   
			var bitmap :Bitmap = new Bitmap( bd );
			addChild( bitmap );
		
			var dec:Base64Decoder = new Base64Decoder;
			dec.decode(asShader.join(""));
			filter = new ShaderFilter(shader = new Shader(dec.drain()));
			addEventListener(MouseEvent.MOUSE_MOVE, Move);
			addEventListener(MouseEvent.MOUSE_DOWN, Down);
			bIncreasing = false;
			fMagnitude = 0;
		}
		
		public function UpdateShader():void {
			shader.data.magnitude.value = [fMagnitude];
			filters = [filter];
		}
		
		public function Move(ev:MouseEvent):void {
			shader.data.center.value = [300, 200];
			fMagnitude = Math.min(fMagnitude + 0.05, 5);
			UpdateShader();
		}

		public function Down(ev:MouseEvent):void {
			fMagnitude = 0;
			UpdateShader();
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

/*
<languageVersion: 1.0;>
// CrossProductFilter: A filter that uses a cross product.
kernel ColourRotateFilter
<   namespace : "";
    vendor : "JWB Software";
    version : 2;
    description : "colour rotation shader"; >
{
    parameter float2 center
    <
        minValue:float2(0.0, 0.0);
        maxValue:float2(465, 465);
        defaultValue:float2(232.5, 232.5);
    >;

    parameter float magnitude
    <
        minValue:float(0.0);
        maxValue:float(5.0);
        defaultValue:float(1.0);
    >;

    input image4 src;
    output float4 dst;
    
    // evaluatePixel(): The function of the filter that actually does the 
    //                  processing of the image.  This function is called once 
    //                  for each pixel of the output image.
    void
    evaluatePixel()
    {
        float4 col = sampleNearest(src, outCoord());
        float2 diff = center - outCoord();

        float angle = length(diff);
        float rec = 1.0 / angle;
        diff = diff * rec;
        angle = angle * 0.002 * magnitude;

        float myCos = cos(angle);
        float mySin = sin(angle);
        float3 imag = float3(mySin * diff.x, mySin * diff.y, 0);

        float3 ortho = col.xyz;
        ortho = ortho * 2.0 - float3(1.0, 1.0, 1.0);

        float3 myCross = cross(ortho, imag);
        float myDot = dot(ortho, imag);
        float qReal = -myDot;
        float3 qImag = myCos * ortho + myCross;
        ortho = qReal * imag + myCos * qImag - cross(imag, qImag);

        ortho = (ortho + float3(1.0, 1.0, 1.0)) * 0.5;
        dst = float4(ortho.x, ortho.y, ortho.z, 1.0);
    }
}
*/