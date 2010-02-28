package Collage.Clips.Guage
{
	import Collage.Clip.*;
	
	public class GuageClip extends Clip
	{
		[Bindable]public var value:Number = 75;
		[Bindable]public var minimum:Number = 0;
		[Bindable]public var maximum:Number = 100;
		[Bindable]public var backgroundColor:Number = 0x327bc2;
		[Bindable]public var bezelColor:Number = 0xAAAAAA;
		[Bindable]public var measureMarksColor:Number = 0xFFFFFF;
		[Bindable]public var measureMarksAlpha:Number = 1;
		[Bindable]public var startAngle:Number = 45;
		[Bindable]public var endAngle:Number = 315;
		[Bindable]public var indicatorColor:Number = 0xFC5976;
		[Bindable]public var indicatorCrownColor:Number = 0xAAAAAA;
		
		public function GuageClip()
		{
			super();
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new GuageClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new GuageClipEditor();
				_Editor.model = this;
			}
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "guage";
			newObject["value"] = value;
			newObject["minimum"] = minimum;
			newObject["maximum"] = maximum;
			newObject["backgroundColor"] = backgroundColor;
			newObject["bezelColor"] = bezelColor;
			newObject["measureMarksColor"] = measureMarksColor;
			newObject["measureMarksAlpha"] = measureMarksAlpha;
			newObject["startAngle"] = startAngle;
			newObject["endAngle"] = endAngle;
			newObject["indicatorColor"] = indicatorColor;
			newObject["indicatorCrownColor"] = indicatorCrownColor;

			return newObject;
		}
	}
}