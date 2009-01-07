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
package onyx.file.filters {

	import onyx.file.*;

	[ExcludeClass]
	/**
	 * 
	 */
	public final class SWFFilter extends FileFilter {

		override public function validate(file:File):Boolean {
			
			var extension:String = file.extension;

			switch (extension) {
				case 'swf':
					if (file.path.indexOf('-debug') >= 0 || file.path.indexOf('-profile') >= 0) {
						break;
					}
				case 'onx':
				case 'mix':
				case 'flv':
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'mp3':
				// VLC formats
				// TBD: Need to determine what formats come from VLC, and what don't --
				// This should probably be done via some protocol handler --
				// vlc://etc etc
				//
				// MovieStar (Flash 9.0.60.184) currently supports mp4, mov, m4v, 3gp, etc
				case 'asf':
				case 'avi':
				case 'divx':
				case 'dv':
				case 'm1v':
				case 'm2v':
				case 'm4v':
				case 'mov':
				case 'mp4':
				case 'mpg':
				case 'mpeg':
 				case 'ogg':
				case 'ogm':
				case 'ps':
				case 'ts':
				case 'vob':
				case 'wmv':
				case '3gp':	
				case 'xml':
					return true;
			}

			return false;
		}
	}

}