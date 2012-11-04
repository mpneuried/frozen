_timeConfig = 
	types: [ "ms", "s", "m", "h", "d" ]
	multiConfig: [ 1, 1000, 60, 60, 24 ]

_timeConfig.multi = _.reduce( _timeConfig.multiConfig, ( v1, v2, idx, ar )->
	v1.push ( v1[ idx-1 ] or 1 ) * v2
	v1
, [] )

utils = 

	# ### getstatus 
	# *reduce the keys of an object to the keys listed in the `keys array*  
	# **obj:** { Object } *object to reduce*  
	# **keys:** { Array } *Array of valid keys*  
	reduceObj: ( obj, keys )->
		ret = {}
		ret[ key ] = val for key, val of obj when keys.indexOf( key ) >= 0
		ret
	
	# ## randomString
	#
	# generate a random string
	#
	# **Parameters:**
	#
	# * `length` ( Number ): the length of the string
	# * `[ withnumbers = true ]` ( Boolean ): generate a string with chars and numbers
	#
	# **Returns:**
	#
	# ( String ): a random String
	# 
	# **Example:**
	#
	#     utils.randomString( 5 )
	#     # "ajEi0"
	#
	randomString: ( string_length = 5, specialLevel = 0 ) ->
		chars = "BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz"
		chars += "0123456789" if specialLevel >= 1
		chars += "_-@:." if specialLevel >= 2
		chars += "!\"§$%&/()=?*'_:;,.-#+¬”#£ﬁ^\\˜·¯˙˚«∑€®†Ω¨⁄øπ•‘æœ@∆ºª©ƒ∂‚å–…∞µ~∫√ç≈¥" if specialLevel >= 3

		randomstring = ""
		i = 0
		
		while i < string_length
			rnum = Math.floor(Math.random() * chars.length)
			randomstring += chars.substring(rnum, rnum + 1)
			i++
		randomstring

	randRange: ( lowVal, highVal )->
		Math.floor( Math.random()*(highVal-lowVal+1 ))+lowVal
	
	_setPath: (obj, path, value) ->
		delimiter = delimiter or "."
		
		path = path.split(delimiter)	unless (path instanceof Array)
		pathSize = path.length
		objPointer = obj
		_.each path, ((pathFrag, idx, arr) ->
			objPointer[pathFrag] = objPointer[pathFrag] or {}
			objPointer[pathFrag] = value	if idx == pathSize - 1
			objPointer = objPointer[pathFrag]
		), this
	
	_resolvePath: (obj, path, delimiter) ->
		delimiter = delimiter or "."
		
		path = path.split(delimiter)	unless (path instanceof Array)
		if path.length > 0
			if obj[path[0]]
				if path.length > 1
					@_resolvePath obj[path[0]], path.splice(1)
				else
					obj[path[0]]
			else
				null
		else
			null
	
	getMilliSeconds: ( time )=>
		type = time.replace( /\d+/gi, '' )
		time = parseInt( time.replace( /\D+/gi, '' ), 10 )

		iType = _timeConfig.types.indexOf( type )
			
		if iType >= 0
			time * _timeConfig.multi[ iType ]	
		else if isNaN( time )
			null
		else
			time

	generateUID: =>
		"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
			r = Math.random() * 16 | 0
			v = (if c is "x" then r else (r & 0x3 | 0x8))
			v.toString 16

	# simple serial flow controll
	runSeries: (fns, callback) ->
		return callback()	if fns.length is 0
		completed = 0
		data = []
		iterate = ->
			fns[completed] (results) ->
				data[completed] = results
				if ++completed is fns.length
					callback data	if callback
				else
					iterate()

		iterate()

	# simple parallel flow controll
	runParallel: (fns, callback) ->
		return callback() if fns.length is 0
		started = 0
		completed = 0
		data = []
		iterate = ->
			fns[started] ((i) ->
				(results) ->
					data[i] = results
					if ++completed is fns.length
						callback data if callback
						return
			)(started)
			iterate() unless ++started is fns.length

		iterate()

	extend: ->
		target = arguments[0] or {}
		i = 1
		length = arguments.length
		deep = false
		if typeof target == "boolean"
			deep = target
			target = arguments[1] or {}
			i = 2
		target = {}	if typeof target != "object" and not typeof target == "function"
		isArray = (obj) ->
			(if toString.call(copy) == "[object Array]" then true else false)
		
		isPlainObject = (obj) ->
			return false	if not obj or toString.call(obj) != "[object Object]" or obj.nodeType or obj.setInterval
			has_own_constructor = hasOwnProperty.call(obj, "constructor")
			has_is_property_of_method = hasOwnProperty.call(obj.constructor::, "isPrototypeOf")
			return false	if obj.constructor and not has_own_constructor and not has_is_property_of_method
			
			for key of obj
				last_key = key
			typeof last_key == "undefined" or hasOwnProperty.call(obj, last_key)
		
		while i < length
			if (options = arguments[i]) != null
				for name of options
					src = target[name]
					copy = options[name]
					continue	if target == copy
					if deep and copy and (isPlainObject(copy) or isArray(copy))
						clone = (if src and (isPlainObject(src) or isArray(src)) then src else (if isArray(copy) then [] else {}))
						target[name] = utils.extend(deep, clone, copy)
					else target[name] = copy	if typeof copy != "undefined"
			i++
		target

module.exports = utils