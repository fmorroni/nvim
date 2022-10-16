local status_ok, leap = pcall(require, "leap")
if not status_ok then
  return
end

leap.add_default_mappings()
vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
