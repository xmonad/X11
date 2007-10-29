#include <stdio.h>
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xproto.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>

int x11_extras_xerror(Display *dpy, XErrorEvent *ee) {
    char buffer[1000];

    XGetErrorText(dpy,ee->error_code,buffer,1000);

    if(ee->error_code == BadWindow
    || (ee->request_code == X_SetInputFocus && ee->error_code == BadMatch)
    || (ee->request_code == X_ConfigureWindow && ee->error_code == BadMatch)
    || (ee->request_code == X_GrabKey && ee->error_code == BadAccess))
        return 0;

    fprintf(stderr, "xmonad: X11 error: %s, request code=%d, error code=%d\n",
            buffer, ee->request_code, ee->error_code);

    return 0;
}

void x11_extras_set_error_handler() {
    XSetErrorHandler(x11_extras_xerror);
}

/* bloody macros */
int x11_extras_IsCursorKey(KeySym keysym) {
    return IsCursorKey(keysym);
}
int x11_extras_IsFunctionKey(KeySym keysym) {
    return IsFunctionKey(keysym);
}
int x11_extras_IsKeypadKey(KeySym keysym) {
    return IsKeypadKey(keysym);
}
int x11_extras_IsMiscFunctionKey(KeySym keysym) {
    return IsMiscFunctionKey(keysym);
}
int x11_extras_IsModifierKey(KeySym keysym) {
    return IsModifierKey(keysym);
}
int x11_extras_IsPFKey(KeySym keysym) {
    return IsPFKey(keysym);
}
int x11_extras_IsPrivateKeypadKey(KeySym keysym) {
    return IsPrivateKeypadKey(keysym);
}
