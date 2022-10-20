-- Not sure if this is doing anythin...
return {
  compilerOptions = {
    module = "commonjs",
    skipLibCheck = true,
    noImplicitAny = true,
    removeComments = true,
    sourceMap = true
  },
  include = { "./**" },
  exclude = {
    "node_modules",
    "./node_modules",
    "./node_modules/*",
    "./node_modules/@types/node/index.d.ts"
  }
}
