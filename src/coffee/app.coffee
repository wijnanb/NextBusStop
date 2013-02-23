window.App = Backbone.Model.extend
    initialize: ->
        _.bindAll this

        @stations = new StationCollection

        @location = new Location
        @locationView = new LocationView model: @location, el: document.getElementById 'location'
        @locationView.render()



# Bootstrap application on jQuery/Zepto ready  (use deviceReady for PhoneGap)
$ ->
    window.app = new App()