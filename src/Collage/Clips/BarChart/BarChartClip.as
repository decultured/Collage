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

		public function BarChartClip()
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
			if (!height)
				return;
				
			var modelRatio:Number = width / height;
		
			if (modelRatio > 2.0067) {
				width = height * 2.0067;
			} else if (modelRatio < 2.0067) {
				height = width / 2.0067;
			}
		}
	}
}