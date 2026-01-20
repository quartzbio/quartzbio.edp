test_that_with_edp_api("Shortcut_create", {
  v <- get_test_vault()

  sc <- Shortcut_create(v, "test", target = list(object_type = "url", url = "url"))
  expect_s3_class(sc, c("Object", "Shortcut"))
})

test_that("Shortcut_create rejects bad target", {
  expect_error(Shortcut_create("id", "path", target = 42))
  expect_error(Shortcut_create("id", "path", target = list()))
  expect_error(Shortcut_create("id", "path", target = list(object_type = "url", id = "123")))
  expect_error(Shortcut_create("id", "path", target = list(object_type = "file", url = "123")))
  expect_error(Shortcut_create("id", "path", target = list(object_type = "file", id = "123", bad_item = "123")))
  expect_error(Shortcut_create("id", "path", target = list(object_type = "filez", id = "123")))
})

test_that_with_edp_api("Shortcut", {
  v <- get_test_vault()

  sc <- Shortcut_create(v, "test", target = list(object_type = "url", url = "url"))

  returned_sc <- Shortcut(sc$id)
  expect_identical(returned_sc$id, sc$id)
  expect_identical(returned_sc$full_path, sc$full_path)
  expect_s3_class(returned_sc, c("Object", "Shortcut"))
})

test_that_with_edp_api("Shortcuts", {
  v <- get_test_vault()

  sc1 <- Shortcut_create(v, "test", target = list(object_type = "url", url = "url"))
  sc1 <- Shortcut_create(v, "test/two", target = list(object_type = "url", url = "url"))

  returned_scs <- Shortcuts(v)

  expect_s3_class(returned_scs, "ObjectList")
  expect_no_error(
    lapply(returned_scs, expect_s3_class, class = "Shortcut")
  )
  expect_length(returned_scs, 2)
})

test_that_with_edp_api("is_shortcut_works", {
  v <- get_test_vault()

  sc <- Shortcut_create(v, "test", target = list(object_type = "url", url = "url"))
  fo <- Folder_create(v, "test_folder")

  expect_true(is_shortcut(sc))
  expect_false(is_shortcut(fo))
})

test_that_with_edp_api("Shortcut_get_target", {
  v <- get_test_vault()
  # shortcuts cannot be within the same vault hence 2 vaults
  v2 <- Vault(name = .vault_name("vault2"))

  fo <- Folder_create(v2, "test_folder")
  sc_fo <- Shortcut_create(v, "test", target = list(object_type = "folder", id = fo$id))
  sc_vault <- Shortcut_create(v, "test/vault", target = list(object_type = "vault", id = v2$id))

  resolved_sc_fo <- Shortcut_get_target(sc_fo)

  expect_s3_class(resolved_sc_fo, class(fo))
  expect_identical(resolved_sc_fo$id, fo$id)
  expect_identical(resolved_sc_fo$full_path, fo$full_path)

  resolved_sc_vault <- Shortcut_get_target(sc_vault)

  expect_s3_class(resolved_sc_vault, class(v2))
  expect_identical(resolved_sc_vault$id, v2$id)
  expect_identical(resolved_sc_vault$full_path, v2$full_path)
})

test_that("Shortcut_get_target fails if target not found", {
  sc <- list(object_type = "shortcut", target = list())

  expect_null(Shortcut_get_target(sc, allow_null_target = TRUE))
  expect_error(Shortcut_get_target(sc, allow_null_target = FALSE))
})
