class App.Controllers.NewItem.Select extends Darwin.Controller
  @options {
    View: App.Views.NewItem.Select
    events: {
      'Users selects a flow': { el: 'new_item_selector', type: 'change' }
    }
  }

  new_item_selector_changed: ($element, $event)->
    flow_id = $element.val()
    if flow_id
      @view.disableNewItemButton()

      request = $.ajax({
        type: 'GET'
        url:  @view.get('root').attr('data-url').replace(':flow_id', flow_id)
        data: { }
      })

      controller = @

      request.done (response)->
        $('#new_item .modal-body').html(response)
        $('.modal-body .page-header').remove()
        # $('.modal-body .form-actions').remove()

        # $('.modal-body .modal-footer').remove()

        # $('#new_item .modal-body').insertAfter(
        #   "<div class='modal-footer'>
        #     <button class='btn btn-default btn-default' data-dismiss='modal' name='button' type='button'>Cancel</button>
        #     <button class='btn btn-default btn-primary' name='button' type='button'>Create</button>
        #   </div>")

        controller.view.enableNewItemButton()

      request.fail (jqXHR, textStatus)->
        alert('oops !?!')