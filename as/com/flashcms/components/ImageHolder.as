package com.flashcms.components {
	import flash.display.Sprite;
	import com.flashcms.data.MultiLoader;
	import com.flashcms.events.LoadEvent;
	import com.flashcms.events.LoadError;
	import flash.events.ProgressEvent;
	/**
	* ...
	* @author Default
	*/
	public class ImageHolder extends ContentHolder{
		private var oDefault:DefaultImage;
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
			oLoader.addEventListener(LoadError.LOAD_ERROR, onError);
			oLoader.addEventListener(LoadEvent.LOAD_EVENT, onImageLoaded);
			oLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			oDefault = new DefaultImage();
			oDefault.x = (width/2)-(oDefault.width/2);
			oDefault.y = (height/2)-(oDefault.height/2);
			addChild(oDefault);
		}
		private function onProgress(e:ProgressEvent)
		{
			var sLoaded:String = String(Math.round((e.bytesLoaded / e.bytesTotal)*100));
			oDefault.txtMessage.text = "Loaded "+sLoaded+ "%";
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
		/**
		 * 
		 */
		public function update()
		{
			if(image!=null){
				removeChild(image);
			}
			oDefault.txtMessage.text = "Loading Image...";
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
			image.width = this.width;
			image.height = this.height;
			addChild(image);
		}
		public function onError(e:LoadError)
		{
			oDefault.txtMessage.text = e.text;
			
		}
	}
}