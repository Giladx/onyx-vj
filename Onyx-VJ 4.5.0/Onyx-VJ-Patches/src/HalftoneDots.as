/**
 * Copyright Lawiz ( http://wonderfl.net/user/Lawiz )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/dtWX
 */

// forked from Aquioux's [WebCam] èª?ã??ã??ã??ã??ã?? -Anyone Seurat-
package {
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.Matrix;
    
    import onyx.core.*;
    import onyx.parameter.*;
    import onyx.plugin.*;
	
	public class HalftoneDots extends Patch
	{       
		private var _data:BitmapData;
		private var source:Bitmap = new Bitmap(new AssetForAbstractPainting());
		private var bd:BitmapData = new AssetForAbstractPainting();		
		private var matrix_:Matrix;
		private var smooth:Smooth;  
		private var tone:HalftoneColor; 
		public function HalftoneDots():void 
		{
			_data = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000);
			matrix_ = new Matrix( 1, 0, 0, 1, 0, 0);  
			
			_data.draw(bd, matrix_);
			smooth = new Smooth();       
			smooth.strength = 2;
			tone = new HalftoneColor();    
			tone.size = 20;
			
			filters = [new BlurFilter(8, 8, BitmapFilterQuality.MEDIUM)];
        }
		override public function render(info:RenderInfo):void 
		{			
            _data.draw(source, matrix_);
			
			smooth.applyEffect(_data);   
			tone.applyEffect(_data);      
			
			info.render( _data );		
		}
    }
}
			
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.geom.Rectangle;
    /**
     * @author YOSHIDA, Akio (Aquioux)
     */
    class HalftoneColor implements IEffector 
	{
        public function set size(value:uint):void {
            _size = value;

            wNum_ = Math.ceil(width_  / _size);    
            hNum_ = Math.ceil(height_ / _size);    
            
            if (blockBmd_) blockBmd_.dispose();
            blockBmd_ = new BitmapData(_size, _size);
            
            blockRect_.width = blockRect_.height = _size;
            
            blockPixels_ = _size * _size;
        }
        private var _size:uint = 16;               
        private var width_:Number;           
        private var height_:Number;           

        private var wNum_:uint;               
        private var hNum_:uint;               
        
        private var blockBmd_:BitmapData;    
        private var blockRect_:Rectangle;
        private var blockPixels_:uint;       
        
        static private var rBmd_:BitmapData;    // for RED Channel
        static private var gBmd_:BitmapData;    // for GREEN Channel
        static private var bBmd_:BitmapData;    // for BLUE Channel
        static private var bufferBmds_:Array;

        static private var totalRect_:Rectangle;


        public function HalftoneColor(width:Number = 0.0, height:Number = 0.0) {
            width_  = width;   
            height_ = height;   
            blockRect_ = new Rectangle();
            if (width_ != 0.0 && height_ != 0.0) init(width, height);
        }

        public function applyEffect(value:BitmapData):BitmapData {
            
            if (rBmd_){
                rBmd_.fillRect(totalRect_, 0x00000000);
                gBmd_.fillRect(totalRect_, 0x00000000);
                bBmd_.fillRect(totalRect_, 0x00000000);
            }

            if (width_ == 0.0 || height_ == 0.0) init(value.width, value.height);

            var saveBmd:BitmapData = value.clone();   
            value.fillRect(value.rect, 0xFF000000);    

            value.lock();
            for (var i:int = 0; i < hNum_; i++) {
                for (var j:int = 0; j < wNum_; j++) {
                    var px:Number = j * _size;
                    var py:Number = i * _size;
                    
                    blockRect_.x = px;
                    blockRect_.y = py;
                    blockRect_.width  = blockRect_.height = _size;
                    
                    blockBmd_.copyPixels(saveBmd, blockRect_, EffectorUtils.ZERO_POINT);
                    
                    var brightness:Vector.<uint> = getAverageBrightness(blockBmd_.histogram());
                    for (var k:int = 0; k < 3; k++) {
                        
                        var blockSize:Number = _size * (brightness[k] / 255) * 0.9;    // 90% 
                        
                        var offset:Number = (_size - blockSize) / 2;
                        
                        blockRect_.x = px + offset + Math.random() - 0.5;
                        blockRect_.y = py + offset + Math.random() - 0.5;
                        blockRect_.width = blockRect_.height = blockSize;
                       
                        bufferBmds_[k].fillRect(blockRect_, 0xFFFFFFFF);
                    }
                }
            }
            value.copyChannel(rBmd_, totalRect_, EffectorUtils.ZERO_POINT, BitmapDataChannel.RED, BitmapDataChannel.RED);
            value.copyChannel(gBmd_, totalRect_, EffectorUtils.ZERO_POINT, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
            value.copyChannel(bBmd_, totalRect_, EffectorUtils.ZERO_POINT, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
            value.unlock();
            return value;
        }
        

        private function init(width:Number, height:Number):void {
            width_  = width;    
            height_ = height;   
            size    = _size;    

            rBmd_ = new BitmapData(width_, height_, true, 0x00000000);
            gBmd_ = rBmd_.clone();
            bBmd_ = rBmd_.clone();
            bufferBmds_ = [rBmd_, gBmd_, bBmd_];
            totalRect_ = new Rectangle(0, 0, width_, height_);
        }

        private function getAverageBrightness(hist:Vector.<Vector.<Number>>):Vector.<uint> {
            var rSum:uint = 0;
            var gSum:uint = 0;
            var bSum:uint = 0;
            for (var i:int = 0; i < 256; i++) {
                rSum += i * hist[0][i];
                gSum += i * hist[1][i];
                bSum += i * hist[2][i];
            }
            var r:uint = rSum / blockPixels_ >> 0;
            var g:uint = gSum / blockPixels_ >> 0;
            var b:uint = bSum / blockPixels_ >> 0;
            
            return Vector.<uint>([r, g, b]);
        }
    }


    import flash.display.BitmapData;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;
    /**
     * BlurFilter ã??ã??ã??å??æ??å??
     * @author YOSHIDA, Akio (Aquioux)
     */
    class Smooth implements IEffector {
        
        public function set strength(value:Number):void {
            blurFilter_.blurX = blurFilter_.blurY = value;
        }
        
        public function set quality(value:int):void {
            blurFilter_.quality = value;
        }

        private var blurFilter_:BlurFilter;

        public function Smooth() {
            blurFilter_ = new BlurFilter(2, 2, BitmapFilterQuality.MEDIUM);
        }
        
        public function applyEffect(value:BitmapData):BitmapData {
            value.applyFilter(value, value.rect, EffectorUtils.ZERO_POINT, blurFilter_);
            return value;
        }
    }


    import flash.display.BitmapData;
    /**
     * BitmapDataEffector interface
     * @author YOSHIDA, Akio (Aquioux)
     */
    interface IEffector {
        function applyEffect(value:BitmapData):BitmapData;
    }


    import flash.geom.Point;
    /**
     * bitmapDataEffector 
     * @author YOSHIDA, Akio (Aquioux)
     */
    class EffectorUtils 
	{
        static public const ZERO_POINT:Point = new Point(0, 0);
    }
