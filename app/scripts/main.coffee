base_url = 'http://www.tnt.com/webtracker/tracking.do?'

class App
  # Application Constructor
  constructor: ->
    @pickup_date = (data) -> @_setContent('#pickup-date', data)
    @destination = (data) -> @_setContent('#destination', data)
    @delivery_date = (data) -> @_setContent('#delivery-date', data)


  readInput: ->
    $("#consignment-number").val()

  fetch: =>
    cons_number = @readInput()

    $.ajax
      type: 'GET'
      url: "#{base_url}cons=#{cons_number}"
      dataType: 'html'
    .done (data) =>
        context = $.parseHTML data
        console.debug context
        parsed = $("table tbody", context)
        console.debug parsed
        [package_table, history_table] = [parsed[1].children, parsed[2].children]

        @pickup_date @_children_textContent package_table[0]
        @destination @_children_textContent package_table[1]
        @delivery_date @_children_textContent package_table[2]

    .fail (data) ->
        alert 'FAIL'


  # private methods
  _setContent: (target, html_data) ->
    $(target).text($.trim html_data).html()

  _children_textContent: (node) ->
    node.children[1].children[0].textContent

# Insanciate the application
app = new App()

# Expose the api
root = exports ? this
root.tnttracker =
  fetch: app.fetch