package Collage.Components
{
	import mx.controls.Alert;
	import Collage.Snippet.*;
	
	public class SnippetFactory
	{
		public var _Snippets:Array();
		
		public function ComponentFactory()
		{
			_Snippets = new Array();
		}
		
		public function CreateNewObject(snippetType:String):Snippet
		{
			var newSnippet:Snippet;
			
			switch (snippetType.toLowerCase()){
				case "labelSnippet" :
					newSnippet = new LabelSnippet();
				break;
				case "textBoxSnippet" :
					newSnippet = new TextBoxSnippet();
				break;
				case "pictureSnippet" :
					newSnippet = new PictureSnippet();
				break;
				default:
					Alert.show("Unmapped Extension");
			}
			return null;
		}
	}
}