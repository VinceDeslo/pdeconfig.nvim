local function init()
    require 'pdeconfig.vim'.init()
    require 'pdeconfig.theme'.init()
end

return {
    init = init,
}
