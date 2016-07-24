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
        skipped_idea_ids: []
        currentIdx: 0
        skips: 0
      computed:
        nextPossible: -> @notLastVote and !@voteNotSelected
        skipPossible: -> @notLastVote and @voteNotSelected and @skips < 2
        notLastVote: -> @currentIdx < 4
        voteNotSelected: ->
          currentVote = @votes["vote_#{@currentIdx}"]
          !(currentVote.positive_idea_id or currentVote.negative_idea_id)
        prevPossible: -> @currentIdx > 0
        submitPossible: -> @currentIdx is 4 and @skips <= 2 and @skipped_idea_ids.length <= 4
      methods:
        updateSelect: (event) ->
          tgt = event.currentTarget
          positive = @votes["vote_#{@currentIdx}"].positive_idea_id = tgt.dataset.id
          negative = @votes["vote_#{@currentIdx}"].negative_idea_id = tgt.dataset.vs_id
          _.pull(@skipped_idea_ids, positive, negative)
          $(tgt.parentElement).find('.selected-idea').removeClass('selected-idea')
          $(tgt).addClass('selected-idea')
        nextVote: -> @currentIdx++ if @currentIdx < 4
        skipVote: ->
          @skips++
          @nextVote()
        prevVote: ->
          @currentIdx-- if @currentIdx > 0
          @skips-- if @votes["vote_#{@currentIdx}"].positive_idea_id is null
