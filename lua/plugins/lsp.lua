return{
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      mason_lspconfig.setup({
        ensure_installed = {
          "asm_lsp",
          "clangd",
          "glsl_analyzer",
          "cmake",
          "lua_ls",
          "texlab",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },

    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      vim.filetype.add({
        extension = {
          vs = "glsl",
          fs = "glsl",
          gs = "glsl",
          cms = "glsl",
        },
      })

      vim.diagnostic.config({
        virtual_text = {
          prefix = "",
          spacing = 0,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
        float = {
          source = "always",
          border = "rounded",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      lspconfig["clangd"].setup({
        cmd = {
          "/usr/bin/clangd",
          "--background-index",
          "--pch-storage=memory",
          "--all-scopes-completion",
          "--pretty",
          "--header-insertion=never",
          "-j=4",
          "--header-insertion-decorators",
          "--function-arg-placeholders=0",
          "--completion-style=detailed",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = require("lspconfig").util.root_pattern("src"),
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig["glsl_analyzer"].setup({
        cmd = { "glsl_analyzer" },
        filetypes = { "glsl" },
        root_dir = lspconfig.util.root_pattern(".git", "."),
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig["texlab"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig["asm_lsp"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "asm", },
      })
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local cmp = require'cmp'

      cmp.setup({
        snippet = {
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          -- { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      hint_prefix = "",
      floating_window = false,
      bind = true,
    },
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  }
}
