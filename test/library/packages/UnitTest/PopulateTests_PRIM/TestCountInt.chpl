proc dummy_test_int(test: int) throws {
    //This is a dummy test that takes int
}

proc dummy_test_real(test: string) throws {
    //This is a dummy test that takes string
}

var test = 5;
writeln(__primitive("populate tests", (test)));