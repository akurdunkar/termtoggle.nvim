# termtoggle.nvim

A simple Neovim plugin to toggle a floating terminal window.

![](./term.png)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "aditya-K2/termtoggle.nvim",
    config = function()
        require("termtoggle").setup()
    end,
}
```

## Configuration

All options are optional and have sensible defaults:

```lua
require("termtoggle").setup({
    height = 20,          -- terminal window height
    shell = vim.o.shell,  -- shell to use
    border = "rounded",   -- border style (see :h nvim_open_win)
    bg = nil,             -- custom background color, e.g. "#1e1e2e"
    keymap = "<M-m>",     -- key to toggle the terminal
})
```

## Usage

Press `<M-m>` (Alt+m) to toggle the terminal. The toggle function is also exported for custom mappings:

```lua
vim.keymap.set({ "n", "t" }, "<your-key>", require("termtoggle").toggle)
```
