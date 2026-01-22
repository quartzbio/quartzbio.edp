test_that_with_edp_api("user", {
  res <- User()

  expect_true(all(
    c("class_name", "full_name", "id", "username") %in% names(res)
  ))
  expect_true(nzchar(res$full_name))
  expect_identical(class(res), c("User", "list"))

  ### print
  lines <- strsplit(capture_output(print(res)), "\n")[[1]]
  expect_match(lines[1], "EDP user")

  ### fetch_vaults.Vault
  vs <- fetch_vaults(res)

  expect_s3_class(vs, "VaultList")
  expect_gt(length(vs), 0)

  ### fetch_vaults.VaultId
  id <- res$id
  class(id) <- c("UserId", class(id))

  vs2 <- fetch_vaults(id)

  expect_equal(vs2, vs)
})
