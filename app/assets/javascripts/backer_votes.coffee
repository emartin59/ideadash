$(document).ready ->
  if $('.backer-voting').length
    new Vue
      el: '.backer-voting'
      data:
        kind: undefined
        previous_kind: undefined
        implementation_id: undefined
      computed:
        showImplementations: ->
          @kind is 'vote'
      methods:
        confirmVote: (e) ->
          if @showImplementations and @implementation_id and @previous_kind isnt 'vote'
            unless confirm('Casting this implementation vote means that, during this month and for this idea, no longer can you vote to extend for another month of proposals or vote to have funds credited back to your account. Are you sure that you want to vote for this implementation?')
              e.preventDefault()
