base_url = 'http://www.tnt.com/webtracker/tracking.do?'

class AppViewModel
  # Application Constructor
  constructor: ->
    @pickup_date = ko.observable 'Pickup date empty'
    @destination = ko.observable 'Destination empty'
    @delivery_date = ko.observable 'Delivery date empty'

    @history =
      header: ko.observableArray []
      body: ko.observableArray []

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
          parsed = $("table tbody", context)
          [package_table, history_table] = [parsed[1].children, parsed[2].children]

          # Package informations
          @pickup_date @_children_textContent package_table[0]
          @destination @_children_textContent package_table[1]
          @delivery_date @_sanitize @_children_textContent package_table[2]


          # History
          history_array = Array.prototype.slice.call(history_table)
          history_header = history_array[0]
          history_body = history_array[1..]

          @history.header.removeAll()
          @history.body.removeAll()

          # Table header
          $.each history_header.children, (index, item) =>
            @history.header.push item.textContent


          # Table body
          $.each history_body, (index, value) =>
            @history.body.push $.map value.children, (data) ->
              data.textContent

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