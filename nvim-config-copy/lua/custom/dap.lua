
require("dap").set_log_level("DEBUG")
vim.fn.setenv("DAP_LOG_PATH", vim.fn.stdpath("cache") .. "/dap.log")
local M = {}


require("mason-nvim-dap").setup({
  ensure_installed  = { "js-debug-adapter" },
  automatic_setup   = true,          -- ← turn off the built‑in server adapter
})

function M.setup()
  local dap    = require("dap")
  local dapui = require("dapui")

  -- Open/close UI automatically
  dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui"]     = function() dapui.close() end

  -- ==== Python adapter ====
  dap.adapters.python = {
    type    = "executable",
    command = "python3",
    args    = { "-m", "debugpy.adapter" },
  }
  dap.configurations.python = {
    {
      type   = "python",
      request= "launch",
      name   = "Launch file",
      program= "${file}",
      cwd    = vim.fn.getcwd(),
      pythonPath = function()
        local venv = vim.fn.getcwd() .. "/venv/bin/python"
        if vim.fn.executable(venv) == 1 then return venv end
        return "python"
      end,
    },
  }

  -- ==== Node.js adapter ====
  -- dap.adapters.node2 = {
  --   type    = "executable",
  --   command = "node",
  --   args    = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", },
  -- }
  -- 
-- Only if you need to override the mason auto‑setup:
local js_debug = vim.fn.stdpath("data")
  .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
dap.adapters["pwa-node"] = {
type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    -- 💀 Make sure to update this path to point to your installation
    args = {js_debug, "${port}"},
  }
  }
  dap.configurations.javascript = {
    {
      name    = "Launch Node",
      type    = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd     = vim.loop.cwd(),
      sourceMaps = true,
      protocol   = "inspector",
      stopOnEntry = false
    },
  }

  -- ==== Key mappings ====
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }
  map("n", "<F5>",  "<Cmd>lua require'dap'.continue()<CR>",     opts)
  map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>",    opts)
  map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>",    opts)
  map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>",     opts)
  map("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
  map("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Condition: '))<CR>", opts)
  map("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
  map("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>",  opts)
end

return M

