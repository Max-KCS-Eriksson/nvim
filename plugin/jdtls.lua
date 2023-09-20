-- Set up nvim-jdtls with lsp-zero
--
-- Created using this guide:
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/setup-with-nvim-jdtls.md
--
-- NOTE: Contradicts the official nvim-jdtls documentation which suggests making a
-- "ftplugin".
-- Instead, an autocommand is executed when a .java file is opened. This allows for a
-- function, rather than a whole file, to be executed.

local java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })
local cache_vars = {}

local root_files = {
  -- Version control files/directories
  ".git",
  -- Maven files/directories
  "mvnw",
  "pom.xml",
  -- Gradle files/directories
  "gradlew",
  "build.gradle",
  "build.gradle.kts",
}

local features = {
  codelens = false,
  debugger = false, -- requires: nvim-dap, java-test and java-debug-adapter
}

local function get_jdtls_paths()
  -- Get all paths needed to start LSP server
  if cache_vars.paths then
    return cache_vars.paths
  end

  local path = {}

  path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"

  local jdtls_install = require("mason-registry").get_package("jdtls"):get_install_path()

  path.java_agent = jdtls_install .. "/lombok.jar"
  path.launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

  if vim.fn.has("mac") == 1 then
    path.platform_config = jdtls_install .. "/config_mac"
  elseif vim.fn.has("unix") == 1 then
    path.platform_config = jdtls_install .. "/config_linux"
  elseif vim.fn.has("win32") == 1 then
    path.platform_config = jdtls_install .. "/config_win"
  end

  -- Bundles for the Language server `initializationOptions`
  -- Extend `path.bundles` with paths to jar files if you want to use additional
  -- eclipse.jdt.ls plugins.
  path.bundles = {}

  -- Include java-test bundle if present
  local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()

  local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")

  if java_test_bundle[1] ~= "" then
    vim.list_extend(path.bundles, java_test_bundle)
  end

  -- Include java-debug-adapter bundle if present
  local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()

  local java_debug_bundle =
    vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")

  if java_debug_bundle[1] ~= "" then
    vim.list_extend(path.bundles, java_debug_bundle)
  end

  -- Useful if you're starting jdtls with a Java version that's different from the one
  -- the project uses.
  path.runtimes = {
    -- NOTE: the field `name` must be a valid `ExecutionEnvironment`.
    -- You can find the list here:
    -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    {
      name = "JavaSE-1.8",
      path = vim.fn.expand("~/.local/share/rtx/installs/java/adoptopenjdk-8.0.382+5/"),
    },
    {
      name = "JavaSE-11",
      path = vim.fn.expand("~/.local/share/rtx/installs/java/11/"),
    },
    {
      name = "JavaSE-17",
      path = vim.fn.expand("~/.local/share/rtx/installs/java/17/"),
    },
    {
      name = "JavaSE-20",
      path = vim.fn.expand("~/.local/share/rtx/installs/java/20/"),
    },
  }

  cache_vars.paths = path

  return path
end

local map = vim.keymap.set

local function enable_codelens(bufnr)
  pcall(vim.lsp.codelens.refresh)

  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = bufnr,
    group = java_cmds,
    desc = "refresh codelens",
    callback = function()
      pcall(vim.lsp.codelens.refresh)
    end,
  })
end

local function enable_debugger(bufnr)
  require("jdtls").setup_dap({ hotcodereplace = "auto" })
  require("jdtls.dap").setup_dap_main_class_configs()

  local opts = require("util").opts
  local _opts = { buffer = bufnr }

  -- Keymaps
  local has_wk, wk = pcall(require, "which-key")
  if has_wk then
    wk.register({
      ["<leader>d"] = {
        name = "+debugger",
        ["t"] = { name = "+test" },
      },
    })
  end
  map("n", "<leader>dtc", "<cmd>lua require('jdtls').test_class()<cr>", opts(_opts, "Test class"))
  map("n", "<leader>dtm", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts(_opts, "Test nearest method"))
end

local function jdtls_on_attach(client, bufnr)
  if features.debugger then
    enable_debugger(bufnr)
  end

  if features.codelens then
    enable_codelens(bufnr)
  end

  -- The following mappings are based on the suggested usage of nvim-jdtls
  -- https://github.com/mfussenegger/nvim-jdtls#usage
  -- Add individual values to desc field
  local opts = require("util").opts
  local _opts = { buffer = bufnr }

  -- Keymaps
  local has_wk, wk = pcall(require, "which-key")
  if has_wk then
    wk.register({
      mode = { "n", "v" },
      ["<leader>c"] = {
        name = "code",
        ["e"] = { name = "+extract" },
      },
    })
  end
  map("n", "<leader>co", "<cmd>lua require('jdtls').organize_imports()<cr>", opts(_opts, "Organize imports"))
  map("n", "<leader>cev", "<cmd>lua require('jdtls').extract_variable()<cr>", opts(_opts, "Extract variable"))
  map("n", "<leader>cec", "<cmd>lua require('jdtls').extract_constant()<cr>", opts(_opts, "Extract constant"))

  map("v", "<leader>cev", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts(_opts, "Extract variable"))
  map("v", "<leader>cec", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts(_opts, "Extract constant"))
  map("v", "<leader>cem", "<esc><cmd>lua require('jdtls').extract_method(true)<cr>", opts(_opts, "Extract method"))
end

local function jdtls_setup(event)
  local jdtls = require("jdtls")

  local path = get_jdtls_paths()
  local data_dir = path.data_dir .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  if cache_vars.capabilities == nil then
    jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    cache_vars.capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      ok_cmp and cmp_lsp.default_capabilities() or {}
    )
  end

  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  local cmd = {
    "java",

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. path.java_agent,
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-jar",
    path.launcher_jar,

    "-configuration",
    path.platform_config,

    "-data",
    data_dir,
  }

  -- Configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  local lsp_settings = {
    java = {
      -- jdt = {
      --   ls = {
      --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
      --   }
      -- },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = path.runtimes,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      -- inlayHints = {
      --   parameterNames = {
      --     enabled = "all" -- Options: "literals", "all", "none"
      --   }
      -- },
      format = {
        -- WARN: Cause cursor jump when enabled and using null_ls formatter together.
        enabled = false,
        -- settings = {
        --   profile = "asdf"
        -- },
      },
    },
    signatureHelp = {
      enabled = true,
    },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
    },
    contentProvider = {
      preferred = "fernflower",
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  }

  -- This starts a new client & server, or attaches to an existing client & server
  -- depending on the `root_dir`.
  jdtls.start_or_attach({
    cmd = cmd,
    settings = lsp_settings,
    on_attach = jdtls_on_attach,
    capabilities = cache_vars.capabilities,
    root_dir = jdtls.setup.find_root(root_files),
    flags = {
      allow_incremental_sync = true,
    },
    init_options = {
      bundles = path.bundles,
    },
  })
end

vim.api.nvim_create_autocmd("FileType", {
  group = java_cmds,
  pattern = { "java" },
  desc = "Setup jdtls",
  callback = jdtls_setup,
})
