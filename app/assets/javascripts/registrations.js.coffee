# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".check-in").bind "change", ->
    $.ajax
      url: "/registrations/#{@value}/toggle"
      type: "POST"
      #success: (data, textStatus, jqXHR) ->
            #$('tr').siblings().addClass "success"
      data:
        checked_in: @checked


