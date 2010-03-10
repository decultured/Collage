package Collage.Clips.Label
{
	import Collage.Clip.*;
	
	public class LabelClip extends Clip
	{
		[Bindable]public var text:String = "Default Text";
		[Bindable]public var color:Number = 0x000000;
		[Bindable]public var backgroundAlpha:Number = 1.0;
		[Bindable]public var backgroundColor:Number = 0xFFFFFF;

		[Bindable]public var textWidth:Number = 200;
		[Bindable]public var textHeight:Number = 24;
		[Bindable]public var fontSize:Number = 18;

		public function LabelClip(dataObject:Object = null)
		{
			verticalSizable = false;
			horizontalSizable = false;
			rotatable = false;
			super(dataObject);
			CreateView(new LabelClipView());
			CreateEditor(new LabelClipEditor());
		}

		public override function Resized():void
		{
			width = textWidth;
			height = textHeight;
		}

		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "label";
			newObject["text"] = text;
			newObject["color"] = color;
			newObject["backgroundAlpha"] = backgroundAlpha;
			newObject["backgroundColor"] = backgroundColor;
			newObject["textWidth"] = textWidth;
			newObject["textHeight"] = textHeight;
			newObject["fontSize"] = fontSize;

			return newObject;
		}

		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;

			super.LoadFromObject(dataObject);
			for (var key:String in dataObject)
			{
				if (key == "text") {
					text = dataObject[key];
				} else if (key == "color") {
					color = parseInt(dataObject[key]);
				} else if (key == "backgroundAlpha") {
					backgroundAlpha = parseFloat(dataObject[key]);
				} else if (key == "backgroundColor") {
					backgroundColor = parseInt(dataObject[key]);
				} else if (key == "textWidth") {
					textWidth = parseInt(dataObject[key]);
				} else if (key == "textHeight") {
					textHeight = parseInt(dataObject[key]);
				} else if (key == "fontSize") {
					fontSize = parseFloat(dataObject[key]);
				}
			}
			return true;
		}

	}
}