require("config.lazy")
require "mini.pick".setup()
require "oil".setup()

-- [[ LSP ]]
vim.lsp.enable({ "clangd", "lua_ls", "marksman", "pyrefly" })

-- [[ Options ]]
-- numbering
vim.o.number = true
vim.o.relativenumber = true

-- border type
vim.o.winborder = "single"

-- keep history even after the buffer is closed
vim.o.undofile = true

-- disable the swap file
vim.o.swapfile = false

-- the vertical line you see
vim.o.colorcolumn = "80"

-- disable the wrapping of texts
vim.o.wrap = false

-- configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.confirm = true
vim.o.signcolumn = "yes"
-- minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- case-insensitive searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- convert Tabs to Spaces
vim.o.expandtab = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Show which line your cursor is on
vim.o.cursorline = true

-- amount to indent with << >>
vim.o.shiftwidth = 4

-- spaces shown per tab
vim.o.tabstop = 4

-- spaces applied when pressing tab
vim.o.softtabstop = 4
vim.g.mapleader = " "

-- convinient tab options
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.autoindent = true

-- enable break indent
vim.o.breakindent = true

-- way nvim displays certain whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.inccommand = "split"

-- show which line your cursor is on
vim.o.cursorline = true

-- sync clipboard between os and nvim
vim.opt.clipboard = "unnamedplus"

-- [[ Keymaps ]]
vim.keymap.set("n", ";", ":", { desc = "easier command mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- diagnostic keymaps
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open [d]iagnostic [l]ist" })
vim.keymap.set("n", "<leader>df", function()
    vim.diagnostic.open_float()
end, { desc = "Open [d]iagnostics in [f]loat" })

-- current buffer actions
vim.keymap.set("n", "<leader>o", ":update<CR> :source ~/.config/nvim/init.lua<CR>", { desc = "s[o]urce the current file" })
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "[w]rite file" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "[q]uit" })

-- file actions
vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "open oil" })
vim.keymap.set("n", "<leader>lf", ":Pick files<CR>", { desc = "[l]ist [f]iles" })
vim.keymap.set("n", "<leader>lg", ":Pick grep_live<CR>", { desc = "[l]ist [g]rep" })
vim.keymap.set("n", "<leader>lb", ":Pick buffers<CR>", { desc = "[l]ist [b]uffers" })
vim.keymap.set("n", "<leader>lh", ":Pick help<CR>", { desc = "[l]ist [h]elp" })
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { desc = "[f]or[m]at current file" })
vim.keymap.set("n", "<leader>db", vim.lsp.buf.hover, { desc = "[d]isplay [b]uffer" })

-- easy terminal quit
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Easy splits
vim.keymap.set("n", "<leader>l", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>j", vim.cmd.split)

-- Easier split navigation
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

-- Moving split panes
vim.keymap.set("n", "<A-k>", ":wincmd K<CR>")
vim.keymap.set("n", "<A-j>", ":wincmd J<CR>")
vim.keymap.set("n", "<A-h>", ":wincmd H<CR>")
vim.keymap.set("n", "<A-l>", ":wincmd L<CR>")

-- Easier pane resizing
vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]])
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]])
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]])
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]])


-- [[ Autocommands ]]
--  highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- refactoring
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- rename the variable under your cursor.
        map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

        -- exacute a code action
        map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

        -- find references for the word under your cursor.
        map("grr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")

        -- jump to the implementation of the word under your cursor.
        --  useful when your language has ways of declaring types without an actual implementation.
        map("gri", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")

        -- jump to the definition of the word under your cursor.
        --  this is where a variable was first declared, or where a function is defined, etc.
        --  to jump back, press <C-t>.
        map("grd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

        -- WARN: this is not Goto Definition, this is Goto Declaration.
        --  for example, in C this would take you to the header.
        map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- fuzzy find all the symbols in your current document.
        map("gO", require("fzf-lua").lsp_document_symbols, "Open Document Symbols")

        -- fuzzy find all the symbols in your current workspace.
        map("gW", require("fzf-lua").lsp_live_workspace_symbols, "Open Workspace Symbols")

        -- jump to the type of the word under your cursor.
        --  useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("grt", require("fzf-lua").lsp_typedefs, "[G]oto [T]ype Definition")

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
                return client:supports_method(method, bufnr)
            else
                return client.supports_method(method, { bufnr = bufnr })
            end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        -- when you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
        then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                end,
            })
        end

        -- the following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
        end
    end,
})


vim.cmd(":colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
