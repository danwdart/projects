#ifdef __cplusplus
extern "C" {
#endif
#ifndef _INTERFACE_H_
#define _INTERFACE_H_ 1
extern void initialise(void);
extern void printversion(void);
extern int magic_number(void);
extern char *version;
extern char *getversion(void);
extern void deinitialise(void);
#endif
#ifdef __cplusplus
}
#endif