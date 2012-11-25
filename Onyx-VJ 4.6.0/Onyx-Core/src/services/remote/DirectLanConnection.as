package services.remote
{
	import flash.events.*;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	import onyx.core.Console;
	import onyx.events.InteractionEvent;
	import onyx.plugin.Display;
	import onyx.plugin.Layer;
	
	
	/**
	 * Creates a direct connection over wifi and is totally independant from any other class in this library 
	 * @author reyco1
	 * 
	 */	
	[Event(name="connected", type="flash.events.TextEvent")]
	public class DirectLanConnection implements IEventDispatcher
	{
		private var dispatcher:EventDispatcher;
		private var netConnection:NetConnection;
		private var group:NetGroup;
		private const CirrusAddress:String = "rtmfp://p2p.rtmfp.net";
		private var _developerKey:String = "";

		
			
		/**
		 * Boolean value indicating if the connection is establised 
		 */		
		private static var _isConnected:Boolean = false;
		/**
		 * The port this connection is on 
		 */		
		public var port:String;

		/**
		 * Method that should be executed when data is recieved (should have one argument to hold the object returned from the NetStatusEvent : event.info.message)
		 */		
		public var onDataReceive:Function;
		/**
		 * Method that should be executed once the connection is established (should have one argument to hold the object returned from the NetStatusEvent : event.info.message)
		 */		
		public var onConnect:Function;
		
		private static var cnxInstance:DirectLanConnection;
		private static var numLayers:int = 0;
		private static var _clientName:String;
		
		public static function getInstance(clientName:String):DirectLanConnection
		{
			if (cnxInstance == null)
			{
				Console.output("new cnxInstance");
				cnxInstance = new DirectLanConnection();
				cnxInstance.onConnect = handleConnectToService;
				cnxInstance.onDataReceive = handleGetObject;
				_clientName = clientName;
			}
			
			return cnxInstance;
		}		
		/**
		 * Creates an instance of DirectLanConnection  
		 * 
		 */		
		public function DirectLanConnection()
		{
				dispatcher = new EventDispatcher(this);
		}
		protected static function handleConnectToService(user:Object):void
		{
			//Console.output("handleConnectToService");
			cnxInstance.sendData({type:"cnx", value:_clientName });			
		}
		protected static function handleGetObject(dataReceived:Object):void
		{
			Console.output("handleGetObject, dataReceived from " + _clientName + " type: " + dataReceived.type.toString());
			// received
			switch ( dataReceived.type.toString() ) 
			{ 
				/*case "x":
					_x = dataReceived.value;
					break;
				case "y":
					_y = dataReceived.value;
					break;
				case "pressure":
					_pressure = dataReceived.value;
					break;
				
				case "layer":
					if ( numLayers > 0 )
					{
						
					}
					break;
				case "layers":
					numLayers = dataReceived.value;
					
					cnxInstance.sendData( {type:"layerbtn", value:"created" }  );
					break;*/
				default: 
					//trace("handleGetObject, dataReceived sending");
					DirectLanConnection.getInstance(_clientName).dispatchEvent( new DLCEvent(DLCEvent.ON_RECEIVED, dataReceived) );

					break;
			}
		}		
		
		/**
		 * Establishes a direct connection. If the connectionPortId is privided, then the connection will be established over wifi the other instance of DirectLanConnection on that port.
		 * If the argument is not provided, then this instance will be connected to a random port and the "port" property will be set.
		 * @param connectionPortId
		 * 
		 */		
		public function connect(connectionPortId:String = null):void
		{
			// Random port generator: 1024..65535
			var minInt:int = 1024;
			var maxInt:int = 65535;
			var randomPort:Number = Math.floor(minInt + (Math.random() * (maxInt - minInt)));
			
			port = connectionPortId == null ? String( randomPort ) : connectionPortId;
			
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, handleStatus);
			// same subnet 
			netConnection.connect("rtmfp:");
			//netConnection.connect(CirrusAddress, DeveloperKey);
		}
		
		protected function handleStatus(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					Console.output("NetConnection.Connect.Success, setUpGroup" );
					setUpGroup();
					break;
				
				case "NetGroup.Connect.Success":
					Console.output("NetGroup.Connect.Success" );
					isConnected = true;
					if(onConnect != null)
						onConnect.apply(null, [event.info.message]);
					break;
				
				case "NetGroup.SendTo.Notify":
					Console.output("NetGroup.SendTo.Notify" );
					if(onDataReceive != null)
						onDataReceive.apply(null, [event.info.message]);
					break;
			}
		}
		
		/**
		 * Sends an object 
		 * @param obj
		 * 
		 */		
		public function sendData(obj:Object):void
		{
			if ( group ) group.sendToAllNeighbors(obj);
		}
		
		/**
		 * Closes the connection 
		 * 
		 */		
		public function close():void
		{
			isConnected = false;
			netConnection.close();
		}
		
		/**
		 * Clears the connection and all internal listeners 
		 * 
		 */		
		public function clear():void
		{
			if(netConnection)
			{
				close();
				netConnection.removeEventListener(NetStatusEvent.NET_STATUS, handleStatus);
				netConnection = null;
			}
			
			if(group)
			{
				group.close();
				group.removeEventListener(NetStatusEvent.NET_STATUS, handleStatus);
				group = null;
			}
			
			onDataReceive = null;
			onConnect = null;
		}
		
		private function setUpGroup():void
		{
			var groupSpec:GroupSpecifier = new GroupSpecifier("Onyx-VJ-"+port);
			groupSpec.routingEnabled = true;
			groupSpec.ipMulticastMemberUpdatesEnabled = true;
			groupSpec.addIPMulticastAddress("224.255.0.0:"+port);
			groupSpec.multicastEnabled = true;
			
			group = new NetGroup(netConnection, groupSpec.groupspecWithAuthorizations());
			group.addEventListener(NetStatusEvent.NET_STATUS, handleStatus);
		}
		public function memberCount():String
		{
			return group == null ? "no group" : group.estimatedMemberCount.toString();
		}
		public function groupInfo():String
		{
			return group == null ? "no group" : group.info.toString();
		}
		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
		public function get DeveloperKey():String
		{
			return _developerKey;
		}
		
		public function set DeveloperKey(value:String):void
		{
			_developerKey = value;
		}
		public function get isConnected():Boolean
		{
			return _isConnected;
		}
		
		public function set isConnected( value:Boolean ):void
		{
			_isConnected = value;
		}
	}
}