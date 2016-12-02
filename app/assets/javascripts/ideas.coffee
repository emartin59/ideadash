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


  confirmationText = (amount, balance) ->
    if amount <= balance
      "Are you sure you want to fund this idea with your funds in your account? (amount to be transferred is $#{ amount }, and you have $#{ balance })"
    else
      "You will now be redirected to Paypal to confirm funding. Amount to be transferred is $#{ amount }"

  if $('#new_payment').length
    window.vueform = new Vue
      el: '#new_payment'
      data:
        fundedAmount: '0,00'
      computed:
        amount: -> parseFloat @fundedAmount
        balance: -> parseFloat @$el.dataset.balance
        isInvalidAmount: -> @amount <= 0
      methods:
        confirmAction: ->
          unless @isInvalidAmount
            if confirm confirmationText(@amount, @balance)
              @$el.submit()

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
