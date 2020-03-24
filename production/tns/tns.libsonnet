local k = import 'ksonnet-util/kausal.libsonnet';
local config = import 'config.libsonnet';
{
  config(): config,

  new(config):: {
    local new_app(name, arg, image) = {
      local container = k.core.v1.container.new(name, image)
        .withPorts(k.core.v1.containerPort.new('http-metrics', 80))
        .withImagePullPolicy('IfNotPresent')
        .withArgs(std.prune(['-log.level=debug', if arg!='' then arg else null]))
        .withEnvMap({
          JAEGER_AGENT_HOST: config.jaeger.host,
          JAEGER_TAGS: config.jaeger.tags,
          JAEGER_SAMPLER_TYPE: config.jaeger.sampler_type,
          JAEGER_SAMPLER_PARAM: config.jaeger.sampler_param,
        })
      ,

      deployment: k.apps.v1.deployment.new(name, 1, [container], {}),
      service: k.util.serviceFor(self.deployment),
    },

    ns: k.core.v1.namespace.new(config.namespace),
    db: new_app('db', '', config.images.db),
    app: new_app('app', 'http://db', config.images.tns_app),
    loadgen: new_app('loadgen', 'http://app', config.images.loadgen),
  },
}
