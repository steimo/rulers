# frozen_string_literal: true

require "rulers/array"
require "rulers/routing"
require "rulers/util"
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
        # return [302, { 'Location' => "/quotes/a_quote" }, []]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      begin
        text = controller.send(act)
        [200, { "Content-Type" => "text/html" },
         [text]]
      rescue StandardError
        [500,
         { "Content-Type" => "text/html" }, ["Oh no, something wrong just happened!"]]
      end
    end
  end
end
