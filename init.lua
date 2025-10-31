-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	-- Core Plugin Manager
	'folke/lazy.nvim',

	-- Git integration
	'tpope/vim-fugitive', -- Git commands in nvim
	'tpope/vim-rhubarb', -- Fugitive-companion to interact with github

	-- Essential Utilities
	'tpope/vim-commentary', -- "gc" to comment visual regions/lines
	'nvim-lua/plenary.nvim', -- A dependency for many plugins
	'jiangmiao/auto-pairs', -- Automatic pairing of quotes, brackets, etc.

	-- UI & Appearance
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			-- Set colorscheme here
			vim.o.termguicolors = true
			vim.o.background = "dark"
			vim.cmd.colorscheme "gruvbox"
		end,
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup {
				options = {
					theme = "gruvbox"
				}
			}
		end
	},
	{
		'nvim-tree/nvim-tree.lua',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require 'nvim-tree'.setup {}
		end
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		config = function()
			-- Configure indent-blankline
			vim.g.indent_blankline_char = '┊'
			vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
			vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
			vim.g.indent_blankline_char_highlight = 'LineNr'
			vim.g.indent_blankline_show_trailing_blankline_indent = false
		end
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup {
				signs              = {
					add          = { text = '┃' },
					change       = { text = '┃' },
					delete       = { text = '_' },
					topdelete    = { text = '‾' },
					changedelete = { text = '~' },
					untracked    = { text = '┆' },
				},
				signcolumn         = true,
				numhl              = false,
				linehl             = false,
				word_diff          = false,
				current_line_blame = false,
			}
		end
	},

	-- Fuzzy Finding with Telescope
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
		config = function()
			require('telescope').setup {
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {}
					}
				},
				defaults = {
					mappings = {
						i = {
							['<C-u>'] = false,
							['<C-d>'] = false,
						},
					},
				},
			}
			require("telescope").load_extension("ui-select")
		end
	},

	-- Treesitter for syntax highlighting and more
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = {
					"c",
					"lua",
					"rust",
					"python",
					"javascript",
					"typescript",
					"html",
					"css",
					"bash",
					"json",
					"go",
					"cpp"
				},
				sync_install = false, -- Install parsers asynchronously
				auto_install = true, -- Automatically install parsers on file open
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = 'gnn',
						node_incremental = 'grn',
						scope_incremental = 'grc',
						node_decremental = 'grm',
					},
				},
				indent = {
					enable = false,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							[']m'] = '@function.outer',
							[']]'] = '@class.outer',
						},
						goto_next_end = {
							[']M'] = '@function.outer',
							[']['] = '@class.outer',
						},
						goto_previous_start = {
							['[m'] = '@function.outer',
							['[['] = '@class.outer',
						},
						goto_previous_end = {
							['[M'] = '@function.outer',
							['[]'] = '@class.outer',
						},
					},
				},
			}
		end
	},

	-- LSP Installer
	{
		'mason-org/mason.nvim',
		config = function()
			require("mason").setup()
		end
	},

	'williamboman/mason-lspconfig.nvim',

	-- LSP Configurations
	{
		'neovim/nvim-lspconfig',
		config = function()
			-- Define the on_attach function that runs for every language server.
			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
				local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

				buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
				local opts = { noremap = true, silent = true }
				buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
				buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
				buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
				buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
				buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
				buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
				buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
					opts)
				buf_set_keymap('n', '<space>wl',
					'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
				buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
				buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
				buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
				buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
				buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
			end

			-- Get completion capabilities from nvim-cmp
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			require('mason-lspconfig').setup({
				-- Mason will automatically install anything in this list that is not already installed.
				ensure_installed = {
					"lua_ls",
					"ruff",
					"pyright",
					"ltex",
					"rust_analyzer",
					"r_language_server",
				},
				handlers = {
					function(server_name)
						require('lspconfig')[server_name].setup({
							on_attach = on_attach,
							capabilities = capabilities,
						})
					end,
					-- add custom handlers for specific servers here if needed
					-- For example:
					-- ["luals"] = function()
					--   require('lspconfig').luals.setup({ ... custom settings ... })
					-- end,
				}
			})
		end
	},

	-- Autocompletion engine
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-buffer',
			'saadparwaiz1/cmp_luasnip',
			'onsails/lspkind-nvim', -- VSCode-like icons for autocompletion
			{
				'L3MON4D3/LuaSnip',
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end
			},
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and
				vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-n>'] = cmp.mapping.select_next_item(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
					{ name = 'buffer' },
				},
			})
		end
	},

	{
		'stevearc/conform.nvim',
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { 'stylua' },
				python = { 'ruff' },
				rust = { 'rustfmt' },
				json = { 'prettier' },
				sql = { 'sql-formatter' },
				javascript = { 'prettier' },
				typescript = { 'prettier' },
				html = { 'prettier' },
				css = { 'prettier' },
			},
		},
	},

	{
		'mfussenegger/nvim-lint',
		config = function()
			local lint = require('lint')
			lint.linters_by_ft = {
				json = { 'jsonlint' },
				sql = { 'sqlfluff' },
				-- You can add other linters here
			}

			-- Automatically run linting on file save and when text changes
			vim.api.nvim_create_autocmd({ 'BufWritePost', 'TextChanged', 'InsertLeave' }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- Code folding
	{
		'kevinhwang91/nvim-ufo',
		dependencies = 'kevinhwang91/promise-async',
		config = function()
			vim.o.foldcolumn = '1'
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
			require('ufo').setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { 'treesitter', 'indent' }
				end
			})
		end
	},

	-- Language-specific tools
	'averms/black-nvim',
	'rhysd/vim-clang-format',
	'darrikonn/vim-gofmt',

	-- AI Plugin
	{
		'yetone/avante.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'MunifTanjim/nui.nvim',
			{
				'MeanderingProgrammer/render-markdown.nvim',
				config = function()
					require('render-markdown').setup({
						file_types = { "markdown", "Avante" },
					})
				end
			}
		},
		run = 'make', -- This command builds the plugin's binary
		config = function()
			require('avante').setup({
				provider = "gemini",
				providers = {
					claude = { model = "claude-4-5-sonnet" },
					openai = { model = "gpt-5-mini" },
					gemini = { model = "gemini-2.5-flash" }
				},
				behaviour = {
					auto_set_keymaps = true,
				},
			})
		end,
	},
})

--[[ ------------------------------------------------------------------------
   Core Neovim Settings (Options)
   ------------------------------------------------------------------------ ]]
vim.o.inccommand = 'nosplit'
vim.wo.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.cmd [[autocmd BufRead,BufNewFile *.htm,*.html,*.js,*.ts setlocal tabstop=2 shiftwidth=2 softtabstop=2]]
vim.o.hidden = true
vim.o.breakindent = true
vim.opt.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.wo.cursorline = true
vim.opt.clipboard = { 'unnamed', 'unnamedplus' }
vim.o.mouse = ""

--[[ ------------------------------------------------------------------------
   Keymaps
   ------------------------------------------------------------------------ ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true, silent = true, desc = "Exit insert mode" })

-- Window navigation
vim.api.nvim_set_keymap('n', '<leader>j', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', { noremap = true, silent = true })

-- NvimTree
vim.api.nvim_set_keymap('', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>r', ':NvimTreeRefresh<CR>', { noremap = true, silent = true })

-- Reformat file shortcuts
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua require("conform").format()<CR>',
	{ noremap = true, silent = true, desc = "Format file" })

-- Word wrap navigation
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Yank until end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Telescope shortcuts
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]],
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]],
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]],
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]],
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so',
	[[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]],
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]],
	{ noremap = true, silent = true })


--[[ ------------------------------------------------------------------------
   Autocommands
   ------------------------------------------------------------------------ ]]
-- Highlight on yank
vim.api.nvim_exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	false
)

vim.diagnostic.config({ virtual_text = true })
