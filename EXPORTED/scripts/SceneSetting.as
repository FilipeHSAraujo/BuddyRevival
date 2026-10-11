package
{
   import com.buddylabs.player.Node;
   import flash.display.Graphics;
   import flash.display.Stage;
   
   public class SceneSetting extends SceneObject
   {
      
      private var childObjects:Array = new Array();
      
      public function SceneSetting(param1:Stage)
      {
         super(param1);
      }
      
      override public function drawFrame(param1:Graphics, param2:uint) : void
      {
         var _loc3_:SceneObject = null;
         if(player == null || param1 == null)
         {
            return;
         }
         if(currentAnim != null)
         {
            currentAnim.drawFrame(player.context,param2);
         }
         for each(_loc3_ in childObjects)
         {
            _loc3_.setCurrentFrame(param2);
         }
         player.renderFrame(param1);
      }
      
      public function addSceneObject(param1:SceneObject, param2:String) : void
      {
         if(player == null || player.context == null || player.context.scene == null)
         {
            return;
         }
         var _loc3_:Node = player.context.scene.getNodeByName(param2) as Node;
         _loc3_.addChild(param1.player.context.scene);
         childObjects.push(param1);
      }
      
      override public function draw(param1:Graphics, param2:Boolean) : void
      {
         var _loc3_:SceneObject = null;
         if(player == null || param1 == null)
         {
            return;
         }
         if(currentAnim != null)
         {
            currentAnim.step(player.context,param2);
         }
         for each(_loc3_ in childObjects)
         {
            _loc3_.stepAnimation(param2);
         }
         player.renderFrame(param1);
      }
   }
}

