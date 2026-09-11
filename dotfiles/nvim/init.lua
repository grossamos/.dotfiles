-- ============================================================================
-- Dependencies (Fedora). Language servers + black install via mason at runtime;
-- these are the system tools mason/plugins need to build & run them:
--
--   sudo dnf install -y golang python3-pip gcc ripgrep git curl unzip \
--                       texlive-latexmk nodejs
--
--   golang         -> gopls (mason installs it via `go install`; also runtime dep)
--   python3-pip    -> basedpyright (installed via pip)
--   gcc            -> nvim-treesitter parser compilation
--   ripgrep        -> telescope live_grep
--   git/curl/unzip -> vim.pack + mason downloads
--   texlive-latexmk-> texlab LaTeX build
--   nodejs         -> optional; no server here needs it (basedpyright bundles node),
--                     only required if you add node-based servers later
--
-- Secrets: export OVERLEAF_COOKIE in your shell rc, e.g.
--   export OVERLEAF_COOKIE='overleaf_session2=s%3A...'
-- ============================================================================

vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/FabijanZulj/blame.nvim",
	"https://github.com/catppuccin/nvim",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/faergeek/Comment.nvim",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-cmdline",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-vsnip",
	"https://github.com/hrsh7th/vim-vsnip",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/richwomanbtc/overleaf.nvim",
	"https://github.com/OXY2DEV/markview.nvim",
})

-- General Settings
vim.g.mapleader = " "

local function has(bin) return vim.fn.executable(bin) == 1 end

local caps = {
	go       = has("go"),
	node     = has("node"),
	latexmk  = has("latexmk"),
	rg       = has("rg"),
	cc       = has("cc") or has("gcc") or has("clang"),
}

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmatch = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.hidden = true
vim.opt.encoding = "utf-8"
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.laststatus = 3
vim.o.fsync = false

vim.keymap.set("n", "<leader>bb", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({'n', 'v'}, '<leader>yy', '"+y')

vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")


-- Oil Settings
require("oil").setup()
vim.keymap.set('n', '<leader>ed', function()
	if vim.bo.filetype == "oil" then
		require("oil").close()
	else
		require("oil").open()
	end
end)

-- Color Theme
require("catppuccin").setup({
	integrations = {
		treesitter = true,
	},
})
vim.cmd.colorscheme("catppuccin")

-- Treesitter Configuration
require("nvim-treesitter").setup({
	-- Install all languages automatically
	ensure_installed = "all",
	auto_install = caps.cc,
	indent = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
			node_decremental = "<BS>",
			scope_incremental = "<TAB>",
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		if vim.bo[ev.buf].buftype ~= "" then return end
		if vim.bo[ev.buf].filetype == "oil" then return end
		if not pcall(vim.treesitter.start, ev.buf) then
			if not caps.cc then return end
			local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
			if lang then
				require("nvim-treesitter").install({ lang })
			end
		end
	end,
})

-- Mason Configuration (LSP Installer)
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	-- LSP servers to auto-install
	ensure_installed = {
		"clangd",       -- C/C++
		"rust_analyzer", -- Rust
		"marksman",     -- Markdown
		"texlab",       -- LaTeX
		"basedpyright", -- Python
		"gopls",        -- Go
		"lua_ls",       -- Lua
	},
	automatic_enable = false,
})

local ok_reg, registry = pcall(require, "mason-registry")
if ok_reg then
	local function ensure(pkg)
		if registry.has_package(pkg) and not registry.is_installed(pkg) then
			registry.get_package(pkg):install()
		end
	end
	registry.refresh(function() ensure("black") end)
end

-- LSP keymaps (buffer-local)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover" }))
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
		if vim.bo[ev.buf].filetype ~= "python" then
			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
		end
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(ev)
		vim.keymap.set("n", "<leader>f", function()
			vim.cmd("!black " .. vim.fn.expand("%"))
			vim.cmd("edit!")
		end, { buffer = ev.buf, desc = "Format with black" })
	end,
})

-- Diagnostic icons and settings
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Autocomplete
local cmp = require'cmp'

-- >>> LLM-GENERATED: bib citekey cmp source
local bib_source = {}

function bib_source.new()
	return setmetatable({}, { __index = bib_source })
end

function bib_source.get_trigger_characters()
	return { '@' }
end

function bib_source.complete(_, _, callback)
	local bib_path = vim.g.bib_file or vim.fn.expand('/var/home/amos/notes/refs.bib')
	local ok, lines = pcall(vim.fn.readfile, bib_path)
	if not ok then
		callback({ items = {}, isIncomplete = false })
		return
	end
	local content = table.concat(lines, '\n')
	local items = {}
	for pos, key in content:gmatch('()@%a+%s*{%s*([^,%s]+)%s*,') do
		local chunk = content:sub(pos, pos + 600)
		local title = chunk:match('title%s*=%s*(%b{})')
		if title then
			title = title:sub(2, -2)
			title = title:gsub('[{}]', '')
		end
		items[#items + 1] = {
			label = key,
			insertText = key,
			kind = require('cmp').lsp.CompletionItemKind.Reference,
			citation_title = title,
		}
	end
	table.sort(items, function(a, b)
		return (a.citation_title or a.label):lower() < (b.citation_title or b.label):lower()
	end)
	callback({ items = items, isIncomplete = false })
end

require('cmp').register_source('bib', bib_source.new())
-- <<< LLM-GENERATED: bib citekey cmp source

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    -- >>> LLM-GENERATED: show bib title inline in completion row
    formatting = {
      format = function(entry, vim_item)
        if entry.source.name == 'bib' then
          local title = entry.completion_item.citation_title
          if title and title ~= '' then
            if #title > 60 then
              title = title:sub(1, 60) .. '…'
            end
            vim_item.menu = title
          end
          vim_item.kind = ''
        end
        return vim_item
      end,
    },
    -- <<< LLM-GENERATED: show bib title inline in completion row
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-r>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
	  { name = 'path' },
    }, {
      { name = 'buffer' },
    })
  })

-- >>> LLM-GENERATED: markdown cmp sources with bib citekeys
cmp.setup.filetype('markdown', {
	sources = cmp.config.sources({
		{ name = 'bib' },
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
		{ name = 'path' },
	}, {
		{ name = 'buffer' },
	}),
})
-- <<< LLM-GENERATED: markdown cmp sources with bib citekeys

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- C/C++ (clangd)
-- Prefer Fedora's clangd: it's built from the same clang as /usr/bin/clang++,
-- so precompiled module BMIs match. Mason's clangd is a different upstream
-- build and rejects BMIs built by the system compiler.
local clangd_cmd = has("/usr/bin/clangd") and "/usr/bin/clangd" or "clangd"
vim.lsp.config.clangd = {
	cmd = { clangd_cmd },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = { ".clangd", "compile_commands.json", ".git" },
    capabilities = capabilities,
}
vim.lsp.enable("clangd")

-- Python
vim.lsp.config.basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },
}
vim.lsp.enable("basedpyright")

-- Go
vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { ".git", "go.mod" },
    capabilities = capabilities,
}
if caps.go then
	vim.lsp.enable("gopls")
end

-- Lua (lua_ls)
vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", ".git" },
    capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}
vim.lsp.enable("lua_ls")

vim.lsp.log.set_level(vim.lsp.log.levels.OFF)

-- Rust (rust_analyzer)
vim.lsp.config.rust_analyzer = {
    capabilities = capabilities,
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
		},
	},
}
vim.lsp.enable("rust_analyzer")

-- Markdown (marksman)
vim.lsp.config.marksman = {
    capabilities = capabilities,
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".marksman.toml", ".git" },
}
vim.lsp.enable("marksman")

-- LaTeX (texlab)
local texlab_settings = { texlab = {} }
if caps.latexmk then
	texlab_settings.texlab.build = {
		executable = "latexmk",
		args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
	}
end

vim.lsp.config.texlab = {
    capabilities = capabilities,
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib" },
	root_markers = { ".git", ".latexmkrc", "latexmkrc", ".texlabrc", "texlab.toml", "Tectonic.toml" },
	settings = texlab_settings,
}
vim.lsp.enable("texlab")

-- Spelling
-- vim.opt.spelllang = 'en_us'
-- vim.opt.spell = true
--
vim.keymap.set("n", "<leader>sn", "]s", { desc = "Next misspelled word" })
vim.keymap.set("n", "<leader>sp", "[s", { desc = "Previous misspelled word" })
vim.keymap.set("n", "<leader>sa", "zg", { desc = "Add word to dictionary" })
vim.keymap.set("n", "<leader>sr", "z=", { desc = "Show spelling suggestions" })
vim.keymap.set("n", "<leader>sc", "zw", { desc = "Mark word as incorrect" })

-- Status line
function get_mode()
  local mode_map = {
    ["n"] = "NORMAL",
    ["no"] = "O-PENDING",
    ["nov"] = "O-PENDING",
    ["noV"] = "O-PENDING",
    ["no\22"] = "O-PENDING",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["nt"] = "NORMAL",
    ["v"] = "VISUAL",
    ["vs"] = "VISUAL",
    ["V"] = "V-LINE",
    ["Vs"] = "V-LINE",
    ["\22"] = "V-BLOCK",
    ["\22s"] = "V-BLOCK",
    ["s"] = "SELECT",
    ["S"] = "S-LINE",
    ["\19"] = "S-BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rx"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["Rvc"] = "V-REPLACE",
    ["Rvx"] = "V-REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "EX",
    ["ce"] = "EX",
    ["r"] = "REPLACE",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
  }
  local mode = vim.api.nvim_get_mode().mode
  return mode_map[mode] or mode
end

function get_buffers()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  local current = vim.fn.bufnr()
  local parts = {}

  for _, buf in ipairs(buffers) do
    local name = vim.fn.fnamemodify(buf.name, ":t")
    if name == "" then name = "[No Name]" end

    if buf.bufnr == current then
      table.insert(parts, "[" .. name .. "]")
    else
      table.insert(parts, name)
    end
  end

  return table.concat(parts, " ")
end

vim.api.nvim_create_autocmd("ModeChanged", {
        group = vim.api.nvim_create_augroup("StatuslineMode", { clear = true }),
        callback = function()
                vim.cmd("redrawstatus")
        end,
})

-- Mode highlight groups for statusline
vim.api.nvim_set_hl(0, "StatusLineMode", { bg = "#89b4fa", fg = "#1e1e2e", bold = true })

vim.opt.statusline = table.concat({
        "%#StatusLineMode#",         -- Mode highlight
        " %{%v:lua.get_mode()%} ",   -- Current mode
        "%#StatusLine#",             -- Reset to normal
        " %{%v:lua.get_buffers()%}",  -- Buffer names
        "%=",                        -- Right align
        " %f%m%r",                   -- Filename + modified + readonly
        "  %l:%c/%L",                -- Line:column/Total lines
})

-- Open at the same location
vim.api.nvim_create_autocmd("BufReadPost", {
  group = general_group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Return to last edit position",
})

-- Comments
vim.keymap.set({ "v" }, "<leader>;", "gc", { remap = true, desc = "Toggle comment" })
vim.keymap.set({ "n" }, "<leader>;", "gcc", { remap = true, desc = "Toggle comment" })
local comment_ok, comment = pcall(require, "Comment")
if comment_ok then
	comment.setup()
end

-- Autopairs
local autopairs = require("nvim-autopairs")
autopairs.setup({
    check_ts = true, -- use treesitter for smarter detection
    ts_config = {
        lua = { "string" },   -- don't add pairs inside lua strings
        python = { "string" },
    },
    fast_wrap = {
        map = "<M-e>", -- Alt+e to wrap selection in a pair
    },
})
-- Make autopairs and cmp work together
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Autotag (XML/HTML)
require("nvim-ts-autotag").setup()

-- Markdown rendering (markview.nvim)
require("markview").setup({})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
if caps.rg then
	vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
else
	vim.keymap.set('n', '<leader>fg', builtin.grep_string, { desc = 'Telescope grep' })
end

-- Terminal
local terminal_buf = -1
local terminal_win = -1

vim.keymap.set("n", "<leader>\\", function()
    if vim.api.nvim_win_is_valid(terminal_win) then
        vim.api.nvim_win_hide(terminal_win)
    else
        if vim.api.nvim_buf_is_valid(terminal_buf) then
            -- Reopen existing terminal buffer in a split
            vim.cmd("botright vsplit")
            vim.api.nvim_win_set_buf(0, terminal_buf)
            terminal_win = vim.api.nvim_get_current_win()
        else
            -- Create a new terminal
            vim.cmd("botright vsplit | terminal")
            terminal_buf = vim.api.nvim_get_current_buf()
            terminal_win = vim.api.nvim_get_current_win()
        end
        vim.cmd("vertical resize 60")
        vim.cmd("startinsert")
    end
end, { desc = "Toggle terminal" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Blame
  require('blame').setup {}

-- Overleaf
require('overleaf').setup({
	cookie = os.getenv("OVERLEAF_COOKIE"),
	sync_dir = '~/.overleaf',
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us" -- or your preferred language
  end,
})

-- vim.opt.rtp:prepend("/home/amos/code/misc/borges.nvim")
-- require("borges").setup()
--
-- vim.api.nvim_create_user_command("ReloadBorges", function()
--   package.loaded["borges"] = nil
--   require("borges").setup()
--   print("borges reloaded")
-- end, {})
