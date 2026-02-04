#!/usr/bin/env Rscript

# Convert R coverage from covr package to SonarQube Generic Coverage XML format
# This script generates coverage.xml in the format expected by SonarQube for R code

library(covr)
library(xml2)

cat("Generating coverage data...\n")
cov <- covr::package_coverage()

cat("Converting to SonarQube Generic Coverage XML format...\n")

# Create root coverage element
coverage_xml <- xml_new_document()
root <- xml_add_child(coverage_xml, "coverage")
xml_set_attr(root, "version", "1")

# Extract coverage data into a data frame for easier processing
cov_df <- as.data.frame(cov)

# Get unique files
unique_files <- unique(cov_df$filename)

# Process each file
for (file_path in unique_files) {
  # Get coverage for this file
  file_data <- cov_df[cov_df$filename == file_path, ]

  # Skip if no coverage data
  if (nrow(file_data) == 0) {
    next
  }

  # Create file element
  file_elem <- xml_add_child(root, "file")
  xml_set_attr(file_elem, "path", file_path)

  # Add coverage for each line
  for (i in seq_len(nrow(file_data))) {
    line_num <- file_data$first_line[i]
    hit_count <- file_data$value[i]

    # Add line to cover element
    line_elem <- xml_add_child(file_elem, "lineToCover")
    xml_set_attr(line_elem, "lineNumber", as.character(line_num))
    xml_set_attr(line_elem, "covered", if (hit_count > 0) "true" else "false")
  }
}

# Write to file
write_xml(coverage_xml, "coverage.xml")
cat("SonarQube Generic Coverage XML written to coverage.xml\n")

# Print summary
total_lines <- nrow(cov_df)
covered_lines <- sum(cov_df$value > 0)
coverage_pct <- if (total_lines > 0) round(100 * covered_lines / total_lines, 2) else 0
cat(sprintf("Coverage summary: %d/%d lines covered (%.2f%%)\n", covered_lines, total_lines, coverage_pct))
