package com.flashcms.components 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import com.flashcms.data.MultiLoader;
	import com.flashcms.events.LoadEvent;
	import com.flashcms.events.LoadError;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	/**
	 * ...
	 * @author David Barrios
	 */
	public class SiteImage extends MovieClip
	{
		public var id:String;
		private var oLoader:MultiLoader;
		private var nWidht:Number;
		private var nHeight:Number;
		public function SiteImage(nwidth:int,nheight:int,url:String)
		{
			nWidht = nwidth;
			nHeight = nheight;
			oLoader = new MultiLoader();
			oLoader.addEventListener(LoadError.LOAD_ERROR, onError);
			oLoader.addEventListener(LoadEvent.LOAD_EVENT, onImageLoaded);
			oLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			oLoader.add(url);
			oLoader.start();
			trace("loading ",url);
		}
		
		private function onProgress(e:Event):void 
		{
			
		}
		
		private function onImageLoaded(e:LoadEvent):void 
		{
			var clip:DisplayObject= LoaderInfo(e.loaderTarget).loader.content;
			clip.width = nWidht;
			clip.height = nHeight;
			addChild(clip);
		}
		
		private function onError(e:LoadError):void 
		{
			
		}
		
	}
	
}