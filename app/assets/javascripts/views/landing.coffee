class Opentok.Landing extends Backbone.View

	className:  'landing'

	template: JST['templates/landing']

	initialize: (options) ->
		@app = options.app
		@page_animation()
		@collection = options.collection
		@model = ""
		@id = ""
		@navigate = @show_room
		@created = false
		console.log @navigate
		@collection.fetch
			success:(model, response, options) =>
			@render()
			@position()

	events: ->
		'click .sign-in-container' 		: 'open_menu'
		'click .close'			   		: 'close_menu'
		'click .find-room'		   		: 'all_rooms'
		'click .create-room'	   		: 'create_room'
		'click .down-arrow'				: 'create_model'
		'focus .create-input-bottom' 	: 'add_focus'
		'focusout .create-input-bottom' : 'remove_focus'

	create_model: ->
		app = @app
		overlay = @black_overlay
		loading = @loading_animation
		input = @$('.create-input-bottom input').val()
		new_model = new Opentok.Room name: input
		@model = new_model
		@collection.create new_model
		new_model.save null,
			success: (model, b,c) ->
				overlay(new_model, loading)
					# success:(d, e, f) =>
					# 	# console.log d
					# 	# id = e[e.length-1]['id']
					# 	# @id = id
					# 	overlay()
					# 	loading()


	show_room: (id) ->
		@app.navigate "rooms/#{id}", trigger: true

	black_overlay: (model, loading)->
		@$('.black-overlay').fadeIn(1000)
		model.fetch
			success: (model, b, c) ->
				id = b[b.length-1]['id']
				console.log id
				loading(id)

	loading_animation:(id) =>
		window.setTimeout (->
				@$('.circle').circleProgress({value: 100, size: 400, fill:{gradient: ['rgb(223, 86, 164)', 'rgb(146, 82, 226)', 'rgb(86, 184, 219)']}, animation: {duration: 40000, easing: 'swing'}, thickness: '10px'})
				@$('.placeholder').animate({'width' : '100px'}, 4000)
			), 1000

		window.setTimeout (=>
				console.log 'wtfffff'
				console.log @id
				@navigate(id)
			), 4000

	add_focus: ->
		@$('.create-input-bottom').animate 'width' : '400px', 1000

	remove_focus: ->
		@$('.create-input-bottom').animate 'width' : '288px', 1000

	create_room: ->
		@create_room_animation()
		open_menu = @open_create_menu
		window.setTimeout -> 
			open_menu()
		, 1500
		
	open_create_menu: ->
		if $(window).width() > 590
			window.setTimeout (->
				@$('.create-input-top').addClass('animated flipInX').show()
			), 100

			window.setTimeout (->
				@$('.create-input-middle').addClass('animated flipInY').show()
			), 500

			window.setTimeout (->
				@$('.create-input-bottom').addClass('animated flipInX').show()
				@$('.create-room').fadeOut('fast')
				@$('.find-room').fadeOut('fast')
			), 1000
		else 
			@$('.create-room, .find-room').hide 'explode'

			window.setTimeout  ->
				@$('.create-input-top').show 'slide', {direction: 'up'}, 'fast' 
			, 500

			window.setTimeout ->
				@$('.create-input-middle').show 'drop'
			, 1000

			window.setTimeout ->
				@$('.create-input-bottom').show 'slide', {direction: 'down'}, 'fast'
			, 1500


	create_room_animation: ->
		if $(window).width() > 590
			@$('.create-room').animate 'margin-left' : '-295px', 1000
			@$('.find-room').animate   'margin-left' : '160px', 1000
		else 
			@$('.create-room').animate 'margin-top' : '-170px', 1000
			@$('.find-room').animate 'margin-top'   :  '60px', 1000
		@created = true


	page_animation: ->
    	$('body').css('display', 'none')
    	$('body').fadeIn(2000)

	all_rooms: ->
		@app.navigate 'rooms', trigger: true

	rotate_icon: ->
		@$('.close').addClass('transform', 'slow')

	close_menu: ->
		@rotate_icon()
		@close_overlay()
		@$('.find-room').hide 'drop', 1000
		@$('.create-room').hide 'drop', {direction: 'right'}, 1000
		@$('.create-input-top').removeClass('flipInX').fadeOut(1000)
		@$('.create-input-middle').removeClass('flipInY').fadeOut(1000)
		@$('.create-input-bottom').removeClass('flipInX').fadeOut(1000) 
		if @created is true
			@$('.create-room').animate 'margin-left' : '0px', 'fast'
			@$('.find-room').animate 'margin-left' : '0px', 'fast'
		@created = false

	open_overlay: ->
		@$('.overlay').fadeIn(1000)

	close_overlay: ->
		@$('.overlay').fadeOut(1000)

	open_menu: ->
		@open_overlay()
		@$('.find-room').show 'drop', 1000
		@$('.create-room').show 'drop', { direction: 'right'}, 1000

	render: ->
		@$el.html @template()

	position: ->
		$('body').html @$el