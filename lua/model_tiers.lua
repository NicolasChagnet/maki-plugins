-- Keybinds to jump between model tiers
local tiers = {
    { key = "<C-1>", tier = "weak"  },
    { key = "<C-2>", tier = "medium" },
    { key = "<C-3>", tier = "strong" },
}

for _, t in ipairs(tiers) do
    maki.keymap.set({ "n", "i" }, t.key, function()
        local spec = maki.model.tier(t.tier)
        if spec == nil then
            maki.notify("Could not resolve tier " .. t.tier)
        end
        local ok, err = maki.model.set(spec)
        if not ok then
            maki.notify(t.tier .. " model failed: " .. err, "error")
        end
    end, { desc = "Switch to " .. t.tier })
end
