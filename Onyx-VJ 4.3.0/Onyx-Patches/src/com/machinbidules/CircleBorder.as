package com.machinbidules 
{
	
	/**
	 * ...
	 * @author tlecoz
	 */
	public class CircleBorder 
	{
		public static const radiusMax:int = 300;
		public static var radiusBorders:Vector.<Vector.<Pt>>;
		
		public function CircleBorder() 
		{
			var nbPixelMax:int =radiusMax  * 2; 
			
			
			
			radiusBorders = new Vector.<Vector.<Pt>>(nbPixelMax,true)
			
			
			var center:Number = radiusMax;
			var dx:Number;
			var dy:Number;
			var d:Number;
			
			
			//tout d'abord je créé un Vector 'radiusBorder' qui va contenir autant d'entrée que le nombre de cercles que je souhaite précalculer.
			//j'associe a chaque entrée un Vector qui va contenir les coordonnées des pixels constituant chaque cercle.
			
			var i:int, j:int;
			for (i = 0; i < nbPixelMax; i++) {
				radiusBorders[i] = new Vector.<Pt>();
			}
			
			
			
			//pour recuperer les pixels constituant chaque cercle concentrique, 
			//il suffit de calculer la distance de chaque pixel par rapport au centre sous la forme d'un int, ce qui nous donne l'index du Vector dans lequel ajouter le point. Et c'est tout !
			
			
			for (i = 0; i < nbPixelMax; i ++) {
				for (j = 0; j < nbPixelMax; j++) {
					dx = i - center;
					dy = j - center;				
					d = Math.floor(Math.sqrt(dx * dx + dy * dy));
					radiusBorders[d].push( new Pt(center - i, center - j));
				}
			}
			
			for (i = 0; i < nbPixelMax; i++) {
				radiusBorders[i].fixed = true;
			}
			
			
		}
	}
}