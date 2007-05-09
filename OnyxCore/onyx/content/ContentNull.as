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
package onyx.content {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;

	[ExcludeClass]
	public final class ContentNull implements IContent {
		
		public function get source():BitmapData
		{
			return null;
		}
		
		public function get totalTime():int
		{
			return 0;
		}
		
		public function get filters():Array
		{	return [];
		}
		
		public function removeFilter(filter:Filter):void
		{
		}
		
		public function get rendered():BitmapData
		{
			return null;
		}
		
		public function get loopStart():Number
		{
			return 0;
		}
		
		public function set loopStart(value:Number):void
		{
		}
		
		public function set time(value:Number):void
		{
		}
		
		public function get time():Number
		{
			return 0;
		}
		
		public function get loopEnd():Number
		{
			return 0;
		}
		
		public function set loopEnd(value:Number):void
		{
		}
		
		public function addFilter(filter:Filter):void
		{
		}
		
		public function getFilterIndex(filter:Filter):int
		{
			return -1;
		}
		
		public function set framerate(value:Number):void
		{
		}
		
		public function get framerate():Number
		{
			return 0;
		}
		
		public function moveFilter(filter:Filter, index:int):void
		{
		}
		
		public function set matrix(value:Matrix):void
		{
		}
		
		public function pause(b:Boolean=true):void
		{
		}
		
		public function get controls():Controls
		{
			return null;
		}
		
		public function dispose():void
		{
		}
		
		public function set tint(value:Number):void
		{
		}
		
		public function get tint():Number
		{
			return 0;
		}
		
		public function set alpha(value:Number):void
		{
		}
		
		public function get alpha():Number
		{
			return 0;
		}
		
		public function get contrast():Number
		{
			return 0;
		}
		
		public function set contrast(value:Number):void
		{
		}
		
		public function set color(value:uint):void
		{
		}
		
		public function get color():uint
		{
			return 0;
		}
		
		public function set threshold(value:int):void
		{
		}
		
		public function get threshold():int
		{
			return 0;
		}
		
		public function get saturation():Number
		{
			return 0;
		}
		
		public function set saturation(value:Number):void
		{
		}
		
		public function set y(value:Number):void
		{
		}
		
		public function get y():Number
		{
			return 0;
		}
		
		public function get brightness():Number
		{
			return 0;
		}
		
		public function set brightness(value:Number):void
		{
		}
		
		public function get blendMode():String
		{
			return 'normal';
		}
		
		public function set blendMode(value:String):void
		{
		}
		
		public function set x(value:Number):void
		{
		}
		
		public function get x():Number
		{
			return 0;
		}
		
		public function get scaleY():Number
		{
			return 0;
		}
		
		public function set scaleY(value:Number):void
		{
		}
		
		public function get scaleX():Number
		{
			return 0;
		}
		
		public function set scaleX(value:Number):void
		{
		}
		
		public function set rotation(value:Number):void
		{
		}
		
		public function get rotation():Number
		{
			return 0;
		}
		
		public function render():RenderTransform {
			return null;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
		public function get path():String {
			return null;
		}

		/**
		 * 	Sets matrix
		 */
		public function get matrix():Matrix {
			return null;
		}
		
		/**
		 * 
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
		}
		
		/**
		 * 
		 */
		public function get properties():Controls {
			return null;
		}

		/**
		 * 
		 */
		public function get visible():Boolean {
			return false;
		}
		
		/**
		 * 
		 */
		public function get anchorX():int {
			return 0;
		}
		
		/**
		 * 
		 */
		public function set anchorX(value:int):void {
		}
		
		/**
		 * 
		 */
		public function get anchorY():int {
			return 0;
		}
		
		/**
		 * 
		 */
		public function set anchorY(value:int):void {
		}

		/**
		 * 
		 */
		public function set visible(value:Boolean):void {
		}
	}
}