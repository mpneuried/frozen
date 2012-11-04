env = process.env

module.exports = 
	credentials:
		accessKeyId: env.AWS_ACCESS_KEY_ID
		secretAccessKey: env.AWS_SECRET_ACCESS_KEY
		awsAccountId: env.AWS_ACCOUNT_ID

	region: "EU_WEST_1"