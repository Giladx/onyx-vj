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
package onyx.file.db {
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import onyx.file.FileFormat;

	/**
	 * 	
	 */
	public final class DBFormat extends FileFormat {
		
		/**
		 * 	@constructor
		 */
		public function DBFormat(bytes:ByteArray = null):void {
			super(bytes);
		}
		
		/**
		 * 	
		 */
		public function addFile(filename:String, thumbnail:BitmapData):void {
			
			var fileBytes:ByteArray	= new ByteArray();
			fileBytes.endian		= Endian.LITTLE_ENDIAN;
			
			// temporary total size bytes
			fileBytes.writeUnsignedInt(0);
			
			// size in bytes of the filename
			fileBytes.writeUnsignedInt(filename.length);
			
			// write image data
			fileBytes.writeBytes(thumbnail.getPixels(thumbnail.rect));
			
			// update the length
			fileBytes.position = 0;
			fileBytes.writeUnsignedInt(fileBytes.length);
			
			// add it
			bytes.writeBytes(fileBytes);
		}
	}
}