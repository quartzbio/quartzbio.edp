# Transforming Datasets

## Overview

The EDP makes it easy to transform data using its dynamic, Python-based
expression language. Users can employ expressions to transform data when
importing files when copying data between (or within) datasets (using
“migrations”), or even when querying datasets. In all scenarios,
expressions can be provided through the target_fields parameter. Users
can refer to the
[Expressions](https://quartzbio.github.io/quartzbio.edp/articles/expressions.md)
documentation to learn more about using expressions.

This article describes how to transform data using dataset migrations,
but users can use the same techniques with dataset imports. With dataset
migrations, users can copy data between datasets as well as modify
datasets in-place. This makes it possible to add, edit, and remove
fields as well as records. All dataset migrations have a source dataset
and a target dataset (which can be the same when editing a single
dataset). Users are recommended to review the [Creating and Migrating
Datasets](https://quartzbio.github.io/quartzbio.edp/articles/creating_and_migrating_datasets.md)
documentation before this article.

## Modifying Fields

### Add Fields

The most common dataset transformation is to add a field to a dataset
(also known as annotating the dataset or inserting a column). Fields can
be added or modified using the target_fields parameter, which should
contain a list of valid dataset fields. Any new fields in target_fields
will be automatically detected and added to the dataset’s schema. Adding
fields requires the use of the upsert or overwrite commit mode,
depending on the desired effect. This will ensure that the records are
updated in-place (based on their \_id value), and not duplicated. To add
multiple fields and transform data in a specific way, users can also
create a reusable Dataset Template.

In the following example, a new field will be added to a dataset
“in-place”, using the upsert commit mode:

``` r
library(quartzbio.edp)

# Retrieve the source dataset
source_dataset <- Dataset.get_by_full_path("quartzbio:Public:/ClinVar/5.2.0-20210110/Variants-GRCH37")

# Create new target dataset in personal vault
vault <- Vault.get_personal_vault()
dataset_full_path <- paste(vault$full_path, "/r_examples/clinvar", sep = ":")
target_dataset <- Dataset.get_or_create_by_full_path(dataset_full_path)

# Apply filter to copy subset of records from source
# Copy all variants in BRCA1
migration <- DatasetMigration.create(
  source_id = source_dataset$id,
  target_id = target_dataset$id,
  # Omit source_params to copy the whole dataset
  source_params = list(
    filters = list(
      list("gene", "BRCA1")
    )
  )
)

dataset <- Dataset.get_or_create_by_full_path(dataset_full_path)

fields <- list(
  list(
    name = "clinsig_clone",
    expression = "record.clinical_significance",
    data_type = "string"
  )
)

# The source and target are the same dataset, which edits the dataset in-place
DatasetMigration.create(
  source_id = dataset$id,
  target_id = dataset$id,
  target_fields = fields,
  source_params = list(limit = 100000),
  commit_mode = "upsert"
)
```

### Edit Fields

In the following example, an existing field in the dataset from the
previous example (clinsig_clone) is modified (converted to uppercase).
Similar to the example above, a commit mode of overwrite or upsert is
required to avoid duplicating records.

This example uses an expression that references a pre-existing field in
the dataset; users can learn more about expression context by reviewing
the
[Expressions](https://quartzbio.github.io/quartzbio.edp/articles/expressions.md)
documentation.

``` r
library(quartzbio.edp)

vault <- Vault.get_personal_vault()
dataset_full_path <- paste(vault$full_path, "/r_examples/clinvar", sep = ":")
dataset <- Dataset.get_or_create_by_full_path(dataset_full_path)

fields <- list(
  list(
    # Convert your copied "clinsig_clone" values to uppercase.
    name = "clinsig_clone",
    data_type = "string",
    expression = "value.upper()"
  )
)

# Run a migration where the source and target are the same dataset
DatasetMigration.create(
  source_id = dataset$id,
  target_id = dataset$id,
  target_fields = fields,
  commit_mode = "upsert"
)
```

### Remove Fields

Fields cannot be removed from a dataset in-place so removing a field
requires a new empty target dataset; all the data must be migrated to a
new target dataset with the removed field(s) excluded from the source
dataset.

In the following example, the field (clinsig_clone) in the source
dataset is removed by the dataset migration. Since a field is removed,
the target dataset must be a new dataset (or one without the field). In
this scenario, any commit mode can be used unless the user intends to
overwrite records in the target dataset.

The example follows from the previous one:

``` r
library(quartzbio.edp)

vault <- Vault.get_personal_vault()

# Use the dataset from the example above
source_full_path <- paste(vault$full_path, "/r_examples/clinvar", sep = ":")
source <- Dataset.get_by_full_path(source_full_path)

# To remove a field, you need to create a new, empty dataset first.
target_full_path <- paste(vault$full_path, "/r_examples/clinvar_lite", sep = ":")
target <- Dataset.get_or_create_by_full_path(target_full_path)

# Exclude the copied field from the example above
DatasetMigration.create(
  source_id = source$id,
  target_id = target$id,
  source_params = list(
    exclude_fields = list("clinsig_clone")
  ),
  commit_mode = "upsert"
)
```

To only remove the data (field values) from a specified field, users can
run an upsert migration and use an expression to set the values to None
(Python’s equivalent to NULL).

### Transient Fields

Transient fields are like variables in a programming language. They can
be used in a complex transform that requires intermediate values that
are not meant to be stored in the dataset. Transient fields can be
referenced by other expressions, but are not added to the dataset’s
schema or stored. Users can set the parameter is_transient to True and
ensure that the field’s ordering parameter evaluates the transient
fields in the right order.

The following example uses transient fields to structure a few VCF
records, leaving the variant IDs and dbSNP rsIDs in the resulting
dataset:

``` r
library(quartzbio.edp)

vault <- Vault.get_personal_vault()
dataset_full_path <- paste(vault$full_path, "/r_examples/variants-transient", sep = ":")
dataset <- Dataset.get_or_create_by_full_path(dataset_full_path)

# translate_variant() returns an object with 8+ fields.
# since we do not want all those fields added to the dataset
# we make this field transient and pull the gene and protein change values
# into their own fields
target_fields <- list(
  list(
    name = "translated_variant_transient",
    description = "Transient fields that runs variant translation expression",
    is_transient = TRUE,
    data_type = "object",
    ordering = 1,
    expression = "translate_variant(record.variant)"
  ),
  list(
    name = "gene",
    description = "HUGO Gene Symbol",
    data_type = "string",
    ordering = 2,
    expression = "get(record, 'translated_variant_transient.gene')"
  ),
  list(
    name = "protein_change",
    data_type = "string",
    ordering = 2,
    expression = "get(record, 'translated_variant_transient.protein_change')"
  )
)

# Import these records into a dataset
records <- list(
  list(variant = "GRCH37-17-41244429-41244429-T"),
  list(variant = "GRCH37-3-37089131-37089131-T")
)

# Add columns gene/protein_change, via transient column "translated_variant"
imp <- Dataset_import(
  dataset_id = dataset$id,
  records = records,
  commit_mode = "upsert",
  target_fields = target_fields
)

Dataset.activity(dataset$id)

Dataset.query(id = dataset$id, exclude_fields = list("_id", "_commit"))
#      gene            variant                   protein_change
#   1  BRCA1  GRCH37-17-41244429-41244429-T       p.S1040N
#   2  MLH1   GRCH37-3-37089131-37089131-T        p.K618M
```

## Modifying Records

### Overwrite Records

In order to completely overwrite specific records in a dataset, users
can utilize the overwrite commit mode. Users will need to know the \_id
of the records they wish to overwrite, which can be retrieved by
querying the dataset.

In the following example, a few records will be imported and then
edited:

``` r
library(quartzbio.edp)

vault <- Vault.get_personal_vault()
dataset_full_path <- paste(vault$full_path, "/r_examples/transform_overwrite", sep = ":")
dataset <- Dataset.get_or_create_by_full_path(dataset_full_path)

# Initial records to import
records <- list(
  list(name = "Francis Crick", birth_year = "1916"),
  list(name = "James Watson", birth_year = "1928"),
  list(name = "Rosalind Franklin", birth_year = "1920")
)
imp <- Dataset_import(
  dataset_id = dataset$id,
  records = records, commit_mode = "append"
)

# Get record and change some data
record <- Dataset.query(id = dataset$id, filters = '[["name", "Francis Crick"]]')[1, ]
record["name"] <- "Francis Harry Compton Crick"
record["awards"] <- list("Order of Merit", "Fellow of the Royal Society")

# Overwrite mode
imp <- Dataset_import(
  dataset_id = dataset$id,
  records = list(as.list(record)),
  commit_mode = "overwrite"
)

# Show the result
filters <- list(
  list("_id", record$"_id")
)
Dataset.query(id = dataset$id, filters = filters)
```

### Upsert (Edit) Records

In order to only update (or add) specific field values in a dataset,
users can utilize the upsert commit mode. Users will need to know the
\_id of the records they wish to upsert, which can be retrieved by
querying the dataset.

Similar to the example above, in the following example a few records
will be imported and then edited:

``` r
library(quartzbio.edp)

vault <- Vault.get_personal_vault()
dataset_full_path <- paste(vault$full_path, "/r_examples/transform_upsert", sep = ":")
dataset <- Dataset.get_or_create_by_full_path(dataset_full_path)

# Initial records to import
records <- list(
  list(name = "Francis Crick", birth_year = "1916"),
  list(name = "James Watson", birth_year = "1928"),
  list(name = "Rosalind Franklin", birth_year = "1920")
)
imp <- Dataset_import(
  dataset_id = dataset$id,
  records = records,
  commit_mode = "append"
)

# Get record and change some data
record <- Dataset.query(id = dataset$id, filters = '[["name", "Francis Crick"]]')[1, ]
record["name"] <- "Francis Harry Compton Crick"
record["birthplace"] <- "Northampton, England"

# Upsert mode
imp <- Dataset_import(
  dataset_id = dataset$id,
  records = list(as.list(record)),
  commit_mode = "upsert"
)

# Show the result
filters <- list(
  list("_id", record$"_id")
)
Dataset.query(id = dataset$id, filters = filters)
```

### Delete Records

In order to completely delete a record from a dataset, users may use the
delete commit mode and pass a list of record IDs (from their \_id
field).

Users can delete records via an import if they have a file or list of
record IDs or via a migration if they are deleting the results of a
dataset query.

The following provides an example of Delete via Import:

``` r
library(quartzbio.edp)

vault <- Vault.get_personal_vault()
dataset_full_path <- paste(vault$full_path, "/r_examples/data_delete", sep = ":")
dataset <- Dataset.get_or_create_by_full_path(dataset_full_path)

# Initial records to import
records <- list(
  list(name = "six"),
  list(name = "seven"),
  list(name = "eight"),
  list(name = "nine")
)
imp <- Dataset_import(
  dataset_id = dataset$id,
  records = records,
  commit_mode = "append"
)

Dataset.query(id = dataset$id, fields = list("name"))
#   name
#   1 six
#   2 seven
#   3 eight
#   4 nine

# Get the record ID for 'nine'
record <- Dataset.query(id = dataset$id, filters = '[["name", "nine"]]', fields = list("_id"))

# Delete mode
imp <- Dataset_import(
  dataset_id = dataset$id,
  records = list(as.list(record)),
  commit_mode = "delete"
)


Dataset.query(id = dataset$id, fields = list("name"))
#   name
#   1 six
#   2 seven
#   3 eight
```

The following provides an example of Delete via Migration:

``` r
library(quartzbio.edp)

vault <- Vault.get_personal_vault()
dataset_full_path <- paste(vault$full_path, "/r_examples/data_delete_migration", sep = ":")
dataset <- Dataset.get_or_create_by_full_path(dataset_full_path)

# Initial records to import
records <- list(
  list(name = "Alice"),
  list(name = "Bob"),
  list(name = "Carol"),
  list(name = "Chuck"),
  list(name = "Craig"),
  list(name = "Dan"),
  list(name = "Eve")
)
imp <- Dataset_import(
  dataset_id = dataset$id,
  records = records,
  commit_mode = "append"
)

# Get the records where names begin with C
records <- Dataset.query(id = dataset$id, filters = '[["name__prefix", "c"]]')

# Delete mode
migration <- DatasetMigration.create(
  source_id = dataset$id,
  target_id = dataset$id,
  source_params = list(filters = list(list("name__prefix", "C"))),
  commit_mode = "delete"
)

Dataset.query(id = dataset$id, fields = list("name"))
#   name
#   1 Alice
#   2 Bob
#   3 Dan
#   4 Eve
```
