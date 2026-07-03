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

local function resolve_java_home(...)
  local base = vim.fn.expand("~/.local/share/mise/installs/java")
  local candidates = {}
  local seen = {}

  local function add_candidate(candidate)
    if candidate ~= "" and seen[candidate] == nil then
      table.insert(candidates, candidate)
      seen[candidate] = true
    end
  end

  for _, version in ipairs({ ... }) do
    add_candidate(base .. "/" .. version)

    for _, candidate in ipairs(vim.fn.glob(base .. "/" .. version .. "*", false, true)) do
      add_candidate(candidate)
    end
  end

  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate .. "/bin/java") == 1 then
      return candidate
    end
  end
end

local function java_runtime_name(version)
  if version == nil or version == "" then
    return nil
  end

  local normalized = version:gsub("^java@", "")
  local major = normalized:match("^1%.(%d+)") or normalized:match("^(%d+)") or normalized:match("%-(%d+)")

  if major == nil then
    return nil
  end

  if major == "8" then
    return "JavaSE-1.8"
  end

  return "JavaSE-" .. major
end

local function find_upward_file(names, start_path)
  local dir = start_path

  if dir == nil or dir == "" then
    dir = vim.fn.getcwd()
  end

  if vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.fnamemodify(dir, ":h")
  end

  while dir ~= "" do
    for _, name in ipairs(names) do
      local candidate = dir .. "/" .. name

      if vim.fn.filereadable(candidate) == 1 then
        return candidate
      end
    end

    local parent = vim.fn.fnamemodify(dir, ":h")

    if parent == dir then
      break
    end

    dir = parent
  end
end

local function java_version_from_mise_toml(file)
  local ok, lines = pcall(vim.fn.readfile, file)

  if not ok then
    return nil
  end

  local in_tools = false

  for _, line in ipairs(lines) do
    local trimmed = vim.trim(line:gsub("#.*$", ""))
    local section = trimmed:match("^%[([^%]]+)%]$")

    if section ~= nil then
      in_tools = section == "tools"
    elseif in_tools then
      local version = trimmed:match("^java%s*=%s*[\"']([^\"']+)[\"']")

      if version ~= nil then
        return version
      end
    end
  end
end

local function java_version_from_tool_versions(file)
  local ok, lines = pcall(vim.fn.readfile, file)

  if not ok then
    return nil
  end

  for _, line in ipairs(lines) do
    local version = line:match("^%s*java%s+([^%s#]+)")

    if version ~= nil then
      return version
    end
  end
end

local function project_java_version(start_path)
  local file = find_upward_file({ "mise.toml", ".mise.toml", ".tool-versions" }, start_path)

  if file == nil then
    return nil
  end

  if vim.endswith(file, ".tool-versions") then
    return java_version_from_tool_versions(file)
  end

  return java_version_from_mise_toml(file)
end

local function java_runtimes_with_default(runtimes, default_java_version)
  local default_runtime = java_runtime_name(default_java_version)
  local configured = {}

  for _, runtime in ipairs(runtimes) do
    if runtime.path ~= nil then
      local entry = {
        name = runtime.name,
        path = runtime.path,
      }

      if runtime.name == default_runtime then
        entry.default = true
      end

      table.insert(configured, entry)
    end
  end

  return configured
end

local function get_jdtls_paths()
  -- Get all paths needed to start LSP server
  if cache_vars.paths then
    return cache_vars.paths
  end

  local path = {}

  path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"
  path.java_home = resolve_java_home("21")
  path.java_bin = path.java_home and (path.java_home .. "/bin/java") or vim.fn.exepath("java")

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
      path = resolve_java_home("temurin-8", "adoptopenjdk-8", "8"),
    },
    {
      name = "JavaSE-11",
      path = resolve_java_home("11"),
    },
    {
      name = "JavaSE-17",
      path = resolve_java_home("17"),
    },
    {
      name = "JavaSE-21",
      path = path.java_home,
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
    wk.add({
      { "<leader>d",  group = "+debugger" },
      { "<leader>dt", group = "+test" },
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
    wk.add({
      {
        mode = { "n", "v" },
        { "<leader>c",  group = "+code" },
        { "<leader>ce", group = "+extract" },
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
  local root_dir = jdtls.setup.find_root(root_files)
  local buf_path = vim.api.nvim_buf_get_name(event.buf)
  local project_dir = root_dir or vim.fn.fnamemodify(buf_path, ":p:h")
  local configured_java_version = project_java_version(project_dir)
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
    path.java_bin,

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
        runtimes = java_runtimes_with_default(path.runtimes, configured_java_version),
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
    root_dir = root_dir,
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
