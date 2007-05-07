/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
package onyx.core {
	
	/**
	 *  Beats
	 */
	public final class TempoBeat {
		
		/**
		 * 	Stores a dictionary of available beats
		 * 	This is also used for a lookup for xml serialization
		 */
		public static const BEATS:Object = {
			'global': new TempoBeat('global', 0),
			'1/16': new TempoBeat('1/16', 1),
			'1/8': new TempoBeat('1/8', 2),
			'1/4': new TempoBeat('1/4', 4),
			'1/2': new TempoBeat('1/2', 8),
			'1': new TempoBeat('1', 16),
			'2': new TempoBeat('2', 32),
			'4': new TempoBeat('4', 64)
		}

		/**
		 * 	Name
		 */
		public var name:String;
		
		/**
		 * 	Beat
		 */
		public var mod:int;
		
		/**
		 * 	@constructor
		 */
		public function TempoBeat(name:String, mod:int):void {
			this.name	= name,
			this.mod	= mod;
		}
		
		/**
		 * 	override toString();
		 */
		public function toString():String {
			return name;
		}
	}
}