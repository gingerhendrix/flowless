class App.Controllers.Flows.Form extends Darwin.Controller
  @options {
    View: App.Views.Flows.Form
    events: {
      'Users clicks on button to add a new field':      { el: 'new_field_action', type: 'click' }
    }
  }

  new_field_action_clicked: ($element, $event)->
    selected_field_type = @view.get('field_type_dropdown').val()
    if selected_field_type
      $('#' + selected_field_type).click()
    else
      # @view.get('generated_dropdown').trigger('click.bs.dropdown')
      # $('button[data-id=field_type_list]').trigger('click.bs.dropdown')
      #@view.get('field_type_dropdown').trigger('click')
      @view.get('generated_dropdown').trigger('click.bs.dropdown')