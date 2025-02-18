# N.B: tested with File_upload. here we only test edge cases
test_that("folder_fetch_or_create", {
  Folder_fetch_or_create <- quartzbio.edp:::Folder_fetch_or_create

  expect_null(Folder_fetch_or_create(path = "/"))
})


test_that_with_edp_api("folder_create", {
  v <- get_test_vault()

  f1 <- Folder_create(v, "d1")

  # N.B: I use the object in place of the ID
  fo <- Folder(f1)
  expect_identical(fo$id, f1$id)
  expect_identical(fo$object_type, "folder")
  expect_identical(fo$path, "/d1")

  ###
  # N.B: I use the objects in place of the IDs
  f2 <- Folder_create(v, "d2", parent_folder_id = f1)

  fo <- Folder(f2)
  expect_identical(fo$id, f2$id)
  expect_identical(fo$object_type, "folder")
  expect_identical(fo$path, "/d1/d2")

  ### recursive
  f5 <- Folder_create(v, "/d1/d2/d3/d4/d5")

  fo <- Folder(f5)
  expect_identical(fo$id, f5$id)
  expect_identical(fo$object_type, "folder")
  expect_identical(fo$path, "/d1/d2/d3/d4/d5")

  ### Folders
  fos <- Folders(v)

  expect_s3_class(fos, "ObjectList")
  expect_length(fos, 5)

  ### fetch folder by path
  fo <- Folder(path = "d1/d2/d3/d4/d5", vault_id = v)
  expect_equal(fo, f5)

  # non existent
  expect_error(Folder("does_not_exist"), "entity not found")
  expect_error(Folder(full_path = "does/not/exist"), "entity not found")

  ### create if the folder already exists...
  Folder_fetch_or_create <- quartzbio.edp:::Folder_fetch_or_create

  fo <- Folder_fetch_or_create(v, "/d1/d2/N3/N4")

  expect_identical(fo$path, "/d1/d2/N3/N4")
  fobis <- Folder_fetch_or_create(v, "/d1/d2/N3/N4")
  expect_identical(fobis$id, fo$id)
})
