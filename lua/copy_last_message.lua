local opts = maki.api.register_options({
  cmd = {
    default = "pbcopy",
    desc = "Shell command that copies standard input to your clipboard, such as pbcopy or wl-copy.",
  },
})

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

maki.api.register_command({
  name = "copy_last_message",
  description = "Copy the latest assistant message to the system clipboard.",
  handler = function()
    local messages, err = maki.session.messages()
    if not messages then
      maki.notify("copy_last_message: " .. tostring(err), "error")
      return
    end

    local last
    for i = #messages, 1, -1 do
      local message = messages[i]
      if message.role == "assistant" and (message.kind == nil or message.kind == "turn") and message.display_text == nil then
        last = message
        break
      end
    end

    if not last then
      maki.notify("copy_last_message: no assistant message found", "warn")
      return
    end

    local text = {}
    for _, block in ipairs(last.content or {}) do
      if block.type == "text" then
        text[#text + 1] = block.text
      end
    end
    local content = table.concat(text)
    if content == "" then
      maki.notify("copy_last_message: latest assistant message has no text", "warn")
      return
    end

    local _, start_err = maki.fn.jobstart("printf %s " .. shell_quote(content) .. " | " .. opts.cmd, {
      scope = "plugin",
      on_exit = function(_, code)
        if code == 0 then
          maki.ui.flash("Copied latest assistant message")
        else
          maki.notify("copy_last_message: " .. opts.cmd .. " exited with status " .. tostring(code), "error")
        end
      end,
    })
    if start_err then
      maki.notify("copy_last_message: " .. start_err, "error")
    end
  end,
})