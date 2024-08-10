return {
  'LintaoAmons/cd-project.nvim',
  lazy = true,
  cmd = { 'CdProject', 'CdProjectAdd', 'CdProjectTab', 'CdSearchAndAdd', 'CdProjectDelete' },
  config = function()
    require('cd-project').setup {
      projects_config_filepath = vim.fs.normalize(vim.fn.stdpath 'config' .. '/cd-project.nvim.json'),
      project_dir_pattern = { '.git', '.gitignore', 'Cargo.toml', 'package.json', 'go.mod' },
      choice_format = 'both',
      projects_picker = 'telescope',
      hooks = {
        {
          callback = function(dir)
            vim.notify('switched to dir: ' .. dir)
          end,
        },
        {
          callback = function(_)
            vim.cmd 'Neotree'
          end,
        },
      },
    }
  end,
}
