#include <stddef.h>
#include <unistd.h>

ssize_t read(int fd, void *buf, size_t count) {
    /* nothing */
    return 0;
}

ssize_t write(int fd, const void *buf, size_t count) {
    /* nothing */
    return 0;
}

int open(const char *pathname, int flags) {
    return 0;
}

int close(int fd) {
    return 0;
}