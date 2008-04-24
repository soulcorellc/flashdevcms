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
			loadNext();
		}
		
		private function loadNext()
		{
			var oLoader:Loader = new Loader();
			oLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			oLoader.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
			
			trace("loading :<" + aMovies[0]+">");
			oRequest = new URLRequest(aMovies[0]);
			oLoader.load(oRequest);
			
		}
		
		private function onError(event:IOErrorEvent)
		{
			aMovies.shift();
			dispatchEvent(new LoadError(event.text));
			if (aMovies.length != 0)
			{
				loadNext();
			}
			
		}
		private function onOpen(event:Event)
		{
			trace("OPEN :" + event);
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
				dispatchEvent(new LoadEvent(true,loaderInfo));
			}
			
		}
		
	}
	
}