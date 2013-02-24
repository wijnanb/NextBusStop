window.Travel = Backbone.Model.extend
    defaults:
        journey: ['Genk','Bokrijk','Kiewit','Hasselt','Landen','Tienen','Leuven']
        index: null
        distance_to_next: null
        distance_to_next_traveled: 0

    step: 1 #seconds between each increment
    distance_per_step: 0.2 #kilometers traveled per step
    station_wait: 2 #seconds to wait in station

    initialize: ->
        @on 'change:index', @atStation

        _.delay =>
            @startJourney()
        , 1000

    atStation: ->
        index = @get 'index'
        next_index = index + 1
        station = app.stations.getStationByName @get('journey')[index]
        next_station = app.stations.getStationByName @get('journey')[next_index]

        if next_station?
            @set
                distance_to_next: app.stations.distanceBetween station, next_station
                distance_to_next_traveled: 0
            console.log "at station", station.get('name'), @get('distance_to_next')
            @increment()
        else
            console.log "at station", station.get('name')
            @end()

    startJourney: ->
        console.log "startJourney"
        @set index: 0

    increment: ->
        console.log "increment", @get('distance_to_next_traveled'), @get('distance_to_next')

        clearTimeout @intervalId
        @intervalId = _.delay =>
            index = @get('index')
            next_index = index+1

            @set distance_to_next_traveled: @get('distance_to_next_traveled') + @distance_per_step
            traveled = @get('distance_to_next_traveled')
            goal = @get('distance_to_next')

            # interpolate
            factor = traveled / goal
            station = app.stations.getStationByName @get('journey')[index]
            next_station = app.stations.getStationByName @get('journey')[next_index]

            latitude = station.get('latitude') + factor * (next_station.get('latitude')-station.get('latitude'))
            longitude = station.get('longitude') + factor * (next_station.get('longitude')-station.get('longitude'))

            console.log "current", latitude, longitude
            app.location.set current:
                coords:
                    latitude: latitude
                    longitude: longitude

            if traveled >= goal
                @set index: next_index
            else
                @increment()
        , @step * 1000

    end: ->
        console.log "end"