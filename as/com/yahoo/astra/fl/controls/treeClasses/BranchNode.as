/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.treeClasses {
//--------------------------------------
//  Class description
//--------------------------------------

/**
 *  The BranchNode is a base class for a node that can contain 
 *  other nodes as children. BranchNode class provides the logic
 *  for hierarchical linking of the nodes, and functionality for
 *  opening and closing nodes.
 *
 *  @author Allen Rabinovich
 *
 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
 *  @see com.yahoo.astra.fl.controls.treeClasses.TNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.LeafNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.RootNode
 */
	public dynamic class BranchNode extends TNode {
	/**
	 * @private
	 * The array of child nodes of this BranchNode.
	 */
		protected var _children:Array;
	
	/**
	 * @private
	 * The boolean holding the current state of the node:
	 * <code>true</code> if the node is open; <code>false</code> otherwise.
	 */
		protected var state:Boolean;

	/**
	 * @private
	 * The string representing the type of the node.
	 */
		protected var _nodeType:String;
		
	/**
	 * @private
	 * The string representing the state of the node.
	 */
		protected var _nodeState:String;

    /**
     *  Constructor.
     *
	 * @param pDP The data provider that will contain this node.
	 */
		public function BranchNode (pDP:TreeDataProvider) {
			super(pDP);
			_nodeType = TreeDataProvider.BRANCH_NODE;
			_nodeState = TreeDataProvider.CLOSED_NODE;
			_children = [];
			state = false;
		}

	/**
	 * The type of the node.
	 * For BranchNode, this value is constant
	 * and equal to <code>TreeDataProvider.BRANCH_NODE.
	 */
		public function get nodeType () : String {
			return _nodeType;
		}

	/**
	 * The state of the node. Depending on whether
	 * the node is currently open or closed, the state
	 * can be equal to <code>TreeDataProvider.OPEN_NODE</code>
	 * or <code>TreeDataProvider.CLOSED_NODE</code>.
	 */
		public function get nodeState () : String {
			return _nodeState;
		}
		
	/**
	 * Checks whether the node is currently open or closed.
	 *
	 * @return true if the node is open; false otherwise.
	 */
		public function isOpen () : Boolean {
			return state;
		}

	/**
	 * Finds the visible size of the node (i.e. the number of
	 * visible child nodes plus one).
	 *
	 * @return number of visible child nodes plus one.
	 */
		public function getVisibleSize () : int {
			var total:int = 0;
			
			if (!(this.isVisible())) {
				return 0;
			}
								
			if (!(this.isOpen())) {
				return 1;
			}
			
			for each (var child:TNode in _children) {
				if (child is LeafNode || !(child.isOpen())) {
					total += 1;
				}
				else if (child is BranchNode && child.isOpen()) {
					total += 1 + child.getVisibleSize ();
				}
			}
			
			return total + 1;
		}
		
	/**
	 * Draws the node by adding it to the Tree's dataProvider.
	 * Will only draw the node if all of its parents are open
	 * and if the node hasn't already been drawn.
	 *
	 */
		override public function drawNode () : void {
			// Only draw the node if it's not already drawn and it's open
			if (_parentDataProvider.getItemIndex(this) == -1 && isVisible()) {
				var myIndex:int = _parentNode.children.indexOf(this);
				var actualIndex:int = 0;
				for (var i:int = 0; i < myIndex; i++) {
					actualIndex += _parentNode.children[i].getVisibleSize();
				}
				// If the node is at the top level, add it directly to the DataProvider at the right location
				if (_parentNode is RootNode) {
					if (_parentDataProvider.length > 0) {
						_parentDataProvider.addItemAt(this, actualIndex);
					}
					else {
						_parentDataProvider.addItem(this);
					}
				}
				// If the node is nested, add it below the parent node with the correct offset
				else {
					var parentIndex:int = _parentDataProvider.getItemIndex(_parentNode);
					_parentDataProvider.addItemAt(this, parentIndex + actualIndex + 1);
				}
				// If the node itself is open, also draw the children
				if (isOpen()) {
					for each (var child:TNode in _children) {
						child.drawNode();
					}
				}
			}
		}

	/**
	 * Hides the node by removing it from the dataProvider.
	 * Only hides the node if one of its parents is closed.
	 *
	 */		
		override public function hideNode () : void {
				// Only hide the node if it's not already hidden and is closed
				if (_parentDataProvider.getItemIndex(this) != -1 && !isVisible()) {
					_parentDataProvider.removeItem(this);
				// If the node has children, make sure they are all removed as well
					for each (var child:TNode in _children) {
						child.hideNode();
					}
				}
		}
		
	/**
	 * Closes the current node if it was previously open.
	 *
	 */		
		public function closeNode () : void {
			this.state = false;
			this._nodeState = TreeDataProvider.CLOSED_NODE;
			for each (var child:TNode in _children) {
				child.hideNode();
			}
		}
		
	/**
	 * Opens the current node if it was previously closed.
	 *
	 */		
		public function openNode () : void {
			this.state = true;
			this._nodeState = TreeDataProvider.OPEN_NODE;
			for each (var child:TNode in _children) {
				child.drawNode();
			}
		}

	/**
	 * Checks whether the node or one of its children contains
	 * a field specified by <code>fieldName</code> that holds
	 * the </code>value</code>.
	 *
	 * @return The node where the field/value pair was found; null if
	 * the node was not found.
	 *
	 */	
		public function checkForValue (fieldName:String, value:String) : TNode {
			if (this[fieldName] == value) {
				return (this as TNode);
			}
			else {
				for each (var child:TNode in _children) {
					var foundNode:TNode = child.checkForValue(fieldName, value);
					if (foundNode != null) {
						return foundNode;
					}
				}
				return null;
			}
		}

	/**
	 * Opens the node and all of its children if they
	 * are branch nodes.
	 *
	 */	
		public function openAllChildren () : void {
			this.openNode();
			for each (var child:TNode in _children) {
				if (child is BranchNode) {
					child.openAllChildren();
				}
			}
		}

	/**
	 * Closes this node and all of its children if they
	 * are branch nodes.
	 *
	 */	
		public function closeAllChildren () : void {
			this.closeNode();
			for each (var child:TNode in _children) {
				if (child is BranchNode) {
					child.closeAllChildren();
				}
			}
		}
		
	/**
	 * A read-only array of the node's children.
	 * Use <code>addChildNodeAt</code> or <code>addChildNode</code>
	 * to add node children.
	 *
	 */
		public function get children () : Array {
			return _children;
		}

	/**
	 * Adds a child node at a particular index in the array
	 * of children of the current node. If the current node is
	 * open, the new child node is also made visible.
	 *
	 * @param childNode The node to be added as a child
	 * @param index The position in the <code>children</code> array where
	 * the child node is inserted.
	 *
	 */
		public function addChildNodeAt (childNode:TNode, index:int) : void {
				_children.splice(index, 0, childNode);
				childNode.parentNode = this;
				childNode.nodeLevel = this.nodeLevel + 1;
			if (isOpen() && isVisible()) {
				childNode.drawNode();
			}
		}

	/**
	 * Pushes a new child node onto the array of children of the
	 * current node. If the current node is
	 * open, the new child node is also made visible.
	 *
	 * @param childNode The node to be added as a child.
	 *
	 */
		public function addChildNode (childNode:TNode) : void {
			addChildNodeAt(childNode, _children.length);
		}
		
	/**
	 *
	 * Completely removes a specified child node from the tree.
	 * 
	 * @param child The node to be removed.
	 *
	 * @return The node that has been removed.
	 *
	 */		
		public function removeChild (child:TNode) : TNode {
			var childindex:int = _children.indexOf(child);
			if (childindex >= 0) {
				child.hideNode();
				_children.splice(childindex, 1);
				return child;
			}
			return null;
		}
	}
}