## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
withr:::defer({Sys.unsetenv('EDP_PROFILE')}, parent.frame(n=2))

## ----tltr---------------------------------------------------------------------
library(quartzbio.edp)
Sys.getenv('EDP_PROFILE')
Sys.setenv(EDP_PROFILE = 'vsim-dev_rw')
Sys.getenv('EDP_PROFILE')

vlts <- Vaults()
u <- User()
u$first_name
vme <- Vault_create(paste0('vault_', u$first_name))

Vault(id = vme)
Folder_create(vme, 'data/cyto')
Folder_create(vme, 'data/flow')
Folder_create(vme, 'source/code')
Folders(vault_id=vme)

delete(vme)

## ----user---------------------------------------------------------------------
library(quartzbio.edp)
# select an EDP instance using a profile

u <- User()
u$first_name
u$last_name
u$full_name
u$id
u$email
u$account$name
u$url


## ----vaults-0-----------------------------------------------------------------
library(quartzbio.edp)
# select an EDP instance using a profile
Sys.setenv(EDP_PROFILE = 'vsim-dev_rw')
# fetch personnal vault info
myV <- Vault()
# personal vault: user-id
myV$name
myV$full_path 
myV$has_children  
myV$has_folder_children
myV$user$full_name
myV$permissions

## ----vaults-1-----------------------------------------------------------------
# create a vault
v <- Vault_create('vault_test_1', description = 'test_1', tags = list('tag1', 'tag2'))
v$name
v$full_path

# retrieve a vault by name
Vault(name = 'vault_test_1')

# retrieve a vault by full_path
Vault(full_path = v$full_path)

v$description
v$metadata
v$tags

# update metadata
new_name <- 'test_one'
v2 <- Vault_update(v, 
      name = new_name, 
      description = 'barabor', 
      metadata = list(meta_1 = 'foo'), 
      storage_class = 'Performance', tags = 'tag_A')

v3 <- update(v2, storage_class = 'Temporary')


## ----vaults-2-----------------------------------------------------------------
# get the firt two ordered vaults
vs1 <- Vaults(limit = 2, page = 1)

# get the the third and fourth vault
Vaults(limit = 2, page = 2)

# same as above
vs2 <- fetch_next(vs1)
vs2

# fetch all remaining vaults by pages of size 2
all_vlts <- fetch_all(vs1)
all_vlts_df <- as.data.frame(all_vlts)

# delete vault
delete(v)

## ----folders-1----------------------------------------------------------------
# list all folders in an account
all_folders <- Folders()

# get first four
Folders(limit = 4)

# create folder with description and tags
v1 <- Vault_create('_an_upload',  description = 'upload', tags = list('fake', 'can_be_removed'))
fdata <- Folder_create(v1, 'data')
fdata

# CAUTION, no overwritting per default, folders are renamed incrementally
# a new folder data-1 is created
Folder_create(v1, 'data')

# create a hierarchy
Folder_create(v1, 'source/code')

# List folders of a given vault - recursive
Folders(vault_id = v1)

# List folders using regex on paths - recursive
Folders(regex = '^/data')
Folders(regex = 'code$')

# List folders matching paths - recursive
Folders(query = 'code')

# fetch a a folder from a given vault
Folder(vault_id = v1, path = 'data')

# fetch a folder with its full.path
Folder(full_path = fdata$full_path)
delete(v1)

## ----obj-1--------------------------------------------------------------------
irisp <- file.path(tempdir(), 'iris.csv')
write.csv(iris[1:10,], irisp)

v <- Vault_create('_iris_upload',  description = 'upload', 
  tags = list('iris', 'can_be_removed'))

vpath <- 'data/iris/v1/iris_10.csv'

# File upload: folder hierarchy is created on the fly
firis <- File_upload(v, irisp, vpath )
firis$full_path
firis$path
firis$md5

# File download
File_download(firis, file.path(dirname(irisp), 'iris_10_download.csv')) 
dir(dirname(irisp), 'iris')

# fetch a File object
File( full_path = firis$full_path)
firis


## ----jsonl--------------------------------------------------------------------

  # upload jsonl file
irisj <- file.path(tempdir(), "iris.json")

# stream_out function write the JSONL format to a connection
jsonlite:::stream_out(iris[1:15, ], file(irisj))

vpath <- "v1/iris_10.json"
fi2 <- File_upload(v, irisj, vpath)
fi2$path
fi2$mimetype

File_query(fi2)
File_query(fi2, filters = filters("Sepal.Length >= 5"))


## ----obj-2--------------------------------------------------------------------
all_files <- as.data.frame(Files())

Files(limit = 3)

Files(regex = 'TCG*')

Files(regex = 'TCG*')

Files(vault_id = v)


## ----obj-3--------------------------------------------------------------------
# move file from v1/ to v2/
f1 <- Folder_create(vault_id=v, '/data/iris/v2')
firis_v2 <- Object_update(firis, parent_object_id = f1$id)
firis_v2

## ----obj-4--------------------------------------------------------------------
# fetch the two first rows
f2r <- File_query(firis_v2, limit=2)

# fetch the two next ones
fetch_next(f2r)

# fetch row 8
File_query(firis_v2, limit=1,  offset=7)
iris[8,]

# fetch all Setosa 
File_query(firis_v2, filters= filters('Species contains "setosa"'))
File_query(firis_v2, filters= filters('Sepal.Length = 4.7'))

## ----ds-2---------------------------------------------------------------------
iris_2 <- Dataset_create(v, 'iris_2.ds')
iris_2$full_path
iris_2$object_type

import_res <- Dataset_import(iris_2, df = iris[1:12, ], sync = TRUE)
iris_2 <- Dataset(vault_id = v, path = iris_2$path)
i2 <- Dataset_query(iris_2, limit = 1)
fetch_next(i2)


## ----ds-3---------------------------------------------------------------------
genes_1 <- Dataset_create(v, 'genes.ds', 
  description = "genes hits",
  metadata = list(DEV = TRUE), 
  tags = list("QBP", "EDP"), 
  storage_class = "Temporary", capacity = "small")

records <- list(
  list(gene = "CFTR", importance = 1, sample_count = 2104),
  list(gene = "BRCA2", importance = 1, sample_count = 1391),
  list(gene = "CLIC2", importance = 5, sample_count = 14)
)

import_res <- Dataset_import(genes_1, records = records, sync = TRUE)
g1 <- Dataset_query(genes_1, limit = 1)
g1
fetch_all(g1)
Dataset_query(genes_1, filters = filters('sample_count <= 14'))


## ----ds-4---------------------------------------------------------------------
nobs <- Dataset_create(v, 'dna_gurus.ds')
authors <- list(
    list(name='Francis Crick'),
    list(name='James Watson'),
    list(name='Rosalind Franklin')
)
# additional firt and last name fields to be created
target_fields <- list(
  list(
    name="first_name",
    description="Adds a first name column based on name column",
    data_type="string",
    expression="record.name.split(' ')[0]"
  ),
  list(
    name="last_name",
    description="Adds a last name column based on name column",
    data_type="string",
    expression="record.name.split(' ')[-1]"
  )
)
res <- Dataset_import(nobs, records = authors, 
  target_fields = target_fields, 
  sync = TRUE)
Dataset_query(nobs)

## ----ds-5---------------------------------------------------------------------
# fetch the first row
f1r_ds <- Dataset_query(iris_2, limit=1)

fetch_next(f1r_ds)

fetch_all(f1r_ds)

# Filters acts on column fields that matches the data.frame import.
Dataset_query(iris_2, filters= filters('Species contains "setosa"'))

Dataset_query(iris_2, filters= filters('Sepal.Length >= 5.1'))

Dataset_query(iris_2, filters= filters('(Sepal.Length >= 5.1) OR  (Sepal.Width <= 3.0)'))

# Keep fields
Dataset_query(iris_2, 
  fields = c('Petal.Width', 'Species'),
  filters= filters('(Sepal.Length >= 5.1) OR  (Sepal.Width <= 3.0)'))

# Exclude fields
Dataset_query(iris_2, 
  exclude_fields = c('Petal.Width', 'Species'),
  filters= filters('(Sepal.Length >= 5.1) OR  (Sepal.Width <= 3.0)'))

# Ordering
Dataset_query(iris_2, 
   ordering = 'Sepal.Length')

delete(v)

