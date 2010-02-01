package Collage.Document
{
	import Collage.Clip.*;
	import Collage.Clips.Label.*;
	import Collage.Clips.LineChart.*;
	import Collage.Clips.Picture.*;
	import Collage.Clips.TextBox.*;
	
	public class ClipFactory
	{
		public static var _ClipTypes:Object = new Object();
		public static var _ClipFileExtentions:Object = new Object();
		public static var _ClipDataBindings:Object = new Object();

		public static function RegisterClipDefinitions():void
		{
			_ClipTypes["image"] = PictureClip;
			_ClipTypes["label"] = LabelClip;
			_ClipTypes["textbox"] = TextBoxClip;
			_ClipTypes["linechart"] = LineChartClip;
		}

		public static function CreateByType(clipType:String):Clip
		{
			if (clipType == "image")
				return new PictureClip();
			else if (clipType == "label")
				return new LabelClip();
			else if (clipType == "textbox")
				return new TextBoxClip();
			else if (clipType == "linechart")
				return new LineChartClip();
			return null;
		}
		
		public static function CreateFromXML(description:XML):Clip
		{
//			if (_ClipTypes[clipTypes])
//				return new _ClipTypes[clipTypes];
			return null;
		}
	}
}