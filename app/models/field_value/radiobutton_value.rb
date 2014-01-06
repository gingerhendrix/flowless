class FieldValue
  class RadiobuttonValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end