return {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup {
          extensions = {
            file_browser = {
              hijack_netrw = true,
              grouped = true,
              auto_depth = true,
              prompt_path = true,
              select_buffer = true,
              display_stat = false,
              dir_icon = " ",
              hidden = {
                file_browser = true,
                folder_browser = false,
              },
              git_status = true,
              mappings = {
                ["i"] = {
                  ["<bs>"] = false  -- disable <bs> from going back to parent dir.
                },
              },
            },
          },
        }
        require("telescope").load_extension "file_browser"
    end
}
