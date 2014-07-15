class FieldValue
  class LinkValue < ::FieldValue
    include Mongoid::Document

    delegate :max_object_links, :linked_flow_id, to: :field_type

    #field :value, type: String # relationship ?
    has_and_belongs_to_many :value, class_name: 'Item', inverse_of: nil

  end
end