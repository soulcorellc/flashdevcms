package com.flashcms.utils {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class XMLLoader {
		private var oRequest:URLRequest;
		private var oLoader:URLLoader;
		private var handler:Function;
		private var errorhandler:Function;
		/**
		 * 
		 * @param	url URL of the xml to be loaded
		 * @param	handler 
		 * @param	errorhandler
		 */
		public function XMLLoader(url:String,handler:Function,errorhandler:Function) {
			this.handler = handler;
			this.errorhandler = errorhandler;
			oRequest = new URLRequest(url);
			oLoader = new URLLoader(oRequest);
			oLoader.addEventListener(Event.COMPLETE, handler);
			oLoader.addEventListener(IOErrorEvent.IO_ERROR, errorhandler);
		}
		/**
		 * Remove listeners
		 */
		public function remove()
		{
			oLoader.removeEventListener(Event.COMPLETE, handler);
			oLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorhandler);
			this.errorhandler = null;
			this.handler = null;
		}
		
	}
	
}