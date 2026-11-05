return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},

		opts = {
			ensure_installed = {
                "clangd",
				"lua_ls",
				"marksman",
				"jdtls",
			},
		},

		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			vim.lsp.config("clangd", {
				cmd = {
					"/usr/bin/clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},

				capabilities = {
					offsetEncoding = { "utf-16" },
				},
			})

			vim.lsp.enable("clangd")
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"google-java-format",
				"stylua",
			},
		},
	},
}
