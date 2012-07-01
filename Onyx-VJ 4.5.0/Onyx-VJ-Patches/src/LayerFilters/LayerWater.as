/**
 * 25-Line ActionScript Contest Entry
 *
 * Project: Fire
 * Author:  Bruce Jawn   (http://bruce-lab.blogspot.com/)
 * Date:    2009-1-10
 */
package LayerFilters
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class LayerWater extends Patch implements IRenderObject, IParameterObject
	{
		private var num_details:int = 48;//48;
		private var inv_num_details:Number = 1 / num_details;
		private var _mesh_size:Number = 200;//100;
		private var count:uint;
		private var bmd:BitmapData;
		private var lastTime:int;
		
		public var delay:int	= 0;
		public var blend:String	= 'normal';
		public var time:int		= 100;
		
		public var layer:Layer;
		
		private var frames:Array	= [];
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
		
		public function LayerWater():void
		{
			Console.output('LayerWater');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterInteger('time', 'time', 1, 2000, time),
				new ParameterInteger('delay', 'delay', 0, 24, 0),						
				new ParameterInteger('mesh_size', 'mesh_size', 1, 500, mesh_size),			
				new ParameterExecuteFunction('capture', 'capture')
			);			

			sprite = new Sprite();			
			width2 = DISPLAY_WIDTH / 2;
			height2 = DISPLAY_HEIGHT / 2;
			
			count = 0;
			
			//bmd = new AssetForWater3D();
			bmd = createDefaultBitmap();
			Console.output("LayerWater, bmd.width: "+bmd.width);
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
			
			vertices = new Vector.<Vertex>(num_details * num_details, true);
			transformedVertices = new Vector.<Number>(num_details * num_details * 2, true);
			indices = new Vector.<int>();
			uvt = new Vector.<Number>(num_details * num_details * 2, true);
			var i:int;
			var j:int;
			// é ‚ç‚¹åˆæœŸåŒ–ã€‚å¤–å´2ã¤åˆ†ã¯è¡¨ç¤ºã—ãªã„ã®ã§ç„¡é§„ãªå‡¦ç†ï¼†ãƒ¡ãƒ¢ãƒªã«ãƒ»ãƒ»ãƒ»
			for (i = 2; i < num_details - 2; i++) {
				for (j = 2; j < num_details - 2; j++) {
					vertices[getIndex(j, i)] = new Vertex(
						(j - (num_details - 1) * 0.5) / num_details * mesh_size, 0,
						(i - (num_details - 1) * 0.5) / num_details * mesh_size);
					if (i != 2 && j != 2) {
						indices.push(getIndex(i - 1, j - 1), getIndex(i, j - 1), getIndex(i, j));
						indices.push(getIndex(i - 1, j - 1), getIndex(i, j), getIndex(i - 1, j));
					}
				}
			}
			// æ°´é¢é–¢ä¿‚åˆæœŸåŒ–
			heights = new Vector.<Vector.<Number>>(num_details, true);
			velocity = new Vector.<Vector.<Number>>(num_details, true);
			for (i = 0; i < num_details; i++) {
				heights[i] = new Vector.<Number>(num_details, true);
				velocity[i] = new Vector.<Number>(num_details, true);
				for (j = 0; j < num_details; j++) {
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
		public function capture():void 
		{
			if (layer && layer.source) 
			{
				var source:BitmapData	= layer.source;
				var matrix:Matrix = new Matrix();
				
				source.draw(layer.source, matrix, null, null, null, true);	
				bmd = source.clone();
			}
		}
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void 
		{			
			var timer:int	= getTimer();
			var ms:int		= timer - lastTime;
			if (ms >= time) 
			{
				var ratio:Number = 1;
				lastTime = timer;
				capture();
			} 
			else
			{
				ratio = ms / time; 
			}
			
			if (layer && layer.source) 
			{				
				if (delay > 0) 
				{				
					frames.push(layer.source.clone());
					if (frames.length > 100) 
					{
						var b:BitmapData = frames.shift() as BitmapData;
						b.dispose();
					}
				}
				
				count++;
				move();
				setMesh();
				transformVertices();
				draw();
				info.render( sprite );
			}			
		}
		private function draw():void 
		{
			sprite.graphics.clear();
			sprite.graphics.beginBitmapFill(bmd);
			sprite.graphics.drawTriangles(transformedVertices, indices, uvt, TriangleCulling.POSITIVE);
			sprite.graphics.endFill();
		}		
		private function setMesh():void {
			for (var i:int = 2; i < num_details - 2; i++) {
				for (var j:int = 2; j < num_details - 2; j++) {
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
					uvt[index * 2] = nx * 0.5 + 0.5 + ((i - num_details * 0.5) * inv_num_details * 0.25);
					uvt[index * 2 + 1] = ny * 0.5 + 0.5 + ((num_details * 0.5 - j) * inv_num_details * 0.25);
				}
			}
		}
		
		public function move():void {
			
			// ---Water simulation---
			
			var i:int;
			var j:int;
			for (i = 1; i < num_details - 1; i++) {
				for (j = 1; j < num_details - 1; j++) {
					heights[i][j] += velocity[i][j];
					if (heights[i][j] > 100) heights[i][j] = 100;
					else if (heights[i][j] < -100) heights[i][j] = -100;
				}
			}
			for (i = 1; i < num_details - 1; i++) {
				for (j = 1; j < num_details - 1; j++) {
					velocity[i][j] = (velocity[i][j] +
						(heights[i - 1][j] + heights[i][j - 1] + heights[i + 1][j] +
							heights[i][j + 1] - heights[i][j] * 4) * 0.5) * 0.95;
				}
			}
		}
		
		public function drag():void {
			var i:int;
			var j:int;
			var mmx:Number = mox / DISPLAY_WIDTH * num_details;
			var mmy:Number = (1 - moy / DISPLAY_HEIGHT) * num_details;
			for (i = mmx - 3; i < num_details - 1 && mmx + 3; i++) {
				for (j = mmy - 3; j < num_details - 1 && mmy + 3; j++) {
					if (i > 1 && j > 1 && i < num_details - 1 && j < num_details - 1) {
						var len:Number = 3 - Math.sqrt((mmx - i) * (mmx - i) + (mmy - j) * (mmy - j));
						if (len < 0) len = 0;
						velocity[i][j] -= len * (press ? 1 : 5);
					}
				}
			}
		}
		
		private function getIndex(x:int, y:int):int {
			return y * num_details + x;
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
					//z = 1 / (z + 100);
					// ç??æ??ã??ã??ã??ã??ã??ã??ã??ã??å??æ??
					x *= z;
					y *= z;
					// ã??ã??ã?ªã??ã??åº?æ??ã??æ??ã??ã??
					x = x * DISPLAY_WIDTH/2 + DISPLAY_WIDTH/2;//232.5 + 232.5;
					y = y * DISPLAY_HEIGHT/2 + DISPLAY_HEIGHT/2; //232.5 + 182.5;
					transformedVertices[i * 2] = x;
					transformedVertices[i * 2 + 1] = y;
				}
			}
		}
		public function get mesh_size():Number
		{
			return _mesh_size;
		}
		
		public function set mesh_size(value:Number):void
		{
			_mesh_size = value;
		}
		/**
		 * 
		 */
		override public function dispose():void 
		{
			while (frames.length) 
			{
				var data:BitmapData = frames.shift() as BitmapData;
				data.dispose();
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
