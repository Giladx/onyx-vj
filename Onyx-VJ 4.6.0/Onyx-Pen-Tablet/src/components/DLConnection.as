// singleton
/** 
 * This is a generated sub-class of _VideoPong.as and is intended for behavior
 * customization.  This class is only generated when there is no file already present
 * at its target location.  Thus custom behavior that you add here will survive regeneration
 * of the super-class. 
 **/

package components
{
	import flash.events.EventDispatcher;
	
	import services.remote.DirectLanConnection;

	[Event(name="connected", type="flash.events.TextEvent")]

	public class DLConnection extends EventDispatcher
	{
		private static var cnxInstance:DLConnection;
		private static var cnx:DirectLanConnection;
		private static var numLayers:int = 0;
		private static var _isConnected:Boolean = false;
	
		public static function getInstance():DLConnection
		{
			if (cnxInstance == null)
			{
				cnxInstance = new DLConnection();
				cnx = new DirectLanConnection();
				cnx.onConnect = handleConnectToService;
				cnx.onDataReceive = handleGetObject;
			}
			
			return cnxInstance;
		}
		// Constructor
		public function DLConnection()
		{

		}
		protected static function handleConnectToService(user:Object):void
		{
			/*connStatus.connected = true;
			connStatus.connectedTo = "";*/
			
			cnx.sendData({type:"cnx", value:"pentablet" });			
		}
		protected static function handleGetObject(dataReceived:Object):void
		{
			// received
			switch ( dataReceived.type.toString() ) 
			{ 
				case "msg":
					//navigator.activeView.status.text 	= dataReceived.value;
					break;
			
				case "layer":
					if ( numLayers == 0 )
					{
						//cnx.sendData({type:"cnx", value:"mobile" });
					}
					else
					{
						//lv.selectedLayer = dataReceived.value;
					}
					break;
				case "layers":
					numLayers = dataReceived.value;
					//navigator.pushView( LayersView, dataReceived );
					
					cnx.sendData( {type:"layerbtn", value:"created" }  );
					break;
				default: 
					
					break;
			}
		}
		public function connect( port:String ):void
		{
			cnx.connect(port);
		}
		public function sendData( obj:Object ):void
		{
			cnx.sendData(obj);
		}
		public function close():void
		{
			cnx.close();
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