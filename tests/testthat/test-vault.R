# delete a vault by name if if exists
..delete_vault_by_name <- function(name) {
  try(
    {
      v <- Vault(name = name)
      if (length(v)) delete(v)
    },
    silent = TRUE
  )
}

test_that_with_edp_api("vaultlist_methods", {
  ### as.data.frame
  vs <- Vaults(limit = 2)

  df <- as.data.frame(vs)

  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), length(vs))
  expect_identical(names(df), names(vs[[1]]))

  ### fetch_next
  vs1 <- Vaults(limit = 1, page = 1)

  vs2 <- fetch_next(vs1)

  expect_s3_class(vs2, "VaultList")
  expect_length(vs2, 1)
  expect_true(vs2[[1]]$id != vs1[[1]]$id)

  ### fetch_prev
  vs1bis <- fetch_prev(vs2)

  expect_equal(vs1bis, vs1)

  expect_null(fetch_prev(vs1bis))
})



test_that_with_edp_api("fetch", {
  v <- get_test_vault()

  # fetch.Vault
  v2 <- fetch(v)
  expect_equal(v2, v)

  # fetch.VaultId
  vault_id <- v$id
  class(vault_id) <- "VaultId"

  v3 <- fetch(vault_id)
  expect_equal(v3, v)
})



test_that_with_edp_api("delete", {
  vault <- .vault_name("delete_tmp")

  ### delete
  v <- Vault_create(vault)
  expect_error(delete(v), NA)
  expect_error(Vault(id = v$id), "entity not found")

  ### delete with id
  v <- Vault_create(vault)
  vault_id <- v$id
  class(vault_id) <- "VaultId"

  expect_error(delete(vault_id), NA)
  expect_error(Vault(id = vault_id), "entity not found")
})



test_that_with_edp_api("update", {
  v <- get_test_vault()

  ### Vault_update
  name <- paste0(v$name, "toto")
  v2 <- Vault_update(v,
    name = name, description = "desc",
    metadata = list(meta1 = "toto"), storage_class = "Performance", tags = "A"
  )

  expect_identical(v2$name, name)
  expect_identical(v2$description, "desc")
  expect_identical(v2$default_storage_class, "Performance")
  # N.B: tags are overwritten
  expect_identical(v2$tags, list("A"))
  expect_identical(v2$metadata, list(meta1 = "toto"))

  # update.Vault
  name <- paste0(v$name, "titi")
  v3 <- update(v2, name = name, storage_class = "Temporary")

  expect_identical(v3$name, name)
  expect_identical(v3$default_storage_class, "Temporary")

  # update.VaultId
  vid <- v$id
  class(vid) <- "VaultId"

  v4 <- update(vid, tags = LETTERS[1:5])
  expect_identical(sort(as.character(v4$tags)), LETTERS[1:5])
})



test_that_with_edp_api("print", {
  ### print.Vaults
  vs <- Vaults(limit = 2)

  lines <- strsplit(capture_output(print(vs)), "\n")[[1]]
  expect_match(lines[1], "List of \\d+ Vaults")
  expect_gt(length(lines), 2)

  ### print.Vault
  v <- get_test_vault()

  expect_output(print(v), "^Vault")
  expect_output(print(v), v$name)
})



test_that_with_edp_api("vaults", {
  # create some vaults
  NAMES <- paste0("qb.edp.", LETTERS[1:3])
  .cleanup <- function() {
    for (name in NAMES) ..delete_vault_by_name(name)
  }
  .cleanup()

  VS <- list(
    Vault_create(NAMES[1], tags = c("A", "TEMP", "QBTEST"), storage_class = "Temporary"),
    Vault_create(NAMES[2], tags = c("B", "PROD", "QBTEST")),
    Vault_create(NAMES[3], tags = c("C", "TEMP", "QBTEST"), storage_class = "Temporary")
  )
  on.exit(.cleanup(), add = TRUE)

  ### by tags
  vs <- Vaults(tags = "QBTEST")

  expect_s3_class(vs, "VaultList")
  expect_type(vs, "list")
  expect_length(vs, 3)
  # attributes
  expect_equal(attr(vs, "total"), 3)
  expect_true(nzchar(attr(vs, "url")))

  expect_equal(attr(vs, "connection"), as.environment(get_connection(auto = FALSE)))
  links <- attr(vs, "links")
  expect_equal(links, list(`next` = NULL, prev = NULL))
  # items
  expect_s3_class(vs[[1]], "Vault")

  ### all + limit
  vs <- Vaults(limit = 2)

  expect_s3_class(vs, "VaultList")
  expect_length(vs, 2)
  expect_gt(attr(vs, "total"), 2)
  links <- attr(vs, "links")
  expect_true(nzchar(links$`next`))
  expect_null(links$prev)

  ## + page
  vs2 <- Vaults(limit = 2, page = 2)

  expect_false(vs2[[1]]$id %in% c(vs[[1]]$id, vs[[2]]$id))
  expect_s3_class(vs, "VaultList")

  ### by user_id
  vs <- Vaults(user_id = VS[[1]]$user_id, limit = 1, page = 2)

  expect_length(vs, 1)
  expect_identical(vs[[1]]$user_id, VS[[1]]$user_id)
  expect_gt(attr(vs, "total"), 2)
  links <- attr(vs, "links")
  expect_true(nzchar(links$`next`))
  expect_true(nzchar(links$`prev`))


  ### by account_id
  vs <- Vaults(account_id = VS[[1]]$account_id, limit = 1)
  expect_length(vs, 1)

  # improbable account id
  vs <- Vaults(account_id = -1, limit = 1)
  expect_length(vs, 0)

  ### by storage_class and tags
  vs <- Vaults(storage_class = "Temporary", tags = "QBTEST")
  expect_length(vs, 2)

  ### by vault_type
  vs <- Vaults(user_id = VS[[1]]$user_id, vault_type = "user")

  expect_length(vs, 1)
  expect_identical(vs[[1]]$user_id, VS[[1]]$user_id)
  expect_identical(vs[[1]]$vault_type, "user")
})
