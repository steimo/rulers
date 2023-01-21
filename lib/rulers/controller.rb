require "erubis"
require "rack/request"
require "rulers/file_model"

module Rulers
  class Controller
    include Rulers::Model

    attr_reader :env, :called_render_explicitly

    def initialize(env)
      @env = env
      @called_render_explicitly = false
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      body = [text].flatten
      @response = Rack::Response.new(body, status, headers)
    end

    def rendered?
      @called_render_explicitly
    end

    def render(view_name, locals = {})
      @called_render_explicitly = true

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
