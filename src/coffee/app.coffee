window.App = Backbone.Model.extend
    initialize: ->
        _.bindAll this

        @stations = new StationCollection



# Bootstrap application on jQuery/Zepto ready  (use deviceReady for PhoneGap)
$ ->
    window.app = new App()