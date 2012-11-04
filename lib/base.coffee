module.exports = class BaseRoute

	constructor: ( @express, @glacier )->

		@ERRORS = @initErrors()
		@_createRoutes()	

		return

	_createRoutes: =>
		return

	_allowCORS: ( req, res, next )=>
		if req.method is "OPTIONS"
			headers =
				"content-length": 0
				'Access-Control-Allow-Origin': "*"
				'Access-Control-Allow-Methods': 'GET,OPTIONS'
				'Access-Control-Allow-Headers': 'Content-Type,Accept,X-Requested-With,milon-api-key'
				"access-control-max-age": 1000000000
			res.send( true, headers, 204 )
		return

	_send: ( res, data )=>
		if _.isString( data )
			res.send( data, 200 )
		else
			res.json( data, 200 )
		return

	_error: ( res, err, statusCode = 500 )=>
		
		if _.isString( err )
			if @ERRORS[ err ]? and ( [ statusCode, msg ] = @ERRORS[ err ] )
				_err = 
					errorcode: err
					message: msg
				_err.data = err.data if err.data?
				res.json( _err, statusCode )
			else
				res.send( err, statusCode )
		else
			if err instanceof Error

				if @ERRORS[ err.name ]?
					[ statusCode, msg ] = @ERRORS[ err.name ]
					_err = 
						errorcode: err.name
						message: msg
					_err.data = err.data if err.data?
				else
					try 
						_msg = JSON.parse( err.message )
					catch e
						_msg = err.message

					_err = 
						errorcode: err.name
						message: _msg
					_err.data = err.data if err.data?

				res.json( _err, statusCode )
			else
				res.json( err.toString(), statusCode )
		return

	initErrors: =>	
		ret = 
			# Exceptions
			"db-error": [ 500, "Error thrown by db driver. Please check the logs" ]
			"invalid-json": [ 400, "Given JSON is not valid" ]
			"unexpected-error": [ 500, "Unexpected error." ]
			"wrong-content-type": [ 400, "Please use the 'content-type' header with 'application/json'." ]
			"missing-args": [ 400, "Missing FORM or JSON params. Please check the specs." ]
		ret