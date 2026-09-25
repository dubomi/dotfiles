-------------------------------------------------------------------------------
-- Plugin:      blink.cmp
-- GitHub:      https://github.com/Saghen/blink.cmp
-- Description: Completion plugin written in Rust and Lua for Neovim.
-- Setup:       Integrated globally in lspconfig.lua using `vim.lsp.config("*", { capabilities = ... })` to provide completion capabilities across all active LSP servers.
-------------------------------------------------------------------------------
return {
  {
    "saghen/blink.cmp",
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    version = "1.*", -- track the v1 release line
    event = "InsertEnter", -- load the first time you start typing
    opts = {
      -- <CR> accepts the highlighted item; <C-n>/<C-p> or <Up>/<Down> move;
      -- <C-space> toggles the menu; <C-e> hides it.
      keymap = { preset = "enter" },

      -- pure-lua matcher so no prebuilt Rust binary is fetched (keeps the nix setup self-contained)
      fuzzy = { implementation = "lua" },

      completion = {
        -- don't force-select the first item; you choose deliberately
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = { border = "rounded" },
        -- docs popup for the highlighted item; blink renders these itself,
        -- so nixd's `documentation: null` items no longer spam a warning
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
      },

      -- experimental
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          lsp = { score_offset = 100 },
          snippets = { score_offset = 80 },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 50,
            async = true,
          },
        },
      },
    },
  },
}
