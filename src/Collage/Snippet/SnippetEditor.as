package Collage.Snippet
{
	import mx.containers.Canvas;
	import mx.events.*;
	import mx.controls.Alert;

	public class SnippetEditor extends Canvas
	{
		[Bindable] public var snippet:Snippet = null;
		
		public function SnippetEditor()
		{
		}
	}
}