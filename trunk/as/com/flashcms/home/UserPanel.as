package com.flashcms.home {
	import com.flashcms.core.Module;
	import flash.text.TextField;
	
	/**
	* ...
	* @author Default
	*/
	public class UserPanel extends Module {
		
		
		public function UserPanel() {
			super("User");
		}
		public override function init()
		{
			txtUser.text = "Welcome, " + oShell.oUser.sName;
		}
		
		
	}
	
}