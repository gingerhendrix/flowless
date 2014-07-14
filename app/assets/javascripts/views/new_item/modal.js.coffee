class App.Views.NewItem.Modal extends Darwin.View
  @options {
    selectors: {
      modal:
        sel:    '.modal-dialog'
        submit: 'input[type=submit]'
    }
  }

  switch_button_to_loading: ->
    @get('modal_submit').button('loading')