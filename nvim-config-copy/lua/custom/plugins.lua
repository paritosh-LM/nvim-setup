return {
   {
    "nvim-neotest/nvim-nio",
    event = "VeryLazy",
    -- no config() call here
  },
  -- Core debug client
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function() require("custom.dap").setup() end,
  },
  -- A floating UI for nvim-dap
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    config = function() require("dapui").setup() end,
  },
  -- Show virtual text for variables, etc.
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    config = function() require("nvim-dap-virtual-text").setup() end,
  },
  -- Mason integration to install adapters
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "jsdebug", "chrome" },
      })
    end,
  },
{
  "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup({ default = true })
  end,
}
}

