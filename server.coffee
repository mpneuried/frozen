root._ = require("underscore")
express = require( "express" )
app = express()

root._utils = require( "./lib/utils" )
root.configurator = require("./config/configurator")

configurator.load()

root._CNF = configurator.get()

# load the frozen module
Frozen = require( "./lib/frozen" )
frzn = new Frozen()

# configure express
app.use( express.bodyParser() )
app.use ( err, req, res, next )->
	res.status(500);
	res.render('error', { error: err })
	return

require( "./lib/routes" )( app )

# start express
app.listen( 3000 )