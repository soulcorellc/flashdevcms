package com.flashcms.events {
	
	import flash.display.Loader;
	import flash.display.MovieClip;
    import flash.events.Event;

    public class LoadEvent extends flash.events.Event {
		public static const LOAD_EVENT:String = "loadEvent";
		public var finish:Boolean;
		public var loaderTarget:Object;
		
		public function LoadEvent(finish:Boolean=false,loader:Object=null) {
			super(LOAD_EVENT);
			this.finish = finish;
			this.loaderTarget = loader;
		}
    }
}