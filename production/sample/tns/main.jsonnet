local tns = import 'tns/main.libsonnet';
local tk = import 'tk';
{
  local config = tns.config(),
  tns: tns.new(config),
}
