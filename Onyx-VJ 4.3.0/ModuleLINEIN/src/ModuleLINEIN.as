package {
		
	import onyx.core.*;
	import onyx.plugin.Plugin;
	import onyx.plugin.PluginLoader;
	
	import core.ID;
	
	/**
	 *  
	 */
	public final class ModuleLINEIN extends PluginLoader {
				
		public function ModuleLINEIN():void {
			this.addPlugins(
				new Plugin(ID, InnerLINEIN, 'LINEINModule')
			)
		}
				
	}
		
}

import events.SoundEvent;

import flash.display.Stage;
import flash.events.*;
import flash.media.*;
import flash.net.*;
import flash.ui.Keyboard;
import flash.utils.*;
import flash.utils.ByteArray;

import onyx.asset.*;
import onyx.core.*;
import onyx.parameter.*;
import onyx.plugin.*;
import onyx.ui.*;

import ui.states.*;

class InnerLINEIN extends Module {
	
	public const LINEIN:EventDispatcher = new EventDispatcher();
		
	protected var mic:Microphone;
	protected var soundRecording:ByteArray;
	
	protected var soundOutput:Sound;
	protected var soundOutputCh:SoundChannel;
	
	public var bytes:ByteArray;
	public var bytesL:ByteArray;
	public var bytesR:ByteArray;
	
	private var _enable:Boolean;
	private var _level:Number;
	private var _show:Boolean;
	
	private var _sfx:Sound;
	private var _url:URLRequest;
	private var _ctx:SoundLoaderContext;
	private var _sch:SoundChannel;
	
	private var myTimer:Timer;
	
	private var   _host:String;
	private var   _port:String;
	private var   _source:String;
	
	public var slevel:Number;
	private var _activity:Number = 2;
	
	public function InnerLINEIN()	{
		
		// default audio source 
		_source = 'line in';
		// streaming server 
		_host 	= 'localhost'; 	//192.168.1.66'; //'127.0.0.1'; // default to localhost    test on 192.168.1.66
		_port 	= '8080';		// default port for http streaming	
				
		_enable			= false;
		_level			= 1;
		soundRecording 	= new ByteArray();
		bytes 			= new ByteArray();
		bytesL 			= new ByteArray();
		bytesR 			= new ByteArray();
		
		// init			
		super(new ModuleInterfaceOptions(null, 140, 110));
		
		parameters.addParameters(
			new ParameterString('host', 'host'),
			new ParameterString('port', 'port'),
			new ParameterArray('source', 'source', new Array('line in','stream'), _source),
			new ParameterBoolean('enable', 'enable'),
			//new ParameterNumber('level','level', 0,1,1,100,0.1),
			new ParameterNumber('activity','activity', 0, 100, _activity, 1,1)
			
			/*new ParameterBoolean('show', 'show', 0),
			new ParameterExecuteFunction('learn', 'learn'),	
			new ParameterExecuteFunction('save', 'save'),	
			new ParameterExecuteFunction('load', 'load')*/
		);
			
		//addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		SoundMixer.bufferTime=0;
				
	}
	
	public function set host(value:String):void {
		_host = value;
	}
	public function get host():String {
		return _host;
	}
	
	public function set port(value:String):void {
		_port = value;
	}
	public function get port():String {
		return _port;
	}
	
	private function _onKeyDown(e:KeyboardEvent):void {
		if(e.shiftKey)
			StateManager.loadState(new SoundLearnState(e.charCode));
	}
	
	///////
	public function set enable(value:Boolean):void {
		if(value) { 
			if(_source=="stream") {
				_sfx = new Sound();
				_ctx = new SoundLoaderContext(0, false);
				_url = new URLRequest("http://"+_host+":"+_port+"/stream");
				_sfx.load(_url,_ctx);
				_sch = _sfx.play();
				
				myTimer = new Timer(50);
				myTimer.addEventListener("timer", _onTimer);
				myTimer.start();
			} else {
				mic = Microphone.getMicrophone(0);
				mic.addEventListener(SampleDataEvent.SAMPLE_DATA, gotMicData);
			}
		} else {
			if(_source=="stream") {
				myTimer.stop();
				myTimer.removeEventListener("timer", _onTimer);
				_sch.stop();
				_sfx.close();
				_sch = null;
				_sfx = null;
			} else {
				mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, gotMicData);
				mic = null;
			}
		}
		_enable = value;
	}
	public function get enable():Boolean {
		return _enable;
	}
	
	public function set source(value:String):void {
		_source = value;
	}
	public function get source():String {
		return _source;
	}
	
	public function set level(value:Number):void {
		_level = value;
		if(soundOutputCh)
			soundOutputCh.soundTransform = new SoundTransform(_level,0);
	}
	public function get level():Number {
		return _level;
	}
	
	public function set activity(value:Number):void {
		_activity = value;
	}
	public function get activity():Number {
		return _activity;
	}
	
	public function set show(value:Boolean):void {
		_show = value;
	}
	public function get show():Boolean {
		return _show;
	}
	
	///////
	public function learn():void {
		StateManager.loadState(new SoundLearnState(0));
	}
	public function load():void {
		StateManager.loadState(new SoundLoadState());           
	}
	public function save():void {
		StateManager.loadState(new SoundSaveState());
	}
	///////
	
	private function _onTimer(e:Event):void {
		SoundMixer.computeSpectrum( bytes, true, 0 );
		slevel = (_sch.leftPeak + _sch.rightPeak)*100/2;
		LINEIN.dispatchEvent(new SoundEvent(SoundEvent.SOUND,bytes));
	}
	
	private function gotMicData(micData:SampleDataEvent):void {
		soundRecording.clear();
		soundRecording.writeBytes(micData.data);
		soundRecording.position = 0;

		soundOutput = new Sound();
		soundOutput.addEventListener(SampleDataEvent.SAMPLE_DATA, playSound);
		soundOutputCh = soundOutput.play();
		soundOutputCh.soundTransform = new SoundTransform(_level,0);
		
	}
		
	private function playSound(soundOutput:SampleDataEvent):void {			
		
		if (!soundRecording.bytesAvailable > 0)
			return;
		for (var i:int = 0; i < 8192; i++) {
			var sample:Number = 0;
			if (soundRecording.bytesAvailable > 0)
				sample = soundRecording.readFloat();
			soundOutput.data.writeFloat(sample); 
			soundOutput.data.writeFloat(sample);
		}   
		
		
		this.soundOutput.removeEventListener(SampleDataEvent.SAMPLE_DATA, playSound);
		this.soundOutput = null;
		
		// FFT, waveform, both
		bytes.clear();
		bytesL.clear();
		bytesR.clear();
		SoundMixer.computeSpectrum( bytes, true, 0 );
		bytes.readBytes(bytesL,0,1024);
		bytes.readBytes(bytesR,0,1024);
		
		slevel = mic.activityLevel;
		
		// update the level's label to track current level
		//parameters.getParameter('activity').display = slevel.toString();
		parameters.getParameter('activity').value = slevel;
		
		LINEIN.dispatchEvent(new SoundEvent(SoundEvent.SOUND,bytes));
		
	}

	// TODO
	// http://code.compartmental.net/2007/03/21/fft-averages/
	// HP: input is always 256 bands per channel 
	
	
	
}
