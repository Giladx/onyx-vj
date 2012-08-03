// forked from aznFanBoy's forked from: Tentacle
// forked from yasuo_from_BDM's Tentacle
/*

original sorce code from "www.levitated.net"
Tentacle(AS3 version)

Yasuo Hasegawa from BIRDMAN

*/

package {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.TextField;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Tentacles extends Patch
	{
		private var maxtents:int = 10;
		private var tents:Number = 0;
		private var sprite:Sprite;
		
		public function Tentacles()
		{
			sprite = new Sprite();
			
		}
		override public function render(info:RenderInfo):void
		{
			if ((!Math.floor(Math.random()*30)) && (tents<maxtents)) 
			{
				var tent:Tentacle = new Tentacle();
				sprite.addChild(tent);
				
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = 10;
				blur.blurY = 10;
				blur.quality = 1;
				var filterArray:Array = new Array(blur);
				tent.filters = filterArray;
				
				tent.addEventListener("moveend", function(event:Event):void
				{
					tents--;
					tent.removeEventListener("moveend", arguments.callee);
				});
				// position it at screen bottom
				tent.x = Math.floor(Math.random()*DISPLAY_WIDTH);
				tent.y = DISPLAY_HEIGHT;
				// point up initially
				tent.theta = 270;
				// keep track of number of tentacles
				tents++;
			}
			info.render(sprite);
		}
	}
}


import flash.display.Sprite;
import flash.events.*;
import flash.text.TextField;

import onyx.plugin.DISPLAY_HEIGHT;
import onyx.plugin.DISPLAY_WIDTH;

class Tentacle extends Sprite
{
	// total number of nodes
	public var numNodes:Number = 27;
	
	// the general size and speed
	public var head:Number  = 2+Math.floor(Math.random()*4);
	public var girth:Number = 8+Math.floor(Math.random()*12);
	
	// locomotion efficiency (0 - 1)
	public var speedCoefficient:Number =.09+Math.floor((Math.random()*10)/50);    
	
	// the viscosity of the water (0 - 1)    
	public var friction:Number = .90+Math.floor((Math.random()*10)/100);    
	
	// muscular range
	public var muscleRange:Number = 20+Math.floor(Math.random()*50);
	
	// muscular frequency
	public var muscleFreq:Number = .1+Math.floor((Math.random()*100)/250);    
	
	// create point array to represent nodes
	public var nodes:Array = [];
	
	private var tracefield:TextField; 
	
	private var tv:Number = 0;
	public var theta:Number = 0;
	private var count:Number = 0;
	
	private var moveEnd_evt:Event = new Event("moveend");
	
	public function Tentacle() 
	{
		init();
	} 
	
	private function init():void
	{   
		generateNodes();
		this.addEventListener(Event.ENTER_FRAME, moveHandler);
	}        
	
	public function generateNodes():void
	{
		nodes = [];
		for (var n:int = 0; n< numNodes; n++)
		{
			var point:Object = {x:0,y:0};
			nodes.push(point);
		}
	}
	
	public function moveHandler(event:Event):void
	{
		
		// directional node with orbiting handle
		// arbitrary direction
		tv += 0.5*(Math.random()-Math.random());
		theta += tv;
		tv *= friction;
		
		nodes[0].x = head*Math.cos(Math.PI / 180 * theta);
		nodes[0].y = head*Math.sin(Math.PI / 180 * theta);
		
		// muscular node
		count += muscleFreq;
		
		var thetaMuscle:Number = muscleRange*Math.sin(count);
		
		nodes[1].x = -head*Math.cos(Math.PI / 180 * (theta + thetaMuscle));
		nodes[1].y = -head*Math.sin(Math.PI / 180 * (theta + thetaMuscle));
		
		// apply kinetic forces down through body nodes
		for (var i:Number = 2; i<numNodes; i++)
		{
			var dx:Number = nodes[i].x - nodes[i - 2].x;
			var dy:Number = nodes[i].y - nodes[i - 2].y;
			
			var d:Number = Math.sqrt (dx * dx + dy * dy);
			nodes[i].x   = nodes[i - 1].x + (dx * girth) / d;
			nodes[i].y   = nodes[i - 1].y + (dy * girth) / d;
			
			// check if muscle node is outside of viewable window
			if (i==2)
			{
				this.x -= dx*speedCoefficient;
				this.y -= dy*speedCoefficient;
				if (((this.x+this.width)<0) || ((this.x-this.width)>DISPLAY_WIDTH) || ((this.y+this.height)<0) || ((this.y-this.height)>DISPLAY_HEIGHT)) {
					this.removeEventListener(Event.ENTER_FRAME, moveHandler);
					var parentObj:Object = Object(parent);
					parentObj.removeChild(this);
					this.dispatchEvent(moveEnd_evt);
				}
			}
		}
		
		// draw nodes using lines    
		this.graphics.clear();
		this.graphics.moveTo(nodes[1].x,nodes[1].y);
		for (var j:Number = 2; j<numNodes; j++)
		{
			//    this.lineStyle((this.numNodes/(i-1))*1.5, 0xFFFFFF, 100);  // with head
			//    this.lineStyle((this.numNodes-i), 0xFFFFFF, 100);  // with no head
			this.graphics.lineStyle(int(numNodes-j)*(numNodes-j)/20, Math.random() * 0xFFFFFF, 1);  // with no head
			this.graphics.lineTo(nodes[j].x,nodes[j].y);
		}
	}; 
}
