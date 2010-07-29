// forked from peko's Rampant Growth 3D
/**
 * 25-Line ActionScript Contest Entry
 * 
 * Project: Rampant Growth 3D
 * Author:  Eduard Ruzga aka wonderwhy-er
 * Date: 26.11.2008
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


package {
	import flash.display.*
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	
	import flash.display.StageScaleMode;
	
	
	
	[SWF(width=456, height=456, backgroundColor=0x0, frameRate=30)]
	public class Tree extends Sprite{ 
		
		var matrixes:Object = {
			transformMatrix:new Matrix3D(Vector.<Number>([1,0,0,0,0,1,0,0,0,0,1,0,0,0,6,1])),
			projectionMatrix:new Matrix3D(Vector.<Number>([603,0,0,0,0,603,0,0,0,0,0.25,1,0,0,0,0])),
			growthRotation:[
				new Matrix3D(Vector.<Number>([0.9806308150291443,-0.13781867921352386,0.13917310535907745,0,0.13917310535907745,0.9902680516242981,0,0,-0.13781867921352386,0.019369153305888176,0.9902680516242981,0,0,0,0,1])),
				new Matrix3D(Vector.<Number>([0.9806308150291443,-0.13781867921352386,-0.13917310535907745,0,0.13917310535907745,0.9902680516242981,0,0,0.13781867921352386,-0.019369153305888176,0.9902680516242981,0,0,0,0,1])),
				new Matrix3D(Vector.<Number>([0.9806308150291443,0.13781867921352386,0.13917310535907745,0,-0.13917310535907745,0.9902680516242981,0,0,-0.13781867921352386,-0.019369153305888176,0.9902680516242981,0,0,0,0,1])),
				new Matrix3D(Vector.<Number>([0.9806308150291443,0.13781867921352386,-0.13917310535907745,0,-0.13917310535907745,0.9902680516242981,0,0,0.13781867921352386,0.019369153305888176,0.9902680516242981,0,0,0,0,1]))
			], 
			siblingOffsets:[
				new Matrix3D(),
				new Matrix3D(Vector.<Number>([0.5868240594863892,0.49240389466285706,-0.6427876353263855,0,-0.6427876353263855,0.7660444378852844,0,0,0.49240389466285706,0.41317594051361084,0.7660444378852844,0,0,0,0,1])),
				new Matrix3D(Vector.<Number>([0.5868240594863892,0.49240389466285706,0.6427876353263855,0,-0.6427876353263855,0.7660444378852844,0,0,-0.49240389466285706,-0.41317594051361084,0.7660444378852844,0,0,0,0,1])),
				new Matrix3D(Vector.<Number>([0.5868240594863892,-0.49240389466285706,-0.6427876353263855,0,0.6427876353263855,0.7660444378852844,0,0,0.49240389466285706,-0.41317594051361084,0.7660444378852844,0,0,0,0,1])),
				new Matrix3D(Vector.<Number>([0.5868240594863892,-0.49240389466285706,0.6427876353263855,0,0.6427876353263855,0.7660444378852844,0,0,-0.49240389466285706,0.41317594051361084,0.7660444378852844,0,0,0,0,1]))
			]};
		
		var treeData:Array =[
			Vector.<Number>([0,1,0,0,0.5,0]),
			new Vector.<Number>(),
			new Vector.<Number>(),
			new Vector.<Number>(),
			[[0,1,0x8000f0,2]],
			[[[0,1,0x8800f0,2],0,0,new Vector3D(0, -0.07, 0)]]
		];
		var differance:Number;
		
		function Tree() {
			//			stage.align = StageAlign.TOP_LEFT;
			//			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(MouseEvent.MOUSE_DOWN,function(evt:Event){
				treeData=[
					Vector.<Number>([0,1,0,0,0.8,0]),
					new Vector.<Number>(),
					new Vector.<Number>(),
					new Vector.<Number>(),
					[[0,1,0x442200,2.4]],
					[[[0,1,0x442200,2.0],0,0,new Vector3D(0, -0.1, 0)]]
				];
			});
			addEventListener(Event.ENTER_FRAME,frame);
		}
		
		public function compareLines(a:Array,b:Array):int {
			return -int((differance = (treeData[2][a[0]*3+2]+treeData[2][a[1]*3+2])/2-(treeData[2][b[0]*3+2]+treeData[2][b[1]*3+2])/2)/Math.abs(differance));
		}
		
		public function frame(evt:Event) {
			for (var i:int=0; i<treeData[5].length; i++) {
				if (Math.random()<0.4) {
					treeData[5].push([treeData[5][i][0],treeData[5][i][1]/3,treeData[5][i][2]/3,Utils3D.projectVector(matrixes.siblingOffsets[int(Math.random()*0.2*matrixes.siblingOffsets.length)],treeData[5][i][3])]);
					treeData[4].push([treeData[5][i][0][0],Math.floor(treeData[0].push(treeData[0][treeData[5][i][0][1]*3]+treeData[5][treeData[5].length-1][3].x,treeData[0][treeData[5][i][0][1]*3+1]+treeData[5][treeData[5].length-1][3].y,treeData[0][treeData[5][i][0][1]*3+2]+treeData[5][treeData[5].length-1][3].z)/3)-1,treeData[5][i][0][2],treeData[5][i][0][3]*0.5]);
					treeData[5][treeData[5].length-1][0]=treeData[4][treeData[4].length-1];
				}
				treeData[5][i][1]+=0.1*(Math.round(Math.random())*2-1);
				treeData[5][i][2]+=0.1*(Math.round(Math.random())*2-1);
				treeData[5][i][3]=Utils3D.projectVector(matrixes.growthRotation[int(((int((treeData[5][i][1])/Math.abs(treeData[5][i][1]))+1)+2*(int((treeData[5][i][2])/Math.abs(treeData[5][i][2]))+1))/2)],treeData[5][i][3]);
				treeData[4].push([
					treeData[5][i][0][1],
					Math.floor(
						treeData[0].push(
							treeData[0][treeData[5][i][0][1]*3]+treeData[5][i][3].x,
							treeData[0][treeData[5][i][0][1]*3+1]+treeData[5][i][3].y,
							treeData[0][treeData[5][i][0][1]*3+2]+treeData[5][i][3].z
						)/3
					)-1,
					treeData[5][i][0][2]-0x010000+0x000500,
					treeData[5][i][0][3]*0.95
				]);
				if (treeData[4][treeData[4].length-1][3]<0.3) {	treeData[5].splice(i--,1);}
				else {treeData[5][i][0]=treeData[4][treeData[4].length-1];}
			}
			matrixes.transformMatrix.prependRotation(3, Vector3D.Y_AXIS);
			matrixes.transformMatrix.transformVectors(treeData[0], treeData[2]);
			treeData[4].sort(compareLines);
			Utils3D.projectVectors(matrixes.projectionMatrix, treeData[2], treeData[1], treeData[3]);
			graphics.clear();
			for (i=0; i<treeData[4].length; i++) {
				graphics.drawGraphicsData(Vector.<IGraphicsData>([new GraphicsStroke(treeData[4][i][3]*(10-((treeData[2][treeData[4][i][0]*3+2]+treeData[2][treeData[4][i][1]*3+2])*0.5)),false,"normal",CapsStyle.ROUND,JointStyle.ROUND,3, new GraphicsSolidFill(treeData[4][i][2])),new GraphicsPath(Vector.<int>([1,2]),Vector.<Number>([200+treeData[1][treeData[4][i][0]*2],200+treeData[1][treeData[4][i][0]*2+1],200+treeData[1][treeData[4][i][1]*2],199+treeData[1][treeData[4][i][1]*2+1]]))]));
			}
		}
	}
	
}

