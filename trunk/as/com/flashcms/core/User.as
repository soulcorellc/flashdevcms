package com.flashcms.core {
	
	/**
	* ...
	* @author Default
	*/
	public class User {
		
		public var bLogged:Boolean;
		public var sID:String;
		public var sName:String;
		public var nActive:int;
		public var idProfile:int;
		
		public function User(id:String=null,name:String=null,logged:Boolean=false,active:int=0,profile:int=0) {
			sID = id;
			sName = name;
			bLogged = logged;
			nActive = active;
			idProfile = profile;
		}
		
	}
	
}