package com.flashcms.events {
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class ErrorEvent extends Event{
		public static const DATA_ERROR="dataError";
		public var message:String;
		public function ErrorEvent(type:String, message:String = null) {
			super(type);
			this.message = message;
		}
		
	}
	
}