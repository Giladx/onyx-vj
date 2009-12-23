/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.asset.AssetQuery;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.jobs.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.*;
	import ui.states.*;
	import ui.styles.*;
	import ui.text.*;
	
	import mx.messaging.messages.IMessage;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.videopong.*;
	/**
	 * 
	 */
	public final class VideopongWindow extends Window implements IParameterObject {
		
		private var vpLoginResponder:CallResponder;
		private var vpFoldersResponder:CallResponder;
		private var vp:VideoPong;
		private var sessiontoken:String;
		/**
		 * 	@private
		 * 	returns controls
		 */
		private const parameters:Parameters	= new Parameters(this as IParameterObject,
			new ParameterString( 'vpusername', 'User name', 'login' ),
			new ParameterString( 'vppwd', 'Password', 'pwd' )
		);
		
		/**
		 * 	@private
		 */
		private var vpLoginBtn:TextButton;
		
		/**
		 * 	@private
		 */
		private var vpLoginTextControl:TextControl;
		
		/**
		 * 	@private
		 */
		private var vpPwdTextControl:TextControl;
		
		/**
		 * 
		 */
		public function set vpusername(t:String):void {
			ContentVideoPong.login	= t;
		}
		
		/**
		 * 
		 */
		public function get vpusername():String {
			return ContentVideoPong.login;
		}
		
		/**
		 * 
		 */
		public function set vppwd(t:String):void {
			ContentVideoPong.pwd	= t;
		}
		
		/**
		 * 
		 */
		public function get vppwd():String {
			return ContentVideoPong.pwd;
		}		
		/**
		 * 
		 
		 public var vpusername:String = "guest";*/
		
		/**
		 * 
		 
		 public var vppwd:String = "pwd";*/
		
		/**
		 * 	@constructor
		 */
		public function VideopongWindow(reg:WindowRegistration):void {
			
			super(reg, true, 150, 184);
			
			init();
		}
		
		/**
		 * 	@private
		 */
		private function init():void {
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			
			// controls for display
			vpLoginBtn				= new TextButton(options, 'login to vp'),
				
			// videopong controls
			vpLoginTextControl = Factory.getNewInstance(TextControl);
			vpLoginTextControl.initialize( parameters.getParameter('vpusername'), options);
			
			vpPwdTextControl = Factory.getNewInstance(TextControl);
			vpPwdTextControl.initialize( parameters.getParameter('vppwd'), options);
			
			
			// add controls
			addChildren(
				vpLoginTextControl,				8,	40,
				vpPwdTextControl,				74,	40,
				vpLoginBtn,						74,	55
			);
			
			
			var bg:AssetWindow	= super.getBackground() as AssetWindow;
			
			// draw things onto the background
			if (bg) {
				var source:BitmapData	= bg.bitmapData;
				source.fillRect(new Rectangle(8, 25, 150, 1), 0xFF445463);
				
				var label:StaticText		= new StaticText();
				
				label.text	= 'VIDEOPONG';
				source.draw(label, new Matrix(1, 0, 0, 1, 8, 17));
			}
			
			// videopong login
			vpLoginBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
		}
		
		/**
		 * 
		 */
		public function getParameters():Parameters {
			return parameters;
		}
		
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			switch (event.currentTarget) {
				case vpLoginBtn:
					vpLogin();
					break;
			}
			event.stopPropagation();
		}
		/**
		 * 
		 */
		public function vpLogin():void {
			
			//Call videopong webservice
			vp = new VideoPong();
			
			vpLoginResponder = new CallResponder();
			// addEventListener for response
			vpLoginResponder.addEventListener( ResultEvent.RESULT, loginHandler );
			vpLoginResponder.addEventListener( FaultEvent.FAULT, faultHandler );
			Console.output( "VideoPong Login" );
			//vp.operations
			vpLoginResponder.token = vp.login(  "onyxapi","login",vpusername,vppwd,0 );
		}		
		/**
		 * 	Result from Login
		 */
		public function loginHandler( event:ResultEvent ):void {
			
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			var res:XML = XML(result);
			
			var response:uint = res..ResponseCode;//0 if ok 1 if not then it is a guest
			sessiontoken = res..SessionToken;
			
			Console.output("loginHandler, response: "+response);  
			trace("loginHandler, sessiontoken: "+sessiontoken);  
			// ask for folders tree
			vpFoldersResponder = new CallResponder();
			// addEventListener for response
			vpFoldersResponder.addEventListener( ResultEvent.RESULT, foldersTreeHandler );
			vpFoldersResponder.addEventListener( FaultEvent.FAULT, faultHandler );
			Console.output( "VideoPong Login" );
			//vp.operations
			vpFoldersResponder.token = vp.getfolderstree( "onyxapi", "getfolderstree", sessiontoken, "1" );
			
		}		
		public function foldersTreeHandler( event:ResultEvent ):void {
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			var res:XML = XML(result);
			
			var response:uint = res..ResponseCode;//0 if ok
			
		}
		public function faultHandler( event:FaultEvent ):void {
			
			var faultString:String = event.fault.faultString;
			var faultDetail:String = event.fault.faultDetail;
			
			Console.output("faultHandler, faultString: "+faultString);  
			Console.output("faultHandler, faultDetail: "+faultDetail);  
			
		}		
		/**
		 * 	@public
		 */
		override public function dispose():void {
			
			if ( vpLoginResponder )
			{
				if ( vpLoginResponder.hasEventListener( ResultEvent.RESULT ) ) vpLoginResponder.removeEventListener( ResultEvent.RESULT, loginHandler );
				if ( vpLoginResponder.hasEventListener( FaultEvent.FAULT ) ) vpLoginResponder.removeEventListener( FaultEvent.FAULT, faultHandler );
			}
			// login btn
			vpLoginBtn.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			// remove
			super.dispose();
			
		}
	}
}
