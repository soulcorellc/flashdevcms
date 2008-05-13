package com.flashcms.events {
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class PopupEvent extends Event{
		public var parameters:Object;
		public static const CLOSE = "close";
		public static const POPUP_EVENT = "popupEvent";
		public static const SHOW_POPUP = "showPopup";
		public function PopupEvent(type:String,parameters:Object=null) {
			this.parameters = parameters;
			super(type);
			
		}
		
	}
	
}