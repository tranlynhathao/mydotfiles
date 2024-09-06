return {
  -- Lua utilities
  "nvim-lua/plenary.nvim",

  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },

  -- Treesitter for syntax highlighting and more
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    dependencies = {
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup()
        end,
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "css", "html", "javascript", "lua", "markdown", "markdown_inline", "rmarkdown", "quarto" },
        highlight = {
          enable = true,
        },
        autotag = {
          enable = true,
          filetypes = {
            "html",
            "javascript",
            "typescript",
            "tsx",
            "xml",
            "vue",
            "svelte",
            "javascriptreact",
            "typescriptreact",
          },
        },
      }
    end,
  },

  -- Additional language support
  { "sheerun/vim-polyglot" },

  -- Colorscheme
  {
    "gruvbox-community/gruvbox",
    config = function()
      vim.cmd "colorscheme gruvbox"
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- LSP setup
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "nvchad.configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
    end,
  },

  -- Completion and snippets
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/vim-vsnip",
      "hrsh7th/vim-vsnip-integ",
      "hrsh7th/cmp-cmdline",
    },
    opts = function()
      return require "nvchad.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "comment toggle linewise" },
      { "gc", mode = "x", desc = "comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "comment toggle blockwise" },
      { "gb", mode = "x", desc = "comment toggle blockwise (visual)" },
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- Multi cursor
  {
    "mg979/vim-visual-multi",
    branch = "master",
    config = function()
      vim.g.VM_default_mappings = 0
      vim.api.nvim_set_keymap("n", "<C-n>", "<Plug>(VM-Find-Under)", {})
      vim.api.nvim_set_keymap("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)", {})
      vim.api.nvim_set_keymap("n", "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", {})
      vim.api.nvim_set_keymap("n", "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", {})
      vim.api.nvim_set_keymap("n", "<C-S-Down>", "<Plug>(VM-Select-Next)", {})
      vim.api.nvim_set_keymap("n", "<C-S-Up>", "<Plug>(VM-Select-Prev)", {})
      vim.api.nvim_set_keymap("n", "<C-d>", "<Plug>(VM-Remove-Cursor)", {})
      vim.api.nvim_set_keymap("n", "<C-S-d>", "<Plug>(VM-Remove-All)", {})
      vim.api.nvim_set_keymap("n", "<C-l>", "<Plug>(VM-Reselect-Last)", {})
      vim.api.nvim_set_keymap("n", "<C-a>", "<Plug>(VM-Select-All)", {})
      vim.api.nvim_set_keymap("n", "<C-/>", "<Plug>(VM-Visual-Clear)", {})
      vim.api.nvim_set_keymap("n", "<C-Space>", "<Plug>(VM-Visual-Regex)", {})
      vim.api.nvim_set_keymap("n", "n", "<Plug>(VM-Find-Under)", {})
      vim.api.nvim_set_keymap("n", "N", "<Plug>(VM-Select-Next)", {})
      vim.api.nvim_set_keymap("n", "p", "<Plug>(VM-Select-Prev)", {})
      vim.api.nvim_set_keymap("n", "<C-s>", "<Plug>(VM-Insert)", {})
      vim.api.nvim_set_keymap("n", "<C-r>", "<Plug>(VM-Replace)", {})
    end,
  },

  -- Nvim-tree for file explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  -- Surround
  -- {
  --    'tpope/vim-surround',
  --    event = 'BufRead',
  -- },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },

  -- -- Vim-Markdown
  -- {
  --   'preservim/vim-markdown',
  --   ft = 'markdown',
  --   config = function()
  --     -- Custom configurations for vim-markdown
  --   end
  -- },

  -- Nvim-compe
  {
    "hrsh7th/nvim-compe",
    config = function()
      require("compe").setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = "enable",
        throttle_time = 80,
        source_timeout = 200,
        resolve_timeout = 800,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,

        source = {
          path = true,
          buffer = true,
          calc = true,
          nvim_lsp = true,
          nvim_lua = true,
          spell = true,
          tags = true,
          snippets_nvim = true,
          treesitter = true,
        },
      }
    end,
  },

  -- {
  --    "zbirenbaum/copilot-cmp",
  --    config = function ()
  --      require("copilot_cmp").setup()
  --    end
  --  },
  --
  --  {
  --    "MunifTanjim/prettier.nvim",
  --    config = function()
  --      require('prettier').setup({
  --        bin = 'prettier', -- hoặc 'prettierd' nếu bạn đã cài đặt prettierd
  --        filetypes = {
  --          "css",
  --          "javascript",
  --          "javascriptreact",
  --          "typescript",
  --          "typescriptreact",
  --          "json",
  --          "scss",
  --          "less",
  --          "html",
  --          "yaml",
  --          "markdown",
  --          "graphql"
  --        },
  --      })
  --    end
  --  },
  {
    "Wansmer/treesj",
    keys = {
      {
        "<leader>m",
        "<CMD>TSJToggle<CR>",
        desc = "Toggle Treesitter Join",
      },
    },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false },
  },
  {
    "mzlogin/vim-markdown-toc",
    config = function()
      -- set up
    end,
  },
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      -- set up
    end,
  },
  {
    "vim-pandoc/vim-pandoc",
    config = function()
      -- set up
    end,
  },
  {
    "amiorin/vim-eval",
    config = function()
      -- set up
    end,
  },
  {
    "fvictorio/vim-eval-expression",
    config = function()
      -- set up
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup {
        filetype = {
          cpp = {
            function()
              return {
                exe = "clang-format",
                args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
                stdin = true,
              }
            end,
          },
        },
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
    },
  },

  -- :cclose
  -- "ctrl + q", "zn", "zN"
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    opts = {},
  },

  -- :GitBlameOpenCommitURL
  -- :GitBlameOpenFileURL
  -- : GitBlameCopySHA
  -- {
  --   "f-person/git-blame.nvim",
  --   event = "VeryLazy",
  -- },

  -- :TroubleToggle
  -- :Trouble workspace_diagnostics
  -- :Trouble lsp_references
  -- :Trouble quickfix
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      { "<leader>x", desc = "Trouble" },
      { "<leader>x" .. "X", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>x" .. "x", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
      { "<leader>x" .. "q", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    },
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        close = { "q", "<esc>" },
        cancel = "<c-e>",
      },
    },
  },

  -- leap.nvim
  {
    "ggandor/leap.nvim",
    init = function()
      require("leap").add_default_mappings()
    end,
    dependencies = {
      "tpope/vim-repeat",
    },
    lazy = false,
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.cmd [[source ~/.config/nvim/coc-settings.json]]
    end,
  },
  {
    "psliwka/vim-smoothie",
    event = "VeryLazy",
  },
  {
    "mattn/emmet-vim",
  },
  {
    "maxmellon/vim-jsx-pretty",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  {
    "leafgarland/typescript-vim",
    ft = { "typescript", "typescriptreact" },
  },
  {
    "posva/vim-vue",
    ft = { "vue" },
  },
  {
    "othree/html5.vim",
    ft = { "html", "htmldjango" },
  },
  {
    "hail2u/vim-css3-syntax",
    ft = { "css", "scss", "less" },
  },
  -- 1. Conjure (for interactive programming with REPLs)
  { "Olical/conjure" },

  -- 2. jupyter.nvim (for Jupyter Notebooks integration)
  -- { "goerz/jupyter.nvim" },

  -- 3. nvim-compe (for autocompletion)
  { "hrsh7th/nvim-compe" },

  -- 4. Vim-Julia (for Julia language support)
  { "JuliaEditorSupport/julia-vim" },

  -- 5. Vim-Python-IDE (for Python development)
  { "kien/rainbow_parentheses.vim" },

  -- 6. coc.nvim (for LSP support)
  { "neoclide/coc.nvim", branch = "release" },

  -- 7. fugitive.vim (for Git integration)
  { "tpope/vim-fugitive" },

  -- 8. vim-ipython-cell (for running Python in IPython kernel)
  { "hanschen/vim-ipython-cell" },

  -- 9. snippets.nvim (for code snippets)
  { "norcalli/snippets.nvim" },

  -- 10. Telescope.nvim (for fuzzy finding)
  { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } },
  {
    "psf/black",
    ft = "python",
    config = function()
      vim.cmd [[autocmd BufWritePre *.py execute 'Black']]
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
        },
      }
    end,
  },
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup(--[[optional config]])
    end,
  },
  {
    "digitaltoad/vim-pug",
    ft = "pug",
  },
  {
    "TimUntersberger/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Cần thiết cho neogit
      "sindrets/diffview.nvim", -- Tích hợp với diffview để xem sự khác biệt giữa các commit
    },
    config = function()
      require('neogit').setup {
        disable_signs = false,  -- Không tắt các ký hiệu Git bên lề
        disable_hint = false,   -- Hiển thị gợi ý về các phím tắt
        disable_context_highlighting = false, -- Bật/tắt highlight theo ngữ cảnh
        disable_commit_confirmation = true, -- Tắt xác nhận khi commit
        auto_refresh = true,    -- Tự động refresh khi có thay đổi
        sort_branches = "-committerdate",  -- Sắp xếp nhánh theo ngày commit
        integrations = {
          diffview = true  -- Tích hợp với diffview để xem sự khác biệt
        },
        signs = {
          section = { ">", "v" },  -- Ký hiệu cho các phần mở rộng
          item = { ">", "v" },     -- Ký hiệu cho các mục mở rộng
          hunk = { "", "" },       -- Ký hiệu cho các thay đổi nhỏ
        },
        mappings = {
          status = {
            ["q"] = "Close",       -- Bản đồ phím tắt 'q' để đóng Neogit
            ["<tab>"] = "Toggle",  -- Bản đồ phím tắt Tab để chuyển đổi các mục
            ["1"] = "Depth1",      -- Chuyển đổi độ sâu
            ["2"] = "Depth2",
            ["3"] = "Depth3",
            ["4"] = "Depth4",
            ["$"] = "CommandHistory",  -- Hiển thị lịch sử lệnh
          }
        }
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",  -- Cần thiết cho diffview
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,  -- Bật highlight nâng cao cho sự khác biệt
        use_icons = true,         -- Sử dụng icon cho UI
        icons = {                 -- Tùy chỉnh icon cho các trạng thái
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
        },
        view = {
          default = {
            layout = "diff2_horizontal",  -- Layout mặc định khi so sánh 2 files theo chiều ngang
          },
          merge_tool = {
            layout = "diff3_mixed",  -- Layout mặc định cho công cụ merge
            disable_diagnostics = true,  -- Tắt chẩn đoán trong chế độ merge
          },
        },
        file_panel = {
          win_config = {
            position = "left",  -- Panel files sẽ mở ở bên trái
            width = 35,         -- Độ rộng của panel
          },
        },
        keymaps = {
          view = {
            ["<tab>"] = "ToggleFold",  -- Phím tắt Tab để gập/mở các phần khác nhau
            ["q"] = "Close",           -- Phím tắt q để đóng diffview
          },
          file_panel = {
            ["j"] = "NextEntry",       -- Di chuyển xuống entry tiếp theo
            ["k"] = "PrevEntry",       -- Di chuyển lên entry trước đó
            ["<cr>"] = "SelectEntry",  -- Chọn entry hiện tại để xem diff
            ["o"] = "ToggleFold",      -- Gập/mở thư mục
            ["R"] = "RefreshFiles",    -- Làm mới danh sách file
            ["<tab>"] = "ToggleFiles", -- Hiển thị/Tắt panel file
          },
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    config = function()
      require('ufo').setup({
        provider_selector = function(_, filetype, _)
          return filetype == 'markdown' and {'treesitter', 'indent'} or nil
        end,
      })

      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end
  },
}
