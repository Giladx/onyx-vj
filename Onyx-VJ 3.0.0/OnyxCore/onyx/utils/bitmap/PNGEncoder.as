/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
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
 */
package onyx.utils.bitmap {
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class PNGEncoder {
	
	    public static function encode(img:BitmapData, type:uint = 0):ByteArray {
	    	var pngEncoder:PNGEncoder = new PNGEncoder();
	    	return pngEncoder.encode(img, type);
	    }
	    
	    private var crcTable:Array;
	    private var crcTableComputed:Boolean = false;

	    /**
	     * 	Encodes
	     */
	    public function encode(img:BitmapData, type:int = 0):ByteArray {

	        // Create output byte array
	        var png:ByteArray = new ByteArray();
	        // Write PNG signature
	        png.writeUnsignedInt(0x89504e47);
	        png.writeUnsignedInt(0x0D0A1A0A);
	        // Build IHDR chunk
	        var IHDR:ByteArray = new ByteArray();
	        IHDR.writeInt(img.width);
	        IHDR.writeInt(img.height);
	        if(img.transparent || type == 0)
	        {
	        	IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
	        }
	        else
	        {
	        	IHDR.writeUnsignedInt(0x08020000); //24bit RGB
	        }
	        IHDR.writeByte(0);
	        writeChunk(png,0x49484452,IHDR);
	        // Build IDAT chunk
	        var IDAT:ByteArray= new ByteArray();
	        
	        switch(type)
	        {
	        	case 0:
	        		writeRaw(img, IDAT);
	        		break;
	        	case 1:
	        		writeSub(img, IDAT);
	        		break;
	        }
	        
	        IDAT.compress();
	        writeChunk(png,0x49444154,IDAT);
	        // Build IEND chunk
	        writeChunk(png,0x49454E44,null);

	        // return PNG
	        return png;
	    }
	    

	    
	    private function writeRaw(img:BitmapData, IDAT:ByteArray):void {
	        var h:int = img.height;
	        var w:int = img.width;
	        var transparent:Boolean = img.transparent;
	        
	        for(var i:int=0;i < h;i++) {
	            // no filter
	            if ( !transparent ) {
	            	var subImage:ByteArray = img.getPixels(
	            		new Rectangle(0, i, w, 1));
	            	//Here we overwrite the alpha value of the first pixel
	            	//to be the filter 0 flag
	            	subImage[0] = 0;
					IDAT.writeBytes(subImage);
					//And we add a byte at the end to wrap the alpha values
					IDAT.writeByte(0xff);
	            } else {
	            	IDAT.writeByte(0);
	            	var p:uint;
	                for(var j:int=0;j < w;j++) {
	                    p = img.getPixel32(j,i);
	                    IDAT.writeUnsignedInt(
	                        uint(((p&0xFFFFFF) << 8)|
	                        (p>>>24)));
	                }
	            }
	        }
	    }
	    
	    private function writeSub(img:BitmapData, IDAT:ByteArray):void {
            var r1:uint;
            var g1:uint;
            var b1:uint;
            var a1:uint;
            
            var r2:uint;
            var g2:uint;
            var b2:uint;
            var a2:uint;
            
            var r3:uint;
            var g3:uint;
            var b3:uint;
            var a3:uint;
            
            var p:uint;
	        var h:int = img.height;
	        var w:int = img.width;
	        
	        for(var i:int=0;i < h;i++) {
	            // no filter
	            IDAT.writeByte(1);
	            if ( !img.transparent ) {
					r1 = 0;
					g1 = 0;
					b1 = 0;
					a1 = 0xff;
	                for(var j:int=0;j < w;j++) {
	                    p = img.getPixel(j,i);
	                    
	                    r2 = p >> 16 & 0xff;
	                    g2 = p >> 8  & 0xff;
	                    b2 = p & 0xff;
	                    
	                    r3 = (r2 - r1 + 256) & 0xff;
	                    g3 = (g2 - g1 + 256) & 0xff;
	                    b3 = (b2 - b1 + 256) & 0xff;
	                    
	                    IDAT.writeByte(r3);
	                    IDAT.writeByte(g3);
	                    IDAT.writeByte(b3);
	                    
	                    r1 = r2;
	                    g1 = g2;
	                    b1 = b2;
	                    a1 = 0;
	                }
	            } else {
					r1 = 0;
					g1 = 0;
					b1 = 0;
					a1 = 0;
	                for(j=0;j < w;j++) {
	                    p = img.getPixel32(j,i);
	                    
	                    a2 = p >> 24 & 0xff;
	                    r2 = p >> 16 & 0xff;
	                    g2 = p >> 8  & 0xff;
	                    b2 = p & 0xff;
	                    
	                    r3 = (r2 - r1 + 256) & 0xff;
	                    g3 = (g2 - g1 + 256) & 0xff;
	                    b3 = (b2 - b1 + 256) & 0xff;
	                    a3 = (a2 - a1 + 256) & 0xff;
	                    
	                    IDAT.writeByte(r3);
	                    IDAT.writeByte(g3);
	                    IDAT.writeByte(b3);
	                    IDAT.writeByte(a3);
	                    
	                    r1 = r2;
	                    g1 = g2;
	                    b1 = b2;
	                    a1 = a2;
	                }
	            }
	        }
	    }
	
	    private function writeChunk(png:ByteArray, type:uint, data:ByteArray):void {
	        if (!crcTableComputed) {
	            crcTableComputed = true;
	            crcTable = [];
	            for (var n:uint = 0; n < 256; n++) {
	                c = n;
	                for (var k:uint = 0; k < 8; k++) {
	                    if (c & 1) {
	                        c = uint(uint(0xedb88320) ^ 
	                            uint(c >>> 1));
	                    } else {
	                        c = uint(c >>> 1);
	                    }
	                }
	                crcTable[n] = c;
	            }
	        }
	        var len:uint = 0;
	        if (data != null) {
	            len = data.length;
	        }
	        png.writeUnsignedInt(len);
	        var p:uint = png.position;
	        png.writeUnsignedInt(type);
	        if ( data != null ) {
	            png.writeBytes(data);
	        }
	        var e:uint = png.position;
	        png.position = p;
	        var c:uint = 0xffffffff;
	        for (var i:int = 0; i < (e-p); i++) {
	            c = uint(crcTable[
	                (c ^ png.readUnsignedByte()) & 
	                0xff] ^ (c >>> 8));
	        }
	        c = uint(c^uint(0xffffffff));
	        png.position = e;
	        png.writeUnsignedInt(c);
	        
	    }
	}
}