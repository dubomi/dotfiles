-------------------------------------------------------------------------------
-- Plugin:      nvim-treesitter
-- GitHub:      https://github.com/nvim-treesitter/nvim-treesitter
-- Description: An interface to the Tree-sitter parsing library for high-speed, syntax-aware code highlighting, folding, and indenting in Neovim.
-- Setup:       Configured on the `main` branch using `ts.install()` and `FileType` autocmds for languages like Lua, Nix, Terraform, HCL, Python, and TS/JS.
-------------------------------------------------------------------------------
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- the rewrite; different API from the old master branch
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate", -- keep parsers in sync when the plugin updates
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup() -- install parsers into stdpath('data')/site

      -- parsers to install (compiled by the tree-sitter CLI, needs a C compiler)
      -- this would tipically require C compilers to be added to home.nix, but if XCode command line tools are installed, not need to add them
      ts.install({
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "go",
        "rust",
        "nix",
        "python",
        "java", -- syntax highlighting only; LSP (jdtls) and formatting are added at the project devshell level, not here
        "markdown",
        "markdown_inline",
        "json",
        "json5",
        "html",
        "css",
        "scss",
        "terraform",
        "hcl",
      })

      -- highlighting + treesitter indentation are enabled per filetype
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "go",
          "rust",
          "nix",
          "python",
          "java",
          "markdown",
          "json",
          "json5",
          "html",
          "css",
          "scss",
          "terraform",
          "hcl",
        },
        callback = function()
          vim.treesitter.start() -- syntax highlighting via neovim's built-in treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
