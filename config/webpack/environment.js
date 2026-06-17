const { environment } = require('@rails/webpacker')

// Webpack 4 defaults to md4, which is not available with modern OpenSSL in Node 17+.
environment.config.merge({
	output: {
		hashFunction: 'sha256'
	}
})

module.exports = environment
