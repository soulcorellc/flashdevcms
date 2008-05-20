package com.flashcms.home {
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.PopupEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	/**
	* ...
	* @author Default
	*/
	public class UserPanel extends Module {
		
		private var oXMLLoader:XMLLoader;
		private var oXMLForm:XML;
		public function UserPanel() {
			super("User");
		}
		public override function init()
		{
			oXMLLoader = new XMLLoader(oShell.getURL("main", "groups"),onXMLData);
		}
		
		private function onXMLData(e:Event)
		{
			oXMLForm = XML(e.target.data);
			txtUser.text = "Welcome, " + oShell.oUser.sName;
			btProfile.addEventListener(MouseEvent.CLICK, onProfile);
			btPassword.addEventListener(MouseEvent.CLICK, onPassword);
			btLogout.addEventListener(MouseEvent.CLICK, onLogout);
		}
		private function onProfile(e:Event)
		{
			oShell.showPopup("edit",{name:"users",data:oXMLForm},onEdit);
		}
		private function onEdit(e:PopupEvent)
		{
			
		}
		private function onPassword(e:Event)
		{
			oShell.showPopup("edit",{name:"password"},onEdit);
		}
		private function onLogout(e:Event)
		{
			oShell.logout();
		}
		
	}
	
}