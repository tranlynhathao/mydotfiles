return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("quarto").setup {
        lspFeatures = {
          enabled = true,
          languages = { "r", "python", "julia" },
          diagnostics = {
            enabled = true,
            triggers = { "BufWrite" },
          },
          completion = {
            enabled = true,
          },
        },
      }
    end,
  },

  -- Send code from python/r/qmd documents to a terminal
  -- Like ipython, R, bash
  {
    "jpalardy/vim-slime",
    config = function()
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = { socket_name = "default", target_pane = "{right-of}" }
      vim.g.slime_dont_ask_default = 1

      function _G.open_repl_if_not_exists()
        local tmux_pane = vim.fn.system "tmux display-message -p '#{pane_id}'"
        if not string.find(tmux_pane, "{right-of}") then
          vim.fn.system "tmux split-window -h 'ipython'"
        end
      end

      function _G.send_to_repl()
        open_repl_if_not_exists()
        vim.cmd "w"
        vim.cmd "SlimeSendCell"
      end
    end,
  },

  -- paste an image to markdown from the clipboard
  "ekickx/clipboard-image.nvim",
}
