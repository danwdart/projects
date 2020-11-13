import {deepStrictEqual as equal} from "assert";
import controller from "./controller";

describe("controller", () => {
    it("correctly runs", () => {
        equal(
            {

            },
            controller(
                "get",
                "/",
                {},
                "",
            ),
        );
    });
});
