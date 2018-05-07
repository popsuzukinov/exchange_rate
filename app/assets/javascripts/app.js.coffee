### Redmine - project management software
   Copyright (C) 2006-2016  Jean-Philippe Lang 
###

checkAll = (id, checked) ->
  $('#' + id).find('input[type=checkbox]:enabled').prop 'checked', checked
  return

toggleCheckboxesBySelector = (selector) ->
  all_checked = true
  $(selector).each (index) ->
    if !$(this).is(':checked')
      all_checked = false
    return
  $(selector).prop 'checked', !all_checked
  return

showAndScrollTo = (id, focus) ->
  $('#' + id).show()
  if focus != null
    $('#' + focus).focus()
  $('html, body').animate { scrollTop: $('#' + id).offset().top }, 100
  return

toggleRowGroup = (el) ->
  tr = $(el).parents('tr').first()
  n = tr.next()
  tr.toggleClass 'open'
  while n.length and !n.hasClass('group')
    n.toggle()
    n = n.next('tr')
  return

collapseAllRowGroups = (el) ->
  tbody = $(el).parents('tbody').first()
  tbody.children('tr').each (index) ->
    if $(this).hasClass('group')
      $(this).removeClass 'open'
    else
      $(this).hide()
    return
  return

expandAllRowGroups = (el) ->
  tbody = $(el).parents('tbody').first()
  tbody.children('tr').each (index) ->
    if $(this).hasClass('group')
      $(this).addClass 'open'
    else
      $(this).show()
    return
  return

toggleAllRowGroups = (el) ->
  tr = $(el).parents('tr').first()
  if tr.hasClass('open')
    collapseAllRowGroups el
  else
    expandAllRowGroups el
  return

toggleFieldset = (el) ->
  fieldset = $(el).parents('fieldset').first()
  fieldset.toggleClass 'collapsed'
  fieldset.children('div').toggle()
  return

hideFieldset = (el) ->
  fieldset = $(el).parents('fieldset').first()
  fieldset.toggleClass 'collapsed'
  fieldset.children('div').hide()
  return

# columns selection

moveOptions = (theSelFrom, theSelTo) ->
  $(theSelFrom).find('option:selected').detach().prop('selected', false).appendTo $(theSelTo)
  return

moveOptionUp = (theSel) ->
  $(theSel).find('option:selected').each ->
    $(this).prev(':not(:selected)').detach().insertAfter $(this)
    return
  return

moveOptionTop = (theSel) ->
  $(theSel).find('option:selected').detach().prependTo $(theSel)
  return

moveOptionDown = (theSel) ->
  $($(theSel).find('option:selected').get().reverse()).each ->
    $(this).next(':not(:selected)').detach().insertBefore $(this)
    return
  return

moveOptionBottom = (theSel) ->
  $(theSel).find('option:selected').detach().appendTo $(theSel)
  return

initFilters = ->
  $('#add_filter_select').change ->
    addFilter $(this).val(), '', []
    return
  $('#filters-table td.field input[type=checkbox]').each ->
    toggleFilter $(this).val()
    return
  $('#filters-table').on 'click', 'td.field input[type=checkbox]', ->
    toggleFilter $(this).val()
    return
  $('#filters-table').on 'click', '.toggle-multiselect', ->
    toggleMultiSelect $(this).siblings('select')
    return
  $('#filters-table').on 'keypress', 'input[type=text]', (e) ->
    if e.keyCode == 13
      $(this).closest('form').submit()
    return
  return

addFilter = (field, operator, values) ->
  fieldId = field.replace('.', '_')
  tr = $('#tr_' + fieldId)
  if tr.length > 0
    tr.show()
  else
    buildFilterRow field, operator, values
  $('#cb_' + fieldId).prop 'checked', true
  toggleFilter field
  $('#add_filter_select').val('').find('option').each ->
    if $(this).attr('value') == field
      $(this).attr 'disabled', true
    return
  return

buildFilterRow = (field, operator, values) ->
  `var option`
  `var filterValue`
  `var option`
  fieldId = field.replace('.', '_')
  filterTable = $('#filters-table')
  filterOptions = availableFilters[field]
  if !filterOptions
    return
  operators = operatorByType[filterOptions['type']]
  filterValues = filterOptions['values']
  i = undefined
  select = undefined
  tr = $('<tr class="filter">').attr('id', 'tr_' + fieldId).html('<td class="field"><input checked="checked" id="cb_' + fieldId + '" name="f[]" value="' + field + '" type="checkbox"><label for="cb_' + fieldId + '"> ' + filterOptions['name'] + '</label></td>' + '<td class="operator"><select id="operators_' + fieldId + '" name="op[' + field + ']"></td>' + '<td class="values"></td>')
  filterTable.append tr
  select = tr.find('td.operator select')
  i = 0
  while i < operators.length
    option = $('<option>').val(operators[i]).text(operatorLabels[operators[i]])
    if operators[i] == operator
      option.attr 'selected', true
    select.append option
    i++
  select.change ->
    toggleOperator field
    return
  switch filterOptions['type']
    when 'list', 'list_optional', 'list_status', 'list_subprojects'
      tr.find('td.values').append '<span style="display:none;"><select class="value" id="values_' + fieldId + '_1" name="v[' + field + '][]"></select>' + ' <span class="toggle-multiselect">&nbsp;</span></span>'
      select = tr.find('td.values select')
      if values.length > 1
        select.attr 'multiple', true
      i = 0
      while i < filterValues.length
        filterValue = filterValues[i]
        option = $('<option>')
        if $.isArray(filterValue)
          option.val(filterValue[1]).text filterValue[0]
          if $.inArray(filterValue[1], values) > -1
            option.attr 'selected', true
        else
          option.val(filterValue).text filterValue
          if $.inArray(filterValue, values) > -1
            option.attr 'selected', true
        select.append option
        i++
    when 'date', 'date_past'
      tr.find('td.values').append '<span style="display:none;"><input type="date" name="v[' + field + '][]" id="values_' + fieldId + '_1" size="10" class="value date_value" /></span>' + ' <span style="display:none;"><input type="date" name="v[' + field + '][]" id="values_' + fieldId + '_2" size="10" class="value date_value" /></span>' + ' <span style="display:none;"><input type="text" name="v[' + field + '][]" id="values_' + fieldId + '" size="3" class="value" /> ' + labelDayPlural + '</span>'
      $('#values_' + fieldId + '_1').val(values[0]).datepickerFallback datepickerOptions
      $('#values_' + fieldId + '_2').val(values[1]).datepickerFallback datepickerOptions
      $('#values_' + fieldId).val values[0]
    when 'string', 'text'
      tr.find('td.values').append '<span style="display:none;"><input type="text" name="v[' + field + '][]" id="values_' + fieldId + '" size="30" class="value" /></span>'
      $('#values_' + fieldId).val values[0]
    when 'relation'
      tr.find('td.values').append '<span style="display:none;"><input type="text" name="v[' + field + '][]" id="values_' + fieldId + '" size="6" class="value" /></span>' + '<span style="display:none;"><select class="value" name="v[' + field + '][]" id="values_' + fieldId + '_1"></select></span>'
      $('#values_' + fieldId).val values[0]
      select = tr.find('td.values select')
      i = 0
      while i < allProjects.length
        filterValue = allProjects[i]
        option = $('<option>')
        option.val(filterValue[1]).text filterValue[0]
        if values[0] == filterValue[1]
          option.attr 'selected', true
        select.append option
        i++
    when 'integer', 'float', 'tree'
      tr.find('td.values').append '<span style="display:none;"><input type="text" name="v[' + field + '][]" id="values_' + fieldId + '_1" size="14" class="value" /></span>' + ' <span style="display:none;"><input type="text" name="v[' + field + '][]" id="values_' + fieldId + '_2" size="14" class="value" /></span>'
      $('#values_' + fieldId + '_1').val values[0]
      $('#values_' + fieldId + '_2').val values[1]
  return

toggleFilter = (field) ->
  fieldId = field.replace('.', '_')
  if $('#cb_' + fieldId).is(':checked')
    $('#operators_' + fieldId).show().removeAttr 'disabled'
    toggleOperator field
  else
    $('#operators_' + fieldId).hide().attr 'disabled', true
    enableValues field, []
  return

enableValues = (field, indexes) ->
  fieldId = field.replace('.', '_')
  $('#tr_' + fieldId + ' td.values .value').each (index) ->
    if $.inArray(index, indexes) >= 0
      $(this).removeAttr 'disabled'
      $(this).parents('span').first().show()
    else
      $(this).val ''
      $(this).attr 'disabled', true
      $(this).parents('span').first().hide()
    if $(this).hasClass('group')
      $(this).addClass 'open'
    else
      $(this).show()
    return
  return

toggleOperator = (field) ->
  fieldId = field.replace('.', '_')
  operator = $('#operators_' + fieldId)
  switch operator.val()
    when '!*', '*', 't', 'ld', 'w', 'lw', 'l2w', 'm', 'lm', 'y', 'o', 'c', '*o', '!o'
      enableValues field, []
    when '><'
      enableValues field, [
        0
        1
      ]
    when '<t+', '>t+', '><t+', 't+', '>t-', '<t-', '><t-', 't-'
      enableValues field, [ 2 ]
    when '=p', '=!p', '!p'
      enableValues field, [ 1 ]
    else
      enableValues field, [ 0 ]
      break
  return

toggleMultiSelect = (el) ->
  if el.attr('multiple')
    el.removeAttr 'multiple'
    el.attr 'size', 1
  else
    el.attr 'multiple', true
    if el.children().length > 10
      el.attr 'size', 10
    else
      el.attr 'size', 4
  return

showTab = (name, url) ->
  $('#tab-content-' + name).parent().find('.tab-content').hide()
  $('#tab-content-' + name).parent().find('div.tabs a').removeClass 'selected'
  $('#tab-content-' + name).show()
  $('#tab-' + name).addClass 'selected'
  #replaces current URL with the "href" attribute of the current link
  #(only triggered if supported by browser)
  if 'replaceState' of window.history
    window.history.replaceState null, document.title, url
  false

moveTabRight = (el) ->
  lis = $(el).parents('div.tabs').first().find('ul').children()
  bw = $(el).parents('div.tabs-buttons').outerWidth(true)
  tabsWidth = 0
  i = 0
  lis.each ->
    if $(this).is(':visible')
      tabsWidth += $(this).outerWidth(true)
    return
  if tabsWidth < $(el).parents('div.tabs').first().width() - bw
    return
  $(el).siblings('.tab-left').removeClass 'disabled'
  while i < lis.length and !lis.eq(i).is(':visible')
    i++
  w = lis.eq(i).width()
  lis.eq(i).hide()
  if tabsWidth - w < $(el).parents('div.tabs').first().width() - bw
    $(el).addClass 'disabled'
  return

moveTabLeft = (el) ->
  lis = $(el).parents('div.tabs').first().find('ul').children()
  i = 0
  while i < lis.length and !lis.eq(i).is(':visible')
    i++
  if i > 0
    lis.eq(i - 1).show()
    $(el).siblings('.tab-right').removeClass 'disabled'
  if i <= 1
    $(el).addClass 'disabled'
  return

displayTabsButtons = ->
  lis = undefined
  tabsWidth = undefined
  el = undefined
  numHidden = undefined
  $('div.tabs').each ->
    el = $(this)
    lis = el.find('ul').children()
    tabsWidth = 0
    numHidden = 0
    lis.each ->
      if $(this).is(':visible')
        tabsWidth += $(this).outerWidth(true)
      else
        numHidden++
      return
    bw = $(el).parents('div.tabs-buttons').outerWidth(true)
    if tabsWidth < el.width() - bw and (lis.length == 0 or lis.first().is(':visible'))
      el.find('div.tabs-buttons').hide()
    else
      el.find('div.tabs-buttons').show().children('button.tab-left').toggleClass 'disabled', numHidden == 0
    return
  return

setPredecessorFieldsVisibility = ->
  relationType = $('#relation_relation_type')
  if relationType.val() == 'precedes' or relationType.val() == 'follows'
    $('#predecessor_fields').show()
  else
    $('#predecessor_fields').hide()
  return

showModal = (id, width, title) ->
  el = $('#' + id).first()
  if el.length == 0 or el.is(':visible')
    return
  if !title
    title = el.find('h3.title').text()
  # moves existing modals behind the transparent background
  $('.modal').zIndex 99
  el.dialog(
    width: width
    modal: true
    resizable: false
    dialogClass: 'modal'
    title: title).on 'dialogclose', ->
    $('.modal').zIndex 101
    return
  el.find('input[type=text], input[type=submit]').first().focus()
  return

hideModal = (el) ->
  modal = undefined
  if el
    modal = $(el).parents('.ui-dialog-content')
  else
    modal = $('#ajax-modal')
  modal.dialog 'close'
  return

submitPreview = (url, form, target) ->
  $.ajax
    url: url
    type: 'post'
    data: $('#' + form).serialize()
    success: (data) ->
      $('#' + target).html data
      return
  return

collapseScmEntry = (id) ->
  $('.' + id).each ->
    if $(this).hasClass('open')
      collapseScmEntry $(this).attr('id')
    $(this).hide()
    return
  $('#' + id).removeClass 'open'
  return

expandScmEntry = (id) ->
  $('.' + id).each ->
    $(this).show()
    if $(this).hasClass('loaded') and !$(this).hasClass('collapsed')
      expandScmEntry $(this).attr('id')
    return
  $('#' + id).addClass 'open'
  return

scmEntryClick = (id, url) ->
  el = $('#' + id)
  if el.hasClass('open')
    collapseScmEntry id
    el.addClass 'collapsed'
    return false
  else if el.hasClass('loaded')
    expandScmEntry id
    el.removeClass 'collapsed'
    return false
  if el.hasClass('loading')
    return false
  el.addClass 'loading'
  $.ajax
    url: url
    success: (data) ->
      el.after data
      el.addClass('open').addClass('loaded').removeClass 'loading'
      return
  true

randomKey = (size) ->
  chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  key = ''
  i = 0
  while i < size
    key += chars.charAt(Math.floor(Math.random() * chars.length))
    i++
  key

updateIssueFrom = (url, el) ->
  $('#all_attributes input, #all_attributes textarea, #all_attributes select').each ->
    $(this).data 'valuebeforeupdate', $(this).val()
    return
  if el
    $('#form_update_triggered_by').val $(el).attr('id')
  $.ajax
    url: url
    type: 'post'
    data: $('#issue-form').serialize()

replaceIssueFormWith = (html) ->
  replacement = $(html)
  $('#all_attributes input, #all_attributes textarea, #all_attributes select').each ->
    object_id = $(this).attr('id')
    if object_id and $(this).data('valuebeforeupdate') != $(this).val()
      replacement.find('#' + object_id).val $(this).val()
    return
  $('#all_attributes').empty()
  $('#all_attributes').prepend replacement
  return

updateBulkEditFrom = (url) ->
  $.ajax
    url: url
    type: 'post'
    data: $('#bulk_edit_form').serialize()
  return

observeAutocompleteField = (fieldId, url, options) ->
  $(document).ready ->
    $('#' + fieldId).autocomplete $.extend({
      source: url
      minLength: 2
      position: collision: 'flipfit'
      search: ->
        $('#' + fieldId).addClass 'ajax-loading'
        return
      response: ->
        $('#' + fieldId).removeClass 'ajax-loading'
        return

    }, options)
    $('#' + fieldId).addClass 'autocomplete'
    return
  return

observeSearchfield = (fieldId, targetId, url) ->
  $('#' + fieldId).each ->
    $this = $(this)
    $this.addClass 'autocomplete'
    $this.attr 'data-value-was', $this.val()

    check = ->
      val = $this.val()
      if $this.attr('data-value-was') != val
        $this.attr 'data-value-was', val
        $.ajax
          url: url
          type: 'get'
          data: q: $this.val()
          success: (data) ->
            if targetId
              $('#' + targetId).html data
            return
          beforeSend: ->
            $this.addClass 'ajax-loading'
            return
          complete: ->
            $this.removeClass 'ajax-loading'
            return
      return

    reset = ->
      if timer
        clearInterval timer
        timer = setInterval(check, 300)
      return

    timer = setInterval(check, 300)
    $this.bind 'keyup click mousemove', reset
    return
  return

beforeShowDatePicker = (input, inst) ->
  default_date = null
  switch $(input).attr('id')
    when 'issue_start_date'
      if $('#issue_due_date').size() > 0
        default_date = $('#issue_due_date').val()
    when 'issue_due_date'
      if $('#issue_start_date').size() > 0
        start_date = $('#issue_start_date').val()
        if start_date != ''
          start_date = new Date(Date.parse(start_date))
          if start_date > new Date
            default_date = $('#issue_start_date').val()
  $(input).datepickerFallback 'option', 'defaultDate', default_date
  return

initMyPageSortable = (list, url) ->
  $('#list-' + list).sortable
    connectWith: '.block-receiver'
    tolerance: 'pointer'
    update: ->
      $.ajax
        url: url
        type: 'post'
        data: 'blocks': $.map($('#list-' + list).children(), (el) ->
          $(el).attr 'id'
        )
      return
  $('#list-top, #list-left, #list-right').disableSelection()
  return

warnLeavingUnsaved = (message) ->
  warnLeavingUnsavedMessage = message
  $(document).on 'submit', 'form', ->
    $('textarea').removeData 'changed'
    return
  $(document).on 'change', 'textarea', ->
    $(this).data 'changed', 'changed'
    return

  window.onbeforeunload = ->
    warn = false
    $('textarea').blur().each ->
      if $(this).data('changed')
        warn = true
      return
    if warn
      return warnLeavingUnsavedMessage
    return

  return

setupAjaxIndicator = ->
  $(document).bind 'ajaxSend', (event, xhr, settings) ->
    if $('.ajax-loading').length == 0 and settings.contentType != 'application/octet-stream'
      $('#ajax-indicator').show()
    return
  $(document).bind 'ajaxStop', ->
    $('#ajax-indicator').hide()
    return
  return

setupTabs = ->
  if $('.tabs').length > 0
    displayTabsButtons()
    $(window).resize displayTabsButtons
  return

hideOnLoad = ->
  $('.hol').hide()
  return

addFormObserversForDoubleSubmit = ->
  $('form[method=post]').each ->
    if !$(this).hasClass('multiple-submit')
      $(this).submit (form_submission) ->
        if $(form_submission.target).attr('data-submitted')
          form_submission.preventDefault()
        else
          $(form_submission.target).attr 'data-submitted', true
        return
    return
  return

defaultFocus = ->
  if $('#content :focus').length == 0 and window.location.hash == ''
    $('#content input[type=text], #content textarea').first().focus()
  return

blockEventPropagation = (event) ->
  event.stopPropagation()
  event.preventDefault()
  return

toggleDisabledOnChange = ->
  checked = $(this).is(':checked')
  $($(this).data('disables')).attr 'disabled', checked
  $($(this).data('enables')).attr 'disabled', !checked
  $($(this).data('shows')).toggle checked
  return

toggleDisabledInit = ->
  $('input[data-disables], input[data-enables], input[data-shows]').each toggleDisabledOnChange
  return

toggleNewObjectDropdown = ->
  dropdown = $('#new-object + ul.menu-children')
  if dropdown.hasClass('visible')
    dropdown.removeClass 'visible'
  else
    dropdown.addClass 'visible'
  return

keepAnchorOnSignIn = (form) ->
  hash = decodeURIComponent(self.document.location.hash)
  if hash
    if hash.indexOf('#') == -1
      hash = '#' + hash
    form.action = form.action + hash
  true

(($) ->

  $.fn.positionedItems = (sortableOptions, options) ->
    settings = $.extend({ firstPosition: 1 }, options)
    @sortable $.extend({
      axis: 'y'
      handle: '.sort-handle'
      helper: (event, ui) ->
        ui.children('td').each ->
          $(this).width $(this).width()
          return
        ui
      update: (event, ui) ->
        sortable = $(this)
        handle = ui.item.find('.sort-handle').addClass('ajax-loading')
        url = handle.data('reorder-url')
        param = handle.data('reorder-param')
        data = {}
        data[param] = position: ui.item.index() + settings['firstPosition']
        $.ajax
          url: url
          type: 'put'
          dataType: 'script'
          data: data
          success: (data) ->
            sortable.children(':even').removeClass('even').addClass 'odd'
            sortable.children(':odd').removeClass('odd').addClass 'even'
            return
          error: (jqXHR, textStatus, errorThrown) ->
            alert jqXHR.status
            sortable.sortable 'cancel'
            return
          complete: (jqXHR, textStatus, errorThrown) ->
            handle.removeClass 'ajax-loading'
            return
        return

    }, sortableOptions)

  return
) jQuery
warnLeavingUnsavedMessage = undefined
(($) ->
  # detect if native date input is supported
  nativeDateInputSupported = true
  input = document.createElement('input')
  input.setAttribute 'type', 'date'
  if input.type == 'text'
    nativeDateInputSupported = false
  notADateValue = 'not-a-date'
  input.setAttribute 'value', notADateValue
  if input.value == notADateValue
    nativeDateInputSupported = false

  $.fn.datepickerFallback = (options) ->
    if nativeDateInputSupported
      this
    else
      @datepicker options

  return
) jQuery
$(document).ready ->
  $('#content').on 'change', 'input[data-disables], input[data-enables], input[data-shows]', toggleDisabledOnChange
  toggleDisabledInit()
  return
$(document).ready setupAjaxIndicator
$(document).ready hideOnLoad
$(document).ready addFormObserversForDoubleSubmit
$(document).ready defaultFocus
$(document).ready setupTabs

# ---
# generated by js2coffee 2.2.0