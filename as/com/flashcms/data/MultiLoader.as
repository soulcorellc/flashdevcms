package com.flashcms.data {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import com.flashcms.events.*;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	/**
	* ...
	* @author David Barrios
	*/
	public class MultiLoader extends EventDispatcher {
		
		private var oRequest:URLRequest;
		private var aMovies:Array;
		private var oLoader:Loader;
				
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
			oLoader.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
			
			oRequest = new URLRequest(aMovies[0]);
			oLoader.load(oRequest);
			
		}
		
		private function onError(event:IOErrorEvent)
		{
			trace("error on :<" + aMovies[0]+">");
			aMovies.shift();
			dispatchEvent(new LoadError(event.text));
			if (aMovies.length != 0)
			{
				loadNext();
			}
			else {
				oLoader = null;
			}
			
		}
		private function onOpen(event:Event)
		{
			//trace("OPEN :" + event);
		}
		private function onLoaded(event:Event)
		{
			aMovies.shift();
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			if (aMovies.length != 0)
			{
				dispatchEvent(new LoadEvent(false,loaderInfo));
				loadNext();
				
			}
			else
			{
				dispatchEvent(new LoadEvent(true, loaderInfo));
				oLoader = null;
			}
			
		}
		
	}
	
}