package services.remote
{
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	public class NetworkUtil
	{
		private static var ipAddress:String = "";

		public static function getIpAddresses()
		{
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo; 
			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces(); 
			
			if( interfaces != null ) 
			{ 
				trace( "Interface count: " + interfaces.length ); 
				for each ( var interfaceObj:NetworkInterface in interfaces ) 
				{ 
					trace( "\nname: "             + interfaceObj.name ); 
					trace( "display name: "     + interfaceObj.displayName ); 
					trace( "mtu: "                 + interfaceObj.mtu ); 
					trace( "active?: "             + interfaceObj.active ); 
					trace( "parent interface: " + interfaceObj.parent ); 
					trace( "hardware address: " + interfaceObj.hardwareAddress ); 
					if( interfaceObj.subInterfaces != null ) 
					{ 
						trace( "# subinterfaces: " + interfaceObj.subInterfaces.length ); 
					} 
					trace("# addresses: "     + interfaceObj.addresses.length ); 
					for each ( var address:InterfaceAddress in interfaceObj.addresses ) 
					{ 
						trace( "  type: "           + address.ipVersion ); 
						trace( "  address: "         + address.address ); 
						trace( "  broadcast: "         + address.broadcast ); 
						trace( "  prefix length: "     + address.prefixLength ); 
						if (ipAddress.length > 0) ipAddress += "-";
						ipAddress += address.address;
					} 
				}             
			} 
			if (ipAddress.length == 0) ipAddress = "unknownip";
		}
	}
}