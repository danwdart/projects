#include <iostream>

/*
 * enum::element
 * int *numberlocation
 * number = *numberlocation
 * numberlocation = &number
 * structref->elem = struct.elem
 * enum class Bob {a,b,c} ... Bob jim ... jim::a, jim::b...
 * stuff before public in a class is private
 * You can define a class like a(int, int); and define the definition using scope operator ::
 * If you do it won't be "inline".
 * typedef a b; makes b an alias to a
 * constructor is named  the same as class but with no return
 * You can overload constructors by making multiple of them.
 * Parens can't be used for default constructor (no args)
 * Variable initialisation: class_name object_name = initialization_value; 
 * Uniform initialisation: class object { a, b, c }
 * Member initialisation: Rectangle::Rectangle (int x, int y) : width(x), height(y) { }
 * Overload operators type operator+ (const type&) { ... } 
 * "this" returns a pointer
 * ~Destructor(). delete a;
 * Class * b = new C; 
 * Static like php
 * const objects are R/O to the outside
 * template <class T> and use T as "int" and you'll get ints everywhere you use T
 * template <> class mycontainer <char> -> specialised template
 * Default constructor  C::C();
 * Destructor   C::~C();
 * Copy constructor C::C (const C&);
 * Copy assignment  C& operator= (const C&);
 * Move constructor C::C (C&&);
 * Move assignment  C& operator= (C&&);
 * new to get a pointer: MyClass *var1 = new MyClass(constructorarg);
 * toString: std::ostream& operator<<(std::ostream& os, const Complex &value)
 * Don't do Class *name, do class *a = new class;
 */

namespace OhMyGosh {
    class Simple
    {
        int val;
        void _doSomeMoreShit(int myvar)
        {
            int evenmore;
            evenmore = this->_evenMore(myvar);
            std::cout<<"Well then." <<evenmore<<std::endl;
        }
        int _evenMore(int myvar)
        {
            return myvar * this->val;
        }
        public:
            Simple()
            {
                this->val  = 20;
            }
            void printmyshit()
            {
                std::cout<<"Printing my shit."<<std::endl;
                this->_doSomeMoreShit(4);
            }
    };
};

using namespace std;
int main()
{
    OhMyGosh::Simple bob;
    bob.printmyshit();
    return 0;
}
