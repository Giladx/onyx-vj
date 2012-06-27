/**
 * Copyright quail24eggs ( http://wonderfl.net/user/quail24eggs )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/zRh0
 */

package inprogress 
{
	/*Each of the faces of the cube is created in the function 
	*createSqr(). This also puts white eyes on each of the 
	*faces (line 61).
	* 
	*The origin of each of these faces is moved to the point 
	*of intersection of diagonals of the square faces by being
	*caged in other Sprites (line 43, 56, 57).
	* 
	*The arrangeSqr() arranges the faces in a Sprite (hex) for
	*proper angles and coordinates to make dice.
	* 
	*When cursor moves, the distance to the center of the 
	*dice is used to change the angle of rotation of the dice 
	*by rotateHex() (line 101). 
	* 
	*In hexSetOrder(), the distance along z axis between the 
	*center of the dice and the point of intersection of 
	*diagonals of each of the faces are compared with each 
	*other to rearrange the layers.
	*/
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Dice extends Patch 
	{
		
		private var hex:Sprite = new Sprite();//cube
		private var dec:Number = 1/80;//deceleration
		private var stgX:Number = DISPLAY_WIDTH / 2;
		private var stgY:Number = DISPLAY_HEIGHT / 2;
		private var uni:Number = 200; //lattice const.
		private var uniH:Number = uni / 2; //half of lattice const.
		private var trs:Number = 0.2;//transparency
		private var mx:int = 0;
		private var my:int = 0;
		
		public function Dice():void 
		{
			hex.addChild(arrangeSqr(1, 0, 0, -uniH,0 , 0));
			hex.addChild(arrangeSqr(5, uniH, 0, 0, -90, 0));
			hex.addChild(arrangeSqr(6, 0, 0, uniH, -180, 0));
			hex.addChild(arrangeSqr(2, -uniH, 0, 0, 90, 0));
			hex.addChild(arrangeSqr(4, 0, -uniH, 0, 0, -90));
			hex.addChild(arrangeSqr(3, 0, uniH, 0, 0, 90));
			
			hex.x = stgX;
			hex.y = stgY;
			hex.z = 0;// An error occurs without this statement!
			addChild(hex);
			
			hexSetOrder();
			addEventListener( MouseEvent.MOUSE_DOWN, mouse );
		}	
		private function mouse(evt:MouseEvent) : void {
			mx = evt.localX; 
			my = evt.localY; 
			
		}
		private function arrangeSqr(eye:int, hexX:Number, hexY:Number, hexZ:Number, aglY:Number, aglX:Number):Sprite 
		{
				var face:Sprite = new Sprite();
				face.addChild(createSqr(eye));
				face.x = hexX;
				face.y = hexY;
				face.z = hexZ;
				face.rotationY = aglY;
				face.rotationX = aglX;
				return face;
		}
			
		private	function createSqr(eye:int):Sprite 
		{
			var sqr:Sprite = new Sprite();
			var rad:Number = uni / 12;
			sqr.graphics.beginFill(0xFFFFFF*Math.random() , trs); //color and transparency
			sqr.x = -uniH;
			sqr.y = -uniH;
			sqr.graphics.drawRect(0, 0, uni, uni);
			sqr.graphics.beginFill(0xFFFFFF, 1);
			
			switch (eye) {
				case 1:
					sqr.graphics.drawCircle(uniH, uniH, rad*1.4);
					break;
				case 2:
					sqr.graphics.drawCircle(uni / 4, uni / 4, rad);
					sqr.graphics.drawCircle(uni * 3 / 4,uni * 3 / 4, rad);
					break;
				case 3:
					sqr.graphics.drawCircle(uni / 4, uni / 4, rad);
					sqr.graphics.drawCircle(uniH, uniH, rad);
					sqr.graphics.drawCircle(uni * 3 / 4,uni * 3 / 4, rad);
					break;
				case 4:
					sqr.graphics.drawCircle(uni / 4, uni / 4, rad);
					sqr.graphics.drawCircle(uni * 3 / 4, uni / 4, rad);
					sqr.graphics.drawCircle(uni / 4, uni * 3 / 4, rad);
					sqr.graphics.drawCircle(uni * 3  / 4, uni * 3 / 4, rad);
					break;
				case 5:
					sqr.graphics.drawCircle(uni / 4, uni / 4, rad);
					sqr.graphics.drawCircle(uni * 3 / 4, uni / 4, rad);
					sqr.graphics.drawCircle(uni / 4, uni * 3 / 4, rad);
					sqr.graphics.drawCircle(uni * 3  / 4, uni * 3 / 4, rad);
					sqr.graphics.drawCircle(uniH, uniH, rad);
					break;
				case 6:
					sqr.graphics.drawCircle(uni / 4, uni / 4, rad);
					sqr.graphics.drawCircle(uni * 3 / 4, uni / 4, rad);
					sqr.graphics.drawCircle(uni / 4, uniH, rad);
					sqr.graphics.drawCircle(uni * 3 / 4, uniH, rad);
					sqr.graphics.drawCircle(uni / 4, uni * 3 / 4, rad);
					sqr.graphics.drawCircle(uni * 3  / 4, uni * 3 / 4, rad);
					break;
			}
			sqr.graphics.endFill();
			return sqr;
		}
		override public function render(info:RenderInfo):void 
		{			
		
			var hexMatrix3D:Matrix3D = hex.transform.matrix3D;
			var rotY:Number = (mx - stgX) * dec;
			var rotX:Number = (my - stgY) * dec;
			hexMatrix3D.appendTranslation(-stgX,-stgY,0);
			hexMatrix3D.appendRotation(-rotY, Vector3D.Y_AXIS);
			hexMatrix3D.appendRotation(rotX, Vector3D.X_AXIS);
			hexMatrix3D.appendTranslation(stgX,stgY,0);
			hexSetOrder();
		
			info.render( hex );		
		}
		private function hexSetOrder():void 
		{
			var hexArray:Array = new Array();
			var hexFaces:uint = hex.numChildren;
			var i:uint;
			var hexSprite:Sprite;
			for (i = 0; i < hexFaces; i++) 
			{
				hexSprite = hex.getChildAt(i) as Sprite;
				var hexVector3D:Vector3D = hexSprite.transform.getRelativeMatrix3D(hex).position;
				var vZ:Number = hexVector3D.z;
				hexArray.push({face:hexSprite, z:vZ});
			}
			hexArray.sortOn("z", Array.NUMERIC | Array.DESCENDING);
			for (i = 0; i < hexFaces; i++ ) 
			{
				hexSprite = hexArray[i].face;
				hex.setChildIndex(hexSprite, i);
			}
		}

	}
}