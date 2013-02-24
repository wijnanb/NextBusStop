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
        #@watchPosition()

    watchPosition: ->
        options =
            maximumAge: 60000 # 1 minute old
            timeout: 30000 # wait 30 seconds
            enableHighAccuracy: true # turn on GPS of the device

        @watchId = navigator.geolocation.watchPosition @onPositionUpdate, @onPositionError, options

    onPositionUpdate: (position) ->
        @write "position update at #{Date(position.timestamp)}"
        position.latitude = parseFloat position.latitude
        position.longitude = parseFloat position.longitude
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
        @map = @$el.find '.map'

        @model.on 'change:current', @render
        @model.on 'change:log', @render

    render: ->
        latitude = @model.get('current').coords.latitude
        longitude = @model.get('current').coords.longitude
        width = $(window).width()

        @current.html latitude + ", " + longitude
        @log.html @model.get('log')

        if latitude? and longitude?
            map_url = "http://maps.googleapis.com/maps/api/staticmap?center=#{latitude},#{longitude}&amp;zoom=13&amp;size=#{width}x120&amp;sensor=false&amp;markers=color:red%7C#{latitude},#{longitude}"
            @map.html """<img src="#{map_url}" />"""

        return this


