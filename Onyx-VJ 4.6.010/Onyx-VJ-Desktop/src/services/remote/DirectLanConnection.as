package services.remote
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;

	/**
	 * Creates a direct connection over wifi and is totally independant from any other class in this library 
	 * @author reyco1
	 * 
	 */	
	public class DirectLanConnection
	{
		private var netConnection:NetConnection;
		private var group:NetGroup;
		private const CirrusAddress:String = "rtmfp://p2p.rtmfp.net";
		private const DeveloperKey:String = "";

			
		/**
		 * Boolean value indicating if the connection is establised 
		 */		
		public var isConnected:Boolean;	
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
		
		
		/**
		 * Creates an instance of DirectLanConnection  
		 * 
		 */		
		public function DirectLanConnection()
		{
			isConnected = false;
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
					setUpGroup();
					break;
				
				case "NetGroup.Connect.Success":
					isConnected = true;
					if(onConnect != null)
						onConnect.apply(null, [event.info.message]);
					break;
				
				case "NetGroup.SendTo.Notify":
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
	}
}