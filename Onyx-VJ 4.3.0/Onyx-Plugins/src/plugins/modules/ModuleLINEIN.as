package plugins.modules {
		
	import flash.display.Stage;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.ui.Keyboard;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;
	
	import services.sound.SoundProvider;
	
	import ui.states.*;
	
	/**
	 *  
	 */
	public final class ModuleLINEIN extends Module {
				
		public const LINEIN:EventDispatcher = new EventDispatcher();
				
		public var bytes:ByteArray;
		public var bytesL:ByteArray;
		public var bytesR:ByteArray;
		public var floatL:Array;
		public var floatR:Array;
		
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
		
		
		public var SP:SoundProvider = SoundProvider.getInstance();
		
		public function ModuleLINEIN()	{
			
			// default audio source 
			_source = 'line in';
			// streaming server 
			_host 	= 'localhost'; 	//192.168.1.66'; //'127.0.0.1'; // default to localhost    test on 192.168.1.66
			_port 	= '8080';		// default port for http streaming	
			
			_enable			= false;
			_level			= 1;
			bytes 			= new ByteArray();
			bytesL 			= new ByteArray();
			bytesR 			= new ByteArray();
			floatL 			= new Array();
			floatR 			= new Array();
			
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
		
		/*private function _onKeyDown(e:KeyboardEvent):void {
			if(e.shiftKey)
				StateManager.loadState(new SoundLearnState(e.charCode));
		}*/
		
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
					SP.mic = Microphone.getMicrophone(0);
					SP.activate();
				}
				SP.addEventListener(SoundEvent.SOUND, _onActivity);
			} else {
				if(_source=="stream") {
					myTimer.stop();
					myTimer.removeEventListener("timer", _onTimer);
					_sch.stop();
					_sfx.close();
					_sch = null;
					_sfx = null;
				} else {
					SP.deactivate();
					SP.mic = null;
				}
				SP.removeEventListener(SoundEvent.SOUND, _onActivity);
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
			SP.level();
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
		
		/*//////
		public function learn():void {
			StateManager.loadState(new SoundLearnState(0));
		}
		public function load():void {
			StateManager.loadState(new SoundLoadState());           
		}
		public function save():void {
			StateManager.loadState(new SoundSaveState());
		}
		*///////
		
		private function _onTimer(e:Event):void {
			SoundMixer.computeSpectrum( bytes, true, 0 );
			slevel = (_sch.leftPeak + _sch.rightPeak)*100/2;
			LINEIN.dispatchEvent(new SoundEvent(SoundEvent.SOUND,new Array([],[])));
		}
		
		// update the level's label to track current level
		private function _onActivity(e:Event):void {
			parameters.getParameter('activity').value = SP.slevel;
		}		
		
	}
}
