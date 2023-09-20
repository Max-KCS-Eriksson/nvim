local colorscheme = require("config").colorscheme
return {
  require("plugins.themes." .. colorscheme),
}
