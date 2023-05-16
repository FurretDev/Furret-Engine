package customization;

import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUI;
import flixel.util.FlxColor;
import flixel.tweens.*;
import flixel.group.FlxGroup.FlxTypedGroup;

class CustomizeGameplay extends MusicBeatState
{
    var FurretEngineWatermark:FlxText;

    public var strumLine:FlxSprite;
    public var strumLineNotes:FlxTypedGroup<FlxSprite>;
    public var alphaaaaaaaaa:Float = FlxG.save.data.note_opacity;
    public var arrayArrowsUwu:Array<FlxSprite> = [];
    public var backgroundleft:Bool = FlxG.save.data.hide_background_on_left;
    public var backgroundright:Bool = FlxG.save.data.hide_background_on_right;
    public var background_left:FlxSprite;
    public var background_right:FlxSprite;

    var UI_box:FlxUITabMenu;
    var thing:FlxUI;

	public var playerStrums:FlxTypedGroup<FlxSprite>;
	public var dadStrums:FlxTypedGroup<FlxSprite>;

    public var camHUD:FlxCamera;
	public var camGame:FlxCamera;

    public var showLeft:FlxUICheckBox;
    public var showRight:FlxUICheckBox;

    var rating:FlxSprite;
    var slider:FlxUISlider;

    var boyfriend:Character;
	var gf:Character;

    override public function create()
    {
        camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

        FlxG.mouse.visible = true;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

        super.create();

        var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/stageback.png');
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.active = false;
        add(bg);

		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic('assets/images/stagefront.png');
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set();
		stageFront.active = false;
        add(stageFront);

		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic('assets/images/stagecurtains.png');
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = true;
		stageCurtains.scrollFactor.set();
		stageCurtains.active = false;
        add(stageCurtains);

        background_left = new FlxSprite(50, 0);
        background_left.makeGraphic(500, 2500, FlxColor.BLACK);
        background_left.alpha = 0.5;
        background_left.cameras = [camHUD];
        add(background_left);

        background_right = new FlxSprite(700, 0);
        background_right.makeGraphic(500, 2500, FlxColor.BLACK);
        background_right.alpha = 0.5;
        background_right.cameras = [camHUD];
        add(background_right);

        gf = new Character(343, 74, "gf", false);
		add(gf);

		boyfriend = new Character(836, 387, "bf", false);
		boyfriend.playAnim("idle", true);
		boyfriend.flipX = false;
		add(boyfriend);

        FurretEngineWatermark = new FlxText(0, 0, FlxG.width);
		FurretEngineWatermark.text = 'Furret Engine ' + MainMenuState.furretEngineVer + " | Customize Gameplay";
		FurretEngineWatermark.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (FlxG.save.data.downscroll)
		{
			FurretEngineWatermark.y = 698;
		}
		add(FurretEngineWatermark);
        FurretEngineWatermark.cameras = [camHUD];

        FlxG.camera.zoom = 1;

        strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		dadStrums = new FlxTypedGroup<FlxSprite>();

        strumLineNotes.cameras = [camHUD];

        generateStaticArrows(0);
        generateStaticArrows(1);

        rating = new FlxSprite();
        rating.loadGraphic(Paths.image("sick"));
		rating.screenCenter();
		rating.x = FlxG.save.data.ratingX;
		rating.y = FlxG.save.data.ratingY;
		/*rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);*/
		rating.cameras = [camHUD];
        rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = true;

        add(rating);

        var tabs = [
			{name: 'Settings', label: 'Settings'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.x = 4;
		UI_box.y = 240;
		UI_box.resize(350, 450);
        UI_box.cameras = [camHUD];
		add(UI_box);

        thing = new FlxUI(null, UI_box);
        thing.name = "Settings";

        slider = new FlxUISlider(this, 'alphaaaaaaaaa', 4, 16, 0, 1, 150, null, 5, FlxColor.WHITE, FlxColor.BLACK);
		slider.visible = true;
        slider.nameLabel.text = 'Arrow opacity';
		thing.add(slider);

        showLeft = new FlxUICheckBox(4,128,null,null,"Show background on left side",100);
        showRight = new FlxUICheckBox(4,164,null,null,"Show background on left side",100);
        thing.add(showLeft);
        thing.add(showRight);
        showLeft.checked = FlxG.save.data.hide_background_on_left;
        showRight.checked = FlxG.save.data.hide_background_on_right;

        UI_box.addGroup(thing);
    }

    function quit():Void
    {
        FlxG.save.data.ratingX = rating.x;
        FlxG.save.data.ratingY = rating.y;
        FlxG.save.data.note_opacity = alphaaaaaaaaa;
        FlxG.save.data.hide_background_on_left = backgroundleft;
        FlxG.save.data.hide_background_on_right = backgroundright;
        FlxG.save.flush();
        FlxG.switchState(new options.OptionsMenu());
    }

    function keyShit():Void
    {
        var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

        playerStrums.forEach(function(spr:FlxSprite)
        {
            switch (spr.ID)
            {
                case 0:
                    if (leftP && spr.animation.curAnim.name != 'confirm')
                        spr.animation.play('confirm');
                    if (leftR)
                        spr.animation.play('static');
                case 1:
                    if (downP && spr.animation.curAnim.name != 'confirm')
                        spr.animation.play('confirm');
                    if (downR)
                        spr.animation.play('static');
                case 2:
                    if (upP && spr.animation.curAnim.name != 'confirm')
                        spr.animation.play('confirm');
                    if (upR)
                        spr.animation.play('static');
                case 3:
                    if (rightP && spr.animation.curAnim.name != 'confirm')
                        spr.animation.play('confirm');
                    if (rightR)
                        spr.animation.play('static');
            }

            if (leftP)
            {
                boyfriend.playAnim("singLEFT", false);
            }
            if (downP)
            {
                boyfriend.playAnim("singDOWN", false);
            }
            if (upP)
            {
                boyfriend.playAnim("singUP", false);
            }  
            if (rightP)
            {
                boyfriend.playAnim("singRIGHT", false);
            }
    
            if (spr.animation.curAnim.name == 'confirm')
            {
                spr.centerOffsets();
                spr.offset.x -= 13;
                spr.offset.y -= 13;
            }
            else
                spr.centerOffsets();
        });
    }

    private function generateStaticArrows(player:Int):Void
    {
        for (i in 0...4)
        {
            // FlxG.log.add(i);
            var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y); //tengo sida uwu

            babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
            babyArrow.animation.addByPrefix('green', 'arrowUP');
            babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
            babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
            babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

            babyArrow.antialiasing = true;
            babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

            switch (Math.abs(i))
            {
                case 0:
                    babyArrow.x += Note.swagWidth * 0;
                    babyArrow.animation.addByPrefix('static', 'arrowLEFT');
                    babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
                    babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
                case 1:
                    babyArrow.x += Note.swagWidth * 1;
                    babyArrow.animation.addByPrefix('static', 'arrowDOWN');
                    babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
                    babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
                case 2:
                    babyArrow.x += Note.swagWidth * 2;
                    babyArrow.animation.addByPrefix('static', 'arrowUP');
                    babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
                    babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
                case 3:
                    babyArrow.x += Note.swagWidth * 3;
                    babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
                    babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
                    babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
            }

            babyArrow.updateHitbox();
            babyArrow.scrollFactor.set();

            babyArrow.y -= 10;
            babyArrow.alpha = 0;
            FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

            babyArrow.ID = i;

            switch (player)
            {
                case 0:
                    dadStrums.add(babyArrow);
                case 1:
                    playerStrums.add(babyArrow);
            }

            babyArrow.animation.play('static');
            babyArrow.x += 90; //así no se mete el pito -isa 2022
            babyArrow.x += ((FlxG.width / 2) * player);

            arrayArrowsUwu.push(babyArrow);

            strumLineNotes.add(babyArrow);
        }
    }

    override public function update(elapsed:Float)
    {
        keyShit();
        boyfriend.holdTimer = 0;
        for (i in 0...arrayArrowsUwu.length) {
            arrayArrowsUwu[i].alpha = this.alphaaaaaaaaa;
        }

        backgroundleft = showLeft.checked;
        backgroundright = showRight.checked;

        background_left.visible = backgroundleft;
        background_right.visible = backgroundright;

        if (FlxG.mouse.overlaps(rating))
        {
            if (FlxG.mouse.pressed)
            {
                rating.setPosition(FlxG.mouse.getPosition().x - rating.width / 2, FlxG.mouse.getPosition().y - rating.height / 2);
                FlxG.mouse.visible = false;
            }
            else
            {
                FlxG.mouse.visible = true;
            }
        }
        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.mouse.visible = false;
            quit();
        }
        super.update(elapsed);
    }
}