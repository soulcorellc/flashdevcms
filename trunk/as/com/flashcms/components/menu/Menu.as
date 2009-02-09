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
		public var currentLevel:Number = 0;
		public var currentSub:Number = -1;
		public var aOpen:Array;
		public var xmlTheme:XML;
		public var selectedID:String;
		/**
		 * 
		 */
		public function Menu(theme:XML) 
		{
			xmlTheme = theme;
		}
		
		/**
		 * 
		 * @param	data
		 */
		public function init(data:XML)
		{
			aItems = new Array();
			aOpen = new Array();
			xmlData = data;
			draw();
			trace(xmlData);
			
		}
		/**
		 * 
		 */
		private function draw()
		{
			var index = 1;
			for each(var item:XML in xmlData.node)
			{
				createItem(item, 0, 0,index);
				index++;
			}
		}
		/**
		 * 
		 * @param	item
		 * @param	xpos
		 */
		private function createItem(item:XML,xpos:Number,level:Number,index:Number)
		{
			//trace(item.@label," creado" );
			var isLeaf = item.children().length() == 0? true : false;
			var oItem:MenuItem = new MenuItem(item.@id,item.@idContent,item.@label,nWidth,nHeight,isLeaf,level,xmlTheme);
			oItem.useHandCursor = true;
			addChild(oItem);
			oItem.x = xpos;
			//oItem.x = xpos -nWidth;
			oItem.y = nextY;
			//oItem.y = nextY + 50;
			oItem.alpha = 0;
			oItem.scaleX = 0;
			TweenMax.to(oItem, index*.2, { alpha:1,scaleX:1} );
			nextY += nHeight + nSpace;
			oItem.addEventListener(MouseEvent.ROLL_OVER, onRollOverItem);
			oItem.addEventListener(MouseEvent.ROLL_OUT, onRollOutItem);
			oItem.addEventListener(MouseEvent.CLICK, onClickItem);
			aItems.push(oItem);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onClickItem(e:Event)
		{
			selectedID = e.target.parent.sIDContent;
			dispatchEvent(new Event("ItemClick"));
			removeAll();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onRollOverItem(e:Event)
		{	
			if (e.target.nLevel < currentLevel)
			{
				
				if (aOpen.length != 0 )
				{
					removeSubItems(aOpen[aOpen.length - 1]);
					currentLevel--;
				}
			}
			
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
		/**
		 * 
		 */
		private function removeAll()
		{
			if (aOpen.length > 0)
			{
				for (var i in aOpen)
				{
					removeSubItems(aOpen.pop())
				}
			}
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onRollOutItem(e:Event)
		{
			e.target.isOpen = false;
		}
		/**
		 * 
		 * @param	id
		 * @param	level
		 */
		private function createSubItems(id,level:Number)
		{
			
			var childnodes:XMLList = xmlData..node.(@id == id).children();
			var index = 1;
			for each (var item:XML in childnodes)
			{
				createItem(item, nWidth * (level+1),level+1,index);
				index++;
				//trace(item.@label, item.@id);
			}
			currentLevel = level + 1;
			currentSub = id;
			aOpen.push(id);
			
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
			currentSub = -1;
			aOpen.pop();
		}
		
		
		/**
		 * 
		 * @param	array
		 * @param	removeValue
		 * @return
		 */
		function removeItems(array:Array, removeValue:Number):Array{
			var outputArray:Array = array.filter(function (item:*, index:int,array:Array):Boolean
			{
				return (item.sID != removeValue);
			});
			return outputArray;
		}
		/**
		 * 
		 * @param	id
		 */
		private function deleteItem(id)
		{
			for each(var menuitem in aItems)
			{
				if (menuitem.sID == id)
				{
					//trace("sid ", menuitem.sID, " = ", id);
					removeChild(menuitem);
				}
			}
		}
		
	}
	
}