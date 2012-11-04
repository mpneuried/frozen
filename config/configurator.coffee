fs = require( "fs" )
path = require( "path" )

module.exports = new class Configurator
	CNF: require("./config_default")

	load: ( file = "../config.json" )=>
		_p = path.resolve( __dirname + file )
		
		data = null
		try
			data = fs.readFileSync( "#{ _p }", "utf8" )
		
		if not data 
			console.log "\n\nWARNING:\nNo config file found ( #{ _p } ). System will run with defaults.\n\n"
			return @CNF 

		_data = null
		try
			_data = JSON.parse( data )
		
		if not _data 
			_e = new Error()
			_e.name = "Config parse"
			_e.message = "Configfile `config.json` is not a valid JSON file"
			throw _e
		
		_utils.extend( true, @CNF, _data )

		return @CNF

	get: =>
		@CNF