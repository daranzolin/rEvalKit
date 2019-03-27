#' Get survey object
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_surveys()
#'}
ek_surveys <- function() {
  BASE_URLs <- glue::glue("{domain}/surveys?page={page}",
                         domain = ek_domain(),
                         page = 1:100)
  ek_paginate(BASE_URLs)
}

#' Get accounts
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_accounts()
#'}
ek_accounts <- function() {
  BASE_URLs <- glue::glue("{domain}/accounts",
                         domain = ek_domain())
  ek_paginate(BASE_URLs)
}

#' Get terms
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_terms()
#'}
ek_terms <- function() {
  BASE_URLs <- glue::glue("{domain}/terms?page={page}",
                         domain = ek_domain(),
                         page = 1:100)
  ek_paginate(BASE_URLs)
}

#' Get survey questions
#'
#' @param surveyId a valid survey id
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_survey_questions(surveyId = 132498)
#'}
ek_survey_questions <- function(surveyId) {
  stopifnot(!is.null(surveyId))
  BASE_URLs <- glue::glue("{domain}/surveys/{surveyId}/Questions?page={page}",
                         domain = ek_domain(),
                         surveyId = surveyId,
                         page = 1:100)
  ek_paginate(BASE_URLs)
}

#' Get projects
#'
#' @param projectType integer, 1 = Course; 2 = General
#' @param projectStatus integer, 1 = Not-Deployed; 2 = Deployed-NotStarted; 3 = In-Progress; 4 = Ended
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_projects()
#'}
ek_projects <- function(projectType = 1, projectStatus = 4) {
  BASE_URLs <- glue::glue("{domain}/projects?page={page}&projectType={projectType}&projectStatus={projectStatus}",
                          domain = ek_domain(),
                          page = 1:100,
                          projectType = projectType,
                          projectStatus = projectStatus)
  ek_paginate(BASE_URLs)
}

#' Get all courses
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_courses()
#'}
ek_courses <- function() {
  BASE_URLs <- glue::glue("{domain}/courses?page={page}",
                          domain = ek_domain(),
                          page = 1:100)
  ek_paginate(BASE_URLs)
}

#' Get account users
#'
#' @param username optional username
#' @param userTypes CSV of user types. Example: 1,2 returns all EK Administrators and Node Administrators
#' @param includeSubaccounts boolean
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_users()
#'}
ek_users <- function(username = NULL, userTypes = NULL, includeSubaccounts = FALSE) {
  if (!is.null(username) && !is.null(userTypes)) {
    BASE_URLs <- glue::glue("{domain}/users?userTypes={userTypes}&username={username}&includeSubaccounts={includeSubaccounts}&page={page}",
                            domain = ek_domain(),
                            username = username,
                            userTypes = userTypes,
                            includeSubaccounts = includeSubaccounts,
                            page = 1:100)
  } else if (is.null(username) && !is.null(userTypes)) {
    BASE_URLs <- glue::glue("{domain}/users?userTypes={userTypes}&includeSubaccounts={includeSubaccounts}&page={page}",
                            domain = ek_domain(),
                            username = username,
                            userTypes = userTypes,
                            includeSubaccounts = includeSubaccounts,
                            page = 1:100)
  } else if (!is.null(username) && is.null(userTypes)) {
    BASE_URLs <- glue::glue("{domain}/users?username={username}&includeSubaccounts={includeSubaccounts}&page={page}",
                            domain = ek_domain(),
                            username = username,
                            userTypes = userTypes,
                            includeSubaccounts = includeSubaccounts,
                            page = 1:100)
  } else {
    BASE_URLs <- glue::glue("{domain}/users?includeSubaccounts={includeSubaccounts}&page={page}",
                            domain = ek_domain(),
                            username = username,
                            userTypes = userTypes,
                            includeSubaccounts = includeSubaccounts,
                            page = 1:100)
  }
  ek_paginate(BASE_URLs)
}

#' Get project courses
#'
#' @param projectId a valid project id
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_project_courses(48923)
#'}
ek_project_courses <- function(projectId) {
  BASE_URLs <- glue::glue("{domain}/projects/{projectId}/courses?page={page}",
                          domain = ek_domain(),
                          projectId = projectId,
                          page = 1:100)
  courses <- ek_paginate(BASE_URLs)
  courses$projectId = projectId
  dplyr::select(courses, projectId, everything())
}

#' Get project users
#'
#' @param projectId a valid project id
#' @param courseId a valid course id
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_project_users(98423, courseId = 43423)
#'}
ek_project_users <- function(projectId, courseId) {
  BASE_URLs <- glue::glue("{domain}/projects/{projectId}/courses/{courseId}/users?page={page}",
                          domain = ek_domain(),
                          projectId = projectId,
                          courseId = courseId,
                          userType = userType,
                          page = 1:100)
  project_users <- ek_paginate(BASE_URLs)
  project_users$projectId <- projectId
  project_users$courseId <- courseId
  project_users
}

#' Get project respondents
#'
#' @param projectId a valid project id
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_project_respondents(94832)
#'}
ek_project_respondents <- function(projectId) {
  BASE_URLs <- glue::glue("{domain}/projects/{projectId}/respondents?page={page}",
                          domain = ek_domain(),
                          projectId = projectId,
                          page = 1:100)
  ek_paginate(BASE_URLs)
}

#' Get project nonrespondents
#'
#' @param projectId a valid project id
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_project_nonrespondents(98233)
#'}
ek_project_nonrespondents <- function(projectId) {
  BASE_URLs <- glue::glue("{domain}/projects/{projectId}/nonRespondents?page={page}",
                          domain = ek_domain(),
                          projectId = projectId,
                          page = 1:100)
  ek_paginate(BASE_URLs)
}

#' Get response rates
#'
#' @param projectId a valid project id
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_response_rates(92834)
#'}
ek_response_rates <- function(projectId) {
  BASE_URLs <- glue::glue("{domain}/projects/{projectId}/responseRate?page={page}",
                          domain = ek_domain(),
                          projectId = projectId,
                          page = 1:100)
  ek_paginate(BASE_URLs)
}

#' Get project raw data
#'
#' @param projectId a valid project id
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_project_rawdata(132784)
#'}
ek_project_rawdata <- function(projectId) {
  BASE_URLs <- glue::glue("{domain}/projects/{projectId}/general/rawData?page={page}",
                          domain = ek_domain(),
                          projectId = projectId,
                          page = 1:100)
  ek_paginate(BASE_URLs)
}

#' Get course raw data
#'
#' @param projectId a valid project id
#' @param courseId a valid course id
#'
#' @return a data frame
#' @export
#'
#' @examples
#'\dontrun{
#' ek_course_rawdata(87123, 4342289)
#'}
ek_course_rawdata <- function(projectId, courseId) {
  BASE_URLs <- glue::glue("{domain}/projects/{projectId}/courses/{courseId}/rawData?page={page}",
                          domain = ek_domain(),
                          projectId = projectId,
                          courseId = courseId,
                          page = 1:100)
  ek_paginate(BASE_URLs)
}
