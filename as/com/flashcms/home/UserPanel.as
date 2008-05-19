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
		
		public function UserPanel() {
			super("User");
		}
		public override function init()
		{
			oXMLLoader = new XMLLoader(oShell.getURL("getData", "groups"),onXMLData);
		}
		
		private function onXMLData(e:Event)
		{
			txtUser.text = "Welcome, " + oShell.oUser.sName;
			btProfile.addEventListener(MouseEvent.CLICK, onProfile);
			btPassword.addEventListener(MouseEvent.CLICK, onPassword);
			btLogout.addEventListener(MouseEvent.CLICK, onLogout);
		}
		private function onProfile(e:Event)
		{
			
			oShell.showPopup("edit",{name:"users"},onEdit);
		}
		private function onEdit(e:PopupEvent)
		{
		
		}
		private function onPassword(e:Event)
		{
			//oShell.showPopup("edit",{name:"users"},onEdit);
		}
		private function onLogout(e:Event)
		{
			//oShell.showPopup("edit",{name:"users"},onEdit);
		}
		
	}
	
}