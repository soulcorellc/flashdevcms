package com.flashcms.components {
	import fl.video.FLVPlayback;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class VideoHolder extends ContentHolder{
		public var sURL:String = "";
		public var flvPlayer:FLVPlayback;
		public var oDefault:DefaultVideo;
		public function VideoHolder(nwidth:int,nheight:int) {
			super("Video");
			setSize(nwidth, nheight);
			init();
		}
		/**
		 * 
		 */
		private function init()
		{
			flvPlayer = new FLVPlayback();
			flvPlayer.setSize(this.width, this.height);
			addChild(flvPlayer);
			oDefault = new DefaultVideo();
			oDefault.x = (width/2)-(oDefault.width/2);
			oDefault.y = (height/2)-(oDefault.height/2);
			addChild(oDefault);
			addEventListener(Event.REMOVED_FROM_STAGE, doRemove);

		}
		public function doRemove(e:Event)
		{
			trace("REMOVED VIDEO HOLDER");
		}
		/**
		 * 
		 * @param	newwidth
		 * @param	newheight
		 */
		public function setSize(newwidth:int,newheight:int)
		{
			updateSize(newwidth, newheight);
		}
		public function update()
		{
			if (sURL != ""){
			removeChild(oDefault);
			}
			flvPlayer.source = sURL;
		}
	}
	
}