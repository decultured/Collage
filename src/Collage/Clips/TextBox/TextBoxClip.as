package Collage.Clips.TextBox
{
	import Collage.Clip.*;
	
	public class TextBoxClip extends Clip
	{
		private var _Text:String = "Default Text.";
		
		[Bindable]
		public function get text():String {return _Text;}
		public function set text(newText:String):void
		{
			_Text = newText;
		}

		public function TextBoxClip()
		{
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
				_View = new TextBoxClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new TextBoxClipEditor();
				_Editor.model = this;
			}
		}

		public override function LoadFromData(data:Object):Boolean
		{
			if (data is String)
			{
				this.text = data as String;
				return true;
			}
			return false;
		}
	}
}