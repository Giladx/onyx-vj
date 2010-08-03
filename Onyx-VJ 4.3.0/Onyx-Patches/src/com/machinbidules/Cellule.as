package com.machinbidules
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author tlecoz
	 */
	public class Cellule 
	{
		private var bd:BitmapData
		private var color:uint
		private var currentRadius:int = 0;
		private var radiusMax:int;
		private var w:int;
		private var h:int;
		private var initX:int;
		private var initY:int;
		public var isAlive:Boolean = true;
		
		public function Cellule(_bd:BitmapData,_picture:BitmapData,_initX:Number,_initY:Number) 
		{
			bd = _bd; 
			radiusMax = CircleBorder.radiusMax;
			w = bd.width;
			h = bd.height;
			initX = _initX;
			initY = _initY;
			
			//je détermine la couleur de chaque "cellule" en me basant sur la couleur d'un pixel d'une image se touvant au même endroit que le centre de la "cellule"
			color = _picture.getPixel32(initX,initY);
		}
		public function update():void {
			
			//si la cellule est vivant
			if(isAlive){
				
				//et que son rayon maximum n'est pas atteind
				if (currentRadius <= radiusMax) {
					//je récupère le tableau de points représentant le cercle du rayon actuel de la cellule
					var t:Vector.<Pt> = CircleBorder.radiusBorders[currentRadius] as Vector.<Pt>;
					var pt:Pt;
					var px:int, py:int;
					var b:Boolean = false;
					
					//pour chaque pixel se trouvant sur ce cercle
					for each(pt in t) {
						px = initX + pt.x;
						py = initY + pt.y;
						
						//si ce pixel est positionné dans l'image,
						if (px > 0 && py > 0 && px < w && py < h) {
							// et que la place est libre
							if (!bd.getPixel32(px, py)) {
								b = true;
								//on l'occupe !
								bd.setPixel32(px, py, color);
							}
						}
					}
					
					//et on augmente la taille du cercle
					currentRadius++;	
					
					//si aucun pixel n'a été ajouté , c'est que la cellule est prisonnière, 
					//on peut donc arreter le calcul.
					if (!b) {
						isAlive = false;
					}	
				}else {
					//si le rayon de la cellule devient trop grand, on stop son expansion.
					isAlive = false;
				}
			}
		}
	}
}