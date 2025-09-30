![packing_gif](https://github.com/user-attachments/assets/98e96d24-6882-41c3-9829-1306f0a57a66)

# Love2D Packing Prototype

A simple, cozy packing prototype built in Love2D.  
This was mainly a sandbox project to shake off some FiveM tunnel vision and get comfortable building something different - something simple, self-contained, and fun.

You place things... inside other things. What more do you want?

### Why no art?

Short answer? Couldn't be bothered.  
Longer answer? I'm juggling a bunch of projects right now, including an actual full game release: **Kevin From IT**.

This prototype was never meant to be a polished product.  
It was just a quick experiment to flex some non-FiveM muscles.

### Will this become a full game?

Never say never.

If it does, expect something more aligned with the **PIT** brand - probably not a cozy organizer, more like a chaotic **drug smuggling sim**.  
You know... same mechanics, just a little *less wholesome*.

## Running the Game

There are two easy ways to run this prototype using [Love2D](https://love2d.org/):

### Method 1: Run with Terminal

1. **Install Love2D** from [https://love2d.org/](https://love2d.org/)
2. (Optional but recommended) Add the `love` binary to your system environment PATH
3. Open a terminal or command prompt
4. Navigate to this folder and run:

```bash
love .
```

That’s it. The game will launch.

### Method 2: Build a `.love` File

If you don’t want to touch a terminal:

1. Zip up the contents of this folder (not the folder itself — just the files inside)
2. Rename the `.zip` file to `.love`
   Example:
   `packing_game.zip` → `packing_game.love`
3. Drag and drop it onto the Love2D executable

That's it, you're playing.

If neither of these work… you might be using Windows 98 or something. Good luck out there.

# Modifying The Game

You can modify the game however you want - it's open source. The world is literally your oyster here.

If you just want to expand on what's currently here, adding audio or levels is stupidly easy.  
It's so easy your nan who's blind in one eye could do it.

## Adding/Changing Audio

You can tweak audio inside `data/audio.lua`.  
It's just a simple return table - nothing fancy, no weird registration logic.

### Adding Background Music

Put your music file into `assets/audio/music/`, then add a new line like:

```lua
music = {
    title = "assets/audio/music/title.mp3",
    level_1 = "assets/audio/music/level_1.mp3",
    my_custom_banger = "assets/audio/music/my_track.mp3" -- add this
}
```

Then in your game logic call:

```lua
audio.play_game_music("my_custom_banger")
```

### Adding Sound Effects

Drop your SFX file into `assets/audio/sfx/` and then add a new entry like this:

```lua
sfx = {
    place_item = {
        type = "static",
        src = "assets/audio/sfx/place_item.mp3",
        volume = 0.7,
        loop = false,
        pitch = true
    },
    zap = {
        type = "static",
        src = "assets/audio/sfx/zap.mp3",
        volume = 1.0,
        loop = false,
        pitch = false
    }
}
```

Then trigger it with:

```lua
audio.play_sfx("zap")
```

Boom. You're now a certified game audio engineer.

## Adding New Levels

Want to make your own levels? Easy.

All levels are defined inside `data/levels.lua` — it's just a plain Lua table, indexed like `[1]`, `[2]`, `[3]`, and so on.

To add a new level:

1. Copy any existing level block (like `[1] = { ... }`)
2. Paste it below the last level and increase the index number (e.g., `[6] = { ... }`)
3. Tweak the container grid:
```lua
main_container = { cols = 5, rows = 4 },
```

4. Add or remove items inside the `items = { ... }` list.
   * `container = true` makes an item hold other items.
   * `shape = { {1,1}, {1,1} }` is the footprint on the grid.
   * `colour = { r, g, b }` changes the draw color.
5. Save.

Then in `core/state.lua`, change this line:

```lua
start_level = 1
```

...to the index of the level you want to test, like:

```lua
start_level = 6
```

Done. You made a new level.

## Support

Can't figure out how to make a level?
Or you can but now you cant beat it? Get in touch!

**[Join the PIT Discord](https://discord.gg/MUckUyS5Kq)**

> Support Hours: **Mon–Fri, 10AM–10PM GMT**  
> Outside that? Shout at the moon, sacrifice a chicken? Or just be patient and wait for someone to be around.
