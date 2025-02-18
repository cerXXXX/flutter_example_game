import 'dart:async';

import 'package:first_flame_game/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({position, size}) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    add(RectangleHitbox(position: Vector2(18, 40), size: Vector2(12, 24)));

    animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint_(No_Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.05, textureSize: Vector2.all(64)));
    return super.onLoad();
  }
}
