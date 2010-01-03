/** 
 * This is a generated class and is not intended for modfication.  To customize behavior
 * of this service wrapper you may modify the generated sub-class of this class - VideoPong.as.
 */
package services.videopong
{
import mx.rpc.AsyncToken;
import com.adobe.fiber.core.model_internal;
import mx.rpc.AbstractOperation;
import com.adobe.fiber.services.wrapper.HTTPServiceWrapper;
import mx.rpc.http.HTTPMultiService;
import mx.rpc.http.Operation;
//import com.adobe.serializers.xml.XMLSerializationFilter;
[ExcludeClass]
internal class _Super_VideoPong extends HTTPServiceWrapper
{      
    //private static var serializer0:XMLSerializationFilter = new XMLSerializationFilter();
       
    // Constructor
    public function _Super_VideoPong()
    {
        // initialize service control
        _serviceControl = new HTTPMultiService(""); 
         var operations:Array = new Array();
         var operation:Operation;  
         var argsArray:Array;       
         
         operation = new Operation(null, "login");
         operation.url = "http://www.videopong.net";
         operation.method = "POST";
         argsArray = new Array("action","method","user","pass","passhashed");
         operation.argumentNames = argsArray;         
         //operation.serializationFilter = serializer0;
         operation.contentType = "application/x-www-form-urlencoded";
		 operation.resultType = Object; 		 
         operations.push(operation);
    
         operation = new Operation(null, "getfolderstree");
         operation.url = "http://www.videopong.net";
         operation.method = "POST";
         argsArray = new Array("action","method","sessiontoken","e4x");
         operation.argumentNames = argsArray;         
         operation.contentType = "application/x-www-form-urlencoded";
		 operation.resultType = Object; 		 
         operations.push(operation);
    
         operation = new Operation(null, "getassets");
         operation.url = "http://www.videopong.net";
         operation.method = "POST";
         argsArray = new Array("action","method","folderid","sessiontoken");
         operation.argumentNames = argsArray;         
         operation.contentType = "application/x-www-form-urlencoded";
		 operation.resultType = Object; 		 
         operations.push(operation);
    
         operation = new Operation(null, "get_clip");
         operation.url = "http://www.videopong.net";
         operation.method = "POST";
         argsArray = new Array("action","method","clip_id","sessiontoken");
         operation.argumentNames = argsArray;         
         operation.contentType = "application/x-www-form-urlencoded";
		 operation.resultType = Object; 		 
         operations.push(operation);
    
		 operation = new Operation(null, "getfolderstreeassets");
		 operation.url = "http://www.videopong.net";
		 operation.method = "POST";
		 argsArray = new Array("action","method","sessiontoken","e4x");
		 operation.argumentNames = argsArray;         
		 operation.contentType = "application/x-www-form-urlencoded";
		 operation.resultType = Object; 		 
		 operations.push(operation);
		 
         _serviceControl.operationList = operations;  
                      
         model_internal::initialize();
    }

	/**
	  * This method is a generated wrapper used to call the 'login' operation. It returns an AsyncToken whose 
	  * result property will be populated with the result of the operation when the server response is received. 
	  * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
	  * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an AsyncToken whose result property will be populated with the result of the operation when the server response is received.
	  */          
	public function login(action:String, method:String, user:String, pass:String, passhashed:Number) : AsyncToken
	{
		var _internal_operation:AbstractOperation = _serviceControl.getOperation("login");
		var _internal_token:AsyncToken = _internal_operation.send(action,method,user,pass,passhashed) ;

		return _internal_token;
	}   

	/*public function getfolderstree(action:String, method:String, sessiontoken:String, e4x:String) : AsyncToken
	{
		var _internal_operation:AbstractOperation = _serviceControl.getOperation("getfolderstree");
		var _internal_token:AsyncToken = _internal_operation.send(action,method,sessiontoken,e4x) ;

		return _internal_token;
	} */  
	 
	public function getfolderstreeassets(action:String, method:String, sessiontoken:String, e4x:String) : AsyncToken
	{
		var _internal_operation:AbstractOperation = _serviceControl.getOperation("getfolderstreeassets");
		var _internal_token:AsyncToken = _internal_operation.send(action,method,sessiontoken,e4x) ;

		return _internal_token;
	}   
	 
	public function getassets(action:String, method:String, folderid:String, sessiontoken:String) : AsyncToken
	{
		var _internal_operation:AbstractOperation = _serviceControl.getOperation("getassets");
		var _internal_token:AsyncToken = _internal_operation.send( action, method, folderid, sessiontoken );

		return _internal_token;
	}   
	 
	public function get_clip(action:String, method:String, clip_id:String, sessiontoken:String) : AsyncToken
	{
		var _internal_operation:AbstractOperation = _serviceControl.getOperation("get_clip");
		var _internal_token:AsyncToken = _internal_operation.send( action, method, clip_id, sessiontoken );

		return _internal_token;
	}   
	 
}

}
