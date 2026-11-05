return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			java = { "google-java-format" }, -- Fallbacks automatically if missing
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "marksman" },
			["_"] = { "trim_whitespace" }, -- Fallback for all other filetypes
		},
		formatters = {
			google_java_format = {
				append_args = { "--max-line-length=80" },
			},
		},
	},
}
