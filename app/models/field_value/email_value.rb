class FieldValue
  class EmailValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end