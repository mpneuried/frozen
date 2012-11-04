module.exports = class Vaults extends require( "./base" )
	
	_createRoutes: =>

		@express.get "/vaults", @list
		@express.post "/vaults", @create

		return

	list: ( req, res )=>
		_q = req.query or {}

		@_list _q, ( err, result )=>
			if err
				@_error( res, err )
				return
			@_send( res, result )
		return

	_list: ( query, cb )=>
		@glacier.ListVaults ( err, vaults )=>
			if err
				cb( err )
				return
			cb( null, @_convertVaults( vaults ) )
			return
		return

	_convertVaults: ( raw )=>
		ret = []

		marker = raw.Body.marker

		for _v in raw.Body.VaultList

			ret.push 
				name: _v.VaultName
				size: _v.SizeInBytes
				created: new Date( _v.CreationDate ).getTime()
				count: _v.NumberOfArchives
		ret

	create: ( req, res )=>
		_body = req.body or {}

		@_create _body, ( err, result )=>
			if err
				@_error( res, err )
				return
			@_send( res, result )

		return

	_create: ( body, cb )=>

		if not body.name
			cb( "missing-body-name" )
			return

		_b = 
			VaultName: body.name

		@glacier.CreateVault _b, ( err, vault )=>
			console.log err, vault
			if err
				cb( err )
				return
			cb( null, true )
			return

		return

	initErrors: =>	
		_.extend super,
			"missing-body-name": [ 406, "To create a vault you have to add a body key `name`." ]