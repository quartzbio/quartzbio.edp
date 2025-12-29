# Vaults and Objects

## Overview

Vaults are similar to filesystems in that they provide a unified
directory structure where folders, files, and datasets can be stored.
All items in a vault (the folders, files, and datasets) are collectively
referred to as “objects”. All vault objects can be moved, copied,
renamed, tagged, and assigned metadata.

Vaults also have an advanced permission model that provides three
different levels of access: read, write, and admin. Vaults can be shared
and permissions can be set via the EDP UI; for more information about
working with vaults on the web interface as well as vault basics such as
vault types, users can refer to the Vaults via UI documentation.

## Creating Vaults

Users can create a vault as long as it has a unique name within their
account domain. Vault and object names are case-insensitive. Once users
create a vault, they’ll be able to add folders, upload files, and create
datasets. To be safe, a special method is provided to retrieve the vault
by name if it already exists:

``` r
library(quartzbio.edp)

# Create a vault by name (only if it doesn't exist)
vault_x <- Vault.get_or_create_by_full_path("Vault X")

# Create a vault (updates the vault if already exists)
vault_x <- Vault_create(name = "Vault X")
```

## Retrieving Vaults

Users can retrieve any shared vault by name or the full path
(e.g. domain:name). The only exception is a user’s personal vault which
has a special name, ~, which is also its full path. If a vault is shared
with a user by someone from another organization, it must be retrieved
by its full path (e.g. quartzbio:public). Users can also retrieve
multiple vaults matching a given advanced search query
(e.g. user:username).

``` r
library(quartzbio.edp)

# Retrieve your personal vault
my_vault <- Vault()

# Your personal vault also has the shortcut `~`
my_vault <- Vault.get_by_full_path("~")

# Retrieve a shared vault by name
vault_x <- Vault.get_by_full_path("Vault X")

# Retrieve a vault from a different domain
public_vault <- Vault.get_by_full_path("quartzbio:public")

# Retrieve a vault by ID
public_vault <- Vault.retrieve("19")

# Retrieve all vaults which match a given Advanced search query
specific_user_vaults <- Vault.all(query = "user:john")
```

## Creating Folders

Folders can only be created within a vault for which the user has
write-level permission. Folder names are case-insensitive. If a user
attempts to create a folder with a duplicate name, the vault will add an
incrementing number to the name (i.e. folder, folder-1, folder-2, …).

``` r
library(quartzbio.edp)

# First, retrieve the vault
vault <- Vault()

# Create the folder at the root of the vault
folder <- Object_create(vault$id, "new-folder", object_type = "folder")
```

## Uploading Files

Users can upload files to any vault to which they have write-level
access. File names are case-insensitive. Uploading a file with a
duplicate name (or the same name as a folder) will cause the new file’s
name to be auto-incremented (i.e. file, file-1, file-2, …).

The maximum file upload size is 100 GB and only UTF-8 encoded files are
supported. Importing files with a different encoding may result in
corrupted content. Users are recommended to gzip their files before
uploading if they are large.

``` r
library(quartzbio.edp)

# First retrieve the vault
vault <- Vault()

# Upload your file into the root of the vault File_upload
# Object.upload_file('local/path/data.csv', vault$id, '/')
File_upload(vault_id = vault$id, local_path = "local/path/data.csv", vault_path = "/")

# You can also specify a new filename for the uploaded file:
File_upload(vault$id, "local/path/data.tsv", "/data_with_a_description.csv")
```

## Downloading Files

Users can download any existing file from a vault if they have read
access to the vault:

``` r
library(quartzbio.edp)

# Retrieve an existing file from your personal vault
csv_file <- Object.get_by_full_path("vault:/data.csv")

# Download file
File_download(csv_file$id, "data.csv")

# Get file download URL
url <- File_get_download_url(csv_file$id)
```

Users can also download more than one file in the same folder:

``` r
# Search for a particular object in the vault using the query argument.
# Query can include the exact file name or Unix style wildcards are supported too

files <- Vault.search(vault$id, query = "xyz", object_type = "file")

for (i in 1:nrow(files)) {
  File_download(files$id[i], files$filename[i])
}
```

## Searching within Vaults

Users can search for files, folders, and datasets within any vault by
name or other attributes.

``` r
library(quartzbio.edp)

# Retrieve a vault
vault <- Vault()

# Search across files, folders, and datasets in the vault
objects <- Vault.search(vault$id, query = "xyz")

# Search for a particular object type: file/folder/dataset
files <- Vault.search(vault$id, "xyz", object_type = "file")

# List all datasets in a vault
datasets <- Vault.datasets(vault$id)

# Find all objects matching an exact filename
data_objects <- Vault.objects(vault$id, filename = "data.csv")

# Retrieve the QuartzBio public vault
public <- Vault.get_by_full_path("quartzbio:public")
```

## Advanced Search

Users can list all objects within a vault that match a specific pattern
(i.e. find all the files within a certain folder) by providing a
case-insensitive regular expression to the regex parameter. It is highly
recommended to use Object.search() instead of searching by regular
expression, unless it is absolutely necessary.

``` r
library(quartzbio.edp)

# Retrieve the EDP public vault
# List all datasets within a specific folder using regex
public <- Vault.get_by_full_path("quartzbio:public")
all_clinvar_datasets <- Vault.datasets(public$id, regex = "/ClinVar/.*")
```

## Move Files Between Folders

Users can search for files in one folder using the aforementioned
querying and move them to another folder.

``` r
library(quartzbio.edp)

# Get the vault
vault_x <- Vault.get_or_create_by_full_path("Vault X")
# Create the folder in the vault
new_folder <- Vault.create_folder(vault_x$id, "/new-folder")

# Query current vault for the specific files
files <- Vault.search(vault_x$id, "xyz", object_type = "file")

# Update parent_object_id in order to move the file to the new folder
for (i in 1:nrow(files)) {
  Object.update(files$id[i], parent_object_id = new_folder$id)
}
```

## Deleting Vaults and Objects

Users can delete any vault or object (file, folder, or dataset) that
they have admin-level permissions on. Deleting a vault or folder will
automatically delete all its contents.

``` r
library(quartzbio.edp)

# Create an empty folder in your personal vault
vault <- Vault()
folder <- Vault.create_folder(vault$id, "/test-delete-folder")

# Create the folder at the root of the vault
Object.delete(folder$id)
```

## API Endpoints

Methods do not accept URL parameters or request bodies unless specified.
Please note that if your EDP endpoint is sponsor.edp.aws.quartz.bio, you
would use sponsor.api.edp.aws.quartz.bio.

### Vaults

| Method | HTTP Request              | Description     | Authorization                    | Response                                       |
|--------|---------------------------|-----------------|----------------------------------|------------------------------------------------|
| create | POST <https://>/v2/vaults | Create a vault. | All users can create new vaults. | The response contains a single Vault resource. |

#### Request Body:

| Property              | Value  | Description                                                        |
|-----------------------|--------|--------------------------------------------------------------------|
| name                  | string | The name of the vault. This must be unique to your account domain. |
| description           | string | (Optional) The description of the vault.                           |
| metadata              | object | (Optional) A dictionary of key/value pairs.                        |
| tags                  | object | (Optional) A list of strings to organize the vault.                |
| default_storage_class | string | (Optional) A list of strings to organize the vault.                |

| Method | HTTP Request             | Description                | Authorization                                                                                                                                                                 | Response                                                             |
|--------|--------------------------|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|
| list   | GET <https://>/v2/vaults | List all available vaults. | All public vaults are included in this response. If the request is sent by an authenticated user, vaults which the user has “read” permission or higher on are also returned. | The response returns a list of vaults matching the provided filters. |

| Method | HTTP Request                  | Description     | Authorization                                                                            | Response                                          |
|--------|-------------------------------|-----------------|------------------------------------------------------------------------------------------|---------------------------------------------------|
| update | PUT <https://>/v2/vaults/{ID} | Update a vault. | This request requires an authorized user with “write” permission or higher on the vault. | The response contains the updated Vault resource. |

### Request Body

In the request body, provide a valid Vault object (see create above).

| Method | HTTP Request                     | Description     | Authorization                                                                  | Response                                            |
|--------|----------------------------------|-----------------|--------------------------------------------------------------------------------|-----------------------------------------------------|
| delete | DELETE <https://>/v2/vaults/{ID} | Delete a vault. | This request requires an authorized user with “admin” permission on the vault. | The response returns “HTTP 200 OK” when successful. |

| Method | HTTP Request                  | Description                  | Authorization                                                                           | Response                                |
|--------|-------------------------------|------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------|
| get    | GET <https://>/v2/vaults/{ID} | Retrieve a vault’s metadata. | This request requires an authorized user with “read” permission or higher on the vault. | The response contains a Vault resource. |
