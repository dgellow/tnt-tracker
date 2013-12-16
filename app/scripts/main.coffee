base_url = 'http://www.tnt.com/webtracker/tracking.do?'

class AppViewModel
  # Application Constructor
  constructor: ->
    @pickup_date = ko.observable 'Pickup date empty'
    @destination = ko.observable 'Destination empty'
    @delivery_date = ko.observable 'Delivery date empty'

    @error = ko.observable null

  readInput: ->
    $("#consignment-number").val()

  fetch: =>
    cons_number = @readInput()

    if cons_number.length is 9
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
          @delivery_date @_sanitize @_children_textContent package_table[2]

          @error null

      .fail (data) ->
          alert 'FAIL'

    else
      @error {message: 'Consignments numbers are composed of 9 digits'}


  # private methods
  _sanitize: (html_data) ->
    $.trim html_data

  _children_textContent: (node) ->
    node.children[1].children[0].textContent

# Insanciate the application

app = new AppViewModel()
ko.applyBindings app