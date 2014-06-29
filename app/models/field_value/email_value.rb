class FieldValue
  class EmailValue < ::FieldValue
    include Mongoid::Document

    SINGLE_EMAIL_REGEXP   = /\A[^@\s,]+@([^@\s,]+\.)+[^@\s,]+\z/ # Taken directly from Devise.email_regexp but make sure no , are present in email
    MULTIPLE_EMAIL_REGEXP = /\A[^@\s,]+@([^@\s,]+\.)+[^@\s,]+(\s*,\s*[^@\s,]+@([^@\s,]+\.)+[^@\s,]+)*\z/ # allowing emails separated with , and spaces

    delegate :multiple_email_allowed?, :default_value, to: :field_type

    field     :value, type: String

    validates :value, format: { with: SINGLE_EMAIL_REGEXP },   allow_nil: true, unless: ->{ multiple_email_allowed? } # allowing nil is important in case there are no value provided (when optional)
    validates :value, format: { with: MULTIPLE_EMAIL_REGEXP }, allow_nil: true, if:     ->{ multiple_email_allowed? } # allowing nil is important in case there are no value provided (when optional)
  end
end