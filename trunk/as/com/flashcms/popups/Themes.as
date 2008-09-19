package com.flashcms.popups 
{
	import com.flashcms.core.Module;
	import com.flashcms.design.DynamicBG;
	import com.flashcms.components.ButtonBar;
	import com.flashcms.editors.utils.ThemeItem;
	import fl.containers.ScrollPane;
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.layout.LayoutSchema;
	import com.flashcms.data.XMLLoader;
	
	/**
	* ...
	* @author David Barrios
	*/
	public class Themes extends Module
	{
		public var scPanel:ScrollPane;
		public var txtName:TextInput;
		private var oBG:DynamicBG;
		private var oBar:ButtonBar;
		private var oLayout:LayoutSchema;
		private var mcHolder:MovieClip;
		private var bCreate:Boolean;
		private var id:String;
		private var oXMLLoader:XMLLoader;
		private var oXMLEdit:XML;
		private var oXMLTemp:XML;
		private var oXML:XML;
		private var oXMLDefault:XML =
		<data>
			<header name="Header">0x003366</header>
			<footer name="Footer">0x003366</footer>
			<background name="Background">0x006699</background>
			<menu_background name="Menu Background">0xFFFF00</menu_background>
			<menu_up name="MenuItem Up">0x003366</menu_up>
			<menu_over name="MenuItem Over">0x003366</menu_over>
			<menu_uptext name="MenuItem Text Up">0x003366</menu_uptext>
			<menu_overtext name="MenuItem Text Over">0x003366</menu_overtext>
			<submenu_up name="Submenu Up">0x003366</submenu_up>
			<submenu_over name="Submenu Over">0x003366</submenu_over>
			<submenu_textup name="Submenu Text Up">0x003366</submenu_textup>
			<submenu_textover name="Submenu Text Over">0x003366</submenu_textover>
		</data>;
		public function Themes() 
		{
			createBG();
		}
		public override function init()
		{
			bCreate = parameters.create ;
			id = parameters.id;
			oLayout = new LayoutSchema(this, 3, 50, 0);
			oLayout.defaultwidth = 150;
			oLayout.bChangeWidth = false;
			oLayout.xmargin = 10;
			oLayout.ymargin = 10;
			mcHolder = new MovieClip();
			addChild(mcHolder);
			scPanel.source = mcHolder;
	
			oBar = new ButtonBar(doSave, onCancel, "Save", "Cancel");
			oBar.x = 20;
			oBar.y = 310;
			addChild(oBar);
			
			if (bCreate== true){
				txtName.text = "New Template";
				oXML = oXMLDefault;
				createItems();
			}
			else
			{
				oXMLLoader = new XMLLoader(oShell.getURL("main", "themes"), onLoadTheme,null,null,{option:"gettheme",idTheme:parameters.id});
			}
		}
		private function onLoadTheme(e:Event)
		{
			oXMLEdit = XML(e.target.data);
			txtName.text=oXMLEdit.themes[0].name;
			var templatestring:String = oXMLEdit.themes[0].data;
			var oXMLTemp:XML = new XML(templatestring);
			trace(templatestring);
			oXML = new XML(oXMLTemp.toString());
			createItems();
		}
		private function createItems()
		{
			trace("creating items on edit");
			for each(var theme:XML in oXML.children()){
				var item:ThemeItem = new ThemeItem(theme.@name);
				item.name = theme.name();
				item.cPicker.selectedColor = theme.text();
				var obj = mcHolder.addChild(item);
				oLayout.addComponent(obj, "","theme");
			}
			var mcX:MovieClip = new MovieClip();
			mcX.graphics.beginFill(0x003366, 1);
			mcX.graphics.drawRect(0, 0, 10, 10);
			mcX.graphics.endFill();
			
			mcX.y=mcHolder.height+50
			mcHolder.addChild(mcX)
			scPanel.update();
			
		}
		private function createBG()
		{
			oBG = new DynamicBG(550, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		private function doSave(e:Event)
		{
			var obj = oLayout.getFormObject();
			var strData:String = "<data>";
			for (var i in obj)
			strData += "<" + i + " name='"+oXMLDefault[i].@name+"'>" + obj[i] + "</" + i + ">";
			strData += "</data>";
			
			if(bCreate==true)
			oXMLLoader = new XMLLoader(oShell.getURL("main", "themes"), onSave,null,null,{option:"settheme",name:txtName.text,data:strData});
			else
			oXMLLoader = new XMLLoader(oShell.getURL("main", "themes"), onSave,null,null,{option:"edittheme",idTheme:id,name:txtName.text,data:strData});
		}
		private function onSave(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"yes"}));
		}
		
		private function onCancel(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"no"}));
		}
	}
	
}