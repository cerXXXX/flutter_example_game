import 'dart:async';

import 'package:first_flame_game/components/level.dart';
import 'package:first_flame_game/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  Player player = Player(character: 'Mask_Dude');
  late JoystickComponent joystick;
  late HudButtonComponent jumpButton;
  bool showControls = true;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = ['Level-01', 'Level-02'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    _loadLevel();

    if (showControls) {
      addJoystick();
      addJumpButton();
      
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        )
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        )
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Level world = Level(
      player: player,
      levelName: levelNames[currentLevelIndex],
    );
    // remove(camera);

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    add(cam..priority=-1);
    add(world);
  }

  void addJumpButton() {
    jumpButton = HudButtonComponent(button: SpriteComponent(
      sprite: Sprite(images.fromCache('HUD/JumpButton.png')),
      size: Vector2.all(64),
    ),
      margin: const EdgeInsets.only(right: 32, bottom: 32),
      anchor: Anchor.bottomRight,
      onPressed: () {
        player.hasJumped = true;
      },
      onReleased: () {
        player.hasJumped = false;
      },
    );
    add(jumpButton);
  }
}
