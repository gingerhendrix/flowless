class App.Views.Flows.Form extends Darwin.View
  @options {
    selectors: {
      new_field_action:    'button#add-field-button'
      field_type_dropdown: 'select#field_type_list'
      generated_dropdown:  'button[data-id=field_type_list]' # this will fail if bootstrap-select is not properly initialized
    }
  }

