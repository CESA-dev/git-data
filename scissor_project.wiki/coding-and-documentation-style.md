**Always follow this style**

Yes, I know the existing code is not using these styles, it is a little harsh for you guys to keep these styles. But hey... Never too late, right?


Coding Style
------------------------
[Google Python Style](https://google.github.io/styleguide/pyguide.html)


Documentation Style
------------------------
[PEP 257](https://www.python.org/dev/peps/pep-0257/)


### Google style python docstrings

```
def FetchBigtableRows(big_table, keys, other_silly_variable=None):
  """Fetches rows from a Bigtable.

  Retrieves rows pertaining to the given keys from the Table instance
  represented by big_table.  Silly things may happen if
  other_silly_variable is not None.

  Args:
    big_table: An open Bigtable Table instance.
    keys: A sequence of strings representing the key of each table row
        to fetch.
    other_silly_variable: Another optional variable, that has a much
        longer name than the other args, and which does nothing.

  Returns:
    A dict mapping keys to the corresponding table row data
    fetched. Each row is represented as a tuple of strings. For
    example:

    {'Serak': ('Rigel VII', 'Preparer'),
     'Zim': ('Irk', 'Invader'),
     'Lrrr': ('Omicron Persei 8', 'Emperor')}

    If a key from the keys argument is missing from the dictionary,
    then that row was not found in the table.

  Raises:
    IOError: An error occurred accessing the bigtable.Table object.
  """
  pass

```