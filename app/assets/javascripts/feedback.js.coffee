enable_button =->
  if $('#feedback_to').val() == ""
    $('#ask').prop 'disabled', true
  else
    $('#ask').prop 'disabled', false
    
$ ->
  $('#feedback_to').change ->
    enable_button()