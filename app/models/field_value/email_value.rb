class FieldValue
  class EmailValue < ::FieldValue
    include Mongoid::Document

    SINGLE_EMAIL_REGEXP   = /\A[^@\s,]+@([^@\s,]+\.)+[^@\s,]+\z/ # Taken directly from Devise.email_regexp but make sure no , are present in email
    MULTIPLE_EMAIL_REGEXP = /\A[^@\s,]+@([^@\s,]+\.)+[^@\s,]+(\s*,\s*[^@\s,]+@([^@\s,]+\.)+[^@\s,]+)*\z/ # allowing emails separated with , and spaces

    delegate :multiple_email_allowed?, :default_value, to: :field_type

    field     :value, type: String, pre_processed: true, default: ->{ default_value if field_container } # adding nil check against field_container due to https://github.com/mongoid/mongoid/issues/2945

    validates :value, format: { with: SINGLE_EMAIL_REGEXP },   unless: ->{ multiple_email_allowed? }
    validates :value, format: { with: MULTIPLE_EMAIL_REGEXP }, if:     ->{ multiple_email_allowed? }
  end
end