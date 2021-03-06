col_analysis <- function(tidy_df, column_name){
  #tidy_df is a tibble returned by set_separator()
  current_col <- tidy_df[[column_name]]
  sep <- attr(current_col, "sep")
  if (sep=="" || is.null(sep)){
    sep <- ";"
  }
  split_col <- stringr::str_split(current_col, sep)
  values <- unlist(split_col)
  values[which(values=="")] <- NA
  total_values <- length(values[!is.na(values)])
  freq_frame <- tibble::as_tibble(as.data.frame(table(values)))
  final_freq_frame <- dplyr::mutate(freq_frame, `Fractional Freq (in %)`=100*(Freq/total_values))
  entries_per_row <- unlist(lapply(split_col, function(x){length(x[!is.na(x)])}))
  ordered_freq_frame <- final_freq_frame[order(-final_freq_frame$Freq),] #First entry of output
  row_analysis <- data.frame(row_numbers=1:length(current_col), entries_per=entries_per_row) 
  row_frame <- tibble::as_tibble(row_analysis[order(-row_analysis$entries_per),])
  colnames(row_frame) <- c("Row number", "Entries per Row")
  return(list(ordered_freq_frame, row_frame))
}
