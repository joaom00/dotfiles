vim.opt.pumblend = 3 -- Make popup window translucent
vim.opt.number = false
vim.opt.relativenumber = false
-----------------------------------------------------------------------------//
-- Message output on vim actions {{{1
-----------------------------------------------------------------------------//
vim.opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  c = true,
  W = true, -- Don't show [w] or written when writing
}
-----------------------------------------------------------------------------//
-- Timings {{{1
-----------------------------------------------------------------------------//
vim.opt.updatetime = 100
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
-----------------------------------------------------------------------------//
-- Window splitting and buffers {{{1
-----------------------------------------------------------------------------//
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.eadirection = "hor"
vim.opt.switchbuf = "useopen,uselast"
vim.opt.fillchars = {
  fold = " ",
  eob = " ", -- suppress ~ at EndOfBuffer
  diff = "╱", -- alternatives = ⣿ ░ ─
  msgsep = "‾",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
}
-----------------------------------------------------------------------------//
-- Diff {{{1
-----------------------------------------------------------------------------//
-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
vim.opt.diffopt = vim.opt.diffopt
  + {
    "vertical",
    "iwhite",
    "hiddenoff",
    "foldcolumn:0",
    "context:4",
    "algorithm:histogram",
    "indent-heuristic",
  }
-----------------------------------------------------------------------------//
-- Format Options {{{1
-----------------------------------------------------------------------------//
vim.opt.formatoptions = {
  ["1"] = true,
  ["2"] = true, -- Use indent from 2nd line of a paragraph
  q = true, -- continue comments with gq"
  c = true, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}
-----------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
vim.o.foldlevelstart = 10
-- vim.wo.foldcolumn = "1"
-- vim.wo.foldlevel = 99
-- vim.wo.foldenable = true
-- vim.opt.foldtext = "v:lua.JM.folds()"
-- vim.opt.foldopen = vim.opt.foldopen + "search"
-- vim.opt.foldlevelstart = 3
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldmethod = "expr"

-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.wo.foldtext =
--   [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
-- vim.wo.foldnestmax = 3
-- vim.wo.foldminlines = 1

-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
vim.opt.conceallevel = 2
vim.opt.breakindentopt = "sbr"
vim.opt.linebreak = true -- lines wrap at words rather than random characters
vim.opt.synmaxcol = 1024 -- don't syntax highlight long lines
-- vim.opt.signcolumn = "number"
-- vim.opt.signcolumn = "auto:2-5"
vim.opt.signcolumn = "yes:1"
vim.opt.ruler = false
vim.opt.cmdheight = 1 -- Set command line height to two lines
vim.opt.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
--- This is used to handle markdown code blocks where the language might
--- be set to a value that isn't equivalent to a vim filetype
vim.g.markdown_fenced_languages = {
  "js=javascript",
  "ts=typescript",
  "shell=sh",
  "bash=sh",
  "console=sh",
}
-----------------------------------------------------------------------------//
-- List chars {{{1
-----------------------------------------------------------------------------//
vim.opt.list = true -- invisible chars
-- vim.opt.listchars = {
--   eol = "↲",
--   tab = "│ ",
--   extends = "»", -- Alternatives: … » ›
--   precedes = "«", -- Alternatives: … « ‹
--   trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
-- }
-----------------------------------------------------------------------------//
-- Indentation
-----------------------------------------------------------------------------//
vim.opt.wrap = true
vim.opt.wrapmargin = 2
vim.opt.textwidth = 100
vim.opt.autoindent = true
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
-----------------------------------------------------------------------------//
-- vim.o.debug = "msg"
vim.opt.gdefault = true
vim.opt.pumheight = 15
vim.opt.confirm = true -- make vim prompt me to save before doing destructive things
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.hlsearch = true
vim.opt.autowriteall = true -- automatically :write before running commands and changing files
vim.opt.clipboard = { "unnamedplus" }
vim.opt.laststatus = 3
vim.opt.termguicolors = true
vim.opt.guifont = "monospace:h17"
-----------------------------------------------------------------------------//
-- Emoji {{{1
-----------------------------------------------------------------------------//
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
vim.opt.emoji = false
-----------------------------------------------------------------------------//
-- Cursor {{{1
-----------------------------------------------------------------------------//
vim.opt.cursorline = true
-- vim.opt.guicursor = {
--   [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]],
--   [[a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]],
--   [[sm:block-blinkwait175-blinkoff150-blinkon175]],
-- }
vim.opt.cursorlineopt = "screenline,number"
-----------------------------------------------------------------------------//
-- Title {{{1
-----------------------------------------------------------------------------//
vim.opt.titlestring = " ❐ %t %r %m"
vim.opt.titleold = vim.fn.fnamemodify(vim.loop.os_getenv "SHELL", ":t")
vim.opt.title = true
vim.opt.titlelen = 70
-----------------------------------------------------------------------------//
-- Utilities {{{1
-----------------------------------------------------------------------------//
vim.opt.showmode = false
vim.opt.sessionoptions = {
  "globals",
  "buffers",
  "curdir",
  "help",
  "winpos",
  -- "tabpages",
}
vim.opt.viewoptions = { "cursor", "folds" } -- save/restore just these (with `:{mk,load}view`)
vim.opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
-------------------------------------------------------------------------------
-- BACKUP AND SWAPS {{{
-------------------------------------------------------------------------------
vim.opt.backup = false
vim.opt.writebackup = false
-- if vim.fn.isdirectory(vim.o.undodir) == 0 then
--   vim.fn.mkdir(vim.o.undodir, "p")
-- end
-- vim.opt.undofile = true
vim.opt.swapfile = false
-- The // at the end tells Vim to use the absolute path to the file to create the swap file.
-- This will ensure that swap file name is unique, so there are no collisions between files
-- with the same name from different directories.
vim.opt.directory = vim.fn.stdpath "data" .. "/swap//"
if vim.fn.isdirectory(vim.o.directory) == 0 then
  vim.fn.mkdir(vim.o.directory, "p")
end
-----------------------------------------------------------------------------//
-- Match and search {{{1
-----------------------------------------------------------------------------//
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true -- Searches wrap around the end of the file
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.sidescroll = 1
-----------------------------------------------------------------------------//
-- Spelling {{{1
-----------------------------------------------------------------------------//
vim.opt.spellsuggest:prepend { 12 }
vim.opt.spelloptions = "camel"
vim.opt.spellcapcheck = "" -- don't check for capital letters at start of sentence
vim.opt.fileformats = { "unix", "mac", "dos" }
-----------------------------------------------------------------------------//
-- Mouse {{{1
-----------------------------------------------------------------------------//
vim.opt.mouse = "a"
vim.opt.mousefocus = true
-----------------------------------------------------------------------------//
-- these only read ".vim" files
vim.opt.secure = true -- Disable autocmd etc for project local vimrc files.
vim.opt.exrc = true -- Allow project local vimrc files example .nvimrc see :h exrc
