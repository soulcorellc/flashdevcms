package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.yahoo.astra.fl.containers.VBoxPane;
	import com.yahoo.astra.layout.modes.*;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	
	/**
	* ...
	* @author Default
	*/
	public class Templates extends Module{
		public var scPanel:ScrollPane;
		public var cpPanel:VBoxPane;
		public var xmlData:XML =
		<data>
			<components>
				<type>Text</type>
			</components>
			<components>
				<type>Image</type>
			</components>
			<components>
				<type>Video</type>
			</components>
		</data>
		
		/**
		 * 
		 */
		public function Templates() {
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			cpPanel.verticalAlign = VerticalAlignment.MIDDLE;
			cpPanel.verticalGap = 5;
			for each(var component:XML in xmlData.components)
			{
				var oButton:Button = new Button();
				oButton.label = component.type;
				trace("type : "+component.type);
				cpPanel.addChild(oButton);
			}
		}
		
	}
	
}