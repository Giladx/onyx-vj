/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 *  
 * Based on Maillage code by tlecoz 
 * Thomas Le Coz (http://www.machinbidules.com)
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * version 4.0.503 last modified March 6th 2009
 */
package library.patches
{
	import com.machinbidules.Cellule;
	import com.machinbidules.CircleBorder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import mx.events.ToolTipEvent;
	
	import onyx.core.RenderInfo;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 *  
	 */
	public class Maillage extends Patch 
	{
		private var cellules:Vector.<Cellule> = new Vector.<Cellule>();
		private var bd:BitmapData = createDefaultBitmap();
		private var a:Number = 0;
		private var txt:TextField;
		private var _colorTransformCount:int = 30;
		private var _alphaMultiplier:Number = .9;
		private var _nbCells:int = 5000;
		private var ct:ColorTransform = new ColorTransform();
		private var pict:BitmapData	= createDefaultBitmap();
		private const source:BitmapData	= createDefaultBitmap(); 		
		private var structureIsAlive:Boolean = false;
		
		[Embed(source='./images/batchass240t.png' )] private const IMAGE_CLASS: Class;
		private const IMAGE_BMP:Bitmap = Bitmap( new IMAGE_CLASS() );
		private const IMAGE_BD:BitmapData = IMAGE_BMP.bitmapData;
		
		public function Maillage():void 
		{
			parameters.addParameters(
				new ParameterInteger('colorTransformCount', 'colorTransformCount', 1, 100, _colorTransformCount),
				new ParameterNumber('alphaMultiplier', 'alphaMultiplier', 0.01, 1, _alphaMultiplier),
				new ParameterInteger('nbCells', 'nbCells', 1, 1000000, _nbCells),
				new ParameterExecuteFunction('initAnim', 'start')
			);
			
			//j'instancie le CircleBorder pour qu'il me prepare les coordonnées des pixels
			//pas la peine de le mettre dans une variable , car je ne l'utilise pas dans cette classe
			//autrement que pour le mettre en place.
			new CircleBorder();
			
			addChild(new Bitmap(bd));
			
			addEventListener(InteractionEvent.MOUSE_DOWN, initAnim);
		}
		
		public function initAnim( e:InteractionEvent = null ):void 
		{
			bd.fillRect(bd.rect, 0x00000000);
			
			ct.alphaMultiplier = alphaMultiplier;
			
			//le bitmapData de la photo sur laquelle va se baser la couleur de chaque cellule
			var _pict:BitmapData = IMAGE_BD;
			var m:Matrix = new Matrix();
			
			var scale:Number = DISPLAY_WIDTH / _pict.height;
			
			m.scale(scale,scale);
			m.translate( -(_pict.width * scale - DISPLAY_WIDTH) / 2, 0);
			
			pict.draw(_pict, m);
			
			//j'instancie plein de cellule un peu partout
			cellules.fixed = false;
			cleanVector();
			var i:int,initX:int,initY:int;
			for (i = 0; i < nbCells; i++) {
				initX = int(Math.round(Math.random() * bd.width));
				initY = int(Math.round(Math.random() * bd.height));	
				cellules[i] = new Cellule(bd, pict,initX,initY);
			}
			cellules.fixed = true;
			structureIsAlive = true;
		}
		private function cleanVector():void
		{
			while ( cellules.length > 0 )
			{
				cellules.pop();
			}	

		}		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void 
		{
			if (structureIsAlive)
			{
				var i:int;
				//var nb:int = cellules.length;
				var b:Boolean = false;
				var cellule:Cellule;
				
				//j'update tout les cellules
				for (i = 0; i < cellules.length; i++) {
					cellule =  cellules[i] as Cellule;
					cellules[i].update();
					
					//je verifie l'etat de la structure globale
					//--> si au moins une cellule est en vie, l'animation doit continuer
					if (!structureIsAlive && cellules[i].isAlive) structureIsAlive = true;
				}
				
				//si j'appliquais l'effet de transparence en continue, les petites cellules disparaitraient trop vite
				//j'ai donc mis un compteur permettant de mieux controler cet effet
				colorTransformCount --;
				if (colorTransformCount > 0) bd.colorTransform(bd.rect, ct);

				info.source.copyPixels(bd, DISPLAY_RECT, ONYX_POINT_IDENTITY);
			}
		}
		override public function dispose():void 
		{
			cleanVector();
			cellules = null;
			removeEventListener(InteractionEvent.MOUSE_DOWN, initAnim);
		}

		public function get colorTransformCount():int
		{
			return _colorTransformCount;
		}

		public function set colorTransformCount(value:int):void
		{
			_colorTransformCount = value;
		}

		public function get alphaMultiplier():Number
		{
			return _alphaMultiplier;
		}

		public function set alphaMultiplier(value:Number):void
		{
			_alphaMultiplier = value;
		}

		public function get nbCells():int
		{
			return _nbCells;
		}

		public function set nbCells(value:int):void
		{
			_nbCells = value;
		}


	}
}