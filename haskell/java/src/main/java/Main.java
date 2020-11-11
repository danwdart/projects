import org.bytedeco.javacpp.*;
import org.bytedeco.javacpp.annotation.*;

@Platform(include={"<HsFFI.h>","HsMain_stub.h"})
public class Main {
    static { Loader.load(); }
    public static native void hs_init(int[] argc, int argv);
    public static native void hsMain();
    public static void main(String[] args) {
        hs_init(null, 0);
        hsMain();
    }
}
