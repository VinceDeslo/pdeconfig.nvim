local function init()
    require 'pdeconfig.vim'.init()
    require 'pdeconfig.theme'.init()
    require 'pdeconfig.telescope'.init()
    require 'pdeconfig.treesitter'.init()
    require 'pdeconfig.lsp'.init()
    require 'pdeconfig.completions'.init()
    require 'pdeconfig.ai'.init()
end

return {
    init = init,
}
