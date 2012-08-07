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
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.Base64Decoder;
	
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
			
			bd = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT, true, 0xff000000);

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
