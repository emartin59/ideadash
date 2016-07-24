Vue.directive 'array',
  twoWay: true
  bind: ->
    @listener = => @set @el.value.split(', ')
    $(@el).on 'change', @listener
    $(@el).on 'input', @listener
    @afterBind = @listener
  update: (value) ->
    @el.value = value.join(', ')
  unbind: ->
    jQuery(el).off 'change', @listener
    jQuery(el).off 'input', @listener
