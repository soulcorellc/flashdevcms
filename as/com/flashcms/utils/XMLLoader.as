package com.flashcms.utils {
	import com.flashcms.events.ErrorEvent;
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
		private var oXML:XML;
		private var handler:Function;
		private var errorhandler:Function;
		private var dataerrorhandler:Function;
		
		/**
		 * 
		 * @param	url URL of the xml to be loaded
		 * @param	handler 
		 * @param	errorhandler
		 */
		public function XMLLoader(url:String,handler:Function,dataerrorhandler:Function=null,errorhandler:Function=null) {
			this.handler = handler;
			this.errorhandler = errorhandler;
			this.dataerrorhandler = dataerrorhandler;
			oRequest = new URLRequest(url);
			oLoader = new URLLoader(oRequest);
			oLoader.addEventListener(Event.COMPLETE, onComplete);
			oLoader.addEventListener(IOErrorEvent.IO_ERROR, errorhandler);
		}
		private function onComplete(event:Event)
		{
			oXML = XML(event.target.data);
			if (oXML.result.success == "true")
			{
				handler.call(this,event);
			}
			else 
			{
				dataerrorhandler.call(this,new ErrorEvent(ErrorEvent.DATA_ERROR,oXML.result.message));
			}
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
		
		public function test(event:IOErrorEvent)
		{
		trace("test!!");
		}
	}
	
}