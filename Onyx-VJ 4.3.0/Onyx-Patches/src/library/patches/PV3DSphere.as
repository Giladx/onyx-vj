package library.patches
{
	import flash.display.Sprite;
	
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
	
	public class PV3DSphere extends BasicView
	{
		public function PV3DSphere()
		{
			super( 800, 600 );
			scene.addChild( new Sphere( null, 100, 15, 12 ) );
			camera.fov = 30;
			startRendering();
		}
	}
}