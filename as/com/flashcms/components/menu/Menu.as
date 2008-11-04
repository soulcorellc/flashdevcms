package com.flashcms.components.menu
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.flashcms.components.menu.MenuItem
	import gs.TweenMax;
	/**
	 * @author David Barrios
	 */
	public class Menu extends MovieClip 
	{
		public var xmlData:XML;
		public var nHeight:Number=20;
		public var nWidth:Number = 150;
		public var nextY = 0;
		public var nSpace:Number = 3;
		public var aItems:Array;
		public var aColors:Array;
		
		/**
		 * 
		 */
		public function Menu() 
		{
			
		}
		
		/**
		 * 
		 * @param	data
		 */
		public function init(data:XML)
		{
			aItems = new Array();
			xmlData = data;
			draw();
			trace(xmlData);
			
		}
		/**
		 * 
		 */
		private function draw()
		{
			for each(var item:XML in xmlData.node)
			{
				
				createItem(item,0,0);
			}
		}
		/**
		 * 
		 * @param	item
		 * @param	xpos
		 */
		private function createItem(item:XML,xpos:Number,level:Number)
		{
			var isLeaf = item.children().length() == 0? true : false;
			var oItem:MenuItem = new MenuItem(item.@id, item.@label,nWidth,nHeight,0x00FFFF,isLeaf,level);
			oItem.useHandCursor = true;
			addChild(oItem);
			oItem.x = xpos;
			oItem.y = nextY;
			nextY += nHeight + nSpace;
			oItem.addEventListener(MouseEvent.ROLL_OVER, onRollOverItem);
			oItem.addEventListener(MouseEvent.ROLL_OUT, onRollOutItem);
			aItems.push(oItem);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onRollOverItem(e:Event)
		{

			if (!e.target.isLeaf)
			{
				
				if (!e.target.isOpen)
				{
					nextY = e.target.y;
					e.target.isOpen = true;
					createSubItems(e.target.sID,e.target.nLevel);
				}
				else
				{
					//e.target.isOpen = false;
					//removeSubItems(e.target.sID);
					//trace(xmlData.node.(@id == e.target.sID).children().length(), " hijos");
				}
			}
		}
		private function onRollOutItem(e:Event)
		{
			//trace("level",e.target.nLevel);
			//if (!e.target.isLeaf) {
				
			e.target.isOpen = false;
			//removeSubItems(e.target.sID);
			//}
			//trace(xmlData.node.(@id == e.target.sID).children().length(), " hijos");
		}
		/**
		 * 
		 * @param	id
		 * @param	level
		 */
		private function createSubItems(id,level)
		{
			
			var childnodes:XMLList = xmlData..node.(@id == id).children();
			
			for each (var item:XML in childnodes)
			{
				createItem(item, nWidth * (level+1),level+1);
				//trace(item.@label, item.@id);
			}
			
		}
		/**
		 * 
		 */
		private function removeSubItems(id)
		{
			var childnodes:XMLList = xmlData..node.(@id == id).children();
			for each (var item:XML in childnodes)
			{
				deleteItem(item.@id);
				aItems=removeItems(aItems, item.@id);
				//trace(item.@label, item.@id);
			}
		}
		
		
		
		function removeItems(array:Array, removeValue:Number):Array{
			var outputArray:Array = array.filter(function (item:*, index:int,array:Array):Boolean
			{
				return (item.sID != removeValue);
			});
			return outputArray;
		}
		
		private function deleteItem(id)
		{
			for each(var menuitem in aItems)
			{
				if (menuitem.sID == id)
				{
					trace("sid ", menuitem.sID, " = ", id);
					removeChild(menuitem);
				}
			}
		}
		
	}
	
}