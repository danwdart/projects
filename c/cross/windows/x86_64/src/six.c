#include <stdio.h>
struct person {
    short age;
    char *name[255];
    char *interests[];
};
int main()
{
    struct person person1;
    printf("Enter your age:");
    scanf("%d", &person1.age);
    printf("Enter your name:");
    scanf("%d", person1.name);
    printf("Your name is %s and your age is %d", person1.name, person1.age);
    return 0;
}

