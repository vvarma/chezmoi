return {
  "mfussenegger/nvim-dap",
  -- config = function()
  --   local dap = require("dap")
  --   dap.adapters.lldb = {
  --     type = "server",
  --     host = "127.0.0.1",
  --     port = 13000,
  --     executable = {
  --       command = "/usr/local/bin/codelldb",
  --       args = { "--port", "13000" },

  --       -- on windows you may have to uncomment this:
  --       -- detached = false,
  --     },
  --   }
  --   dap.configurations.rust = {
  --     {
  --       name = "Launch",
  --       type = "codelldb",
  --       request = "launch",
  --       program = function()
  --         return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
  --       end,
  --       cwd = "${workspaceFolder}",
  --       stopOnEntry = false,
  --     },
  --   }
  -- end,
}
