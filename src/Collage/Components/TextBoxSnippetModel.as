package Collage.Components
{
	import Collage.Snippet.*;
	
	public class TextBoxSnippetModel extends SnippetModel
	{
		private var _Text:String = null;
		
		[Bindable]
		public function get text():String {return _Text;}
		public function set text(newText:String):void
		{
			_Text = newText;
		}
	}
}