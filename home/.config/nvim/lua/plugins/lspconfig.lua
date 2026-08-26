return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Inline diagnostics configuration
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
      })

      -- Set global capabilities for all servers (Blink.cmp integration)
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Native Neovim 0.11 server settings configuration
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- MASTER LSP SERVER LIST
      -- They only spawn if the binary is discovered on the PATH.
      local lsp_servers = {
        -- Global Baseline Servers (Always available via home.nix)
        "lua_ls",
        "nixd",
        "marksman",
        "jsonls",
        "html",
        "cssls",
        "eslint",
        "terraformls",

        -- Project-Specific Ecosystem Servers (Loaded dynamically from flake.nix)
        "pyright", -- Python
        "ts_ls", -- JavaScript / TypeScript (formerly tsserver)
        "gopls", -- Go
        "rust_analyzer", -- Rust
      }
      -- Automatically search and launch them using native management
      vim.lsp.enable(lsp_servers)
    end,
  },
}
