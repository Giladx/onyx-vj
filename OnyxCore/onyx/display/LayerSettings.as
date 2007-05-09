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
package onyx.display {
	
	import flash.events.EventDispatcher;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;

	/**
	 * 	This class stores settings that can be applied to layers
	 */
	public class LayerSettings extends EventDispatcher {

		public var x:int				= 0;
		public var y:int				= 0;
		public var anchorX:int			= 0;
		public var anchorY:int			= 0;
		public var scaleX:Number		= 1;
		public var scaleY:Number		= 1;
		public var rotation:int			= 0;

		public var alpha:Number			= 1;
		public var brightness:Number	= 0;
		public var contrast:Number		= 0;
		public var saturation:Number	= 1;
		public var tint:Number			= 0;
		public var color:uint			= 0;
		public var threshold:Number		= 0;
		public var blendMode:String		= 'normal';
		public var visible:Boolean		= true;
		
		public var time:Number			= 0;
		public var framerate:Number		= 1;

		public var filters:Array;
		public var controls:Object;

		public var loopStart:Number		= 0;
		public var loopEnd:Number		= 1;
		public var path:String;
		
		/**
		 * 	Gets variables from a layer
		 */
		public function load(content:ILayer):void {
			
			x			= content.x,
			y			= content.y,
			scaleX		= content.scaleX,
			scaleY		= content.scaleY,
			rotation	= content.rotation,
			alpha		= content.alpha,
			brightness	= content.brightness,
			contrast	= content.contrast,
			saturation	= content.saturation,
			color		= content.color,
			tint		= content.tint,
			threshold	= content.threshold,
			blendMode	= content.blendMode,
			time		= content.time,
			framerate	= content.framerate,
			loopStart	= content.loopStart,
			loopEnd		= content.loopEnd,
			visible		= content.visible,
			path		= content.path,
			filters		= content.filters;
			
			if (content.controls) {
				controls = content.controls;
			}
		}
		
		/**
		 * 	Loads settings info from xml
		 */
		public function loadFromXML(xml:XML):void {
			
			x			= xml.properties.x;
			y			= xml.properties.x;
			alpha		= xml.properties.alpha;
			scaleX		= xml.properties.scaleX;
			scaleY		= xml.properties.scaleY;
			rotation	= xml.properties.rotation;
			brightness	= xml.properties.brightness;
			contrast	= xml.properties.contrast;
			saturation	= xml.properties.saturation;
			tint		= xml.properties.tint;
			color		= xml.properties.color;
			threshold	= xml.properties.threshold;
			blendMode	= xml.properties.blendMode;
			time		= xml.properties.time;
			framerate	= xml.properties.framerate;
			loopStart	= xml.properties.loopStart;
			loopEnd		= xml.properties.loopEnd;
			path		= xml.@path;
			
			if (xml.controls) {
				controls = xml.controls;
			}
			
			// TBD: needs to be cleaned up
			if (xml.filters) {
				
				filters = new FilterArray(null);
				filters.loadXML(xml.filters);
			}
		}
		
		/**
		 * 	Applies values to a layer
		 */
		public function apply(content:IContent):void {
			
			content.x			= x;
			content.y			= y;
			content.scaleX		= scaleX;
			content.scaleY		= scaleY;
			content.rotation	= rotation;
			content.anchorX		= anchorX;
			content.anchorY		= anchorY;
			
			content.alpha		= alpha;
			
			content.brightness	= brightness;
			content.contrast	= contrast;
			content.saturation	= saturation;
			content.color		= color;
			content.tint		= tint;
			content.threshold	= threshold;
			content.blendMode	= blendMode;
			
			content.framerate	= framerate;
			content.loopStart	= loopStart;
			content.loopEnd		= loopEnd;
			content.time		= time;
			content.visible		= visible;
			
			// clone filters
			for each (var filter:Filter in filters) {
				content.addFilter(filter.clone());
			}
			
			// apply controls
			if (controls && content.controls) {
				
				// check what type of object "controls" is
				// type: Controls, set value to value
				// type: XML, parse the xml values
				
				// it's a control object
				if (controls is Controls) {
					
					for each (var control:Control in controls) {
						
						try {
							var targetControl:Control = content.controls.getControl(control.name);
							if ( ! (targetControl is ControlExecute) ) {
								targetControl.value = control.value;
							}
						} catch (e:Error) {
							Console.output('error setting property', control.name);
						}
					}
					
				// it's xml
				} else {
					
					var xml:XMLList = controls as XMLList;
					
					for each (var node:XML in xml.*) {
						
						try {
							var name:String = node.name();

							targetControl = content.controls.getControl(name);
							targetControl.loadXML(node);
							
						} catch (e:Error) {
							Console.output('error setting property', name);
						}
					}
				}
			}
		}
	}
}