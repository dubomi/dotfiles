return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    -- Custom LSP component to show attached language servers
    local function lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return "No LSP"
      end
      local names = {}
      for _, client in ipairs(clients) do
        table.insert(names, client.name)
      end
      return " " .. table.concat(names, ", ")
    end

    -- Define active sections once so top and bottom bars are identical
    local active_sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
        "diff",
      },
      lualine_c = {
        {
          "filename",
          path = 1, -- Relative path (e.g., lua/plugins/git.lua)
          symbols = {
            modified = " ●",
            readonly = " 🔒",
            unnamed = "[No Name]",
          },
        },
      },
      lualine_x = {
        "diagnostics",
        lsp_status,
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    }

    -- Define inactive sections once
    local inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          path = 1,
        },
      },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    }

    return {
      options = {
        -- Powerline arrows setup
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- Per-split statusline (separate statusline per split window)
        globalstatus = false,
        disabled_filetypes = {
          statusline = { "NvimTree", "neo-tree" },
          winbar = { "NvimTree", "neo-tree" },
        },
      },
      -- Bottom Statusline
      sections = active_sections,
      inactive_sections = inactive_sections,

      -- Top Winbar (Identical to bottom)
      winbar = active_sections,
      inactive_winbar = inactive_sections,
    }
  end,
}
