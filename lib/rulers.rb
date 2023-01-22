# frozen_string_literal: true

require "rulers/array"
require "rulers/routing"
require "rulers/util"
require "rulers/file_model"
require "rulers/controller"
require "rulers/dependencies"
require_relative "rulers/version"

module Rulers
  class Error < StandardError; end

  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404,
                { "Content-Type" => "text/html" }, []]
      elsif env["PATH_INFO"] == "/"
        return [200,
                { "Content-Type" => "text/html" }, [File.read("./public/index.html")]]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      begin
        result = controller.send(act)
        result = controller.render(act) unless controller.rendered?
        if controller.get_response
          status, headers, rsbody = controller.get_response.to_a
          [status, headers, [rsbody].flatten]
        else
          [200,
           { "Content-Type" => "text/html" }, [result]]
        end
      rescue StandardError => e
        puts e
      end
    end
  end
end
