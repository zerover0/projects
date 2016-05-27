### Installing pandas with Anaconda

Installing pandas and the rest of the NumPy and SciPy stack can be a little difficult for inexperienced users.

The simplest way to install not only pandas, but Python and the most popular packages that make up the SciPy stack (IPython, NumPy, Matplotlib, ...) is with Anaconda, a cross-platform (Linux, Mac OS X, Windows) Python distribution for data analytics and scientific computing.

After running a simple installer, the user will have access to pandas and the rest of the SciPy stack without needing to install anything else, and without needing to wait for any software to be compiled.

Installation instructions for Anaconda can be found here.

A full list of the packages available as part of the Anaconda distribution can be found here.

An additional advantage of installing with Anaconda is that you don’t require admin rights to install it, it will install in the user’s home directory, and this also makes it trivial to delete Anaconda at a later date (just delete that folder).

> source: http://pandas.pydata.org/pandas-docs/stable/install.html

### Running the test suite

pandas is equipped with an exhaustive set of unit tests covering about 97% of the codebase as of this writing. To run it on your machine to verify that everything is working (and you have all of the dependencies, soft and hard, installed), make sure you have nose and run:
```python
>>> import pandas as pd
>>> pd.test()
Running unit tests for pandas
pandas version 0.18.0
numpy version 1.10.2
pandas is installed in pandas
Python version 2.7.11 |Continuum Analytics, Inc.|
   (default, Dec  6 2015, 18:57:58) [GCC 4.2.1 (Apple Inc. build 5577)]
nose version 1.3.7
..................................................................S......
........S................................................................
.........................................................................

----------------------------------------------------------------------
Ran 9252 tests in 368.339s

OK (SKIP=117)
```

pandas 1.18.0 이후 버전 테스트할 때 아래와 같은 날짜 파싱 문제가 발생하면 Python dateutil 패키지를 업데이트해야한다.
특히, 최근에 dateutil 패키지가 2.5.0 버전으로 업그레이드하면서 문제가 발생했는데, 2.5.3 버전에서 수정되었다.
pandas 1.18.0 버전을 쓰고 있다면, pandas도 최신 버전으로 업그레이드한다.
```sh
pip install --upgrade python-dateutil
```
```sh
pip install --upgrade pandas
```
```python
======================================================================
FAIL: test_yy_format (pandas.io.tests.test_parsers.TestCParserHighMemory)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 1064, in test_yy_format
    tm.assert_frame_equal(rs, xp)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 1097, in assert_frame_equal
    obj='{0}.index'.format(obj))
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 729, in assert_index_equal
    obj=obj, lobj=left, robj=right)
  File "pandas/src/testing.pyx", line 58, in pandas._testing.assert_almost_equal (pandas/src/testing.c:3809)
  File "pandas/src/testing.pyx", line 147, in pandas._testing.assert_almost_equal (pandas/src/testing.c:2685)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 880, in raise_assert_detail
    raise AssertionError(msg)
AssertionError: DataFrame.index are different

DataFrame.index values are different (100.0 %)
[left]:  DatetimeIndex(['2031-09-01 00:10:00', '2028-09-02 10:20:00',
               '2031-09-03 08:30:00'],
              dtype='datetime64[ns]', name=u'date_time', freq=None)
[right]: DatetimeIndex(['2009-01-31 00:10:00', '2009-02-28 10:20:00',
               '2009-03-31 08:30:00'],
              dtype='datetime64[ns]', name=u'date_time', freq=None)

======================================================================
FAIL: test_yy_format (pandas.io.tests.test_parsers.TestCParserLowMemory)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 1064, in test_yy_format
    tm.assert_frame_equal(rs, xp)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 1097, in assert_frame_equal
    obj='{0}.index'.format(obj))
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 729, in assert_index_equal
    obj=obj, lobj=left, robj=right)
  File "pandas/src/testing.pyx", line 58, in pandas._testing.assert_almost_equal (pandas/src/testing.c:3809)
  File "pandas/src/testing.pyx", line 147, in pandas._testing.assert_almost_equal (pandas/src/testing.c:2685)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 880, in raise_assert_detail
    raise AssertionError(msg)
AssertionError: DataFrame.index are different

DataFrame.index values are different (100.0 %)
[left]:  DatetimeIndex(['2031-09-01 00:10:00', '2028-09-02 10:20:00',
               '2031-09-03 08:30:00'],
              dtype='datetime64[ns]', name=u'date_time', freq=None)
[right]: DatetimeIndex(['2009-01-31 00:10:00', '2009-02-28 10:20:00',
               '2009-03-31 08:30:00'],
              dtype='datetime64[ns]', name=u'date_time', freq=None)

======================================================================
FAIL: test_yy_format (pandas.io.tests.test_parsers.TestPythonParser)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 1064, in test_yy_format
    tm.assert_frame_equal(rs, xp)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 1097, in assert_frame_equal
    obj='{0}.index'.format(obj))
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 729, in assert_index_equal
    obj=obj, lobj=left, robj=right)
  File "pandas/src/testing.pyx", line 58, in pandas._testing.assert_almost_equal (pandas/src/testing.c:3809)
  File "pandas/src/testing.pyx", line 147, in pandas._testing.assert_almost_equal (pandas/src/testing.c:2685)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 880, in raise_assert_detail
    raise AssertionError(msg)
AssertionError: DataFrame.index are different

DataFrame.index values are different (100.0 %)
[left]:  DatetimeIndex(['2031-09-01 00:10:00', '2028-09-02 10:20:00',
               '2031-09-03 08:30:00'],
              dtype='datetime64[ns]', name=u'date_time', freq=None)
[right]: DatetimeIndex(['2009-01-31 00:10:00', '2009-02-28 10:20:00',
               '2009-03-31 08:30:00'],
              dtype='datetime64[ns]', name=u'date_time', freq=None)

======================================================================
FAIL: test_parsers (pandas.tseries.tests.test_tslib.TestDatetimeParsingWrappers)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/tseries/tests/test_tslib.py", line 537, in test_parsers
    self.assertEqual(result1, expected)
AssertionError: datetime.datetime(2011, 5, 20, 0, 0) != datetime.datetime(2020, 5, 11, 0, 0)

----------------------------------------------------------------------
Ran 9742 tests in 1457.112s

FAILED (SKIP=153, errors=7, failures=5)
```
