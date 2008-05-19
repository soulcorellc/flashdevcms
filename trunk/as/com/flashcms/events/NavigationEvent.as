package com.flashcms.events {
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class NavigationEvent extends Event {
		
		public static const ON_NAVIGATION:String = "onNavigation";
		public var parameters:Object;
		public var sModule:String;
		public function NavigationEvent(module:String,parameters:Object=null) {
			super(ON_NAVIGATION);
			sModule = module;
			this.parameters = parameters;
		}
		
	}
	
}
