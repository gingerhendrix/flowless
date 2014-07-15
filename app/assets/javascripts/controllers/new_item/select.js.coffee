class App.Controllers.NewItem.Select extends Darwin.Controller
  @options {
    View: App.Views.NewItem.Select
    events: {
      'Users selects a flow': { el: 'new_item_selector', type: 'change' }
    }
  }

  new_item_selector_changed: ($element, $event)->
    @view.disableNewItemButton()

    flow_id = $element.val()

    if flow_id
      request = $.ajax({
        type: 'GET'
        url:  @view.get('root').attr('data-url').replace(':flow_id', flow_id)
        data: {}
      })

      view = @view

      request.done (response)->
        $('#new_item .modal-content').html(response)
        view.enableNewItemButton()

      request.fail (jqXHR, textStatus)->
        view.get('new_item_selector').selectpicker('val', '')

    else
      @view.deactivateNewItemButton()