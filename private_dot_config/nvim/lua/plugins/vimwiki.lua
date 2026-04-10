local wiki_root = vim.fn.expand("~/work/vvarma/wiki")

local function trim(input)
  return vim.trim(input or "")
end

local function ensure_file(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  vim.fn.mkdir(dir, "p")

  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({}, path)
  end
end

local function normalize_page_name(input)
  local page = trim(input)
  if page == "" then
    return nil
  end

  page = page:gsub("\\", "/")
  page = page:gsub("^/+", "")
  page = page:gsub("/+", "/")

  if page == "" then
    return nil
  end

  for part in page:gmatch("[^/]+") do
    if part == "." or part == ".." then
      return nil, "Wiki pages must stay inside the wiki root"
    end
  end

  if not page:match("%.md$") then
    page = page .. ".md"
  end

  return page
end

local function open_new_page()
  vim.ui.input({ prompt = "New wiki page: " }, function(input)
    local page, err = normalize_page_name(input)
    if not page then
      if err then
        vim.notify(err, vim.log.levels.ERROR)
      end
      return
    end

    local path = wiki_root .. "/" .. page
    ensure_file(path)
    vim.cmd.edit(vim.fn.fnameescape(path))
  end)
end

local function search_wiki()
  vim.ui.input({ prompt = "Wiki search: " }, function(input)
    local pattern = trim(input)
    if pattern == "" then
      return
    end

    vim.api.nvim_cmd({
      cmd = "VimwikiSearch",
      args = { pattern },
    }, {})
  end)
end

return {
  {
    "vimwiki/vimwiki",
    lazy = false,
    init = function()
      vim.g.vimwiki_list = {
        {
          path = wiki_root .. "/",
          syntax = "markdown",
          ext = ".md",
          diary_rel_path = "diary/",
        },
      }
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_markdown_link_ext = 1
    end,
    keys = {
      {
        "<leader>ww",
        function()
          ensure_file(wiki_root .. "/index.md")
          vim.cmd.VimwikiIndex()
        end,
        desc = "Wiki Index",
      },
      {
        "<leader>wt",
        function()
          ensure_file(wiki_root .. "/index.md")
          vim.cmd.VimwikiTabIndex()
        end,
        desc = "Wiki Index Tab",
      },
      {
        "<leader>wd",
        function()
          vim.cmd.VimwikiDiaryIndex()
        end,
        desc = "Wiki Diary Index",
      },
      {
        "<leader>wy",
        function()
          vim.cmd.VimwikiMakeDiaryNote()
        end,
        desc = "Wiki Diary Today",
      },
      {
        "<leader>ws",
        search_wiki,
        desc = "Wiki Search",
      },
      {
        "<leader>wn",
        open_new_page,
        desc = "Wiki New Page",
      },
    },
  },
}
