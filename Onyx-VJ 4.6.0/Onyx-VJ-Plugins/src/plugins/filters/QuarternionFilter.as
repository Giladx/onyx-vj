//QuarternionFilter
/**
 * Copyright John_Blackburne ( http://wonderfl.net/user/John_Blackburne )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/5ls1
 */

package plugins.filters {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ShaderFilter;
	import flash.net.*;
	
	import onyx.utils.Base64Decoder;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class QuarternionFilter extends Filter implements IBitmapFilter {
		
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
		private var delta:Number = 0.05;
		
		public function QuarternionFilter():void { 
			
			
			var dec:Base64Decoder = new Base64Decoder;
			dec.decode(asShader.join(""));
			filter = new ShaderFilter(shader = new Shader(dec.drain()));
			/* does not trigger
			addEventListener(MouseEvent.MOUSE_MOVE, Move);
			addEventListener(MouseEvent.MOUSE_DOWN, Down);*/
			bIncreasing = false;
			fMagnitude = 0;
		}
		
		public function UpdateShader():void {
			fMagnitude = Math.min(fMagnitude + delta, 5);
			if (fMagnitude == 5 || fMagnitude == 0) delta = -delta;
			shader.data.magnitude.value = [fMagnitude];
			//filters = [filter];
		}
		
/*		public function Move(ev:MouseEvent):void {
			shader.data.center.value = [ev.localX, ev.localY];
			UpdateShader();
		}
		
		public function Down(ev:MouseEvent):void {
			shader.data.center.value = [ev.localX, ev.localY];
			UpdateShader();
		}*/
		public function applyFilter(bitmapData:BitmapData):void {
			UpdateShader();
			bitmapData.applyFilter(bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY, filter);
		}
	}
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