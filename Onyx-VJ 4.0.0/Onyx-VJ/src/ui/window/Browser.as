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
package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import onyx.asset.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.controls.browser.*;
	import ui.core.*;
	import ui.events.*;
	import ui.layer.*;
	import ui.styles.*;
	import ui.text.*;

	/**
	 * 	File Explorer
	 */
	public final class Browser extends Window {
		
		/**
		 * 	
		 */
		public static var useTransition:Transition;
		
		/**
		 * 	@private
		 * 	An array of targets you can drag filters to
		 */
		private static const targets:Dictionary			= new Dictionary(true);

		/**
		 * 	Registers a UIObject to be a target of a Browser drag
		 */
		public static function registerTarget(obj:UIObject, enable:Boolean):void {
			(enable) ? targets[obj] = obj : delete targets[obj];
		}
		
		/**
		 * 	The root directory the browser should look in
		 */
		public static var ROOT_DIR:String;

		/** @private **/
		private static const FILES_PER_ROW:int			= 6;
		
		/** @private **/
		private static const FILE_WIDTH:int				= THUMB_WIDTH + 1;
		
		/** @private **/
		private static const FILE_HEIGHT:int			= THUMB_HEIGHT + 1;
		
		/** @private **/
		private static const FOLDER_HEIGHT:int			= 10;
		
		/**
		 * 	@private
		 * 	Holds the file objects
		 */
		private const files:ScrollPane					= new ScrollPane(400, 196);
		
		/**
		 * 	@private
		 * 	Holds the folder objects
		 */
		private const folders:ScrollPane				= new ScrollPane(81, 173);
		
		/**
		 * 	@private
		 * 	The browser files button
		 */
		private var buttonFiles:TextButtonIcon;
		
		/**
		 * 	@private
		 * 	The browser files button
		 */
		private var buttonCameras:TextButtonIcon;
		
		/**
		 * 	@private
		 */
		private var _path:String;
		
		/**
		 * 	@constructor
		 */
		public function Browser(reg:WindowRegistration):void {
			
			super(reg, true, 499, 217);
			
			init();

		}
		
		/**
		 * 	@private
		 */
		private function init():void {
			
			// draw the pane background
			var bmp:BitmapData			= (getChildAt(0) as Bitmap).bitmapData;
			bmp.fillRect(new Rectangle(417,15,81, super.height - 17), 0xFF131e28);
			
			// arrange everything else
			var options:UIOptions	= new UIOptions();
			options.width			= 82;
			
			buttonFiles				= new TextButtonIcon(options, 'FILES', new AssetFolder()),
			buttonCameras			= new TextButtonIcon(options, 'CAMERAS', new AssetIconCamera()),
			
			files.x					= 4,
			files.y					= 17,
			folders.x				= 417,
			folders.y				= 15,
			buttonFiles.x			= 417,
			buttonFiles.y			= 192,
			buttonCameras.x			= 417,
			buttonCameras.y			= 204;
			
			// add handlers for buttons
			buttonFiles.addEventListener(MouseEvent.MOUSE_DOWN, fileDown);
			buttonCameras.addEventListener(MouseEvent.MOUSE_DOWN, fileDown);
			
			addChild(folders);
			addChild(files);
			addChild(buttonFiles);
			addChild(buttonCameras);
			
			// query default folder
			OnyxFile.queryDirectory(
				ONYX_LIBRARY_PATH, updateList
			);
		}
		
		/**
		 * 	@private
		 */
		private function updateList(query:AssetQuery, list:Array):void {
			
			// check for valid path first
			if (query) {
				
				_path = query.path;
	
				// kill all previous objects here
				_clearChildren();
	
				// Now we add all the new stuff for this folder;
	
				folders.reset();
				
				var control:DisplayObject, index:int;
				
				// reset location
				files.reset();
				folders.reset();
				
				for each (var asset:OnyxFile in list) {
				
					if (asset.isDirectory) {
						
						// add and position
						control		= folders.addChild(new FolderControl(asset, asset.path.length < _path.length));

						index		= folders.getChildIndex(control);

						control.x	= 0,
						control.y	= FOLDER_HEIGHT * index;

						control.addEventListener(MouseEvent.MOUSE_DOWN, folderDown);
						
					} else {
						
						control 	= files.addChild(new FileControl(asset, asset.thumbnail));
						index		= files.getChildIndex(control);
		
						// position it
						control.x	= (index % FILES_PER_ROW) * FILE_WIDTH,
						control.y	= ((index++ / FILES_PER_ROW) >> 0) * FILE_HEIGHT;
						
						// start listening to start dragging
						control.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
						control.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);
					}
					
				}
			}
		}
		
		/**
		 * 	@private
		 * 	Handlers for Camera/File Button
		 */
		private function fileDown(event:MouseEvent):void {
			
			switch (event.currentTarget) {
				case buttonFiles:

					OnyxFile.queryDirectory(ONYX_LIBRARY_PATH, updateList);
					
					break;
				case buttonCameras:
				
					OnyxFile.queryDirectory('onyx-query://cameras', updateList);
					
					break;
			}
		}
		
		
		/**
		 * 	@private
		 * 	Clears children
		 */
		private function _clearChildren():void {
			
			// clear our controls, etc
			while (files.numChildren) {
				var control:FileControl = files.removeChildAt(0) as FileControl;

				// stop listening to start dragging
				control.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				control.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);

			}
			
			if (folders.numChildren > 0) {
				
				while (folders.numChildren > 0) {
					var folder:FolderControl = folders.removeChildAt(0) as FolderControl;
					folder.removeEventListener(MouseEvent.MOUSE_DOWN, folderDown);
				}
			}
		}
		
		/**
		 * 
		 */
		public function updateFolders():void {
			
			// query default folder
			OnyxFile.queryDirectory(_path, updateList);
			
		}
		
		/**
		 * 	@private
		 *  double click auto-loads
		 */
		private function doubleClick(event:MouseEvent):void {
			var control:FileControl = event.target as FileControl;
			
			var target:ILayerDrop		= UIObject.selection as ILayerDrop;
			
			if (target) {

				// try to preserve settings
				if (event.ctrlKey && target.layer.path) {
					
					var settings:LayerSettings	= new LayerSettings();
					settings.load(target.layer);
				}
				
				// load
				_loadFile(target, control.asset, settings);
			}
		}
		
		/**
		 * 	@private
		 *  when we start dragging
		 */
		private function mouseDown(event:MouseEvent):void {
			
			var control:FileControl = event.currentTarget as FileControl;
			DragManager.startDrag(control, targets, dragOver, dragOut, dragDrop);
			
		}
		
		/**
		 * 	@private
		 *  when a folder is clicked
		 */
		private function folderDown(event:MouseEvent):void {
			var control:FolderControl = event.currentTarget as FolderControl;
			OnyxFile.queryDirectory(control.asset.path, updateList);
		}
		
		/**
		 * 	@private
		 *  drag functions
		 */
		private function dragOver(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.transform.colorTransform = DRAG_HIGHLIGHT;
		}
		
		/**
		 * 	@private
		 *  drag functions
		 */
		private function dragOut(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.transform.colorTransform = (obj === UIObject.selection) ? LAYER_HIGHLIGHT : DEFAULT;
		}
		
		/**
		 * 	@private
		 *  Drag functions
		 */
		private function dragDrop(event:DragEvent):void {
			var uilayer:ILayerDrop = event.currentTarget as ILayerDrop;
			var origin:FileControl = event.origin as FileControl;
			
			uilayer.transform.colorTransform = DEFAULT;

			if (event.ctrlKey && uilayer.layer.path) {
				var settings:LayerSettings = new LayerSettings();
				settings.load(uilayer.layer);
			}
			
			_loadFile(uilayer, origin.asset, settings);
		}
		
		/**
		 * 	@private
		 * 	Load
		 */
		private function _loadFile(layer:ILayerDrop, asset:OnyxFile, settings:LayerSettings):void {
			
			switch (asset.extension) {
				case 'xml':
				case 'mix':
				case 'onx':
					(Display as OutputDisplay).load(asset.path, layer.layer, useTransition);
					return;
				default:
					layer.layer.load(asset.path, settings, useTransition);
					break;
			}
			
			UIObject.select(layer as UIObject);
		}
	}
}