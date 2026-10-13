# txustris

This is the very first Ruby code I wrote, back in 2008-2009. It is a clone of
Tetris with an original soundtrack :) The code might suck, but the game is
fun!

As of October 2026, I fixed a couple things to make it run on Ruby 3.x/4.x
with Gosu 1.4. 

    git clone https://github.com/txus/txustris
    cd txustris
    bundle install
    bundle exec ruby init.rb

On macOS with Homebrew, `brew install sdl2` now installs `sdl2-compat`, which breaks Gosu's native build. Fix it with:

    bundle config set --local build.gosu "--with-ldflags='-L/opt/homebrew/lib -lSDL2 -framework Cocoa'"
    bundle pristine gosu

Have fun! <3

## Who's this

This was made by Txus under the MIT license.
