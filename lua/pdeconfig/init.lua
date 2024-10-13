local function init()
    require 'pdeconfig.vim'.init()
    require 'pdeconfig.theme'.init()
    require 'pdeconfig.telescope'.init()
end

return {
    init = init,
}
