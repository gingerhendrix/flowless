class FieldType
  class EmailType < ::FieldType
    field     :placeholder, type: String     # email fields can have a placeholder

    field     :label, type: String           # email fields can have an associated label

    field     :default_value, type: String   # email field can have a default value

    field     :blocked_keywords, type: Array, default: [] # email can forbide some keywords

    field     :multiple_emails, type: Boolean, default: false # can the email field contain more than one email address
    validates :multiple_emails, presence: true

    def multiple_email_allowed?
      multiple_emails
    end
  end
end