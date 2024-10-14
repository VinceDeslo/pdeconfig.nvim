local function init()
    require 'pdeconfig.vim'.init()
    require 'pdeconfig.theme'.init()
    require 'pdeconfig.telescope'.init()
    require 'pdeconfig.treesitter'.init()
end

return {
    init = init,
}
