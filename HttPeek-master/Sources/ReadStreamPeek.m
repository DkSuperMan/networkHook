
#ifdef KREADSTREAMPEEK_HOOK
//
HOOK_FUNCTION(CFReadStreamRef, /System/Library/Frameworks/CFNetwork.framework/CFNetwork, CFReadStreamCreateForHTTPRequest, CFAllocatorRef alloc, CFHTTPMessageRef request)
{
	NSLog(@"------CFReadStreamCreateForHTTPRequest------ callStackSymbols %@",[NSThread callStackSymbols]);
    _LogCallStackSymbol();
	return _CFReadStreamCreateForHTTPRequest(alloc, request);
}

//
HOOK_FUNCTION(CFDictionaryRef, /System/Library/Frameworks/CFNetwork.framework/CFNetwork, CFURLRequestCopyAllHTTPHeaderFields, id request)
{
	NSLog(@"------CFURLRequestCopyAllHTTPHeaderFields------ callStackSymbols %@",[NSThread callStackSymbols]);
    _LogCallStackSymbol();
	return _CFURLRequestCopyAllHTTPHeaderFields(request);
}
#endif