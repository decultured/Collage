package Collage.Clips.Label
{
	import Collage.Clip.*;
	
	public class LabelClip extends Clip
	{
		private var _Text:String = "Default Text";
		private var _Color:Number = 0x000000;
		private var _BackgroundAlpha:Number = 1.0;
		private var _BackgroundColor:Number = 0xFFFFFF;

		[Bindable]
		public function get text():String {return _Text;}
		public function set text(newText:String):void {_Text = newText;}

		[Bindable]
		public function get color():Number {return _Color;}
		public function set color(color:Number):void {_Color = color;}

		[Bindable]
		public function get backgroundAlpha():Number {return _BackgroundAlpha;}
		public function set backgroundAlpha(bgAlpha:Number):void {_BackgroundAlpha = bgAlpha;}

		[Bindable]
		public function get backgroundColor():Number {return _BackgroundColor;}
		public function set backgroundColor(bgColor:Number):void {_BackgroundColor = bgColor;}

		public function LabelClip()
		{
			verticalSizable = false;
			horizontalSizable = false;
			rotatable = false;
			super();
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new LabelClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new LabelClipEditor();
				_Editor.model = this;
			}
		}
	}
}