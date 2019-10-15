# ruby-roguelike

![Screenshot of the game](https://github.com/coljonesdev/ruby-roguelike/blob/master/assets/screenshot.png "Screenshot")

This is a modified version of the Roguelike game from Academy Pittsburgh Session 9 Week 3. This version uses graphical display instead of using the text-based console, and also has sound effects. For the sake of comparison, [here's the original roguelike code](https://gist.github.com/coljonesdev/a069a3fcb4502431d3d95566d466f6b0) that John made during class.

This code uses a library called [Gosu](https://www.libgosu.org/index.html) to handle graphics, sound, and input. You must install it before running the script. Of course, Ruby must also be installed.

## What changed between the original program and this code
* The game code is now contained within a class 'Game'. This class extends 'Gosu::Window', which is required for Gosu's features. An update() function runs every frame to handle game logic, and a draw() function runs every frame to produce the graphics you see onscreen.
* Sound effects play when you move, run into a wall, pick up treasure, or get teleported.
* The grid is shown using graphical tiles instead of text symbols.
* The fact that tiles, various tile types, and the player were already contained within classes makes it pretty simple to add graphics to the game without too many changes. This is a testament to the usefulness of OOP.

## Installing Gosu on Windows
Simply type this into a command line:
```
gem install gosu
```

## Installing Gosu on a Mac
These steps should work even if you can't log in as root on your Mac (su/sudo).

1. Install Homebrew, then use that to install SDL2 (required for Gosu to work):
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install sdl2
```

2. __Skip if Ruby is installed and working.__ If you haven't done a proper Ruby install, do that now. Even though macOS includes Ruby, it may be outdated/incomplete:
```
brew install rbenv
rbenv install 2.6.5
```

3. __Skip if Ruby is installed and working.__ Close and re-open Terminal!

4. Finally, run this command:
```
gem install gosu
```

## Running Ruby-Roguelike
Once Gosu is installed, you should clone the repository, then you can run ruby-roguelike like any other script.
```
git clone https://github.com/coljonesdev/ruby-roguelike.git
cd ruby-roguelike
ruby roguelike.rb
```
Use the WASD or Arrow keys to move the player, press 'T' to switch fonts, or press 'Q' to quit.
