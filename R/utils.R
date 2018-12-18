#' Set your EvaluationKit API Token
#'
#' @param token Your EvaluationKit API Token
#'
#' @return NULL
#' @export
#'
#' @examples
#'\dontrun{
#' ek_set_token("YOUR_TOKEN")
#'}
ek_set_token <- function(token) {
  Sys.setenv(EK_API_TOKEN = token)
}

#' Set your EvaluationKit Domain
#'
#' @param domain Your EvaluationKit domain
#'
#' @return NULL
#' @export
#'
#' @examples
#'\dontrun{
#' ek_set_domain("YOUR_DOMAIN")
#'}
ek_set_domain <- function(domain) {
  Sys.setenv(EK_DOMAIN = domain)
}

ek_domain <- function() paste0(Sys.getenv("EK_DOMAIN"), "/api")

check_token <- function() {
  token <- Sys.getenv("EK_API_TOKEN")
  if (identical(token, "")) {
    stop("Please set env var EK_API_TOKEN to your access token.",
         call. = FALSE)
  }
  token
}

ek_query <- function(urlx, type = "GET") {
  fun <- getFromNamespace(type, "httr")
  resp <- fun(urlx,
              httr::user_agent("rEvalKit - https://github.com/daranzolin/rEvalKit"),
              httr::add_headers(AuthToken = check_token())
              )
  httr::stop_for_status(resp)
  return(resp)
}

ek_paginate <- function(base_urls) {
  response_list <- list()
  for (i in seq_along(base_urls)) {
    rx <- ek_query(base_urls[i])
    rx <- ek_process_response(rx)
    if (length(rx$resultList) == 0) break
    response_list[[i]] <- rx$resultList
    }
  if (length(response_list) == 0) stop("No data returned.", call. = FALSE)
  dplyr::bind_rows(response_list)
}

ek_process_response <- function(response) {
  httr::content(response, "text") %>%
    jsonlite::fromJSON()
}

sc <- function(x) {
  Filter(Negate(is.null), x)
}
