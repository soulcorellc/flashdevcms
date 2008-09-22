package com.flashcms.login {
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	import com.flashcms.events.PopupEvent;
	import flash.events.MouseEvent;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.design.DynamicBG;
	/**
	* ...
	* @author David Barrios
	*/
	public class Login extends Module{
		
		public var txtTitle:TextField;
		public var txtUser:TextInput;
		public var txtPass:TextInput;
		public var btEnter:Button;
		public var sUserName:String="";
		public var txtError:TextField;
		private var sOption:String = "login";
		private var oXMLLoader:XMLLoader;
		private var oXML:XML;
		private var oBG:DynamicBG;
		public function Login() {
			super("Login");
			createBG();
		}
		/**
		 * 
		 */
		public override function init()
		{
			txtUser.tabIndex = 0;
			txtPass.tabIndex = 1;
			btEnter.tabIndex = 2;
			txtError.tabEnabled = false;
			txtTitle.tabEnabled = false;
			btEnter.addEventListener(MouseEvent.CLICK, onEnter);
		}
		/**
		 * 
		 */
		private function createBG()
		{
			oBG = new DynamicBG(350, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		/**
		 * 
		 * @param	e
		 */
		public function onEnter(e:Event)
		{
			if(txtUser.text!="" && txtPass.text != ""){ 
				var url:String = oShell.getURL("login", "core");
				oXMLLoader = new XMLLoader(url, onXMLData, onDataError, onError, { option:sOption, user:txtUser.text, password:txtPass.text } );
			}
			else
			{
				txtError.text="Escriba usuario y contraseña"
			}
		}
		private function onXMLData(event:Event)
		{
			oXML = XML(event.target.data);
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{sID:oXML.user.idUser,sName:oXML.user.idUser}));	
		}
		private function onDataError(event:ErrorEvent)
		{
			txtError.text = event.message;
		}
		
		private function onError(event:IOErrorEvent)
		{
			trace("FILE NOT FOUND ON LOGIN "+event.text);
		}
		
		
		
	}
}