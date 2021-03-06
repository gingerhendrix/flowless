class FieldValue
  class InputValue < ::FieldValue
    include Mongoid::Document

    delegate :validation_regexp, :min_char_count, :max_char_count, :default_value, :length_constraints?, to: :field_type

    field :value, type: String

    validates :value, format: { with: ->(v) { v.validation_regexp } }, allow_blank: true, on: :create, if: ->{ validation_regexp } # allowing blank is important in case there are no value provided (when optional)

    validate  :input_value_length_constraints_validation, on: :create, if: ->{ length_constraints? && !value.blank? } # making sure not to try the validation if the value is blank

    # WARNING this needs to support UTF-8 encoding - should be ok by default on Ruby 2+
    def input_value_length_constraints_validation
      errors.add :value, I18n.t('errors.messages.too_short', count: value.size) if min_char_count && value.size < min_char_count
      errors.add :value, I18n.t('errors.messages.too_long',  count: value.size) if max_char_count && value.size > max_char_count
    end

  end
end