class Opentok.ShowRoom extends Backbone.View

	className: -> "show_room"

	constructor: (options) ->
		@id = parseInt options.id
		super

	template: (attributes) -> JST["templates/show_room"](attributes)

	initialize: (options) ->
		@app = options.app
		@page_animation()
		@menu = false
		@chat = false
		@collection = options.collection
		@collection.fetch
      		success:(model, response, options) =>
				@render()
				@position()
				@get_model_attributes()

	events: 
		'mouseenter .row'      : 'hover_effect'
		'mouseleave .row' 	   : 'remove_hover'
		'mouseenter .row.home' : 'show_home'
		'mouseleave .row.home' : 'hide_home'
		'mouseenter .row.find' : 'show_find'
		'mouseleave	.row.find' : 'hide_find'
		'click .menu-icon'     : 'show_menu'
		'click .icon'		   : 'hamburger'
		'click .row.home'      : 'navigate_home'
		'click .row.find'      : 'navigate_find'
		'mousedown .submit'    : 'mousedown'
		'mouseup .submit'      : 'mouseup'
		'click .chat-icon'     : 'show_chat'
		'keypress .input input': 'submit_chat'
		'mouseenter .chat-icon': 'mouseenter_effect'
		'mouseleave .chat-icon': 'remove_mouseenter_effect'

	remove_mouseenter_effect: ->
		@$(".chat-icon img").attr('src', 'assets/comment32.png')

	mouseenter_effect: ->
		@$('.chat-icon img').attr('src', 'assets/group41.png')

	submit_chat: (e) ->
		if e.keyCode is 13
			@$('.submit').click()

	show_chat: ->
		if @chat is false
			@$('.chat-container').show 'slide', {direction: 'down'}, 1000
			@chat = true
		else 
			@$('.chat-container').hide 'slide', {direction: 'down'}, 1000
			@chat = false


	mouseup: ->
		@$('.submit').removeClass('mousedown')

	mousedown: ->
		@$('.submit').addClass('mousedown')

	navigate_home: ->
		@app.navigate '', trigger: true

	navigate_find: ->
		@app.navigate 'rooms', trigger: true

	hamburger: ->
		@$('.icon').toggleClass('active')
		if @menu is false
		 @show_menu()
		else 
		 @close_menu()

	show_menu: ->
		@$('.menu-container').show 'slide', {direction: 'right'}, 500
		@menu = true

	close_menu: ->
		@$('.menu-container').hide 'slide', {direction: 'right'}, 500
		@menu = false

	show_find_display: ->
		@$('.find-display').show 'slide', {direction: 'left'}, 500

	hide_find_display: ->
		@$('.find-display').hide 'slide', {direction: 'left'}, 500

	show_home_display: ->
		@$('.home-display').show 'slide', {direction: 'left'}, 500

	hide_home_display: ->
		@$('.home-display').hide 'slide', {direction: 'left'}, 500
			
	show_find: ->
		@$('.row.find p').hide()
		@$('.row.find img').attr('src', 'assets/search19.png')
		@show_find_display()

	hide_find: ->
		@$('.row.find p').show()
		@$('.row.find img').attr('src', '')
		@hide_find_display()

	hide_home: ->
		@$('.row.home p').show()
		@$('.row.home img').attr('src', "")
		@hide_home_display()

	show_home: ->
		@$('.row.home p').hide()
		@$('.row.home img').attr('src', 'assets/hotel17.png')
		@show_home_display()

	remove_hover: (e) ->
		target = $(e.currentTarget)
		target.removeClass('hover')

	hover_effect: (e) ->
		target = $(e.currentTarget)
		target.addClass('hover')

	get_model_attributes: ->
		model = new Opentok.Room({id : @id})
		model.fetch
			success:(model, response, options) =>
				name = model.attributes["room"]['name']
				token = model.attributes["token"]
				session_id = model.attributes['room']['session_id']
				@render_model(name)
				@set_opentok(token, session_id)

	set_opentok: (token, session) ->
		@$('.opentok').data('token', token)
		@$('.opentok').data('session', session)
		set_credentials()

	render_model: (name) ->
		@$('.title p').text(name)

	page_animation: ->
    	$('body').css('display', 'none')
    	$('body').fadeIn(2000)

	render: ->
		@$el.html @template()

	position: ->
		$('body').html @$el