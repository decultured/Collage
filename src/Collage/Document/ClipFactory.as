package Collage.Document
{
	import flash.display.BitmapData;
	import Collage.Clip.*;
	import Collage.Clips.Label.*;
	import Collage.Clips.LineChart.*;
	import Collage.Clips.PieChart.*;
	import Collage.Clips.BarChart.*;
	import Collage.Clips.Guage.*;
	import Collage.Clips.Picture.*;
	import Collage.Clips.TextBox.*;
	import Collage.Clips.Table.*;
	import Collage.Clips.DataLabel.*;
	
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
			_ClipTypes["piechart"] = PieChartClip;
			_ClipTypes["barchart"] = BarChartClip;
			_ClipTypes["guage"] = GuageClip;
			_ClipTypes["table"] = TableClip;
			_ClipTypes["datalabel"] = DataLabelClip;
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
			else if (clipType == "piechart")
				return new PieChartClip();
			else if (clipType == "barchart")
				return new BarChartClip();
			else if (clipType == "guage")
				return new GuageClip();
			else if (clipType == "table")
				return new TableClip();
			else if (clipType == "datalabel")
				return new DataLabelClip();
			return null;
		}
		
		public static function CreateFromData(data:Object):Clip
		{
			var newClip:Clip = null;
			if (data is BitmapData)	{
				newClip = CreateByType("image");
				newClip.LoadFromData(data);
				return newClip;
			} else if (data is String) {
				newClip = CreateByType("textbox");
				newClip.LoadFromData(data);
				return newClip;
			}
			
			return newClip;
		}
		
		public static function CreateFromXML(description:XML):Clip
		{
//			if (_ClipTypes[clipTypes])
//				return new _ClipTypes[clipTypes];
			return null;
		}
	}
}