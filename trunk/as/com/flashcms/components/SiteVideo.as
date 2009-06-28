package com.flashcms.components 
{
	import com.yahoo.astra.fl.accessibility.EventTypes;
	import flash.display.MovieClip;
	import fl.video.FLVPlayback;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author David Barrios
	 */
	public class SiteVideo extends MovieClip
	{
		public var id:String;
		public var flvPlayer:FLVPlayback;
		
		public function SiteVideo(nwidth:int,nheight:int,url:String) 
		{
			addEventListener(Event.REMOVED_FROM_STAGE, doRemoved);
			flvPlayer = new FLVPlayback();
			flvPlayer.setSize(nwidth, nheight);
			flvPlayer.source = url;
			addChild(flvPlayer);
		}
		/**
		 * 
		 * @param	e
		 */
		public function doRemoved(e:Event)
		{	
			flvPlayer.stop();
		}
		
		
	}
	
}