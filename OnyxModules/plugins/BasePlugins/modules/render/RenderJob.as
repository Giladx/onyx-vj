package modules.render {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.Socket;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.display.IDisplay;
	import onyx.jobs.Job;

	public final class RenderJob extends Job {
		
		/**
		 * 	@private
		 */
		private static const FRAME_DATA:uint	= 0;
		
		/**
		 * 
		 */
		private static const SEND_ORDER:uint	= 0;	
		
		private var socket:Socket;
		private var display:IDisplay;
		
		/**
		 * 
		 */
		public function RenderJob(socket:Socket, display:IDisplay):void {
			this.socket		= socket,
			this.display	= display;
			
			display.addEventListener(Event.COMPLETE, frame);
		}
		
		/**
		 * 	@private
		 */
		private function frame(event:Event):void {
			var bmp:BitmapData	= display.rendered;
			var imgData:ByteArray	= bmp.getPixels(BITMAP_RECT);
			var header:ByteArray	= new ByteArray();
			
			// temporarily make space for the length
			header.writeInt(0);
			
			// our message
			header.writeShort(FRAME_DATA);
			
			// timer
			header.writeUnsignedInt(getTimer());
			
			// base layer
			header.writeShort(0);
			
			// normal blend mode (not implemented currently)
			header.writeShort(0);
			
			// width
			header.writeShort(BITMAP_RECT.width);

			// height
			header.writeShort(BITMAP_RECT.height);
			
			// now update the length
			header.position = 0;
			
			// hehe
			header.writeInt(header.length + imgData.length);
			
			// write the header and imageData
			socket.writeBytes(header);
			socket.writeBytes(imgData);
			
			// send it
			socket.flush();
		} 
	}
}