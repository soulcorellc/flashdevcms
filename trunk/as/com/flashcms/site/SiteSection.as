package com.flashcms.site 
{
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.yahoo.astra.fl.controls.mediaPlayerClasses.IMediaController;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.flashcms.components.ContentHolder;
	import com.flashcms.components.VideoHolder;
	import com.flashcms.components.ImageHolder;
	import com.flashcms.components.TextHolder;
	/**
	 * ...
	 * @author ...
	 */
	public class SiteSection extends Module
	{
		private var sURLTemplates:String;
		private var sURLContent:String;
		private var oXMLLoader:XMLLoader;
		private var xmlContentLoaded:XML;
		private var xmlContent:XML;
		private var xmlTemplate:XML;
		private var idTemplate:String;
		private var mcLayout:Sprite;
		
		public function SiteSection() 
		{
			mcLayout = new Sprite();
		}
		/**
		 * 
		 */
		
		public function setSection(id:String)
		{
			addChild(mcLayout);
			sURLTemplates = oShell.getURL("main", "template");
			sURLContent = oShell.getURL("main", "content")
			oXMLLoader = new XMLLoader(sURLContent, onContent, null, null, {option:"getcontent",idContent:id} );
		}
		/**
		 * 
		 * @param	e
		 */
		public function onContent(event:Event)
		{
			xmlContentLoaded = XML(event.target.data);
			idTemplate = xmlContentLoaded.content[0].idTemplate;
			//idContent= oXMLContentLoaded.content[0].idContent;
			var contentstring:String = xmlContentLoaded.content[0].content;
			var oXMLTemp:XML = new XML(contentstring);
			xmlContent=new XML(oXMLTemp.toString());
			oXMLLoader = new XMLLoader(sURLTemplates, onTemplate, null, null, { option:"gettemplate", idTemplate:idTemplate } );
			trace(xmlContent);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onTemplate(event:Event)
		{
			xmlTemplate = XML(event.target.data);
			var templatestring:String = xmlTemplate.template[0].content;
			var oXMLTemp:XML = new XML(templatestring);
			xmlTemplate = new XML(oXMLTemp.toString());
			
			
			for each(var component:XML in xmlTemplate.component)
			{
				var holder:ContentHolder=createComponent(component);
				//xmlContent.component +=<component id = { component.@id } /> ;	
			}
			//scPanel.update();
			
			
		}
		private function createComponent(component:XML):ContentHolder
		{
			var newcomponent:ContentHolder;
			switch(String(component.@type))
			{
				case "Text":
					newcomponent = new TextHolder(component.@width,component.@height);
				break;
				case "Video":
					newcomponent = new VideoHolder(component.@width,component.@height);
				break;
				case "Image":
					newcomponent = new ImageHolder(component.@width,component.@height);
				break;
			}
			newcomponent.id = component.@id;
			newcomponent.x = component.@x;
			newcomponent.y = component.@y;
			
			mcLayout.addChild(newcomponent);
			//aComponents.push(newcomponent);
			//newcomponent.addEventListener(MouseEvent.CLICK, onSelectComponent);
			return newcomponent;
			
		}
		
	}
	
}