extends GutTest

func test_should_pass():
	assert_eq(1,1, "são iguais")

func test_shoud_fail():
	assert_eq("ok","ok")
