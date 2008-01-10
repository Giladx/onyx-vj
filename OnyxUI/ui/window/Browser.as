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
package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import onyx.constants.*;
	import onyx.display.LayerSettings;
	import onyx.file.*;
	import onyx.file.filters.*;
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
		private static const FILE_WIDTH:int				= 49;
		
		/** @private **/
		private static const FILE_HEIGHT:int			= 38;
		
		/** @private **/
		private static const FOLDER_HEIGHT:int			= 10;
		
		/**
		 * 	@private
		 * 	Holds the file objects
		 */
		private var _files:ScrollPane					= new ScrollPane(294, 227);
		
		/**
		 * 	@private
		 * 	Holds the folder objects
		 */
		private var _folders:ScrollPane					= new ScrollPane(91, 191, null, true);
		
		/**
		 * 	@private
		 * 	The browser files button
		 */
		private var _buttonFiles:TextButtonIcon;
		
		/**
		 * 	@private
		 * 	The browser files button
		 */
		private var _buttonCameras:TextButtonIcon;
		
		/**
		 * 	@private
		 */
		private var _buttonVisualizers:TextButtonIcon;
		
		/**
		 * 	@private
		 */
		private var _path:String;
		
		/**
		 * 	@constructor
		 */
		public function Browser(reg:WindowRegistration):void {
			
			super(reg, true, 396, 240);
			
			var options:UIOptions		= new UIOptions();
			options.width				= 90;
			
			_buttonFiles				= new TextButtonIcon(options, 'FILES', new AssetFolder()),
			_buttonCameras				= new TextButtonIcon(options, 'CAMERAS', new AssetIconCamera()),
			_buttonVisualizers			= new TextButtonIcon(options, 'VISUALIZERS', new AssetIconVisualizer());
			
			_files.x				= 2,
			_files.y				= 12,
			_folders.x				= 304,
			_folders.y				= 12,
			_buttonFiles.x			= 304,
			_buttonFiles.y			= 204,
			_buttonCameras.x		= 304,
			_buttonCameras.y		= 216,
			_buttonVisualizers.x	= 304,
			_buttonVisualizers.y	= 228;
			
			// add handlers for buttons
			_buttonFiles.addEventListener(MouseEvent.MOUSE_DOWN, _onFileDown);
			_buttonCameras.addEventListener(MouseEvent.MOUSE_DOWN, _onFileDown);
			_buttonVisualizers.addEventListener(MouseEvent.MOUSE_DOWN, _onFileDown);
			
			addChild(_folders);
			addChild(_files);
			addChild(_buttonFiles);
			addChild(_buttonCameras);
			addChild(_buttonVisualizers);
			
			// query default folder
			File.query(
				ROOT_DIR, _updateList, new SWFFilter()
			);
			// _folders.addChild();
		}
		
		/**
		 * 	@private
		 * 	Handlers for Camera/File Button
		 */
		private function _onFileDown(event:MouseEvent):void {
			
			switch (event.currentTarget) {
				case _buttonFiles:
				
					File.query(
						ROOT_DIR, _updateList, new SWFFilter()
					);
					
					break;
				case _buttonCameras:
				
					File.query('onyx-query://cameras', _updateCamera);
					
					break;
				case _buttonVisualizers:
				
					File.query('onyx-query://visualizers', _updateVisualizer);
				
					break;
			}
		}
		
		/**
		 * 	@private
		 */
		private function _updateCamera(list:FolderList):void {
			_updateList(list);
		}
		
		/**
		 * 	@private
		 */
		private function _updateVisualizer(list:FolderList):void {
			_updateList(list);
		}
		
		/**
		 * 	@private
		 * 	Clears children
		 */
		private function _clearChildren():void {
			
			// clear our controls, etc
			while (_files.numChildren) {
				var control:FileControl = _files.removeChildAt(0) as FileControl;

				// stop listening to start dragging
				control.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
				control.removeEventListener(MouseEvent.DOUBLE_CLICK, _doubleClick);

			}
			
			if (_folders.numChildren > 1) {
				
				while (_folders.numChildren > 1) {
					var folder:FolderControl = _folders.removeChildAt(1) as FolderControl;
					folder.removeEventListener(MouseEvent.MOUSE_DOWN, _onFolderDown);
				}
			}
		}
		
		/**
		 * 	@private
		 */
		private function _updateList(list:FolderList):void {
			
			// check for valid path first
			if (list) {
				
				_path = list.path;
				
				title = 'file browser: [' + list.path + ']';
	
				// kill all previous objects here
				_clearChildren();
	
				// Now we add all the new stuff for this folder;
	
				_folders.reset();
				
				var folders:Array	= list.folders;
				var len:int			= folders.length;
				var folder:Folder, foldercontrol:FolderControl;
				
				for (var index:int = 0; index < len; index++) {
	
					folder			= folders[index];
					
					foldercontrol	= new FolderControl(folder);
					foldercontrol.addEventListener(MouseEvent.MOUSE_DOWN, _onFolderDown);
					
					_folders.addChild(foldercontrol);
					
					index = _folders.getChildIndex(foldercontrol) - 1;

					foldercontrol.x = 3,
					foldercontrol.y = FOLDER_HEIGHT * index + 2;
					
				}
				
				_files.reset();
				
				var files:Array = list.files;
				index = 0;
				
				for each (var file:File in files) {
	
					var control:FileControl = new FileControl(file, file.thumbnail);
	
					// position it
					control.x = (index % FILES_PER_ROW) * FILE_WIDTH,
					control.y = ((index++ / FILES_PER_ROW) >> 0) * FILE_HEIGHT;
					
					// start listening to start dragging
					control.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
					control.addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClick);
					
					// add it to the files scrollpane
					_files.addChild(control);
				}
			}
		}
		
		/**
		 * 	@private
		 *  double click auto-loads
		 */
		private function _doubleClick(event:MouseEvent):void {
			var control:FileControl = event.target as FileControl;
			
			var target:ILayerDrop		= UIObject.selection as ILayerDrop;
			
			if (target) {

				// try to preserve settings
				if (event.ctrlKey && target.layer.path) {
					
					var settings:LayerSettings	= new LayerSettings();
					settings.load(target.layer);
				}
				
				// load
				_loadFile(target, control.path, settings);
			}
		}
		
		/**
		 * 	@private
		 *  when we start dragging
		 */
		private function _mouseDown(event:MouseEvent):void {
			
			var control:FileControl = event.currentTarget as FileControl;
			DragManager.startDrag(control, targets, _onDragOver, _onDragOut, _onDragDrop);
			
		}
		
		/**
		 * 	@private
		 *  when a folder is clicked
		 */
		private function _onFolderDown(event:MouseEvent):void {
			var control:FolderControl = event.currentTarget as FolderControl;

			File.query(control.path, _updateList, new SWFFilter(), false, true);
		}
		
		/**
		 * 	@private
		 *  drag functions
		 */
		private function _onDragOver(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.transform.colorTransform = DRAG_HIGHLIGHT;
		}
		
		/**
		 * 	@private
		 *  drag functions
		 */
		private function _onDragOut(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.transform.colorTransform = (obj === UIObject.selection) ? LAYER_HIGHLIGHT : DEFAULT;
		}
		
		/**
		 * 	@private
		 *  Drag functions
		 */
		private function _onDragDrop(event:DragEvent):void {
			var uilayer:ILayerDrop = event.currentTarget as ILayerDrop;
			var origin:FileControl = event.origin as FileControl;
			
			uilayer.transform.colorTransform = DEFAULT;

			if (event.ctrlKey && uilayer.layer.path) {
				var settings:LayerSettings = new LayerSettings();
				settings.load(uilayer.layer);
			}
			
			_loadFile(uilayer, origin.path, settings);
		}
		
		/**
		 * 	@private
		 * 	Load
		 */
		private function _loadFile(layer:ILayerDrop, path:String, settings:LayerSettings):void {
			
			layer.load(path, settings);
			UIObject.select(layer as UIObject);
		}
	}
}