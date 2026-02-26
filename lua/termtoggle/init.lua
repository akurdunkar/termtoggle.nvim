local M = {}

local state = { win = nil, buf = nil, started = false }

local defaults = {
    height = 20,
    shell = vim.o.shell,
    border = "rounded",
    bg = nil,
    keymap = "<M-m>",
}

local config = {}

local function valid_win()
    return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function valid_buf()
    return state.buf and vim.api.nvim_buf_is_valid(state.buf)
end

local function close()
    if valid_win() then
        vim.api.nvim_win_close(state.win, true)
    end
    state.win = nil
end

local function open()
    local ui = vim.api.nvim_list_uis()[1]

    state.win = vim.api.nvim_open_win(state.buf, true, {
        relative = "editor",
        width = ui.width - 4,
        height = config.height,
        col = 1,
        row = ui.height - config.height - 4,
        border = config.border,
    })

    vim.wo[state.win].number = false
    vim.wo[state.win].relativenumber = false

    if config.bg then
        local ns = vim.api.nvim_create_namespace("termtoggle")
        vim.api.nvim_set_hl(ns, "Normal", { bg = config.bg })
        vim.api.nvim_win_set_hl_ns(state.win, ns)
    end
end

local function toggle()
    if valid_win() then
        close()
        return
    end

    if not valid_buf() then
        state.buf = vim.api.nvim_create_buf(false, true)
        state.started = false
    end

    open()

    if not state.started then
        vim.cmd("term " .. config.shell)
        vim.bo.buflisted = false
        state.buf = vim.api.nvim_get_current_buf()
        state.started = true
    end
end

function M.setup(opts)
    config = vim.tbl_deep_extend("force", defaults, opts or {})

    local group = vim.api.nvim_create_augroup("termtoggle", { clear = true })

    vim.api.nvim_create_autocmd("VimResized", {
        group = group,
        callback = function()
            if valid_win() then
                close()
                open()
            end
        end,
    })

    vim.api.nvim_create_autocmd("TermClose", {
        group = group,
        callback = function()
            if vim.api.nvim_get_current_win() == state.win then
                close()
                state.started = false
            end
        end,
    })

    vim.keymap.set({ "n", "t" }, config.keymap, toggle, { silent = true })
end

M.toggle = toggle

return M
