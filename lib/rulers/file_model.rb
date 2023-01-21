require "multi_json"
require "json"

module Rulers
  module Model
    class FileModel
      attr_reader :hash

      def initialize(filename)
        @filename = filename
        # If filename is "dir/37.json", @id is 37
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i
        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      # syntactic sugar of array method call
      # def [](x) --> obj.[](x) --> obj[x]

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      # Like “real” find in ActiveRecord, this find just returns nil if it canʼt
      # find anything - Ruby will raise a FileNotFound exception.
      def self.find(id)
        file_path = "db/quotes/#{id}.json"
        return nil unless File.exist?(file_path)

        FileModel.new(file_path)
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new(f) }
      end

      def self.create(attrs)
        hash = {
          "submitter" => attrs["submitter"] || "",
          "quote" => attrs["quote"] || "",
          "attribution" => attrs["attribution"] || ""
        }

        files = Dir["db/quotes/*.json"]
        names = files.map { |f| f.split("/")[-1] }
        highest = names.map { |b| b[0...-5].to_i }.max
        id = highest + 1

        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write(JSON.pretty_generate(hash))
        end

        FileModel.new("db/quotes/#{id}.json")
      end

      def self.where(**query_params)
        string_query_params = query_params.transform_keys(&:to_s)

        all.select do |model|
          string_query_params.all? do |key, match_value|
            model[key] == match_value
          end
        end
      end
    end
  end
end
