# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.

# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.

# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.

# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.

#= require jquery
#= require jquery_ujs
#= require jquery.turbolinks
#= require turbolinks
#= require bootstrap
#= require cocoon
#= require darwin
#= require bootstrap-select
#= require_tree ./views
#= require_tree ./controllers
#= require_tree .

$(->
  Darwin.Loader.run()
  AppInit.bootstrap_select()
)

@AppInit =
  bootstrap_select: ->
    $('select.form-control').selectpicker().removeClass('form-control') # using the default bootstrap 'form-control' class to have a nice fallback if somehow JS fails to load
    $('.bootstrap-select.form-control').removeClass('form-control')     # remove the lingering form-control that got brought over during the selectpicker() initialization

