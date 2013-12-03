module FieldType
  module TextMarkupType
    class << self

      def data_type
        :string
      end

      def markup?
        true
      end

    end
  end
end