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
package onyx.display {
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
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

		public var x:int;
		public var y:int;
		public var anchorX:Number;
		public var anchorY:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:int;

		public var alpha:Number;
		public var tint:Number;
		public var color:uint;
		public var blendMode:String;
		public var visible:Boolean;
		
		public var time:Number;
		public var framerate:Number;

		public var filters:Array;
		public var controls:Object;
		public var properties:XML;

		public var loopStart:Number;
		public var loopEnd:Number;
		public var path:String;
		
		/**
		 * 	Stores midi hash values
		 */ 
		public var hashMap:Dictionary = new Dictionary(false);
		
		/**
		 * 
		 */
		public function LayerSettings():void {

			x				= 0,
			y				= 0,
			anchorX			= 0,
			anchorY			= 0,
			rotation		= 0,
			scaleX			= 1,
			scaleY			= 1,
			alpha			= 1,
			tint			= 0,
			color			= 0,
			blendMode		= 'normal',
			visible			= true,
			time			= 0,
			framerate		= 1,
			loopStart		= 0,
			loopEnd			= 1;

		}
		
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
			color		= content.color,
			tint		= content.tint,
			blendMode	= content.blendMode,
			time		= content.time,
			framerate	= content.framerate,
			loopStart	= content.loopStart,
			loopEnd		= content.loopEnd,
			visible		= content.visible,
			path		= content.path;
			filters		= [];
			
			for each (var filter:Filter in content.filters) {
				filters.push(filter.clone());	
			}
			
			if (content.controls) {
				controls = content.controls;
			}

		}
		
		/**
		 * 	Loads settings info from xml
		 */
		public function loadFromXML(xml:XML):void {
			
			var propXML:XMLList = xml.properties;
			
			var value:String;
			
			for each (var list:XML in propXML.*) {
				if (!list.hasComplexContent()) {
					try { 
						var name:String = list.name();
						value			= list.toString();
						
						switch (name) {
							case 'visible':
								visible = (value === 'true')
								break;
							default:
								this[name]	= value;
								// midi hash map build
                                hashMap[name] = list.@hash;            
								break;
						}
					} catch (e:Error) {
						Console.error(e);
					}
				} else {
					for each (var child:XML in list.*) {
						try {
							 
							name		= child.name();
							this[name]	= String(child);
																								
						} catch (e:Error) {
							Console.error(e);
						}
					}
				}
			}
			
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
			
			var targetControl:Control;
			
			content.x			= x;
			content.y			= y;
			content.scaleX		= scaleX;
			content.scaleY		= scaleY;
			content.rotation	= rotation;
			content.anchorX		= anchorX;
			content.anchorY		= anchorY;
			
		    content.alpha		= alpha;
			content.color		= color;
			content.tint		= tint;
			content.blendMode	= blendMode;
			
			content.framerate	= framerate;
			content.loopStart	= loopStart;
			content.loopEnd		= loopEnd;
			content.time		= time;
			content.visible		= visible;
						
			// clone filters
			for each (var filter:Filter in this.filters) {
				content.addFilter(filter);
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
							targetControl = content.controls.getControl(control.name);
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
		
		/**
         *  Applies midi to a layer
         */
        public function applyMidi(properties:Controls):void {
            
            var targetControl:Control;
            var xml:XML;
            
            // apply midi hash to control 
            for (var key:String in hashMap) {
               try {
                        targetControl = properties.getControl(key);
                        
                        // set midi hash
                        targetControl.hash = hashMap[key];
                        
                        xml = <{key} hash={hashMap[key]}/>
                        var value:Object = this[key];
                        xml.appendChild((value) ? value.toString() : value);
                        targetControl.loadXML(xml);
                                
               } catch (e:Error) {
                        Console.output('error setting property', key);
               }
  
            }
        }
        
	}
}