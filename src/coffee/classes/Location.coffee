window.Location = Backbone.Model.extend
    defaults:
        current:
            coords:
                latitude: null
                longitude: null
            timestamp: null
        log: ""

    initialize: ->
        _.bindAll this
        @watchPosition()

    watchPosition: ->
        options =
        @watchId = navigator.geolocation.watchPosition @onPositionUpdate, @onPositionError, options

    onPositionUpdate: (position) ->
        @write "position update at #{Date(position.timestamp)}"
        @set current: position

    onPositionError: (error) ->
        @write "Error getting your position"
        if error.code is error.PERMISSION_DENIED
            @write "permission denied"
        else if error.code is error.POSITION_UNAVAILABLE
            @write "position not available"
        else
            @write "timeout"

    write: (message) ->
        @set log: "<p>" + message + "</p>" + @get('log')




window.LocationView = Backbone.View.extend
    initialize: ->
        _.bindAll this
        @current = @$el.find '.current'
        @log = @$el.find '.log'

        @model.on 'change:current', @render
        @model.on 'change:log', @render

    render: ->
        @current.html @model.get('current').coords.latitude + ", " + @model.get('current').coords.longitude
        @log.html @model.get('log')
        return this


