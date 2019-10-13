# ruby-roguelike

This is a modified version of the Roguelike game from Academy Pittsburgh Session 9 Week 3. This version uses graphical display instead of using the text-based console, and also has sound effects.

This code uses a library called [Gosu](https://www.libgosu.org/index.html) to handle graphics, sound, and input. You must install it before running the script.

## A few notes on how this changes the game
* The game code is now contained within a class 'Game'. This class extends 'Gosu::Window', which is required for Gosu's features. An update() function runs every frame to handle game logic, and a draw() function runs every frame to produce the graphics you see onscreen.
* Sound effects play when you move, run into a wall, pick up treasure, or get teleported.
* There is (kind of) a player avatar at the bottom of the screen that changes in reaction to the game.
* For now, the game screen is still text-based, and the graphical features exist in the form of being able to change fonts and the player avatar. I'll be adding graphical tiles to replace the text.
* The fact that tiles, various tile types, and the player were already contained within classes makes it pretty simple to add graphics to the game without too many changes. This is a testament to the usefulness of OOP.

## Installing Gosu on Windows
Simply type this into a command line:
```
gem install gosu
```

## Installing Gosu on a Mac
If you are running this on a Mac, see [this page](https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X) for installation instructions.

## Running Ruby-Roguelike
Once Gosu is installed, you should clone the repository, then you can run ruby-roguelike like any other script.
```
git clone https://github.com/coljonesdev/ruby-roguelike.git
cd ruby-roguelike
ruby roguelike.rb
```
Use the WASD or Arrow keys to move the player, press 'T' to switch fonts, or press 'Q' to quit.

![Screenshot of the game](https://github.com/coljonesdev/ruby-roguelike/blob/master/screenshot.png "Screenshot")
