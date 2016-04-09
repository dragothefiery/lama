module Lama
  #
  class Engine < ::Rails::Engine
    isolate_namespace Lama

    config.generators do |g|
      g.test_framework :rspec
      g.integration_tool :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
