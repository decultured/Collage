package Collage.Components
{
	import Collage.Snippet.*;
	
	public class LabelSnippetModel extends SnippetModel
	{
		private var _Text:String = "Default Text";
		
		[Bindable]
		public function get text():String {return _Text;}
		public function set text(newText:String):void
		{
			_Text = newText;
		}
	}
}