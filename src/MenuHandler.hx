package ;

/**
 * ...
 * @author Deepak Aggarwal
 */
import com.eclecticdesignstudio.motion.actuators.FilterActuator;
import flash.geom.Point;
import flash.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.Shape;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Tilesheet;
import nme.Lib;
import nme.Assets;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Rectangle;
import nme.media.SoundChannel;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import MainMenu;
import SubLevelMenu;

 // Main Sprite that will be responsible for displaying menu and submenus 
class MenuHandler extends Sprite
{
	public var level:Int;
	public var sublevel:Int;
	var sublevelmenu:SubLevelMenu;
	var main_menu_screen:MainMenu;
	public function new() 
	{
		super();
		addChild(new Bitmap(Assets.getBitmapData("assets/background/main_background.png")));
		main_menu_screen = new MainMenu();
		// Sublevel menu 
		sublevelmenu = new SubLevelMenu();
		sublevelmenu.x = GameConstant.stageWidth * 0.1;
		sublevelmenu.y = GameConstant.stageHeight * 0.1;
		//Back Button
		var back_button:Sprite = Button.button("BACK", 0xED1C1C, GameConstant.stageHeight/ 6);
		back_button.y = GameConstant.stageHeight - back_button.height;
		back_button.alpha = 0.7;
		// Adding stardust 
		addChild(GameConstant.star_dust);
		// Displaying Main menu 
		addChild(main_menu_screen);
		// Playing stardust
		GameConstant.star_dust.play();
		// Play sound when added to stage
		var sound_instance:SoundChannel;							// Used for stopping playing sound
		sound_instance = GameConstant.background_sound.play(0, -1);                   // Playing background sound
		
		GameConstant.star_dust.register(main_menu_screen.planets);			// Registering planet sprite so that stardust move wih respect to it
		// Displaying sublevels 
		addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
			if (!Std.is(event.target, Planet))
				return;
				level = event.target.value;
				// Initializing star score of sublevels
				sublevelmenu.initializeScore(SavedData.score[level]);
				sound_instance.stop();
				GameConstant.star_dust.stop();								// Stoping stardust for better performance 
				Transition.zoomIn([sublevelmenu, back_button], [main_menu_screen], this);			// No need to remove stardust
				function temp_function(ev:Event)
				{
					GameConstant.star_dust.play();
					Transition.dispatch.removeEventListener(Transition.TRANSITION_COMPLETE, temp_function);
				}
				Transition.dispatch.addEventListener(Transition.TRANSITION_COMPLETE, temp_function); 
				/*     To be replaced with transition statement if we don't want any transitions 
				addChild(sublevelmenu);
				addChild(back_button);
				removeChild(main_menu_screen);	
				*/
			});
			
		//sublevel handler 
		addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
			if (Std.is(event.target, SubLevels))
			{
				sublevel = event.target.value;
				trace("Level selected is:" + (level+1) + " and sublevel is: " + (sublevel+1));
				this.dispatchEvent( new Event("Start Game"));
			}
			if (Std.is(event.target.parent, SubLevels))
			{
				sublevel = event.target.parent.value;
				trace("Level selected is:" + (level+1) + " and sublevel is: " + (sublevel+1));
				this.dispatchEvent( new Event("Start Game"));
			}
		});
			
		// Back button handler 
		back_button.addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
				level = -1;                     // No vaid choice has been made
				GameConstant.star_dust.stop();							// Stoping stardust for better performance
				Transition.zoomIn([main_menu_screen], [sublevelmenu, back_button], this);
				// Waiting for transition to be finished 
				function temp_function(ev:Event)
				{
					sound_instance = GameConstant.background_sound.play(0, -1);
					GameConstant.star_dust.play();										// Playing stardust again
					Transition.dispatch.removeEventListener(Transition.TRANSITION_COMPLETE, temp_function);
				}
				Transition.dispatch.addEventListener(Transition.TRANSITION_COMPLETE, temp_function); 
				/*
				removeChild(sublevelmenu);
				removeChild(back_button);
				addChild(main_menu_screen);	
				*/
			});
	}
	
	// This function is used to show updated star score when a game ends and player is redirected to sublevel menu 
	// screen again.
	public function refreshScore() {
		sublevelmenu.initializeScore(SavedData.score[level]);
	}
}