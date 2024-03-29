/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls{
	
import com.yahoo.astra.fl.controls.menuClasses.MenuCellRenderer;
import com.yahoo.astra.fl.data.XMLDataProvider;
import com.yahoo.astra.fl.events.MenuEvent;
import com.yahoo.astra.fl.managers.PopUpManager;
import fl.controls.List;
import fl.controls.listClasses.CellRenderer;
import fl.controls.listClasses.ICellRenderer;
import fl.containers.BaseScrollPane;
import fl.core.InvalidationType;
import fl.data.DataProvider;
import fl.events.ListEvent;
import fl.transitions.*;
import fl.transitions.easing.*;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.*;
//--------------------------------------
//  Events
//--------------------------------------
/**
 * Dispatched when the user rolls the pointer over a row.
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.ITEM_ROLL_OVER
 *
 * @see #event:itemRollOut
 * 
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="itemRollOver", type="com.yahoo.astra.fl.events.MenuEvent")]	
/**
 * Dispatched when the user rolls the pointer off a row.
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.ITEM_ROLL_OUT
 *
 * @see #event:itemRollOver
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="itemRollOut", type="com.yahoo.astra.fl.events.MenuEvent")]
 
 /**
 * Dispatched when the user clicks an item in the menu. 
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.ITEM_CLICK
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="itemClick", type="com.yahoo.astra.fl.events.MenuEvent")]
/**
 * Dispatched when a different item is selected in the Menu.
 *
 * @eventType flash.events.Event.CHANGE
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="change", type="flash.events.Event")]
/**
 * Dispatched when a menu is shown
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.MENU_SHOW
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="menuShow", type="com.yahoo.astra.fl.events.MenuEvent")]
/**
 * Dispatched when a menu is hidden.
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.MENU_HIDE
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="menuHide", type="com.yahoo.astra.fl.events.MenuEvent")]

	//--------------------------------------
	//  Styles
	//--------------------------------------	
	
	/**
	 * The number of pixels between the left edge of the menu and the left edge of 
	 * the stage when the stage is too narrow to fit the menu. If the value were set 
	 * to 0, the left edge of the menu would be flush with the left edge of the stage. 
     *
     * @default 0
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="leftMargin", type="Number")]
	
	/**
	 * The number of pixels between the bottom of the menuBar and the top of the 
	 * menu when the stage is to short to fit the menu. If the value were set to 0, 
	 * the top of the menu would be flush with bottom edge of the menuBar. 
     *
     * @default 0
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="topMargin", type="Number")]	
	
	/**
	 * The number of pixels for a bottom gutter to a menu when the stage to short to 
	 * fit the menu. If the value were set to 0, the bottom of the menu would be 
	 * flush with the bottom edge of the stage. 
     *
     * @default 0
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="bottomMargin", type="Number")]	 

	/**
	 * The number of pixels between the right edge of the menu and the right edge of 
	 * the stage when the stage is too narrow to fit the menu. If the value were set 
	 * to 0, the right edge of the menu would be flush with the left edge of the 
	 * stage. 	
     *
     * @default 0
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="rightMargin", type="Number")]	 
	
	/**
	 * The number of pixels that each submenu will appear to right of its parent 
	 * menu. A negative value can be used to have the menus overlap. 
     *
     * @default -3
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="xOffset", type="Number")]		

	/**
	 * The number of pixels that each submenu will appear below the top of its parent 
	 * menu. A negative value can be used to have the menu appear above its parent 
	 * menu. 	
	 *
     * @default 3
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="yOffset", type="Number")]	

	
//--------------------------------------
//  Other metadata
//--------------------------------------
[IconFile("assets/Menu.png")]
 
//--------------------------------------
//  Class description
//--------------------------------------
/**
 *  The Menu class creates an array of menus from an XML data provider.
 *  Add the Menu to your library (either by dragging it onto the stage and then deleting it, or
 *  dragging it directly to your library). Then call the static <code>Menu.createMenu(parent)</code> 
 *  method to create a menu, and call <code>yourMenuInstance.show()</code> to display it.
 *
 *  @author Alaric Cole
 */
	 
public class Menu extends List {
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     *
     *  <p>Applications do not normally call the Menu constructor directly.
     *  Call the <code>Menu.createMenu()</code> method.</p>
	 *  @see #createMenu()
     */
	public function Menu() {
		super();
		
		//Make it initially invisible
		visible=false;
		
		tabEnabled=false;
		
		verticalScrollPolicy = horizontalScrollPolicy = "off";
		
		addEventListener(MenuEvent.ITEM_ROLL_OVER,itemRollOver);
		addEventListener(MenuEvent.ITEM_ROLL_OUT,itemRollOut);
	}
	
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	/**
	 * Indicates whether or not a menu item with a submenu is clickable.
	 */	
	public var parentMenuClickable:Boolean;
	
	/**
	 * Coordinates indicating the ideal position of the menu.  These are used to determine where 
	 * to position the menu when the stage is resized outward.
	 */
	public var specifiedPoint:Point;
	
	/**
	 * Object that contains arrays of groups.  Used when menu items toggle with each other.
	 */
	public var groups:Object;
	
	/**
	 * Indicates whether the menu will close when the mouse leaves the stage.
	 */
	public var closeOnMouseLeave:Boolean;
		
	/**
	 * @private
	 */	
	private var realParent:DisplayObjectContainer;
	
	// the anchor is the row in the parent menu that opened to be this menu
	// or the row in this menu that opened to be a submenu
	private var anchorRow:MenuCellRenderer;
	// reference to the ID of the last opened submenu within a menu level
	private var anchor:String;
	// reference to the rowIndex of a menu's anchor in the parent menu
	private var anchorIndex:int=-1;
	private var subMenu:Menu;
	/**
	 *  @private
	 *  When this timer fires, we'll open a submenu
	 */
	private var openSubMenuTimer:int=0;
	/**
	 *  @private
	 *  When this timer fires, we'll hide this menu
	 */
	private var closeTimer:int=0;
	
	/**
	 * @private
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	private static var defaultStyles:Object = {
												skin:"MenuSkin",
												cellRenderer:MenuCellRenderer,
												contentPadding:null,
												disabledAlpha:null,
												leftMargin:0,
												rightMargin:0,
												topMargin:0,
												bottomMargin:0,
												xOffset:0,
												yOffset:0												
												};
																							
	/**
	 * @private
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	public static function getStyleDefinition():Object { 
		return mergeStyles(defaultStyles, BaseScrollPane.getStyleDefinition());
	}
	/**
	 * @private
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	//private static var defaultStyles:Object = {backgroundSkin:"MenuSkin"}
	//--------------------------------------------------------------------------
	//  parentMenu
	//--------------------------------------------------------------------------
	/**
	 *  @private
	 */
	protected var _parentMenu:Menu;
	/**
	 *  The parent menu in a hierarchical chain of menus, where the current 
	 *  menu is a submenu of the parent.
	 * 
	 *  @return The parent Menu control. 
	 */
	public function get parentMenu():Menu {
		return _parentMenu;
	}
	/**
	 *  @private
	 */
	public function set parentMenu(value:Menu):void {
		_parentMenu=value;
	}
	
	/**
	 *  Get the current set of submenus for a Menu
	 * @return all submenus of this menu, if any
	 */
	public function get subMenus():Array {
		var arr:Array=[];
		for (var i:int=0; i < dataProvider.length; i++) {
			var d:Object=dataProvider.getItemAt(i);
			if (d) {
				var c:MenuCellRenderer=MenuCellRenderer(itemToCellRenderer(d));
				if (c) {
					var m:Menu=c.subMenu;
					//
					if (m) {
						arr.push(m);
					}
				}
			}
		}
		return arr;
	}
	
	  
   /**
	 *  @private
	 */
   protected var tween:Tween;
   
	//--------------------------------------------------------------------------
	// 
	// Overridden Properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
    //  labelField
    //----------------------------------
    [Inspectable(category="Data", defaultValue="label")]
    /**
     *  Name of the field in the items in the <code>dataProvider</code>
     *  Array to display as the label in the TextInput portion and drop-down list.
     *  By default, the control uses a property named <code>label</code>
     *  on each Array object and displays it.
     *  <p>However, if the <code>dataProvider</code> items do not contain
     *  a <code>label</code> property, you can set the <code>labelField</code>
     *  property to use a different property.</p>
     *
     */
    override public function get labelField():String
    {
        return _labelField;
    }
    /**
     *  @private
     */
    override public function set labelField(value:String):void
    {
        //support @ modifiers for XML converted to Object via XMLDataProvider
		if(value.indexOf("@") == 0) value = value.slice(1); 
        super.labelField = value;
    }
	//--------------------------------------------------------------------------
	//  dataProvider
	//--------------------------------------------------------------------------
[Collection(collectionClass="com.yahoo.astra.fl.data.XMLDataProvider", collectionItem="fl.data.SimpleCollectionItem", identifier="item")]
	/**
	 *  Gets or sets the data model of the list of items to be viewed. 
	 *  A data provider can be shared by multiple list-based components. 
	 *  Changes to the data provider are immediately available to all components that use it as a data source.
	 * 
	 *  To use XML data, you should set the dataProvider as type <code>XMLDataProvider</code>:
	 *  <code>menu.dataProvider = new XMLDataProvider(someXML);</code>
	 *
	 *  However, using the <code>createMenu()</code> method and passing in XML will do this for you.
	 *
	 *  @see com.yahoo.astra.fl.data.XMLDataProvider
	 *  @default null
	 */
	override public function  get dataProvider():DataProvider
	{
		return _dataProvider;
	}
	override public function set dataProvider(value:DataProvider):void {
			if((value is DataProvider && value.length == 0) || value is XMLDataProvider) 
			{
				_dataProvider = value;
				clearSelection();
                invalidateList();
			}
		else throw new TypeError("Error: Type Coercion failed: cannot convert " + value + " to com.yahoo.astra.fl.data.XMLDataProvider");
	}
	
	
	//--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    /**
     *  Creates and returns an instance of the Menu class. The Menu control's 
     *  content is determined by the method's <code>xmlDataProvider</code> argument. The 
     *  Menu control is placed in the parent container specified by the 
     *  method's <code>parent</code> argument.
     * 
     *  This method does not show the Menu control. Instead, 
     *  this method just creates the Menu control and allows for modifications
     *  to be made to the Menu instance before the Menu is shown. To show the 
     *  Menu, call the <code>Menu.show()</code> method.
     *
     *  @param parent A container that the PopUpManager uses to place the Menu 
     *  control in. The Menu control may not actually be parented by this object.
     * 
     *  @param xmlDataProvider The data provider for the Menu control. 
     *  @see #dataProvider 
     *  
     *  @return An instance of the Menu class. 
     *
     *  @see #popUpMenu()
	 *  @see com.yahoo.astra.fl.data.XMLDataProvider
     */		
	public static function createMenu(inParent:DisplayObjectContainer,xmlDataProvider:Object = null):Menu {
		var menu:Menu=new Menu;
		menu.realParent=inParent;
		
		//add to the stage as popup
		popUpMenu(menu,inParent,xmlDataProvider);
		return menu;
	}
	
    /**
     *  Sets the dataProvider of an existing Menu control and places the Menu 
     *  control in the specified parent container.
     *  
     *  This method does not show the Menu control; you must use the 
     *  <code>Menu.show()</code> method to display the Menu control. 
     * 
     *  The <code>Menu.createMenu()</code> method uses this method.
     *
     *  @param menu Menu control to popup. 
     * 
     *  @param parent A container that the PopUpManager uses to place the Menu 
     *  control in. The Menu control may not actually be parented by this object.
     *  If you omit this property, the method sets the Menu control's parent to 
     *  the stage. 
     * 
     *  @param xmlDataProvider dataProvider object set on the popped up Menu. If you omit this 
     *  property, the method sets the Menu data provider to a new, empty XML object.
     */
	public static function popUpMenu(menu:Menu,parent:DisplayObjectContainer,dp:Object = null):void {
		if (!dp) dp = new XML();
			
		menu.dataProvider = new XMLDataProvider(dp);
		menu.invalidateList();
	}
	/**
	 *  @private
	 *  Removes the root menu from the display list.  This is called only for
	 *  menus created using "createMenu".
	 * 
	 */
	private static function menuHideHandler(event:MenuEvent):void {
		var menu:Menu=Menu(event.target);
		if (! event.isDefaultPrevented() && event.menu == menu) {
			PopUpManager.removePopUp(menu);
			menu.removeEventListener(MenuEvent.MENU_HIDE,menuHideHandler);
		}
	}
	
	/**
	 *  @private
	 *  Removes the main menu and submenus from the stage.
	 * 
	 */	
	protected function hideAllMenus():void {
		getRootMenu().hide();
		getRootMenu().deleteDependentSubMenus();
	}
	
	/**
	 *  @private
	 *  Removes all menus and submenus from the stage.
	 * 
	 */
	protected function deleteDependentSubMenus():void {
		if (subMenus.length > 0) {
			var n:int=subMenus.length;
			for (var i:int=0; i < n; i++) {
				var m:Menu=subMenus[i]  as  Menu;
				m.deleteDependentSubMenus();
				//m.hide();
				//more responsive to make invisble rather than hide()
				m.visible=false;
			}
		}
	}
	/**
     *  Shows the Menu control. If the Menu control is not visible, this method 
     *  places the Menu in the upper-left corner of the stage, resizes the Menu control as needed, 
	 *  and makes it visible.
     * 
     *  The x and y arguments of the <code>show()</code> method specify the 
     *  coordinates of the upper-left corner of the Menu control relative to the 
     *  stage, which is not necessarily the direct parent of the Menu control. 
     * 
     *  For example, if the Menu control is in a container, the x and y coordinates are 
     *  relative to the stage, not the container.
     *
     *  @param x Horizontal location of the Menu control's upper-left 
     *  corner (optional).
     *  @param y Vertical location of the Menu control's upper-left 
     *  corner (optional).
     */
	public function show(xShow:Object=null,yShow:Object=null):void {
		//if this is a top level menu, set the point based off of xShow and yShow params)
		if(!parentMenu)
		{
			specifiedPoint = new Point(Number(xShow), Number(yShow));
		}

		//if empty, forget it
		if (dataProvider && dataProvider.length == 0) {
			return;
		}
		// If parent is closed, then don't show a submenu
		if (parentMenu && ! parentMenu.visible && parentMenu.selectedIndex < 0) {
			return;
		}
		// If already visible, why bother?
		//if (visible) {
			//return;
		//}
		//don't highlight anything
		selectedIndex= caretIndex = -1;
		
		//Pop up the menu
		if(!this.parent && realParent)
		{
			PopUpManager.addPopUp(this,realParent);
		}
		//if it's been added by dragging onto stage
		else
		{
			if(parent)
			{
				realParent = parent;
				parent.removeChild(this);
				PopUpManager.addPopUp(this,realParent);
			}
		}
		
		//resize the menu to its rows
		var maxW:int = 0;
		var totalHeights:int = 0;
		var n:int=dataProvider.length;
		
		//Must set row count before drawing, otherwise there will be a problem
		//with itemToCellRenderer not resolving the last item
		//this is due to the way recycling of item renderers is done, 
		//specifically the way 
		rowCount = n;
		drawNow();
		groups = {};
		//loop through all renderers
		for (var i:int=0; i < n; i++) {
			var item:Object = dataProvider.getItemAt(i);
			var c:MenuCellRenderer;
			var w:int;
			var h:int; 
			c=itemToCellRenderer(item) as  MenuCellRenderer;
			//build arrays containing member MenuCellRenderers for each group that is declared
			for(var j:String in item)
			{
				if(j == "group")
				{
					var key:String = item[j].toString();
					var isArray:Boolean = (groups[key] != null && groups[key] is Array)
					if(!isArray) groups[key] = [];
					groups[key].push(c);		
				}
			}			
			if(!c)
			{
				trace(item.label.toString() + " couldn't be coerced into a MenuCellRenderer")
			}
			
			w =  (c.width?c.width:10);
			h= c.height;
			
			totalHeights += h;
			if( w > maxW) 
			{
				maxW = w;
			}
			
		}
		
		//set the width of the menu to the largest width of the renderers
		width = (maxW < 10 ? 10: maxW);
		
		//height = totalHeights;
		
		//HACK: separator isn't resizing due to the row's width not being
		//set immediately, so we force all row widths to the Menu's width
		for (var t:int=0; t < n; t++) {
			var itm:Object = dataProvider.getItemAt(t);
			var r:MenuCellRenderer=itemToCellRenderer(itm)  as  MenuCellRenderer;
			if(!r)
			break;
			
			r.width = maxW;
			
			r.drawNow();
		}
		
		addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,-50);
		// Fire an event
		var menuEvent:MenuEvent=new MenuEvent(MenuEvent.MENU_SHOW);
		menuEvent.menu=this;
		//menuEvent.menuBar = sourceMenuBar;
		getRootMenu().dispatchEvent(menuEvent);
		// Activate the menu
		this.setFocus();
		// Position it
		if (xShow !== null && ! isNaN(Number(xShow))) {
			x=Number(xShow);
		}
		if (yShow !== null && ! isNaN(Number(yShow))) {
			y=Number(yShow);
		}

		// Make it visible
		visible=true;
		
		//disabled items aren't rendering properly with addtostage feature
		
		drawNow();

		var pt:Point = new Point(x, y);
		pt = realParent.localToGlobal(pt);
		if(pt.x + width > this.stage.stageWidth - Number(getStyleValue("rightMargin"))) x = realParent.globalToLocal(new Point(Math.max(this.stage.stageWidth - width - Number(getStyleValue("rightMargin")), Number(getStyleValue("leftMargin"))),0)).x;
		if(pt.y + height > this.stage.stageHeight) y = realParent.globalToLocal(new Point(0, Math.max(this.stage.stageHeight - height - Number(getStyleValue("bottomMargin")), realParent.y + realParent.height + Number(getStyleValue("topMargin"))))).y;
		// If the user clicks outside the menu, then hide the menu
		stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler,false,0,true);
		stage.addEventListener(Event.RESIZE, stageResizeHandler,false,0,true);
		if(closeOnMouseLeave) stage.addEventListener(Event.MOUSE_LEAVE, mouseOutsideApplicationHandler,false,0,true);
	}


	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	
	/**
	*  @private
	*  Set up keyboard navigation specific to the Menu
	*/
	override protected function keyDownHandler(event:KeyboardEvent):void {
		//Override the List key down function entirely because it stops propagation of the keyboard event.  The event needs to bubble up to the parent.
		var row:MenuCellRenderer=selectedIndex < 0 ? null : itemToCellRenderer(dataProvider.getItemAt(selectedIndex))  as  MenuCellRenderer;
		var rowData:Object=row?row.data.data:null;
		var mnu:Menu=row?MenuCellRenderer(row).menu:null;
		if (!selectable) { return; }
		switch (event.keyCode) {
			case Keyboard.UP:
			case Keyboard.DOWN:
			case Keyboard.END:
			case Keyboard.HOME:
			case Keyboard.PAGE_UP:
			case Keyboard.PAGE_DOWN:
				moveSelectionVertically(event.keyCode, event.shiftKey && _allowMultipleSelection, event.ctrlKey && _allowMultipleSelection);
				break;
			case Keyboard.LEFT:
				if (parentMenu) {
					//parentMenu.selectedIndex = 
					parentMenu.selectedIndex=anchorIndex;//?anchorIndex:-1;
					parentMenu.setFocus();
					hide();
					event.stopPropagation();
				}			
				break;			
			case Keyboard.RIGHT:
				if (row) {
					if (rowData) {
						//if the row has its own data (taken from XML and thrown into an object)
						var m2:Menu=openSubMenu(row);
						m2.selectedIndex=0;
						event.stopPropagation();
					}

				}	
				break;			
			case Keyboard.SPACE:
				if (row) {
					if (rowData) 
					{
						//if the row has its own data (taken from XML and thrown into an object)
						var m:Menu=openSubMenu(row);
						m.selectedIndex = 0;
					} 
					else
					{
						row.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
					
				}				
				break;
			case Keyboard.ENTER:
				if(row)
				{
					row.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				break;
			case Keyboard.ESCAPE :
				hideAllMenus();
				break;				
			default:
				var nextIndex:int = getNextIndexAtLetter(String.fromCharCode(event.keyCode), selectedIndex);
				if (nextIndex > -1) {
					selectedIndex = nextIndex;
					scrollToSelected();
				}
				break;
		}		
	}
	
	/**
	 * @private (protected)
	 * Moves the selection in a vertical direction in response
	 * to the user selecting items using the up-arrow or down-arrow
	 *
	 * @param code The key that was pressed (e.g. Keyboard.DOWN)
	 *
	 * @param shiftKey <code>true</code> if the shift key was held down 
	 *
	 * @param ctrlKey <code>true</code> if the ctrl key was held down 
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	override protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean):void {
		var pageSize:int = Math.max(Math.floor(calculateAvailableHeight() / rowHeight), 1);
		var newCaretIndex:int = -1;
		var dir:int = 0;
		switch (code) {
			case Keyboard.UP :
				if (caretIndex > 0) {
					newCaretIndex = caretIndex - 1;
				}
				else
				{
					newCaretIndex = length - 1;
				}
				break;
			case Keyboard.DOWN :
				if (caretIndex < length - 1) {
					newCaretIndex = caretIndex + 1;
				}
				else
				{
					newCaretIndex = 0;
				}
				break;
			case Keyboard.PAGE_UP :
				if (caretIndex > 0) {
					newCaretIndex = Math.max(caretIndex - pageSize, 0);
				}
				break;
			case Keyboard.PAGE_DOWN :
				if (caretIndex < length - 1) {
					newCaretIndex = Math.min(caretIndex + pageSize, length - 1);
				}
				break;
			case Keyboard.HOME :
				if (caretIndex > 0) {
					newCaretIndex = 0;
				}
				break;
			case Keyboard.END :
				if (caretIndex < length - 1) {
					newCaretIndex = length - 1;
				}
				break;
		}
		if (newCaretIndex >= 0) {
			//set selected to false for the previously selected row
			if(caretIndex > -1 && !isNaN(caretIndex))
			{
				var oldRow:MenuCellRenderer = itemToCellRenderer(dataProvider.getItemAt(caretIndex)) as MenuCellRenderer;
				oldRow.selected = false;
			}
			
			var item:Object = dataProvider.getItemAt(newCaretIndex);
			var row:MenuCellRenderer=itemToCellRenderer(item)  as  MenuCellRenderer;
			
			doKeySelection(newCaretIndex, shiftKey, ctrlKey);
			scrollToSelected();
			if(!row.enabled) moveSelectionVertically(code, shiftKey, ctrlKey);
		}
		
	}
	
	/**
	 *  @private
	 *  Recreates ListEvents as MenuEvents 
	 */
	override public function dispatchEvent(event:Event):Boolean {
		if (!(event is MenuEvent) && event is ListEvent && 
					(event.type == ListEvent.ITEM_ROLL_OUT ||
					event.type == ListEvent.ITEM_ROLL_OVER) ) {
			// we don't want to dispatch ListEvent.ITEM_ROLL_OVER or
			// ListEvent.ITEM_ROLL_OUT or ListEvent.CHANGE events 
			// because Menu dispatches its own 
			event.stopImmediatePropagation();
			//add index parameter to menu event
			var meV:MenuEvent = new MenuEvent(event.type, event.bubbles,event.cancelable, null, this, ListEvent(event).item, null, itemToLabel(ListEvent(event).item), ListEvent(event).index);
			return super.dispatchEvent(meV);
		}
		// in case we encounter a ListEvent.ITEM_CLICK from 
		// a superclass that we did not account for, 
		// lets convert the ListEvent and pass it on up to 
		// avoid an RTE
		if (!(event is MenuEvent) && event is ListEvent && 
					(event.type == ListEvent.ITEM_CLICK)) {
			event.stopImmediatePropagation();
			//add index parameter to menu event
			var me:MenuEvent = new MenuEvent(event.type, event.bubbles, event.cancelable, null, this, ListEvent(event).item, null, itemToLabel(ListEvent(event).item), ListEvent(event).index);
			return super.dispatchEvent(me);
		}
		// we'll let everything else go through
		return super.dispatchEvent(event);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
 
	/**
	 *  Hides the Menu control and any of its submenus if visible
	 */
	public function hide(useTween:Boolean = true):void {
		stage.removeEventListener(Event.RESIZE, stageResizeHandler);
		if(closeOnMouseLeave) stage.removeEventListener(Event.MOUSE_LEAVE, mouseOutsideApplicationHandler);
	
		// Stop any tween that's running
		if (tween)
			tween.stop();		

		//if there are submenus, delete them
		if(subMenus.length > 0) deleteDependentSubMenus();

		if(useTween)
		{
			if (visible) {
				var duration:Number = getStyle("openDuration") as Number;
				if (!duration) {
					duration = .125;
				}

				//Hack to get certain transitions to work on device fonts; thanks, Scott!
				if (filters.length < 1) {
					//if no one has put any filters, we do so
					//this causes it to be cached as a bitmap 
					//and allows transparency on device fonts
					var filter:BlurFilter=new BlurFilter(0,0,1);
					var fltrs:Array = [filter];
					filters = fltrs;
				}


				tween=new Tween(this,'alpha',Regular.easeOut,1,0, duration,true);
				tween.addEventListener(TweenEvent.MOTION_FINISH,onTweenEnd);
			}		
		}
		else
		{
			alpha = 1;
			visible = false;
			// Now that the menu is no longer visible, it doesn't need
			// to listen to mouseDown events anymore.
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler);			
			// Fire an event
			var menEvent:MenuEvent=new MenuEvent(MenuEvent.MENU_HIDE);
			menEvent.menu=this;
			dispatchEvent(menEvent);				
		}	
	}
    /**
     *  @private
	 *  Creates a submenu for this menu
     */
	protected function openSubMenu(row:MenuCellRenderer):Menu {
		var rootMenu:Menu=getRootMenu();
		var mnu:Menu;

		// check to see if the menu exists, if not create it
		if (! MenuCellRenderer(row).menu) {
			mnu=Menu.createMenu(rootMenu,row.data.data);
			mnu.parentMenuClickable = rootMenu.parentMenuClickable;
			mnu.setStyle("xOffset", Number(rootMenu.getStyleValue("xOffset")));
			mnu.setStyle("yOffset", Number(rootMenu.getStyleValue("yOffset")));
			mnu.visible=false;
			mnu.parentMenu=this;
			//mnu.showRoot = showRoot;
			mnu.labelField=rootMenu.labelField;
			mnu.labelFunction=rootMenu.labelFunction;
			mnu.iconField=rootMenu.iconField;
			mnu.iconFunction=rootMenu.iconFunction;
			mnu.rowHeight=rootMenu.rowHeight;
			mnu.setStyle("leftMargin", Number(getStyleValue("leftMargin")));
			mnu.setStyle("topMargin", Number(getStyleValue("topMargin")));
			mnu.setStyle("rightMargin", Number(getStyleValue("rightMargin")));
			mnu.setStyle("bottomMargin", Number(getStyleValue("bottomMargin")));
			mnu.anchorRow=row;
			mnu.anchorIndex=row.listData.index;
			selectedIndex = row.listData.index;
			row.subMenu=mnu;
			//setting scales causes a redraw loop
			//mnu.scaleY = rootMenu.scaleY;
			//mnu.scaleX = rootMenu.scaleX;
			mnu.realParent=this.realParent;
			// mnu.sourceMenuBar = sourceMenuBar;
		} else {
			mnu=MenuCellRenderer(row).menu;
		}
		
		//not sure if this is necessary.  If you base the coordinates off of the parent menu, it will not matter.
		var r:DisplayObject=DisplayObject(row);
		var pt:Point=new Point(0,0);
		pt = r.localToGlobal(pt);
		// if this is loaded from another swf, global coordinates could be wrong
		if (r.root) {
			pt=r.root.globalToLocal(pt);
		}
		
		mnu.specifiedPoint = new Point(specifiedPoint.x + width + Number(getStyleValue("xOffset")), specifiedPoint.y + row.y + Number(getStyleValue("yOffset")));
		mnu.show(mnu.specifiedPoint.x, mnu.specifiedPoint.y);
		//hack for resetting caretIndex (used by moveSelectionVertically)
		//caretIndex isn't being updated to synchronize with selectedIndex, so 
		//you'd have to press the down key twice to get the selection to move
		mnu.caretIndex = 0;
		
		return mnu;
	}
	/**
	 *  @private
	 */
	private function closeSubMenu(menu:Menu):void {
		menu.hide();
		menu.closeTimer=0;
	}
	
	/**
	 *  @private
	 *  Sets everything back to normal when the hidden Menu's fade ends
	 */
	protected function onTweenEnd(event:TweenEvent):void {
		//set the menu back to normal, and off the display list
			var m:Menu = event.currentTarget.obj as Menu;
			m.visible=false;
			// Now that the menu is no longer visible, it doesn't need
			// to listen to mouseDown events anymore.
			trace("antes stage");
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler);
			trace("despues stage");
			m.alpha=1;
			// Fire an event
			//could be fired earlier, but it messes with the tween
			var menEvent:MenuEvent=new MenuEvent(MenuEvent.MENU_HIDE);
			menEvent.menu=m;
			//menuEvent.menuBar = sourceMenuBar;
			dispatchEvent(menEvent);
		
		
		
	}
	
	/**
	 * @private
	 * From any menu, walks up the parent menu chain and finds the root menu.
	 */
	protected function getRootMenu():Menu {
		var target:Menu=this;
		while (target.parentMenu) {
			target = target.parentMenu;
		}
		return target;
	}
	/**
	 *  @private
	 *  Checks to see if a mouse event was fired from a Menu
	 */
	private function isMouseOverMenu(event:MouseEvent):Boolean {
		var target:DisplayObject = DisplayObject(event.target);
		while (target) {
			//include the parent as target so that clicking on the menubar does not call hide all menus
			if (target is Menu || target == realParent) {
				return true;
			}
			target = target.parent;
		}
		return false;
	}
	
	// -------------------------------------------------------------------------
	// Event Handlers
	// -------------------------------------------------------------------------
	
	/**
	 * @private (protected)
	 * Does Menu-specific item clicks
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	override protected function handleCellRendererClick(event:MouseEvent):void {
		var renderer:MenuCellRenderer = event.currentTarget as MenuCellRenderer;
		var itemIndex:uint = renderer.listData.index;
		
		if(parentMenuClickable || !renderer.data.data)
		{
		
			if (!getRootMenu().dispatchEvent(new MenuEvent(MenuEvent.ITEM_CLICK,false,true,null,
			   renderer.menu,renderer.data, renderer,itemToLabel(renderer.data) ,itemIndex)) || !_selectable) {
				return;
			}
			var selectIndex:int = selectedIndices.indexOf(itemIndex);
			var i:int;

			renderer.selected = true;
			_selectedIndices = [itemIndex];
			lastCaretIndex = caretIndex = itemIndex;
			var item:Object = renderer.data;

			var hasSelectableIcon:Boolean = item.hasOwnProperty("selectedIcon") || (item.hasOwnProperty("type") && (item.type.toLowerCase() == "check" || item.type.toLowerCase() == "radio"))
			if(hasSelectableIcon)
			{	
				if(item.hasOwnProperty("group"))
				{
					var groupArr:Array = groups[item.group] as Array;
					var groupLen:int = groupArr.length;
					
					for(var j:int = 0; j < groupLen;j++)
					{
						var mcr:MenuCellRenderer = groupArr[j] as MenuCellRenderer;
						if(mcr != renderer)
							mcr.data.selected = "false";	
					}	
				}
				renderer.data.selected = !renderer.data.selected;
				
				invalidate();				
			}
			hideAllMenus();
			//dispatchEvent(new Event(Event.CHANGE));
			invalidate(InvalidationType.DATA);
		}
	}
	
	/**
	 *  @private
	 */
	private function mouseDownOutsideHandler(event:MouseEvent):void {
		if (!isMouseOverMenu(event) )
			hide();
		}
	/**
	 *  @private
	 *  Extend the behavior from SelectableList to pop up submenus
	 */
	protected function itemRollOver(event:MenuEvent):void {
		deleteDependentSubMenus();
		var row:MenuCellRenderer=itemToCellRenderer(event.item)  as  MenuCellRenderer;
		//set the selected index to the index of the row that fired the event (previously set to -1)
		selectedIndex = caretIndex = event.index;
		if (row.data.data) {
			//if the row has its own data (taken from XML and thrown into an object)
			// If the menu is not visible, pop it up after a short delay
			if (!row.subMenu || !row.subMenu.visible)
			{
				if (openSubMenuTimer)
					clearInterval(openSubMenuTimer);
 
				openSubMenuTimer = setTimeout(
					function(row:MenuCellRenderer):void
					{
						//add check so the submenu is only opened when the mouse is over the row
						if(mouseX > 0 && mouseX < row.x + row.width && mouseY > 0 && mouseY < row.y + row.height && visible)
							openSubMenu(row);	
					},
					175,
					row);
			}
		}
	}
	/**
	 *  @private
	 *  Make submenu disappear when another item is hovered
	 */
	protected function itemRollOut(event:MenuEvent):void {
		var row:MenuCellRenderer=itemToCellRenderer(event.item)  as  MenuCellRenderer;
		//only reset if there is no visible subMenu and the selectedIndex is the same as the index of the row that fired the event
		if ((!row.subMenu || !row.subMenu.visible) && event.index == selectedIndex) {
			selectedIndex=-1;
		}
	}
	
	/**
	* @private
	* <p>stageResizeHandler</p>
	* <p>Adjusts menu postion, if necessary, when the stage resizes</p>
	* <p>Will adjust menu position to keep in view when the stage size decreases</p>
	* <p>Will adjust menu position towards its specified x and y coordinates when the stage size increases</p>
	*/
	protected function stageResizeHandler(event:Event):void
	{
		if(!isNaN(this.stage.stageWidth) && !isNaN(this.stage.stageHeight) && specifiedPoint != null)
		{
			if(visible && !isNaN(width) && !isNaN(specifiedPoint.x) && !isNaN(specifiedPoint.y) && !isNaN(height))
			{
				var pt:Point = new Point(x, y);
				pt = realParent.localToGlobal(pt);
				var specifiedPt:Point = realParent.localToGlobal(specifiedPoint);
				if(pt.x + width > this.stage.stageWidth - Number(getStyleValue("rightMargin")))
				{
					x = realParent.globalToLocal(new Point(Math.max(this.stage.stageWidth - width - Number(getStyleValue("rightMargin")), Number(getStyleValue("leftMargin"))),0)).x;
				}
				else if(pt.x < specifiedPt.x) 
				{
					x = Math.min(realParent.globalToLocal(new Point(this.stage.stageWidth - width - Number(getStyleValue("rightMargin")), 0)).x, specifiedPoint.x);
				}
				if(pt.y + height > this.stage.stageHeight - Number(getStyleValue("bottomMargin"))) 	
				{
					y = Math.max(this.stage.stageHeight - height - Number(getStyleValue("bottomMargin")), getRootMenu().specifiedPoint.y + Number(getStyleValue("topMargin"))); 
				}
				else if(pt.y < specifiedPt.y)
				{
					y = Math.min(realParent.globalToLocal(new Point(0, this.stage.stageHeight - height - Number(getStyleValue("bottomMargin")))).y, specifiedPoint.y);
				}	
			}
		}
	}
	
	/**
	* @private (protected)
	* hide menus if the mouse moves off of the stage
	*/
	protected function mouseOutsideApplicationHandler(event:Event):void
	{
		hide();
	}
	
}
}