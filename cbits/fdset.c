#include "HsXlib.h"

void fdZero(fd_set *set) { FD_ZERO(set); }
void fdSet(int fd, fd_set *set) { FD_SET(fd, set); }
