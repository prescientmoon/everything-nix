local bin_name = 'agda-language-server'
local cmd = {bin_name, '--stdio'}

if vim.fn.has 'win32' == 1 then cmd = {'cmd.exe', '/C', bin_name, '--stdio'} end

return {
    default_config = {
        cmd = cmd,
        filetypes = {'agda'}
        -- root_dir = util.root_pattern('bower.json', 'psc-package.json', 'spago.dhall'),
    }
}
