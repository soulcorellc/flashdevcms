package com.flashcms.admin {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import com.flashcms.core.Module;
	import com.yahoo.astra.fl.containers.VBoxPane;
	import com.yahoo.astra.layout.modes.*;
	import com.flashcms.components.Holder;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	
	/**
	* ...
	* @author Default
	*/
	public class Templates extends Module{
		public var scPanel:ScrollPane;
		public var cpPanel:VBoxPane;
		public var selectionPanel:VBoxPane;
		private var icon:Holder;
		private var mcLayout:Sprite;
		private var id:int = 0;
		private var selected:Holder;
		public var xmlData:XML =
		<data>
			<components>
				<type>Text</type>
				<icon>IconText</icon>
			</components>
			<components>
				<type>Image</type>
				<icon>IconImage</icon>
			</components>
			<components>
				<type>Video</type>
				<icon>IconVideo</icon>
			</components>
		</data>;
		
		public var xmlTemplate:XML = <template/>;
		
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
			mcLayout = new Sprite();
			mcLayout.graphics.beginFill(0xFFFFFF, 0.3);
			mcLayout.graphics.drawRect(10, 10, 612, 523);
			mcLayout.graphics.endFill();
			scPanel.source=mcLayout;
			selectionPanel.setStyle( "skin", "ToolbarSkin" ); 
			cpPanel.setStyle( "skin", "ToolbarSkin" ); 
			cpPanel.horizontalAlign = HorizontalAlignment.CENTER;
			cpPanel.verticalAlign = VerticalAlignment.MIDDLE;
			cpPanel.verticalGap = 10;
			cpPanel.horizontalGap = 10;
			for each(var component:XML in xmlData.components)
			{
				var oButton:Button = new Button();
				oButton.useHandCursor = true;
				oButton.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
				oButton.width = 32;
				oButton.label = "";
				oButton.name = component.type;
				oButton.setStyle("upSkin", Shape);
				oButton.setStyle("icon", component.icon);
				cpPanel.addChild(oButton);
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onDelete)
		}
		/**
		 * 
		 * @param	e
		 */
		private function onStartDrag(e:MouseEvent)
		{
			icon = new Holder(e.target.name);
			icon.x = mouseX-8;
			icon.y = mouseY - 8;
			icon.alpha = 0.5;
			addChild(icon);
			icon.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			icon.addEventListener("Select", onSelect);
			icon.startDrag();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onStopDrag(e:MouseEvent)
		{
			icon.stopDrag();
			icon.addEventListener("Resize", onHolderResize);
			icon.alpha = 1;
			icon.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			if (icon.dropTarget.parent.parent== scPanel)
			{
				insertHolder();
				insertXML();
			}
			else 
			{
				removeChild(icon);
				icon = null;
			}
		}
		/**
		 * 
		 * @param	e
		 */
		private function onHolderResize(e:Event)
		{
			updateXML(e.target);
		}
		/**
		 * 
		 */
		private function updateXML(target)
		{
			var node = xmlTemplate.component.(@id == target.id);
			node.@x = target.x;
			node.@y = target.y;
			node.@width = target.width;
			node.@height = target.height;
			trace(xmlTemplate);
		}
		/**
		 * 
		 */
		private function insertXML()
		{
			xmlTemplate.component += <component id = { icon.id } type = { icon.type } x={icon.x} y={icon.y} width={icon.width} height={icon.height} />
			
		}
		/**
		 * 
		 */
		private function removeXML()
		{
			var node:XMLList = xmlTemplate.component.(@id == selected.id);
			delete node[0];
		}
		/**
		 * 
		 */
		private function insertHolder()
		{
			var point = new Point(icon.x, icon.y);
			var point2 = this.localToGlobal(point);
			mcLayout.globalToLocal(point2);
			icon.id = id;
			icon.x = mcLayout.globalToLocal(point2).x;
			icon.y=scPanel.globalToLocal(point2).y;
			mcLayout.addChild(icon);
			scPanel.update();
			icon.setDragable();
			id++;
		}
		/**
		 * 
		 * @param	e
		 */
		private function onSelect(e:Event)
		{
			selected = e.target as Holder;
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDelete(e:KeyboardEvent)
		{
			switch (e.keyCode) {
				case Keyboard.DELETE:
				deleteComponent();
				break;
			}
		}
		/**
		 * 
		 */
		private function deleteComponent()
		{
			if(selected != null)
			{
				removeXML();
				mcLayout.removeChild(selected);
				selected = null;
			}
		}
		/**
		 * 
		 */
		private function updateLayout()
		{
			mcLayout.graphics.clear();
			mcLayout.graphics.beginFill(0xFFFFFF, 0.3);
			mcLayout.graphics.drawRect(10, 10, mcLayout.width, mcLayout.height);
			mcLayout.graphics.endFill();
			
		}
		
	}
	
}