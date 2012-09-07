package {
	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class CircleCountdown extends Patch {
		static public const N:int = 24;
		static public const SIZE:int = 36;
		
		private var panels:Array = [];
		private var bases:Array = [];
		private var ansPanels:Array = [];
		
		private var centerX:int;
		private var centerY:int;
		private var r:int;
		
		private var count:int = 0;
		private var countColors:Array = [0xff0033, 0xffd700, 0x1e90ff];
		
		private var timeLabel:TextField;
		private var startTime:int;
		private var nowTime:int;
		private var previousTime:int;
		private var remainingTime:int;
		
		private var sprite:Sprite;
		private var _seconds:int = 10;
		private var ms:int = 1000 * _seconds;
		
		public function CircleCountdown():void {
			
			parameters.addParameters(
				new ParameterInteger( 'seconds', 'seconds:', 1, 59, _seconds ),
				new ParameterExecuteFunction('start', 'start')
			);
			
			sprite = new Sprite();
			
			centerX = DISPLAY_WIDTH / 2;
			centerY = DISPLAY_HEIGHT / 2;
			r = DISPLAY_WIDTH / 4;

			timeLabel = new TextField();
			var format:TextFormat = new TextFormat();
			
			format.color = 0xFF6666;
			format.size = 20;
			format.bold = true;
			format.font = 'Verdana';
			
			timeLabel.defaultTextFormat = format;
			timeLabel.setTextFormat(format);
			timeLabel.autoSize = TextFieldAutoSize.CENTER,		
			
			timeLabel.text = "--";
			timeLabel.scaleX = timeLabel.scaleY = 4;
			timeLabel.x = centerX - 50;
			timeLabel.y = centerY - 60;
			//timeLabel.y = centerY - timeLabel.height * timeLabel.scaleY / 2;
			
			
			for (var i:int = 0; i < 360; i += 360 / N){
				var color:ColorHSV = new ColorHSV(i, 0.8);
				var panel:Panel = new Panel(color, SIZE);
				panels.push(panel);
				
				var base:BasePanel = new BasePanel(i - 90, SIZE);
				var rad:Number = base.rotation * 2 * Math.PI / 360;
				base.x = centerX + r * Math.cos(rad);
				base.y = centerY + r * Math.sin(rad);
				sprite.addChild(base);
				bases.push(base);
			}
		}
		
		public function start():void {		
			
			startTime = getTimer();
			previousTime = getTimer() - startTime;
			addEventListener(Event.ENTER_FRAME, timer);
			sprite.addChild(timeLabel);
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );		
		}

		
		private function timer(e:Event):void {
			nowTime = getTimer() - startTime;
			remainingTime = (ms - nowTime)/1000;
			if (remainingTime < 0) remainingTime = 0;
			timeLabel.text = remainingTime + "";
			
			var time:int = count / N;
			var index:int = count % N;
			var color:uint = countColors[time%3];
			var base:BasePanel = bases[index];
			
			base.color = color;
			
			//trace("startTime:"+startTime + " previousTime:"+previousTime +" nowTime:"+nowTime + " nowTime - previousTime:"+(nowTime - previousTime) );
			if ( (nowTime - previousTime)/N > 1 ) {
				count++;
				previousTime = nowTime;
			}
			
			if ( remainingTime == 0){
				for (var i:int = 0; i < N; i++){
					bases[i].color = BasePanel.DEF_COLOR;
				}
				stop();
			}
		}

		private function stop():void {		
			
			removeEventListener(Event.ENTER_FRAME, timer);
		}
		
		public function get seconds():int
		{
			return _seconds;
		}

		public function set seconds(value:int):void
		{
			_seconds = value;
			ms = value * 1000;
		}


	}
}
	
	import flash.display.Sprite
	import frocessing.color.ColorHSV;
	
	class Panel extends Sprite {
		private var _color:ColorHSV;
		private var _initX:int;
		private var _initY:int;
		private var _initRotation:Number;
		
		public function Panel(color:ColorHSV, size:int){
			_color = color;
			
			graphics.beginFill(color.value);
			graphics.drawRoundRect(-size / 2, -size / 2, size, size, 10);
			graphics.endFill();
			
			this.buttonMode = true;
		}
		
		public function init(x:int, y:int, rotation:Number):void {
			_initX = x;
			_initY = y;
			_initRotation = rotation;
		}
		
		public function get initX():int {
			return _initX;
		}
		
		public function set initX(value:int):void {
			_initX = value;
		}
		
		public function get initY():int {
			return _initY;
		}
		
		public function set initY(value:int):void {
			_initY = value;
		}
		
		public function get initRotation():Number {
			return _initRotation;
		}
		
		public function set initRotation(value:Number):void {
			_initRotation = value;
		}
		
		public function get color():ColorHSV {
			return _color;
		}
		
		public function set color(value:ColorHSV):void {
			_color = value;
		}
	}
	
	class BasePanel extends Sprite {
		public static const DEF_COLOR:uint = 0xaaaaaa;
		private var size:int;
		
		public function BasePanel(angle:Number, size:int){
			this.size = size;
			rotation = angle;
		}
		
		public function set color(rgb:uint):void {
			graphics.clear();
			graphics.beginFill(rgb, 0.9);
			graphics.drawRoundRect(-size / 2, -size / 2, size, size, 10);
			graphics.endFill();
		}
	}
