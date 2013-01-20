/**
 * Copyright o8que ( http://wonderfl.net/user/o8que )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/e2LB
 */

package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.core.RenderInfo;
	import onyx.plugin.*;
	
	public class CrossTownTraffic extends Patch {		
		public static const MAP_SIZE:int = 33;
		public static const NODE_SIZE:int = 15;
		
		// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??
		public static var nodes:Array;
		public static var particles:Array;
		private var _starts:Array;
		private var _goals:Array;
		
		// ã??ã??ã??ã??ã??ã??ã??å??ã??ã??ã??ã??ã??ã??è??ç?ºã?ªã??ã??ã??ã??ã??é??ä??
		private var _particleCanvas:BitmapData;
		private var _canvasRect:Rectangle;
		private var _colorTransform:ColorTransform;
		private var _wallLayer:Sprite;
		private var _cursor:Shape;
		
		public function CrossTownTraffic() {
			// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??å??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??é??ã??å??æ??å??
			initializeNodes();
			initializeParticles();
			initializeWalls();
			initializeStreams();	
			
			initializeCursor();
			
		}
		
		// ã??ã??ã??ã??å??æ??å??
		private function initializeNodes():void {
			nodes = [];
			for (var row:int = 0; row < MAP_SIZE; row++) {
				nodes[row] = [];
				for (var col:int = 0; col < MAP_SIZE; col++) {
					nodes[row][col] = new Node(col, row);
				}
			}
		}
		
		// ã??ã??ã??ã??ã??ã??ã??å??æ??å??
		private function initializeParticles():void {
			Particle.createImages();
			
			var numParticles:int = Parameter.numParticles;
			particles = new Array(numParticles);
			for (var i:int = 0; i < numParticles; i++){
				particles[i]= new Particle();
			}
			
			var particleLayer:Bitmap = new Bitmap();
			_particleCanvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x000000);
			particleLayer.bitmapData = _particleCanvas;
			addChild(particleLayer);
			
			_canvasRect = new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			_colorTransform = new ColorTransform(0.9, 0.9, 0.9);
		}
		
		// å??ã??å??æ??å??
		private function initializeWalls():void {
			_wallLayer = new Sprite();
			var walls:Array = Parameter.getWalls();
			var len:int = int(walls.length);
			for (var i:int = 0; i < len; i++) {
				_wallLayer.addChild(walls[i]);
			}
			addChild(_wallLayer);
		}
		
		// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??å??æ??å??
		private function initializeStreams():void {
			_goals = Parameter.getGoals();
			_starts = Parameter.getStarts(_goals);
			Start.setSpawnInterval();
			
			// ã??ã??ã??ã??ã??ã??ã??å?ºç??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??
			shuffle(_starts);
		}
		
		// é??å??ã??ã??ã??ã??ã??ã??ã??ã??
		private function shuffle(arr:Array):void {
			var i:int = arr.length;
			while (i) {
				var j:int = Math.floor(i * Math.random());
				var tmp:* = arr[--i];
				arr[i] = arr[j];
				arr[j] = tmp;
			}
		}
		
		// ã??ã??ã??ã??ã??å??æ??å??
		private function initializeCursor():void {
			_cursor = new Shape();
			_cursor.graphics.lineStyle(1, 0xffff00);
			_cursor.graphics.drawRect(0, 0, NODE_SIZE * 2 - 0.5, NODE_SIZE * 2 - 0.5);
			addChild(_cursor);
			
			addEventListener(MouseEvent.MOUSE_MOVE, moveCursor);
			addEventListener(MouseEvent.MOUSE_UP, clickMap);
		}
		
		// ã??ã??ã??ã??ã??ç??å??
		private function moveCursor(e:MouseEvent):void {
			_cursor.x = e.localX - (e.localX % NODE_SIZE);
			_cursor.y = e.localY - (e.localY % NODE_SIZE);
		}
		
		// ã??ã??ã??ã??ã?ªã??ã??æ??ã??æ??å??
		private function clickMap(e:MouseEvent):void {
			var wall:Wall;
			
			// ã??ã?ªã??ã??ã??ã??å??æ??ã??é??å??ã??ã??ã??å??ã?ªã??é??å??ã??ã??
			if (e.target is Wall) {
				wall = e.target as Wall;
				if (wall.removable) {
					wall.remove();
					reSearchGoals();
				}
				// ã??ã?ªã??ã??ã??ã??å??æ??ã??å??ã??è??ç??ã??ã??ã??ã?ªã??è??ç??ã??ã??
			}else {
				var tile:Point = Node.tileFormPos(new Point(e.localX, e.localY));
				if (buildableWall(tile.x, tile.y)) {
					wall = new Wall(tile.x, tile.y);
					_wallLayer.addChild(wall);
					reSearchGoals();
				}
			}
		}
		
		// å??ã??ã??ã??ã??ã??ã??ã??ã??ã??æ??æ??ï??çµ?è??ã??æ??æ??ç??ï??ã??ã??ã??
		private function reSearchGoals():void {
			var len:int = _goals.length;
			for (var i:int = 0; i < len; i++) {
				_goals[i].search();
			}
		}
		
		// æ??å??ã??ã??ä??ç??ã??å??ã??è??ç??ã??ã??ã??ã??
		private function buildableWall(tilex:int, tiley:int):Boolean {
			return (nodes[tiley][tilex].passable &&
				nodes[tiley][tilex + 1].passable &&
				nodes[tiley + 1][tilex].passable &&
				nodes[tiley + 1][tilex + 1].passable);
		}
		
		// æ??ã??ã??ã??ã??ã??æ??æ??å??ç??
		override public function render(info:RenderInfo):void {
			spawnParticles();	
			updateParticles();
			info.render(_particleCanvas);
		}
		
		// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??å?ºç??ã??ã??ã??
		private function spawnParticles():void {
			var numStarts:int = _starts.length;
			for (var i:int = 0; i < numStarts; i++) {
				_starts[i].update();
			}
		}
		
		// ã??ã??ã??ã??ã??ã??ã??æ??æ??ã??è??ã??
		private function updateParticles():void {
			_particleCanvas.lock();
			for (var i:int = 0; i < Parameter.numParticles; i++) {
				// ã??ã??ã??ã??ã??ã??ã??ç??é??å??ã??å??å??ã??ã??ã??ã??ã??æ??æ??
				if(particles[i].exists){
					particles[i].update();
					particles[i].draw(_particleCanvas);
				}
			}
			_particleCanvas.colorTransform(_canvasRect, _colorTransform);
			_particleCanvas.unlock();
		}
	}
}

import flash.display.Shape;
import flash.geom.Point;

class Node {
	private var _tilex:int;
	private var _tiley:int;
	private var _centerx:Number;
	private var _centery:Number;
	private var _passable:Boolean;
	
	public function get tileX():int { return _tilex; }
	public function get tileY():int { return _tiley; }
	public function get centerX():Number { return _centerx; }
	public function get centerY():Number { return _centery; }
	public function get passable():Boolean { return _passable; }
	public function set passable(arg:Boolean):void { _passable = arg; }
	
	public function Node(tilex:int, tiley:int) {
		_tilex = tilex;
		_tiley = tiley;
		var pos:Point = Node.posFromTile(new Point(_tilex, _tiley));
		_centerx = pos.x + (CrossTownTraffic.NODE_SIZE / 2);
		_centery = pos.y + (CrossTownTraffic.NODE_SIZE / 2);
		_passable = true;
	}
	
	// ã??ã??ã??ç??æ?ªå??ã??ã??XYåº?æ??å??ã??æ??ã??ã??
	public static function posFromTile(tile:Point):Point {
		var pos:Point = new Point();
		
		pos.x = (tile.x * CrossTownTraffic.NODE_SIZE) - CrossTownTraffic.NODE_SIZE;
		if (pos.x < -CrossTownTraffic.NODE_SIZE) {
			pos.x = -CrossTownTraffic.NODE_SIZE;
		}else if (pos.x > (CrossTownTraffic.NODE_SIZE * (CrossTownTraffic.MAP_SIZE - 1))) {
			pos.x = (CrossTownTraffic.NODE_SIZE * (CrossTownTraffic.MAP_SIZE - 1));
		}
		
		pos.y = (tile.y * CrossTownTraffic.NODE_SIZE) - CrossTownTraffic.NODE_SIZE;
		if (pos.y < -CrossTownTraffic.NODE_SIZE) {
			pos.y = -CrossTownTraffic.NODE_SIZE;
		}else if (pos.y > (CrossTownTraffic.NODE_SIZE * (CrossTownTraffic.MAP_SIZE - 1))) {
			pos.y = (CrossTownTraffic.NODE_SIZE * (CrossTownTraffic.MAP_SIZE - 1));
		}
		
		return pos;
	}
	
	// XYåº?æ??å??ã??ã??ã??ã??ã??ç??æ?ªå??ã??æ??ã??ã??
	public static function tileFormPos(pos:Point):Point {
		var tile:Point = new Point();
		
		tile.x = Math.floor(pos.x / CrossTownTraffic.NODE_SIZE) + 1;
		if (tile.x < 0) {
			tile.x = 0;
		}else if (tile.x > CrossTownTraffic.MAP_SIZE - 1) {
			tile.x = CrossTownTraffic.MAP_SIZE - 1;
		}
		
		tile.y = Math.floor(pos.y / CrossTownTraffic.NODE_SIZE) + 1;
		if (tile.y < 0) {
			tile.y = 0;
		}else if (tile.y > CrossTownTraffic.MAP_SIZE - 1) {
			tile.y = CrossTownTraffic.MAP_SIZE - 1;
		}
		
		return tile;
	}
}

import flash.display.Sprite;
import flash.geom.Point;

class Wall extends Sprite {
	private var _tilex:int;
	private var _tiley:int;
	private var _removable:Boolean;
	
	public function get removable():Boolean { return _removable; }
	
	public function Wall(tilex:int, tiley:int, removable:Boolean = true) {
		_tilex = tilex;
		_tiley = tiley;
		var pos:Point = Node.posFromTile(new Point(_tilex, _tiley));
		this.x = pos.x;
		this.y = pos.y;
		_removable = removable;
		
		setNodePassablity(false);
		draw();
	}
	
	// å??ã??è??ç??ã??ã??é??å??ã??ã??ã??ã??ã??é??è??å??è??æ??ã??å??æ??ã??ã??
	private function setNodePassablity(passable:Boolean):void {
		CrossTownTraffic.nodes[_tiley][_tilex].passable = passable;
		CrossTownTraffic.nodes[_tiley][_tilex + 1].passable = passable;
		CrossTownTraffic.nodes[_tiley + 1][_tilex].passable = passable;
		CrossTownTraffic.nodes[_tiley + 1][_tilex + 1].passable = passable;
	}
	
	// å??ã??ç??å??ã??æ??ç??ã??ã??
	private function draw():void {
		var rectSize:Number = CrossTownTraffic.NODE_SIZE * 2;
		
		if (_removable) {
			rectSize -= 0.5;
			graphics.lineStyle(1, 0x222222);
		}
		
		graphics.beginFill(0x111111);
		graphics.drawRect(0, 0, rectSize, rectSize);
		graphics.endFill();
	}
	
	// å??ã??å??ã??é??ã??é??ã??å??ã??é??æ??
	public function remove():void {
		setNodePassablity(true);
		parent.removeChild(this);
	}
}


import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class Particle {
	private static const IMAGE_COLORS:Array =
		[0x0000ff, 0x3333ff, 0x6666ff, 0x9999ff, 0xccccff, 0xffffff,
			0x0033ff, 0x0066ff, 0x0099ff, 0x00ccff, 0x00ffff,
			0x33ffff, 0x66ffff, 0x99ffff, 0xccffff];
	private static var IMAGE_RADIUS:int;
	
	private var _posx:Number;
	private var _posy:Number;
	private var _vx:Number;
	private var _vy:Number;
	
	private var _speed:Number;
	private var _exists:Boolean;
	private var _start:Start;
	
	private static var _images:Array;
	private var _imageIndex:int;
	private static var _sourceRect:Rectangle;
	
	public function get exists():Boolean { return _exists; }
	
	public function Particle() {
		_posx = _posy = _vx = _vy = 0;
		_speed = ((Parameter.particleMaxSpeed - 1) * Math.random()) + 1;
		_exists = false;
		_start = null;
		_imageIndex = 0;
	}
	
	// ã??ã??ã??ã??ã??ã??ã??ã??ã??å?ºç??ã??ã??ã??
	public function spawn(start:Start):void {
		_posx = start.node.centerX;
		_posy = start.node.centerY;
		_exists = true;
		_start = start;
		_imageIndex = Math.floor(Particle.IMAGE_COLORS.length * Math.random());
	}
	
	public function update():void {
		_posx += _vx;
		_posy += _vy;
		
		var tile:Point = Node.tileFormPos( new Point(_posx, _posy));
		// ã??ã??ã??ã??ç??ã??ã??ã??ã??ç??å??ä??å??è??ï??ã??ã??ã??ã?ªã??ã??ã??ã??ï??ã?ªã??æ??æ??ã??ã??
		if (arrivedGoal(tile.x, tile.y) || !isMovable(tile.x, tile.y)) {
			_exists = false;
			return;
		}
		
		var nextNode:Node = _start.destination.getNext(tile.x, tile.y);
		// ã??ã??ã??ã??ã??ã??ã??ã??çµ?è??ã??å??å??ã??ã?ªã??ã?ªã??æ??ã??ã??
		if (nextNode == CrossTownTraffic.nodes[tile.y][tile.x]) {
			_vx = 0;
			_vy = 0;
		}else {
			var radians:Number = Math.atan2(nextNode.centerY - _posy, nextNode.centerX - _posx);
			_vx = _speed * Math.cos(radians);
			_vy = _speed * Math.sin(radians);
		}
	}
	
	// ã??ã??ã??ã??ã??ã??ã??å??ç??ã??ã??ã??ã??ã??ã??ã??ã??
	private function arrivedGoal(tilex:int, tiley:int):Boolean {
		var goalNode:Node = _start.destination.node;
		
		return (tilex == goalNode.tileX) && (tiley == goalNode.tileY);
	}
	
	// ã??ã??ã??ã??ã??ã??ã??ç??å??ã??ã??ã??ã??ã??ã??ã??
	private function isMovable(tilex:int, tiley:int):Boolean {
		return CrossTownTraffic.nodes[tiley][tilex].passable;
	}
	
	public function draw(canvas:BitmapData):void {
		var destPoint:Point = new Point(_posx - Particle.IMAGE_RADIUS, _posy - Particle.IMAGE_RADIUS);
		canvas.copyPixels(_images[_imageIndex], _sourceRect, destPoint);
	}
	
	// ã??ã??ã??ã??ã??ã??ã??ç??å??ã??äº?ã??ä??æ??ã??ã??ã??ã??é??æ??
	public static function createImages():void {
		Particle.IMAGE_RADIUS = Parameter.particleRadius;
		_images = [];
		_sourceRect = new Rectangle(0, 0, Particle.IMAGE_RADIUS * 2, Particle.IMAGE_RADIUS * 2);
		for (var i:int = 0; i < Particle.IMAGE_COLORS.length; i++) {
			var bitmapData:BitmapData = new BitmapData(Particle.IMAGE_RADIUS * 2, Particle.IMAGE_RADIUS * 2, true, 0x00ffffff);
			var shape:Shape = new Shape();
			shape.graphics.beginFill(Particle.IMAGE_COLORS[i]);
			shape.graphics.drawCircle(Particle.IMAGE_RADIUS, Particle.IMAGE_RADIUS, Particle.IMAGE_RADIUS);
			shape.graphics.endFill();
			bitmapData.draw(shape);
			_images.push(bitmapData);
		}
	}
}


class Start {
	private static var SPAWN_INTERVAL:int;
	
	private var _node:Node;
	private var _destination:Goal;
	private var _spawnCount:int;
	
	public function get node():Node { return _node; }
	public function get destination():Goal { return _destination; }
	
	public function Start(node:Node, dest:Goal) {
		_node = node;
		_destination = dest;
		_spawnCount = 0;
	}
	
	public function update():void {
		// ã??ã??ã??ã??ã??ã??ã??ã??çµ?è??ã??å??å??ã??ã?ªã??å??å??ã??ä??ã??ã??ã?ªã??
		if (_destination.getCost(node.tileX, node.tileY) == int.MAX_VALUE) { return; }
		
		// ä??å??ã??é??é??ã??ã??ã??ã??ã??ã??ã??ã??å?ºç??ã??è??ã??ã??
		if (++_spawnCount >= Start.SPAWN_INTERVAL) {
			// ç??é??ä??ã??å??å??ã??ã?ªã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??å?ºç??ã??ã??ã??
			var len:int = CrossTownTraffic.particles.length;
			for (var i:int = 0; i < len; i++) {
				if (!CrossTownTraffic.particles[i].exists) {
					CrossTownTraffic.particles[i].spawn(this);
					_spawnCount = 0;
					break;
				}
			}
		}
	}
	
	public static function setSpawnInterval():void {
		Start.SPAWN_INTERVAL = Parameter.spawnInterval;
	}
}


class Goal {
	private static const DX:Array = [ -1, 0, 1, -1, 1, -1, 0, 1];
	private static const DY:Array = [ -1, -1, -1, 0, 0, 1, 1, 1];
	private static const DCOST:Array = [Math.SQRT2, 1, Math.SQRT2, 1, 1, Math.SQRT2, 1, Math.SQRT2];
	
	private var _ID:int;
	private var _node:Node;
	
	private var _openNodes:Array;	// ä??ç??ã??ã??ã??ã?ªã??ã??
	private var _closedNodes:Array;	// ç?ºå??ã??ã??ã??ã?ªã??ã??
	private var _nodeCost:Array;	// å??ã??ã??ã??ã??ç??å??ã??ã??ã??
	private var _nodeNext:Array;	// å??ã??ã??ã??ã??æ??ã??çµ?è??ã??ã?ªã??ã??ã??ã??
	
	public function get ID():int { return _ID; }
	public function get node():Node { return _node; }
	public function getCost(tilex:int, tiley:int):int { return _nodeCost[tiley][tilex]; }
	public function getNext(tilex:int, tiley:int):Node { return _nodeNext[tiley][tilex]; }
	
	public function Goal(ID:int, node:Node) {
		_ID = ID;
		_node = node;
		
		_openNodes = [];
		_closedNodes = [];
		_nodeCost = [];
		_nodeNext = [];
		for (var row:int = 0; row < CrossTownTraffic.MAP_SIZE; row++) {
			_closedNodes[row] = [];
			_nodeCost[row] = [];
			_nodeNext[row] = [];
		}
		
		search();
	}
	
	private function initialize():void {
		for (var row:int = 0; row < CrossTownTraffic.MAP_SIZE; row++) {
			for (var col:int = 0; col < CrossTownTraffic.MAP_SIZE; col++) {
				_closedNodes[row][col] = false;
				_nodeCost[row][col] = int.MAX_VALUE;
				_nodeNext[row][col] = CrossTownTraffic.nodes[row][col];
			}
		}
		
		// Goalã??ã??ã??ã??ã??çµ?è??æ??ç??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??
		_nodeCost[_node.tileY][_node.tileX] = 0;
		_openNodes.push(CrossTownTraffic.nodes[_node.tileY][_node.tileX]);
	}
	
	// ã??ã??ã??ã??ã??ã??æ??ã??ã??ã??çµ?è??æ??ç??
	public function search():void {
		initialize();
		
		while (_openNodes.length > 0) {
			var subject:Node = _openNodes.pop() as Node;
			_closedNodes[subject.tileY][subject.tileX] = true;
			
			// å??å??8æ??å??ã??ã??ã??ã??ã??è?ªå??ã??ã??
			for (var i:int = 0; i < 8; i++) {
				// ç??é??å??ã??å??å??ã??ã?ªã??ã??ã??ã??ã??æ??ã??ã?ªã??æ??ã??å??å??ã??ã??ã??ã??é??ã??
				if (!isValid(subject.tileX + Goal.DX[i]) || !isValid(subject.tileY + Goal.DY[i])) { continue; }
				
				// å??ã??è??ç??ã??ã??ã??ã??ã??ã??ã??ã??ã??ç?ºå??ã??ã??ã??ã??ç??é??ã??ã??ã??ã??ã??ã??ã??ã?ªã??ã??ã??ã??ã?ªã??æ??ã??å??å??ã??ã??ã??ã??é??ã??
				var test:Node = CrossTownTraffic.nodes[subject.tileY + Goal.DY[i]][subject.tileX + Goal.DX[i]];
				if (isWall(test) || isClosedNode(test) || !canGoStraightTo(subject, test)) { continue; }
				
				// æ??å??ã??ç??å??ã??ã??ã??ã??ã??å??ã??ã??ã??ã??ã??æ??æ??ã??ã??
				if (_nodeCost[test.tileY][test.tileX] > _nodeCost[subject.tileY][subject.tileX] + Goal.DCOST[i]) {
					_nodeCost[test.tileY][test.tileX] = _nodeCost[subject.tileY][subject.tileX] + Goal.DCOST[i];
					// æ??ã??çµ?è??ã??ã??ã??ã??subjectã??ã??ã??ã??è??å??ã??ã??
					_nodeNext[test.tileY][test.tileX] = subject;
					// ä??ç??ã??ã??ã??ã?ªã??ã??ã??è??å??ã??ã??
					insertToOpenNodes(test);
				}
			}
		}
	}
	
	// indexã??å??ã??æ??å??ã?ªå??ã??ã??ã??ã??
	private function isValid(index:int):Boolean {
		return ((index >= 0) && (index < CrossTownTraffic.MAP_SIZE));
	}
	
	private function isClosedNode(node:Node):Boolean {
		return _closedNodes[node.tileY][node.tileX];
	}
	
	// å??ã??è??ç??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??
	private function isWall(node:Node):Boolean {
		return !node.passable;
	}
	
	// subjectã??ã??ã??ã??ã??testã??ã??ã??ã??ç??é??ã??ã??ã??ã??ã??ã??ã??
	private function canGoStraightTo(subject:Node, test:Node):Boolean {
		return (CrossTownTraffic.nodes[subject.tileY][test.tileX].passable && CrossTownTraffic.nodes[test.tileY][subject.tileX].passable);
	}
	
	// nodeã??ä??ç??ã??ã??ã??ã?ªã??ã??ã??é??å??ã?ªå??æ??ã??æ??å??ã??ã??
	private function insertToOpenNodes(node:Node):void {
		var insertIndex:int;
		var len:int = _openNodes.length;
		var nodeCost:int = _nodeCost[node.tileY][node.tileX];
		
		for (insertIndex = 0; insertIndex < len; insertIndex++) {
			var openNode:Node = _openNodes[insertIndex];
			if (nodeCost > _nodeCost[openNode.tileY][openNode.tileX]) { break; }
		}
		_openNodes.splice(insertIndex, 0, node);
	}
}


import flash.geom.Point;

class Parameter {
	private static const data:XML =
		<root>
			<particles num="1000" radius="2" maxspeed="8" />
			<walls>
				<wall x="0" y="0" rem="f"/><wall x="2" y="0" rem="f"/>
				<wall x="4" y="0" rem="f"/><wall x="6" y="0" rem="f"/>
				<wall x="8" y="0" rem="f"/><wall x="10" y="0" rem="f"/>
				<wall x="21" y="0" rem="f"/><wall x="23" y="0" rem="f"/>
				<wall x="25" y="0" rem="f"/><wall x="27" y="0" rem="f"/>
				<wall x="29" y="0" rem="f"/><wall x="31" y="0" rem="f"/>
				
				<wall x="0" y="31" rem="f"/><wall x="2" y="31" rem="f"/>
				<wall x="4" y="31" rem="f"/><wall x="6" y="31" rem="f"/>
				<wall x="8" y="31" rem="f"/><wall x="10" y="31" rem="f"/>
				<wall x="21" y="31" rem="f"/><wall x="23" y="31" rem="f"/>
				<wall x="25" y="31" rem="f"/><wall x="27" y="31" rem="f"/>
				<wall x="29" y="31" rem="f"/><wall x="31" y="31" rem="f"/>
				
				<wall x="0" y="2" rem="f"/><wall x="0" y="4" rem="f"/>
				<wall x="0" y="6" rem="f"/><wall x="0" y="8" rem="f"/>
				<wall x="0" y="10" rem="f"/><wall x="0" y="21" rem="f"/>
				<wall x="0" y="23" rem="f"/><wall x="0" y="25" rem="f"/>
				<wall x="0" y="27" rem="f"/><wall x="0" y="29" rem="f"/>
				
				<wall x="31" y="2" rem="f"/><wall x="31" y="4" rem="f"/>
				<wall x="31" y="6" rem="f"/><wall x="31" y="8" rem="f"/>
				<wall x="31" y="10" rem="f"/><wall x="31" y="21" rem="f"/>
				<wall x="31" y="23" rem="f"/><wall x="31" y="25" rem="f"/>
				<wall x="31" y="27" rem="f"/><wall x="31" y="29" rem="f"/>
			</walls>
			<starts interval="10">
				<start dest="0" x="12" y="0"/>
				<start dest="0" x="13" y="0"/>
				<start dest="1" x="14" y="0"/>
				<start dest="1" x="15" y="0"/>
				<start dest="2" x="16" y="0"/>
				<start dest="3" x="17" y="0"/>
				<start dest="3" x="18" y="0"/>
				<start dest="4" x="19" y="0"/>
				<start dest="4" x="20" y="0"/>
				
				<start dest="5" x="0" y="12"/>
				<start dest="5" x="0" y="13"/>
				<start dest="6" x="0" y="14"/>
				<start dest="6" x="0" y="15"/>
				<start dest="7" x="0" y="16"/>
				<start dest="8" x="0" y="17"/>
				<start dest="8" x="0" y="18"/>
				<start dest="9" x="0" y="19"/>
				<start dest="9" x="0" y="20"/>
			</starts>
			<goals>
				<goal id="0" x="14" y="32"/>
				<goal id="1" x="15" y="32"/>
				<goal id="2" x="16" y="32"/>
				<goal id="3" x="17" y="32"/>
				<goal id="4" x="18" y="32"/>
				
				<goal id="5" x="32" y="14"/>
				<goal id="6" x="32" y="15"/>
				<goal id="7" x="32" y="16"/>
				<goal id="8" x="32" y="17"/>
				<goal id="9" x="32" y="18"/>
			</goals>
		</root>;
	
	public static function get numParticles():int {
		return int(Parameter.data.particles.@num);
	}
	
	public static function get particleRadius():int {
		return int(Parameter.data.particles.@radius);
	}
	
	public static function get particleMaxSpeed():Number {
		return Number(Parameter.data.particles.@maxspeed);
	}
	
	public static function get spawnInterval():int {
		return int(Parameter.data.starts.@interval);
	}
	
	public static function getWalls():Array {
		var walls:Array = [];
		for each(var w:XML in Parameter.data.walls.*) {
			var removable:Boolean = ((w.@rem == "t") ? true : false);
			var wall:Wall = new Wall(int(w.@x), int(w.@y), removable);
			walls.push(wall);
		}
		return walls;
	}
	
	public static function getStarts(goals:Array):Array {
		var starts:Array = [];
		var len:int = goals.length;
		
		for each(var s:XML in Parameter.data.starts.*) {
			var destID:int = int(s.@dest);
			var i:int;
			for (i = 0; i < len; i++) {
				if (destID == goals[i].ID) { break; }
			}
			if (i >= len) { i = 0; }
			
			var node:Node = CrossTownTraffic.nodes[int(s.@y)][int(s.@x)];
			var dest:Goal = goals[i];
			var start:Start = new Start(node, dest);
			starts.push(start);
		}
		return starts;
	}
	
	public static function getGoals():Array {
		var goals:Array = [];
		for each(var g:XML in Parameter.data.goals.*) {
			var node:Node = CrossTownTraffic.nodes[int(g.@y)][int(g.@x)];
			var goal:Goal = new Goal(int(g.@id), node);
			goals.push(goal);
		}
		return goals;
	}
}