package onyx.utils.event {
	
	import flash.events.*;
	
	public function removeStatusListeners(target:IEventDispatcher, method:Function):void {
		
		target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, method);
		target.removeEventListener(IOErrorEvent.IO_ERROR, method);
		target.removeEventListener(Event.COMPLETE, method);
		
	}
}