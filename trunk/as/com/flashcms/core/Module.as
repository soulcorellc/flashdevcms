package com.flashcms.core {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	/**
	* ...
	* @author David Barrios
	*/
	public class Module extends MovieClip {
		private var _oShell;
		public var sName:String;
		private var oXML:XML; 
		private var oLoader:URLLoader;
		public function Module(name:String=null) {
			
			sName = name;
		}
				
		public function getURL(name:String, section:String = null):String
		{
			return oShell.getURL(name, section);
		}
		
		public function init()
		{
			
		}
		
		public function onResize(event:Event)
		{
			
		}
		public function get oShell() {
			return _oShell; 
		};
		
		public function set oShell(value):void {
			_oShell = value;
		}
	}
	
}