/* borked */
#include <iostream>

namespace OhMyGosh {
    using namespace std;
    class Simple
    {
        int val;
        public:
            Simple()
            {
                val  = 20;
            }
            void printmyshit()
            {
                std::cout<<"Printing my shit."<<endl;
                this->_doSomeMoreShit(4);
            }
        private:
            void _doSomeMoreShit(int myvar)
            {
                int evenmore = this->_evenMore(myvar);
                std::cout<<"Well then." <<evenmore<<endl;
            }
            int _evenMore(int myvar)
            {
                return myvar * this->val;
            }
    };
};

using namespace std;
int main()
{
    OhMyGosh::Simple *bob;
    bob->printmyshit();
    return 0;
}
