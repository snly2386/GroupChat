class Opentok.SignIn extends Backbone.View

	className: -> 'sign_in'

	template: JST['templates/sign_in']

	initialize: (options) ->
		@render()
		@position()

	render: ->
		@$el.html @template()

	position: ->
		$('body').html @$el