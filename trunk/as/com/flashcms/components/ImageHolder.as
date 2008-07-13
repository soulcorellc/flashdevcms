package com.flashcms.components {
	import flash.display.Sprite;
	import com.flashcms.data.MultiLoader;
	import com.flashcms.events.LoadEvent;
	/**
	* ...
	* @author Default
	*/
	public class ImageHolder extends ContentHolder{
		private var oDefault:Sprite;
		private var oLoader:MultiLoader;
		public var sURL:String = "";
		public var image;
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
			oLoader = new MultiLoader();
			oLoader.addEventListener(LoadEvent.LOAD_EVENT, onImageLoaded);
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
		
		public function update()
		{
			if(image!=null){
				removeChild(image);
			}
			oLoader.add(sURL);
			oLoader.start();
		}
		/**
		 * 
		 * @param	e
		 */
		public function onImageLoaded(e:LoadEvent)
		{
			image = e.loaderTarget.content;
			addChild(image);
		}
	}
}