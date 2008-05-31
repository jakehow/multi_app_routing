require 'hash_extension'

module MultiAppMapper
  def application(name, options = {}, &block)
    [ActionController::Base, ActionView::Base].each { |d| d.send :include, define_application_helper(name, options) }
    with_options(:name_prefix =>"#{name}_app_", &block)
  end
  
  def define_application_helper(name, options)
    mod = Module.new
    mod.send :module_eval, <<-end_eval # We use module_eval to avoid leaks
          def #{name}
            ActionController::Routing::RouteSet::Mapper::UrlHelperProxy.new('#{name}', self, #{options.prepare_for_eval})
          end
        end_eval
    mod.send(:protected, name)
    return mod
  end
  
  class UrlHelperProxy
    attr_accessor :name
    attr_accessor :view_or_controller_instance
    attr_accessor :options
    
    def initialize(name, view_or_controller_instance, opts={} )
      @name = name
      @view_or_controller_instance = view_or_controller_instance
      config_options = MultiAppRouting::APPS[name].symbolize_keys
      @options = config_options.merge(opts)
    end
    
    def method_missing(method, opts = {})
      opts.each { |k,v| opts[k] = v.to_param }
      url_helper = :"#{name}_app_#{method}"
      view_or_controller_instance.send(url_helper, @options.merge(opts))
    end
  end
end