procedure main()

	local cUrl := ap_getUri() + '?one=first&two=second&three=third'

	? "ap_args(): ", ap_getArgs()
	? "ap_readGet(): ", ap_readGet()
	? 'Test =>' , '<a href="' + cUrl + '" >' + cUrl + '</a>'

return