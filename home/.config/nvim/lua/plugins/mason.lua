return {
  -- 1. Core Mason Plugin (Corrected GitHub repository)
  {
    "williamboman/mason.nvim",
    config = true, -- Automatically runs require("mason").setup()
  },

  -- 2. Companion Plugin to actually enforce auto-installation
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Formatters matching your conform.nvim setup
        -- "prettier", -- JS/TS/HTML/CSS formatter
        -- "stylua",   -- Lua formatter
        -- "black",    -- Python formatter
        -- "isort",    -- Python import sorter

        -- LSPs are added in lspconfig.lua plugin - no need to add them here
      },
      auto_update = true, -- Keep tools updated automatically
      run_on_start = true, -- Install missing tools when Neovim opens
    },
  },
}
