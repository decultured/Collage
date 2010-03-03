package Collage.Clips.WebEmbed
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	
	public class WebEmbedClip extends Clip
	{		
		public function WebEmbedClip(dataObject:Object = null)
		{
			moveFromCenter = true;
			super(dataObject);
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new WebEmbedClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new WebEmbedClipEditor();
				_Editor.model = this;
			}
		}
		
		public override function Resized():void
		{
			
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			return newObject;
		}

	}
}