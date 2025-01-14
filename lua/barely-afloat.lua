local new_command = function(command, opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- new scratch buffer without a file
    local buf = vim.api.nvim_create_buf(false, true)

    -- new float
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    if vim.bo[buf].buftype ~= "terminal" then
        vim.cmd.terminal(command)
        vim.cmd.startinsert()
    end
    vim.api.nvim_create_autocmd('TermClose', {
        buffer = buf,
        callback = function()
            -- TODO: check if win exists
            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(buf, { force = true, unload = true })
        end,
    })
    -- vim.api.nvim_create_autocmd('BufWinLeave', {
    --     buffer = buf,
    --     callback = function()
    --         vim.cmd.terminal("exit")
    --         vim.api.nvim_buf_delete(buf, { force = true, unload = true })
    --     end,
    -- })
end


local M = {}

M.setup = function()
    -- noop
end

M.command = function(name, command, opts)
    vim.api.nvim_create_user_command(name, function()
        new_command(command, opts)
    end, {})
end

return M
