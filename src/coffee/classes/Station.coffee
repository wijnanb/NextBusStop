window.Station = Backbone.Model.extend
    defaults:
        id: undefined
        latitude: null
        longitude: null
        name: null
        standardname: null

    initialize: ->

    distanceFromCurrent: ->
        current_coords = app.location.get('current').coords
        unless current_coords.latitude? and current_coords.longitude?
            console.error "current position not available to calculate distance for ", @get('id')

        current_position = new LatLon parseFloat(current_coords.latitude), parseFloat(current_coords.longitude)
        station_position = new LatLon parseFloat(@get 'latitude'), parseFloat(@get 'longitude')

        # distance in kilometers
        distance = current_position.distanceTo station_position


window.StationCollection = Backbone.Collection.extend
    model: Station
    url: config.stationsAPI
    _idAttr: 'id'
    initialize: ->
        _.bindAll this
        try
            if localStorage["stations"]?
                stations = JSON.parse localStorage["stations"]
                @reset stations
        catch error
            console.error error

        @fetch (success: @onFetchStations, error: @onFetchStationsError)

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

    getDistanceMap: ->
        @each (station, index) =>
            distance = station.distanceFromCurrent()
            name = station.get('name')
            console.log name, distance, 'km'
