-------------------------------------------------------------------------------
-- Plugin:      conform.nvim
-- GitHub:      https://github.com/stevearc/conform.nvim
-- Description: Format-on-save plugin that manages external CLI code formatters.
-- Setup:       Using local project binaries before falling back to global binaries managed by home.nix.
-------------------------------------------------------------------------------
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- Lazy load for speed
  config = function()
    local conform = require("conform")

    conform.setup({
      -- Map filetypes to specific external formatters
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "alejandra" },
        json = { "jq" },
        yaml = { "yamlfmt" },
        terraform = { "terraform_fmt" }, -- Add the native Terraform mapping
        hcl = { "terraform_fmt" }, -- Covers raw HashiCorp Configuration Language files
        python = { "ruff_format" }, -- Runs sequentially
        javascript = { "prettierd", "prettier", stop_after_first = true }, -- Fallback chain
        typescript = { "prettierd", "prettier", stop_after_first = true },

        -- Languages where LSP formatting is excellent out-of-the-box.
        -- Setting these to empty arrays `{}` tells Conform:
        -- "Do not look for a CLI tool, look directly at the LSP fallback path."
        rust = {},
        go = {},
      },

      -- Customize formatter args directly (ensures ruff_format uses fast stdin)
      formatters = {
        ruff_format = {
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
        },
      },

      -- Smart Format-on-Save Logic
      format_on_save = function(bufnr)
        -- Check if the current filetype uses a dedicated formatter from our map
        local formatter_list = conform.list_formatters(bufnr)

        -- If a CLI formatter is mapped and available, use it without falling back to LSP.
        -- This prevents LSPs like nixd or lua_ls from fighting CLI tools.
        if #formatter_list > 0 then
          return {
            lsp_fallback = false,
            timeout_ms = 500,
          }
        end

        -- If no CLI formatter is specified (like Rust or Go), fall back to the LSP natively.
        return {
          lsp_fallback = true,
          timeout_ms = 1000, -- Give LSPs a little more time to respond than local binaries
        }
      end,
    })

    -- Optional: Manual trigger hotkey (Space + f)
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file or range" })
  end,
}
