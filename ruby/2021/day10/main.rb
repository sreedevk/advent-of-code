    class SyntaxScoring
      def data
        @data ||= ARGF.readlines
      end
    end
