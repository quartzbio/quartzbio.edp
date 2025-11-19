# Exporting Data

## Overview

The EDP provides several data accessibility and portability tools to
facilitate the export of data to downstream tools for molecular
analysis.

Datasets can be exported in multiple formats:

- JSON: JSON Lines format (gzipped).
- CSV: Comma Separated Value format (flattened, gzipped).
- TSV: Tab Separated Value format (flattened, gzipped).
- Excel (XLSX): Microsoft Excel format (flattened).
- Parquet: column-oriented data file format.

Exporting data can take anywhere from a few seconds to tens of minutes,
depending on the number of records and selected format. Exports are
processed server-side, and the output is a downloadable file. An
exported JSON file can be re-imported into EDP without any modification.

## Export Limits

Different export formats have different limits:

| Format | Max Records         |
|--------|---------------------|
| Excel  | 1,048,576 records   |
| JSON   | 500,000,000 records |
| TSV    | 500,000,000 records |
| CSV    | 500,000,000 records |

## Flattened Fields (CSV/XLSX)

CSV and XLSX exports are processed by a flattening algorithm during
export. The reason for this is to handle list fields, which are not well
supported by Excel and other CSV readers. The following example
illustrates the effects of the flattening algorithm:

The following dataset records:

    {"a": "a", "b": ["x"]}
    {"a": "a", "b": ["x", "y"]}
    {"a": "a", "b": ["x", "y", "z"]}

will be exported to the following CSV:

    a,b.0,b.1,b.2
    a,x,,
    a,x,y,
    a,x,y,z

## Export a Dataset

To export a dataset, users can retrieve it by name or ID and initiate
the export. Exports can take a few minutes for large datasets. Users can
always start a large export and check back when it finishes on the
Activity tab of the EDP web interface. Exports can also be saved
directly into a vault (with target_full_path keyword argument) and
accessed from there.

``` r
library(quartzbio.edp)

dataset <- Dataset.get_or_create_by_full_path("quartzbio:Public:/HGNC/3.3.1-2021-08-25/HGNC")

# Export the entire dataset (~40k records), this may take a minute...
# NOTE: `format` can be: json, tsv, csv, or excel
export <- DatasetExport.create(
  dataset$id,
  format = "csv",
  params = NULL,
  send_email_on_completion = TRUE
)

# Wait for the export to complete
Dataset.activity(dataset$id)

# Download
url <- DatasetExport.get_download_url(export$id)
download.file(url, "data.csv")

# An exports can also be saved to a path in a vault
export <- DatasetExport.create(
  dataset$id,
  format = "csv",
  params = NULL,
  send_email_on_completion = TRUE,
  target_full_path = "my_vault:/path/to/csv_files_folder/my_export"
)
```

## Exporting Large Amounts of Data

An example file size for a CSV file with 150M rows and 50 columns
populated with floats and relatively short strings is about 50GB. In
general, users are recommended not to work with files this size directly
and instead to shrink the export by applying filters or selecting only
specific columns. If necessary, users can also export in batches
(e.g. export by chromosome or sample).

### Export a Filtered Dataset

Users can leverage the dataset filtering system to export a slice of a
dataset:

``` r
library(quartzbio.edp)

dataset <- Dataset.get_by_full_path("quartzbio:Public:/ClinVar/5.2.0-20221105/Variants-GRCH37")

# Filter the dataset by field values and limit the number of results
# NOTE: `format` can be: json, tsv, csv, or excel
filters <- list(list("info.ORIGIN__gte", 3))
fields <- list("variant", "info.ORIGIN", "gene")
export <- DatasetExport.create(
  dataset$id,
  format = "json",
  params = list(filters = filters, fields = fields, limit = 100),
  follow = TRUE,
)

# Download to your home directory
url <- DatasetExport.get_download_url(export$id)
download.file(url, "my_variants.json")
```

### Export and Load a dataset from Parquet File

Datasets can also be exported into a parquet file and then can be
read/queried. The Dataset results are returned as a R dataframe or as a
[arrow](https://arrow.apache.org/docs/r/reference/read_parquet.html)
table. User can export the dataset into parquet file format (.parquet)
and build queries using [Arrow
expressions](https://arrow.apache.org/docs/r/reference/Expression.html).
Export Dataset into parquet and read the records using `Dataset_load`
function.

``` r
# Export the whole dataset into parquet and read into a dataframe.
# Datset ID or dataset full path can be provided

results <- Dataset_load(id = "<DATASET_ID>")

results <- Dataset_load(full_path = "<DATASET_FULL_PATH>")

# To export selected fields

results <- Dataset_load(
  full_path = "quartzbio:Public:/ClinVar/5.3.0-20231007/hgvs4variation",
  col_select = c("Symbol", "GeneID", "Type", "NucleotideExpression", "Assembly")
)

# Fields can be selected/excluded based on tidyverse expressions

results <- Dataset_load(id = "<DATASET_ID>", col_select = ends_with("e"))


# The Dataset can also be queried by creating arrow filter expressions
# Filter based on Assembly == 'GRCH37' and VariantionID < 9000

results <- Dataset_load(
  id = "<DATASET ID>",
  filter_expr = Expression$create("and", args = list(
    Expression$field_ref("Assembly") == "\"GRCh37\"",
    Expression$field_ref("VariationID") < 9000
  ))
)

# Dataset schema can also be reterived along with the dataset results
# get_schema can be set to true to return the schema as well along with the fitered dataset results

results <- Dataset_load(
  full_path = "<DATASET_FULL_PATH>",
  col_select = c("Symbol", "GeneID", "Type", "NucleotideExpression", "Assembly"),
  get_schema = TRUE, filter_expr = Expression$field_ref("Assembly") == "\"GRCh37\""
)
```

## API Endpoints

Methods do not accept URL parameters or request bodies unless specified.
Please note that if your EDP endpoint is sponsor.edp.aws.quartz.bio, you
would use sponsor.api.edp.aws.quartz.bio.

### Dataset Exports

| Method |            HTTP Request            |              Description               |                                 Authorization                                  |                        Response                        |
|:------:|:----------------------------------:|:--------------------------------------:|:------------------------------------------------------------------------------:|:------------------------------------------------------:|
| create | POST <https://>/v2/dataset_exports | Create a dataset export for a dataset. | This request requires an authorized user with read permission for the dataset. | The response contains a single DatasetExport resource. |

Request Body:

In the request body, provide an object with the following properties:

|         Property         |  Value  |                                    Description                                     |
|:------------------------:|:-------:|:----------------------------------------------------------------------------------:|
|        dataset_id        | integer |                                A valid dataset ID.                                 |
|          format          | string  |                              The export file format.                               |
|          params          | object  |                             Dataset query parameters.                              |
|     target_full_path     | string  | (Optional) A vault location to store the export output (must be an EDP full path). |
|         priority         | integer |                   (Optional) A priority to assign to this task.                    |
| send_email_on_completion | boolean |       (Optional) An email is sent when the export is ready (default: false)        |

The following export formats (format property) are available:

|    Format    | Extension |                    Description                     |
|:------------:|:---------:|:--------------------------------------------------:|
|     json     | .json.gz  |               JSONL format, gzipped.               |
|     csv      |   .csv    |               Comma-separated format               |
|  csv-expand  |   .csv    | Comma-separated format, with expanded list values. |
|    excel     |   .xlsx   |                Excel (XLSX) format.                |
| excel-expand |   .xlsx   |  Excel (XLSX) format, with list values expanded.   |

When using an “expanded” mode, fields containing list values (multiple
distinct values) will be expanded into independent columns in the
output. This is useful in some downstream applications that do not
natively support list within columns.

The following query parameters (params property) are supported for
exports:

|    Property    |  Value  |                        Description                         |
|:--------------:|:-------:|:----------------------------------------------------------:|
|     limit      | integer | The number of records to export (between 1 and 1,000,000). |
|    filters     | objects |                   A valid filter object.                   |
|     fields     | string  |        A list of fields to include in the results.         |
| exclude_fields | string  |        A list of fields to exclude in the results.         |
|     query      | string  |                   A valid query string.                    |

| Method |               HTTP Request                |       Description        |                                  Authorization                                  |                      Response                       |
|:------:|:-----------------------------------------:|:------------------------:|:-------------------------------------------------------------------------------:|:---------------------------------------------------:|
| delete | DELETE <https://>/v2/dataset_exports/{ID} | Delete a dataset export. | This request requires an authorized user with write permissions on the dataset. | The response returns “HTTP 200 OK” when successful. |

|  Method  |                  HTTP Request                   |        Description         |                                 Authorization                                  |                                                     Response                                                     |
|:--------:|:-----------------------------------------------:|:--------------------------:|:------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------:|
| download | GET <https://>/v2/dataset_exports/{ID}/download | Download a dataset export. | This request requires an authorized user with read permissions on the dataset. | The default response is a 302 redirect. When redirect mode is disabled, the response contains a URL to the file. |

Parameters

This request accepts the following parameter:

| Property |  Value  |                           Description                           |
|:--------:|:-------:|:---------------------------------------------------------------:|
| redirect | boolean | Return a 302 redirect to the download location (default: true). |

Dataset exports may expire after 24 hours, after which the download URL
will not work. Please re-run the export if necessary.

| Method |              HTTP Request              |            Description             |                                 Authorization                                  |                    Response                     |
|:------:|:--------------------------------------:|:----------------------------------:|:------------------------------------------------------------------------------:|:-----------------------------------------------:|
|  get   | GET <https://>/v2/dataset_exports/{ID} | Retrieve metadata about an export. | This request requires an authorized user with read permissions on the dataset. | The response contains a DatasetExport resource. |

| Method |                  HTTP Request                   |                 Description                 |                                 Authorization                                  |                         Response                         |
|:------:|:-----------------------------------------------:|:-------------------------------------------:|:------------------------------------------------------------------------------:|:--------------------------------------------------------:|
|  list  | GET <https://>/v2/datasets/{DATASET_ID}/exports | List the exports associated with a dataset. | This request requires an authorized user with read permissions on the dataset. | The response contains a list of DatasetExport resources. |

| Method |                  HTTP Request                  |                 Description                 |                                 Authorization                                  |                                   Response                                   |
|:------:|:----------------------------------------------:|:-------------------------------------------:|:------------------------------------------------------------------------------:|:----------------------------------------------------------------------------:|
| cancel | PUT <https://>/v2/datasets_exports/{ID}/cancel | List the exports associated with a dataset. | This request requires an authorized user with read permissions on the dataset. | The response will contain a DatasetExport resource with the status canceled. |
