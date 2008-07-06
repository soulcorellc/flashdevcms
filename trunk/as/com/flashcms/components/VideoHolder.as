package com.flashcms.components {
	
	/**
	* ...
	* @author Default
	*/
	public class VideoHolder extends ContentHolder{
		
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
	}
	
}