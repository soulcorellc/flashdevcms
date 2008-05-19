package com.flashcms.components {
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author Default
	*/
	public class ButtonBar extends Sprite{
		
		var btnOK:Button;
		var btnCANCEL:Button;
		var okhandler:Function;
		var cancelhandler:Function;
		var labelOK:String;
		var labelCancel:String;
		public function ButtonBar(okhandler:Function,cancelhandler:Function,labelOK:String="OK",labelCancel:String="Cancel") {
			this.okhandler = okhandler;
			this.cancelhandler = cancelhandler;
			this.labelOK = labelOK;
			this.labelCancel = labelCancel;
			init();
		}
		
		private function init()
		{
			btnOK = new Button();
			btnOK.label = labelOK;
			btnOK.addEventListener(MouseEvent.CLICK, okhandler);
			btnCANCEL = new Button();
			btnCANCEL.x = 120;
			btnCANCEL.label = labelCancel;
			btnCANCEL.addEventListener(MouseEvent.CLICK, cancelhandler);
			addChild(btnOK);
			addChild(btnCANCEL);
		}
		
		
	}
	
}