module ApplicationHelper
  include BasePresenter::ApplicationHelper

  # convert the 'regular' flash message type with a compatible set for bootstrap
  def set_flash_message_type_for_bootstrap(type)
    case type
    when 'error'
      'danger'
    when 'alert'
      'warning'
    when 'success', 'info', 'warning', 'danger'
      type
    else
      'info'
    end
  end

end
