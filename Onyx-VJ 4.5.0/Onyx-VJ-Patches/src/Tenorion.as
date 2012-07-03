/**
 * Copyright chuckl ( http://wonderfl.net/user/chuckl )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/8DOC
 */

// SiON TENORION for v0.57
package {
    import flash.display.*;
    import flash.events.*;
    import flash.text.TextField;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import onyx.core.*;
    import onyx.parameter.*;
    import onyx.plugin.*;
    
    public class Tenorion extends Patch {
        public var notes :Vector.<int> = Vector.<int>([36,48,60,72, 43,48,55,60, 65,67,70,72, 77,79,82,84]);
        public var length:Vector.<int> = Vector.<int>([ 1, 1, 1, 1,  1, 1, 1, 1,  4, 4, 4, 4,  4, 4, 4, 4]);
		private var _speed:int			= 60;
		private var eventTriggerID:int	= 0;
		private var running:Boolean = false;
		private var _useTapTempo:Boolean = true;
		private var ms:int;
		private var _midi:Number = 0;
    
        // beat counter
        public var beatCounter:int;
        
        // control pad
        public var matrixPad:MatrixPad;
        
        // constructor
        public function Tenorion() {

			Console.output('Tenorion');
			Console.output('Credits to chuckl ( http://wonderfl.net/user/chuckl )');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');

			parameters.addParameters(
				new ParameterNumber( 'midi', 'midi:', 0, 255, _midi ),
				new ParameterInteger('speed', 'speed', 8, 600, _speed),
				new ParameterBoolean( 'useTapTempo', 'use tap tempo', 1 ),
				new ParameterExecuteFunction('run', 'run')
			)
            // start streaming
            beatCounter = 0;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			// control pad
			with(addChild(matrixPad = new MatrixPad())) {
				x = y = 72;
			}
			ms = getTimer();
        }

		public function get useTapTempo():Boolean
		{
			return _useTapTempo;
		}

		public function set useTapTempo(value:Boolean):void
		{
			_useTapTempo = value;
		}

		public function run():void
		{
			eventTriggerID = 0;
			if ( useTapTempo )
			{
				ms = Tempo.delay;
			}
			else
			{
				ms = speed;
			}

			running = true;
		}               
		private function onMouseDown(e:MouseEvent):void 
		{
			matrixPad.onClick(e.localX,e.localY);
		}        
		
		override public function render(info:RenderInfo):void 
		{
			if( getTimer() - speed > ms ) {
	           	matrixPad.beat(eventTriggerID & 15);
				if (eventTriggerID++>15) eventTriggerID = 0;
				ms = getTimer();
			}
			if (running) info.render( matrixPad.getBitmapData() );		
		}        
 
		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}  
		public function get midi():Number
		{
			return _midi;
		}
		
		public function set midi(value:Number):void
		{
			_midi = value;
			speed = value; 
			eventTriggerID = 0;
			ms = speed;
			running = true;
		}

	}
}

import flash.display.*;
import flash.events.*;
import flash.geom.*;

import onyx.plugin.*;

class MatrixPad extends Bitmap {
    public var sequences:Vector.<int> = new Vector.<int>(16);
    private var canvas:Shape = new Shape();
    private var buffer:BitmapData = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT, true, 0);
    private var padOn:BitmapData  = _pad(0x303050, 0x6060a0);
    private var padOff:BitmapData = _pad(0x303050, 0x202040);
    private var pt:Point = new Point();
    private var colt:ColorTransform = new ColorTransform(1,1,1,0.1)
    private var _squareWidth:int = DISPLAY_WIDTH/16;
    private var _squareHeight:int = DISPLAY_HEIGHT/16;
    
    public function MatrixPad() {
        super(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0));
        var i:int;
        for (i=0; i<256; i++) {
            pt.x = (i&15)*squareWidth;//20;
            pt.y = (i&240)*_squareHeight/16;//3;//1.25;
            buffer.copyPixels(padOff, padOff.rect, pt);
            bitmapData.copyPixels(padOff, padOff.rect, pt);
        }
        for (i=0; i<16; i++) sequences[i] = 0;

    }
    
    
	public function get squareHeight():int
	{
		return _squareHeight;
	}

	public function set squareHeight(value:int):void
	{
		_squareHeight = value;
	}

	public function get squareWidth():int
	{
		return _squareWidth;
	}

	public function set squareWidth(value:int):void
	{
		_squareWidth = value;
	}

    private function _pad(border:int, face:int) : BitmapData {
		squareWidth = DISPLAY_WIDTH/16;
		squareHeight = DISPLAY_HEIGHT/16;
        var pix:BitmapData = new BitmapData(squareWidth, squareHeight, false, 0);
        canvas.graphics.clear();
        canvas.graphics.lineStyle(1, border);
        canvas.graphics.beginFill(face);
        canvas.graphics.drawRect(1, 1, squareWidth-3, squareHeight-3);
        canvas.graphics.endFill();
        pix.draw(canvas);
        return pix;
    }
    
    
    public function getBitmapData() : BitmapData {
        bitmapData.draw(buffer, null, colt);
		return bitmapData;
    }
    
    
    public function onClick(mx:int,my:int) : void {
        if (mx>=0 && mx<DISPLAY_WIDTH && my>=0 && my<DISPLAY_HEIGHT) 
		{
            //var track:int = 15-int(my*0.05), beat:int = int(mx*0.05);
            //var track:int = 15-int(my*0.02), beat:int = int(mx*0.02);
            var track:int = 15-int(my/DISPLAY_HEIGHT*16)
			var beat:int = int(mx/DISPLAY_WIDTH*16);
            sequences[track] ^= 1<<beat;
            pt.x = beat*squareWidth;
            pt.y = (15-track)*squareHeight;
            if (sequences[track] & (1<<beat)) buffer.copyPixels(padOn, padOn.rect, pt);
            else buffer.copyPixels(padOff, padOff.rect, pt);
        }
    }
    
    
    public function beat(beat16th:int) : void {
        for (pt.x=beat16th*squareWidth, pt.y=0; pt.y<DISPLAY_HEIGHT; pt.y+=squareHeight) bitmapData.copyPixels(padOn, padOn.rect, pt);
    }
}
