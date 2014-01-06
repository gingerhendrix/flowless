class FieldValue
  class BooleanValue < ::FieldValue
    include Mongoid::Document

    field :value, type: Boolean

  end
end