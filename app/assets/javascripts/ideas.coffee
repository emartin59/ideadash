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

  if $('.tag_list').length
    $('.tag_list').selectize
      delimiter: ','
      persist: false
      maxItems: 5
      preload: true
      load: (q, cb) ->
        $.getJSON "/tags?q=#{q}", (data) ->
          selTags = _.map data.tags, (tag) -> { value: tag, text: tag }
          cb(selTags)
      create: (input) ->
        value: input,
        text: input
