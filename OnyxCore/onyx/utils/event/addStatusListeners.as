package onyx.utils.event {
	
	import flash.events.*;
	
	public function addStatusListeners(target:IEventDispatcher, method:Function):void {
		
		target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, method);
		target.addEventListener(IOErrorEvent.IO_ERROR, method);
		target.addEventListener(Event.COMPLETE, method);
		
	}
}