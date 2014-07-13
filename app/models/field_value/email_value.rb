class FieldValue
  class EmailValue < ::FieldValue
    include Mongoid::Document

    SINGLE_EMAIL_REGEXP   = /\A[^@\s,]+@([^@\s,]+\.)+[^@\s,]+\z/ # Taken directly from Devise.email_regexp but make sure no , are present in email
    MULTIPLE_EMAIL_REGEXP = /\A[^@\s,]+@([^@\s,]+\.)+[^@\s,]+(\s*,\s*[^@\s,]+@([^@\s,]+\.)+[^@\s,]+)*\z/ # allowing emails separated with , and spaces

    delegate :multiple_emails?, :blocked_keywords, :default_value, to: :field_type

    field     :value, type: String

    validates :value, format: { with: SINGLE_EMAIL_REGEXP },   allow_blank: true, unless: ->{ multiple_emails? } # allowing nil is important in case there are no value provided (when optional)
    validates :value, format: { with: MULTIPLE_EMAIL_REGEXP }, allow_blank: true, if:     ->{ multiple_emails? } # allowing nil is important in case there are no value provided (when optional)

    validate :forbidden_keyword_validation, unless: ->{ blocked_keywords.empty? }

    # TOTEST, TODO improve the handling of the value regexp
    def forbidden_keyword_validation
      errors.add :value, I18n.t('errors.messages.exclusion') if value =~ /(#{blocked_keywords.split(',').map(&:strip).join('|')})/
    end
  end
end