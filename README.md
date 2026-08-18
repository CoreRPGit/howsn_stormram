# Stormram Door Opener

Use a **Stormram** item to break open (or lock) doors managed by **ox_doorlock**, with a real
battering-ram animation and held prop.

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_doorlock](https://github.com/overextended/ox_doorlock)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_target](https://github.com/overextended/ox_target)
- [qbx_core](https://github.com/Qbox-project/qbx_core)

## Installation

1. Drop this folder in your resources as `howsn_stormram`.
2. Add to `server.cfg` after the dependencies above:
   ```
   ensure howsn_stormram
   ```
3. Add the item to `ox_inventory`'s `data/items.lua`:
   ```lua
   ['police_stormram'] = {
       label = 'Stormram',
       weight = 18000,
       stack = true,
       close = true,
       description = 'Knock knock!',
       client = {
           image = 'police_stormram.png',
       }
   },
   ```
   and drop a matching `police_stormram.png` in ox_inventory's image folder.

## Usage

Police can target a door while holding a Stormram: use it to break open a locked door (50/50
chance per attempt) or to lock an unlocked one.

## Configuration

Set the UI/notification language in [shared/config.lua](shared/config.lua):

```lua
Config.Locale = 'en' -- see locales/ for available languages
```

## Credits

Reworked by [Greve](https://github.com/grevef/) (animation/prop handling, locales, cleanup).

The battering ram model (`w_me_batteringram`) and breach animation (`anim@batteringram`) are from
[Epixx1337/Battering-Ram](https://github.com/Epixx1337/Battering-Ram), which in turn credits
[thecrazy_craft](https://sketchfab.com/thecrazy_craft) on Sketchfab for the original model.

## License

MIT.
