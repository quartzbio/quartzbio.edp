# Dataset versioning via API

## Dataset Activity

Dataset activity includes any operation that imports, transforms,
exports, or copies dataset data. Users can view a dataset’s activity via
the API or in the EDP UI by visiting the Activity tab of a dataset.

### Example: Check for any Activity

This example is a fast way to check for any activity on a dataset.

``` r
status <- paste("running", "queued", "pending", sep = ",")
tasks <- Task.all(target_object_id = "<DATASET ID>", status = status, limit = 1)$total
if (tasks) {
  # Active tasks
} else {
  # Dataset is idle
}
```

### Example: Wait for an Idle Dataset

Some use cases may require waiting until a dataset is idle. A dataset is
idle when there are no longer any task operations that are queued,
pending, or running.

This can be done synchronously using the follow parameter. This
parameter continually loops through all dataset activity until the
dataset is idle.

The function sleeps for 3 seconds in between each check for activity.

``` r
Dataset.activity("<DATASET ID>", follow = TRUE)
```

## Reverting Datasets

### Overview

Dataset commits are the backbone of EDP’s datastore and represent a
change log of modifications to a dataset. A dataset commit represents
all changes made to the target dataset by the import/migration/delete
process.

All of these changes can be reverted by creating a rollback commit. All
commits can be reverted. A rollback commit will restore the dataset to
its state before the commit was made.

The parent commit of a rollback commit is the commit to be reverted.

### Rollbacks

A rollback commit represents a revert of a commit. The rollback commit
will do different things depending on the mode of the parent commit. It
may delete records, index a rollback file, or both.

A rollback file is generated for overwrite, upsert, and delete modes.
This file is generated right before records are committed, by querying
the current state of the dataset and storing those records in a file.
This file is stored with the commit object and used when creating a
rollback commit.

| Commit Mode | Description                                                                                    |
|-------------|------------------------------------------------------------------------------------------------|
| append      | Reverts by deleting all records containing parent \_commit ID                                  |
| delete      | Reverts by indexing the records deleted (stored in the rollback file)                          |
| overwrite   | Reverts by deleting all records containing parent \_commit ID. Then indexing the rollback file |
| upsert      | Same as overwriting commit mode                                                                |

### Checking the Ability to Rollback

In order for a commit to be reverted, there must be a clear “commit”
stack on the dataset. Commits with mode overwrite or upsert will block
reverts and must be reverted first. When creating a rollback, if there
are blocking commits, the endpoint will fail and return these blocking
commit values.

#### Example

Imagine a simple dataset containing employee names and employee
addresses. This is maintained by an annual import of employees with
address changes (including new employees.) Over the course of a few
years, several employees move addresses. Several employees join the
company, and some leave as well.

- Commit A (Import 2015 address file in overwrite mode)
- Commit B (Import 2016 address file in overwrite mode)
- Commit C (Import 2017 address file in overwrite mode)
- Commit D (Import 2018 address file in overwrite mode)

Let’s do a simple case first, where nobody actually moves addresses, and
therefore only new employees are added.

If a user were to revert Commit C, then they would only remove new 2017
employees from the dataset. The 2015, 2016, and 2018 employees all
remain.

Now let’s assume people do move and so each year we have all sorts of
address changes.

If users were to revert Commit C, then the dataset would be restored to
the known state that it was in Commit B. It would only reset the 2017
addresses to 2016 addresses for people that did not also change in 2018.
It would also leave any new employees added in 2018. This is an
inconsistent state and not a valid snapshot of the dataset at the time
Commit C was indexed. Therefore this is not allowed and attempts to
rollback will fail. Commit D must be reverted first.

### Archiving Datasets

#### Overview

Archiving gives users the ability to safely store the datasets that they
do not use frequently, without consuming their organization’s active
storage space quota. When users decide that they want to use the dataset
again, they can quickly and easily restore it. Depending on the storage
class used, a dataset may be archived automatically.

#### Permissions

A user must have `write` permissions on the vault in order to archive or
restore a dataset.

#### Querying

Archived datasets currently cannot be queried and will raise an error if
a query is attempted. Users can check if a dataset is archived by
checking its `availability` parameter. The value will be `available`,
`unavailable`, or `archived`.

#### Examples

Users can easily archive and restore a dataset through the UI or through
the API.

#### Archiving

A Dataset can be archived by changing the storage class to “Archive”
within the R client.

``` r
require(quartzbio.edp)

# Set storage class to archive
Object_update("DATASET ID", storage_class = "Archive")
```

#### Restore

Restoring the archived dataset can be done by changing the storage class
to “Standard” within the R client.

``` r
require(quartzbio.edp)

# Restore the dataset by setting the storage class to standard
Object_update("DATASET ID", storage_class = "Standard")
```

#### Switching the Storage Class

Storage classes can be modified from the R client as follows:

``` r
require(quartzbio.edp)

# Set storage class to archive
Object_update("DATASET ID", storage_class = "Archive")

# Set the storage class to essential
Object_update("DATASET ID", storage_class = "Essential")
```

#### Supporting Archived Datasets

After the introduction of dataset archiving & restoring and of dataset
storage classes (December 2020), a dataset may now be in an unavailable
state. Scripts and apps must now check for this state before querying or
explicitly handling query failures. Both the Dataset and the Object
resources now contain the “availability” parameter which returns
“available”, “unavailable”, “restoring” or “archived” for a dataset.

See examples below:

``` r
# Explicitly check availability
dataset <- Dataset.get_by_full_path("quartzbio:public:/ClinVar/3.7.4-2017-01-30/Variants-GRCh37")
if (dataset$availability != "available") {
  print(paste("Not querying dataset", dataset$id, " with availability:", dataset$availability))
}

# Catch errors
tryCatch(
  print(Dataset.query(id = dataset$id, limit = 10, paginate = TRUE)),
  error = function() {
    print(paste(
      "Unable to query: Dataset", dataset$id, "availability is",
      dataset$availability
    ))
  }
)
```

## API Endpoints

Methods do not accept URL parameters or request bodies unless specified.
Please note that if your EDP endpoint is sponsor.edp.aws.quartz.bio, you
would use sponsor.api.edp.aws.quartz.bio.

### Dataset Commits

Dataset commits cannot be directly created. Commits are generated only
from dataset imports.

| Method |                      HTTP Request                       |                                              Description                                              |                                  Authorization                                  |                      Response                       |
|:------:|:-------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------:|:---------------------------------------------------:|
| delete | DELETE `https://<EDP_API_HOST>/v2/dataset_commits/{ID}` | Delete a dataset commit. Deleting dataset commits is not recommended as data provenance will be lost. | This request requires an authorized user with write permissions on the dataset. | The response returns “HTTP 200 OK” when successful. |

| Method |                     HTTP Request                     |                Description                |                       Authorization                       |                    Response                     |     |
|:------:|:----------------------------------------------------:|:-----------------------------------------:|:---------------------------------------------------------:|:-----------------------------------------------:|-----|
|  get   | GET `https://<EDP_API_HOST>/v2/dataset_commits/{ID}` | Retrieve metadata about a dataset commit. | This request requires an authorized user with permission. | The response contains a DatasetCommit resource. |     |

| Method |                         HTTP Request                          |                          Description                          |                                 Authorization                                 |                         Response                         |
|:------:|:-------------------------------------------------------------:|:-------------------------------------------------------------:|:-----------------------------------------------------------------------------:|:--------------------------------------------------------:|
|  list  | GET `https://<EDP_API_HOST>/v2/datasets/{DATASET_ID}/commits` | Retrieve a list of dataset commits associated with a dataset. | This request requires an authorized user with read permission on the dataset. | The response contains a list of DatasetCommit resources. |

|    Method     |                         HTTP Request                          |                                                    Description                                                     |                                  Authorization                                  |                                                                            Response                                                                             |
|:-------------:|:-------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| revert status | GET `https://<EDP_API_HOST>/v2/dataset_commits/{ID}/rollback` | Returns whether or not a commit can be reverted and returns a reason why along with any commits that are blocking. | This request requires an authorized user with write permissions on the dataset. | Returns a boolean is_blocked and a detail string explaining why. If there are blocking commits blocking_commits will contain a list of DatasetCommit resources. |

| Method |                          HTTP Request                          |                    Description                    |                                 Authorization                                  |                                                                                  Response                                                                                  |
|:------:|:--------------------------------------------------------------:|:-------------------------------------------------:|:------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| revert | POST `https://<EDP_API_HOST>/v2/dataset_commits/{ID}/rollback` | Revert a completed commit by creating a rollback. | This request requires an authorized user with write permission on the dataset. | If a rollback cannot be created, the status code will be 400 Bad Request. Otherwise, the response will contain a DatasetCommit resource, representing the rollback commit. |

| Method |                         HTTP Request                         |       Description        |                                 Authorization                                 |                                   Response                                   |
|:------:|:------------------------------------------------------------:|:------------------------:|:-----------------------------------------------------------------------------:|:----------------------------------------------------------------------------:|
| cancel | PUT `https://<EDP_API_HOST>/v2/datasets_commits/{ID}/cancel` | Cancel a dataset commit. | This request requires an authorized user with read permission on the dataset. | The response will contain a DatasetCommit resource with the status canceled. |

Request Body: In the request body, provide a valid DatasetCommit object
with status = canceled.

### Dataset Restore Tasks

| Method |                              HTTP Request                               |                   Description                   |                                    Authorization                                    |                       Response                       |
|:------:|:-----------------------------------------------------------------------:|:-----------------------------------------------:|:-----------------------------------------------------------------------------------:|:----------------------------------------------------:|
|  get   | GET `https://<EDP_API_HOST>/v2/dataset_restore_tasks/{RESTORE_TASK_ID}` | Retrieve metadata about a dataset restore task. | This request requires an authorized user with read permission for the restore task. | The response contains a DatasetRestoreTask resource. |

| Method |                     HTTP Request                      |                     Description                     |                                    Authorization                                     |                           Response                            |
|:------:|:-----------------------------------------------------:|:---------------------------------------------------:|:------------------------------------------------------------------------------------:|:-------------------------------------------------------------:|
|  list  | GET `https://<EDP_API_HOST>/v2/dataset_restore_tasks` | Retrieve a list of available dataset restore tasks. | This request requires an authorized user with read permission for the restore tasks. | The response contains a list of DatasetRestoreTask resources. |

### Dataset Snapshot Tasks

Dataset snapshot tasks can not be created directly. They are created
when a dataset’s storage class is set to Archive.

| Method |                               HTTP Request                                |                   Description                    |                                    Authorization                                     |                       Response                        |
|:------:|:-------------------------------------------------------------------------:|:------------------------------------------------:|:------------------------------------------------------------------------------------:|:-----------------------------------------------------:|
|  get   | GET `https://<EDP_API_HOST>/v2/dataset_snapshot_tasks/{SNAPSHOT_TASK_ID}` | Retrieve metadata about a dataset snapshot task. | This request requires an authorized user with read permission for the snapshot task. | The response contains a DatasetSnapshotTask resource. |

| Method |                      HTTP Request                      |                     Description                      |                                     Authorization                                     |                            Response                            |
|:------:|:------------------------------------------------------:|:----------------------------------------------------:|:-------------------------------------------------------------------------------------:|:--------------------------------------------------------------:|
|  list  | GET `https://<EDP_API_HOST>/v2/dataset_snapshot_tasks` | Retrieve a list of available dataset snapshot tasks. | This request requires an authorized user with read permission for the snapshot tasks. | The response contains a list of DatasetSnapshotTask resources. |
