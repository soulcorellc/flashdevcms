package com.flashcms.core {
	
	/**
	* ...
	* @author Default
	*/
	public class User {
		
		public var bLogged:Boolean;
		public var sID:String;
		public var sName:String;
		
		public function User(id:String=null,name:String=null,logged:Boolean=false) {
			sID = id;
			sName = name;
			bLogged = logged;
		}
		
	}
	
}