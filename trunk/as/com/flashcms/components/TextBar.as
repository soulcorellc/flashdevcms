package com.flashcms.components {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	* ...
	* @author Default
	*/
	public class TextBar {
		public var txtText:TextField;
		public var oFormat:TextFormat;
		/**
		 * 
		 */
		public function TextBar(field:TextField) {
			txtText = field;
			txtText.alwaysShowSelection = true;
		}
		public function init()
		{
			//oFormat=txtText.getTextFormat(txtText.selectionBeginIndex,txtText.selectionEndIndex);
			//oFormat.bold=!txtFormat.bold;
			//oFormat.underline=!txtFormat.bold;
		}
		/**
		 * 
		 * @param	e
		 */
		function onClick(e:Event)
		{
			txtText.setTextFormat(oFormat,txtText.selectionBeginIndex,txtText.selectionEndIndex);
			
			//trace(mytext.htmlText);
			//mytext.replaceSelectedText()
			//mytext.replaceSelectedText("<b>"+mytext.text.slice(mytext.selectionBeginIndex,mytext.selectionEndIndex)+"</b>")
			//trace(mytext.text.slice(mytext.selectionBeginIndex,mytext.selectionEndIndex));
			//mytext.htmlText=mytext.text;
			//trace("caretIndex:", mytext.caretIndex);
			//trace("selectionBeginIndex:", mytext.selectionBeginIndex);
			//trace("selectionEndIndex:", mytext.selectionEndIndex);

		}
		
	}
	
}