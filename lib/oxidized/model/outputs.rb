module Oxidized
  class Model
    class Outputs

      def to_cfg
        type_to_str(nil)
      end

      def type_to_str want_type
        type(want_type).map { |out| out }.join
      end

      def << output
        puts "POOP: #{output}" if output.class != Oxidized::String
        @outputs << output
      end

      def all
        @outputs
      end

      def type type
        @outputs.select { |out| out.type==type }
      end

      def types
        @outputs.map { |out| out.type }.uniq.compact
      end

      private

      def initialize
        @outputs = []
      end

    end
  end
end
