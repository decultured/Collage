package Collage.Document
{
	import flash.geom.*;
	import Collage.Clip.*;
	import mx.core.UIComponent;

	public class ClipDocument
	{
		protected var _Clips:Array;
		protected var _ViewPane:UIComponent;
		
		public function set viewPane(viewPane:UIComponent):void {_ViewPane = viewPane;}
		public function get viewPane():UIComponent {return _ViewPane;}
		
		public function ClipDocument(newViewPane:UIComponent)
		{
			_ViewPane = newViewPane;
			ClipFactory.RegisterClipDefinitions();
			_Clips = new Array();
		}
		
		public function ViewResized():void
		{
			// TODO : Reposition all objects to fit in new size
		}
		
		public function AddClip(newClip:Clip):Boolean
		{
			if (_ViewPane && newClip && !_Clips[newClip.uid]) {
				_Clips[newClip.uid] = newClip;
				_ViewPane.addChild(newClip.view);
				return true;
			}
			return false;
		}

		public function AddClipByType(clipType:String, position:Rectangle = null):Clip
		{
			var newClip:Clip = ClipFactory.CreateByType(clipType);
			if (!newClip || !AddClip(newClip))
				return null;
			PositionClip(newClip, position);
			
			return newClip;
		}

		public function AddClipFromData(data:Object, position:Rectangle = null):Clip
		{
			var newClip:Clip = ClipFactory.CreateFromData(data);
			if (!newClip || !AddClip(newClip))
				return null;
			PositionClip(newClip, position);
			
			return newClip;
		}
		
		public function PositionClip(clip:Clip, position:Rectangle):void
		{
			if (!clip)
				return;

			if (!position)
				position = new Rectangle(0,0,300,300);
			
			clip.x = position.x;
			clip.y = position.y;
			clip.width = position.width;
			clip.height = position.height;
		}
	}
}