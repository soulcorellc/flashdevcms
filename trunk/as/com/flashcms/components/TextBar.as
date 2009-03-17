package com.flashcms.components {
	import fl.accessibility.ComboBoxAccImpl;
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.controls.NumericStepper;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import fl.controls.Button;
	import com.yahoo.astra.fl.containers.HBoxPane;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.yahoo.astra.layout.modes.*;
	import fl.events.ColorPickerEvent;
	import flash.text.Font;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	/**
	* ...
	* @author Default
	*/
	public class TextBar extends ToolBar{
		public var formatPanel:HBoxPane;
		public var fontPanel:HBoxPane;
		public var txtText:TextField;
		public var oFormat:TextFormat;
		public var colorpicker:ColorPicker;
		public var cbSize:NumericStepper;
		public var cbFonts:ComboBox;
		public var xmlControls:XML =
		<data>
			<controls>
				<type>Bold</type>
				<icon>IconBold</icon>
			</controls>
			<controls>
				<type>Italic</type>
				<icon>IconItalic</icon>
			</controls>
			<controls>
				<type>Underline</type>
				<icon>IconUnderline</icon>
			</controls>
			<controls>
				<type>Bullets</type>
				<icon>IconBullets</icon>
			</controls>
			<controls>
			<type>Paragraph</type>
				<icon>IconParagraph</icon>
			</controls>
			
			
		</data>
		;
		/**
		 * 
		 */
		public function TextBar(field:TextField=null) {
			
			if(field){
				txtText = field;
				init();
			}
			
		}
		public function init()
		{
			oFormat = new TextFormat();
			txtText.alwaysShowSelection = true;
			setToolBar(xmlControls.controls, formatPanel, onClick);
		}
		/**
		 * 
		 * @param	e
		 */
		function onClick(e:Event)
		{
			var currentText = txtText.text.slice(txtText.selectionBeginIndex, txtText.selectionEndIndex);
			switch(e.target.name)
			{
				case "Bold":
					//oFormat.bold = !txtText.getTextFormat(txtText.selectionBeginIndex, txtText.selectionEndIndex).bold;
					txtText.replaceSelectedText("<b>"+currentText+"</b>")
				break;
				case "Underline":
					txtText.replaceSelectedText("<u>"+currentText+"</u>")
				break;
				case "Italic":
					txtText.replaceSelectedText("<i>"+currentText+"</i>")
				break;
				case "Bullets":
					txtText.replaceSelectedText("<ol><li>"+currentText+"</li></ol>")
				break;
				case "Paragraph":
					txtText.replaceSelectedText("<p>"+currentText+"</p>")
				break;
				case "Link":
					txtText.replaceSelectedText("<a href='http://www.algo.com'>"+currentText+"</a>")
				break;
				
			}
			
		}
		/**
		 * 
		 * @param	data
		 * @param	toolbar
		 * @param	callback
		 */
		private function setToolBar(data:XMLList,toolbar:HBoxPane,callback:Function)
		{
			for each(var component:XML in data)
			{
				var oButton:Button = new Button();
				oButton.useHandCursor = true;
				oButton.addEventListener(MouseEvent.MOUSE_DOWN, callback);
				oButton.width = 32;
				oButton.label = "";
				oButton.name = component.type;
				oButton.setStyle("upSkin", Shape);
				oButton.setStyle("icon", component.icon);
				toolbar.addChild(oButton);
			}
			toolbar.setStyle( "skin", "ToolbarSkin" ); 
			toolbar.horizontalAlign = HorizontalAlignment.CENTER;
			toolbar.verticalAlign = VerticalAlignment.MIDDLE;
			toolbar.verticalGap = 10;
			toolbar.horizontalGap = 10;
			
		}
		
		
		
	}
	
}	