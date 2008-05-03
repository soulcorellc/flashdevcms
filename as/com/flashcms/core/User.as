package com.flashcms.core {
	
	/**
	* ...
	* @author Default
	*/
	public class User {
		
		public var bLogged:Boolean;
		public var sName:String;
		
		public function User(name:String=null,logged:Boolean=false) {
			sName = name;
			bLogged = logged;
		}
		
	}
	
}