return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      enabled = true,
      hidden = true,
      sources = {
        files = {
          hidden = true, -- Shows hidden files by default when searching
        },
      },
      exclude = {
        ".git",
        ".venv",
        ".direnv",
        "node_modules",
        "target",
        "build",
        "dist",
      },
    },
    notifier = { enabled = true },
    input = { enabled = true },
  },
  -- stylua: ignore start
  keys = {
    { '<leader>t', function() Snacks.picker.files() end,                desc = 'Open/Find Files' },
    { '<leader>s', function() Snacks.picker.grep() end,                 desc = 'Search Text' },
    { '<leader>b', function() Snacks.picker.buffers() end,              desc = 'Buffers' },
    { 'gd',        function() Snacks.picker.lsp_definitions() end,      desc = 'Goto Definition' },
    { "<leader>dd", function() Snacks.picker.diagnostics() end,         desc = "Buffer Diagnostics" },
    { "<leader>dD", function() Snacks.picker.project_diagnostics() end, desc = "Project Diagnostics" }
  },
  -- stylua: ignore end
}
