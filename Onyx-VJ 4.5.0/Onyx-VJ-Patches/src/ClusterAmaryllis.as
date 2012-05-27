/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/vAM6
 */

// forked from otias's ClusterAmaryllis
package {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class ClusterAmaryllis extends Patch {
		private var lines:Vector.<Sprite> = new Vector.<Sprite>();
		private var prop:Vector.<Object> = new Vector.<Object>();
		private var timer:Timer;
		private var sprite:Sprite;
		
		public function ClusterAmaryllis() {
			var initPos:Array = new Array(0, DISPLAY_HEIGHT);
			sprite = new Sprite();
			for(var i:uint = 0; i < 150; i++) {
				prop.push(new Object());
				prop[i].xpos = DISPLAY_WIDTH / 2;
				prop[i].ypos = DISPLAY_HEIGHT / 2;
				prop[i].vx = 0;
				prop[i].vy = 0;
				prop[i].speed = 1 + Math.random() * 2;
				prop[i].vec = Math.random() * 10 - 5;
				prop[i].angle = Math.random() * 360;
				
				lines.push(new Sprite());
				lines[i].graphics.lineStyle(Math.random() * 3, 0x6BC976 + Math.random() * 100 << 16);
				lines[i].graphics.moveTo(prop[i].xpos, prop[i].ypos);
				sprite.addChild(lines[i]);
			}
			
			timer = new Timer(33);
			timer.addEventListener(TimerEvent.TIMER, onLoop, false, 0, true);
			timer.start();
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );		
		} 		
		private function onLoop(e:TimerEvent):void {
			for(var i:uint = 0; i < 100; i++) {
				prop[i].vec += Math.random() * 4 - 2;
				prop[i].angle += (Math.random() * 5) * Math.sin(prop[i].vec * (Math.PI / 180));
				prop[i].vx = Math.cos(prop[i].angle * (Math.PI / 180) ) * prop[i].speed;
				prop[i].vy = Math.sin(prop[i].angle * (Math.PI / 180) ) * prop[i].speed;
				prop[i].xpos += prop[i].vx;
				prop[i].ypos += prop[i].vy;
				lines[i].graphics.lineTo(prop[i].xpos, prop[i].ypos);
				lines[i].alpha = Math.abs(Math.sin(prop[i].angle * (Math.PI / 180) ));
				
				if(prop[i].xpos < 0 || prop[i].xpos > DISPLAY_WIDTH) {
					prop[i].vx = 0;    
				}
				
				if(prop[i].ypos > DISPLAY_HEIGHT || prop[i].ypos < 0) {
					prop[i].vy = 0;
				}
			}
		}
	}
}