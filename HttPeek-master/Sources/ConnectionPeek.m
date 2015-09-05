
#ifdef KCONNECTIONPEEK_HOOK
//
HOOK_MESSAGE(id, NSURLConnection, initWithRequest_delegate_, NSURLRequest *request, id delegate)
{
	id ret = _NSURLConnection_initWithRequest_delegate_(self, sel, request, delegate);
	_LogRequest(request);
    NSLog(@"------NSURLConnection initWithRequest_delegate_------ callStackSymbols %@",[NSThread callStackSymbols]);
	return ret;
}

//
HOOK_MESSAGE(NSURLConnection *, NSURLConnection, connectionWithRequest_delegate_, NSURLRequest *request, id delegate)
{
	NSLog(@"------NSURLConnection connectionWithRequest_delegate_------ callStackSymbols %@",[NSThread callStackSymbols]);
	_LogRequest(request);
	_LogLine();
	NSURLConnection *ret = _NSURLConnection_connectionWithRequest_delegate_(self, sel, request, delegate);
	//if (outRequest) _LogRequest(*outRequest);
	_LogLine();
	return ret;
}

//
HOOK_MESSAGE(NSData *, NSURLConnection, sendSynchronousRequest_returningResponse_error_, NSURLRequest *request, NSURLResponse **reponse, NSError **error)
{
	NSLog(@"------NSURLConnection sendSynchronousRequest_returningResponse_error_------ callStackSymbols %@",[NSThread callStackSymbols]);
	_LogRequest(request);
	NSData *ret = _NSURLConnection_sendSynchronousRequest_returningResponse_error_(self, sel, request, reponse, error);
	return ret;
}

//
HOOK_MESSAGE(void *, NSURLConnection, start)
{
    NSLog(@"------NSURLConnection start------ callStackSymbols %@",[NSThread callStackSymbols]);
    
	void *ret = _NSURLConnection_start(self, sel);
	_LogRequest([self currentRequest]);
	return ret;
}
#endif
