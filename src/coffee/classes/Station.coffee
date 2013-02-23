window.Station = Backbone.Model.extend
    defaults:
        id: undefined
        locationX: null
        locationY: null
        name: null
        standardname: null

    initialize: ->


window.StationCollection = Backbone.Collection.extend
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

        try localStorage.setItem "stations", JSON.stringify stations
        catch error then console.error error

        return stations

    onFetchStations: ->
        console.log "Fetched #{@length} stations from the iRail server"

    onFetchStationsError: (model, xhr, options) ->
        console.error "error fetching stations from ", @url
