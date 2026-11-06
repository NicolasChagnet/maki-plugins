# Maki plugins

This is my collection of plugins for the coding agent [maki](https://maki.sh).

## Installation

Add the following code to your global `init.lua` (`~/.config/maki/init.lua`):

```lua
maki.pack.add({
  {
    src = "https://github.com/NicolasChagnet/maki-plugins",
  },
})
```

On first install, maki asks you to approve the permissions that this package requests in `plugin.toml`: `run`, `session_read`, and `session_settings`.

## Configuration

The package accepts options under `plugins["maki-plugins"]` in `maki.setup`:

```lua
maki.setup({
  plugins = {
    ["maki-plugins"] = {
      cmd = "wl-copy", -- default: pbcopy
    },
  },
})
```

`cmd` is the shell command that copies standard input to your clipboard: `pbcopy` on macOS, `wl-copy` on Wayland, or `xclip -selection clipboard` on X11. A key that the package does not declare fails the load, so typos do not go unnoticed.

## Plugins

- `copy_last_message`: creates a custom command `/copy_last_message` which enables you to copy the last message by the AI assistant.
- `model_tiers`: creates a shortcut `<C-n>` for `n = 1, 2, 3` to switch between weak, medium and high tiers of a provider.