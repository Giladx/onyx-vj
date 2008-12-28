/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package onyx.display {
	
	import flash.events.EventDispatcher;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	[ExcludeClass]

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
		
		public var brightness:Number
		public var contrast:Number;
		public var saturation:Number;
		public var hue:Number; 

		public var alpha:Number;
		public var blendMode:String;
		public var visible:Boolean;
		
		public var time:Number;
		public var framerate:Number;

		public var filters:Array;
		public var parameters:Object;
		public var properties:XML;

		public var loopStart:Number;
		public var loopEnd:Number;
		public var path:String;
		
		/**
		 * 
		 */
		public function LayerSettings():void {

			x				= 0,
			y				= 0,
			anchorX			= 0.5,
			anchorY			= 0.5,
			rotation		= 0,
			scaleX			= 1,
			scaleY			= 1,
			alpha			= 1,
			brightness		= 0,
			contrast		= 0,
			saturation		= 1,
			hue				= 0,
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
		public function load(content:Content):void {
			
			x			= content.x,
			y			= content.y,
			scaleX		= content.scaleX,
			scaleY		= content.scaleY,
			rotation	= content.rotation,
			alpha		= content.alpha,
			brightness	= content.brightness,
			contrast	= content.contrast,
			saturation	= content.saturation,
			hue			= content.hue,
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
			
			parameters = content.getParameters();
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
			
			if (xml.parameters) { 
				parameters = xml.parameters;
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
		public function apply(content:Content):void {
			
			var targetControl:Parameter;
			
			content.x			= x,
			content.y			= y,
			content.scaleX		= scaleX,
			content.scaleY		= scaleY,
			content.rotation	= rotation,
			content.anchorX		= anchorX,
			content.anchorY		= anchorY,
		    content.alpha		= alpha,
			content.brightness	= brightness,
			content.contrast	= contrast,
			content.saturation	= saturation,
			content.hue			= hue,
			content.blendMode	= blendMode,
			content.framerate	= framerate,
			content.loopStart	= loopStart,
			content.loopEnd		= loopEnd,
			content.time		= time,
			content.visible		= visible;
						
			// clone filters
			for each (var filter:Filter in this.filters) {
				content.addFilter(filter);
			}
			            
			// apply parameters
			if (parameters && content.getParameters()) {
								
				// check what type of object "parameters" is
				// type: parameters, set value to value
				// type: XML, parse the xml values
				
				// it's a control object
				if (parameters is Parameters) {
					for each (var control:Parameter in parameters) {
						if (control) {
							try {
								targetControl = content.getParameters().getParameter(control.name);
								if ( ! (targetControl is ParameterExecuteFunction) ) {
									targetControl.value = control.value;
								}
							} catch (e:Error) {
								Console.output('error setting property', control.name, e.message);
							}
						}
					}
					
				// it's xml
				} else {
					
					
					var xml:XMLList = parameters as XMLList;
					for each (var node:XML in xml.*) {
						try {
							var name:String = node.name();
							targetControl = content.getParameters().getParameter(name);
							targetControl.loadXML(node);
							
						} catch (e:Error) {
							Console.output('error setting property', name, e.message);
						}
					}
				}
				            
			}
		}
		        
	}
}