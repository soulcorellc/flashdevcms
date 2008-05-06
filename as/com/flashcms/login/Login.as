package com.flashcms.login {
	import com.flashcms.core.Module;
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author David Barrios
	*/
	public class Login extends Module{
		
		public var txtNombre:TextField;
		public var btEnter:Button;
		public var sUserName:String="usuario";
		
		public function Login() {
			super("Login");
		}
		
		public override function init()
		{
			btEnter.addEventListener(MouseEvent.CLICK, onEnter);
		}
		public function onEnter(e:Event)
		{
			dispatchEvent(new Event("closepopup"));	
		}
		
	}
}