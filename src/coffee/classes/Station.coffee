window.Station = Backbone.Model.extend
    defaults:
        id: undefined
        latitude: null
        longitude: null
        name: null
        standardname: null
        distance: null

    initialize: ->
        @updateDistance()

    updateDistance: ->
        current_coords = app.location.get('current').coords
        if current_coords.latitude? and current_coords.longitude?
            current_position = new LatLon parseFloat(current_coords.latitude), parseFloat(current_coords.longitude)
            station_position = new LatLon parseFloat(@get 'latitude'), parseFloat(@get 'longitude')

            # distance in kilometers
            distance = parseFloat current_position.distanceTo station_position

            @set distance: distance
            return distance


window.StationCollection = Backbone.Collection.extend
    model: Station
    url: config.stationsAPI
    _idAttr: 'id'
    comparator: "distance"

    initialize: ->
        _.bindAll this
        try
            if localStorage["stations"]?
                stations = JSON.parse localStorage["stations"]
                @reset stations
        catch error
            console.error error

        @fetch (success: @onFetchStations, error: @onFetchStationsError)

        app.location.on 'change:current', @calculateDistanceMap

    parse: (response, options) ->
        stations = response.station

        # get rid of x,y coordinates, it's too confusing with latitude and longitude
        _.map stations, (element, index) ->
            element.latitude = element.locationY
            element.longitude = element.locationX
            delete element.locationX
            delete element.locationY

        try localStorage.setItem "stations", JSON.stringify stations
        catch error then console.error error

        return stations

    onFetchStations: ->
        console.log "Fetched #{@length} stations from the iRail server"

    onFetchStationsError: (model, xhr, options) ->
        console.error "error fetching stations from ", @url

    calculateDistanceMap: ->
        if app.location.get('current')?
            console.log "calculateDistanceMap"

            pending = @length
            @each (station, index) =>
                distance = station.updateDistance()
                name = station.get('name')
                #console.log name, distance, 'km'
                unless --pending
                    console.log "ready"
                    @sort()
                    @trigger "distanceMap"


window.StationCollectionView = Backbone.View.extend
    initialize: ->
        _.bindAll this
        @model.on "distanceMap", @render
        @model.on "reset", @render

    render: ->
        console.log "render"
        output = ""
        @model.each (station, index) =>
            distance = station.get('distance')
            name = station.get('name')
            output += """<div class="station">
                    <span class="name">#{name}</span>
                    <span class="distance">#{distance} km</span>
                </div>"""

        @$el.html output





