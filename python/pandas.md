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

pandas 1.18.0 이후 버전 테스트할 때 아래와 같은 문제가 발생하면 python-dateutil 패키지를 업데이트해야한다.
```sh
pip install --upgrade python-dateutil
```
```python
======================================================================
ERROR: test_round_trip_frame (pandas.io.tests.test_clipboard.TestClipboard)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_clipboard.py", line 81, in test_round_trip_frame
    self.check_round_trip_frame(dt)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_clipboard.py", line 68, in check_round_trip_frame
    result = read_clipboard()
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/clipboard.py", line 19, in read_clipboard
    text = clipboard_get()
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/clipboard.py", line 141, in _pasteQt
    return str(cb.text())
UnicodeEncodeError: 'ascii' codec can't encode characters in position 29-30: ordinal not in range(128)

======================================================================
ERROR: test_round_trip_frame_sep (pandas.io.tests.test_clipboard.TestClipboard)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_clipboard.py", line 73, in test_round_trip_frame_sep
    self.check_round_trip_frame(dt, sep=',')
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_clipboard.py", line 66, in check_round_trip_frame
    result = read_clipboard(sep=sep, index_col=0)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/clipboard.py", line 19, in read_clipboard
    text = clipboard_get()
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/clipboard.py", line 141, in _pasteQt
    return str(cb.text())
UnicodeEncodeError: 'ascii' codec can't encode characters in position 29-30: ordinal not in range(128)

======================================================================
ERROR: test_round_trip_frame_string (pandas.io.tests.test_clipboard.TestClipboard)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_clipboard.py", line 77, in test_round_trip_frame_string
    self.check_round_trip_frame(dt, excel=False)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_clipboard.py", line 68, in check_round_trip_frame
    result = read_clipboard()
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/clipboard.py", line 19, in read_clipboard
    text = clipboard_get()
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/clipboard.py", line 141, in _pasteQt
    return str(cb.text())
UnicodeEncodeError: 'ascii' codec can't encode character u'\xf1' in position 56: ordinal not in range(128)

======================================================================
ERROR: test_url (pandas.io.tests.test_parsers.TestCParserHighMemory)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 1884, in wrapper
    return t(*args, **kwargs)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 1885, in test_url
    url_table = self.read_table(url)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 3496, in read_table
    return read_table(*args, **kwds)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/parsers.py", line 529, in parser_f
    return _read(filepath_or_buffer, kwds)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/parsers.py", line 281, in _read
    compression=kwds.get('compression', None))
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/common.py", line 277, in get_filepath_or_buffer
    req = _urlopen(str(filepath_or_buffer))
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 154, in urlopen
    return opener.open(url, data, timeout)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 469, in error
    result = self._call_chain(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 656, in http_error_302
    return self.parent.open(new, timeout=req.timeout)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 475, in error
    return self._call_chain(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 558, in http_error_default
    raise HTTPError(req.get_full_url(), code, msg, hdrs, fp)
HTTPError: HTTP Error 404: Not Found

======================================================================
ERROR: test_url (pandas.io.tests.test_parsers.TestCParserLowMemory)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 1884, in wrapper
    return t(*args, **kwargs)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 1885, in test_url
    url_table = self.read_table(url)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 3809, in read_table
    return read_table(*args, **kwds)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/parsers.py", line 529, in parser_f
    return _read(filepath_or_buffer, kwds)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/parsers.py", line 281, in _read
    compression=kwds.get('compression', None))
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/common.py", line 277, in get_filepath_or_buffer
    req = _urlopen(str(filepath_or_buffer))
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 154, in urlopen
    return opener.open(url, data, timeout)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 469, in error
    result = self._call_chain(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 656, in http_error_302
    return self.parent.open(new, timeout=req.timeout)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 475, in error
    return self._call_chain(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 558, in http_error_default
    raise HTTPError(req.get_full_url(), code, msg, hdrs, fp)
HTTPError: HTTP Error 404: Not Found

======================================================================
ERROR: test_url (pandas.io.tests.test_parsers.TestPythonParser)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 1884, in wrapper
    return t(*args, **kwargs)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 1885, in test_url
    url_table = self.read_table(url)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 2685, in read_table
    return read_table(*args, **kwds)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/parsers.py", line 529, in parser_f
    return _read(filepath_or_buffer, kwds)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/parsers.py", line 281, in _read
    compression=kwds.get('compression', None))
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/common.py", line 277, in get_filepath_or_buffer
    req = _urlopen(str(filepath_or_buffer))
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 154, in urlopen
    return opener.open(url, data, timeout)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 469, in error
    result = self._call_chain(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 656, in http_error_302
    return self.parent.open(new, timeout=req.timeout)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 475, in error
    return self._call_chain(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 558, in http_error_default
    raise HTTPError(req.get_full_url(), code, msg, hdrs, fp)
HTTPError: HTTP Error 404: Not Found

======================================================================
ERROR: test_url_gz (pandas.io.tests.test_parsers.TestUrlGz)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 1884, in wrapper
    return t(*args, **kwargs)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/tests/test_parsers.py", line 4486, in test_url_gz
    url_table = read_table(url, compression="gzip", engine="python")
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/parsers.py", line 529, in parser_f
    return _read(filepath_or_buffer, kwds)
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/parsers.py", line 281, in _read
    compression=kwds.get('compression', None))
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/io/common.py", line 277, in get_filepath_or_buffer
    req = _urlopen(str(filepath_or_buffer))
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 154, in urlopen
    return opener.open(url, data, timeout)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 469, in error
    result = self._call_chain(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 656, in http_error_302
    return self.parent.open(new, timeout=req.timeout)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 475, in error
    return self._call_chain(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/home/hadoop/anaconda2/lib/python2.7/urllib2.py", line 558, in http_error_default
    raise HTTPError(req.get_full_url(), code, msg, hdrs, fp)
HTTPError: HTTP Error 404: Not Found

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

======================================================================
FAIL: test_scatter_matrix_axis (pandas.tests.test_graphics_others.TestDataFramePlots)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/tests/test_graphics_others.py", line 431, in test_scatter_matrix_axis
    frame=df, range_padding=.1)
  File "/home/hadoop/anaconda2/lib/python2.7/contextlib.py", line 24, in __exit__
    self.gen.next()
  File "/home/hadoop/anaconda2/lib/python2.7/site-packages/pandas/util/testing.py", line 2152, in assert_produces_warning
    % expected_warning.__name__)
AssertionError: Did not see expected warning of class 'UserWarning'.

----------------------------------------------------------------------
Ran 9742 tests in 1457.112s

FAILED (SKIP=153, errors=7, failures=5)
```
