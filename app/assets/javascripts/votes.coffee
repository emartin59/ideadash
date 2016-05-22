$(document).ready ->
  if $('#voting_list').length
    new Vue
      el: '#voting_list'
      data:
        votes:
          vote_0:
            positive_idea_id: null
            negative_idea_id: null
          vote_1:
            positive_idea_id: null
            negative_idea_id: null
          vote_2:
            positive_idea_id: null
            negative_idea_id: null
          vote_3:
            positive_idea_id: null
            negative_idea_id: null
          vote_4:
            positive_idea_id: null
            negative_idea_id: null
        currentIdx: 0
      computed:
        nextPossible: ->
          currentVote = @votes["vote_#{@currentIdx}"]
          @currentIdx < 4 and currentVote.positive_idea_id and currentVote.negative_idea_id
        prevPossible: -> @currentIdx > 0
        submitPossible: ->
          return false if @currentIdx < 4
          for i in [0..4]
            vote = @votes["vote_#{@currentIdx}"]
            return false unless vote.positive_idea_id and vote.negative_idea_id
          return true
      methods:
        updateSelect: (event) ->
          tgt = event.currentTarget
          @votes["vote_#{@currentIdx}"].positive_idea_id = tgt.dataset.id
          @votes["vote_#{@currentIdx}"].negative_idea_id = tgt.dataset.vs_id
          $(tgt.parentElement).find('.selected-idea').removeClass('selected-idea')
          $(tgt).addClass('selected-idea')
        nextVote: (event) ->
          event.preventDefault()
          @currentIdx++ if @currentIdx < 4
        prevVote: (event) ->
          event.preventDefault()
          @currentIdx-- if @currentIdx > 0
