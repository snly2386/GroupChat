class Opentok.Router extends Backbone.Router

  initialize: ->
    Backbone.history.start()

  routes: ->
  	''					: 'landing'
  	'users/sign_in'		: 'sign_in'
  	'rooms'			    : 'all_rooms'
  	'rooms/:id'			: 'show_room'

  landing: ->
  	@create_rooms()
  	view = new Opentok.Landing app: @, collection: @rooms

  all_rooms: ->
  	@create_rooms()
  	view = new Opentok.AllRooms app: @, collection: @rooms

  show_room: (id) ->
  	@create_rooms()
  	view = new Opentok.ShowRoom app: @, collection: @rooms, id: id

  create_rooms: ->
  	@rooms ||= new Opentok.Rooms()







