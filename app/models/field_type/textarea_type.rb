class FieldType
  class TextareaType < ::FieldType

    FORMATS = AppConfig.textarea_formats

    field     :placeholder, type: String     # textarea fields can have a placeholder

    field     :label, type: String           # textarea fields can have an associated label

    field     :default_value, type: String   # textarea field can have a default value

    field     :min_char_count, type: Integer, default: nil # can set the mininum number of character allowed for the value, nil means no limit
    validates :min_char_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

    field     :max_char_count, type: Integer, default: nil # can set the maximum number of character allowed for the value, nil means no limit
    validates :max_char_count, numericality: { only_integer: true, greater_than_or_equal_to: ->(input_type){ input_type.minimum_max_char_count_allowed } }, allow_nil: true
    # max char count must allows be greater or equal than the min char if it is defined, otherwise it must be at least 1 char long to avoid potential conflicts with the "none" optional option.

    field     :validation_regexp, type: Regexp # a regexp can be supplied to validate the value of the field

    field     :resizable,  type: Boolean, default: false   # wether or not the text area should be resizable by the user filling in the form
    validates :resizable,  presence: true  # with mongoid 4, a string "true" will automatically be converted to true

    field     :height, type: Integer, default: 2 # size of the textarea in lines (might need to do conversion from pixels)
    validates :height, numericality: { only_integer: true, greater_than_or_equal_to: 2 } # arbitraty value, 2 lines minimum of text
    validates :height, presence: true

    field     :format, type: String, default: AppConfig.textarea_formats.first
    validates :format, inclusion: { in: FORMATS }

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