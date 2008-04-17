package com.flashcms.events {
	
	import flash.display.MovieClip;
    import flash.events.Event;

    public class LoadError extends flash.events.Event {
		public static const LOAD_ERROR:String = "loadError";
		public var message:String;
		
		public function LoadError(message:String=null) {
			super(LOAD_ERROR);
			this.message = message;
		}
    }
}