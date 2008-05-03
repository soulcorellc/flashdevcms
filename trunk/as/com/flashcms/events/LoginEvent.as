package com.flashcms.events {
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class LoginEvent extends Event{
		public static const LOGIN_EVENT:String = "loginEvent";
		public var sName:String=null;
		public function LoginEvent(sName) {
			super(LOGIN_EVENT);
			this.sName = sName;
		}
		
	}
	
}