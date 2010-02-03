package Collage.Clips.Label
{
	import Collage.Clip.*;
	
	public class LabelClip extends Clip
	{
		private var _Text:String = "Default Text";
		
		[Bindable]
		public function get text():String {return _Text;}
		public function set text(newText:String):void
		{
			_Text = newText;
		}

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