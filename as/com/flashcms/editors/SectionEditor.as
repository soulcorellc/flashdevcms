package com.flashcms.editors {
	import com.flashcms.core.Module;
	import com.yahoo.astra.fl.controls.TabBar;
	import fl.containers.ScrollPane;
	import com.yahoo.astra.fl.containers.VBoxPane;
	/**
	* ...
	* @author Default
	*/
	public class SectionEditor extends Module{
		public var oTabBar:TabBar;
		public var scPanel:ScrollPane;
		public var componentsPanel:VBoxPane;
		public var toolsPanel:VBoxPane;
		
		public function SectionEditor() {
			super("SectionEditor");	
		}
		
	}
	
}