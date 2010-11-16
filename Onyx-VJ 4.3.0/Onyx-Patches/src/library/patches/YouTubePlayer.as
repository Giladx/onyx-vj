/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * plug-in for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * based on YouTube codebase by MkUltra (http://www.ericmedine.com)
 */
 ////////////////////////////////////////////////////////////////////
///EMAQ Design
///http://www.emaqdesign.com
///Copyright (c) 2008-2009, EMAQ Design.
///All rights reserved.
///Redistribution and re-sale of these Flash Components/photo
///galleries+CMS systems/video loops, or related material, with or
///without modification, is not permitted.
/////////////////////////////////////////////////////////////////////

package library.patches
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Video;
	import flash.net.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.xml.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class YouTubePlayer extends Patch
	{
		private var _url:String;
		private var _volume:int = 100;
		private var _play:Boolean = true;
		private var sprite:Sprite;
		public var player:Object;
		public var loader:Loader = new Loader();
		public var hasVideoBeenLoaded:Boolean = false;
		
		//public var theURLString:String;
		
		/// timer to check position of the playhead
		private var playheadTimer:Timer;
		//// in and out point handlers
		public var theInPoint:Number = 0; /// sets default end point to 0
		public var theOutPoint:Number;
		public var theDuration:Number;
		public var theScrubPoint:Number;
				
		///// this is the text field that you type the youtube URL into
		///// when the textfield changes, it launches the parameter changed function and converts the URL to an FLV
		/*private var paramText:StringParameter = resolume.addStringParameter("YouTube URL", "default");
		
		///// this is the "scrubber", "in" and "out" vars
		private var trimInPoint:FloatParameter = resolume.addFloatParameter("Set In Point", 0.5);
		private var trimOutPoint:FloatParameter = resolume.addFloatParameter("Set Out Point", 0.5);
		private var theScrubber:FloatParameter = resolume.addFloatParameter("Scrub", 0.5);
		//// pause var
		private var thePause:BooleanParameter = resolume.addBooleanParameter("Play/Pause", true);
		
		//// volume var
		private var theVolume:FloatParameter = resolume.addFloatParameter("Volume", 0.5);*/
		
		
		//// INITIALIZE YOUTUBE FUNCTIONS AND PLAYER ENVIRONMENT
		public function YouTubePlayer():void
		{
			Console.output('Youtube player');
			Console.output('YouTube codebase by MkUltra (http://www.ericmedine.com)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterString('url', 'url', _url),
				new ParameterInteger('volume', 'volume', 0, 100, _volume),
				new ParameterBoolean('play', 'play/pause')
			)
			url = 'http://www.youtube.com/watch?v=dXDb3rgxoOE';
			initEnvironment();
		}
		
		public function initEnvironment():void
		{
			sprite = new Sprite();
			addChild(sprite);
			// This will hold the API player instance once it is initialized.
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
		}
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );		
		} 
		///// this listens for text to be in the text box
		///// if it is, load the video in the chromeless player
		/*public function parameterChanged(event:ChangeEvent): void{
			if (event.object == paramText) {
				//// this gets the youtube URL
				theURLString = this.paramText.getValue();
				// youTubeText.text = this.paramText.getValue();
				//// load the URL
				loadVideo(theURLString);
				
				//// set in and out points
			} else if (event.object == trimInPoint) {
				setTrimInPoint(this.trimInPoint.getValue() * 100);
			} else if (event.object == trimOutPoint) {
				setTrimOutPoint(this.trimOutPoint.getValue() * 100);
			} else if (event.object == theScrubber) {
				setScrubPoint(this.theScrubber.getValue() * 100);
			} else if (event.object == thePause) {
				setPlayPause(this.thePause.getValue());
				///// set volume
			} else if (event.object == theVolume) {
				setVolume(this.theVolume.getValue() * 100);
				
			} else {
				trace(event.object);
			}		
		}*/
		
		//////////////////////////////////////////////
		///// CHROMELESS YOUTUBE PLAYER FUNCTIONS
		//////////////////////////////////////////////
		private function onLoaderInit(event:Event):void {
			sprite.addChild(loader);
			loader.content.addEventListener( "onReady", onPlayerReady );
			loader.content.addEventListener( "onError", onPlayerError );
			loader.content.addEventListener( "onStateChange", onPlayerStateChange );
			loader.content.addEventListener( "onPlaybackQualityChange", onVideoPlaybackQualityChange );
		}
		
		private function onPlayerReady(event:Event):void {
			// now that the player is loaded and ready, add an event listener for text changes
			//youTubeText.addEventListener(Event.CHANGE, reloadVideo);
			// Event.data contains the event parameter, which is the Player API ID 
			trace("player ready:", Object(event).data);
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			player = loader.content;
			// Set appropriate player dimensions for your application
			/// should make this scale to fit stage
			player.setSize(DISPLAY_WIDTH, DISPLAY_HEIGHT);
			
			/// start playhead timer to check the playhead position
			playheadTimer = new Timer(100);
			playheadTimer.addEventListener(TimerEvent.TIMER, checkPlayHead);
			playheadTimer.start();
			
			loadVideo( url );
		}
		
		private function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}
		
		private function onPlayerStateChange(event:Event):void 
		{
			trace("onPlayerStateChange:", Object(event).data);
			// Event.data contains the event parameter, which is the new player state
			//stateTextBox.text = Object(event).data;
			
			switch (Object(event).data) {
				case 1: // means its playing
					theDuration = player.getDuration();
					hasVideoBeenLoaded = true;
					break;
				
				case 0: /// means its ended
					player.seekTo(theInPoint, true);
					
					break;
				
				case 3: // means its buffering
					
					break;
				
				case -1: // means its unstarted 
					
					break;
			}
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("video quality:", Object(event).data);
		}
		
		///// load video on init
		private function loadVideo(theURLString){
			if ( player )
			{
				if( hasVideoBeenLoaded == true )
				{
					player.clearVideo();
				}
				// gets the video ID
				var theParsedString:String = theURLString.substr(31);
				try
				{
					player.loadVideoByUrl("http://www.youtube.com/v/" + theParsedString, 0);
				} 
				finally 
				{
					
				}
				
			}
			
		}
		
		/////////////////////////////////
		////  SCRUBBING, IN AND OUT POINTS
		/////////////////////////////////////
		private function setScrubPoint(theNumber){

			var theRealPosition = Math.round(((theNumber - 0) * theDuration) / 100);
			player.seekTo(theNumber, true);
			
		}
		
		private function setTrimInPoint(theNumber){
			
			theInPoint = Math.round(((theNumber - 0) * theDuration) / 100);
			//inPointTextBox.text = theNumber;
		}
		
		private function setTrimOutPoint(theNumber){
			// var NewRange = (theDuration - 0)
			theOutPoint = Math.round(((theNumber - 0) * theDuration) / 100);
			
		}
		
		///// check to see if the video is at the "end"
		///// if so, go to in-point
		private function checkPlayHead(e:TimerEvent):void{
			var thePlayheadLocation = player.getCurrentTime();
			//stateTextBox.text = thePlayheadLocation;
			if(thePlayheadLocation >= theOutPoint){
				// player.seekTo(seconds:Number, allowSeekAhead:Boolean):Void
				player.seekTo(theInPoint, true);
				
			}
		}
				
		/**
		 * 	
		 */
		public function set url( value:String ):void 
		{
			_url = value;
			loadVideo( _url );
		}
		
		/**
		 * 	
		 */
		public function get url():String 
		{
			return _url;
		}
		/**
		 * 	
		 */
		public function set volume( value:int ):void 
		{
			_volume = value;
			player.setVolume( _volume );
		}
		
		/**
		 * 	
		 */
		public function get volume():int 
		{
			return _volume;
		}
		/**
		 * 	
		 */
		public function set play( value:Boolean ):void 
		{
			_play = value;
			if ( _play ) player.playVideo() else player.pauseVideo();
		}
		
		/**
		 * 	
		 */
		public function get play():Boolean 
		{
			return _play;
		}
		///// end class
	}
	/// end package
}




