require "erubis"

module Rulers
  class Controller
    def initialize(env)
      @env = env
    end

    attr_reader :env

    def render(view_name, locals = {})
      filename = File.join "app", "views",
                           controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(env:)
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Rulers.to_underscore klass
    end
  end
end
