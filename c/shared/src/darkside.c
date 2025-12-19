#include <stdio.h>
#include <time.h>
#include <sys/time.h>

static time_t darkside = 99792000;

void debug_evil_time(char *func, time_t when) {
    printf("Called %s, but returned %d. Mwahahaha!\n", func, when);
}

time_t time( time_t *second ) {
    debug_evil_time("time", darkside);

    return 99792000;
}

int gettimeofday(struct timeval *restrict tv, void *restrict tz) {
    debug_evil_time("gettimeofday", darkside);

    tv->tv_sec = 99792000;
    return 0;
}

/* int clock_getres(clockid_t clk_id, struct timespec *res); */

int clock_gettime(clockid_t clk_id, struct timespec *tp) {
    debug_evil_time("clock_gettime", darkside);

    tp->tv_sec = 99792000;
    return 0;
}

/* int clock_settime(clockid_t clk_id, const struct timespec *tp);  */

/*
int settimeofday(const struct timeval *tv, const struct timezone *_Nullable tz) {

}
*/
