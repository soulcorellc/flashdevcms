package com.flashcms.components {
	import fl.video.FLVPlayback;
	
	/**
	* ...
	* @author Default
	*/
	public class VideoHolder extends ContentHolder{
		public var sURL:String = "";
		public var flvPlayer:FLVPlayback;
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
			flvPlayer.source = sURL;
		}
	}
	
}