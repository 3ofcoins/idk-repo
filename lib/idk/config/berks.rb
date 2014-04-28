require 'idk/config'

module IDK
  module Berks
    class StubLoader
      def run_list(*args)
        @run_list ||= []
        if args.empty?
          @run_list
        else
          @run_list |= args
        end
      end

      def env_run_lists(lists = {})
        lists.values.each do |list|
          run_list(*Array(list))
        end
      end

      def depends(*args)
        @dependencies ||= []
        @dependencies << args
      end

      def load(*paths)
        Dir[*paths].each do |path|
          instance_eval(File.read(path), path)
        end
      end

      def needed_cookbooks
        needs = {}
        Array(@run_list).map do |item|
          next if item =~ /^role\[/
          item = $1 if item =~ /^recipe\[(.*)\]$/
          item = $1 if item =~ /^(.*)::.*$/
          needs[item] = []
        end

        Array(@dependencies).each do |dep|
          name = dep.first
          version = dep[1]
          needs[name] ||= []
          needs[name] |= dep[1..-1]
        end

        needs
      end

      def method_missing(method, *args)
      end
    end
  end
end
