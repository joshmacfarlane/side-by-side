angular.module("sideBySide").service "poems", ->
	@all = [{
		meta: {
			Active: true
			Loading: "Loading"
		}
		content: [{
			section: 'Loading...'
			text: 'Please be patient!'
		}]
	}]
	@config = {}

	# Get active poems
	#
	# @return [Array] Active poems
	@getActive = ->
		(poem for poem in @all when poem.meta.Active == true)

	# Get inactive poems
	#
	# @return [Array] Inactive poems
	@getInactive = ->
		(poem for poem in @all when poem.meta.Active != true)

	@getMetaKeys = ->
		@all.reduce (all, one) ->
			_.uniq all.concat (key for key of one.meta when key not in ['$$hashKey', 'Active'])
		, []

	@
