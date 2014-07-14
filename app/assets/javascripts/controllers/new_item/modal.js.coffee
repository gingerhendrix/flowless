class App.Controllers.NewItem.Modal extends Darwin.Controller
  @options {
    View: App.Views.NewItem.Modal
    events: {
      # 'Users clicks on create an item': {
      #   el:           'modal',
      #   stop:         false,
      #   type:         'click',
      #   delegate:     'modal_submit',
      #   view_method:  'switch_button_to_loading'
      # }
    }
  }
