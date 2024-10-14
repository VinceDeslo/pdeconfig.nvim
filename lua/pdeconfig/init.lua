local function init()
    require 'pdeconfig.vim'.init()
    require 'pdeconfig.theme'.init()
    require 'pdeconfig.telescope'.init()
    require 'pdeconfig.treesitter'.init()
    require 'pdeconfig.lsp'.init()
end

return {
    init = init,
}
