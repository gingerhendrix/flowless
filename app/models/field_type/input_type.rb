class FieldType
  class InputType < ::FieldType
    field     :placeholder, type: String     # input fields can have a placeholder

    field     :label, type: String           # input fields can have an associated label

    field     :default_value, type: String   # input field can have a default value

    field     :masked,  type: Boolean, default: false   # wether or not the field should be masked and use a password type or regular input
    validates :masked,  presence: true  # with mongoid 4, a string "true" will automatically be converted to true

    field     :min_char_count, type: Integer, default: nil # can set the mininum number of character allowed for the value, nil means no limit
    validates :min_char_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

    field     :max_char_count, type: Integer, default: nil # can set the maximum number of character allowed for the value, nil means no limit
    validates :max_char_count, numericality: { only_integer: true, greater_than_or_equal_to: ->(input_type){ input_type.minimum_max_char_count_allowed } }, allow_nil: true #TODO: fix validation message it gives this for now: {:one=>"is too long (maximum is 1 character)", :other=>"is too long (maximum is %{count} characters)"}
    # max char count must allows be greater or equal than the min char if it is defined, otherwise it must be at least 1 char long to avoid potential conflicts with the "none" optional option.

    field     :validation_regexp, type: Regexp # a regexp can be supplied to validate the value of the field

    def length_constraints?
      min_char_count || max_char_count
    end

    def minimum_max_char_count_allowed
      unless min_char_count.nil?
        min_char_count == 0 ? 1 : min_char_count
      else
        1
      end
    end
  end
end