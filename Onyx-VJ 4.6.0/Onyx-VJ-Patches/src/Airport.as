/**
 * Copyright sugikota74 ( http://wonderfl.net/user/sugikota74 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/50GE
 */

// forked from ProjectNya's ã‚¹ãƒ­ãƒƒãƒˆãƒžã‚·ãƒ³ (2)
////////////////////////////////////////////////////////////////////////////////
// ã‚¹ãƒ­ãƒƒãƒˆãƒžã‚·ãƒ³ (2)
//
// [AS3.0] ã‚¹ãƒ­ãƒƒãƒˆãƒžã‚·ãƒ³ã£ã½ã„ã® (2)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=1451
////////////////////////////////////////////////////////////////////////////////

package {
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Airport extends Patch {
		private static var lines:uint = 3;
		private var machine:SlotMachine;
		private var startBtn:Btn;
		private var btns:Array;
		private var slotId:uint = 0;
		private var list:Array;
		private var checked:uint = 0;
		private var label:Label;
		private var sprite:Sprite;    
		
		public function Airport() {
			
			var icons:Array = new Array();
			icons.push({icon: Icon, id: 0});
			icons.push({icon: Icon, id: 0});
			icons.push({icon: Icon, id: 0});
			icons.push({icon: Icon, id: 0});
			icons.push({icon: Icon, id: 0});
			icons.push({icon: Icon, id: 0});
			icons.push({icon: Icon, id: 0});
			icons.push({icon: Icon, id: 70});
			icons.push({icon: Icon, id: 8});
			icons.push({icon: Icon, id: 9});
			
			sprite = new Sprite();
			machine = new SlotMachine();
			sprite.addChild(machine);
			machine.x = 232;
			machine.y = 202;
			machine.initialize(icons, 15, 120);
			machine.setup(80, 80, lines);
			machine.addEventListener(SlotEvent.SELECT, selected, false, 0, true);
			machine.addEventListener(SlotEvent.COMPLETE, complete, false, 0, true);
			//
			startBtn = new Btn();
			sprite.addChild(startBtn);
			startBtn.x = 232;
			startBtn.y = 312;
			startBtn.init({label: "start"});
			startBtn.addEventListener(MouseEvent.MOUSE_DOWN, start, false, 0, true);
			btns = new Array();
			for (var n:uint = 0; n < lines; n++) {
				var stopBtn:Btn = new Btn();
				sprite.addChild(stopBtn);
				stopBtn.x = 232 + 82*(n - 1);
				stopBtn.y = 272;
				stopBtn.init({label: "stop"});
				stopBtn.addEventListener(MouseEvent.MOUSE_DOWN, stop, false, 0, true);
				stopBtn.enabled = false;
				btns.push(stopBtn);
			}
			label = new Label(200, 20, 14, Label.CENTER);
			sprite.addChild(label);
			label.x = 132;
			label.y = 420;
			label.textColor = 0x333333;
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );	
		}
		private function start(evt:MouseEvent):void {
			slotId = 1;
			startBtn.selected = true;
			manage();
			machine.start();
			list = new Array();
			checked = 0;
			label.text= "";
		}
		private function stop(evt:MouseEvent):void {
			machine.stop(slotId - 1);
			slotId ++;
			manage();
		}
		private function selected(evt:SlotEvent):void {
			var id:uint = evt.value;
			list.push(id);
			checked ++;
			if (checked > lines - 1) match();
		}
		private function match():void {
			if (list[0] == list[1] && list[0] == list[2]) {
				label.textColor = 0xCC0000;
				label.text = "match";
			} else if (list[0] == list[1] || list[0] == list[2] || list[1] == list[2]) {
				label.textColor = 0x333333;
				label.text = "reach";
			} else {
				label.textColor = 0x999999;
				label.text = "no match";
			}
		}
		private function complete(evt:SlotEvent):void {
			startBtn.selected = false;
			slotId = 0;
			manage();
		}
		private function manage():void {
			for (var n:uint = 0; n < lines; n++) {
				var stopBtn:Btn = btns[n];
				if (n == slotId - 1) {
					stopBtn.enabled = true;
				} else {
					stopBtn.enabled = false;
				}
			}
		}
		
	}
	
}


//////////////////////////////////////////////////
// SlotMachineã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.display.Shape;
import flash.events.Event;
import flash.filters.DropShadowFilter;

class SlotMachine extends Sprite {
	private var lines:uint;
	private var slotWidth:uint;
	private var slotHeight:uint;
	private var icons:Array;
	private var slots:Array;
	private static var baseColor:uint = 0x333333;
	private var speed:Number;
	private var radius:Number;
	private var completed:uint = 0;
	private var overlay:Shape;
	
	public function SlotMachine() {
		init();
	}
	
	private function init():void {
		slots = new Array();
	}
	public function initialize(list:Array, s:Number, r:Number):void {
		icons = list;
		speed = s;
		radius = r;
	}
	public function setup(w:uint, h:uint, n:uint):void {
		slotWidth = w;
		slotHeight = h;
		lines = n;
		draw();
		for (var n:uint = 0; n < lines; n++) {
			var slot:Slot = new Slot(n, slotWidth, slotHeight, speed, radius);
			addChild(slot);
			slot.x = (slotWidth + 2)*(n - 1);
			slot.y = 0;
			slot.setup(ArrayUtils.shuffle(icons));
			slot.addEventListener(SlotEvent.SELECT, selected, false, 0, true);
			slots.push(slot);
		}
		addChild(overlay);
	}
	public function start():void {
		for (var n:uint = 0; n < lines; n++) {
			var slot:Slot = slots[n];
			slot.addEventListener(Event.COMPLETE, complete, false, 0, true);
			slot.start();
		}
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		completed = 0;
	}
	private function update(evt:Event):void {
		for (var n:uint = 0; n < lines; n++) {
			var slot:Slot = slots[n];
			slot.update();
		}
	}
	public function stop(id:uint):void {
		if (id > lines - 1) return;
		var slot:Slot = slots[id];
		slot.stop();
	}
	private function selected(evt:SlotEvent):void {
		dispatchEvent(new SlotEvent(SlotEvent.SELECT, evt.value));
	}
	private function complete(evt:Event):void {
		evt.target.removeEventListener(Event.COMPLETE, complete);
		completed ++;
		if (completed > lines - 1) {
			removeEventListener(Event.ENTER_FRAME, update);
			dispatchEvent(new SlotEvent(SlotEvent.COMPLETE));
		}
	}
	private function draw():void {
		var back:Shape = new Shape();
		addChild(back);
		var w:uint = slotWidth*lines + 2*(lines + 1);
		var h:uint = slotHeight + 4;
		back.graphics.beginFill(baseColor);
		back.graphics.drawRect(-w/2, -h/2, w, h);
		back.graphics.endFill();
		//
		overlay = new Shape();
		addChild(overlay);
		overlay.graphics.beginFill(baseColor);
		overlay.graphics.drawRect(-w/2, -h/2, w, h);
		overlay.graphics.endFill();
		overlay.filters = [new DropShadowFilter(1, 90, 0x000000, 0.4, 8, 8, 2, 3, true, true, false)];
	}
	
}


//////////////////////////////////////////////////
// Slotã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.display.Shape;
import flash.events.Event;
import flash.filters.BlurFilter;

class Slot extends Sprite {
	public var id:uint;
	private var _width:uint;
	private var _height:uint;
	private var board:Sprite;
	private var box:Sprite;
	private var overlay:Shape;
	private var slots:Array;
	private var icons:Array;
	private var unit:uint;
	private static var baseColor:uint = 0xFFFFFF;
	public var scrolling:Boolean = false;
	public var stopped:Boolean = false;
	public var completed:uint = 0;
	private static var blur:BlurFilter = new BlurFilter(0, 16, 2);
	private var velocity:Number;
	public static var speed:uint;
	private var deceleration:Number = 0.32;
	private var guide:SlotIcon;
	private var offset:Number;
	private var radius:Number;
	
	public function Slot(n:uint, w:uint, h:uint, s:Number, r:Number) {
		id = n;
		_width = w;
		_height = h;
		speed = s;
		radius = r;
		init();
	}
	
	private function init():void {
		draw();
	}
	public function setup(list:Array):void {
		icons = list;
		unit = 360/icons.length;
		slots = new Array();
		for (var n:uint = 0; n < icons.length; n++) {
			var icon:SlotIcon = new SlotIcon(n, radius);
			box.addChild(icon);
			icon.x = 0;
			var pid:uint = icons[n].id;
			var Icon:Class = icons[n].icon;
			icon.setup(id, pid, new Icon(pid));
			icon.angle = 360 - unit*n;
			icon.update();
			icon.move();
			slots.push(icon);
		}
	}
	public function start():void {
		scrolling = true;
		stopped = false;
		completed = 0;
		box.filters = [blur];
		velocity = speed;
	}
	public function stop():void {
		//ã‚¹ãƒ­ãƒ¼ãƒ€ã‚¦ãƒ³é–‹å§‹
		scrolling = false;
		catchup();
	}
	public function update():void {
		if (stopped) return;
		if (scrolling) {
			scroll();
		} else {
			slide();
		}
	}
	private function scroll():void {
		for (var n:uint = 0; n < slots.length; n++) {
			var icon:SlotIcon = slots[n];
			icon.angle += velocity;
			icon.update();
			icon.move();
		}
	}
	private function slide():void {
		for (var n:uint = 0; n < slots.length; n++) {
			var icon:SlotIcon = slots[n];
			icon.angle += (icon.tangle - icon.angle)*deceleration;
			if (Math.abs(icon.tangle - icon.angle) < 0.5) {
				completed ++;
				if (completed > slots.length - 1) complete();
			}
			icon.update();
			icon.move();
		}
		box.filters = [new BlurFilter(0, Math.abs(icon.tangle - icon.angle) >> 2, 2)]
	}
	private function complete():void {
		box.filters = [];
		velocity = 0;
		dispatchEvent(new Event(Event.COMPLETE));
		stopped = true;
		for (var n:uint = 0; n < slots.length; n++) {
			var icon:SlotIcon = slots[n];
			icon.angle = uint(icon.angle);
			icon.update();
			icon.move();
		}
		checkout();
	}
	private function catchup():void {
		var list:Array = new Array();
		for (var n:uint = 0; n < slots.length; n++) {
			var icon:SlotIcon = slots[n];
			if (icon.visible) {
				list.push(icon);
			}
		}
		var id:uint = list[list.length - 1].id;
		var gid:uint = (id + slots.length)%slots.length;
		guide = slots[gid];
		offset = 360 - (guide.angle + 360)%360;
		setTarget();
	}
	private function setTarget():void {
		for (var n:uint = 0; n < slots.length; n++) {
			var icon:SlotIcon = slots[n];
			icon.tangle = icon.angle + offset;
		}
	}
	private function checkout():void {
		dispatchEvent(new SlotEvent(SlotEvent.SELECT, guide.pid));
	}
	private function draw():void {
		var back:Shape = new Shape();
		addChild(back);
		back.graphics.beginFill(baseColor);
		back.graphics.drawRect(-_width/2, -_height/2, _width, _height);
		back.graphics.endFill();
		//
		board = new Sprite();
		addChild(board);
		box = new Sprite();
		board.addChild(box);
		//
		overlay = new Shape();
		overlay.graphics.beginFill(baseColor);
		overlay.graphics.drawRect(-_width/2, -_height/2, _width, _height);
		overlay.graphics.endFill();
		//
		board.addChild(overlay);
		board.mask = overlay;
		cacheAsBitmap = true;
		board.cacheAsBitmap = true;
		overlay.cacheAsBitmap = true;
	}
	
}


//////////////////////////////////////////////////
// SlotIconã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.display.DisplayObject;

class SlotIcon extends Sprite {
	public var id:uint;
	public var sid:uint;
	public var pid:uint;
	public var position:Number;
	public var angle:Number;
	public var tangle:Number;
	public static var radius:uint;
	private static var radian:Number = Math.PI/180;    
	private static var offset:uint = 45;
	
	public function SlotIcon(n:uint, r:Number) {
		id = n;
		radius = r;
	}
	
	public function setup(i:uint, p:uint, icon:DisplayObject):void {
		sid = i;
		pid = p;
		addChild(icon);
	}
	public function update():void {
		position = radius*Math.sin(angle*radian);
	}
	public function move():void {
		var rad:Number = (angle + 360)%360;
		if (rad > offset && rad < 360 - offset) {
			angle = Math.round(angle);
			visible = false;
		} else {
			visible = true;
			y = position;
		}
	}
	
}


//////////////////////////////////////////////////
// Iconã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.AntiAliasType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class Icon extends Sprite {
	private var id:uint;
	private var txt:TextField;
	private static var fontType:String = "Arial";
	
	public function Icon(n:uint) {
		id = n;
		init();
	}
	
	private function init():void {
		txt = new TextField();
		addChild(txt);
		txt.x = -40;
		txt.y = -40;
		txt.width = 80;
		txt.height = 80;
		txt.type = TextFieldType.DYNAMIC;
		txt.selectable = false;
		//txt.embedFonts = true;
		//txt.antiAliasType = AntiAliasType.ADVANCED;
		var tf:TextFormat = new TextFormat();
		tf.font = fontType;
		tf.size = 72;
		tf.align = TextFormatAlign.CENTER;
		txt.defaultTextFormat = tf;
		txt.text = String(id);
	}
	
}


//////////////////////////////////////////////////
// SlotEventã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.events.Event;

class SlotEvent extends Event {
	public static const SELECT:String = "select";
	public static const COMPLETE:String = "complete";
	public var value:*;
	
	public function SlotEvent(type:String, value:* = null) {
		super(type);
		this.value = value;
	}
	
	override public function clone():Event {
		return new SlotEvent(type, value);
	}
	
}


//////////////////////////////////////////////////
// ArrayUtilsã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

class ArrayUtils {
	
	public function ArrayUtils() {
	}
	
	public static function shuffle(list:Array):Array {
		var n:uint = list.length;
		var sList:Array = list.concat();
		while (n--) {
			var i:uint = uint(Math.random()*(n+1));
			var t:Object = sList[n];
			sList[n] = sList[i];
			sList[i] = t;
		}
		return sList;
	}
	
}


//////////////////////////////////////////////////
// Btnã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.AntiAliasType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.filters.GlowFilter;
import flash.events.MouseEvent;

class Btn extends Sprite {
	public var id:uint;
	private var shade:Shape;
	private var bottom:Shape;
	private var light:Shape;
	private var base:Shape;
	private var txt:TextField;
	private var label:String = "";
	private static var fontType:String = "_ã‚´ã‚·ãƒƒã‚¯";
	private var _width:uint = 60;
	private static var _height:uint = 20;
	private static var corner:uint = 5;
	private var type:uint = 1;
	private static var bColor:uint = 0xFFFFFF;
	private static var sColor:uint = 0x000000;
	private static var upColor:uint = 0x666666;
	private static var overColor:uint = 0x333333;
	private static var offColor:uint = 0x999999;
	private static var gColor:uint = 0x0099FF;
	private var blueGlow:GlowFilter;
	private var shadeGlow:GlowFilter;
	private var _selected:Boolean = false;
	private var _enabled:Boolean = true;
	
	public function Btn() {
	}
	
	public function init(option:Object):void {
		if (option.id != undefined) id = option.id;
		if (option.label != undefined) label = option.label;
		if (option.width != undefined) _width = option.width;
		if (option.type != undefined) type = option.type;
		draw();
	}
	private function draw():void {
		switch (type) {
			case 1 :
				bColor = 0xFFFFFF;
				sColor = 0x000000;
				upColor = 0x666666;
				overColor = 0x333333;
				offColor = 0x999999;
				break;
			case 2 :
				bColor = 0x000000;
				sColor = 0xFFFFFF;
				upColor = 0x666666;
				overColor = 0x999999;
				offColor = 0x333333;
				break;
		}
		blueGlow = new GlowFilter(gColor, 0.6, 5, 5, 2, 3, false, true);
		shadeGlow = new GlowFilter(sColor, 0.3, 4, 4, 2, 3, false, true);
		shade = new Shape();
		bottom = new Shape();
		light = new Shape();
		base = new Shape();
		txt = new TextField();
		addChild(shade);
		addChild(bottom);
		addChild(light);
		addChild(base);
		addChild(txt);
		createBase(shade, _width, _height, corner, sColor);
		shade.filters = [shadeGlow];
		createBase(bottom, _width, _height, corner, sColor, 0.3);
		createBase(light, _width, _height, corner, gColor);
		light.filters = [blueGlow];
		createBase(base, _width, _height, corner, bColor);
		txt.x = -_width*0.5;
		txt.y = -_height*0.5;
		txt.width = _width;
		txt.height = _height - 1;
		txt.type = TextFieldType.DYNAMIC;
		txt.selectable = false;
		//txt.embedFonts = true;
		//txt.antiAliasType = AntiAliasType.ADVANCED;
		var tf:TextFormat = new TextFormat();
		tf.font = fontType;
		tf.size = 12;
		tf.align = TextFormatAlign.CENTER;
		txt.defaultTextFormat = tf;
		txt.text = label;
		enabled = true;
		mouseChildren = false;
	}
	private function rollOver(evt:MouseEvent):void {
		_over();
	}
	private function rollOut(evt:MouseEvent):void {
		_up();
	}
	private function press(evt:MouseEvent):void {
		_down();
	}
	private function release(evt:MouseEvent):void {
		_up();
	}
	private function click(evt:MouseEvent):void {
	}
	private function _up():void {
		txt.y = -_height*0.5;
		txt.textColor = upColor;
		base.y = -1;
		light.visible = false;
		light.y = -1;
	}
	private function _over():void {
		txt.y = -_height*0.5;
		txt.textColor = overColor;
		base.y = -1;
		light.visible = true;
		light.y = -1;
	}
	private function _down():void {
		txt.y = -_height*0.5 + 1;
		txt.textColor = overColor;
		base.y = 0;
		light.visible = true;
		light.y = 0;
	}
	private function _off():void {
		txt.y = -_height*0.5 + 1;
		txt.textColor = offColor;
		base.y = 0;
		light.visible = false;
		light.y = 0;
	}
	public function get selected():Boolean {
		return _selected;
	}
	public function set selected(param:Boolean):void {
		_selected = param;
		enabled = !_selected;
		if (_selected) {
			_down();
		} else {
			_up();
		}
	}
	public function get enabled():Boolean {
		return _enabled;
	}
	public function set enabled(param:Boolean):void {
		_enabled = param;
		buttonMode = _enabled;
		mouseEnabled = _enabled;
		useHandCursor = _enabled;
		if (_enabled) {
			_up();
			addEventListener(MouseEvent.MOUSE_OVER, rollOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, rollOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, press, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, release, false, 0, true);
			addEventListener(MouseEvent.CLICK, click, false, 0, true);
		} else {
			_off();
			removeEventListener(MouseEvent.MOUSE_OVER, rollOver);
			removeEventListener(MouseEvent.MOUSE_OUT, rollOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, press);
			removeEventListener(MouseEvent.MOUSE_UP, release);
			removeEventListener(MouseEvent.CLICK, click);
		}
	}
	private function createBase(target:Shape, w:uint, h:uint, c:uint, color:uint, alpha:Number = 1):void {
		target.graphics.beginFill(color, alpha);
		target.graphics.drawRoundRect(-w*0.5, -h*0.5, w, h, c*2);
		target.graphics.endFill();
	}
	
}


//////////////////////////////////////////////////
// Labelã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.AntiAliasType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class Label extends Sprite {
	private var txt:TextField;
	private static var fontType:String = "_ã‚´ã‚·ãƒƒã‚¯";
	private var _width:uint = 20;
	private var _height:uint = 20;
	private var size:uint = 12;
	public static const LEFT:String = TextFormatAlign.LEFT;
	public static const CENTER:String = TextFormatAlign.CENTER;
	public static const RIGHT:String = TextFormatAlign.RIGHT;
	
	public function Label(w:uint, h:uint, s:uint = 12, align:String = LEFT) {
		_width = w;
		_height = h;
		size = s;
		draw(align);
	}
	
	private function draw(align:String):void {
		txt = new TextField();
		addChild(txt);
		txt.width = _width;
		txt.height = _height;
		txt.autoSize = align;
		txt.type = TextFieldType.DYNAMIC;
		txt.selectable = false;
		//txt.embedFonts = true;
		//txt.antiAliasType = AntiAliasType.ADVANCED;
		var tf:TextFormat = new TextFormat();
		tf.font = fontType;
		tf.size = size;
		tf.align = align;
		txt.defaultTextFormat = tf;
		textColor = 0x000000;
	}
	public function set text(param:String):void {
		txt.text = param;
	}
	public function set textColor(param:uint):void {
		txt.textColor = param;
	}
	
}
