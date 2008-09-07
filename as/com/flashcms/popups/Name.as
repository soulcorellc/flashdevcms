package com.flashcms.popups 
{
	import com.flashcms.core.Module;
	import com.flashcms.design.DynamicBG;
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.events.MouseEvent;
	import com.flashcms.events.PopupEvent;
	import flash.text.TextField;
	/**
	* ...
	* @author David Barrios
	*/
	public class Name extends Module
	{
		private var oBG:DynamicBG;
		public var btSelect:Button;
		public var btCancel:Button;
		public var txtTitle:TextField;
		public var txtName:TextInput;
		public function Name() 
		{
			createBG();
		}
		private function createBG()
		{
			oBG = new DynamicBG(400, new left(), new center(), new right());
			addChildAt(oBG, 0);
			btSelect.addEventListener(MouseEvent.CLICK, onSelect);
			btCancel.addEventListener(MouseEvent.CLICK, onCancel);
		}
		public override function init()
		{
			txtTitle.text = parameters.title;
		}
		private function onSelect(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{name:txtName.text}));
		}
		private function onCancel(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{}));
		}
	}
	
}