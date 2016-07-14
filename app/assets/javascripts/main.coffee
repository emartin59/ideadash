$(document).ready ->
  if $('#idea_search').length
    new Vue
      el: '#idea_search'
      data:
        results: []
        query: ''
        searchInProgress: false
      computed:
        showNoItems: ->
          (!@searchInProgress && @query.length > 2 && @results.length == 0)
      methods:
        loadResults: ->
          if @query.length > 2
            @searchInProgress = true
            algolia_index.search @query, { attributesToSnippet: ['description:20'] }, (err, content) =>
              @searchInProgress = false
              if err
                console.log(err)
              else
                @results = content.hits
