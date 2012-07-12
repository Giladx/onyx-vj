/**
 * Copyright saharan ( http://wonderfl.net/user/saharan )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/pTKv
 */

package {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import EmbeddedAssets.AssetForWater3D;
	
	/**
	 * Water 3D
	 *
	 * ãƒ»è§£èª¬ã‚³ãƒ¡ãƒ³ãƒˆã‚’ã¡ã‚‡ã£ã¨å…¥ã‚Œã¾ã—ãŸ
	 * 
	 * Click&Drag:Make wave
	 * 
	 * @author saharan
	 */
	public class Water3D extends Patch {
		private const NUM_DETAILS:int = 48;
		private const INV_NUM_DETAILS:Number = 1 / NUM_DETAILS;
		private const MESH_SIZE:Number = 100;
		private var count:uint;
		private var bmd:BitmapData;
		private var vertices:Vector.<Vertex>;
		private var transformedVertices:Vector.<Number>;
		private var indices:Vector.<int>;
		private var uvt:Vector.<Number>;
		private var width2:Number;
		private var height2:Number;
		private var heights:Vector.<Vector.<Number>>;
		private var velocity:Vector.<Vector.<Number>>;
		private var press:Boolean;
		private var mox:int = 320;
		private var moy:int = 240;
		private var sprite:Sprite;
		
		public function Water3D():void
		{
			Console.output('Water3D adapted by Bruce LANE (http://www.batchass.fr)');
			sprite = new Sprite();			
			width2 = DISPLAY_WIDTH / 2;
			height2 = DISPLAY_HEIGHT / 2;

			count = 0;

			bmd = new AssetForWater3D();

			addEventListener( MouseEvent.MOUSE_DOWN, onClick );
			addEventListener(MouseEvent.MOUSE_UP,
				function(e:Event = null):void {
					press = false;
				});
			addEventListener(MouseEvent.MOUSE_MOVE,
				function(e:MouseEvent = null):void {
					mox = e.localX; 
					moy = e.localY; 

					if (press) drag();
				});

			vertices = new Vector.<Vertex>(NUM_DETAILS * NUM_DETAILS, true);
			transformedVertices = new Vector.<Number>(NUM_DETAILS * NUM_DETAILS * 2, true);
			indices = new Vector.<int>();
			uvt = new Vector.<Number>(NUM_DETAILS * NUM_DETAILS * 2, true);
			var i:int;
			var j:int;
			// é ‚ç‚¹åˆæœŸåŒ–ã€‚å¤–å´2ã¤åˆ†ã¯è¡¨ç¤ºã—ãªã„ã®ã§ç„¡é§„ãªå‡¦ç†ï¼†ãƒ¡ãƒ¢ãƒªã«ãƒ»ãƒ»ãƒ»
			for (i = 2; i < NUM_DETAILS - 2; i++) {
				for (j = 2; j < NUM_DETAILS - 2; j++) {
					vertices[getIndex(j, i)] = new Vertex(
						(j - (NUM_DETAILS - 1) * 0.5) / NUM_DETAILS * MESH_SIZE, 0,
						(i - (NUM_DETAILS - 1) * 0.5) / NUM_DETAILS * MESH_SIZE);
					if (i != 2 && j != 2) {
						indices.push(getIndex(i - 1, j - 1), getIndex(i, j - 1), getIndex(i, j));
						indices.push(getIndex(i - 1, j - 1), getIndex(i, j), getIndex(i - 1, j));
					}
				}
			}
			// æ°´é¢é–¢ä¿‚åˆæœŸåŒ–
			heights = new Vector.<Vector.<Number>>(NUM_DETAILS, true);
			velocity = new Vector.<Vector.<Number>>(NUM_DETAILS, true);
			for (i = 0; i < NUM_DETAILS; i++) {
				heights[i] = new Vector.<Number>(NUM_DETAILS, true);
				velocity[i] = new Vector.<Number>(NUM_DETAILS, true);
				for (j = 0; j < NUM_DETAILS; j++) {
					heights[i][j] = 0;
					velocity[i][j] = 0;
				}
			}
		}
		private function onClick(event:MouseEvent):void {
			mox = event.localX; 
			moy = event.localY; 
			press = true;
		}	
		override public function render(info:RenderInfo):void 
		{
			count++;
			move();
			setMesh();
			transformVertices();
			draw();
			info.render( sprite );
		}
		
		private function setMesh():void {
			for (var i:int = 2; i < NUM_DETAILS - 2; i++) {
				for (var j:int = 2; j < NUM_DETAILS - 2; j++) {
					const index:int = getIndex(i, j);
					vertices[index].y = heights[i][j] * 0.15;
					
					// ---Sphere map---
					
					var nx:Number;
					var ny:Number;
					// nz is 1
					nx = (heights[i][j] - heights[i - 1][j]) * 0.15;
					ny = (heights[i][j] - heights[i][j - 1]) * 0.15;
					var len:Number = 1 / Math.sqrt(nx * nx + ny * ny + 1);
					nx *= len;
					ny *= len;
					// ã¡ã‚‡ã£ã¨å¼ã‚’å¤‰æ›´ã—ã¦å¹³é¢ã§ã‚‚ãƒ†ã‚¯ã‚¹ãƒãƒ£ãŒè¦‹ãˆã‚‹ã‚ˆã†ã«
					uvt[index * 2] = nx * 0.5 + 0.5 + ((i - NUM_DETAILS * 0.5) * INV_NUM_DETAILS * 0.25);
					uvt[index * 2 + 1] = ny * 0.5 + 0.5 + ((NUM_DETAILS * 0.5 - j) * INV_NUM_DETAILS * 0.25);
				}
			}
		}
		
		public function move():void {
			
			// ---Water simulation---
			
			var i:int;
			var j:int;
			/*var mmx:Number = mx / DISPLAY_WIDTH * NUM_DETAILS;
			var mmy:Number = (1 - my / DISPLAY_HEIGHT) * NUM_DETAILS;*/
			for (i = 1; i < NUM_DETAILS - 1; i++) {
				for (j = 1; j < NUM_DETAILS - 1; j++) {
					heights[i][j] += velocity[i][j];
					if (heights[i][j] > 100) heights[i][j] = 100;
					else if (heights[i][j] < -100) heights[i][j] = -100;
				}
			}
			for (i = 1; i < NUM_DETAILS - 1; i++) {
				for (j = 1; j < NUM_DETAILS - 1; j++) {
					velocity[i][j] = (velocity[i][j] +
						(heights[i - 1][j] + heights[i][j - 1] + heights[i + 1][j] +
							heights[i][j + 1] - heights[i][j] * 4) * 0.5) * 0.95;
				}
			}
		}
		
		public function drag():void {
			var i:int;
			var j:int;
			var mmx:Number = mox / DISPLAY_WIDTH * NUM_DETAILS;
			var mmy:Number = (1 - moy / DISPLAY_HEIGHT) * NUM_DETAILS;
			for (i = mmx - 3; i < NUM_DETAILS - 1 && mmx + 3; i++) {
				for (j = mmy - 3; j < NUM_DETAILS - 1 && mmy + 3; j++) {
					if (i > 1 && j > 1 && i < NUM_DETAILS - 1 && j < NUM_DETAILS - 1) {
						var len:Number = 3 - Math.sqrt((mmx - i) * (mmx - i) + (mmy - j) * (mmy - j));
						if (len < 0) len = 0;
						velocity[i][j] -= len * (press ? 1 : 5);
					}
				}
			}
		}
		
		private function draw():void {
			sprite.graphics.clear();
			sprite.graphics.beginFill(0x202020);
			sprite.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			sprite.graphics.endFill();
			sprite.graphics.beginBitmapFill(bmd);
			sprite.graphics.drawTriangles(transformedVertices, indices, uvt, TriangleCulling.POSITIVE);
			sprite.graphics.endFill();
		}
		
		private function getIndex(x:int, y:int):int {
			return y * NUM_DETAILS + x;
		}
		
		private function transformVertices():void {
			
			// xè»¸å›žè»¢ã¨ãƒ“ãƒ¥ãƒ¼å¤‰æ›ãƒ»ãƒ—ãƒ­ã‚¸ã‚§ã‚¯ã‚·ãƒ§ãƒ³å¤‰æ›ã‚’å®Ÿè¡Œ
			
			var angle:Number = 70 * Math.PI / 180;
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			for (var i:int = 0; i < vertices.length; i++) {
				var v:Vertex = vertices[i];
				if(v != null) {
					var x:Number = v.x;
					// xè??å??è??è??å??ã??ã??ã??
					var y:Number = cos * v.y - sin * v.z;
					var z:Number = sin * v.y + cos * v.z;
					// ã??ã??ã??ã??ã??ã??ã??ã??å??æ??ã??ã??ã??ã??ã??ã??ã??ã??(ã??ã??ã??ã??ã??é??ã??)
					z = 1 / (z + 60);
					// ç??æ??ã??ã??ã??ã??ã??ã??ã??ã??å??æ??
					x *= z;
					y *= z;
					// ã??ã??ã?ªã??ã??åº?æ??ã??æ??ã??ã??
					x = x * 232.5 + 232.5;
					y = y * 232.5 + 182.5;
					transformedVertices[i * 2] = x;
					transformedVertices[i * 2 + 1] = y;
				}
			}
		}
	}
}

class Vertex {
	public var x:Number;
	public var y:Number;
	public var z:Number;
	
	public function Vertex(x:Number, y:Number,z:Number) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
}