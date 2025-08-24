return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      proto = { "clang_format" },
      bzl = { "buildifier" },
    },
    formatters = {
      clang_format = {
        args = { "-style=file", "-assume-filename", "$FILENAME" },
      },
    },
  },
}
