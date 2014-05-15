# I/O helper functions

#' Add \code{ext}ension parameter to \link{\code{base::file.path}}
file.path <- function (..., ext = NULL, fsep = .Platform$file.sep) {
    dots <- list(...)
    if (! is.null(ext)) {
        ilast <- length(dots)
        dots[ilast] <- sprintf('%s.%s', dots[ilast], sub('^\\.', '', ext))
    }

    do.call(base::file.path, c(dots, fsep = fsep))
}

#' Augment \code{\link{utils::read.table}} by a mechanism to guess the file format.
#'
#' For the moment, only separators are handled based on the file extension.
#' This might change in the future to be more powerful, think Python’s
#' \code{csv.Sniffer} class.
read.table <- function (file, ..., text) {
    args <- list(...)
    if (missing(file))
        return(do.call(utils::read.table, c(args, text = text)))

    if (! ('sep' %in% names(args))) {
        separators <- list('.csv' = ',',
                           '.tsv' = '\t')
        extension <- rxmatch('\\.(\\w+)$', file)
        args$sep <- separators[[extension]]
    }

    args$file <- file
    do.call(utils::read.table, args)
}
