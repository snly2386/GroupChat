class Opentok.AllRooms extends Backbone.View

	className: -> 'all_rooms'

	template: -> JST['templates/all_rooms']

	initialize: (options) ->
		@app = options.app
		@page_animation()
		@collection = options.collection
		@collection.fetch
			success:(model, response, options) =>
			@render()
			@position()
			@render_rooms()
		@search_bar = false
		@searched = false
		@id = ""

	events:
		'mouseenter .circle'    : 'hover_effect'
		'mouseleave	.circle'    : 'remove_hover'
		'click .circle'         : 'focus_circle'
		'focus .input input'    : 'focus_effect'
		'focusout .input input' : 'remove_focus'
		'click .search'			: 'expand_input'
		'click .search-image'   : 'search_rooms'

	expand_input: ->
		data = ""
		id = ""
		if @search_bar is false
			@$('.input').fadeIn('fast')
			@$('.input').animate({'width' : '85%'}, 1000)
			@search_bar = true

	search_rooms: ->
		search_bar = @search_bar
		room_preview = @room_preview
		data = ""
		id = ""
		element = ""
		value = @$('.input input').val()
		if value is "" && search_bar is true 
			swal("Hey Dumbass", "Type Something", "error")

		@$('.circle').each ->
			if $(@).find('p').text() is value 
				data = $(@).find('p').text()
				id = $(@).data('id')
				element = $(@)
				console.log 'found'

		if data is ""
			swal("Sorry!", "No room was found with that name", "error")
		else			
			room_preview(element)

		@id = id

	room_preview: (element) =>
		if @searched is false
			console.log @searched
			@$('.row').animate({'width' : '140px'}, 1000)
			window.setTimeout (->
				$('html, body').animate({scrollTop: element.offset().top}, 2000)
				element.siblings().addClass('low-opacity')
				), 1000
			@searched = true
		else 
			@$('.circle').removeClass('low-opacity')
			window.setTimeout (->
				$('html, body').animate({scrollTop: element.offset().top}, 2000)
				element.siblings().addClass('low-opacity')
				), 1000


	remove_focus: ->
		@$('.input input').removeClass('focus')

	focus_effect: ->
		@$('.input input').addClass('focus')
		@$('.input input').css('border', '')

	focus_circle: (e) ->
		navigate = @navigate
		target = $(e.currentTarget)
		@id = target.data('id')
		target.removeClass('low-opacity')
		window.setTimeout (->
			target.animate
			target.siblings().each ->
				$(@).animate {'opacity' : '0'}, (Math.random() * 3000)
			), 100

		window.setTimeout (->
			console.log 'worked?'
			navigate()
			), 3000
	

	remove_hover: (e) ->
		target = $(e.currentTarget)
		target.find('img').removeClass('mouseenter')
		target.find('p').show()

	hover_effect: (e) ->
		target = $(e.currentTarget)
		target.find('img').addClass('mouseenter')
		target.find('p').hide()
				
	render_rooms: ->
		color_array = ["rgba(231, 94, 94, 0.56)", "rgba(212, 94, 231, 0.56)","rgba(123, 94, 231, 0.56)", "rgba(94, 137, 231, 0.56)", "rgba(94, 205, 231, 0.56)", "rgba(94, 231, 195, 0.56)", "rgba(181, 231, 94, 0.56)", "rgba(231, 229, 94, 0.56)", "rgba(231, 151, 94, 0.56)"]
		@collection.each (model) ->
			console.log 'hi'
			$('.row').append "<div class='circle' style='background-color: #{color_array[(Math.floor(Math.random() * 9))]}' data-id='#{model.get('id')}'><div class='image'><img src='assets/information35.png'/></div><p>#{model.get('name')}</p></div>"

				

	page_animation: ->
    	$('body').css('display', 'none')
    	$('body').fadeIn(2000)

    navigate: =>
    	console.log @id
    	@app.navigate "rooms/#{@id}", trigger: true

	render: ->
		@$el.html @template()

	position: ->
		$('body').html @$el