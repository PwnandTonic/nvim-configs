-----------------------------------------
-- Lazy.nvim bootstrap (FIRST)*********
-----------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-----------------------------------------
-- Basic settings
-----------------------------------------

vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd("cd C:/Users/judge/dev")

-----------------------------------------
-- Git Bash shell
-----------------------------------------

vim.opt.shell = '"C:\\Program Files\\Git\\bin\\bash.exe"'
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-----------------------------------------
-- Plugins (Lazy)
-----------------------------------------

require("lazy").setup({

  { "neovim/nvim-lspconfig" },

  { "mason-org/mason.nvim", config = true },

  { "nvim-lua/plenary.nvim" },

  { "nvim-telescope/telescope.nvim" },

  { "hrsh7th/nvim-cmp" },

  { "hrsh7th/cmp-nvim-lsp" },

  { 
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "java", "lua", "vim", "vimdoc", "query" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        transparent = true,
      })
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "kanagawa",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          hijack_netrw_behavior = "open_default",
        },
        window = {
          width = 30,
        },
      })
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = function()
      vim.fn.system({
        "cmake",
        "-S.",
        "-Bbuild",
        "-DCMAKE_BUILD_TYPE=Release",
      })
      vim.fn.system({
        "cmake",
        "--build",
        "build",
        "--config",
        "Release",
        "--target",
        "install",
    })
  end,
},

{
  "KieranCanter/candela.nvim",
  config = function()
    require("candela").setup({})
  end,
},

})

require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

pcall(require("telescope").load_extension, "fzf")

--------------------------------------
--UI Tweaks
--------------------------------------

vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "Normal", {bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", {bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", {bg = "none" })

vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8

local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

cmp.setup({
  completion = {
    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

-----------------------------------------
-- Plugin configuration
-----------------------------------------

require("mason").setup()

vim.lsp.config("pyright", {
  capabilities = capabilities,
})
vim.lsp.enable("pyright")

vim.lsp.config("jdtls", {
  cmd = { "jdtls" },
  capabilities = capabilities,
})
vim.lsp.enable("jdtls")

require("telescope").setup({})

-----------------------------------------
-- Keymaps
-----------------------------------------

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle filesystem left<CR>")
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>")
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>")
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>")
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>")
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)