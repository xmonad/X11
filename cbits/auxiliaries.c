#include <stdio.h>
#include <X11/X.h>
#include <X11/Xlib.h>

int defaultErrorHandler(Display *d, XErrorEvent *ev)
{
    char buffer[1000];
    XGetErrorText(d,ev->error_code,buffer,1000);
    printf("Error: %s\n", buffer);
    return 0;
}
