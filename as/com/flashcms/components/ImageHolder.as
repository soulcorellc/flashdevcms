package com.flashcms.components {
	import flash.display.Sprite;
	
	/**
	* ...
	* @author Default
	*/
	public class ImageHolder extends ContentHolder{
		private var oDefault:Sprite;
		/**
		 * 
		 * @param	nwidth
		 * @param	nheight
		 */
		public function ImageHolder(nwidth:int,nheight:int) {
			super("Image");
			setSize(nwidth, nheight);
			init();
		}
		/**
		 * 
		 */
		private function init()
		{
			oDefault = new DefaultImage();
			oDefault.x = (width/2)-(oDefault.width/2);
			oDefault.y = (height/2)-(oDefault.height/2);
			addChild(oDefault);
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