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

		protected override function CreateView():void
		{
			_View = new LabelClipView();
			_View.model = this;
		}

		protected override function CreateEditor():void
		{
			_Editor = new LabelClipEditor();
			_Editor.model = this;
		}
	}
}