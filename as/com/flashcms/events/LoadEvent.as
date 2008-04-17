package com.flashcms.events {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
    import flash.events.Event;

    public class LoadEvent extends flash.events.Event {
		public static const LOAD_EVENT:String = "loadEvent";
		public var mcTarget:Object;
		public var finish:Boolean;
		
		public function LoadEvent(finish:Boolean=false,target:Object=null) {
			super(LOAD_EVENT);
			this.mcTarget = target;
			this.finish = finish;
		}
    }
}