/**
 * Copyright uwi ( http://wonderfl.net/user/uwi )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/gOgm
 */

// forked from Nao_u's ç”»åƒã‚’çµµç”»èª¿ã«å¤‰æ›
// 
// ç”»åƒã‚’çµµç”»èª¿ã«å¤‰æ›
//
// ç”»åƒã‚’ã‚¯ãƒªãƒƒã‚¯ã™ã‚‹ã¨ã€æ¬¡ã®ç”»åƒã¸ã€‚
//
//
// è§£èª¬ãªã©:http://game.g.hatena.ne.jp/Nao_u/20091229
//
// é«˜é€ŸåŒ–ã—ãŸã‘ã©ã‚ˆãã‚ã‹ã‚“ã­
package {     
	import flash.display.Sprite;     
	import flash.events.*;     
	
	public class DrawShader extends Sprite {     
		public function DrawShader() {     
			Main = this;     
			startLoad();     
			addEventListener(Event.ENTER_FRAME,update);      
			addEventListener(MouseEvent.MOUSE_DOWN, isClick );        
		}     
	}     
}

function isClick(event:MouseEvent):void{
	Text.text = "ç”Ÿæˆä¸­...";  
	bLoad = false;
	startLoad();     
}

import flash.display.*; 
import flash.events.*
	import flash.text.TextField;     
import flash.geom.*;
import flash.utils.getTimer;
import flash.net.*; 
import flash.filters.*;

var Main:Sprite;     
var SCREEN_W:Number = 465;
var SCREEN_H:Number = 465;
var Text:TextField    
var View: Bitmap; 
var BmpData: BitmapData; 
var BmpData2: BitmapData; 
var BmpDataMono: BitmapData; 
var BmpDataEdge: BitmapData; 
var BmpDataTmp: BitmapData; 

var BITMAP_W:int = SCREEN_W;
var BITMAP_H:int = SCREEN_H;
var loaderA:Loader; 
var loaderB:Loader; 
var bLoad:Boolean = false;
var No:int = 0;

function startLoad():void{     
	loaderA = new Loader(); 
	
	
	var url:String;
	switch(No){
		case  0: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20090326044849.jpg"; break;
		case  1: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090913/20090913133305.jpg"; break;
		case  2: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20090817090823.jpg"; break;
		case  3: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20080716105600.jpg"; break;
		case  4: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20090326042031.jpg"; break;
		case  5: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20090327043047.jpg"; break;
		case  6: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20080810100737.jpg"; break;
		case  7: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20080809101700.jpg"; break;
		case  8: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20090327102950.jpg"; break;
		case  9: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20090327090702.jpg"; break;
		case 10: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20080716102900.jpg"; break;
		case 11: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20090327091952.jpg"; break;
		case 12: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090913/20090913133218.jpg"; break;
		case 13: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20090327043118.jpg"; break;
		case 14: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20090326052814.jpg"; break;
		case 15: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20080810090405.jpg"; break;
		case 16: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20080106055925.jpg"; break;
		case 17: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090326/20080106044103.jpg"; break;
		case 18: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20090817091054.jpg"; break;
		case 19: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20091004065300.jpg"; break;
		case 20: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20091004070000.jpg"; break;
		case 21: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20090815193507.jpg"; break;
		case 22: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20090326084145.jpg"; break;
		case 23: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20090326072406.jpg"; break;
		case 24: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20080810113647.jpg"; break;
		case 25: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20080716105000.jpg"; break;
		case 26: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20080115004653.jpg"; break;
		case 27: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20080716101100.jpg"; break;
		case 28: url = "http://img.f.hatena.ne.jp/images/fotolife/N/Nao_u/20090817/20080716111200.jpg"; break;
	}
	No++;
	if( No == 29 ) No = 0;
	loaderA.load( new URLRequest(url) );
	loaderA.contentLoaderInfo.addEventListener( Event.COMPLETE, loadComplete ); 
}


function loadComplete(e:Event):void { 
	/* BL NECESSARY but Error #3226: Cannot import a SWF file when LoaderContext.allowCodeImport is false.
	loaderB = new Loader(); 
	loaderB.contentLoaderInfo.addEventListener(Event.INIT, initialize); 
	loaderB.loadBytes(loaderA.contentLoaderInfo.bytes); */
}

function initialize(event:Event):void 
{ 
	var loader:Loader = loaderB;
	BmpData = new BitmapData(BITMAP_W, BITMAP_W, false); 
	BmpData.draw(loader);
	View = new Bitmap(BmpData); 
	View.scaleX = 1.0;
	View.scaleY = 1.0;
	Main.addChild(View);      
	
	BmpData2 = new BitmapData(loader.width, loader.height, false); 
	BmpDataMono = new BitmapData(loader.width, loader.height, false); 
	BmpDataEdge = new BitmapData(loader.width, loader.height, false); 
	BmpDataTmp  = new BitmapData(loader.width, loader.height, false); 
	
	
	
	Text = new TextField();     
	Text.text = "ç”»åƒå¤‰æ›ä¸­ãƒ»ãƒ»ãƒ»ã—ã°ã‚‰ããŠå¾…ã¡ãã ã•ã„";   
	Text.autoSize = "left";
	Main.addChild(Text);      
	
	Cnt=0;
	bLoad = true;
} 

var Cnt:int;
function update(e :Event):void{     
	if( bLoad == false ){
		return;
	}
	Cnt++;
	if( Cnt == 3 ){
		var time:int = getTimer(); 
		var cont:Number = 64;
		var mul:Number = 128 + cont;
		
		// ãƒ¢ãƒŽã‚¯ãƒ­ç”»åƒã‚’ç”Ÿæˆ
		FilterMono( BmpData, BmpDataMono );
		// ãƒ¢ãƒŽã‚¯ãƒ­ç”»åƒã‹ã‚‰ã‚¨ãƒƒã‚¸æŠ½å‡ºç”»åƒã‚’ç”Ÿæˆ
		FilterEdge( BmpDataMono, BmpDataEdge );
		// å…ƒçµµã‹ã‚‰ã¼ã‹ã—ç”»åƒã‚’ç”Ÿæˆ(11x11ã‚’2ãƒ‘ã‚¹)
		Filter3( BmpData, BmpData2);
		Filter3( BmpData2, BmpData );
		
		// ã¼ã‹ã—ãŸç”»åƒã«ã‚¨ãƒƒã‚¸æŠ½å‡ºç”»åƒã‚’ä¹—ç®—
		BmpData.draw(BmpDataEdge, null, null, BlendMode.MULTIPLY);
		
		var endTime:int = getTimer() - time;
		Text.text = "ç”Ÿæˆæ™‚é–“ï¼š" + endTime + "[ms]";   
	}
}  


// ãƒ¢ãƒŽã‚¯ãƒ­ç”»åƒã‚’ç”Ÿæˆ
function FilterMono( inBmp:BitmapData, outBmp:BitmapData):void{
	var cmf : ColorMatrixFilter = new ColorMatrixFilter([
		0.298912, 0.586611, 0.114477, 0, 0,
		0.298912, 0.586611, 0.114477, 0, 0,
		0.298912, 0.586611, 0.114477, 0, 0,
		0.298912, 0.586611, 0.114477, 0, 0
	]);
	
	outBmp.lock();
	outBmp.applyFilter(inBmp, inBmp.rect, new Point(), cmf);
	outBmp.unlock(); 
}


// ã‚¨ãƒƒã‚¸æŠ½å‡ºç”»åƒã‚’ç”Ÿæˆ
function FilterEdge( inBmp:BitmapData, outBmp:BitmapData):void{
	var i : uint;
	
	var cf1 : ConvolutionFilter = new ConvolutionFilter(3, 3, [
		-1, 0, 1,
		-2, 0, 2,
		-1, 0, 1
	], 1, 127);
	var cf2 : ConvolutionFilter = new ConvolutionFilter(3, 3, [
		-1, -2, -1,
		0, 0, 0,
		1, 2, 1
	], 1, 127); 
	var mSquare : Array = new Array(256);
	for(i = 0;i < 256;i++){
		mSquare[i] = Math.min((i - 127) * (i - 127) / 40, 255);
	}
	var m : Array = new Array(256);
	for(i = 0;i < 255;i++)m[i] = 0xffffff;
	m[255] = 0x737373;
	
	var zero : Array = new Array(256);
	for(i = 0;i < 255;i++)zero[i] = 0;
	
	outBmp.lock();
	var tempB: BitmapData = inBmp.clone();
	outBmp.applyFilter(inBmp, inBmp.rect, new Point(), cf1);
	outBmp.paletteMap(outBmp, outBmp.rect, new Point(), zero, zero, mSquare); // 2ä¹—
	tempB.applyFilter(inBmp, inBmp.rect, new Point(), cf2);
	tempB.paletteMap(tempB, tempB.rect, new Point(), zero, zero, mSquare); // 2ä¹—
	
	outBmp.draw(tempB, null, null, BlendMode.ADD);
	tempB.dispose();
	outBmp.paletteMap(outBmp, outBmp.rect, new Point(), zero, zero, m);
	outBmp.unlock();
	
	// MedianFilter
	// @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&extid=1744024
	// @see http://wonderfl.net/code/040577c9daacfcf99cb4d343ca91575a1107179f
	var median : ShaderFilter = new ShaderFilter(new MedianSimpleShader());
	BmpDataTmp.applyFilter(outBmp, outBmp.rect, new Point(), median);
	
	// ã¼ã‹ã—(å°‘ã—æ”¹å¤‰)
	var blur : ConvolutionFilter = new ConvolutionFilter(5, 5, [
		0.16, 0.4, 0.4, 0.4, 0.16,
		0.4, 1, 1, 1, 0.4,
		0.4, 1, 1, 1, 0.4,
		0.4, 1, 1, 1, 0.4,
		0.16, 0.4, 0.4, 0.4, 0.16
	],
		0.16 + 0.4 + 0.4 + 0.4 + 0.16 +
		0.4 + 1 + 1 + 1 + 0.4 +
		0.4 + 1 + 1 + 1 + 0.4 +
		0.4 + 1 + 1 + 1 + 0.4 + 
		0.16 + 0.4 + 0.4 + 0.4 + 0.16
	);
	outBmp.applyFilter(BmpDataTmp, BmpDataTmp.rect, new Point(), blur);
}

// ã¼ã‹ã—ãƒ•ã‚£ãƒ«ã‚¿(ãƒã‚¤ãƒ©ãƒ†ãƒ©ãƒ«ãƒ•ã‚£ãƒ«ã‚¿ã£ã½ã„æ„Ÿã˜)
// ãƒã‚¤ãƒ©ãƒ†ãƒ©ãƒ«ãƒ•ã‚£ãƒ«ã‚¿ã‚’å½“ã¦ãŸã‚‰æ™‚é–“ã‹ã‹ã‚‹ä¸Šã«åˆ¥ç‰©ã«ãªã£ãŸãƒ»ãƒ»
function Filter3( inBmp:BitmapData, outBmp:BitmapData):void{
	
	// @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&loc=en_us&extid=1789025
	//    var bilateral : ShaderFilter = new ShaderFilter(new BilateralBlurShader());
	//    outBmp.applyFilter(inBmp, inBmp.rect, new Point(), bilateral);
	var b:Color = new Color(0);
	var col:Color = new Color(0);
	var c:Color = new Color( 0 );
	var sum:Number = 0;
	var s:Number = 0;
	var w:Number = 0;
	
	inBmp.lock(); 
	outBmp.lock(); 
	for( var x:int=0; x<BITMAP_W; x++ ){ 
		for( var y:int=0; y<BITMAP_H; y++ ){ 
			sum = 0;
			col.r = col.g = col.b = 0;
			b.set( inBmp.getPixel(x, y) );
			
			for( var lx:int=-5; lx<=5; lx++ ){ 
				for( var ly:int=-5; ly<=5; ly++ ){ 
					c.set( inBmp.getPixel(x+lx, y+ly) );
					
					s = c.g - b.g;
					if( s < 0 ) s = -s;   
					w = 1 - s*s*s;      
					col.r += c.r * w;
					col.g += c.g * w;
					col.b += c.b * w;
					sum += w;
				}
			}
			var mul:Number = 1.0 / sum;
			col.r *= mul;
			col.g *= mul;
			col.b *= mul;
			outBmp.setPixel(x, y, col.getInt() ); 
		}
	} 
	inBmp.unlock();
	outBmp.unlock();
}

// è‰²ã‚¯ãƒ©ã‚¹
class Color{
	public var r:Number;
	public var g:Number;
	public var b:Number;
	
	public function Color( c:int ){
		r = ((c & 0xff0000)>>16)*0.003921568627;
		g = ((c & 0x00ff00)>>8)*0.003921568627;
		b = ((c & 0x0000ff))*0.003921568627;
	}
	
	public function set( c:int ):void{
		r = ((c & 0xff0000)>>16)*0.003921568627;
		g = ((c & 0x00ff00)>>8)*0.003921568627;
		b = ((c & 0x0000ff))*0.003921568627;
	}
	
	public function getInt():int{
		if( r > 1.0 ) r = 1.0;
		if( g > 1.0 ) g = 1.0;
		if( b > 1.0 ) b = 1.0;
		if( r < 0.0 ) r = 0.0;
		if( g < 0.0 ) g = 0.0;
		if( b < 0.0 ) b = 0.0;
		var col:int = ((r*255) << 16) + ((g*255)<<8) + (b*255);
		return col;
	}
}

import flash.utils.ByteArray;

class MedianSimpleShader extends Shader
{
	
	private var vec:Vector.<int> = Vector.<int>( [ 237,153,205,106,219,80,16,133,143,108,217,150,127,106,89,178,228,77,49,104,221,69,41,109,233,162,155,94,232,186,116,209,7,40,33,86,192,16,219,193,118,67,151,243,40,9,109,247,125,131,210,71,18,122,129,106,116,71,106,116,145,54,33,132,36,40,155,177,125,190,163,57,247,78,22,131,253,203,2,240,115,130,79,241,106,125,178,253,178,222,92,156,199,87,147,237,201,38,62,92,156,156,198,136,55,235,243,248,229,122,123,182,195,213,228,50,222,174,118,123,224,202,185,140,247,135,245,110,11,43,251,116,21,31,78,247,235,139,35,191,215,143,121,31,233,7,69,111,190,191,137,54,249,71,209,217,250,252,24,239,113,109,117,128,201,215,207,223,142,31,119,187,253,10,63,96,31,246,167,184,238,216,22,220,213,225,136,215,64,244,135,192,117,198,117,217,193,223,236,37,172,188,254,198,171,46,146,78,246,62,251,60,237,226,121,206,103,71,248,207,119,133,239,10,111,35,233,50,223,69,106,11,255,225,230,243,109,225,109,225,123,72,108,230,109,164,61,225,139,60,220,103,217,19,190,39,124,31,73,143,249,30,210,190,145,39,231,251,194,247,133,31,32,233,51,223,71,58,48,242,228,252,64,248,129,240,14,146,1,243,3,164,142,145,135,125,75,71,120,71,248,33,18,135,121,7,233,208,200,147,243,67,225,135,194,143,144,12,153,31,34,29,25,121,114,126,36,252,72,248,49,146,17,243,35,164,227,27,207,95,142,65,29,93,85,87,215,200,230,58,1,245,116,85,125,93,163,1,215,103,32,71,87,53,212,53,26,113,157,194,25,103,245,197,20,106,202,239,45,34,100,57,222,102,175,45,206,147,245,203,36,230,180,62,101,149,240,14,250,47,243,105,189,214,71,204,151,254,138,207,5,229,122,141,207,229,62,133,62,229,243,86,124,202,109,200,233,114,159,66,119,141,156,174,232,181,62,98,190,244,87,124,51,144,219,144,147,255,129,150,133,238,26,57,103,80,179,134,156,51,238,83,232,51,35,231,76,244,90,31,49,95,250,141,57,180,243,123,8,243,107,231,112,183,115,104,239,179,254,62,159,250,189,60,150,243,221,119,206,91,246,211,251,130,146,125,65,201,190,160,100,95,80,178,47,40,217,23,148,236,11,74,246,5,37,251,66,86,61,217,23,60,40,175,33,135,167,57,173,123,198,185,61,209,107,125,196,124,233,175,248,124,144,215,48,31,159,251,20,186,103,204,199,135,242,27,114,250,220,167,208,125,35,167,47,122,173,143,152,47,253,21,223,28,228,55,228,156,115,159,66,247,141,156,115,168,121,67,206,57,247,41,244,185,145,115,46,122,173,143,152,47,253,198,28,218,249,61,132,249,181,115,184,219,57,180,247,89,127,159,79,253,94,30,203,249,238,59,231,45,251,233,125,129,100,95,32,217,23,72,246,5,146,125,129,100,95,32,217,23,72,246,5,146,125,33,171,129,236,11,1,84,208,144,35,224,28,133,30,24,231,14,68,175,245,229,207,47,253,21,95,8,10,26,230,19,114,159,66,15,140,249,132,80,97,67,206,144,251,20,122,104,228,12,69,175,245,17,243,165,191,226,91,128,194,134,156,11,238,83,232,161,145,115,1,181,104,200,185,224,62,133,190,48,114,46,68,175,245,17,243,165,223,152,67,59,191,135,48,191,118,14,119,59,135,246,62,235,239,243,169,223,203,99,57,223,125,231,188,101,63,254,157,130,127,183,88,90,250,119,138,172,146,254,94,139,247,181,188,230,243,248,7 ] );
	private var byteArr:ByteArray;
	public function MedianSimpleShader():void
	{
		var len:int = vec.length;
		if(!byteArr)
		{
			byteArr = new ByteArray();
			for(var i:int=0; i<len; i++)
			{
				byteArr.writeByte( vec[i] );
			}
			byteArr.inflate();
			this.byteCode = byteArr;
		}
	}
}

class BilateralBlurShader extends Shader
{
	
	private var vec:Vector.<int> = Vector.<int>( [ 237,156,189,110,212,64,16,199,199,62,231,206,145,130,98,165,66,138,44,109,9,205,41,66,162,161,32,78,82,32,33,36,58,10,26,216,216,62,206,146,99,71,254,72,64,52,150,82,80,82,67,117,9,208,208,135,14,113,129,167,224,45,136,238,5,152,181,247,146,139,112,65,20,5,133,232,95,141,246,107,118,247,119,115,51,179,246,222,125,50,136,232,227,13,90,143,98,89,132,153,140,215,227,50,27,45,36,114,43,204,183,165,31,82,18,22,253,52,41,134,225,110,148,188,200,251,131,40,230,110,57,141,22,118,194,36,72,51,90,75,130,87,226,81,68,35,123,135,235,163,52,33,131,27,131,48,247,179,104,187,80,229,19,213,66,233,238,211,190,97,18,45,60,123,92,22,27,105,154,5,92,230,53,152,1,29,24,91,81,242,68,198,101,72,247,246,150,82,46,202,151,77,113,77,16,183,6,225,64,150,113,209,84,121,188,236,131,51,211,172,13,6,210,47,114,193,75,21,15,100,153,231,145,76,196,160,76,124,213,42,118,135,145,63,20,155,50,15,3,193,197,32,202,11,153,248,97,191,153,221,200,206,55,251,253,159,239,222,255,49,123,248,215,179,251,105,156,102,194,31,202,36,9,227,252,86,148,248,113,25,48,94,33,227,237,161,188,77,31,200,202,51,159,246,77,203,160,197,32,47,200,53,233,136,200,161,59,29,170,120,227,74,122,90,10,45,157,90,154,77,121,197,162,99,147,171,220,57,154,88,180,172,234,29,143,71,186,22,85,12,159,204,90,142,85,217,179,154,113,51,237,222,108,187,80,237,43,93,58,182,232,57,185,61,154,116,89,159,219,165,201,28,75,147,101,143,229,77,251,180,222,214,243,125,83,122,89,143,119,104,77,44,75,173,175,162,14,75,107,90,207,210,181,169,178,120,158,94,45,155,249,187,44,141,90,122,170,92,247,231,178,211,229,241,170,93,245,111,218,199,212,232,29,183,233,245,180,94,111,170,215,214,122,109,173,215,156,25,183,100,42,57,214,251,231,250,158,226,198,253,59,205,254,216,98,197,148,211,106,85,235,17,170,223,138,125,202,69,237,155,231,109,184,216,154,203,188,174,103,46,243,103,185,56,222,136,200,178,213,231,201,92,52,135,186,94,175,95,173,183,167,247,225,214,251,159,114,240,78,184,25,182,226,80,115,113,236,147,246,177,214,59,110,211,43,180,94,49,213,171,120,24,181,172,106,189,230,204,56,197,197,38,250,183,92,222,46,127,5,151,22,46,123,191,94,131,75,11,151,10,223,35,216,11,252,11,226,209,37,113,81,249,203,245,227,226,169,126,51,121,159,163,243,62,231,52,239,131,61,93,138,61,189,249,241,5,92,90,184,12,142,158,130,75,11,151,135,155,223,193,165,133,139,7,255,2,123,129,127,65,60,66,62,124,165,242,62,156,175,224,127,206,195,229,238,181,60,95,93,156,203,34,190,71,173,92,8,121,31,236,5,254,5,241,8,207,135,175,84,222,135,247,13,56,143,35,94,93,152,203,234,33,226,85,43,23,188,231,133,189,192,191,32,30,225,190,196,213,202,251,224,151,241,126,10,207,111,144,223,92,18,23,130,189,192,94,224,95,16,143,112,127,24,207,251,112,190,194,121,28,207,111,144,223,192,94,192,5,254,5,241,8,249,11,238,247,225,62,5,238,223,32,94,225,249,13,236,5,254,5,92,16,143,112,191,15,191,231,197,239,167,224,127,112,30,199,251,41,216,11,252,11,226,17,184,224,247,188,248,255,27,216,19,206,87,120,223,128,251,55,176,23,248,23,196,35,252,127,223,127,200,133,231,155,152,244,89,141,155,116,212,126,141,102,223,191,1 ] );
	private var byteArr:ByteArray;
	public function BilateralBlurShader():void
	{
		var len:int = vec.length;
		if(!byteArr)
		{
			byteArr = new ByteArray();
			for(var i:int=0; i<len; i++)
			{
				byteArr.writeByte( vec[i] );
			}
			byteArr.inflate();
			this.byteCode = byteArr;
		}
	}
}