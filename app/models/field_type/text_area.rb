module FieldType
  module TextAreaType
    class << self

      def data_type
        :string
      end

      def markup?
        false
      end

    end
  end
end