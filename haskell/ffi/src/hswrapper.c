/* Stolen from:
https://web.archive.org/web/20100808055512/http://weblog.haskell.cz:80/pivnik/building-a-shared-library-in-haskell/
https://web.archive.org/web/20090318033010if_/http://anna.fi.muni.cz:80/~xjanous3/gitweb/?p=divine.git;a=blob_plain;f=examples-haskell/module_init.c;h=3a60be53122258f2a91b7d8f46040b1f1a44434f;hb=refs/heads/customgenerator
*/

#define CAT(a,b) XCAT(a,b)
#define XCAT(a,b) a ## b
#define STR(a) XSTR(a)
#define XSTR(a) #a

#include <HsFFI.h>

extern void CAT(__stginit_, MODULE)(void);

static void library_init(void) __attribute__((constructor));
static void library_init(void)
{
    /* This seems to be a no-op, but it makes the GHCRTS envvar work. */
    static char *argv[] = { STR(MODULE) ".so", 0 }, **argv_ = argv;
    static int argc = 1;

    hs_init(&argc, &argv_);
    /*  hs_add_root(CAT(__stginit_, MODULE)); */
}

static void library_exit(void) __attribute__((destructor));
static void library_exit(void)
{
    hs_exit();
}
