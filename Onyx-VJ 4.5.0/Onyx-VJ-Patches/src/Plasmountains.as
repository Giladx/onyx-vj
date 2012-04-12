/**
 * Copyright Madore.Jean-S.bastien ( http://wonderfl.net/user/Madore.Jean-S.bastien )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/qmtM
 */

// forked from yonatan's Plasmountains
package {
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Plasmountains extends Patch 
	{
		private static const SIZE:int = 32;
		private static const OCTAVES:int = 5;
		
		private var vertices:Vector.<Number> = new Vector.<Number>(SIZE*SIZE*3, true);
		private var projected:Vector.<Number> = new Vector.<Number>(0, false);
		private var uvtData:Vector.<Number> = new Vector.<Number>(SIZE*SIZE*3, true);
		private var heightMap:BitmapData = new BitmapData(SIZE, SIZE, false);
		private var indices:Vector.<int> = new Vector.<int>((SIZE-1)*(SIZE-1)*6, true);
		private var tmpBmd1:BitmapData = new BitmapData(SIZE, SIZE);
		private var texture:BitmapData = new BitmapData(SIZE, SIZE);
		private var projection:PerspectiveProjection = new PerspectiveProjection();
		private var viewport:Shape = new Shape();
		
		//private var stats:Sprite = new Sprite;
		private var sprite:Sprite;
		
		public function Plasmountains() {
			sprite = new Sprite();
			//addChild(sprite);
			
			viewport.x = viewport.y = DISPLAY_HEIGHT / 2;
			sprite.addChild(viewport);
			projection.fieldOfView = 20;
			
			/*stats.addChild(new Bitmap(heightMap));
			stats.addChild(new Bitmap(tmpBmd1)).y=SIZE*1.1;
			stats.addChild(new Bitmap(texture)).y=SIZE*2.2;
			sprite.addChild(stats).visible = true;*/
		}
		
		override public function render(info:RenderInfo):void 
		{			
			var offsets:Array = [];
			var offset:Number = -getTimer()/100;
			
			for(var i:uint = 0; i < OCTAVES; i++) {
				offsets.push(new Point(0, offset/(i+1)));
			}
			
			heightMap.perlinNoise(SIZE, SIZE, OCTAVES, 16, true, false, 
				BitmapDataChannel.RED | BitmapDataChannel.GREEN | BitmapDataChannel.BLUE, true,
				offsets);
			texture.perlinNoise(SIZE, SIZE, OCTAVES, 3, false, false,
				BitmapDataChannel.RED | BitmapDataChannel.GREEN | BitmapDataChannel.BLUE, false,
				offsets);
			
			// "shadows" in valleys
			tmpBmd1.draw(heightMap)
			tmpBmd1.draw(heightMap, null, null, "screen");
			texture.draw(tmpBmd1, null, null, "multiply");
			
			// generate vertices, uvtdata and indices
			i = 0;
			var ii:uint = 0; // indices index
			for(var y:int = 0; y < SIZE; y++) {
				for(var x:int = 0; x < SIZE; x++) {
					vertices[i]  = -(x*2-SIZE);
					uvtData[i++] = x/SIZE;
					vertices[i]  = ((heightMap.getPixel(x,y) & 0xFF) - 0x80) / 0x80 * SIZE;
					uvtData[i++] = y/SIZE;
					vertices[i]  = y*2-SIZE;
					uvtData[i++] = 0;
					
					if(x < SIZE-1 && y < SIZE-1) {
						var i1:uint = y*SIZE+x;
						var i2:uint = i1+SIZE;
						
						indices[ii++]=i1;
						indices[ii++]=i1+1;
						indices[ii++]=i2;
						indices[ii++]=i1+1;
						indices[ii++]=i2+1;
						indices[ii++]=i2;
					}
				}
			}
			
			// project
			var m:Matrix3D = new Matrix3D;
			m.appendScale(.6,.4,.6);
			m.appendRotation(38, Vector3D.X_AXIS);
			m.appendTranslation(0,-SIZE/8,-SIZE*2.3);
			m.append(projection.toMatrix3D());
			Utils3D.projectVectors(m, vertices, projected, uvtData);
			
			viewport.graphics.clear();
			//viewport.graphics.lineStyle(1, 0, 0.25);
			viewport.graphics.beginBitmapFill(texture, null, false, true);
			viewport.graphics.drawTriangles(projected, indices, uvtData);
			viewport.graphics.endFill();
			info.render( sprite );	
		}
	}
}