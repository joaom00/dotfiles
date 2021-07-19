require'utils'.define_augroups {autoformat = {{'BufWritePost', '*', ':silent FormatWrite'}}}

local status_ok, formatter = pcall(require, 'formatter')
if not status_ok then return end

