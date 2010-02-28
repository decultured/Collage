package Collage.Clips.PieChart
{
	import Collage.Clip.*;
	
	public class PieChartClip extends Clip
	{		
		private var _BackgroundAlpha:Number = 1.0;
		private var _BackgroundColor:Number = 0xFFFFFF;

		[Bindable]
		public function get backgroundAlpha():Number {return _BackgroundAlpha;}
		public function set backgroundAlpha(bgAlpha:Number):void {_BackgroundAlpha = bgAlpha;}

		[Bindable]
		public function get backgroundColor():Number {return _BackgroundColor;}
		public function set backgroundColor(bgColor:Number):void {_BackgroundColor = bgColor;}

		public function PieChartClip()
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
				_View = new PieChartClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new PieChartClipEditor();
				_Editor.model = this;
			}
		}

		public override function Resized():void
		{
			if (!height)
				return;
				
			var modelRatio:Number = width / height;
		
			if (modelRatio > 1.3068) {
				width = height * 1.3068;
			} else if (modelRatio < 1.3068) {
				height = width / 1.3068;
			}
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "piechart";
			newObject["backgroundAlpha"] = backgroundAlpha;
			newObject["backgroundColor"] = backgroundColor;

			return newObject;
		}
	}
}