$(document).ready ->
  if $("textarea").length > 0
    CKEDITOR_BASEPATH = '/assets/ckeditor/'
    data = $("textarea")
    $.each data, (i) ->
      CKEDITOR.replace data[i].id