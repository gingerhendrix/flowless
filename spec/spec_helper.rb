require 'rails_helper'

def save_and_open_rspec_page
  File.open('/tmp/test.html','w'){|file| file.write(response.body)}; `open '/tmp/test.html'`
end