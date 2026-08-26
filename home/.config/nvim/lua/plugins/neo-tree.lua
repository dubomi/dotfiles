-------------------------------------------------------------------------------
-- Plugin:      neo-tree.nvim
-- GitHub:      https://github.com/nvim-neo-tree/neo-tree.nvim
-- Description: A sidebar file explorer plugin for browsing the file system and project structures in Neovim.
-- Setup:       Mapped with `<C-v>` for vertical split and `<C-s>` for horizontal split to mirror Snacks picker muscle memory while preserving native `v` visual selection mode.
-------------------------------------------------------------------------------
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Adds visual file icons
    "MunifTanjim/nui.nvim",
  },

  keys = {
    { "<leader>e", "<cmd>Neotree focus<cr>", desc = "Explorer NeoTree" },
  },

  opts = {
    window = {
      mappings = {
        ["<C-s>"] = "open_split", -- Horizontal split (top / bottom)
        ["<C-v>"] = "open_vsplit", -- Vertical split (side-by-side)
        ["l"] = "toggle_or_open_and_stay", -- Custom space mapping to open the file and stay focused in neo-tree,
      },
    },
    filesystem = {
      filtered_items = {
        visible = true, -- Set to true if you want to see hidden files by default
      },
      follow_current_file = {
        enabled = true, -- Automatically expands the tree to reveal your open file
      },
    },
    commands = {
      toggle_or_open_and_stay = function(state)
        local node = state.tree:get_node()

        if node.type == "directory" then
          -- Toggle folder open/closed
          require("neo-tree.sources.filesystem.commands").toggle_node(state)
        else
          -- Call the standard open command from the filesystem module
          require("neo-tree.sources.filesystem.commands").open(state)

          -- Schedule Neo-tree to steal focus back right after opening
          vim.schedule(function()
            vim.cmd([[Neotree focus]])
          end)
        end
      end,
    },
  },
}
