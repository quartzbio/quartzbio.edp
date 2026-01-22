# N.B: deletion must be tested on its own
test_that_with_edp_api("delete.object", {
  v <- get_test_vault()
  o1 <- Object_create(v$id, "dir1", object_type = "folder")
  o2 <- Object_create(
    v,
    "toto.txt",
    object_type = "file",
    parent_object_id = o1$id
  )

  ####### delete ######
  # delete.Object
  delete(o2)
  expect_error(Object(o2$id), "entity not found")

  # delete.ObjectId
  id <- o1$id
  class(id) <- c("ObjectId", class(id))
  delete(id)
  expect_error(Object(o1$id), "entity not found")
})
#
test_that_with_edp_api("objects", {
  v <- get_test_vault()
  # create a folder
  o1 <- Object_create(v, "dir1", object_type = "folder")

  expect_s3_class(o1, "Folder")
  expect_s3_class(o1, "Object")
  expect_true(is.list(o1))
  expect_identical(o1$filename, "dir1")
  expect_identical(o1$path, "/dir1")
  expect_identical(o1$object_type, "folder")
  expect_equal(o1$depth, 0)
  expect_null(o1$parent_object_id)
  expect_false(o1$has_children)
  expect_false(o1$has_folder_children)
  expect_null(o1$upload_url)

  # create a subfolder
  o2 <- Object_create(
    v,
    "dir2",
    object_type = "folder",
    parent_object_id = o1$id
  )

  expect_s3_class(o2, "Folder")
  expect_identical(o2$path, "/dir1/dir2")
  expect_equal(o2$depth, 1)
  expect_identical(unclass(o2$parent_object_id), o1$id)

  # create a file
  o3 <- Object_create(
    v,
    "toto.txt",
    object_type = "file",
    parent_object_id = o2$id
  )

  expect_s3_class(o3, "File")
  expect_s3_class(o3, "Object")
  expect_identical(o3$filename, "toto.txt")
  expect_identical(o3$path, "/dir1/dir2/toto.txt")
  expect_equal(o3$depth, 2)
  expect_identical(unclass(o3$parent_object_id), o2$id)
  expect_true(nzchar(o3$upload_url))

  # create a Dataset
  o4 <- Object_create(
    v,
    "data.csv",
    object_type = "dataset",
    parent_object_id = o1$id,
    tags = c("quartzbio.edp.objects.hopefully.this.is.unique", "misc")
  )

  expect_s3_class(o4, "Dataset")
  expect_s3_class(o4, "Object")
  expect_identical(o4$filename, "data.csv")
  expect_identical(o4$path, "/dir1/data.csv")
  expect_equal(o4$depth, 1)
  expect_identical(unclass(o4$parent_object_id), o1$id)
  expect_null(o4$upload_url)

  ### Object() with specified conn
  expect_error(Object(o1, conn = list()), "bad connection")
  expect_error(Object("123", conn = list()), "bad connection")

  conn <- get_connection()
  o <- Object(o1, conn = conn)
  expect_identical(o$id, o1$id)

  ### Object()
  # by id
  o <- Object(o1)

  expect_s3_class(o, "Folder")
  expect_identical(o$id, o1$id)
  expect_equal(o$num_children, 2)
  expect_equal(o$num_descendants, 3)

  expect_error(Object("whatever"), "entity not found")

  # by Object
  o1bis <- Object(o1)

  o1bis$updated_at <- o$updated_at
  expect_equal(o1bis, o)

  # by full_path
  o <- Object(full_path = o4$full_path)

  expect_s3_class(o, "Dataset")
  expect_identical(o$id, o4$id)

  # by path
  expect_error(Object(path = "/dir1/dir2/toto.txt"), "all items")
  o <- Object(path = "/dir1/dir2/toto.txt", vault_id = v$id)

  expect_s3_class(o, "File")
  expect_identical(o$id, o3$id)

  # by object_type
  o <- Object(full_path = o1$full_path, object_type = "folder")

  o$updated_at <- o1bis$updated_at
  expect_equal(o, o1bis)

  # no object_type matching
  expect_error(
    Object(full_path = o1$full_path, object_type = "file"),
    "entity not found"
  )

  ### Object_update()
  expect_length(o2$tags, 0)
  Object_update(o2, tags = c("A", "B"))

  o <- Object(o2)
  expect_setequal(o$tags, list("A", "B"))

  ### Objects()
  # by vault_id
  os <- Objects(vault_id = v)

  expect_s3_class(os, "ObjectList")
  expect_type(os, "list")
  expect_length(os, 4)

  # by regex
  os <- Objects(vault_id = v, regex = "/dir2.+")
  expect_length(os, 1)

  # by glob
  os <- Objects(vault_id = v, glob = "/dir1/d*")
  expect_length(os, 2)

  # by tag
  os <- Objects(tag = "quartzbio.edp.objects.hopefully.this.is.unique")

  expect_length(os, 1)
  expect_identical(os[[1]]$id, o4$id)

  ### print.edplist
  lines <- strsplit(capture_output(print(os)), "\n")[[1]]
  expect_match(lines[1], "EDP List")
  expect_gt(length(lines), 4)

  ### print.Object
  lines <- strsplit(capture_output(print(o1)), "\n")[[1]]
  expect_match(lines, "^folder")

  lines <- strsplit(capture_output(print(o4)), "\n")[[1]]
  expect_match(lines, "^dataset")

  ################ ObjectId ############
  id <- o4$id
  class(id) <- c("ObjectId", class(id))

  o <- fetch(id)

  expect_s3_class(o, "Object")
  expect_identical(o$id, o4$id)
})
