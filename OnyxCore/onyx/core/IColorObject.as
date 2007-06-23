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
package onyx.core {
	
	import flash.events.IEventDispatcher;
	
	import onyx.plugin.*;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	
	/**
	 * 	Base interface for DisplayObject interface as well as tint, saturation etc
	 */
	public interface IColorObject extends IEventDispatcher {
		
		function set anchorX(value:int):void;
		function get anchorX():int;
		
		function set anchorY(value:int):void;
		function get anchorY():int;
		
		function set color(value:uint):void;
		function get color():uint;

		function get alpha():Number;
		function set alpha(value:Number):void;

		function get brightness():Number;
		function set brightness(value:Number):void;

		function get contrast():Number;
		function set contrast(value:Number):void;

		function get scaleX():Number;
		function set scaleX(value:Number):void;

		function get scaleY():Number;
		function set scaleY(value:Number):void;

		function get rotation():Number;
		function set rotation(value:Number):void;

		function get saturation():Number;
		function set saturation(value:Number):void;

		function get threshold():int;
		function set threshold(value:int):void;

		function get tint():Number;
		function set tint(value:Number):void;

		function get x():Number;
		function set x(value:Number):void;

		function get y():Number;
		function set y(value:Number):void;
		
		function get blendMode():String;
		function set blendMode(value:String):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function pause(b:Boolean = true):void;
		
	}
}