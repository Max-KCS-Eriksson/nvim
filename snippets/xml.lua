local luasnip = require("luasnip")

local snip = luasnip.snippet
local ls_fmt = require("luasnip.extras.fmt").fmt
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node

return {
  snip(
    { trig = "mvnCompilerVersion", name = "Proterty of MVN project defining Java version" },
    ls_fmt(
      [[
          <maven.compiler.source>{}</maven.compiler.source>
          <maven.compiler.target>{}</maven.compiler.target>
      ]],
      { insert_node(1, "11"), insert_node(2, "11") }
    )
  ),
  snip(
    { trig = "springContext", name = "Spring Context dependency for MVN project" },
    ls_fmt(
      [[
          <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.2.7.RELEASE</version>
          </dependency>
      ]],
      {}
    )
  ),
  snip(
    { trig = "junit", name = "JUnit test dependency for MVN project" },
    ls_fmt(
      [[
          <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.8.1</version>
            <scope>test</scope>
          </dependency>
      ]],
      {}
    )
  ),
  snip(
    { trig = "jar", name = "Build JAR with dependencies" },
    ls_fmt(
      [[
          <build>
            <plugins>
              <plugin>
                <artifactId>maven-assembly-plugin</artifactId>
                <configuration>
                  <archive>
                    <manifest>
                      <!-- Run following to compile: -->
                      <!-- $ mvn clean compile assembly:single -->
                      <!-- Run JAR with: -->
                      <!-- $ java -jar target/*.jar -->
                      <mainClass>{}</mainClass>
                    </manifest>
                  </archive>
                  <descriptorRefs>
                    <descriptorRef>jar-with-dependencies</descriptorRef>
                  </descriptorRefs>
                </configuration>
              </plugin>
            </plugins>
          </build>
        ]],
      { insert_node(1, "PACKAGE.STRUCTURE.MainClass") }
    )
  ),
}
