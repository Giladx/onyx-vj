/** 
 * The code in this file is derived from code found here:
 *    http://www.actionscript.com/Article/tabid/54/ArticleID/using-hls-color-instead-of-rgb/Default.aspx
 * which in turn was based on C# code found here:
 *    http://www.vbaccelerator.com/home/VB/Code/vbMedia/Colour_Models/Hue__Luminance_and_Saturation/article.asp
 */
package onyx.utils {



	public class HLS {
		
		private var _red : Number = 0;
		private var _green : Number = 0;
		private var _blue : Number = 0;
		private var _hue : Number = 0;
		private var _luminance 	: Number = 0;
		private var _saturation : Number = 0;
		
		public function HLS(h:Number, l:Number, s:Number ) {
			_hue = h;
			_luminance = l;
			_saturation = s;
			_ToRGB();
		}
		public function get rgb () : uint {
			return (_red<<16) | (_green<<8) | (_blue);
		}
		public function set rgb (c:uint) : void {
			_red = (c>>16) & 0xff;
			_green = (c>>8) & 0xff;
			_blue = c & 0xff;
			_ToHLS();
		}
		public function set hls (a:Array):void {
			// Note, no sanity checking on values is done.
			_hue = a[0];
			_luminance = a[1];
			_saturation = a[2];
			_ToRGB();
		}
		public function get red () : Number
		{
			return (_red);
		}
		public function set red (n : Number) : void
		{
			_red = n;
			_ToHLS ();
		}
		public function get green () : Number
		{
			return (_green);
		}
		public function set green (n : Number) : void
		{
			_green = n;
			_ToHLS ();
		}
		public function get blue () : Number
		{
			return (_blue);
		}
		public function set blue (n : Number) : void
		{
			_blue = n;
			_ToHLS ();
		}
		public function get luminance () : Number
		{
			return (_luminance);
		}
		public function set luminance (n : Number) : void
		{
			if (n < 0 || n > 1)
			{
				trace (n + " exceeds luminance bounds.  Luminance must be between 0.0 and 1.0");
			} else
			{
				_luminance = n;
				_ToRGB ();
			}
		}
		public function get hue () : Number
		{
			return (_hue);
		}
		public function set hue (n : Number) : void
		{
			if (n < 0 || n > 360)
			{
				trace (n + " exceeds hue bounds.  Hue must be between 0.0 and 360.0");
			} else
			{
				_hue = n;
				_ToRGB ();
			}
		}
		public function get saturation () : Number
		{
			return (_saturation);
		}
		public function set saturation (n : Number) : void
		{
			if (n < 0 || n > 1)
			{
				trace (n + "exceeds saturation bounds.  Saturation must be between 0.0 and 1.0");
			} else
			{
				_saturation = n;
				_ToRGB ();
			}
		}
		public function lightenBy(n:Number):void {
			_luminance *= (1 + n);
			if(_luminance > 1) {
				_luminance = 1;
			}
			_ToRGB();
		}
		public function darkenBy(n:Number):void {
			_luminance *= n;
			_ToRGB();
		}
		private function _ToHLS ():void {
			var minval:Number = Math.min(_red, Math.min(_green, _blue));
			var maxval:Number = Math.max(_red, Math.max(_green, _blue));
			var mdiff:Number = maxval-minval;
			var msum:Number = maxval + minval;
			_luminance = msum / 510;
			if(maxval == minval) {
				_saturation = 0;
				_hue = 0;
			}
			else {
				var rnorm:Number = (maxval - _red) / mdiff;
				var gnorm:Number = (maxval - _green) / mdiff;
				var bnorm:Number = (maxval - _blue) / mdiff;
				_saturation = (_luminance <= .5) ? (mdiff/msum) : (mdiff / (510 - msum));
				if(_red == maxval) {
					_hue = 60 * (6 + bnorm - gnorm);
				} else if (_green == maxval) {
					_hue = 60 * (2 + rnorm - bnorm);
				} else if (_blue == maxval) {
					_hue = 60 * (4 + gnorm - rnorm);
				}
				_hue %= 360;
			}
		}
		private function _ToRGB():void {
			if(_saturation == 0){
				_red = _green = _blue = _luminance * 255;
				
			} else {
				var rm1:Number;
				var rm2:Number;
				if(_luminance <= 0.5) {
					rm2 = _luminance + _luminance * _saturation;
				} else {
					rm2 = _luminance + _saturation - _luminance * _saturation;
				}
				rm1 = 2 * _luminance - rm2;
				_red = _ToRGB1(rm1, rm2, _hue + 120);
				_green = _ToRGB1(rm1, rm2, _hue);
				_blue = _ToRGB1(rm1, rm2, _hue - 120);
			}
		}
		private function _ToRGB1(rm1:Number, rm2:Number, rh:Number):Number {
			if(rh > 360){
				rh -= 360;
			} else if (rh < 0) {
				rh += 360;
			}
			if(rh < 60) {
				rm1 = rm1 + (rm2 - rm1) * rh / 60;
			} else if (rh < 180) {
				rm1 = rm2;
			} else if (rh < 240) {
				rm1 = rm1 + (rm2 - rm1) * (240 - rh) / 60;
			}
			return(rm1 * 255);
		}
		public function toString():String {
			return "HLS(r="+_red.toString()
				+" g="+_green.toString()
				+" b="+_blue.toString()
				+" h="+_hue.toString()
				+" l="+_luminance.toString()
				+" s="+_saturation.toString()
				+")";
		}
	}
}