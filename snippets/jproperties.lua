local luasnip = require("luasnip")

local snip = luasnip.snippet
local ls_fmt = require("luasnip.extras.fmt").fmt
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node

return {
  -- Snippets
  snip(
    { trig = "jpa", name = "JPA setup" },
    ls_fmt(
      [[
      spring.datasource.url=jdbc:mysql://localhost/<databaseName>
      spring.datasource.username=<username>
      spring.datasource.password=<password>
      ]],
      {}
    )
  ),
  snip(
    { trig = "output", name = "Turn off console logger output" },
    ls_fmt(
      [[
      logging.pattern.console=
      ]],
      {}
    )
  ),
  snip(
    { trig = "ddl-auto", name = "Auto create tables. WARN: set to `none` in production" },
    ls_fmt(
      [[
      # WARN: Set to `none` in production
      spring.jpa.hibernate.ddl-auto=create
      ]],
      {}
    )
  ),
  snip(
    { trig = "show-sql", name = "Show generated SQL statements" },
    ls_fmt(
      [[
      spring.jpa.show-sql=true
      ]],
      {}
    )
  ),
  snip(
    { trig = "nameField", name = "Use value of `name` field in annotations of an `@Entity`" },
    ls_fmt(
      [[
      spring.datasource.url=jdbc:mysql://localhost/<databaseName>
      spring.datasource.username=<username>
      spring.datasource.password=<password>

      spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
      ]],
      {}
    )
  ),
  snip(
    { trig = "mariadb", name = "Required JPA settings when using MariaDB localy as drop-in replacement for MySQL" },
    ls_fmt(
      [[
      spring.datasource.url=jdbc:mysql://localhost/<databaseName>
      spring.datasource.username=<username>
      spring.datasource.password=<password>

      spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
      spring.jpa.hibernate.naming.implicit-strategy=org.hibernate.boot.model.naming.ImplicitNamingStrategyLegacyJpaImpl
      spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
      ]],
      {}
    )
  ),
}
