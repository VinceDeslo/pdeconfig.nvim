local dap = require 'dap'
local go = require 'dap-go'

local function setup_dap()
    vim.keymap.set('n', '<leader>db', function() dap.set_breakpoint() end, { desc = '[db] Debug: Set breakpoint' })
    vim.keymap.set('n', '<leader>dt', function() dap.toggle_breakpoint() end, { desc = '[dt] Debug: Toggle breakpoint' })
    vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = '[dc] Debug: Continue' })
    vim.keymap.set('n', '<leader>dn', function() dap.step_over() end, { desc = '[dn] Debug: Step Next' })
    vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = '[di] Debug: Step Into' })
    vim.keymap.set('n', '<leader>do', function() dap.step_out() end, { desc = '[do] Debug: Step Out' })
end

local function setup_dap_go()
    go.setup()
end

local function init()
    setup_dap_go()
    setup_dap()
end

return {
    init = init
}
