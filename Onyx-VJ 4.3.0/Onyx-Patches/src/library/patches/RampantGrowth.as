/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 *  
 * Based on Rampant Growth 3D code by Edik RUZGA
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * 
 */
package library.patches {

	import flash.display.*
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	
	import flash.display.StageScaleMode;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	
	[SWF(width='320', height='240', frameRate='24', backgroundColor='#FFFFFF')]
	public class RampantGrowth extends Patch{ 
		
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
		var difference:Number;
		
		/**
		 * 	@constructor
		 */
		public function RampantGrowth() {
			Console.output('RampantGrowth');
			Console.output('Credits to Edik RUZGA (http://wonderwhy-er.deviantart.com/)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}
		private function mouseDown(event:MouseEvent):void 
		{
			treeData=[
				Vector.<Number>([0,1,0,0,0.8,0]),
				new Vector.<Number>(),
				new Vector.<Number>(),
				new Vector.<Number>(),
				[[0,1,0x442200,2.4]],
				[[[0,1,0x442200,2.0],0,0,new Vector3D(0, -0.1, 0)]]
			];		 
		} 
		
		public function compareLines(a:Array,b:Array):int {
			return -int((difference = (treeData[2][a[0]*3+2]+treeData[2][a[1]*3+2])/2-(treeData[2][b[0]*3+2]+treeData[2][b[1]*3+2])/2)/Math.abs(difference));
		}
		
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
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
			var gra:Shape = new Shape();
			gra.graphics.clear();
			for (i=0; i<treeData[4].length; i++) {
				gra.graphics.drawGraphicsData(Vector.<IGraphicsData>([new GraphicsStroke(treeData[4][i][3]*(10-((treeData[2][treeData[4][i][0]*3+2]+treeData[2][treeData[4][i][1]*3+2])*0.5)),false,"normal",CapsStyle.ROUND,JointStyle.ROUND,3, new GraphicsSolidFill(treeData[4][i][2])),new GraphicsPath(Vector.<int>([1,2]),Vector.<Number>([200+treeData[1][treeData[4][i][0]*2],200+treeData[1][treeData[4][i][0]*2+1],200+treeData[1][treeData[4][i][1]*2],199+treeData[1][treeData[4][i][1]*2+1]]))]));
			}
			info.source.draw(gra);


		}
	}
	
}

