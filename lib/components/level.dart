import 'dart:async';

import 'package:first_flame_game/components/background_tile.dart';
import 'package:first_flame_game/components/checkpoint.dart';
import 'package:first_flame_game/components/collision_block.dart';
import 'package:first_flame_game/components/fruit.dart';
import 'package:first_flame_game/components/player.dart';
import 'package:first_flame_game/components/saw.dart';
import 'package:first_flame_game/pixel_adventure.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2(16, 16),
        prefix: "assets/tiles/");

    add(level);

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');
    const tileSize = 64;

    final numTilesY = (game.size.y / tileSize).floor();
    final numTilesX = (game.size.x / tileSize).floor();
    print(numTilesY);

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');

      for (double y = 0; y < game.size.y / numTilesY; y++) {
        for (double x = 0; x < numTilesX; x++) {
          final backgroundTile = BackgroundTile(
              color: backgroundColor ?? 'Gray',
              position: Vector2(x * tileSize, y * tileSize - tileSize));

          add(backgroundTile);
        }
      }
    }
  }

  void _spawningObjects() {
    final spawnpointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawnpointsLayer != null) {
      for (final spawnpoint in spawnpointsLayer.objects) {
        switch (spawnpoint.class_) {
          case 'Player':
            player.position = Vector2(spawnpoint.x, spawnpoint.y);
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
                fruit: spawnpoint.name,
                position: Vector2(spawnpoint.x, spawnpoint.y),
                size: Vector2(spawnpoint.width, spawnpoint.height));
            add(fruit);
            break;
          case 'Saw':
            final isVertical = spawnpoint.properties.getValue('isVertical');
            final offNeg = spawnpoint.properties.getValue('offNeg');
            final offPos = spawnpoint.properties.getValue('offPos');

            final saw = Saw(
                isVertical: isVertical,
                offNeg: offNeg,
                offPos: offPos,
                position: Vector2(spawnpoint.x, spawnpoint.y),
                size: Vector2(spawnpoint.width, spawnpoint.height));
            add(saw);
            break;
          case 'Checkpoint':
            print(1);
            final checkpoint = Checkpoint(
                position: Vector2(spawnpoint.x, spawnpoint.y),
                size: Vector2(spawnpoint.width, spawnpoint.height));
            add(checkpoint);
            break;
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: true);
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height));
            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
