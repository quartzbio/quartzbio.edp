# Expressions

## Overview

Expressions on the QuartzBio Enterprise Data Platform (EDP) are
Python-like formulas that can be used to pull data from datasets,
calculate statistics, or run advanced algorithms. They are typically
used when transforming datasets but have many other uses such as
building web application widgets, pulling EDP data into Excel or Google
Sheets, and augmenting databases outside EDP. Expressions are also
referred to as Python “one-liners” but can be used in both the Python
and R client libraries for EDP. Expressions may also be evaluated in the
EDP UI for data discovery and data transformation.

## Expression Syntax

Expressions resemble a single line of code in the Python language.
Expressions can only be one valid line of code but can contain line
breaks for presentation purposes. As a result, they do not support the
declaration of variables or classes.

Expressions can use the built-in library of expression functions in EDP.
The expression functions library is maintained by QuartzBio staff and
users are encouraged to submit suggestions for new functions to be added
to the library.

Expressions can be a simple static value, such as a number or string:

    # Numeric expression
    1 + (2 * 3)
    # output: 7

    # String expression
    "hello" + " world"
    # output: "hello world"

## Context Variables

Depending on when an expression is evaluated, it may also include
“context variables”. These are variables available to the expression
interpreter at run-time (similar to the library of available functions).

For example, expressions can reference context values provided during
evaluation or annotation, such as record:

    # String expression with context: {"record": {"a": "hello"}}
    record["a"] + " world"
    # output: "hello world"

The following context variables may be referenced:

- record: An object containing the current dataset record (or “row”)
  currently being processed. Users can access field values in the record
  using Python dictionary notation (e.g. record\[‘field’\]) or by dot
  notation (e.g. record.field).

- value: The value of the current field before being processed. This can
  be used as a shortcut for retrieving the current value.

- source_filename: The filename of the file being imported. This is only
  available for expressions for fields passed into a dataset import with
  a manifest or object_id. This is useful if metadata is encoded within
  the filename e.g. sample info or genome build. This value will be None
  for dataset imports with records (i.e. when no file is provided)..

- source_dataset: the ID of the source dataset. This is the same as the
  source_id in a dataset migration. This value is always None for
  dataset imports (since the source is a file or a list of JSON records,
  not a dataset).

- target_dataset: the ID of the target dataset. This is the same as the
  target_id in a dataset migration and the dataset_id in a dataset
  import.

The following example shows how these variables can be used during
annotation (i.e. when importing or migrating datasets), along with a
built-in expression function such as “split”:

If the current record is: `{"message": "hello"}`

The following fields have valid expressions:

    {
        # Replace the value of `message` with "hello world"
        "message": {
            "expression": 'value + "world"',
            "ordering": 0
        }


    # Create a new field containing ["hello", "world"] using the split function
        "split_message": {
            "expression": 'record.message.split()',
            "ordering": 1
            "is_list": True
        }
    }

The output would be:

`{"message": "hello world", "split_message": ["hello", "world"]}`

As well as split, users can also use several other built-in Python
functions such as len, min, max, sum, round, range, and a wide range of
EDP-specific functions to perform analysis on datasets.In addition,
users can wrap functions in other functions, and iterate through lists.
This makes it possible to construct advanced expressions that pull and
manipulate data from one or more datasets:

    # Numeric expression using built-in functions
    sum(i for i in range(100))
    # output: 4950

    # Numeric expression using a built-in EDP function
    dataset_field_stats("quartzbio:Public:/ClinVar/5.2.0-20210110/Variants-GRCH37", "info.ORIGIN")["avg"]
    # output: 0.883874789018

## Data Types and Lists

Expressions always have a return value. The value’s data type depends on
the expression, but can be one of the following:

| Data Type        | Description                                                                            |
|------------------|----------------------------------------------------------------------------------------|
| string (default) | A valid UTF-8 string with up to 32,766 characters.                                     |
| text             | A valid UTF-8 string of any length.                                                    |
| blob             | A valid UTF-8 string of any length (this data type is not indexed for search).         |
| date             | A string in ISO 8601 format, for example: “2017-03-29T14:52:01”.                       |
| integer          | A signed 32-bit integer with a minimum value of -231 and a maximum value of 231-1.     |
| long             | A signed 64-bit integer with a minimum value of -263 and a maximum value of 263-1.     |
| float            | single-precision 32-bit IEEE 754 floating point.                                       |
| double           | A double-precision 64-bit IEEE 754 floating point.                                     |
| boolean          | Casts the result to a boolean: True or False. Uses Python’s truth value testing rules. |
| object           | A key/value, JSON-like object, similar to a Python dictionary.                         |

Expressions can be set up to return a single value (default) or a list
of values. Enabling list mode will cause the expression to always cast
the return value as a list, and vice-versa.

## Type Casting

Each data type “casts” the result of an expression ensuring
compatibility with the underlying dataset system. If the result of an
expression is incompatible with the data type, an error will be raised
for that record.

For return values compatible with the required data type, the final
result should be straightforward. It is important to note that
expressions make a distinction between null values (i.e. Python None),
empty strings, and empty lists. The following tables show what to expect
when encountering these types of values for different data types:

| Expression Result |   Data Type   | As Value  |    As List    |
|:-----------------:|:-------------:|:---------:|:-------------:|
|        “”         |  string/text  |    “”     |    \[“”\]     |
|      \[“”\]       |  string/text  |    “”     |    \[“”\]     |
|       None        |  string/text  |   None    |   \[None\]    |
|     \[None\]      |  string/text  |   None    |   \[None\]    |
|       \[\]        |  string/text  |   None    |     \[\]      |
|        “”         | integer/float |   None    |   \[None\]    |
|      \[“”\]       | integer/float |   None    |   \[None\]    |
|       None        | integer/float |   None    |   \[None\]    |
|     \[None\]      | integer/float |   None    |   \[None\]    |
|       \[\]        | integer/float |   None    |     \[\]      |
|        “”         |    boolean    |   False   |   \[False\]   |
|      \[“”\]       |    boolean    |   False   |   \[False\]   |
|       None        |    boolean    |   None    |   \[None\]    |
|     \[None\]      |    boolean    |   None    |   \[None\]    |
|       \[\]        |    boolean    |   None    |     \[\]      |
|   float(“inf”)    |     float     | Infinity  | \[Infinity\]  |
|   float(“-inf”)   |     float     | -Infinity | \[-Infinity\] |
|   float(“NaN”)    |     float     |   None    |   \[None\]    |

## Using Expressions

Most commonly, expressions are used to [transform
datasets](https://quartzbio.github.io/quartzbio.edp/articles/transforming_datasets.md).

Dataset imports and migrations are asynchronous tasks that can take time
to run. There are two ways to run expressions in real time:

- Evaluation: run a single expression with custom context values.
- Annotation: run one or more expressions on an arbitrary list of
  records.

## Evaluate an Expression

The ability to evaluate a single expression is helpful when testing new
expressions, or in the context of an application view that needs a very
specific piece of information. When evaluating individual expressions
using the evaluate endpoint, no context is included by default. Users
can provide a custom dictionary of context variables through the data
parameter.

``` r
require(quartzbio.edp)

# Static expression
Expression.evaluate('"hello" + " " + "world"')
# Response: 'hello world'

# Expression with a context variable "my_field"
Expression.evaluate(
  '"hello" + " " + my_field',
  data = list(my_field = "world")
)
# Response: 'hello world'
```

## Annotating Records

Users can annotate a list of records in real time (i.e. without saving
them to a dataset) using the annotate endpoint. This provides a way to
quickly test one or more expressions on a list of records. To annotate
an entire dataset, see [Transforming
Datasets](https://quartzbio.github.io/quartzbio.edp/articles/transforming_datasets.md).

### Examples:

``` r
require(quartzbio.edp)
records <- list(list(gene = "BRCA1"), list(gene = "BRCA2"), list(gene = "BRAF"), list(gene = "TTN"), list(gene = "TP53"))
# Define the fields to annotate
fields <- list(
  list(
    # How many times is the gene in ClinVar?
    name = "clinvar_count",
    data_type = "integer",
    expression = "dataset_count(
    'quartzbio:Public:/ClinVar/5.2.0-20210110/Variants-GRCH38',
    entities=[('gene', record.gene)]
    )"
  ),
  list(
    # What chromosome is the gene on?
    name = "chromosome",
    data_type = "string",
    expression = "
    dataset_query(
    'quartzbio:Public:/ClinVar/5.2.0-20210110/Variants-GRCH38',
    entities=[('gene', record.gene)],
    filters=[('feature', 'gene')]
    )[0]['genomic_coordinates']['chromosome']"
  ),
  list(
    # Set the current date and time.
    name = "date_evaluated",
    data_type = "date",
    expression = "now()"
  )
)
Annotator.annotate(records = records, fields = fields)
```

### Expression Functions

Users are encouraged to review the [Expression Functions
article](https://quartzbio.github.io/quartzbio.edp/articles/expression_functions.md)
to access a list of all built-in EDP expression functions along with
details about each function.

## Use Cases

Expressions can be evaluated using the EDP Python and R client
libraries, such as when querying and annotating datasets. Expressions
can also be used when creating Expression Recipes and Dataset Templates
in EDP, which are data management tools designed to facilitate dataset
transformation and annotation.

## Expression Recipes

Recipes are expressions that are used to add or modify a dataset field
and may be accessed from the EDP web interface to insert or modify a
column (field) in a dataset. Recipes can also be used to join datasets
by adding multiple fields to a dataset from other datasets based on join
conditions. Users are recommended to read the Recipes documentation for
an in-depth review of Recipes.

## Dataset Templates

Templates describe how data should be transformed. A template is a
collection of fields (columns) that describe the desired format of some
input data. Templates are used to import, export, query, or migrate
data. Expressions can be used in templates for field normalization and
transformation, as well as for adding additional fields and annotations
to input data. Users are recommended to read the [Dataset
Templates](https://quartzbio.github.io/quartzbio.edp/articles/dataset_templates.md)
documentation for an in-depth review of Templates.

## API Endpoints

There are two endpoints that can be used to run expressions in
real-time: annotate and evaluate. Annotate can be used to transform a
list of records, and evaluate can be used for running individual
expressions. These two endpoints are primarily designed for testing
expressions and dataset templates but they can also be used when data
outside of datasets need to be processed. To annotate entire datasets or
imported files, see [Transforming
Data](https://quartzbio.github.io/quartzbio.edp/articles/transforming_datasets.md).
Also, see [Expression
Functions](https://quartzbio.github.io/quartzbio.edp/articles/expression_functions.md)
for a list of functions available for use in expressions.

Methods do not accept URL parameters or request bodies unless specified.
Please note that if your EDP endpoint is sponsor.edp.aws.quartz.bio, you
would use sponsor.api.edp.aws.quartz.bio.

|  Method  |        HTTP Request         |                  Description                   |               Authorization               |                                                                      Response                                                                      |
|:--------:|:---------------------------:|:----------------------------------------------:|:-----------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------:|
| annotate | POST <https://>/v1/annotate |  Annotate a list of records with expressions.  | This request requires an authorized user. | The response contains a list of annotated records and an object containing the number of records with errors and the number of fields with errors. |
| evaluate | POST <https://>/v1/evaluate | Run a single expression with a custom context. | This request requires an authorized user. |                                                  The response contains the evaluated expression.                                                   |

### Annotate

Run a set of expressions on a list of records in real-time.

#### Request Body

In the request body, provide the following properties:

|          Property          |    Value     |                                                        Description                                                        |
|:--------------------------:|:------------:|:-------------------------------------------------------------------------------------------------------------------------:|
|           fields           | DatasetField | A list of [dataset field objects.](https://quartzbio.github.io/quartzbio.edp/articles/creating_and_migrating_datasets.md) |
|       include_errors       |   boolean    |   If True, a new field (\_errors) will be added to each record containing expression evaluation errors (default: True).   |
|          records           |   objects    |                                               An arbitrary list of records.                                               |
| pre_annotation_expression  |    string    |    An arbitrary expression that will be applied before the annotation, e.g. ‘explode(record, fields=\[“mutations”\])’     |
| post_annotation_expression |    string    |  An arbitrary expression that will be applied after the annotation, e.g. ‘melt(record,fields=\[“gene”, “chromosome”\])’   |

### Evaluate

Evaluate a single expression with a custom context.

#### Request Body

In the request body, provide the following properties:

|  Property  |  Value  |                           Description                           |
|:----------:|:-------:|:---------------------------------------------------------------:|
|   fields   | object  |  An object containing variables referenced in the expression.   |
| data_type  | string  |            A valid data type to cast the result to.             |
| expression | string  |                       A valid expression.                       |
|  is_list   | boolean | True if the result should be a list of values (default: False). |

### Common Issues

Using expressions does require some basic knowledge of Python. Due to
the condensed nature of an expression, syntax errors can be hard to
spot. Selecting the correct data type can also be confusing at times.

**The data type defines the final output of an expression.**

One common issue is confusing the data type of a particular function
with the final output of an expression. When working with functions,
users can look to its documentation to see what it returns. If it
returns a list, users should make sure their expression handles that,
even if list mode is disabled.

**Some data types are incompatible with some functions.**

If a function returns a string, but the user has set the expression’s
data type to an integer, double, or object, it may not evaluate
properly.

**When list mode is disabled it will never return a list.**

If list mode is disabled but the expression returns a list, only the
first value will be returned. Conversely, if list mode is enabled, the
value will always be cast to a list.
