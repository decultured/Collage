package Collage
{
	import Collage.Clip.*;
	import Clips.Label.*;
	import Clips.LineChart.*;
	import Clips.Picture.*;
	import Clips.TextBox.*;
	
	public class ClipFactory
	{
		public static var _ClipTypes:Object = new Object();
		public static var _ClipFileExtentions:Object = new Object();
		public static var _ClipDataBindings:Object = new Object();

		public static function RegisterClipDefinitions():void
		{
			
		}

		public static function CreateByType(clipType:String):Clip
		{
			var newSnippet:Snippet;
			return newSnippet;
		}
		
		public static function CreateFromObject(data:Object):Clip
		{
			var newSnippet:Snippet;
			return newSnippet;
		}

		public static function CreateFromFile(file:File):Clip
		{
			var newSnippet:Snippet;
			return newSnippet;
		}

		public static function CreateFromXML(description:XML):Clip
		{
			var newSnippet:Snippet;
			return newSnippet;
		}
		
	}
}