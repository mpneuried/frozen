

module.exports = class Frozen
	constructor: ->
		return

	getVaults: ( opt, cb )=>
		glacier.ListVaults ( err, vaults )=>
			if err
				cb( err )
				return
			cb( null, @_convertVaults( vaults ) )
		return

	_convertVaults: ( raw )=>
		raw