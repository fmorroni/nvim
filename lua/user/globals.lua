P = function(obj)
  print(vim.inspect(obj))
  return obj
end

LogNewBuf = function (obj)
  local buf = vim.api.nvim_create_buf(true, false)
  print("Logging to buffer: "..buf)
  local lines = {}
  for line in vim.inspect(obj):gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end
