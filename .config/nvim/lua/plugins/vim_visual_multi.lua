-- ~/.config/nvim/lua/plugins/vim_visual_multi.lua

return {
  "mg979/vim-visual-multi",
  branch = "master",
  config = function()
    vim.g.VM_default_mappings = 0
    -- available keymap
    vim.api.nvim_set_keymap("n", "<C-n>", "<Plug>(VM-Find-Under)", {})
    vim.api.nvim_set_keymap("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)", {})
    vim.api.nvim_set_keymap("n", "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", {})
    vim.api.nvim_set_keymap("n", "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", {})

    -- advance keymap
    vim.api.nvim_set_keymap("n", "<C-S-Down>", "<Plug>(VM-Select-Next)", {})
    vim.api.nvim_set_keymap("n", "<C-S-Up>", "<Plug>(VM-Select-Prev)", {})
    vim.api.nvim_set_keymap("n", "<C-d>", "<Plug>(VM-Remove-Cursor)", {})
    vim.api.nvim_set_keymap("n", "<C-S-d>", "<Plug>(VM-Remove-All)", {})
    vim.api.nvim_set_keymap("n", "<C-l>", "<Plug>(VM-Reselect-Last)", {})
    vim.api.nvim_set_keymap("n", "<C-a>", "<Plug>(VM-Select-All)", {})
    vim.api.nvim_set_keymap("n", "<C-/>", "<Plug>(VM-Visual-Clear)", {})
    vim.api.nvim_set_keymap("n", "<C-Space>", "<Plug>(VM-Visual-Regex)", {})

    -- switch between cursors
    vim.api.nvim_set_keymap("n", "n", "<Plug>(VM-Find-Under)", {})
    vim.api.nvim_set_keymap("n", "N", "<Plug>(VM-Select-Next)", {})
    vim.api.nvim_set_keymap("n", "p", "<Plug>(VM-Select-Prev)", {})

    -- lock and unclock the current cursor
    vim.api.nvim_set_keymap("n", "<C-s>", "<Plug>(VM-Insert)", {})
    vim.api.nvim_set_keymap("n", "<C-r>", "<Plug>(VM-Replace)", {})
  end,
}
