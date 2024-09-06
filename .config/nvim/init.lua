vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- Bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },
  { import = "plugins" },
}, lazy_config)

-- Load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Initialize variable (if not)
vim.g.nvim_tree_show_dotfiles = vim.g.nvim_tree_show_dotfiles or false

-- Declare toggle_dotfiles function
local function toggle_dotfiles()
  local show = vim.g.nvim_tree_show_dotfiles
  vim.g.nvim_tree_show_dotfiles = not show
  require("nvim-tree").refresh()
end

vim.api.nvim_set_keymap("n", "<leader>d", ":lua toggle_dotfiles()<CR>", { noremap = true, silent = true })

-- Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Empty setup using defaults
require("nvim-tree").setup()

-- Setup with some options
require("nvim-tree").setup {
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
}

-- Define the Replace functions
function ReplaceCurrentLine()
  local search = vim.fn.input "Replace: "
  if search == "" then
    print "No pattern to replace"
    return
  end
  local replace = vim.fn.input "With: "
  vim.cmd(string.format("s/%s/%s/g", search, replace))
end

function ReplaceInFile()
  local search = vim.fn.input "Replace: "
  if search == "" then
    print "No pattern to replace"
    return
  end
  local replace = vim.fn.input "With: "
  vim.cmd(string.format("%%s/%s/%s/g", search, replace))
end

function ReplaceInSelection()
  local search = vim.fn.input "Replace: "
  if search == "" then
    print "No pattern to replace"
    return
  end
  local replace = vim.fn.input "With: "
  vim.cmd(string.format("'<,'>s/%s/%s/g", search, replace))
end

-- Custom configuration
local function InsertBacklink()
  local backlink_text = vim.fn.input "Backlink Text: "
  local backlink_url = vim.fn.input "Backlink URL: "
  vim.api.nvim_put({ "[" .. backlink_text .. "](" .. backlink_url .. ")" }, "c", true, true)
end

-- Put function in global space
_G.InsertBacklink = InsertBacklink

-- Key mapping for inserting backlinks in Markdown
vim.api.nvim_set_keymap("n", "<leader>l", ":lua InsertBacklink()<CR>", { noremap = true, silent = true })

function EvalExpressionWithBC()
  local line = vim.api.nvim_get_current_line()
  local result = vim.fn.system("echo '" .. line .. "' | bc")
  vim.api.nvim_set_current_line(result)
end

vim.api.nvim_set_keymap("n", "<leader>E", ":lua EvalExpressionWithBC()<CR>", { noremap = true, silent = true })

function EvalExpression()
  local line = vim.api.nvim_get_current_line()
  local expr = line:match "//(.*)"
  if expr then
    expr = expr:gsub("%s+", "")
    local result, err = load("return " .. expr)
    if result then
      result = result()
      local new_line = line:gsub("//(.*)", "// " .. expr .. " = " .. tostring(result))
      vim.api.nvim_set_current_line(new_line)
    else
      print("error: " .. err)
    end
  else
    print "Not found expression in line"
  end
end

vim.api.nvim_set_keymap("n", "<leader>t", ":lua EvalExpression()<CR>", { noremap = true, silent = true })

-- Insert Codeblock with languages
vim.api.nvim_set_keymap("n", "<leader>p", "o```python<CR><ESC>O<ESC>o```", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>j", "o```javascript<CR><ESC>O<ESC>o```", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "x",
  "<leader>`",
  ":<C-u>normal! I```<CR><Esc>:<C-u>normal! A```<Esc><Esc>",
  { noremap = true, silent = true }
)

-- Global settings for all files
vim.cmd [[
  filetype plugin indent on
  set tabstop=2
  set shiftwidth=2
  set expandtab
]]
