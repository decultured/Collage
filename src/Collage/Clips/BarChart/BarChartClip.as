package Collage.Clips.BarChart
{
	import Collage.Clip.*;
	
	public class BarChartClip extends Clip
	{		
		private var _BackgroundAlpha:Number = 1.0;
		private var _BackgroundColor:Number = 0xFFFFFF;

		[Bindable]
		public function get backgroundAlpha():Number {return _BackgroundAlpha;}
		public function set backgroundAlpha(bgAlpha:Number):void {_BackgroundAlpha = bgAlpha;}

		[Bindable]
		public function get backgroundColor():Number {return _BackgroundColor;}
		public function set backgroundColor(bgColor:Number):void {_BackgroundColor = bgColor;}

		public function BarChartClip(dataObject:Object = null)
		{
			super(dataObject);
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new BarChartClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new BarChartClipEditor();
				_Editor.model = this;
			}
		}

		public override function Resized():void
		{
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "barchart";
			newObject["backgroundAlpha"] = backgroundAlpha;
			newObject["backgroundColor"] = backgroundColor;

			return newObject;
		}
	}
}