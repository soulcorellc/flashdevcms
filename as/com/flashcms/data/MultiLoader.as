package com.flashcms.data {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import com.flashcms.events.*;
	import flash.display.DisplayObject;
	/**
	* ...
	* @author David Barrios
	*/
	public class MultiLoader {
		
		private var oRequest:URLRequest;
		private var oLoader:Loader;
		private var aMovies:Array;
				
		public function MultiLoader()
		{
			aMovies = new Array();
			oLoader = new Loader();
			oLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			
		}
		
		public function add(url:String)
		{
			aMovies.push(url);
		}
		
		public function start()
		{
			trace("start ... " );
			loadNext();
		}
		
		private function loadNext()
		{
			trace("loading ... " + aMovies[0]);
			oRequest = new URLRequest(aMovies[0]);
			oLoader.load(oRequest);
		}
		
		private function onError(event:IOErrorEvent)
		{
			aMovies.shift();
			dispatchEvent(new LoadError(event.toString()));
			if (aMovies.length != 0)
			{
				loadNext();
			}
			
		}
		private function onLoaded(event:Event)
		{
			aMovies.shift();
			if (aMovies.length != 0)
			{
				loadNext();
				var oEvent:LoadEvent = new LoadEvent(false, event.target);
				dispatchEvent(oEvent);
			}
			else
			{
				dispatchEvent(new LoadEvent(true));
			}
			
		}
		
	}
	
}