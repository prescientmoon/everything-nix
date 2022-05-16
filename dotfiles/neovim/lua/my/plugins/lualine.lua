local M = {}

function M.setup()
    require('lualine').setup({
        theme = vim.g.lualineTheme,
        options = {
            section_separators = {left = '', right = ''},
            component_separators = {left = '', right = ''}
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {},
            lualine_y = {'encoding', 'fileformat', 'filetype'},
            lualine_z = {'location'}
        },
        -- Integration with other plugins
        extensions = {"nvim-tree"}
    })
end

return M
