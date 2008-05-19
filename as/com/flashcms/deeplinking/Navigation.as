package com.flashcms.deeplinking {
	import com.flashcms.deeplinking.SWFAddress;
	import com.flashcms.events.NavigationEvent;
	import flash.events.EventDispatcher;
	/**
	* ...
	* @author Default
	*/
	public class Navigation extends EventDispatcher{
		public var oController;
		public function Navigation(controller) {
			oController = controller;
			SWFAddress.setStrict(false);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onChange);
		}
		public function onChange(event:SWFAddressEvent)
		{
			var module:String = SWFAddress.getValue() == ""? "/":SWFAddress.getPath();
			var oparams:Object=new Object();
			oparams.section = SWFAddress.getParameter("section");
			var oEvent = new NavigationEvent(module, oparams);
			dispatchEvent(oEvent);
		}
		
		public function setURL(module:String, parameters:Object=null)
		{
			var sparams:String="section="+parameters.type;
			
			SWFAddress.setValue("/" + module+"?"+sparams);
			SWFAddress.setTitle(":: " + module + " ::");
			
		}
	}
}