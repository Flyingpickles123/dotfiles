return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<Esc>"] = require("telescope.actions").close,
        },
        n = {
          ["q"] = require("telescope.actions").close,
        },
      },
    },
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
      },
    },
  },
  keys = {
    { "<c-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    {
      "<c-f>",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Find (global)",
    },
    {
      "<c-e>",
      function()
        require("telescope.builtin").live_grep({ search_dirs = { vim.fn.expand("%:p") } })
      end,
      desc = "Find (global)",
    },
  },
}
