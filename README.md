# rEvalKit

The goal of rEvalKit is to hasten data extraction from the EvaluationKit REST API.

## Installation

`rEvalKit` is not on CRAN, but you can install the package with `devtools`:

``` r
devtools::install_github("daranzolin/rEvalKit")
```

## Setup

First, obtain an API key by contacting EvaluationKit. Second, set your domain and key with the two helper functions below. These values will get written to your .Rprofile.

```r
library(rEvalKit)
ek_set_token("YOUR_TOKEN_HERE")
ek_set_domin("YOUR_DOMAIN_HERE")
```

## Available Functions

* `ek_accounts`
* `ek_course_rawdata`
* `ek_courses`
* `ek_project_courses`
* `ek_project_nonrespondents`
* `ek_project_rawdata`
* `ek_project_respondents`
* `ek_project_users`
* `ek_projects`
* `ek_response_rates`
* `ek_survey_questions`
* `ek_surveys`
* `ek_terms`
* `ek_users`

## Project Raw Data

`ek_project_rawdata` will throw a 422 status error if the specified project is not a "General Survey Project". A workaround is to collect the raw data from each course like so:

```
projects <- ek_projects()

safe_get_ek_data <- safely(ek_course_rawdata)
get_project_data_safe_list <- function(projectId) {
  courses <- try(ek_project_courses(projectId), silent = TRUE)
  if (inherits(courses, "try-error")) return(NULL)
  list_args <- list(
    projectId = projectId,
    courseId = courses$id
  )
  pmap(list_args, safe_get_ek_data)
}
all_raw_data <- projects$id %>% 
  map(get_project_data_safe_list) %>%
  map_df("result")
```

