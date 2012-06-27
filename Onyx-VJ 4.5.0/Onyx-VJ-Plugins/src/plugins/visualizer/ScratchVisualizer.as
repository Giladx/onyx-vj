/**
 * Copyright devon_o ( http://wonderfl.net/user/devon_o )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/iYlE
 */
package plugins.visualizer {
	
	
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.Sound;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class ScratchVisualizer extends Visualizer
	{
		private var mLoadedSong:Sound;
		private var mScratchDisplay:ScratchDisplay;
		private var mRightSoundDiplay:ScratchDisplay;
		
		[Embed(source="../assets/batchass.mp3")]
		public var soundClass:Class;
		
		public function ScratchVisualizer() {
			
			Console.output('ScratchVisualizer from devon_o ( http://wonderfl.net/user/devon_o )');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
						
		}
		public function load():void
		{
			mLoadedSong = new soundClass() as Sound;
			mScratchDisplay = new ScratchDisplay();
			mScratchDisplay.loadSound(mLoadedSong);
			//mLoadedSong.play();
			mScratchDisplay.play();
			
		}
		override public function render(info:RenderInfo):void 
		{
			if ( mScratchDisplay )
			{
				mScratchDisplay.mouseMove(null);
				info.render( mScratchDisplay );
				
			}
		}
			
	}	
}

//    ***** SCRATCH DISPLAY ****   //
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.SampleDataEvent;
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.ByteArray;
import flash.utils.getTimer;

class ScratchDisplay extends Sprite
{
	private const WRITE_SIZE:int             = 2048;
	private const PLAYBACK_FREQUENCY:Number = 44100.0;
	private const DRAG:Number                 = .25;
	private const SPEED_EASE:Number         = 1.0;
	private const SPEED_MULT:Number            = 24;
	private const MOVE_EASE:Number             = 1.0;
	
	private const BYTE_POSITION_TO_PIXELS:Number  = 0.00004;    // original = .0004
	
	public var mSoundData:ByteArray;
	
	private var mSamples:Vector.<Number>;
	private var mNumSamples:Number;
	
	private var mSound:Sound;
	private var mWaveHolder:Sprite;
	private var mPlayingSound:Sound;
	private var mDisplay:Shape;
	
	private var mIsScratching:Boolean;
	
	private var mPosition:Number = 0.0;
	private var mTargetSpeed:Number;
	private var mSpeed:Number = 2.0;
	
	private var mChannel:SoundChannel;
	private var mVolume:SoundTransform;
	
	private var mRatio:Number;
	private var mCenterX:Number;
	
	// throwing
	private var mDiffX:Number;
	private var mVelX:Number = 0.0;
	private var mCurrX:Number;
	private var mPrevX:Number;
	private var mFarLeft:Number;
	private var mFarRight:Number;
	
	public function ScratchDisplay()
	{
		mPlayingSound = new Sound();
		mVolume = new SoundTransform();
		mWaveHolder = new Sprite();
		
	}
	public function loadSound(sound:Sound)
	{
		mSound = sound;
		drawWaveForm();
		extractSamples();
		initSmoothBuffer();
		initDisplay();
	}
	
	public function play():void
	{
		mPlayingSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSample);
		mChannel = mPlayingSound.play();
		mWaveHolder.buttonMode = true;
		mWaveHolder.addEventListener(MouseEvent.MOUSE_DOWN, startScratch);
	}
	
	public function stop():void
	{
		mPlayingSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSample);
		mChannel.stop();
		mWaveHolder.buttonMode = false;
		mWaveHolder.removeEventListener(MouseEvent.MOUSE_DOWN, startScratch);
	}
	
	public function setVolume(value:Number):void
	{
		mVolume.volume = value;
		mChannel.soundTransform = mVolume;
	}
	
	private function initSmoothBuffer():void
	{
		var i:int = mSmoothBufferSize;
		while (i--)
		{
			mSmoothBuffer[i] = 0.0;
		}
	}
	
	public function wave_interpolator(x:Number, y:Vector.<Number>):Number
	{
		const offset:int = 2;
		
		var z:Number = x - 1 / 2.0; 
		var even1:Number = y[int(offset + 1)] + y[int(offset +  0)], odd1:Number = y[int(offset + 1)] - y[int(offset +  0)];
		var even2:Number = y[int(offset + 2)] + y[int(offset + -1)], odd2:Number = y[int(offset + 2)] - y[int(offset + -1)];
		var even3:Number = y[int(offset + 3)] + y[int(offset + -2)], odd3:Number = y[int(offset + 3)] - y[int(offset + -2)];
		
		var c0:Number = even1 * 0.42685983409379380 + even2 * 0.07238123511170030
			+ even3 * 0.00075893079450573;
		var c1:Number = odd1 * 0.35831772348893259 + odd2 * 0.20451644554758297
			+ odd3 * 0.00562658797241955;
		var c2:Number = even1 * -0.217009177221292431 + even2 * 0.20051376594086157
			+ even3 * 0.01649541128040211;
		var c3:Number = odd1 * -0.25112715343740988 + odd2 * 0.04223025992200458
			+ odd3 * 0.02488727472995134;
		var c4:Number = even1 * 0.04166946673533273 + even2 * -0.06250420114356986
			+ even3 * 0.02083473440841799;
		var c5:Number = odd1 * 0.08349799235675044 + odd2 * -0.04174912841630993
			+ odd3 * 0.00834987866042734;
		
		return ((((c5 * z + c4) * z + c3) * z + c2) * z + c1) * z + c0;
	}
	
	private function onSample(event:SampleDataEvent):void
	{
		var data:ByteArray = event.data;
		
		if (mIsScratching)
		{
			writeScratchStream(data);
			
		} else {
			
			writeNormalStream(data);
			mRatio = mPosition / mNumSamples;
			mWaveHolder.x = mCenterX - (mWaveHolder.width * mRatio);
		}
	}
	
	private function writeNormalStream(stream:ByteArray):void
	{
		for (var i:int = 0; i < WRITE_SIZE; i++)
		{
			var sample:Number = getNextSample();
			
			stream.writeFloat(sample);
			stream.writeFloat(sample);
			
			mPosition += mSpeed;
			if (mPosition >= mNumSamples)     mPosition = 0;
			if (mPosition < 0)                 mPosition = mNumSamples - 1;
		}
	}
	
	
	//    http://blog.glowinteractive.com/2011/01/vinyl-scratch-emulation-on-iphone/
	private var mAudioSampleSize:uint = 8;    // original = sizeof(float) * 2
	private var mScratchingBufferSize:uint = 500000;
	private var mSmoothBufferSize:uint = 3000;
	private var mScratchCircularBufferSamplePosition:int = 0;
	private var mScratchingPositionOffset:Number = 0.0;
	private var mScratchingPositionSmoothedVelocity:Number = 0.0;
	private var mScratchingPositionVelocity:Number = 0.0;
	// for smoothing of input
	private var mSmoothBuffer:Vector.<Number> = new Vector.<Number>(mSmoothBufferSize, true);
	private var mSmoothBufferPositionsUsed:int = 0;
	private var mSmoothBufferPosition:int = 0;
	
	private var mLeftInterpData:Vector.<Number> = new Vector.<Number>(6, true);
	private var mRightInterpData:Vector.<Number> = new Vector.<Number>(6, true);
	
	//    comments from original source. http://blog.glowinteractive.com/2011/01/vinyl-scratch-emulation-on-iphone/
	private function writeScratchStream(stream:ByteArray):void
	{
		var bufferBasePosition:Number = Number(mScratchCircularBufferSamplePosition);
		
		for (var i:int = 0; i < WRITE_SIZE; i++)
		{
			if (++mSmoothBufferPositionsUsed > int(mSmoothBufferSize))
			{
				mSmoothBufferPositionsUsed = mSmoothBufferSize;
			}
			
			// STEP 1
			// find moving average
			mScratchingPositionSmoothedVelocity -= mSmoothBuffer[mSmoothBufferPosition];
			mSmoothBuffer[mSmoothBufferPosition] = mScratchingPositionVelocity / mSmoothBufferPositionsUsed;
			mScratchingPositionSmoothedVelocity += mSmoothBuffer[mSmoothBufferPosition];
			mSmoothBufferPosition = (++mSmoothBufferPosition) % mSmoothBufferSize;
			var velocity:Number = mScratchingPositionSmoothedVelocity;
			
			// STEP 2
			// modify velocity to point to the correct position
			var targetOffset:Number = mPosition + mSpeed;
			var offsetDiff:Number = targetOffset - mPosition;
			velocity += offsetDiff * 10.0;
			
			// STEP 3
			// update scratch buffer position
			mScratchingPositionOffset += velocity / PLAYBACK_FREQUENCY;
			
			// find absolute scratch buffer position
			var fBufferPosition:Number = bufferBasePosition + mScratchingPositionOffset;
			
			// wrap fBufferPosition
			//TODO use fmodf but what's faster?
			while (fBufferPosition >= mScratchingBufferSize) fBufferPosition -= mScratchingBufferSize;
			while (fBufferPosition < 0) fBufferPosition += mScratchingBufferSize;
			
			// STEP 4
			// use interpolation to find a sample value
			var iBufferPosition:int = int(fBufferPosition);
			var rem:Number = fBufferPosition - iBufferPosition;
			
			var pos:int = 2 * (iBufferPosition - 2)
			var sample:Number = readSample(pos);
			mLeftInterpData[0] = sample;
			
			++pos;
			sample = readSample(pos);
			mRightInterpData[0] = sample;
			
			++pos;
			sample = readSample(pos);
			mLeftInterpData[1] = sample;
			
			++pos;
			sample = readSample(pos);
			mRightInterpData[1] = sample;
			
			++pos;
			sample = readSample(pos);
			mLeftInterpData[2] = sample;
			
			++pos;
			sample = readSample(pos);
			mRightInterpData[2] = sample;
			
			++pos;
			sample = readSample(pos);
			mLeftInterpData[3] = sample;
			
			++pos;
			sample = readSample(pos);
			mRightInterpData[3] = sample;
			
			++pos;
			sample = readSample(pos);
			mLeftInterpData[4] = sample;
			
			++pos;
			sample = readSample(pos);
			mRightInterpData[4] = sample;
			
			++pos;
			sample = readSample(pos);
			mLeftInterpData[5] = sample;
			
			++pos;
			sample = readSample(pos);
			mRightInterpData[5] = sample;
			
			stream.writeFloat(wave_interpolator(rem, mLeftInterpData));
			stream.writeFloat(wave_interpolator(rem, mRightInterpData));
		}
	}
	
	public function getNextSample():Number
	{
		var intPos:int = int(mPosition);
		return readSample(intPos);
	}
	
	private function readSample(pos:int):Number
	{
		while (pos < 0)             pos += mNumSamples;
		while (pos >= mNumSamples)     pos -= mNumSamples;
		
		return mSamples[pos];
	}
	
	private function clamp(target:Number, min:Number, max:Number):Number 
	{
		if (target < min) target = min;
		if (target > max) target = max;
		return target;
	}
	
	private function startScratch(event:MouseEvent):void
	{
		mIsScratching = true;    
		mPrevX = mWaveHolder.x
		mDiffX = event.localX - mWaveHolder.x;
		addEventListener(MouseEvent.MOUSE_UP, endScratch);
		addEventListener(Event.ENTER_FRAME, mouseMove);
	}
	
	private function endScratch(event:MouseEvent):void
	{
		removeEventListener(MouseEvent.MOUSE_UP, endScratch);
		removeEventListener(Event.ENTER_FRAME, mouseMove);
		addEventListener(Event.ENTER_FRAME, slide);
	}
	
	
	// ENTER FRAME FUNCTION
	public function mouseMove(event:Event):void
	{
		var tx:Number = mouseX - mDiffX;
		mWaveHolder.x += (tx - mWaveHolder.x) / MOVE_EASE;
		if (mWaveHolder.x < mFarLeft) mWaveHolder.x = mFarLeft;
		if (mWaveHolder.x > mFarRight) mWaveHolder.x = mFarRight;
		
		mVelX = mWaveHolder.x - mPrevX;
		mPrevX = mWaveHolder.x;
		
		setSpeed();
		
		setByteOffset(mSpeed / BYTE_POSITION_TO_PIXELS);
		update();
	}
	
	private var mPreviousTime:Number             = 0.0;
	private var mPositionOffset:Number             = 0.0;
	private var mPreviousPositionOffset:Number    = 0.0;
	private function update():void
	{
		var time:int = getTimer();
		var dt:Number = time - mPreviousTime;
		
		if (dt == 0.0)
			mScratchingPositionVelocity = 0.0;
		else
			mScratchingPositionVelocity =    (mPosition - mScratchingPositionOffset) / dt;
		
		mPreviousTime = time;
	}
	
	private function setByteOffset(offset:Number):void
	{
		mPosition = offset / mAudioSampleSize;
	}
	
	private function initDisplay():void
	{
		mDisplay = new Shape();
		mDisplay.graphics.beginFill(0x0, 0);
		mDisplay.graphics.lineStyle(0, 0x00FF00);
		mDisplay.graphics.drawRect(0, 0, 300, 150);
		mDisplay.graphics.lineStyle(0, 0xFF0000);
		mDisplay.graphics.moveTo(150, 0);
		mDisplay.graphics.lineTo(150, 150);
		mDisplay.graphics.endFill();
		
		var waveMask:Shape = new Shape();
		waveMask.graphics.beginFill(0xFF00FF);
		waveMask.graphics.drawRect(0, 0, 300, 150);
		waveMask.graphics.endFill();
		
		mCenterX = mDisplay.width >> 1;
		
		mWaveHolder.y = mDisplay.height >> 1;
		mWaveHolder.x = mCenterX;
		addChild(mWaveHolder);
		
		var r:Rectangle = new Rectangle( -mWaveHolder.width + mCenterX +2, mWaveHolder.y, mWaveHolder.width -4, 0);
		mFarLeft = r.left;
		mFarRight = r.right;
		
		mWaveHolder.mask = waveMask;
		addChild(waveMask);
		
		addChild(mDisplay);
	}
	
	private function drawWaveForm():void
	{
		mSoundData = new ByteArray();
		
		var max:Number = PLAYBACK_FREQUENCY * (mSound.length / 1000) - WRITE_SIZE;
		mSound.extract(mSoundData, max);
		mSoundData.position = 0;
		
		var yr:int = 35;
		var step:int = 1;
		var xp:int = 0;
		
		var waveform:Shape = new Shape();
		waveform.graphics.lineStyle(0, 0x00FF00);
		
		while(mSoundData.bytesAvailable > PLAYBACK_FREQUENCY * 2)
		{
			var minLeft:Number    = Number.MAX_VALUE;
			var minRight:Number    = Number.MAX_VALUE;
			var maxRight:Number = Number.MIN_VALUE;
			var maxLeft:Number = Number.MIN_VALUE;
			
			for (var i:uint = 0; i < 1024; i++)
			{                                                    
				var left:Number = mSoundData.readFloat();
				if (left > maxLeft) maxLeft    = left;
				if (left < minLeft) minLeft = left;
				var right:Number = mSoundData.readFloat();
				if (right > maxRight) maxRight = right;
				if (right < minRight) minRight = right;            
			}
			
			minLeft        *= yr;
			minRight    *= yr;
			maxLeft        *= yr;
			maxRight    *= yr;
			
			waveform.graphics.moveTo(xp, minLeft);
			waveform.graphics.lineTo(xp, maxLeft);
			xp++;
			
			waveform.graphics.moveTo(xp, minRight);
			waveform.graphics.lineTo(xp, maxRight);
			xp++;
		}
		waveform.cacheAsBitmap = true;
		mWaveHolder.graphics.beginFill(0x0);
		mWaveHolder.graphics.drawRect(0, -waveform.height * .5, waveform.width, waveform.height);
		mWaveHolder.graphics.endFill();
		mWaveHolder.cacheAsBitmap = true;
		mWaveHolder.addChild(waveform);
	}
	
	private function extractSamples():void
	{
		mNumSamples = Math.floor(mSoundData.length / 4);
		mSamples = new Vector.<Number>(mNumSamples, true);
		mSoundData.position = 0;
		for (var i:int = 0; i < mNumSamples; i++)
		{
			mSamples[i] = Number(mSoundData.readFloat());
		}
	}
	
	public function slide(event:Event):void
	{
		mWaveHolder.x += mVelX;
		if (mWaveHolder.x < mFarLeft)    mVelX *= -1;
		if (mWaveHolder.x > mFarRight)    mVelX *= -1;
		
		setSpeed();
		
		mVelX *= DRAG;
		
		// scratch is complete
		if (Math.abs(mVelX) <= .025)
		{
			removeEventListener(Event.ENTER_FRAME, slide);
			completeScratch();
		}
	}
	
	private function completeScratch():void
	{
		mRatio = (mWaveHolder.x - mCenterX) / mWaveHolder.width;
		mPosition = -mRatio * mNumSamples;
		mPosition = clamp(mPosition, 0, mNumSamples - 1);
		mSpeed = 2.0;
		mIsScratching = false;
	}
	
	private function setSpeed():void
	{
		mTargetSpeed = mVelX * SPEED_MULT;
		mSpeed += (mTargetSpeed - mSpeed) / SPEED_EASE;
		mSpeed *= -1;
	}
}
