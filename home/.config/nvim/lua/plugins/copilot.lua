-------------------------------------------------------------------------------
-- Plugin:      copilot.lua + blink-cmp-copilot
-- GitHub:      https://github.com/zbirenbaum/copilot.lua
--              https://github.com/giuxtaposition/blink-cmp-copilot
-- Description: GitHub Copilot completions surfaced through blink.cmp.
--              Run :Copilot auth once to authenticate on a new machine.
-------------------------------------------------------------------------------
return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false }, -- handled by blink-cmp-copilot
      panel = { enabled = false },
    },
  },
}
