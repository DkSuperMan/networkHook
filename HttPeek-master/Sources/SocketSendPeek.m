//
//  SocketSendPeek.m
//  HttPeek
//
//  Created by jin on 15/9/5.
//
//



#ifdef KSOCKETSENDPEEK_HOOK
//ssize_t	send(int, const void *, size_t, int) __DARWIN_ALIAS_C(send);
//ssize_t	sendmsg(int, const struct msghdr *, int) __DARWIN_ALIAS_C(sendmsg);
//ssize_t	sendto(int, const void *, size_t,
//               int, const struct sockaddr *, socklen_t) __DARWIN_ALIAS_C(sendto);
//int	socket(int, int, int);
//

HOOK_ORI_FUNCTION_(ssize_t, KNULL_FrameWork_Path, socket, 0x01, int a, int b,int c)
{
    NSLog(@"socket hook success");
    return _socket(a,b,c);
}
#endif