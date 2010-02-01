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
			super();
			CreateView();
			CreateEditor();
		}

		protected override function CreateView():void
		{
			_View = new TextBoxClipView();
			_View.model = this;
		}

		protected override function CreateEditor():void
		{
			_Editor = new TextBoxClipEditor();
			_Editor.model = this;
		}

	}
}