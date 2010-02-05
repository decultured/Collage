package Collage.Clips.LineChart
{
	import Collage.Clip.*;
	
	public class LineChartClip extends Clip
	{		
		private var _BackgroundAlpha:Number = 1.0;
		private var _BackgroundColor:Number = 0xFFFFFF;

		[Bindable]
		public function get backgroundAlpha():Number {return _BackgroundAlpha;}
		public function set backgroundAlpha(bgAlpha:Number):void {_BackgroundAlpha = bgAlpha;}

		[Bindable]
		public function get backgroundColor():Number {return _BackgroundColor;}
		public function set backgroundColor(bgColor:Number):void {_BackgroundColor = bgColor;}

		public function LineChartClip()
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
				_View = new LineChartClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new LineChartClipEditor();
				_Editor.model = this;
			}
		}
		
		public override function Resized():void
		{
			if (!height)
				return;
				
			var modelRatio:Number = width / height;
		
			if (modelRatio > 1.67114) {
				width = height * 1.67114;
			} else if (modelRatio < 1.67114) {
				height = width / 1.67114;
			}
		}
		
	}
}