blah
================

 We conduct a large scale data-driven analysis of the effects of online personal attacks on social media user activity. First, we perform a thorough overview of the literature on the influence of social media on user behavior, especially on the impact that negative and aggressive behaviors, such as harassment and cyberbullying, have on users’ engagement in online media platforms. The majority of previous research were small-scale self-reported studies, which is their limitation. This motivates our data-driven study. We perform a large-scale analysis of messages from Reddit, a discussion website, for a period of two weeks, involving 182,528 posts or comments to posts by 148,317 users. To efficiently collect and analyze the data we apply a high-precision personal attack detection technology. We analyze the obtained data from three perspectives: (i) classical statistical methods, (ii) Bayesian estimation, and (iii) model-theoretic analysis. The three perspectives agree: personal attacks decrease the victims’ activity. The results can be interpreted as an important signal to social media platforms and policy makers that leaving personal attacks unmoderated is quite likely to disengage the users and in effect depopulate the platform. On the other hand, application of cyberviolence detection technology in combination with various mitigation techniques could improve and strengthen the user community. As more of our lives is taking place online, keeping the virtual space inclusive for all users becomes an important problem which online media platforms need to face.

Remark. In what follows, we sometimes display key pieces of code and explain what it does. Some not too fascinating pieces of code are supressed, but the reader can look them up in the associated .Rmd file and compile their own version.

# Technology applied for personal attack detection

For the need of this research we define personal attack as any kind of abusive remark made in relation to a person (ad hominem) rather than to the content of the argument expressed by that person in a discussion. The definition of ‘personal attack’ subsumes the use of specific terms which compare other people to animals or objects or making nasty insinuations without providing evidence. Three examples of typical personal attacks are as follows.

-   *You are legit mentally retarded homie.*
-   *Eat a bag of dicks, fuckstick.*
-   *Fuck off with your sensitivity you douche.*

The detection of personal attacks was performed using Samurai, a proprietary technology of Samurai Labs.[1]

The following figure illustrates how the input text ("ccant believ he sad ur an id10+...!") is processed step-by-step utilizing both statistical and symbolic methods.

In practice, it means that a whole variety of constructions can be detected without the need to construct a fixed list of dictionary words defined . Due to utilizing symbolic components that oversee statistical components, {Samurai} recognizes complex linguistic phenomena (such as indirect speech, rhetorical figures or counter-factual expressions) to distinguish personal attacks from normal communication, greatly reducing the number of false alarms as compared to others systems used for violence detection. An example of comparison can be seen in Figure , and a full benchmark was presented in (Ptaszyński et al., 2018).

The detection models utilized in this research were designed to detect personal attacks targeted against a second person (e.g. interlocutor, original author of a post) and a third person/group (e.g., other participants in the conversation, people not involved in the conversation, social groups, professional groups), except public figures (e.g. politicians, celebrities). With regards to symbolic component of the system, by "models" we mean separate rules (such as, specifying a candidate for the presence of personal attack, such as the aggressive word "idiot," which is further disambiguated with a syntactic rule of citation, e.g., "\[he|she|they\] said \[SUBJECT\] \[PREDICATE\]") or sets of rules, as seen in Figure , e.g. normalization model contains rules for transcription normalization, citation detection model contains rules for citation, etc. With regards to the statistical component, by "models" refer to machine learning models trained on large data to classify an entry into one of the categories (e.g., true personal attack, or false positive).

Moreover, the symbolic component of the system uses two types of symbolic rules, namely "narrow rules" and "wide rules." The former have smaller coverage (e.g., are triggered less often), but detect messages containing personal attacks with high precision. The latter, have wider coverage, but their precision is lower. We decided to set apart the "narrow" and "wide" subgroups of the detection models in order to increase the granularity of the analysis. Firstly, we took only the detection models designed to detect personal attacks targeted against second person. Secondly, we used these models on a dataset of 320,000 Reddit comments collected on 2019/05/06. Thirdly, we randomly picked at most hundred returned results for each low-level model. Low-level models are responsible for detecting low-level categories. Similarly, mid-level models detect mid-level categories, by combining several low-level models, etc. (Some models are triggered very often while others rarely, so using all instances would create too much bias). There were 390 low-level models but many of them returned in less than 100 results. We verified them manually with the help of expert annotators trained in detection of personal attacks and selected only those models that achieved at least 90% of precision. The models with fewer than 100 returned results were excluded from the selection. After this step, the "narrow" subgroup contained 43 out of 390 low-level models. Finally, we tested all of the "narrow" models on a large dataset of 477,851 Reddit comments collected between 2019/06/01 and 2019/08/31 from two subreddits (r/MensRights and r/TooAfraidToAsk). Each result of the "narrow" models was verified manually by a trained annotator and the "narrow" models collectively achieved over 93.3% of precision. We also tested the rest of the "wide" models on random samples of 100 results for each model (from the previous dataset of 320,000 Reddit comments) and we excluded the models that achieved less than 80% precision. The models with fewer than 100 results were not excluded from the "wide" group. In this simple setup we detected 24,251 texts containing "wide" attacks, where:

The sum exceeds 100% because some of the comments contained personal attacks against both second person and third person / groups. For example, a comment \`\`Fu\*\* you a\*\*hole, you know that girls from this school are real bit\*\*es" contains both types of personal attack.

Additionally, from the original data of 320,000 Reddit posts we extracted and annotated 6,769 Reddit posts as either a personal attack (1) or not (0). To assure that the extracted additional dataset contains a percentage of Personal Attacks sufficient to perform the evaluation, the Reddit posts were extracted with an assumption that each post contains at least one word of a general negative connotation. Our dictionary of such words contains 6,412 instances, and includes a wide range of negative words, such as nouns (e.g., "racist", "death", "idiot", "hell"), verbs (e.g., "attack", "kill", "destroy", "suck"), adjectives (e.g., "old", "thick", "stupid", "sick"), or adverbs (e.g., "spitefully", "tragically", "disgustingly"). In the 6,769 additionally annotated Reddit samples there were 957 actual Personal Attacks (14%), from which Samurai correctly assigned 709 (true positives) and missed 248 (false negatives), which accounts for 74% of the Recall rate. Finally, we performed another additional experiment in which, we used Samurai to annotate completely new 10,000 samples from Discord messages that did not contain Personal Attacks but contained vulgar words. The messages were manually checked by two trained annotators and one additional super-annotator. The result of Samurai on this additional dataset was a 2% of false positive rate, with exactly 202 cases misclassified as personal attacks. This accounts for specificity rate of 98%.

The raw datasets used have been obtained by , who were able to collect posts and comments without moderation or comment removal. All content was downloaded from the data stream provided by which enabled full data dump from Reddit in real-time. The advantage of using it was access to unmoderated data. Further, deployed their personal attacks recognition algorithms to identify personal attacks.

In the study, experimental manipulation of the crucial independent variables (personal attacks of various form) to assess their effect on the dependent variable (users’ change in activity) would be unethical and against the goal of Samurai Labs, which is to detect and *prevent* online violence. While such a lack of control is a weakness as compared to typical experiments in psychology, our sample was both much larger and much more varied than the usual WEIRD (western, educated, and from industrialized, rich, and democratic countries) groups used in psychology. Notice, however, that the majority of Reddit users are based in U.S. For instance, (Wise, Hamman, & Thorson, 2006) examined 59 undergraduates from a political science class at a major Midwestern university in the USA, (Zong, Yang, & Bao, 2019) studied 251 students and faculty members from China who are users of WeChat, and (Valkenburg, Peter, & Schouten, 2006) surveyed 881 young users (10-19yo.) of a Dutch SNS called CU2.

Because of the preponderance of personal attacks online, we could use the real-life data from Reddit and use the following study design:

1.  All the raw data, comprising of daily lists of posts and comments (some of which were used in the study) with time-stamps and author and target user names, have been obtained by Samurai Labs, who also applied their personal attack detection algorithm to them, adding two more variables: narrow and wide. These were the raw datasets used in further analysis.

2.  Practical limitations allowed for data collection for around two continuous weeks (day 0 ± 7 days). First, we randomly selected one weekend day and one working day. These were June 27, 2020 (Saturday, S) and July 02, 2020 (Thursday, R). The activity on those days was used to assign users to groups in the following manner. We picked one weekend and one non-weekend day to correct for activity shifts over the weekend (the data indeed revealed slightly higher activity over the weekends, no other week-day related pattern was observed). We could not investigate (or correct for) monthly activity variations, because the access to unmoderated data was limited.

3.  For each of these days, a random sample of 100,000 posts or comments have been drawn from all content posted on Reddit. Each of these datasets went through preliminary user-name based bots removal. This is a simple search for typical phrases included in user names, such as "Auto", "auto", "Bot", or "bot".

For instance, for our initial thursdayClean datased, this proceeds like this:

``` r
thursdayClean <- thursdayClean[!grepl("Auto", thursdayClean$author,
    fixed = TRUE), ]
thursdayClean <- thursdayClean[!grepl("auto", thursdayClean$author,
    fixed = TRUE), ]
thursdayClean <- thursdayClean[!grepl("Auto", thursdayClean$receiver,
    fixed = TRUE), ]
thursdayClean <- thursdayClean[!grepl("auto", thursdayClean$receiver,
    fixed = TRUE), ]
thursdayClean <- thursdayClean[!grepl("bot", thursdayClean$receiver,
    fixed = TRUE), ]
thursdayClean <- thursdayClean[!grepl("Bot", thursdayClean$receiver,
    fixed = TRUE), ]
```

1.  In some cases, content had been deleted by the user or removed by Reddit --- in such cases the dataset only contained information that some content had been posted but was later removed; since we could not access the content of such posts or comments and evaluate them for personal attacks, we also excluded them from the study.

Again, this was a fairly straightforward use of grepl:

``` r
thursdayClean <- thursdayClean[!grepl("none", thursdayClean$receiver,
    fixed = TRUE), ]
thursdayClean <- thursdayClean[!grepl("None", thursdayClean$receiver,
    fixed = TRUE), ]
thursdayClean <- thursdayClean[!grepl("<MISSING>", thursdayClean$receiver,
    fixed = TRUE), ]
thursdayClean <- thursdayClean[!grepl("[deleted]", thursdayClean$receiver,
    fixed = TRUE), ]
```

1.  This left us with 92,943 comments or posts by 75,516 users for and 89,585 comments by 72,801 users for . While we didn't directly track whether content was a post or a comment, we paid attention as to whether a piece of content was a reply to a post or not (the working assumption was that personal attacks on posts might have different impact than attacks on comments). Quite consistently, 46% of content were comments on posts on both days.

2.  On these two days respectively, 1359 users (1.79%) received at least one attack, 35 of them received more than one (0.046%). 302 of users (0.39%) received at least one attack and 3 of them more than one on that day (0.003%). These numbers are estimates for a single day, and therefore if the chance of obtaining at least one attack in a day is 1.79%, assuming the binomial distribution, the estimated probability of obtaining at least one attack in a week is 11.9% in a week and 43% in a month.

``` r
100  * round(1-dbinom(0,7,prob = 1359/75516),3)` #week
100 * round(1-dbinom(0,31,prob = 1359/75516),3)` #month
```

1.  To ensure a sufficient sample size, we decided not to draw a random sub-sample from the or class comprising 340 users, and included all of them in the Thursday treatment group (). Other users were randomly sampled from and added to , so that the group count was 1000.

2.  An analogous strategy was followed for . 1338 users belonged to , 27 to , 329 to and 3 to . The total of 344 or users was enriched with sampled users to obtain the group of 1000 users.

3.  The preliminary / groups of 1500 users each were constructed by sampling 1500 users who posted comments on the respective days but did not receive any recognized attacks. The group sizes for control groups are higher, because after obtaining further information we intended to eliminate those who received any attacks before the group selection day (and for practical reasons we could only obtain data for this period after the groups were selected).

4.  For each of these groups new dataset was prepared, containing all posts or comments made by the users during the period of ±7 days from the selection day (337,015 for , 149,712 for , 227,980 for and 196,999 for ) and all comments made to their posts or comments (621,486 for , 170,422 for , 201,614 for and 204,456 for ), after checking for uniqueness these jointly were 951,949 comments for , 318,542 comments for , 404,535 comments for , and 380,692 comments for ). The need to collect all comments to the content posted by our group members was crucial. We needed this information because we needed to check all such comments for personal attacks to obtain an adequate count of attacks received by our group members. In fact, this turned out to be the most demanding part of data collection.

5.  All these were wrangled into the frequency form, with (1) numbers of attacks as recognized by or algorithm (in the dataset we call these and respectively), (2) distinction between and ), and (3) activity counts for each day of the study, (4) with added joint counts for the e and periods. Frequency data for users outside of the control or treatment groups were removed.

6.  With the frequency form at hand, we could look at outliers. We used a fairly robust measure. For each of the weekly counts of and we calculated the interquartile range (), as the absolute distance between the first and the third quartile and identified as outliers those users which landed at least 1.5 × IQR from the respective mean. These resulted in a list of 534 "powerusers" which we suspected of being bots (even though we already removed users whose names suggested they were bots) --- all of them were manually checked by . Those identified as bots (only 15 of them) or missing (29 of them) were removed. It was impossible to establish whether the missing users were bots; there are also two main reasons why a user might be missing: (a) account suspended, and (b) user deleted. We decided not to include the users who went missing in our study, because they would artificially increase the activity drop during the period and because we didn't suspect any of the user deletions to be caused by personal attacks directed against them (although someone might have deleted the account because they were attacked, these were power-users who have a high probability of having been attacked quite a few times before, so this scenario is unlikely).

7.  The frequency form of the control sets data was used to remove those users who were attacked in the period (894 out of 1445 for , and 982 out of 1447 for remained).

8.  A few more unusual data points needed to be removed, because they turned out to be users whose comments contained large numbers of third-person personal attacks which in fact supported them. Since we were interested in the impact of personal attacks directed against a user on the user's activity, such unusual cases would distort the results. Six were authors of posts or comments which received more than 60 attacks each. Upon inspection, all of them supported the original users. For instance, two of them were third-person comments about not wearing a mask or sneezing in public, not attacks on these users. Another example is a female who asked for advice about her husband: the comments were supportive of her and critical of the husband. Two users with weekly activity count change higher than 500 were removed -- they did not seem to be bots but very often they posted copy-pasted content and their activity patterns were highly irregular with changes most likely attributable to some other factors than attacks received. The same holds for a young user we removed from the study who displayed activity change near 1000. She commented on her own activity during that period as very unusual and involving 50 hrs without sleeping. Her activity drop afterwards is very likely attributable to other factors than receiving a personal attack.

9.  86 users who did not post anything in the period were also removed.

10. In the end, and were aligned, centering around the selection day (day 8) and the studied group comprised 3673 users.

``` r
# note we load the data here
data <- read.csv("../datasets/quittingFinalAnon.csv")[, -1]
table(data$group)
```

    ## 
    ##   Rcontrol Rtreatment   Scontrol Streatment 
    ##        875        935        942        921

A few first lines of the resulting anonymized dataset from which we removed separate day counts. Note that in the code "low" corresponds to "wide" (for "low precision") and "high" to "narrow" attacks (for "high precision"). The variables are: (low attacks, high attacks, low attacks on posts, how attacks on posts, authored content posted) and retained summary columns.

-    contains anonymous user numbers.
-    contains the sum of attacks in days 1-7. the sum of (attacks in the same period.
-    and code and attacks on posts (we wanted to verify the additional sub-hypothesis that attacks on a post might have more impact than attacks on comments).

-    and count comments or posts during days seven days before and seven days after. The intuition is, these shouldn't change much if personal attacks have no impact on activity.

-    and include information about which group a user belongs to.

``` r
dataDisp <- data[, c(1, 77:85)]
head(dataDisp)
```

    ##   user sumLowBefore sumHighBefore sumPlBefore sumPhBefore activityBefore
    ## 1    1            1             0           1           0              2
    ## 2    2            5             4           0           0            106
    ## 3    3            2             1           0           0             29
    ## 4    4            6             4           0           0            180
    ## 5    5            5             2           0           0            116
    ## 6    6            2             0           0           0            124
    ##   activityAfter activityDiff      group treatment
    ## 1             0           -2 Rtreatment         1
    ## 2            80          -26 Rtreatment         1
    ## 3            31            2 Rtreatment         1
    ## 4            92          -88 Rtreatment         1
    ## 5            95          -21 Rtreatment         1
    ## 6           104          -20 Rtreatment         1

First, we visually explore our dataset by looking at the relationship between the number of received attacks vs. the activity change counted as the difference of weekly counts of posts or comments authored in the second () and in the first week (). We do this for attacks (Fig. ), attacks (Fig. ), where a weaker, but still negative impact, can be observed, and then we take a look at the impact of those attacks which were recognized as (Fig. ). The distinction between wide and narrow pertains only to the choice of attack recognition algorithm and does not directly translate into how offensive an attack was, except that attacks also include third-person ones. Here, the direction of impact is less clear: while the tendency is negative for low numbers of attacks, non-linear smoothing suggests that higher numbers mostly third-person personal attacks seem positively correlated with activity change. This might suggest that while being attacked has negative impact on a user's activity, having your post "supported" by other users' third-person attacks has a more motivating effect. We will look at this issue in a later section, when we analyze the dataset using regression.

The visualisations in Figure should be understood as follows. Each point is a user. The *x*-axis represents a number of attacks they received in the period (so that, for instance, users with 0 wide attacks are the members of the control group), and the *y*-axis represents the difference between their activity count and . We can see that most of the users received 0 attacks before (these are our control group members), with the rest of the group receiving 1, 2, 3, etc. attacks in the period with decreasing frequency. The blue line represents linear regression suggesting negative correlation. The gray line is constructed using generalized additive mode (gam) smoothing, which is a fairly standard smoothing method for large datasets (it is more sensitive to local tendencies and yet avoids overfitting). The parameters of the gam model (including the level of smoothing) are chosen by their predictive accuracy. Shades indicate the 95% confidence level interval for predictions from the linear model.

``` r
library(ggthemes)
th <- theme_tufte()
highPlot <- ggplot(data, aes(x = sumHighBefore, y = activityDiff)) +
    geom_jitter(size = 0.8, alpha = 0.3) + geom_smooth(method = "lm",
    color = "skyblue", fill = "skyblue", size = 0.7, alpha = 0.8) +
    scale_x_continuous(breaks = 0:max(data$sumHighBefore), limits = c(-1,
        max(data$sumHighBefore))) + ylim(c(-300, 300)) + geom_smooth(color = "grey",
    size = 0.4, lty = 2, alpha = 0.2) + xlab("narrow attacks before") +
    ylab("activity change after") + labs(title = "Impact of narrow attacks on activity",
    subtitle = "weekly counts, n=3673") + geom_segment(aes(x = -1,
    y = -100, xend = 9, yend = -100), lty = 3, size = 0.1, color = "gray71",
    alpha = 0.2) + geom_segment(aes(x = -1, y = 100, xend = 9,
    yend = 100), lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    geom_segment(aes(x = -1, y = -100, xend = -1, yend = 100),
        lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    geom_segment(aes(x = 9, y = -100, xend = 9, yend = 100),
        lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    th


highPlotZoomed <- ggplot(data, aes(x = sumHighBefore, y = activityDiff)) +
    geom_jitter(size = 1, alpha = 0.2) + geom_smooth(method = "lm",
    color = "skyblue", fill = "skyblue", size = 0.7, alpha = 0.8) +
    th + scale_x_continuous(breaks = 0:max(data$sumHighBefore),
    limits = c(-1, 9)) + ylim(c(-100, 100)) + geom_smooth(color = "grey",
    size = 0.4, lty = 2, alpha = 0.2) + xlab("narrow attacks before") +
    ylab("activity change after") + labs(title = "Impact of narrow attacks on activity",
    subtitle = "weekly counts, zoomed in") + geom_hline(yintercept = 0,
    col = "red", size = 0.2, lty = 3)
```

``` r
highPlot
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/highPlot-1.png" width="100%" style="display: block; margin: auto;" />

``` r
highPlotZoomed
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/highPlotZoomed-1.png" width="100%" style="display: block; margin: auto;" />

``` r
lowPlot <- ggplot(data, aes(x = sumLowBefore, y = activityDiff)) +
    geom_jitter(size = 0.8, alpha = 0.3) + geom_smooth(method = "lm",
    color = "skyblue", fill = "skyblue", size = 0.7, alpha = 0.8) +
    th + geom_smooth(color = "grey", size = 0.4, lty = 2, alpha = 0.2) +
    xlab("wide attacks before") + ylab("activity change after") +
    labs(title = "Impact of wide attacks on activity", subtitle = "weekly counts, n=3673") +
    geom_segment(aes(x = -1, y = -150, xend = 15, yend = -150),
        lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    geom_segment(aes(x = -1, y = 150, xend = 15, yend = 150),
        lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    geom_segment(aes(x = -1, y = -150, xend = -1, yend = 150),
        lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    geom_segment(aes(x = 15, y = -150, xend = 15, yend = 150),
        lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    xlim(c(-1, max(data$sumLowBefore)))



lowPlotZoomed <- ggplot(data, aes(x = sumLowBefore, y = activityDiff)) +
    geom_jitter(size = 1, alpha = 0.2) + geom_smooth(method = "lm",
    color = "skyblue", fill = "skyblue", size = 0.7, alpha = 0.8) +
    th + scale_x_continuous(breaks = 0:max(data$sumLowBefore),
    limits = c(-1, 15)) + ylim(c(-150, 150)) + geom_smooth(color = "grey",
    size = 0.4, lty = 2, alpha = 0.2) + xlab("wide attacks before") +
    ylab("activity change after") + labs(title = "Impact of wide attacks on activity",
    subtitle = "weekly counts, zoomed in") + geom_hline(yintercept = 0,
    col = "red", size = 0.2, lty = 3)
```

``` r
lowPlot
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/lowPlot-1.png" width="100%" style="display: block; margin: auto;" />

``` r
lowPlotZoomed
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/lowPlotZoomed-1.png" width="100%" style="display: block; margin: auto;" />

``` r
lowOnlyPlot <- ggplot(data, aes(x = (sumLowBefore - sumHighBefore),
    y = activityDiff)) + geom_jitter(size = 0.8, alpha = 0.3) +
    geom_smooth(method = "lm", color = "skyblue", fill = "skyblue",
        size = 0.7, alpha = 0.8) + th + geom_smooth(color = "grey",
    size = 0.4, lty = 2, alpha = 0.2) + xlab("wide only attacks before") +
    ylab("activity change after") + labs(title = "Impact of wide only attacks on activity",
    subtitle = "weekly counts, n=3673") + geom_segment(aes(x = -1,
    y = -150, xend = 15, yend = -150), lty = 3, size = 0.1, color = "gray71",
    alpha = 0.2) + geom_segment(aes(x = -1, y = 150, xend = 15,
    yend = 150), lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    geom_segment(aes(x = -1, y = -150, xend = -1, yend = 150),
        lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    geom_segment(aes(x = 15, y = -150, xend = 15, yend = 150),
        lty = 3, size = 0.1, color = "gray71", alpha = 0.2) +
    xlim(c(-1, max(data$sumLowBefore)))


lowOnlyPlotZoomed <- ggplot(data, aes(x = (sumLowBefore - sumHighBefore),
    y = activityDiff)) + geom_jitter(size = 1, alpha = 0.2) +
    geom_smooth(method = "lm", color = "skyblue", fill = "skyblue",
        size = 0.7, alpha = 0.8) + th + scale_x_continuous(breaks = 0:max(data$sumLowBefore),
    limits = c(-1, 15)) + ylim(c(-150, 150)) + geom_smooth(color = "grey",
    size = 0.4, lty = 2, alpha = 0.2) + xlab("wide only attacks before") +
    ylab("activity change after") + labs(title = "Impact of wide only attacks on activity",
    subtitle = "weekly counts, zoomed in") + geom_hline(yintercept = 0,
    col = "red", size = 0.2, lty = 3)
```

``` r
lowOnlyPlot
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/lowOnlyPlot-1.png" width="100%" style="display: block; margin: auto;" />

``` r
lowOnlyPlotZoomed
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/lowOnlyPlotZoomed-1.png" width="100%" style="display: block; margin: auto;" />

``` r
rescale <- function(diff, act) {
    diff/act
}
data$activityScore <- rescale(data$activityDiff, data$activityBefore)

propPlotHigh <- ggplot(data, aes(x = sumHighBefore, y = activityScore)) +
    geom_jitter(size = 0.8, alpha = 0.3) + geom_smooth(method = "lm",
    color = "skyblue", fill = "skyblue", size = 0.7, alpha = 0.8) +
    th + xlab("narrow attacks before") + ylab("proportional activity change") +
    labs(title = "Impact of narrow attacks on proportional activity",
        subtitle = "n=3673") + scale_y_continuous(limits = c(-1,
    10)) + geom_hline(yintercept = 0, col = "red", size = 0.2,
    lty = 3) + scale_x_continuous(breaks = 1:15, limits = c(-1,
    10)) + geom_smooth(color = "grey", size = 0.4, lty = 2, alpha = 0.2)

propPlotLow <- ggplot(data, aes(x = sumLowBefore, y = activityScore)) +
    geom_jitter(size = 0.8, alpha = 0.3) + geom_smooth(method = "lm",
    color = "skyblue", fill = "skyblue", size = 0.7, alpha = 0.8) +
    th + xlab("wide attacks before") + ylab("proportional activity change") +
    labs(title = "Impact of wide attacks on proportional activity",
        subtitle = "n=3673") + scale_y_continuous(limits = c(-1,
    10)) + geom_hline(yintercept = 0, col = "red", size = 0.2,
    lty = 3) + scale_x_continuous(breaks = 1:15, limits = c(-1,
    10)) + geom_smooth(color = "grey", size = 0.4, lty = 2, alpha = 0.2)


propPlotLowOnly <- ggplot(data, aes(x = sumLowBefore - sumHighBefore,
    y = activityScore)) + geom_jitter(size = 0.8, alpha = 0.3) +
    geom_smooth(method = "lm", color = "skyblue", fill = "skyblue",
        size = 0.7, alpha = 0.8) + th + xlab("wide only attacks before") +
    ylab("proportional activity change") + labs(title = "Impact of wide only attacks on proportional activity",
    subtitle = "n=3673") + scale_y_continuous(limits = c(-1,
    10)) + geom_hline(yintercept = 0, col = "red", size = 0.2,
    lty = 3) + scale_x_continuous(breaks = 1:15, limits = c(-1,
    10)) + geom_smooth(color = "grey", size = 0.4, lty = 2, alpha = 0.2)
```

``` r
propPlotHigh
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/propPlotHigh-1.png" width="100%" style="display: block; margin: auto;" />

``` r
propPlotLow
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/propPlotLow-1.png" width="100%" style="display: block; margin: auto;" />

``` r
propPlotLowOnly
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/propPlotLowOnly-1.png" width="100%" style="display: block; margin: auto;" />

``` r
counts <- t(table(data$sumHighBefore))
counts <- rbind(counts, counts)
counts[1, ] <- as.numeric(colnames(counts))
colnames(counts) <- NULL
rownames(counts) <- c("no. of attacks", "count")
counts
```

    ##                [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12]
    ## no. of attacks    0    1    2    3    4    5    6    7    8     9    10    11
    ## count          2831  530  147   61   35   22   17    8    4     3     2     2
    ##                [,13] [,14] [,15] [,16] [,17] [,18] [,19] [,20] [,21]
    ## no. of attacks    12    13    14    16    17    19    25    26    27
    ## count              1     1     1     3     1     1     1     1     1

``` r
attacks <- 0:8
max <- max(attacks)
low <- numeric(max + 1)
high <- numeric(max + 1)
m <- numeric(max + 1)
p <- numeric(max + 1)
t <- list()

for (attacks in attacks) {
    t[[attacks + 1]] <- t.test(data[data$sumHighBefore == attacks,
        ]$activityDiff)

    low[attacks + 1] <- t[[attacks + 1]]$conf.int[1]
    high[attacks + 1] <- t[[attacks + 1]]$conf.int[2]
    m[attacks + 1] <- t[[attacks + 1]]$estimate
    p[attacks + 1] <- t[[attacks + 1]]$p.value
}
highTable <- as.data.frame(round(rbind(0:8, low, m, high, p),
    3))
rownames(highTable) <- c("attacks", "CIlow", "estimated m", "CIhigh",
    "p-value")
```

``` r
highTableLong <- round(data.frame(attacks = 0:8, low, m, high,
    p), 3)

highTableBar <- ggplot(highTableLong) + geom_bar(aes(x = attacks,
    y = m), stat = "identity", fill = "skyblue", alpha = 0.5) +
    geom_errorbar(aes(x = attacks, ymin = low, ymax = high),
        width = 0.4, colour = "seashell3", alpha = 0.9, size = 0.3) +
    th + xlab("narrow attacks") + ylab("mean activity change") +
    geom_text(aes(x = attacks, y = low - 20, label = p), size = 2) +
    labs(title = "Mean impact of narrow attacks on  weekly activity",
        subtitle = "with 95% confidence intervals and p-values") +
    scale_x_continuous(labels = 0:8, breaks = 0:8)

highTableBar6 <- ggplot(highTableLong[highTableLong$attacks <
    6, ]) + geom_bar(aes(x = attacks, y = m), stat = "identity",
    fill = "skyblue", alpha = 0.5) + geom_errorbar(aes(x = attacks,
    ymin = low, ymax = high), width = 0.4, colour = "seashell3",
    alpha = 0.9, size = 0.3) + th + xlab("narrow attacks") +
    ylab("mean activity change") + geom_text(aes(x = attacks,
    y = low - 20, label = p), size = 2) + labs(title = "Mean impact of narrow attacks <6 on  weekly activity",
    subtitle = "with 95% confidence intervals and p-values") +
    scale_x_continuous(labels = 0:5, breaks = 0:5)

highTableBar3 <- ggplot(highTableLong[highTableLong$attacks <
    3, ]) + geom_bar(aes(x = attacks, y = m), stat = "identity",
    fill = "skyblue", alpha = 0.5) + geom_errorbar(aes(x = attacks,
    ymin = low, ymax = high), width = 0.4, colour = "seashell3",
    alpha = 0.9, size = 0.3) + th + xlab("narrow attacks") +
    ylab("mean activity change") + geom_text(aes(x = attacks,
    y = low - 5, label = p), size = 2) + labs(title = "Mean impact of narrow attacks <3 on  weekly activity",
    subtitle = "with 95% confidence intervals and p-values") +
    scale_x_continuous(labels = 0:2, breaks = 0:2)
```

``` r
attacks <- 0:8
max <- max(attacks)
lowL <- numeric(max + 1)
highL <- numeric(max + 1)
mL <- numeric(max + 1)
pL <- numeric(max + 1)
tL <- list()

for (attacks in attacks) {
    tL[[attacks + 1]] <- t.test(data[data$sumLowBefore == attacks,
        ]$activityDiff)

    lowL[attacks + 1] <- t[[attacks + 1]]$conf.int[1]
    highL[attacks + 1] <- t[[attacks + 1]]$conf.int[2]
    mL[attacks + 1] <- t[[attacks + 1]]$estimate
    pL[attacks + 1] <- t[[attacks + 1]]$p.value
}
lowTable <- as.data.frame(round(rbind(0:8, lowL, mL, highL, pL),
    3))
rownames(lowTable) <- c("attacks", "CIlow", "estimated m", "CIhigh",
    "p-value")


attacks <- 0:8
max <- max(attacks)
lowLo <- numeric(max + 1)
highLo <- numeric(max + 1)
mLo <- numeric(max + 1)
pLo <- numeric(max + 1)
tLo <- list()

for (attacks in attacks) {
    tLo[[attacks + 1]] <- t.test(data[data$sumLowBefore - data$sumHighBefore ==
        attacks, ]$activityDiff)

    lowLo[attacks + 1] <- t[[attacks + 1]]$conf.int[1]
    highLo[attacks + 1] <- t[[attacks + 1]]$conf.int[2]
    mLo[attacks + 1] <- t[[attacks + 1]]$estimate
    pLo[attacks + 1] <- t[[attacks + 1]]$p.value
}
lowOnlyTable <- as.data.frame(round(rbind(0:8, lowLo, mLo, highLo,
    pLo), 3))
rownames(lowTable) <- c("attacks", "CIlow", "estimated m", "CIhigh",
    "p-value")
```

``` r
lowTableLong <- round(data.frame(attacks = 0:8, lowL, mL, highL,
    pL), 3)

lowTableBar <- ggplot(lowTableLong) + geom_bar(aes(x = attacks,
    y = m), stat = "identity", fill = "skyblue", alpha = 0.5) +
    geom_errorbar(aes(x = attacks, ymin = low, ymax = high),
        width = 0.4, colour = "seashell3", alpha = 0.9, size = 0.3) +
    th + xlab("wide attacks") + ylab("mean activity change") +
    geom_text(aes(x = attacks, y = low - 20, label = round(p,
        3)), size = 2) + labs(title = "Mean impact of wide attacks on  weekly activity",
    subtitle = "with 95% confidence intervals and p-values") +
    scale_x_continuous(labels = 0:8, breaks = 0:8)


lowOnlyTableLong <- round(data.frame(attacks = 0:8, lowLo, mLo,
    highLo, pLo), 3)

lowOnlyTableBar <- ggplot(lowOnlyTableLong) + geom_bar(aes(x = attacks,
    y = m), stat = "identity", fill = "skyblue", alpha = 0.5) +
    geom_errorbar(aes(x = attacks, ymin = low, ymax = high),
        width = 0.4, colour = "seashell3", alpha = 0.9, size = 0.3) +
    th + xlab("wide only attacks") + ylab("mean activity change") +
    geom_text(aes(x = attacks, y = low - 20, label = round(p,
        3)), size = 2) + labs(title = "Mean impact of wide only attacks on  weekly activity",
    subtitle = "with 95% confidence intervals and p-values") +
    scale_x_continuous(labels = 0:8, breaks = 0:8)
```

T-test based estimates for activity change divided by numbers of narrow attacks received:

    ##                 V1      V2      V3      V4      V5       V6       V7       V8
    ## attacks      0.000   1.000   2.000   3.000   4.000    5.000    6.000    7.000
    ## CIlow       -3.154 -12.658 -23.390 -45.991 -94.861 -108.030 -169.527 -108.555
    ## estimated m -2.140  -8.251 -12.646 -25.607 -59.400  -60.864  -80.882  -46.125
    ## CIhigh      -1.125  -3.844  -1.902  -5.222 -23.939  -13.697    7.762   16.305
    ## p-value      0.000   0.000   0.021   0.015   0.002    0.014    0.071    0.124
    ##                   V9
    ## attacks        8.000
    ## CIlow       -144.273
    ## estimated m  -46.750
    ## CIhigh        50.773
    ## p-value        0.225

T-test based estimates for activity change divided by numbers of wide attacks received:

    ##                 V1      V2      V3      V4      V5       V6       V7       V8
    ## attacks      0.000   1.000   2.000   3.000   4.000    5.000    6.000    7.000
    ## CIlow       -3.154 -12.658 -23.390 -45.991 -94.861 -108.030 -169.527 -108.555
    ## estimated m -2.140  -8.251 -12.646 -25.607 -59.400  -60.864  -80.882  -46.125
    ## CIhigh      -1.125  -3.844  -1.902  -5.222 -23.939  -13.697    7.762   16.305
    ## p-value      0.000   0.000   0.021   0.015   0.002    0.014    0.071    0.124
    ##                   V9
    ## attacks        8.000
    ## CIlow       -144.273
    ## estimated m  -46.750
    ## CIhigh        50.773
    ## p-value        0.225

T-test based estimates for activity change divided by numbers of wide only attacks received:

    ##            V1      V2      V3      V4      V5       V6       V7       V8
    ##         0.000   1.000   2.000   3.000   4.000    5.000    6.000    7.000
    ## lowLo  -3.154 -12.658 -23.390 -45.991 -94.861 -108.030 -169.527 -108.555
    ## mLo    -2.140  -8.251 -12.646 -25.607 -59.400  -60.864  -80.882  -46.125
    ## highLo -1.125  -3.844  -1.902  -5.222 -23.939  -13.697    7.762   16.305
    ## pLo     0.000   0.000   0.021   0.015   0.002    0.014    0.071    0.124
    ##              V9
    ##           8.000
    ## lowLo  -144.273
    ## mLo     -46.750
    ## highLo   50.773
    ## pLo       0.225

``` r
highTableBar
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/highTableBar-1.png" width="100%" style="display: block; margin: auto;" />

``` r
highTableBar6
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/highTableBar6-1.png" width="100%" style="display: block; margin: auto;" />

``` r
highTableBar3
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/highTableBar3-1.png" width="100%" style="display: block; margin: auto;" />

``` r
lowTableBar
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/lowTableBar-1.png" width="100%" style="display: block; margin: auto;" />

``` r
lowOnlyTableBar
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/lowOnlyTableBar-1.png" width="100%" style="display: block; margin: auto;" />

``` r
h6 <- data[data$sumHighBefore == 6, ]
h7 <- data[data$sumHighBefore == 7, ]
h8 <- data[data$sumHighBefore == 8, ]

# power for 6 attacks
a <- mean(data$activityDiff)
s <- sd(h7$activityDiff)
n <- 8
error <- qt(0.975, df = n - 1) * s/sqrt(n)
left <- a - error
right <- a + error
assumed <- a - 80
tleft <- (left - assumed)/(s/sqrt(n))
tright <- (right - assumed)/(s/sqrt(n))
p <- pt(tright, df = n - 1) - pt(tleft, df = n - 1)
power6 <- 1 - p
power6
```

    ## [1] 0.7369795

``` r
# power for 7 attacks
a <- mean(data$activityDiff)
s <- sd(h7$activityDiff)
n <- 8
error <- qt(0.975, df = n - 1) * s/sqrt(n)
left <- a - error
right <- a + error
assumed <- a - 80
tleft <- (left - assumed)/(s/sqrt(n))
tright <- (right - assumed)/(s/sqrt(n))
p <- pt(tright, df = n - 1) - pt(tleft, df = n - 1)
power7 <- 1 - p
power7
```

    ## [1] 0.7369795

``` r
# power for 8 attacks
a <- mean(data$activityDiff)
s <- sd(h8$activityDiff)
n <- 4
error <- qt(0.975, df = n - 1) * s/sqrt(n)
left <- a - error
right <- a + error
assumed <- a - 80
tleft <- (left - assumed)/(s/sqrt(n))
tright <- (right - assumed)/(s/sqrt(n))
p <- pt(tright, df = n - 1) - pt(tleft, df = n - 1)
power8 <- 1 - p
power8
```

    ## [1] 0.3088534

robabilities that this effect would be discovered by a single sample t-test for 6, 7, and 8 attacks are 0.737, 0.737, 0.309, and so tests for higher numbers of attacks are underpowered.

We run single t-tests on different groups to estimate different means and we don't use t-test for hypothesis testing. To alleviate concerns about multiple testing and increased risk of type I error, we also performed an ANOVA tests, which strongly suggest non-random correlation between the numbers of attacks and activity change. Furthermore, 80 comparison rows in Tukey's Honest Significance Test (Tukey, 1949) have conservatively adjusted p-value below 0.05.

``` r
highAnova <- aov(activityDiff ~ as.factor(sumHighBefore), data = data)
lowAnova <- aov(activityDiff ~ as.factor(sumLowBefore), data = data)
lowOnlyAnova <- aov(activityDiff ~ as.factor(sumLowBefore - sumHighBefore),
    data = data)

library(descr, quietly = TRUE)
library(pander, quietly = TRUE)
library(papeR, quietly = TRUE)
sh <- xtable(summary(highAnova))
rownames(sh) <- c("narrow", "residuals")
sh
```

    ## % latex table generated in R 3.6.3 by xtable 1.8-4 package
    ## % Thu Jul 15 07:57:54 2021
    ## \begin{table}[ht]
    ## \centering
    ## \begin{tabular}{lrrrrr}
    ##   \hline
    ##  & Df & Sum Sq & Mean Sq & F value & Pr($>$F) \\ 
    ##   \hline
    ## narrow & 20 & 785495.95 & 39274.80 & 25.03 & 0.0000 \\ 
    ##   residuals & 3652 & 5730212.39 & 1569.06 &  &  \\ 
    ##    \hline
    ## \end{tabular}
    ## \end{table}

``` r
sl <- xtable(summary(lowAnova))
rownames(sl) <- c("narrow", "residuals")
sl
```

    ## % latex table generated in R 3.6.3 by xtable 1.8-4 package
    ## % Thu Jul 15 08:00:58 2021
    ## \begin{table}[ht]
    ## \centering
    ## \begin{tabular}{lrrrrr}
    ##   \hline
    ##  & Df & Sum Sq & Mean Sq & F value & Pr($>$F) \\ 
    ##   \hline
    ## narrow & 42 & 1103365.53 & 26270.61 & 17.62 & 0.0000 \\ 
    ##   residuals & 3630 & 5412342.81 & 1491.00 &  &  \\ 
    ##    \hline
    ## \end{tabular}
    ## \end{table}

``` r
so <- xtable(summary(lowOnlyAnova))
rownames(so) <- c("narrow", "residuals")
so
```

    ## % latex table generated in R 3.6.3 by xtable 1.8-4 package
    ## % Thu Jul 15 08:02:16 2021
    ## \begin{table}[ht]
    ## \centering
    ## \begin{tabular}{lrrrrr}
    ##   \hline
    ##  & Df & Sum Sq & Mean Sq & F value & Pr($>$F) \\ 
    ##   \hline
    ## narrow & 35 & 1106625.41 & 31617.87 & 21.26 & 0.0000 \\ 
    ##   residuals & 3637 & 5409082.93 & 1487.24 &  &  \\ 
    ##    \hline
    ## \end{tabular}
    ## \end{table}

``` r
means <- numeric(10000)
for (run in 1:10000) {
    means[run] <- mean(sample(data[data$sumHighBefore == 2, ]$activityDiff,
        30))
}
distr <- ggplot(data[data$sumHighBefore == 2, ], aes(x = activityDiff)) +
    geom_histogram(bins = 100) + th + ggtitle("Distribution of activityDiff for narrow attacks before = 2")


sampDistr <- ggplot() + geom_histogram(aes(x = means), bins = 100) +
    th + ggtitle("Simulated sampling distribution for the same  with n=30 and 10 000 runs")
```

``` r
distr
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/distr-1.png" style="display: block; margin: auto;" />

``` r
sampDistr
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/sampDistr-1.png" style="display: block; margin: auto;" />

-   *p*-values and confidence intervals are sensitive to undesirable factors, such as stopping intention in experiment design (Kruschke, 2015).

``` r
library(BEST)
priorsWide <- list(muM = 0, muSD = 50)
priorsInformed <- list(muM = -1.11, muSD = 44.47)
priorsFit <- list(muM = -1.11, muSD = 7.5)
```

``` r
priorWide <- ggplot(data = data.frame(x = c(-200, 200)), aes(x)) +
    stat_function(fun = dnorm, args = list(mean = 0, sd = 50)) +
    ylab("") + scale_y_continuous(breaks = NULL) + th + xlab("expected activity change") +
    labs(title = "Wide prior", subtitle = "Normal prior with m = 0, sd = 50")
priorWide
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/priorWide-1.png" width="100%" style="display: block; margin: auto;" />

``` r
priorFit <- ggplot(data = data.frame(x = c(-100, 100)), aes(x)) +
    stat_function(fun = dnorm, args = list(mean = -1.11, sd = 7.5)) +
    ylab("") + scale_y_continuous(breaks = NULL) + th + xlab("expected activity change") +
    labs(title = "Fitted prior, zoomed in", subtitle = "Normal prior with m = 0, sd = 10, empirical distribution in gray") +
    geom_density(data = data, aes(x = activityDiff), col = "grey",
        alpha = 0.6) + xlim(c(-80, 80))
priorFit
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/priorFit-1.png" width="100%" style="display: block; margin: auto;" />

``` r
priorInformative <- ggplot(data = data.frame(x = c(-200, 200)),
    aes(x)) + stat_function(fun = dnorm, args = list(mean = -1.11,
    sd = 44.47)) + ylab("") + scale_y_continuous(breaks = NULL) +
    th + xlab("expected activity change") + labs(title = "Informative prior",
    subtitle = "Normal prior with m = -1.11 and sd = 44.47")
priorInformative
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/priorInformative-1.png" width="100%" style="display: block; margin: auto;" />

``` r
priorFitted <- ggplot(data = data.frame(x = c(-100, 100)), aes(x)) +
    stat_function(fun = dnorm, args = list(mean = -1.11, sd = 7.5)) +
    ylab("") + scale_y_continuous(breaks = NULL) + th + xlab("expected activity change") +
    labs(title = "Fitted prior", subtitle = "Normal prior with m = 0, sd = 10, empirical distribution in gray") +
    geom_density(data = data, aes(x = activityDiff), col = "grey",
        alpha = 0.6) + xlim(c(-200, 200))
priorFitted
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/priorFitted-1.png" width="100%" style="display: block; margin: auto;" />

``` r
sh0 <- data[data$sumHighBefore == 0, ]$activityDiff
sh1 <- data[data$sumHighBefore == 1, ]$activityDiff
sh2 <- data[data$sumHighBefore == 2, ]$activityDiff
sh3 <- data[data$sumHighBefore == 3, ]$activityDiff
sh4 <- data[data$sumHighBefore == 4, ]$activityDiff
sh5 <- data[data$sumHighBefore == 5, ]$activityDiff
sh6 <- data[data$sumHighBefore == 6, ]$activityDiff
sh7 <- data[data$sumHighBefore == 7, ]$activityDiff
sh8 <- data[data$sumHighBefore == 8, ]$activityDiff
```

``` r
mc3w <- BESTmcmc(sh3, priors = priorsWide)
plotPostPred(mc3w)
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-28-1.png" width="100%" style="display: block; margin: auto;" />

Next, we print some information about the object we obtained:

``` r
print(mc3w)
```

    ## MCMC fit results for BEST analysis:
    ## 100002 simulations saved.
    ##          mean     sd  median    HDIlo  HDIup  Rhat n.eff
    ## mu    -24.476  9.063 -24.327 -42.4760 -6.859 1.000 48767
    ## nu      9.626 12.988   5.275   0.9163 33.326 1.001  2867
    ## sigma  61.398 11.533  61.081  39.6685 84.249 1.000  9530
    ## 
    ## 'HDIlo' and 'HDIup' are the limits of a 95% HDI credible interval.
    ## 'Rhat' is the potential scale reduction factor (at convergence, Rhat=1).
    ## 'n.eff' is a crude measure of effective sample size.

``` r
ggplot() + geom_line(aes(x = 1:length(mc3w$mu[1:100]), y = mc3w$mu[1:100]),
    alpha = 0.7) + th + xlab("initial steps in the chain") +
    ylab("potential parameter") + labs(title = "Convergence plot for first 100 steps in MCMC",
    subtitle = "Wide prior, three attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/convergencePlot-1.png" width="100%" style="display: block; margin: auto;" />

We can also inspect the chain diagnostics:

``` r
conv <- mc3w$mu[seq(1, length(mc3w$mu), by = 50)]
ggplot() + geom_line(aes(x = 1:length(conv), y = conv), alpha = 0.7) +
    th + xlab("steps in the selection") + ylab("potential parameter") +
    labs(title = "Convergence plot for every 50th step in MCMC",
        subtitle = "Wide prior, three attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/chainDiagnostics-1.png" width="100%" style="display: block; margin: auto;" />

``` r
plot(mc3w)
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/collapsed-1.png" width="100%" style="display: block; margin: auto;" />

Visual inspection of Figure reveals that the most visited locations (potential mean activity drops) center around slightly less than minus twenty. In fact, the mean of those visited potential means is -24.476 (although this does not have to be the mean of the sample, which in our case is -25.6065574; rather it is the result of a compromise between the data and the prior). The median is very close. The new elements are HDIlo and HDIup, the limits of the : the range of values that are most credible and cover 95% of the distribution. The Values within the 95% HDI are more credible than values outside the HDI, and the values inside it have a total probability of 95%. Crucially, these can be interpreted as posterior probabilities of various mean candidates being the population means based on the data, which makes HDI much unlike standard confidence intervals.

``` r
# prepare data and plot densities
bayesianWideDF <- data.frame(a0 = mc0w$mu, a1 = mc1w$mu, a2 = mc2w$mu,
    a3 = mc3w$mu, a4 = mc4w$mu, a5 = mc5w$mu, a6 = mc6w$mu, a7 = mc7w$mu,
    a8 = mc8w$mu)
bayesianWideDF$prior <- rnorm(nrow(bayesianWideDF), mean = 0,
    sd = 50)
BayesianWideDFLong <- gather(bayesianWideDF)
BayesianWideDFLong$key <- as.factor(BayesianWideDFLong$key)
BayesianWideDensities <- ggplot(BayesianWideDFLong, aes(x = value,
    group = key, color = key, fill = key)) + geom_density(alpha = 0.2) +
    th + xlab("activity change") + scale_fill_discrete(name = "group",
    labels = c("0 attacks", "1 attack", "2 attacks", "3 attacks",
        "4 attacks", "5 attacks", "6 attacks", "7 attacks", "8 attacks",
        "prior")) + guides(color = FALSE, size = FALSE) + ylim(c(0,
    0.11)) + xlim(c(-90, 60)) + labs(title = "Impact of data on wide prior",
    subtitle = "narrow attacks vs. activity change")

# extract means and HDI limits from the mcmc objects
wideMeans <- numeric(9)
wideLow <- numeric(9)
wideHigh <- numeric(9)
for (i in 1:9) {
    wideMeans[i] <- eval(parse(text = paste("summary(mc", i -
        1, "w)[1]", sep = "")))
    wideLow[i] <- eval(parse(text = paste("summary(mc", i - 1,
        "w)[21]", sep = "")))
    wideHigh[i] <- eval(parse(text = paste("summary(mc", i -
        1, "w)[26]", sep = "")))
}

# order the data and make the barplot
wideBayesTable <- round(data.frame(attacks = 0:8, wideLow, wideMeans,
    wideHigh), 3)
wideBayesBar <- ggplot(wideBayesTable) + geom_bar(aes(x = attacks,
    y = wideMeans), stat = "identity", fill = "skyblue", alpha = 0.5) +
    geom_errorbar(aes(x = attacks, ymin = wideLow, ymax = wideHigh),
        width = 0.4, colour = "seashell3", alpha = 0.9, size = 0.3) +
    th + xlab("narrow attacks") + ylab("activity change") + geom_text(aes(x = attacks +
    0.24, y = wideMeans - 3, label = round(wideMeans, 1)), size = 3) +
    scale_x_continuous(labels = 0:8, breaks = 0:8)
```

``` r
bayesianFittedDF <- data.frame(a0 = mc0f$mu, a1 = mc1f$mu, a2 = mc2f$mu,
    a3 = mc3f$mu, a4 = mc4f$mu, a5 = mc5f$mu, a6 = mc6f$mu, a7 = mc7f$mu,
    a8 = mc8f$mu)
bayesianFittedDF$prior <- rnorm(nrow(bayesianFittedDF), mean = -1.11,
    sd = 7.5)
BayesianFittedDFLong <- gather(bayesianFittedDF)
BayesianFittedDFLong$key <- as.factor(BayesianFittedDFLong$key)
BayesianFittedDensities <- ggplot(BayesianFittedDFLong, aes(x = value,
    group = key, color = key, fill = key)) + geom_density(alpha = 0.2) +
    th + xlab("activity change") + scale_fill_discrete(name = "group",
    labels = c("0 attacks", "1 attack", "2 attacks", "3 attacks",
        "4 attacks", "5 attacks", "6 attacks", "7 attacks", "8 attacks",
        "prior")) + guides(color = FALSE, size = FALSE) + ylim(c(0,
    0.12)) + xlim(c(-35, 20)) + labs(title = "Impact of data on fitted prior",
    subtitle = "narrow attacks vs. activity change")

fittedMeans <- numeric(9)
fittedLow <- numeric(9)
fittedHigh <- numeric(9)

for (i in 1:9) {
    fittedMeans[i] <- eval(parse(text = paste("summary(mc", i -
        1, "f)[1]", sep = "")))
    fittedLow[i] <- eval(parse(text = paste("summary(mc", i -
        1, "f)[21]", sep = "")))
    fittedHigh[i] <- eval(parse(text = paste("summary(mc", i -
        1, "f)[26]", sep = "")))
}

fittedBayesTable <- round(data.frame(attacks = 0:8, fittedLow,
    fittedMeans, fittedHigh), 3)
fittedBayesBar <- ggplot(fittedBayesTable) + geom_bar(aes(x = attacks,
    y = fittedMeans), stat = "identity", fill = "skyblue", alpha = 0.5) +
    geom_errorbar(aes(x = attacks, ymin = fittedLow, ymax = fittedHigh),
        width = 0.4, colour = "seashell3", alpha = 0.9, size = 0.3) +
    th + xlab("narrow attacks") + ylab("activity change") + geom_text(aes(x = attacks +
    0.25, y = fittedMeans - 1, label = round(fittedMeans, 1)),
    size = 3) + scale_x_continuous(labels = 0:8, breaks = 0:8)


# ______________________________
bayesianInformativeDF <- data.frame(a0 = mc0i$mu, a1 = mc1i$mu,
    a2 = mc2i$mu, a3 = mc3i$mu, a4 = mc4i$mu, a5 = mc5i$mu, a6 = mc6i$mu,
    a7 = mc7i$mu, a8 = mc8i$mu)
bayesianInformativeDF$prior <- rnorm(nrow(bayesianInformativeDF),
    mean = -1.11, sd = 44.47)
BayesianInformativeDFLong <- gather(bayesianInformativeDF)
BayesianInformativeDFLong$key <- as.factor(BayesianInformativeDFLong$key)
BayesianInvormativeDensities <- ggplot(BayesianInformativeDFLong,
    aes(x = value, group = key, color = key, fill = key)) + geom_density(alpha = 0.2) +
    th + xlab("activity change") + scale_fill_discrete(name = "group",
    labels = c("0 attacks", "1 attack", "2 attacks", "3 attacks",
        "4 attacks", "5 attacks", "6 attacks", "7 attacks", "8 attacks",
        "prior")) + guides(color = FALSE, size = FALSE) + ylim(c(0,
    0.11)) + xlim(c(-90, 50)) + labs(title = "Impact of data on Informative prior",
    subtitle = "narrow attacks vs. activity change")


InformativeMeans <- numeric(9)
InformativeLow <- numeric(9)
InformativeHigh <- numeric(9)

for (i in 1:9) {
    InformativeMeans[i] <- eval(parse(text = paste("summary(mc",
        i - 1, "i)[1]", sep = "")))
    InformativeLow[i] <- eval(parse(text = paste("summary(mc",
        i - 1, "i)[21]", sep = "")))
    InformativeHigh[i] <- eval(parse(text = paste("summary(mc",
        i - 1, "i)[26]", sep = "")))
}

InformativeBayesTable <- round(data.frame(attacks = 0:8, InformativeLow,
    InformativeMeans, InformativeHigh), 3)

InformativeBayesBar <- ggplot(InformativeBayesTable) + geom_bar(aes(x = attacks,
    y = InformativeMeans), stat = "identity", fill = "skyblue",
    alpha = 0.5) + geom_errorbar(aes(x = attacks, ymin = InformativeLow,
    ymax = InformativeHigh), width = 0.4, colour = "seashell3",
    alpha = 0.9, size = 0.3) + th + xlab("narrow attacks") +
    ylab("activity change") + geom_text(aes(x = attacks + 0.25,
    y = InformativeMeans - 3, label = round(InformativeMeans,
        1)), size = 3) + scale_x_continuous(labels = 0:8, breaks = 0:8)
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/BayesianWideDensities-1.png" width="100%" style="display: block; margin: auto;" />

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/wideBayesBar-1.png" width="100%" style="display: block; margin: auto;" />

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/BayesianFittedDensities-1.png" width="100%" style="display: block; margin: auto;" />

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/fittedBayesBar-1.png" width="100%" style="display: block; margin: auto;" />

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/BayesianInvormativeDensitie-1.png" width="100%" style="display: block; margin: auto;" />

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/InformativeBayesBar-1.png" width="100%" style="display: block; margin: auto;" />

``` r
sds <- c(sd(sh0), sd(sh1), sd(sh2), sd(sh3), sd(sh4), sd(sh5),
    sd(sh6), sd(sh7), sd(sh8))
attacks <- 0:8

ggplot() + geom_bar(aes(x = attacks, y = round(sds, 2)), stat = "identity",
    fill = "skyblue", alpha = 0.5) + th + xlab("narrow attacks") +
    ylab("standard deviation of activity change") + scale_x_continuous(breaks = 0:8,
    labels = 0:8)
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/sds-1.png" width="100%" style="display: block; margin: auto;" />

``` r
library(MASS)
library(vcd)
library(lmtest)
library(countreg)
library(pscl)
library(stats)
```

``` r
activityAfterTab <- table(factor(data$activityAfter, levels = 0:max(data$activityAfter)))
activityAfterDf <- as.data.frame(activityAfterTab)
activityAfterDf$Var1 <- as.integer(activityAfterDf$Var1)
```

``` r
activityDistr <- ggplot(activityAfterDf, aes(x = Var1, y = Freq)) +
    geom_bar(stat = "identity") + scale_x_continuous(breaks = seq(0,
    1000, by = 50)) + th + labs(title = "Distribution of activityAfter") +
    xlab("activityAfter") + ylab("count")

activityDistrRestr <- ggplot(activityAfterDf, aes(x = Var1, y = Freq)) +
    geom_bar(stat = "identity") + scale_x_continuous(breaks = seq(0,
    100, by = 10), limits = c(0, 100)) + th + labs(title = "Distribution of activityAfter",
    subtitle = "x restricted to 0-100") + xlab("activityAfter") +
    ylab("count")
```

``` r
activityDistr
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/activityDistr-1.png" width="100%" style="display: block; margin: auto;" />

``` r
activityDistrRestr
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/activityDistrRes-1.png" width="100%" style="display: block; margin: auto;" />

``` r
activityFitPois <- goodfit(activityAfterTab, type = "poisson")
unlist(activityFitPois$par)
summary(activityFitPois)
```

``` r
activityFitPois <- goodfit(activityAfterTab, type = "poisson")
poissonFitPlot <- ggplot(activityAfterDf, aes(x = Var1, y = Freq)) +
    geom_bar(stat = "identity", alpha = 0.6) + scale_x_continuous(breaks = seq(0,
    100, by = 10), limits = c(0, 100)) + th + labs(title = "activityAfter with fitted best Poisson model predictions",
    subtitle = "x restricted to 0-100") + xlab("activityAfter") +
    ylab("count") + geom_point(aes(x = Var1, y = activityFitPois$fitted),
    colour = "darksalmon", size = 0.5, alpha = 0.5)
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/poissonFitPlot-1.png" width="100%" style="display: block; margin: auto;" />

``` r
activityFitNbin <- goodfit(activityAfterTab, type = "nbinom")
summary(activityFitNbin)
```

    ## 
    ##   Goodness-of-fit test for nbinomial distribution
    ## 
    ##                       X^2  df     P(> X^2)
    ## Likelihood Ratio 647.9633 272 1.045879e-32

``` r
activityFitNbin <- goodfit(activityAfterTab, type = "nbinom")
poissonNbinPlot2 <- ggplot(activityAfterDf, aes(x = Var1, y = Freq)) +
    geom_bar(stat = "identity", alpha = 0.5) + scale_x_continuous(breaks = seq(0,
    100, by = 10), limits = c(0, 100)) + th + labs(title = "activityAfter with fitted best negative binomial model predictions",
    subtitle = "x restricted to 0-100") + xlab("activityAfter") +
    ylab("count") + geom_point(aes(x = Var1, y = activityFitNbin$fitted),
    colour = "darksalmon", size = 0.5, alpha = 0.8)
```

``` r
poissonNbinPlot2
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/poissonNbinPlot2-1.png" width="100%" style="display: block; margin: auto;" />

``` r
data$sumLowOnlyBefore <- data$sumLowBefore - data$sumHighBefore

fullModelZINbin <- zeroinfl(activityAfter ~ sumLowOnlyBefore +
    sumHighBefore + sumPlBefore + sumPhBefore + activityBefore,
    data = data, dist = "negbin")

fullModelHNbin <- hurdle(activityAfter ~ sumLowOnlyBefore + sumHighBefore +
    sumPlBefore + sumPhBefore + activityBefore, data = data,
    dist = "negbin")

fullModelZIpois <- zeroinfl(activityAfter ~ sumLowOnlyBefore +
    sumHighBefore + sumPlBefore + sumPhBefore + activityBefore,
    data = data, dist = "poisson")

fullModelHpois <- hurdle(activityAfter ~ sumLowOnlyBefore + sumHighBefore +
    sumPlBefore + sumPhBefore + activityBefore, data = data,
    dist = "poisson")
```

``` r
fullModelZINbinRoot <- countreg::rootogram(fullModelZINbin, max = 100,
    main = "Zero-inflated negative binomial")

fullModelHNbinRoot <- countreg::rootogram(fullModelHNbin, max = 100,
    main = "Hurdle negative binomial")

fullModelZIpoisRoot <- countreg::rootogram(fullModelZIpois, max = 100,
    main = "Zero-inflated Poisson")

fullModelHpoisRoot <- countreg::rootogram(fullModelHpois, max = 100,
    main = "Hurdle Poisson")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-40-1.png" width="100%" style="display: block; margin: auto;" /><img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-40-2.png" width="100%" style="display: block; margin: auto;" /><img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-40-3.png" width="100%" style="display: block; margin: auto;" /><img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-40-4.png" width="100%" style="display: block; margin: auto;" />

``` r
autoplot(fullModelZINbinRoot, alpha = 0.5) + th + ylab("Square root of couts") +
    ggtitle("Zero-inflated negative binomial")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/fullModelZINbinRoot-1.png" width="100%" style="display: block; margin: auto;" />

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/fullModelHNbinRoot-1.png" width="100%" style="display: block; margin: auto;" />

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/fullModelZIpoisRoot-1.png" width="100%" style="display: block; margin: auto;" />

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/fullModelHpoisRoot-1.png" width="100%" style="display: block; margin: auto;" />

``` r
vuong(fullModelZINbin, fullModelHNbin)
```

    ## Vuong Non-Nested Hypothesis Test-Statistic: 
    ## (test-statistic is asymptotically distributed N(0,1) under the
    ##  null that the models are indistinguishible)
    ## -------------------------------------------------------------
    ##               Vuong z-statistic             H_A  p-value
    ## Raw                    2.089478 model1 > model2 0.018332
    ## AIC-corrected          2.089478 model1 > model2 0.018332
    ## BIC-corrected          2.089478 model1 > model2 0.018332

``` r
logLik(fullModelZINbin)
```

    ## 'log Lik.' -14459.65 (df=13)

``` r
AIC(fullModelZINbin)
```

    ## [1] 28945.3

``` r
logLik(fullModelHNbin)
```

    ## 'log Lik.' -14527.69 (df=13)

``` r
AIC(fullModelHNbin)
```

    ## [1] 29081.39

There seem to be some reasons to prefer the zero-inflated model, but the score differences are not too impressive, both likelihood ratios are Akaike scores are very close (note: we want to minimize AIC and maximize log likelihood).

To move on we need to modify the variables, because some of the counts included others. This was not a problem so far, but now we will be looking in detail at their roles jointly, and so it is important to not count various things multiple times.

``` r
# select variables of interest
dataModeling <- data %>%
    dplyr::select(sumLowOnlyBefore, sumHighBefore, sumPlBefore,
        sumPhBefore, activityBefore, activityAfter)

# sum narrow now becomes sum of narrow attacks on comments
dataModeling$sumHighBefore <- dataModeling$sumHighBefore - dataModeling$sumPhBefore

# sum wide only now becomes sum of wide only on comments
dataModeling$sumLowOnlyBefore <- dataModeling$sumLowOnlyBefore -
    dataModeling$sumPlBefore

# sum of wide on posts now becomes sum of wide only on
# posts
dataModeling$sumPlBefore <- dataModeling$sumPlBefore - dataModeling$sumPhBefore
```

``` r
ZNBfull <- zeroinfl(activityAfter ~ ., data = dataModeling, dist = "negbin")
ZNBactivity <- zeroinfl(activityAfter ~ activityBefore, data = dataModeling,
    dist = "negbin")
HNBfull <- hurdle(activityAfter ~ ., data = dataModeling, dist = "negbin")
HNBactivity <- hurdle(activityAfter ~ activityBefore, data = dataModeling,
    dist = "negbin")

# now take a look at this
summary(dataModeling$activityAfter)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    2.00   10.00   35.69   38.00 1032.00

The outcome variable has third quartile of weekly activity count in the period at 38, and we are mostly interested in predictive accuracy where most of the users are placed. Therefore, we look at what happens with these models up to 40.

``` r
ZNBfullRoot <- countreg::rootogram(ZNBfull, max = 40, main = "Zero-inflated negative binomial")

ZNBactivityRoot <- countreg::rootogram(ZNBactivity, max = 40,
    main = "Hurdle negative binomial")

HNBfullRoot <- countreg::rootogram(HNBfull, max = 40, main = "Zero-inflated Poisson")

HNBactivityRoot <- countreg::rootogram(HNBactivity, max = 40,
    main = "Hurdle Poisson")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-45-1.png" width="100%" style="display: block; margin: auto;" /><img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-45-2.png" width="100%" style="display: block; margin: auto;" /><img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-45-3.png" width="100%" style="display: block; margin: auto;" /><img src="https://rfl-urbaniak.github.io/redditAttacks/images/unnamed-chunk-45-4.png" width="100%" style="display: block; margin: auto;" />

``` r
autoplot(ZNBfullRoot, alpha = 0.5) + th + ylab("Square root of couts") +
    ggtitle("Zero-inflated negative binomial (all variables)")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/ZNBfullRoot-1.png" width="100%" style="display: block; margin: auto;" />

``` r
autoplot(HNBfullRoot, alpha = 0.5) + th + ylab("Square root of couts") +
    ggtitle("Hurdle negative binomial (all variables)")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/HNBfullRoot-1.png" width="100%" style="display: block; margin: auto;" />

``` r
autoplot(ZNBactivityRoot, alpha = 0.5) + th + ylab("Square root of couts") +
    ggtitle("Zero-inflated negative binomial (activity only)")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/ZNBactivityRoot-1.png" width="100%" style="display: block; margin: auto;" />

``` r
autoplot(HNBactivityRoot, alpha = 0.5) + th + ylab("Square root of couts") +
    ggtitle("Hurdle negative binomial (activity only)")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/HNBactivityRoot-1.png" width="100%" style="display: block; margin: auto;" />

Finally, Akaike Information Criterion (Akaike, 1974) provides an estimator of out-of-sample prediction error and penalizes more complex models. As long as we evaluate models with respect to the same data, the ones with lower Akaike score should be chosen. Even with penalty for the additional variables, the full model receives better score (although the difference is not very large, 29,081 vs. 29,085).

``` r
library(lmtest)
likHNBactivity <- logLik(HNBactivity)
likHNBfull <- logLik(HNBfull)
(teststat <- -2 * (as.numeric(likHNBactivity) - as.numeric(likHNBfull)))
```

    ## [1] 20.28267

``` r
df <- 13 - 5
(p.val <- pchisq(teststat, df = df, lower.tail = FALSE))
```

    ## [1] 0.009317915

``` r
lrtest(HNBactivity, HNBfull)
```

    ## Likelihood ratio test
    ## 
    ## Model 1: activityAfter ~ activityBefore
    ## Model 2: activityAfter ~ .
    ##   #Df LogLik Df  Chisq Pr(>Chisq)   
    ## 1   5 -14538                        
    ## 2  13 -14528  8 20.283   0.009318 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
waldtest(HNBactivity, HNBfull)
```

    ## Wald test
    ## 
    ## Model 1: activityAfter ~ activityBefore
    ## Model 2: activityAfter ~ .
    ##   Res.Df Df  Chisq Pr(>Chisq)   
    ## 1   3668                        
    ## 2   3660  8 24.714   0.001738 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
AIC(HNBactivity)
```

    ## [1] 29085.67

``` r
AIC(HNBfull)
```

    ## [1] 29081.39

``` r
HNBfull
```

    ## 
    ## Call:
    ## hurdle(formula = activityAfter ~ ., data = dataModeling, dist = "negbin")
    ## 
    ## Count model coefficients (truncated negbin with log link):
    ##      (Intercept)  sumLowOnlyBefore     sumHighBefore       sumPlBefore  
    ##         2.534167         -0.009021         -0.007607          0.015150  
    ##      sumPhBefore    activityBefore  
    ##        -0.139336          0.015018  
    ## Theta = 0.7734 
    ## 
    ## Zero hurdle model coefficients (binomial with logit link):
    ##      (Intercept)  sumLowOnlyBefore     sumHighBefore       sumPlBefore  
    ##         0.490741         -0.009813         -0.111728         -0.104510  
    ##      sumPhBefore    activityBefore  
    ##         0.144576          0.080384

``` r
expCoef <- as.data.frame(round((exp(coef((HNBfull)))), 3))
colnames(expCoef) <- c("Odds ratios")
expCoef
```

    ##                        Odds ratios
    ## count_(Intercept)           12.606
    ## count_sumLowOnlyBefore       0.991
    ## count_sumHighBefore          0.992
    ## count_sumPlBefore            1.015
    ## count_sumPhBefore            0.870
    ## count_activityBefore         1.015
    ## zero_(Intercept)             1.634
    ## zero_sumLowOnlyBefore        0.990
    ## zero_sumHighBefore           0.894
    ## zero_sumPlBefore             0.901
    ## zero_sumPhBefore             1.156
    ## zero_activityBefore          1.084

``` r
sumLowOnlyBefore <- rep(mean(dataModeling$sumLowOnlyBefore),
    4001)
sumHighBefore <- rep(mean(dataModeling$sumHighBefore), 4001)
sumPlBefore <- rep(mean(dataModeling$sumPlBefore), 4001)
sumPhBefore <- rep(mean(dataModeling$sumPhBefore), 4001)
activityBefore <- rep(mean(dataModeling$activityBefore), 4001)
activityAfter <- rep(mean(dataModeling$activityAfter), 4001)

baseEffDf <- data.frame(sumLowOnlyBefore, sumHighBefore, sumPlBefore,
    sumPhBefore, activityBefore, activityAfter)

effSizePlot <- function(columnno, range = 40, by = 5) {
    EffDf <- baseEffDf
    EffDf[, columnno] <- 0:4000
    EffDf$prediction <- predict(HNBfull, EffDf)
    ggplot(EffDf, aes(x = EffDf[, columnno], y = prediction)) +
        geom_smooth(alpha = 0.5, col = "skyblue", se = FALSE) +
        scale_x_continuous(breaks = seq(0, range, by = by), limits = c(-1,
            range)) + th + ylab("predicted activity")
}

effLO <- effSizePlot(1, 500, 50)  #low only
effH <- effSizePlot(2, 50, 5)  #narrow on comments
effPl <- effSizePlot(3, 100, 10)  #pl
effPh <- effSizePlot(4, 50, 5)  #ph
effA <- effSizePlot(5, 200, 20)  #abefore
```

``` r
effLO + ggtitle("Predicted (hurdle) effect of wide only attacks on comments") +
    xlab("wide only attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effLO-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effH + ggtitle("Predicted (hurdle) effect of narrow attacks on comments") +
    xlab("narrow attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effH-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effPl + ggtitle("Predicted (hurdle) effect of wide attacks on posts") +
    xlab("wide attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effPl-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effPh + ggtitle("Predicted (hurdle) effect of narrow attacks on posts") +
    xlab("narrow attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effPh-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effA + ggtitle("Predicted (hurdle) effect of previous activity") +
    xlab("activity before")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effA-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effSizePlotZ <- function(columnno, range = 40, by = 5) {
    EffDf <- baseEffDf
    EffDf[, columnno] <- 0:4000
    EffDf$prediction <- predict(ZNBfull, EffDf)
    ggplot(EffDf, aes(x = EffDf[, columnno], y = prediction)) +
        geom_smooth(alpha = 0.5, col = "skyblue", se = FALSE) +
        scale_x_continuous(breaks = seq(0, range, by = by), limits = c(-1,
            range)) + th + ylab("predicted activity")
}

effLOZ <- effSizePlotZ(1, 500, 50)  #wide only
effHZ <- effSizePlotZ(2, 50, 5)  #high on comments
effPlZ <- effSizePlotZ(3, 100, 10)  #pl
effPhZ <- effSizePlotZ(4, 50, 5)  #ph
effAZ <- effSizePlotZ(5, 200, 20)  #abefore
```

``` r
effLOZ + ggtitle("Predicted (zero-inflated) effect of wide only attacks on comments") +
    xlab("wide only attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effLOZ-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effHZ + ggtitle("Predicted (zero-inflated) effect of narrow attacks on comments") +
    xlab("narrow attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effHZ-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effPlZ + ggtitle("Predicted (zero-inflated) effect of wide attacks on posts") +
    xlab("wide attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effPlZ-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effPhZ + ggtitle("Predicted (zero-inflated) effect of narrow attacks on posts") +
    xlab("narrow attacks")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effPhZ-1.png" width="100%" style="display: block; margin: auto;" />

``` r
effAZ + ggtitle("Predicted (zero-inflated) effect of previous activity") +
    xlab("activity before")
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/effAZ-1.png" width="100%" style="display: block; margin: auto;" />

``` r
EffSumHighTable <- baseEffDf[0:20, ]
EffSumHighTable[, 4] <- 0:19
EffSumHighTable$prediction <- predict(HNBfull, EffSumHighTable)
EffTablePosts <- rbind(EffSumHighTable$sumPhBefore, round(EffSumHighTable$prediction))
rownames(EffTablePosts) <- c("attacks", "expected activity")
EffTablePosts
```

    ##                   [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11]
    ## attacks              0    1    2    3    4    5    6    7    8     9    10
    ## expected activity   24   22   19   17   15   13   11   10    9     8     7
    ##                   [,12] [,13] [,14] [,15] [,16] [,17] [,18] [,19] [,20]
    ## attacks              11    12    13    14    15    16    17    18    19
    ## expected activity     6     6     5     5     4     4     3     3     3

One might have reasoned about our previous analyses as follows: attacks in the before period correlate with activity before, and it is activity before that is the real predictor of activity after. This could be supported by observing that the *p*-value for the hurdle model is really low for activity before. Pearson correlation coefficient for narrow attacks before and activity before is *r*(3671)≈ 0.437 and *r*(3671)≈ 0.332 for activity after. However, activity before is a much better correlate of activity after, *r*(3671)≈ 0.845 --- all correlations with *p*-value &lt;2.2*e* − 16, and regression analysis (inspect the effect plots) indicates that activity before and high attacks before actually go in the opposite directions.

``` r
attacksb <- 0:8
maxb <- max(attacks)
lowb <- numeric(max + 1)
highb <- numeric(max + 1)
mb <- numeric(max + 1)
pb <- numeric(max + 1)
tb <- list()

for (attacks in attacksb) {
    t[[attacks + 1]] <- t.test(data[data$sumHighBefore == attacks,
        ]$activityBefore)

    lowb[attacks + 1] <- t[[attacks + 1]]$conf.int[1]
    highb[attacks + 1] <- t[[attacks + 1]]$conf.int[2]
    mb[attacks + 1] <- t[[attacks + 1]]$estimate
    pb[attacks + 1] <- t[[attacks + 1]]$p.value
}
highTableb <- as.data.frame(round(rbind(0:8, lowb, mb, highb,
    pb), 3))
rownames(highTableb) <- c("attacks", "CIlow", "estimatedm", "CIhigh",
    "p-value")

before <- as.data.frame(t(highTableb))

attacksa <- 0:8
maxa <- max(attacksa)
lowa <- numeric(max + 1)
higha <- numeric(max + 1)
ma <- numeric(max + 1)
pa <- numeric(max + 1)
ta <- list()
for (attacks in attacksa) {
    ta[[attacks + 1]] <- t.test(data[data$sumHighBefore == attacks,
        ]$activityAfter)
    lowa[attacks + 1] <- ta[[attacks + 1]]$conf.int[1]
    higha[attacks + 1] <- ta[[attacks + 1]]$conf.int[2]
    ma[attacks + 1] <- ta[[attacks + 1]]$estimate
    pa[attacks + 1] <- ta[[attacks + 1]]$p.value
}
highTablea <- as.data.frame(round(rbind(0:8, lowa, ma, higha,
    pa), 3))
rownames(highTablea) <- c("attacks", "CIlow", "estimatedm", "CIhigh",
    "p-value")
after <- as.data.frame(t(highTablea))

ggplot(before, aes(x = attacks, y = estimatedm)) + geom_point() +
    geom_errorbar(aes(ymin = CIlow, ymax = CIhigh), width = 0.2,
        size = 0.2, position = position_dodge(0.05)) + th + xlab("narrow attacks") +
    ylab("mean activity") + geom_line(data = after, aes(x = attacks,
    y = estimatedm), color = "skyblue") + geom_errorbar(data = after,
    aes(ymin = CIlow, ymax = CIhigh), width = 0.3, size = 0.2,
    color = "skyblue", position = position_dodge(0.05))
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/mean1-1.png" width="100%" style="display: block; margin: auto;" />

``` r
attacksb <- 0:8
maxb <- max(attacks)
lowb <- numeric(max + 1)
highb <- numeric(max + 1)
mb <- numeric(max + 1)
pb <- numeric(max + 1)
tb <- list()

for (attacks in attacksb) {
    t[[attacks + 1]] <- t.test(data[data$sumHighBefore == attacks,
        ]$activityBefore)

    lowb[attacks + 1] <- t[[attacks + 1]]$conf.int[1]
    highb[attacks + 1] <- t[[attacks + 1]]$conf.int[2]
    mb[attacks + 1] <- t[[attacks + 1]]$estimate
    pb[attacks + 1] <- t[[attacks + 1]]$p.value
}
highTableb <- as.data.frame(round(rbind(0:8, lowb, mb, highb,
    pb), 3))
rownames(highTableb) <- c("attacks", "CIlow", "estimatedm", "CIhigh",
    "p-value")

before <- as.data.frame(t(highTableb))

attacksa <- 0:8
maxa <- max(attacksa)
lowa <- numeric(max + 1)
higha <- numeric(max + 1)
ma <- numeric(max + 1)
pa <- numeric(max + 1)
ta <- list()
for (attacks in attacksa) {
    ta[[attacks + 1]] <- t.test(data[data$sumHighBefore == attacks,
        ]$activityAfter)
    lowa[attacks + 1] <- ta[[attacks + 1]]$conf.int[1]
    higha[attacks + 1] <- ta[[attacks + 1]]$conf.int[2]
    ma[attacks + 1] <- ta[[attacks + 1]]$estimate
    pa[attacks + 1] <- ta[[attacks + 1]]$p.value
}
highTablea <- as.data.frame(round(rbind(0:8, lowa, ma, higha,
    pa), 3))
rownames(highTablea) <- c("attacks", "CIlow", "estimatedm", "CIhigh",
    "p-value")
after <- as.data.frame(t(highTablea))

ggplot(before, aes(x = attacks, y = estimatedm)) + geom_point() +
    geom_errorbar(aes(ymin = CIlow, ymax = CIhigh), width = 0.2,
        size = 0.2, position = position_dodge(0.05)) + th + xlab("narrow attacks") +
    ylab("mean activity") + geom_line(data = after, aes(x = attacks,
    y = estimatedm), color = "skyblue") + geom_errorbar(data = after,
    aes(ymin = CIlow, ymax = CIhigh), width = 0.3, size = 0.2,
    color = "skyblue", position = position_dodge(0.05))
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/mean2-1.png" width="100%" style="display: block; margin: auto;" />

``` r
h0 <- data[data$sumHighBefore == 0, ]
h1 <- data[data$sumHighBefore == 1, ]
h2 <- data[data$sumHighBefore == 2, ]
h3 <- data[data$sumHighBefore == 3, ]
h4 <- data[data$sumHighBefore == 4, ]

distance <- function(x) {
    x - mean(data$sumHighBefore)
}

library(gridExtra)
grid.arrange(ggplot(h0, aes(x = distance(activityBefore), y = activityDiff)) +
    geom_point(alpha = 0.3, size = 1, position = "jitter") +
    geom_smooth(size = 0.5, alpha = 0.5) + th + xlab("distance from sample mean") +
    ggtitle("0 narrow attacks") + ylab("activity change"), ggplot(h2,
    aes(x = distance(activityBefore), y = activityDiff)) + geom_point(alpha = 0.3,
    size = 1, position = "jitter") + geom_smooth(size = 0.5,
    alpha = 0.5) + th + xlab("distance from sample mean") + ggtitle("2 narrow attacks") +
    ylab("activity change"), ggplot(h3, aes(x = distance(activityBefore),
    y = activityDiff)) + geom_point(alpha = 0.3, size = 1, position = "jitter") +
    geom_smooth(size = 0.5, alpha = 0.5) + th + xlab("distance from sample mean") +
    ggtitle("3 narrow attacks") + ylab("activity change"), ggplot(h4,
    aes(x = distance(activityBefore), y = activityDiff)) + geom_point(alpha = 0.3,
    size = 1, position = "jitter") + geom_smooth(size = 0.5,
    alpha = 0.5) + th + xlab("distance from sample mean") + ggtitle("4 narrow attacks") +
    ylab("activity change"))
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/regressionToMean-1.png" width="100%" style="display: block; margin: auto;" />

First, in an inspection of the control group, the smoothing might suggest some correlation between the distance from the mean and the activity drop. However, the sharp cut-off at the bottom is there because one cannot drop their activity below the previous activity level. So users closer to the mean didn't even have the lower options available, and this restriction might be partially responsible for the smoothing line going downwards. Moreover, Spearman correlation between the distance from the mean and the activity change is -0.269, which is fairly weak. Pearson's *ρ* is not very different ( -0.255), but we need to be careful here, because the relation doesn't seem very linear (*p*-values for correlation tests are both &lt;0.001). If, however, we follow this line of reasoning, the distance from the mean would explain only *R*<sup>2</sup>= 0.065 of the variability in the activity change in the control group.

``` r
h0 <- data[data$sumHighBefore == 0, ]
h1 <- data[data$sumHighBefore == 1, ]
h2 <- data[data$sumHighBefore == 2, ]
h3 <- data[data$sumHighBefore == 3, ]
h4 <- data[data$sumHighBefore == 4, ]

distance <- function(x) {
    x - mean(data$sumHighBefore)
}

library(gridExtra)
grid.arrange(ggplot(h0, aes(x = distance(activityBefore), y = activityScore)) +
    geom_point(alpha = 0.3, size = 1, position = "jitter") +
    geom_smooth(size = 0.5, alpha = 0.5) + th + xlab("distance from sample mean") +
    ggtitle("0 narrow attacks") + ylab("proportional activity change"),
    ggplot(h2, aes(x = distance(activityBefore), y = activityScore)) +
        geom_point(alpha = 0.3, size = 1, position = "jitter") +
        geom_smooth(size = 0.5, alpha = 0.5) + th + xlab("distance from sample mean") +
        ggtitle("2 narrow attacks") + ylab("proportional activity change"),
    ggplot(h3, aes(x = distance(activityBefore), y = activityScore)) +
        geom_point(alpha = 0.3, size = 1, position = "jitter") +
        geom_smooth(size = 0.5, alpha = 0.5) + th + xlab("distance from sample mean") +
        ggtitle("3 narrow attacks") + ylab("proportional activity change"),
    ggplot(h4, aes(x = distance(activityBefore), y = activityScore)) +
        geom_point(alpha = 0.3, size = 1, position = "jitter") +
        geom_smooth(size = 0.5, alpha = 0.5) + th + xlab("distance from sample mean") +
        ggtitle("4 narrow attacks") + ylab("proportional activity change"))
```

<img src="https://rfl-urbaniak.github.io/redditAttacks/images/regressionToMean2-1.png" width="100%" style="display: block; margin: auto;" />

``` r
iqr0 <- data[data$sumHighBefore == 0 & data$activityBefore <=
    44, ]
iqr1 <- data[data$sumHighBefore == 1 & data$activityBefore <=
    44, ]
iqr2 <- data[data$sumHighBefore == 2 & data$activityBefore <=
    44, ]
iqr3 <- data[data$sumHighBefore == 3 & data$activityBefore <=
    44, ]
iqr4 <- data[data$sumHighBefore == 4 & data$activityBefore <=
    44, ]

t.test(iqr0$activityScore)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  iqr0$activityScore
    ## t = 1.2217, df = 2383, p-value = 0.2219
    ## alternative hypothesis: true mean is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.03146482  0.13546981
    ## sample estimates:
    ##  mean of x 
    ## 0.05200249

``` r
t.test(iqr1$activityScore)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  iqr1$activityScore
    ## t = 0.98047, df = 307, p-value = 0.3276
    ## alternative hypothesis: true mean is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.1174912  0.3508613
    ## sample estimates:
    ## mean of x 
    ## 0.1166851

``` r
t.test(iqr2$activityScore)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  iqr2$activityScore
    ## t = -0.42513, df = 48, p-value = 0.6726
    ## alternative hypothesis: true mean is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.5275463  0.3433931
    ## sample estimates:
    ##  mean of x 
    ## -0.0920766

``` r
t.test(iqr3$activityScore)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  iqr3$activityScore
    ## t = -2.4104, df = 12, p-value = 0.03289
    ## alternative hypothesis: true mean is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.68256469 -0.03444387
    ## sample estimates:
    ##  mean of x 
    ## -0.3585043

``` r
t.test(iqr4$activityScore)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  iqr4$activityScore
    ## t = -5.0454, df = 6, p-value = 0.002344
    ## alternative hypothesis: true mean is not equal to 0
    ## 95 percent confidence interval:
    ##  -1.049450 -0.363969
    ## sample estimates:
    ##  mean of x 
    ## -0.7067096

``` r
library(rstatix)
data$fhigh <- as.factor(data$sumHighBefore)
data %>%
    anova_test(activityDiff ~ activityBefore + fhigh)
```

    ## ANOVA Table (type II tests)
    ## 
    ##           Effect DFn  DFd       F         p p<.05   ges
    ## 1 activityBefore   1 3651 577.220 1.53e-118     * 0.137
    ## 2          fhigh  20 3651  10.214  1.57e-31     * 0.053

Akaike, H. (1974). A new look at the statistical model identification. *IEEE Transactions on Automatic Control*, *19*(6), 716–723. <https://doi.org/10.1109/TAC.1974.1100705>

Kruschke, J. (2015). *Doing Bayesian data analysis; a tutorial with R, JAGS, and Stan*.

Ptaszyński, M., Leliwa, G., Piech, M., & Smywiński-Pohl, A. (2018). Cyberbullying detection–technical report 2/2018, Department of Computer Science AGH, University of Science and Technology. *arXiv Preprint arXiv:1808.00926*.

Tukey, J. W. (1949). Comparing individual means in the analysis of variance. *Biometrics*, *5*(2), 99. <https://doi.org/10.2307/3001913>

Valkenburg, P. M., Peter, J., & Schouten, A. P. (2006). Friend networking sites and their relationship to adolescents’ well-being and social self-esteem. *CyberPsychology & Behavior*, *9*(5), 584–590. <https://doi.org/10.1089/cpb.2006.9.584>

Wise, K., Hamman, B., & Thorson, K. (2006). Moderation, response rate, and message interactivity: Features of online communities and their effects on intent to participate. *Journal of Computer-Mediated Communication*, *12*(1), 24–41. <https://doi.org/10.1111/j.1083-6101.2006.00313.x>

Wroczynski, M., & Leliwa, G. (2019). *System and method for detecting undesirable and potentially harmful online behavior*. Google Patents.

Zong, W., Yang, J., & Bao, Z. (2019). Social network fatigue affecting continuance intention of social networking services. *Data Technologies and Applications*. <https://doi.org/10.1108/dta-06-2018-0054>

[1] <https://www.samurailabs.ai/>, described in (Ptaszyński, Leliwa, Piech, & Smywiński-Pohl, 2018; Wroczynski & Leliwa, 2019).
