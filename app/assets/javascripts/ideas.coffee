$ ->
  if $('.simple_form.new_idea, .simple_form.edit_idea').length
    window.form = new Vue
      el: '.simple_form.new_idea, .simple_form.edit_idea'
      data: summary: ''
      computed:
        summaryLength: ->
          left = 200 - @summary.length
          if left > 0
            "#{ left } characters left"
          else
            'Please be brief.'
        showHint: ->
          @summary.length > 100
