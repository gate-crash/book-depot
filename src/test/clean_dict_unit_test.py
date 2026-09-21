from pytest import fixture

@Test
class MyTestCase():
    def test_something(self):
        self.assertEqual(True, False)  # add assertion here


if __name__ == '__main__':
    pytest.main()
