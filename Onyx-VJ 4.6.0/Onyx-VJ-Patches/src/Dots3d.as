/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/c78C
 */

// forked from yd_niku's [1æ—¥1Wonderfl] 3Dã§å…¥ã‚Œå­æ§‹é€ ã‚’ã¤ãã‚‹
// forked from yd_niku's [1æ—¥1Wonderfl] graphicsã¤ã‹ã£ãŸã‚‰ãªã‚“ã‹ã™ã’ãƒ¼é€Ÿããªã£ãŸ
// forked from yd_niku's [1æ—¥1Wonderfl] å¤šå°‘é€Ÿããªã£ãŸã‘ã©ä½™è¨ˆãªã“ã¨ã‚’ã—ãŸä¾‹
// forked from yd_niku's [1æ—¥1Wonderfl] BitmapDataã«ã—ã¦ã¿ãŸã‘ã©ã‚ã‚“ã¾ã‚Šé€Ÿããªã£ã¦ãªã„ä¾‹
// forked from yd_niku's [1æ—¥1Wonderfl] Vector3Dä½¿ã£ã¦ã¿ãŸ
// forked from yd_niku's [1æ—¥1Wonderfl]Matrix3Dä½¿ã£ã¦ã¿ãŸ
// Matrix3Dã‚’ä½¿ã£ã¦ã¿ãŸãƒãƒ¼ã‚¸ãƒ§ãƒ³
package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.filters.*;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	public class Dots3d extends Patch 
	{ 
		private var emitterCount:int = 0;
		private var windCount:int = 0;
		
		private var _camera:Camera;
		private var _scene:Cast;		
		private var _background:BitmapData;
		private var _canvas:Shape;
		private var sprite:Sprite;
		private static const BGCOLOR:uint = 0xFF000000;
		private static const O:Point = new Point();
		private static const BLUR:BitmapFilter = new BlurFilter( 2,  2, 1 );
		private static const ALPHA:ColorTransform= new ColorTransform( 0.9, 0.5, 0.9, 1, 12, 3, 2, 0 );
		private var mx:int = 0;
		private var my:int = 0;
	
		public function Dots3d() 
		{
			Console.output('Dots3d v 0.0.1');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			
			sprite = new Sprite();
			addChild(sprite);
			
			_background= new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, BGCOLOR );
			sprite.addChild( new Bitmap(_background ) );
			
			_canvas = new Shape();
			sprite.addChild(_canvas );
			
			// Set up 3D Elements
			_scene = new Cast();
			createElements();
			
			_camera = new Camera();
			_camera.zoom = 0.5;
			_camera.fl= 500;
			_camera.y= 300;
			_camera.z= 500;
			_camera.rotateX= 0;
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}
		override public function render(info:RenderInfo):void 
		{
			updateMotion();
			
			updateParticles();
			
			_scene.projection( _camera, _camera );
			
			renderScene();
			info.render( sprite );		
		}
		private function mouseDown(evt:MouseEvent) : void {
			mx = evt.localX; 
			my = evt.localY; 
			
		}		
		private function updateMotion():void {
			// Camera Motion
			_camera.rotateX +=  (( 90* (my - World.CENTER.y) / 435 +20 ) - _camera.rotateX  )* 0.05 ;
			_camera.rotateY +=  (( -120 * (mx - World.CENTER.x) / 435 ) - _camera.rotateY ) * 0.03;
			_camera.y +=  (( 200 * (my - World.CENTER.y) / 435 + 400 ) - _camera.y ) * 0.03;
			
			// Particle 
			if( emitterCount++ % 6 == 0) emitter();
			//if( windCount++ % 50 == 0 ) changeWind();
			
			// 3D Model
			_scene.rotateY += 1;
		}
		
		
		/**
		 * Field Elements 
		 */
		private function createElements():void {
			const wlength:uint = 6;
			const hlength:uint = 6;
			const intervalX:uint = 100;
			const intervalY:uint = 100;
			for( var i:int = 0; i< wlength; ++i ) {
				for( var j:int = 0; j< hlength; ++j ) {
					var ball:Ball = new Ball( ( i - wlength*0.5 ) * intervalX, 0, ( j - hlength*0.5 ) * intervalY, 5, 0xFFFFFF99 );
					_scene.addChild( ball );
				}
			}
			ball= new Ball( 0, 0, 0, 3, 0xFFFFFFFF ); 
			_scene.addChild( ball );
		}
		
		/**
		 * Particle System
		 */
		private var _particles:Vector.<Particle > = new Vector.<Particle >();
		private  var _clearList:Vector.<Cast> = new Vector.<Cast>();
		private const G:Vector3D= new Vector3D( 0, 0.2, 0 );
		private const FRICTION:Number = 0.98; 
		private const WIND:Vector3D= new Vector3D( -0.08, 0.01, 0.10 );
		
		private function emitter():void {
			for( var i:int=0; i<16; ++i ) {
				var p:Particle = new Particle(
					Math.random()*100-50, 
					Math.random()*100-50,
					0,
					Math.random()*20+2, 
					0xFF000000
				);
				p.vx = Math.random()*30-15;
				p.vy = -40 * Math.random() - 20;
				p.vz = Math.random()*30-15;
				
				_scene.addChild( p );
				_particles.push( p );
			}
		}
		private function updateParticles():void {
			var force:Vector3D = G.add( WIND );
			for each( var p :Particle in _particles ) {
				if( p.life <= 0 ) {
					_clearList.push(p);
					continue;
				}
				p.velocity.scaleBy( FRICTION );
				p.velocity.incrementBy( force );
				p.position.incrementBy( p.velocity );
				
				p.life--;
			}
			
			while( (p=_clearList.shift() as Particle)!=null ){
				_scene.removeChild( p );
				var i:int = _particles.indexOf( p );
				_particles .splice(i,1);
			}
		}
		private function changeWind():void {
			WIND.incrementBy(
				new Vector3D( 
					( Math.random()-0.5 ) * 0.1,
					( Math.random()-0.5 ) * 0.1,
					( Math.random()-0.5 ) * 0.03
				)
			);
		}
		
		/**
		 * Rendering System
		 */
		private function renderScene():void 
		{
			_canvas.graphics.clear();
			for each( var cast:Cast in Cast.renderList  ) {
				cast.render( _canvas.graphics );
			}
			
			_background.applyFilter( _background, _background.rect, O, BLUR );
			_background.colorTransform( _background.rect, ALPHA );
			_background.draw( _canvas );    
		}
		
	}
}



import flash.display.*;
import flash.geom.*;
import flash.filters.*;

internal class World {
	public static const CENTER:Vector3D= new Vector3D(220,220,600);
}

internal class Cast {
	// for Calcuration 
	public var position:Vector3D;
	public var rotate:Vector3D;
	public var scale:Vector3D;
	public function Cast( x:Number = 0, y:Number =0, z:Number =0 ){
		position = new Vector3D( x, y, z );
		rotate = new Vector3D();
		scale = new Vector3D( 1, 1, 1 );
	}
	
	// Position
	public function set x( value:Number ):void{
		position.x = value;
	}
	public function get x():Number {
		return position.x;
	}
	public function set y( value:Number ):void{
		position.y = value;
	}
	public function get y():Number {
		return position.y;
	}
	public function set z( value:Number ):void{
		position.z = value;
	}
	public function get z():Number {
		return position.z;
	}
	
	// Rotation
	public function set rotateX( value:Number ):void{
		rotate.x = value;
	}
	public function get rotateX():Number {
		return rotate.x;
	}
	public function set rotateY( value:Number ):void{
		rotate.y = value;
	}
	public function get rotateY():Number {
		return rotate.y;
	}
	public function set rotateZ( value:Number ):void{
		rotate.z = value;
	}
	public function get rotateZ():Number {
		return rotate.z;
	}
	
	// Scale
	public function set scaleX( value:Number ):void{
		scale.x = value;
	}
	public function get scaleX():Number {
		return scale.x;
	}
	public function set scaleY( value:Number ):void{
		scale.y = value;
	}
	public function get scaleY():Number {
		return scale.y;
	}
	public function set scaleZ( value:Number ):void{
		scale.z = value;
	}
	public function get scaleZ():Number {
		return scale.z;
	}
	
	// for Rendering
	public var view:Matrix3D= new Matrix3D();
	public var screen:Vector3D= new Vector3D();
	
	public static var renderList:Vector.<Cast> = new Vector.<Cast>();
	
	public function get transform():Matrix3D {
		var mat:Matrix3D = new Matrix3D();
		mat.appendTranslation( position.x, position.y, position.z );
		mat.appendScale( scale.x, scale.y, scale.z );
		mat.appendRotation( rotate.x, Vector3D.X_AXIS );
		mat.appendRotation( rotate.y, Vector3D.Y_AXIS );
		mat.appendRotation( rotate.z, Vector3D.Z_AXIS );
		//var vec :Vector.<Vector3D> = new Vector.<Vector3D>();
		//vec.push( position, rotate, scale  );
		//mat.recompose( vec, Orientation3D.AXIS_ANGLE );
		return mat;
	}
	
	public function projection( parent:Cast, camera:Camera ):Number{
		if( parent is Camera ) {
			view = parent.transform.clone();
			view.append( transform );
		}
		else {
			view = parent.view.clone();
			view.prepend( transform );
		}
		var persp:Number = (camera.fl* camera.zoom) / (camera.fl+ view.position.z );
		screen.x = view.position.x * persp + World.CENTER.x;
		screen.y = view.position.y * persp + World.CENTER.y;
		screen.z = view.position.z;
		
		var screenZ:Number = 0;
		for each( var child:Cast in _children ) screenZ+=child.projection( this, camera );
		return persp;
	}
	
	private var _children:Vector.<Cast> = new Vector.<Cast>();
	public function addChild( cast:Cast ):Cast {
		var index:int = _children.indexOf( cast );
		if( index == -1 ) {
			_children.push( cast );
			renderList.push( cast );
		}
		return cast;
	}
	public function removeChild( cast:Cast ):Cast {
		var index:int = _children.indexOf( cast );
		_children.splice( index, 1 );
		
		index = renderList.indexOf( cast );
		renderList.splice( index, 1 );
		return cast;
	}
	
	// Render
	public function render( canvas:Graphics, focus:Number = 500 ) :void {
	}
}

internal class Camera extends Cast {
	public var fl:Number = 500;
	public var zoom:Number = 1.0;
	public function Camera( x:Number = 0, y:Number =0, z:Number =-300 ) {
		super( x, y, z );
	}
}

internal class Particle extends Cast {
	public var velocity:Vector3D;
	public var life:int;
	public var color:uint = 0;
	public var mass:int = 0;
	
	public function Particle ( x:Number = 0, y:Number =0, z:Number =0, m:int= 10, c:uint = 0xFFcc0000 ) {
		super( x, y, z );
		mass = m;
		color = c;
		
		velocity= new Vector3D();
		life = Math.random()*100 + 100;
	}
	public function set vx( value:Number ):void {
		velocity.x = value;
	}
	public function get vx():Number {
		return velocity.x;
	}
	public function set vy( value:Number ):void {
		velocity.y = value;
	}
	public function get vy():Number {
		return velocity.y;
	}
	public function set vz( value:Number ):void {
		velocity.z = value;
	}
	public function get vz():Number {
		return velocity.z;
	}
	
	// Render
	public override function render( canvas:Graphics, focus:Number = 500 ) :void {
		var scale:Number = focus / ( focus + screen.z );
		canvas.beginFill( color, scale);
		canvas.drawCircle( screen.x, screen.y,  mass*scale );
		canvas.endFill();    
	}
}

internal class Ball extends Particle {
	public function Ball( x:Number = 0, y:Number =0, z:Number =0, r:Number = 10.0, color:uint = 0xFFcc0000 ) {
		super( x, y, z,  r, color  );
	}
}
