return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
	ensure_installed = { "lua_ls", "clangd", "marksman", "jdtls" },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
