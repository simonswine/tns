local tns = import 'tns/main.libsonnet';
local tk = import 'tk';
{
  local config = tns.defaults(),
  tns: tns.new(config),
}
