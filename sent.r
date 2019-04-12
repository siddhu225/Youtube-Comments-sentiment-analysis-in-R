library(tuber)
app_id <- "555979129602-39mrhk9rhuoe1lnan87fna5dl9r4k1ce"
app_secret<-"m4vdXgWX0d0EXw-CJK8BOmiD"

yt_oauth(app_id, app_secret,token='')

get_stats(video_id="N708P-A45D0")

res <- get_all_comments(c(video_id="kffacxfA7G4"))

results <- get_comment_threads(c(video_id="kffacxfA7G4"), max_results = 500)
head(res)