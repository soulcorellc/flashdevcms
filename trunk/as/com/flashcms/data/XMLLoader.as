package com.flashcms.data {
	import com.flashcms.events.ErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
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
		 * @param	url
		 * @param	handler
		 * @param	dataerrorhandler
		 * @param	errorhandler
		 * @param	variables
		 */
		public function XMLLoader(url:String,handler:Function,dataerrorhandler:Function=null,errorhandler:Function=null,variables:Object=null) {
			
			trace(url);
			this.handler = handler;
			this.errorhandler = errorhandler;
			this.dataerrorhandler = dataerrorhandler;
			oRequest = new URLRequest(url);
			
			if (variables != null)
			{
				var postvars:URLVariables = new URLVariables();
				for (var i in variables)
				{
					postvars[i] = variables[i];
				}
				oRequest.data = postvars;
				oRequest.method = URLRequestMethod.GET;
			}
			
			oLoader = new URLLoader(oRequest);
			oLoader.addEventListener(Event.COMPLETE, onComplete);
			if (errorhandler == null)
			{
				errorhandler = onError;
			}
			if (dataerrorhandler== null)
			{
				dataerrorhandler = onError;
			}
			oLoader.addEventListener(IOErrorEvent.IO_ERROR, errorhandler);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onComplete(event:Event)
		{
			try{
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
			catch (e:Error)
			{
				trace("Unable to parse XML : "+e.getStackTrace());
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
		
		private function onError(event:IOErrorEvent)
		{
			trace("XMLERROR :"+event.text);
		}
		
	}
	
}