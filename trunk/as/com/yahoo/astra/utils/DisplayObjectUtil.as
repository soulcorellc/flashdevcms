/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Utility functions for use with DisplayObjects.
	 * 
	 * @author Josh Tynjala
	 */
	public class DisplayObjectUtil
	{
		/**
		 * Converts a point from the local coordinate system of one DisplayObject to
		 * the local coordinate system of another DisplayObject.
		 *
		 * @param point					the point to convert
		 * @param firstDisplayObject	the original coordinate system
		 * @param secondDisplayObject	the new coordinate system
		 */
		public static function localToLocal(point:Point, firstDisplayObject:DisplayObject, secondDisplayObject:DisplayObject):Point
		{
			point = firstDisplayObject.localToGlobal(point);
			return secondDisplayObject.globalToLocal(point);
		}
		
		/**
		 * Using an input, such as a component style, tries to convert the input
		 * to a DisplayObject.
		 * 
		 * <p>Possible inputs include Class, a String representatation of a
		 * fully-qualified class name, Function, any existing instance of
		 * a DisplayObject, or InstanceFactory.</p>
		 * 
		 * @see com.yahoo.astra.utils.InstanceFactory
		 * 
		 * @param target	the parent of the new instance
		 * @param input		the object to convert to a DisplayObject instance
		 */
		public static function getDisplayObjectInstance(target:DisplayObject, input:Object):DisplayObject
		{
			if(input is InstanceFactory)
			{
				return InstanceFactory(input).createInstance() as DisplayObject;
			}
			//added Function as a special case because functions can be used with the new keyword
			else if(input is Class || input is Function)
			{ 
				return (new input()) as DisplayObject; 
			}
			else if(input is DisplayObject)
			{
				(input as DisplayObject).x = 0;
				(input as DisplayObject).y = 0;
				return input as DisplayObject;
			}

			var classDef:Object = null;
			try
			{
				classDef = flash.utils.getDefinitionByName(input.toString());
			}
			catch(e:Error)
			{
				try
				{
					classDef = target.loaderInfo.applicationDomain.getDefinition(input.toString()) as Object;
				}
				catch (e:Error)
				{
					// Nothing
				}
			}

			if(classDef == null)
			{
				return null;
			}
			return (new classDef()) as DisplayObject;
		}
	}
}