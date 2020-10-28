local yaml = require 'yaml'

local function show(word)
  local translationFile = io.open("./example/pt_PT.yaml", "r")
  io.input(translationFile)
  local translations = io.read()
  io.close(translationFile)
  local parsedYaml = yaml.parse(translations)
  local currentWord = vim.api.nvim_eval('expand("<cword>")')

  print(parsedYaml[currentWord])
end

return {
  show = show
}
