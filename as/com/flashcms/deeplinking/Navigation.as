package com.flashcms.deeplinking {
	import com.flashcms.deeplinking.SWFAddress;
	/**
	* ...
	* @author Default
	*/
	public class Navigation {
		public var oController;
		public function Navigation(controller) {
			oController = controller;
			SWFAddress.setStrict(false);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onChange);
			//SWFAddress.setValue("/");
		}
		public function onChange(event:SWFAddressEvent)
		{
			var module:String = SWFAddress.getValue() == ""? "/":SWFAddress.getValue();
			var parameters:Object = new Object;
			oController.setModule(module,parameters);
		}
		
		public function setURL(module:String, parameters:Object)
		{
			SWFAddress.setValue("/seccion/parametros");
		}
	}
}