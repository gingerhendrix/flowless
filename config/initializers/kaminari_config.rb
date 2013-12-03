Kaminari.configure do |config|
  config.default_per_page  = 20 # 25 by default
  config.window            = 3  # 4 by default
  config.outer_window      = 1  # 0 by default
  config.left              = 1  # 0 by default
  config.right             = 1 # 0 by default

  # config.default_per_page = 25
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
end
