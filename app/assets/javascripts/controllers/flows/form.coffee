class App.Controllers.Flows.Form extends Darwin.Controller
  @options {
    View: App.Views.Flows.Form
    events: {
      'Users clicks on button to add a new field':      { el: 'new_field_action', type: 'click' }
    }
  }

  new_field_action_clicked: ($element, $event)->
    $('#' + @view.get('field_type_dropdown').val()).click()