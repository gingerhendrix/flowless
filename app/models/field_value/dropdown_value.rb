class FieldValue
  class DropdownValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end