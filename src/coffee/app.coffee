window.App = Backbone.Model.extend
    initialize: ->
        _.bindAll this

        _.defer =>
            @location = new Location
            @locationView = new LocationView model: @location, el: document.getElementById 'location'
            @locationView.render()

            @stations = new StationCollection
            @stationsView = new StationCollectionView model: @stations, el: document.getElementById 'stations'

            @travel = new Travel

# Bootstrap application on jQuery/Zepto ready  (use deviceReady for PhoneGap)
$ ->
    window.app = new App()