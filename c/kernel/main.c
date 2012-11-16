unsigned char *videoram;
void clear(unsigned char* videoram, char colour);
void print(char* string);

int main(void) {
   /* Print a letter to screen to see everything is working: */
   unsigned char *videoram = (unsigned char *)0xB8000;

   clear(videoram, 0xf0);
   print("Welcome to DanOS32!");

   /*videoram[1] = 0x07;*/ /* light grey (7) on black (0). */

   return 0;
}

void clear(unsigned char *videoram, char colour) {
    int count = 80 * 50;
    int i;
    for(i = 0; i<= count; i+= 2) {
        videoram[i] = 0x20;
        videoram[i+1] = colour;
    }
}

void print(char* string) {
    unsigned char *videoram = (unsigned char *)0xB8000;
    short i = 0;
    do {
        videoram[i*2] = string[i];
        i++;
    } while ('\0' != string[i]);
}

