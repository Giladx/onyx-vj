package
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	
	import com.greensock.TweenMax;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.profiler.showRedrawRegions;
	import flash.utils.Dictionary;
	
	import onyx.asset.AssetFile;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.system.NativeAppLauncher;

	[SWF(width='640', height='480', frameRate='24', backgroundColor='#000000')]
	public class IsoLaunchpad extends Patch
	{
		private static const CELL_SIZE:int = 40;
		//private var grid:IsoGrid;
		private var scene:IsoScene;
		private var view:IsoView;
		private var box:IsoBox;
		
		private var pathToExe:String = 'MidiPipe.exe';
		private var tempText:String	= 'outp launchpad';
		private var appLauncher:NativeAppLauncher;
		//private var isoBoxes:Array = new Array();
		private var _running:Boolean = false;
		private var _processing:Boolean = false;
		private var _received:String = '';
		private var _command:String = '';
		private var numerator:uint = 1;
		private var denominator:uint = 3;
		private var pads:Dictionary = new Dictionary();
		private var isoPads:Dictionary = new Dictionary();
		private var padColors:Dictionary = new Dictionary();
		
		public function IsoLaunchpad()
		{
			//writeLogFile( 'IsoLaunchpad start', true );
			padColors[0] = grey;
			padColors[1] = yellow_low;
			padColors[2] = yellow_high;
			padColors[3] = green_low;
			padColors[4] = green_high;
			padColors[5] = orange_low;
			padColors[6] = orange_high;
			padColors[7] = red_high;

			parameters.addParameters(
				new ParameterExecuteFunction('start', 'launch'),
				new ParameterExecuteFunction('write', 'write'),
				new ParameterExecuteFunction('reset', 'reset'),
				new ParameterExecuteFunction('lightAll', 'lightAll'),
				new ParameterExecuteFunction('dutyCycle', 'dutyCycle'),
				new ParameterExecuteFunction('gradient', 'gradient'),
				new ParameterStatus('running', 'running'),
				new ParameterBoolean('processing', 'processing'),
				new ParameterString('text', 'text'),
				new ParameterStatus('received', 'received'),
				new ParameterStatus('command', 'command')
			);
			appLauncher = new NativeAppLauncher(pathToExe);
			appLauncher.addEventListener( Event.ACTIVATE, activate );
			appLauncher.addEventListener( Event.CLOSE, closed );
			appLauncher.addEventListener( Event.CHANGE, change );
			
			/*grid = new IsoGrid();
			//grid.addEventListener(MouseEvent.CLICK, gridClick);
			grid.setGridSize(8, 8, 1);
			grid.showOrigin = true;
			grid.cellSize = CELL_SIZE;*/
			
			var iso:IsoSprite;
			
			scene = new IsoScene();
			//scene.addChild(grid);
			//scene.addEventListener(MouseEvent.CLICK, gridClick);
			addEventListener(InteractionEvent.MOUSE_DOWN, mouseDown);
			
			var note:uint;
			//column
			for (var column:int=0; column<8; column++)
			{
				//row
				for (var row:int=0; row<8; row++)
				{
					//iso = new Pad(row,column);//IsoSprite();
					iso = new IsoSprite();
					//iso.addEventListener(InteractionEvent.MOUSE_MOVE, boxOver);
					iso.sprites = [padColors[row]];
					//isoBoxes.push( iso);
					note = column + (row*16);
					var isoNote:uint = 7-column + (row*16);
					isoPads[isoNote] = iso;
					pads[note] = new Pad(row, column);
					//writeLogFile( 'note, column, row:' +note +', '+ column+', '+ row );
					
					iso.moveBy(row*CELL_SIZE, column*CELL_SIZE, 0);
					scene.addChild(iso);
				}
			}
			
			view = new IsoView();
			view.setSize(800,600);
			view.centerOnPt(new Pt(250, 200, 50));
			view.addScene(scene);
			addChild(view);
		}
		override public function render(info:RenderInfo):void 
		{
			scene.render();
			info.render( view );	
		}
		
		private function gridClick(event:ProxyEvent):void
		{
			var me:MouseEvent = MouseEvent(event.targetEvent);
			var p:Pt = new Pt(me.localX, me.localY);
			IsoMath.screenToIso(p);
			box.moveTo(Math.floor(p.x/CELL_SIZE)*CELL_SIZE, Math.floor(p.y/CELL_SIZE)*CELL_SIZE, 0);
			scene.render();
		}
		private function mouseDown(event:MouseEvent):void 
		{
			var box:IsoSprite = isoPads[(event.localX) % 8 + 16];
			if (box)
			{
				TweenMax.to(box, 0.5, {z:10, yoyo:true, repeat:1, startAt:{z:0}});
				
				box.sprites = [padColors[5]];
				scene.render();
			}
		}
		
		public function start():void 
		{
			//running = true;
			appLauncher.launchExe();
		}
		public function write():void 
		{			
			appLauncher.writeData(tempText);
			if (tempText == 'outp launchpad') tempText = 'inpt loop';
		}
		public function reset():void 
		{			
			appLauncher.writeData('176,0,0');
		}
		public function lightAll():void 
		{			
			appLauncher.writeData('176,0,127');
		}
		public function dutyCycle():void 
		{	
			if (numerator++>7) numerator = 1;
			if (denominator++>17) denominator = 3;
			var duty:uint = (16 * (numerator - 1)) + (denominator - 3);
			//if (duty > 127) duty = 0;
			appLauncher.writeData('176,30,' + duty);
		}
		public function gradient():void
		{
			for (var red:uint=0;red<8;red++)
			{
				for (var green:uint=0;green<8;green++)
				{
					var colour:uint = 12 + red + (green*16);
					var pos:uint = red + ((green)*16);
					appLauncher.writeData('144,' + pos + ',' + colour);
					//lightPad(isoPads[data1], data1, 4, 60, true);
				}	
			}
		}
		public function change(evt:Event):void 
		{
			var cmd:String = appLauncher.readAppOutput();
			if ( processing )
			{
				var data1:uint = uint(cmd);
				//writeLogFile( 'data1: ' + data1 );
				lightPad(isoPads[data1], data1, 4, 60, true);
				//column
				var padCol:uint = pads[data1].column;
				//row
				var padRow:uint = pads[data1].row;
				if (padRow == 0)
				{
					if (--padCol < 0) padCol = 7;
					//writeLogFile( '--padCol: ' + padCol );
					lightPad(isoPads[padCol], padCol, 3, 44);
					
					if (--padCol < 0) padCol = 7;
					lightPad(isoPads[padCol], padCol, 3, 44);
					
					if (--padCol < 0) padCol = 7;
					lightPad(isoPads[padCol], padCol, 0, 12);

				}
				//scene.render();
			}
		}
		private function lightPad(pad:IsoSprite, padIndex:uint, colorIndex:uint, color:uint, bounce:Boolean=false):void
		{
			if (pad) 
			{
				pad.sprites = [padColors[colorIndex]];
				//pad.sprites = [red_high];
				//show on lp
				appLauncher.writeData('144,' + padIndex + ',' + color);
				if (bounce)
				{
					TweenMax.to(pad, 0.3, {z:3, yoyo:true, repeat:1, startAt:{z:0}});
				}
				scene.render();
			}
		}
		private function activate(evt:Event):void
		{
			running = true;
		}
		private function closed(evt:Event):void
		{
			running = false;
		}
		public function set text(value:String):void {
			tempText = value;
			command = tempText;
		}
		public function get text():String {
			return tempText;
		}
		public function get running():Boolean
		{
			return _running;
		}
		
		public function set running(value:Boolean):void
		{
			_running = value;
		}		
		public function get processing():Boolean
		{
			return _processing;
		}
		
		public function set processing(value:Boolean):void
		{
			_processing = value;
		}		
		
		public function get received():String
		{
			return _received;
		}
		
		public function set received(value:String):void
		{
			_received = value;
		}
		
		public function get command():String
		{
			return _command;
		}
		
		public function set command(value:String):void
		{
			_command = value;
		}

	}
}