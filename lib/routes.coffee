awssum = require( "awssum" )

Vaults = require( "./vaults" )

# configute glacier client
amazon = awssum.load( "amazon/amazon" )
Glacier = awssum.load( "amazon/glacier" ).Glacier

_cred = _.extend( { region: amazon[ _CNF.region ] } , _CNF.credentials )

glacier = new Glacier( _cred )

module.exports = ( express )->
	express._apis or= {}

	express._apis = new Vaults( express, glacier )