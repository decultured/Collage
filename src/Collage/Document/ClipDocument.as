package Collage
{
	import Collage.Snippet.*;
	
	public class SnippetDocument
	{
		public var _Snippets:Array;
		public var _ViewPane:UIComponent;
		
		public function set viewPane(viewPane:UIComponent):void {_ViewPane = viewPane;}
		public function get viewPane():UIComponent {return _ViewPane;}
		
		public function SnippetDocument()
		{
			_Snippets = new Array();
		}
		
		public function AddSnippet(newSnippet:Snippet):Boolean
		{
			if (_newSnippet && !_Snippets[newSnippet.uid]) {
				_Snippets[newSnippet.uid] = newSnippet;
				return true;
			}
			return false;
		}
	}
}