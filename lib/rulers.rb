# frozen_string_literal: true
require 'rulers/array'
require_relative "rulers/version"

module Rulers
  class Error < StandardError; end

  class Application
    def call(env)
      `echo debug > debug.txt`;
      [200, { 'Content-Type' => 'text/html' },
       ["Hello from Ruby on Rulers! #{[1,2,3,4,5].sum}"]]
    end
  end
end
