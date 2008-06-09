package com.flashcms.login {
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import com.flashcms.events.PopupEvent;
	import flash.events.MouseEvent;
	import com.flashcms.data.XMLLoader;
	/**
	* ...
	* @author David Barrios
	*/
	public class Login extends Module{
		
		public var txtUser:TextField;
		public var txtPass:TextField;
		public var btEnter:Button;
		public var sUserName:String="";
		public var txtError:TextField;
		private var sOption:String = "login";
		private var oXMLLoader:XMLLoader;
		private var oXML:XML;
		public function Login() {
			super("Login");
		}
		/**
		 * 
		 */
		public override function init()
		{
			btEnter.addEventListener(MouseEvent.CLICK, onEnter);
		}
		/**
		 * 
		 * @param	e
		 */
		public function onEnter(e:Event)
		{
			oXMLLoader = new XMLLoader(oShell.getURL("main", "login"), onXMLData, onDataError,onError,{option:sOption,user:txtUser.text,password:txtPass.text});
		}
		private function onXMLData(event:Event)
		{
			oXML = XML(event.target.data);
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{sName:oXML.user.nombre}));	
		}
		private function onDataError(event:ErrorEvent)
		{
			txtError.text = event.message;
		}
		
		private function onError(event:Error)
		{
			trace("onError");
		}
		
		
		
	}
}