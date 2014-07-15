#TOTEST
class FieldType
  class LinkType < ::FieldType

    belongs_to :linked_flow, class_name: 'Flow', inverse_of: nil

    field      :label, type: String

    field      :max_item_links, type: Integer, default: nil
    validates  :max_item_links, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true
  end
end