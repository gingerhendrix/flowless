class FieldTypePresenter < ApplicationPresenter
  presents :field_type

  # delegete :name, to: field_type or just # delegete :name
end
