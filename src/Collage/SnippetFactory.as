package Collage
{
	import mx.controls.Alert;
	import Collage.Snippet.*;
	import Collage.Components.*;
	import Collage.Components.Label.*;
	import Collage.Components.TextBox.*;
	import Collage.Components.Picture.*;
	import Collage.Components.TextBox.*;
	
	public class SnippetFactory
	{
		public var _Snippets:Array;
		
		public function SnippetFactory()
		{
			_Snippets = new Array();
		}
		
		public function CreateNewObject(snippetType:String):Snippet
		{
			var newSnippet:Snippet;
			
			switch (snippetType.toLowerCase()){
				case "label" :
					newSnippet = new LabelSnippet();
				break;
				case "textBox" :
					newSnippet = new TextBoxSnippet();
				break;
				case "picture" :
					newSnippet = new PictureSnippet();
				break;
				default:
					Alert.show("Unmapped Extension");
			}
			return newSnippet;
		}
	}
}