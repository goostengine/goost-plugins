# Goost Plugins

This is a collection of GDScript plugins which rely on the functionality
implemented in the [Goost](https://github.com/goostengine/goost) Godot Engine C++
extension.

## List of plugins

|        Plugin        |                 Short description                 |                 Depends on                  |
| -------------------- | ------------------------------------------------- | ------------------------------------------- |
| `GridLayer`          | Displays infinite grid at run-time.               | `GridRect` class                            |
| `GDScriptTranspiler` | Adds an editor interface for transpiling scripts. | `gdscript_transpiler` module (experimental) |

## Compatibility

The default branch is compatible with the latest stable Godot version.

If you are using an older (or future) version of Godot, use the appropriate
branch for your Godot version:

- [`gd3`](https://github.com/goostengine/goost-plugins/tree/gd3) for Godot 3.x.
- [`gd4`](https://github.com/goostengine/goost-plugins/tree/gd4) for Godot 4.x.

## Useful links

- [Goost source code](https://github.com/goostengine/goost)

## License

Unless otherwise specified, the plugins and scripts are distributed under the
terms of the MIT license, as described in the [LICENSE.md](LICENSE.md) file.
