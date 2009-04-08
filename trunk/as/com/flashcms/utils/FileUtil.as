package com.flashcms.utils 
{
	
	/**
	 * ...
	 * @author David Barrios
	 */
	public class FileUtil
	{
		
		public function FileUtil() 
		{
			
		}
		
		public static function getFileType(extension:String)
		{
			switch(extension.toLowerCase())
			{
				case ".jpg":
				case ".jpeg":
				case ".gif":
				case ".png":
				case ".swf":
					return "images";
				break;
				case ".flv":
				return "videos";
			}
		}
		
	}
	
}