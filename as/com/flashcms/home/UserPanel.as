package com.flashcms.home {
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.PopupEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import com.flashcms.forms.FormData;
	/**
	* ...
	* @author Default
	*/
	public class UserPanel extends Module {
		
		private var oXMLLoader:XMLLoader;
		private var oXMLForm:XML;
		private var oForm:FormData;
		public function UserPanel() {
			super("User");
		}
		/**
		 * 
		 */
		public override function init()
		{
			oXMLLoader = new XMLLoader(oShell.getURL("main", "groups"),onXMLData);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onXMLData(e:Event)
		{
			oXMLForm = XML(e.target.data);
			txtUser.text = "Welcome, " + oShell.oUser.sName;
			btProfile.addEventListener(MouseEvent.CLICK, onProfile);
			btPassword.addEventListener(MouseEvent.CLICK, onPassword);
			btLogout.addEventListener(MouseEvent.CLICK, onLogout);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onProfile(e:Event)
		{
			oForm = new FormData("users", "users", true,oXMLForm);
			oShell.showPopup("edit",oForm,onEdit);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onEdit(e:PopupEvent)
		{
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onPassword(e:Event)
		{
			
			oForm = new FormData("password", "password");
			oShell.showPopup("edit",oForm,onEdit);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onLogout(e:Event)
		{
			oShell.logout();
		}
		
	}
	
}