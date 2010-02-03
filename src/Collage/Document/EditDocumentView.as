package Collage.Document
{
	import flash.geom.*;
	import Collage.Clip.*;
	import flash.events.*;
	import mx.core.UIComponent;
	import com.roguedevelopment.objecthandles.*;
	import com.roguedevelopment.objecthandles.constraints.*;

	public class EditDocumentView extends DocumentView
	{
		protected var _InspectorPane:UIComponent;
		protected var _OptionsBox:UIComponent;
		protected var _SelectionManager:ObjectHandlesSelectionManager;
		protected var _ObjectHandles:ObjectHandles;
		protected var _CurrentlySelected:Clip;
		public function set inspector(inspectorPane:UIComponent):void {_InspectorPane = inspectorPane;}
		public function get inspector():UIComponent {return _InspectorPane;}
		public function set optionsBox(optionsBox:UIComponent):void {_OptionsBox = optionsBox;}
		public function get optionsBox():UIComponent {return _OptionsBox;}


		public override function set viewPane(viewPane:UIComponent):void {
			_ViewPane = viewPane;
			InitObjectHandles();
		}

		public function EditDocumentView()
		{
			super();
		}

		public function InitializeForEdit(newViewPane:UIComponent, newInspector:UIComponent, newOptionsBox:UIComponent):void
		{
			super.Initialize(newViewPane);
			_InspectorPane = newInspector;
			_OptionsBox = newOptionsBox;
			InitObjectHandles();
		}

		public function InitObjectHandles():void
		{
			if (!_ViewPane)
				return;
				
			_SelectionManager = new ObjectHandlesSelectionManager();
			_ObjectHandles = new ObjectHandles(_ViewPane, _SelectionManager);
			var sizeConstraint:SizeConstraint = new SizeConstraint();
			sizeConstraint.minWidth = 20;
			sizeConstraint.minHeight = 20;
			sizeConstraint.maxWidth = _ViewPane.width;
			sizeConstraint.maxHeight = _ViewPane.height;
			_ObjectHandles.constraints.push(sizeConstraint);							

			_SelectionManager.addEventListener(SelectionEvent.ADDED_TO_SELECTION, ObjectSelected);
			_SelectionManager.addEventListener(SelectionEvent.REMOVED_FROM_SELECTION, ObjectDeselected);
			_SelectionManager.addEventListener(SelectionEvent.SELECTION_CLEARED, ObjectDeselected);

			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVED, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVING, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZED, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZING, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_ROTATED, ObjectChanged);
		}		

		public override function ViewResized():void
		{
			super.ViewResized();
			if (_ObjectHandles) {
				var moveConstraint:MovementConstraint = new MovementConstraint();
				moveConstraint.minX = 0;
				moveConstraint.minY = 0;
				moveConstraint.maxX = _ViewPane.width;
				moveConstraint.maxY = _ViewPane.height;
				_ObjectHandles.constraints.push(moveConstraint);							
			}
		}
		
		public override function AddClip(newClip:Clip):Boolean
		{
			if (!super.AddClip(newClip))
				return false;
			_ObjectHandles.registerComponent(newClip, newClip.view);
			return true;
		}

		public override function AddClipByType(clipType:String, position:Rectangle = null):Clip
		{
			var newClip:Clip = super.AddClipByType(clipType);
			if (newClip)
				_ObjectHandles.registerComponent(newClip, newClip.view);
			return newClip;
		}

		public override function AddClipFromData(data:Object, position:Rectangle = null):Clip
		{
			var newClip:Clip = super.AddClipFromData(data);
			if (newClip)
				_ObjectHandles.registerComponent(newClip, newClip.view);
			return newClip;
		}

		protected function ObjectSelected(event:SelectionEvent):void {
			for each (var clip:Clip in event.targets) {
				clip.selected = true;
				_CurrentlySelected = clip;
				PositionOptionsBox();
				if (_CurrentlySelected) {
					ShowClipEditor();
				}
			}
		}

		protected function ObjectDeselected(event:SelectionEvent):void {
			for each (var clip:Clip in event.targets) {
				_CurrentlySelected = null;
				PositionOptionsBox();
				clip.selected = false;
				
				HideClipEditor();
			}
		}


		private function ObjectChanged(event:ObjectChangedEvent):void{
			for each (var clip:Clip in event.relatedObjects) {
				if (event.type == ObjectChangedEvent.OBJECT_MOVED) {clip.Moved();}
				else if (event.type == ObjectChangedEvent.OBJECT_RESIZED) {clip.Resized();}
				else if (event.type == ObjectChangedEvent.OBJECT_ROTATED) {clip.Rotated();}
				PositionOptionsBox();
			}
		}
		
		protected function PositionOptionsBox():void
		{
			if (!_OptionsBox) return;
			if (!_CurrentlySelected) {
				_OptionsBox.visible = false;
				return;
			}
			_OptionsBox.visible = true;
			
			if (_CurrentlySelected.y < 30) {
				_OptionsBox.y = _CurrentlySelected.y + _CurrentlySelected.height;
				_OptionsBox.x = _CurrentlySelected.x + _CurrentlySelected.width - optionsBox.width;
			} else {
				_OptionsBox.y = _CurrentlySelected.y - optionsBox.height;
				_OptionsBox.x = _CurrentlySelected.x + _CurrentlySelected.width - optionsBox.width;
			}
		}
		
		public function deleteSelected():void
		{
			if (_CurrentlySelected && _CurrentlySelected.view) {
				var view:ClipView = _CurrentlySelected.view;
				_ObjectHandles.unregisterComponent(view);
				_ViewPane.removeChild(view);
			}
			
			// TODO : Remove from internal list
		}
		
		public function lockSelected():void
		{
			if (_CurrentlySelected && _CurrentlySelected.view) {
				var view:ClipView = _CurrentlySelected.view;
				_ObjectHandles.unregisterComponent(view);
			}
		}
		
		public function BackgroundClick(event:MouseEvent) : void
		{		
			if( event.target == _ViewPane)
				_ObjectHandles.selectionManager.clearSelection();
		}
		
		public function ShowClipEditor():void
		{
			if (!_CurrentlySelected.editor || !_InspectorPane)
				return;
			HideClipEditor();
			_InspectorPane.addChild(_CurrentlySelected.editor);
		}
		
		public function HideClipEditor():void
		{
			if (!_InspectorPane)
				return;
			for (var i:uint = 0; i < _InspectorPane.numChildren; i++)
				_InspectorPane.removeChildAt(0);
		}
	}
}