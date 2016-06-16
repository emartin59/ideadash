$ ->
  if $('.simple_form.with_short_fields').length
    new Vue
      el: '.simple_form'
      data:
        summary: ''
        title: ''
      computed:
        summaryLength: ->
          left = 200 - @summary.length
          if left > 0
            "#{ left } characters left"
          else
            'Please be brief.'
        titleLength: ->
          left = 60 - @title.length
          if left > 0
            "#{ left } characters left"
          else
            'Please be brief.'
        showSummaryHint: ->
          @summary.length > 100
        showTitleHint: ->
          @title.length > 50
