return {
  settings = {
    texlab = {
      build = {
        args = {
          -- Here by default:
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "%f",
          -- Required for syntax highlighting inside the generated pdf apparently
          "-shell-escape",
        },
        executable = "latexmk",
        forwardSearchAfter = true,
        onSave = true,
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = true,
      },
    },
  },
}
