package com.flashcms.data {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import com.flashcms.events.*;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	/**
	* ...
	* @author David Barrios
	*/
	public class MultiLoader extends EventDispatcher {
		
		private var oRequest:URLRequest;
		private var aMovies:Array;
		private var aLoaders:Array;
		private var oLoader:Loader;
		private var oEvent:LoadEvent;
		private var oError:LoadError;
		public function MultiLoader()
		{
			aMovies = new Array();
		}
		
		public function add(url:String)
		{
			aMovies.push(url);
			
		}
		
		public function start()
		{
			if (aMovies.length > 0)
			{
				loadNext();
			}
		}
		
		private function loadNext()
		{
			oLoader = new Loader();
			oLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			oLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			oRequest = new URLRequest(aMovies[0]);
			oLoader.load(oRequest);
			
		}
		/**
		 * 
		 * @param	event
		 */
		private function onError(event:IOErrorEvent)
		{
			//trace("mloader error on :[" + aMovies[0]+"]");
			aMovies.shift();
			oError = new LoadError(event.text);
			dispatchEvent(oError);
			if (aMovies.length != 0)
			{
				loadNext();
			}
			else {
				
				dispose();
			}
			
		}
		private function onProgress(e:ProgressEvent)
		{
			dispatchEvent(e);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onLoaded(event:Event)
		{
			aMovies.shift();
			
			if (aMovies.length != 0)
			{
				oEvent = new LoadEvent(false, event.target);
				dispatchEvent(oEvent);
				loadNext();
				
			}
			else
			{
				oEvent = new LoadEvent(true, event.target);
				dispatchEvent(oEvent);
				dispose();
			}

			
		}
		/**
		 * 
		 */
		private function dispose()
		{
			oLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			oLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);	
			oEvent = null;
		}
		
	}
	
}