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
		
		public var txtNombre:TextField;
		public var btEnter:Button;
		public var sUserName:String="david";
		private var oXMLLoader:XMLLoader;
		private var txtError:TextField;
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
			oXMLLoader = new XMLLoader(oShell.getURL("main", "login"), onXMLData, onDataError,onError,{usuario:"david",password:"123456"});
		}
		private function onXMLData(event:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE));	
		}
		private function onDataError(event:ErrorEvent)
		{
			txtError = new TextField();
			txtError.text = event.message;
			txtError.y = 100;
			addChild(txtError);
		}
		
		private function onError(event:Error)
		{
			trace("onError");
		}
		
		
		
	}
}