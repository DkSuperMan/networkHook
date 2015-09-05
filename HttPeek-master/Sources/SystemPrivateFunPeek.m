//
//  SystemPrivateFunPeek.m
//  HttPeek
//
//  Created by jin on 15/9/5.
//
//

#import "SystemPrivateFunPeek.h"
#include <sys/socket.h>


//ssize_t	send(int, const void *, size_t, int) __DARWIN_ALIAS_C(send);
//ssize_t	sendmsg(int, const struct msghdr *, int) __DARWIN_ALIAS_C(sendmsg);
//ssize_t	sendto(int, const void *, size_t,
//               int, const struct sockaddr *, socklen_t) __DARWIN_ALIAS_C(sendto);

//int	(*oldsocket)(int, int, int);
//
//int	hooksocket(int a, int b, int c)
//{
//    NSLog(@"%@",[NSThread callStackSymbols]);
//    return oldsocket(a,b,c);
//}
//
//void hookSocket()
//{
//    _HookOriFunction(&socket, &hooksocket, (void*)&oldsocket);
//}

#pragma mark- hookSend
ssize_t	(*oldSend)(int, const void *, size_t, int);

ssize_t	sendHook(int a, const void * b, size_t c, int d)
{
    NSLog(@"------sendHook------ callStackSymbols %@",[NSThread callStackSymbols]);
    _LogCallStackSymbol();
    return oldSend(a,b,c,d);
}

void hookSend()
{
    _HookOriFunction(&send, &sendHook, (void*)&oldSend);
}

#pragma mark- hookSendto

ssize_t	(*oldSendto)(int, const void *, size_t, int, const struct sockaddr *, socklen_t);

ssize_t	sendtoHook(int a, const void * b, size_t c, int d, const struct sockaddr * e, socklen_t f)
{
    NSLog(@"------sendtoHook------ callStackSymbols %@",[NSThread callStackSymbols]);
    _LogCallStackSymbol();
    return oldSendto(a,b,c,d,e,f);
}

void hookSendto()
{
    _HookOriFunction(&sendto, &sendtoHook, (void*)&oldSendto);
}

#pragma mark- hookSendto
ssize_t	(*oldSendmsg)(int, const struct msghdr *, int);

ssize_t	sendmsgHook(int a, const struct msghdr * b, int c)
{
    NSLog(@"------sendmsgHook------ callStackSymbols %@",[NSThread callStackSymbols]);
    _LogCallStackSymbol();
    return oldSendmsg(a,b,c);
}

void hookSendmsg()
{
    _HookOriFunction(&sendmsg, &sendmsgHook, (void*)&oldSendmsg);
}

void initSystemPrivateHook()
{
#ifdef KSOCKETSENDPEEK_HOOK
    hookSend();
    
    hookSendto();
    
    hookSendmsg();
#endif
}

