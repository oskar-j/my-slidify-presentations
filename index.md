---
title       : GitHub discussion pages
subtitle    : First glance at text-data
author      : Oskar Jarczyk
job         : Powered by R, Slidify, FTW!
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      #
widgets     : [mathjax, quiz, bootstrap] # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Presentation agenda

1. How I gathered discussions from the GitHub,
2. Getting more insights into what's there,
  * global buzz-having repositories and small teams as well
  * all of them are coordinating their work through written communication
  * calculated simple yet meaningfull statistics
3. The discussion network,
  * vaious definitions, multiple subnetworks, but same data
  * more than one scope of such network
  * a true social network - people who spoke and/or coded together and/or follow(-ed) each other..
4. What I found out, some results,
  * you will be the very first few in the world, to who I will present some interesting findings about utterances on the GitHub
5. Summary and Q&A time.

<div class="well well-sm">
<p> <b>Note: </b> You can hit <code>[P] key</code> on any slide to reveal the source code. </p>
</div>



--- .class #id 

## Handouts

<div class='well'>
<p><b>You can download this presentation offline here:</b></p>
<p><a href='https://github.com/oskar-j/slidify-presentations-topic1'>https://github.com/oskar-j/slidify-presentations-topic1</a></p>
</div>
<div class='well'>
<p><b>Sources and data</b> is available here:</p>
<p><a href='https://github.com/wikiteams/gh-torrent-queries'>https://github.com/wikiteams/gh-torrent-queries</a></p>
<p><a href='https://github.com/oskar-j/slidify-presentations-topic1'>https://github.com/oskar-j/slidify-presentations-topic1</a></p>
<p><a href='https://github.com/wikiteams/linda-nlp'>https://github.com/wikiteams/linda-nlp</a></p>
</div>
<div class='well'>
<p><b>Draft</b> paper with raw data:</p>
<p><a href='https://dl.dropboxusercontent.com/u/103068909/recognizing-dialogue-acts-on-github-abstract.pdf'>https://dl.dropboxusercontent.com/u/103068909/recognizing-dialogue-acts-on-github-abstract.pdf</a></p>
</div>

--- &radio

## Quiz

In which way would you describe the discussion dimension in the GitHub portal?

1. _A feedback mechanism, place for discussion, bug-list and task delegation, accessible through GitHub webpages. It is a dialogue between developers and/or users held under a code change, code integration or issue submission._
2. An exchange postbox, available as newsgroup protocol, created automaticly for every GitHub code repository, which you can add to e.g. Microsoft Outlook and automaticly get new messages.
3. Exchanging messages between programmers strictly through <i>git commit</i> messages and other git features like <i>git blame</i>.
4. None of those.

*** .hint

Programmers on GitHub discuss their work and ask for pull-requests (of code they created) with help of the GitHub web interface. In very rare cases, someone can have an external tool to submit comments through GitHub API.

*** .explanation

**2nd** is incorrect, despite the fact you can get notifications on your e-mail about new comments, there is no such thing as a seperate newsgroup. **3rd** is incorrect - while of course proper title of the commit is an important part of communication inside the team, the main action is happening on the github pages, under particular commit / issue / pull request pages. **1st answer is correct**.

---

## Where discussion is taking place?

<div class='well'>
<p>Please visit this <b>'developer's manual'</b> for better insight:</p>
<p><a href="https://developer.github.com/guides/working-with-comments/">https://developer.github.com/guides/working-with-comments/</a></p>
</div>
<div class='well'>
<p>If you are less familiar with GitHub, start with <b>'the guide':</b></p>
<p><a href="https://guides.github.com/activities/hello-world/#intro">https://guides.github.com/activities/hello-world/#intro</a></p>
<p>It's also called "Hello World in 10 minutes"</p>
</div>

---

### What you need to know

* Discussions, same as wiki pages and `README` files, use a `Markdown` syntax
* They also have emoticons placed between double-colons, e.g. `:+1:`
* You can cite somebody or call him by login (with the `'@'` char)
* Keep in mind that discussion always occurs under a change or integration request (pull request) or issue submission
* You can paste code blocks and ony objects supported by Markdown syntax
* Detecting quoting is tricky, but in most cases, it is recognized by this pattern:
  * starts with: `"On [date] user <e-mail> wrote:"`
  * `'>'` char starting every line in-a-quote
* It can have any language used worldwide and is always (in technical terms) properly formated `UTF-8` text

--- &twocol w1:50% w2:50%
### Possible data-sources
Data acquisition. Hence **3** types of discussions: dialogue under issue/feature page, dialogue under a code commit, and a dialogue page under a pull request page. And you can get them from:

*** =left

**GitHub Archive**
- document-oriented JSON data
- document structure (MongoDB), vulnerable to constant change
- unlimited time periods and easy refill from the GitHub Archive (wget -> mongoimport)
- includes only a full body of *PullRequest* comment, rest of utterances one needs to download directly from the GitHub through web
- includes much more of *meta-information*!

*** =right

**GitHub Torrent**
- table-suctured relational data
- well structured - they're in defined MySQL database tables
- time period limited to the date of last SQL dumps
- includes the body (message) of only *PullRequest* comment and a *Commit* comment, body **is truncated to 256 chars** :(
- includes additional information about *timestamp, author, and commit id / pull request id*, but nothing more in particulat table..

---

### Possible data-sources (2)

For rapid data analysis, you can try using `Google BigQuery`, there is GitHub archive data (called `timeline`) already included in fast engine using propertiary BigQuery Language (BQL).

Alternatively, you can use GitHub Torrent `MySQL web-interface`, but don't expect good relability neither performance.

Web-scrapping always requires executing JavaScript.

<div class='well'>
<p>The best of course is using local copy of GHA / GHT data.</p>
</div>

When using MySQL, set encoding collation to `utf8_unicode_ci`.

---

## Creating discussion network

Data genesis

1. I made union of `Commit Comments` and `Pull Request Comments` in MySQL instance of [GitHub Torrent](http://ghtorrent.org/relational.html)
2. Loaded into `R` and joined with `GitHub users`
   
   ```r
   dialogues_n_users <- sqldf("select d.*, u.login from dialogues d join users u on d.user_id = u.id");
   ```
   
   ```r
   > nrow(dialogues_n_users)
   [1] 2923703
   ```
3. Count contributions per discussion page
   
   ```r
   aggregates <- sqldf("select commit_id, login, count(login) as n from dialogues_n_users d group by commit_id, login");
   ```
   
   ```r
   > nrow(aggregates)
   [1] 1273025
   ```

---

## Creating discussion network (2)


```r
> summary(aggregates[aggregates$n < 50, c('n')])
   Min.     1st Qu.  Median   Mean     3rd Qu.  Max.
   1.000    1.000    1.000    2.297    2.000    4566.000
```
![aggregates-typical-number-of-utt-under-dialogue.png](https://dl.dropboxusercontent.com/u/103068909/aggregates-typical-number-of-utt-under-dialogue.png)

---

## Creating discussion network (3)

4\. Count how many times users spoke with each other (under any discussion page - in whole GitHub)

```r
activity_network <- sqldf("SELECT a1.login as login1, a2.login as login2,
                              a1.n as c1, a2.n as c2
                              FROM aggregates a1
                              LEFT JOIN aggregates a2
                              ON a1.commit_id = a2.commit_id
                              WHERE a1.login < a2.login;")
network <- sqldf("SELECT login1, login2, count(*) as weight from activity_network group by login1, login2")
network_matrix <- as.matrix(network)
```

```r
> summary(network[network$weight < 500, c('weight')])
   Min.     1st Qu.  Median   Mean     3rd Qu.  Max.
   1.000    1.000    1.000    1.243    1.000    431.000
> nrow(network)
[1] 1340327
```

5\. Returns a matrix of **unique paris (Vx, Vy)**

---

## Creating discussion network (3)


```r
g = graph.edgelist(network_matrix[,1:2],directed=FALSE)
E(g)$weight=as.numeric(network_matrix[,3])
# Don't call plot where >1 milion nodes, reduce first
# plot(g,layout=layout.fruchterman.reingold,edge.width=E(g)$weight)
```
<center>
<img src="https://dl.dropboxusercontent.com/u/103068909/matrix.png" width="50%" height="50%" />
</center>

---

## Network schema

* **Discussion** network

```{wolfram, echo=TRUE}
Graph[{B \[UndirectedEdge] A}]
```
<img width="410" height="114" src="https://dl.dropboxusercontent.com/u/103068909/siec1.png"/>

* **Citing** network
* **Mentioning** network
* (both can be combined to one network)

```{wolfram, echo=TRUE}
Graph[{B \[DirectedEdge] A}]
```
<img width="410" height="114" src="https://dl.dropboxusercontent.com/u/103068909/siec2.png"/>

---

## Network properties


```r
> summary(dialogues_n_users)
```
<img src="https://dl.dropboxusercontent.com/u/103068909/summary_dialogues.png" />

```r
> summary(network_matrix)
```
<img src="https://dl.dropboxusercontent.com/u/103068909/summary_matrix.png" />

---

## Network properties (2)

<div class='well'>
<p>Calculating any properties at all in a reasonable period of time was unreal. Even when using the cutoff parameter (where possible), I got nothing.</p>
</div>


```r
library(igraph)

mycutoff <- 3

betweenness(g, directed = FALSE, weights = E(g)$weight, normalized = FALSE)
edge.betweenness(g, directed = FALSE, weights = E(g)$weight)
betweenness.estimate(g, directed = FALSE, cutoff = mycutoff,
                     weights = E(g)$weight, nobigint = TRUE)

walktrap.community(g, weights = E(g)$weight, steps = 4, merges =
                      TRUE, modularity = TRUE, membership = TRUE)
fastgreedy.community(g, merges=TRUE, modularity=TRUE,
                     membership=TRUE, weights=E(g)$weight)
```

---

## (Smaller) sample discussion network

```{sql}
create table github_discussions_selected_users as select d.* from github_discussions d join (select distinct user_id from project_members_with_owners pm join selected_repos sr on pm.repo_id = sr.repo_id) as s
on d.user_id = s.user_id;
```

* *Selected repos* is a sample created joined with a list of users (project members) but *from repositories*
   * having at least 5 project members
   * existing at least for 2 years
   * with minimum of 100 commits
* Number of utterances downgraded slightly - from 2.9 mln to 1.5 mln :(

---

## Swear words


```r
library(sqldf)
library(plyr)
library(rCharts)

swear_words <- read.csv("C:/big data/swearing.csv")
names(swear_words)[1] <- "entry"
swear_words$entry <- as.character(swear_words$entry)
swear_matched <- sqldf("select * from dialogues_n_users where body like '%" + famous_word + "%';")
short.date = strftime(swear_matched$created_at, "%Y/%m")
count_swear_dates <- count(short.date)

n1 <- rPlot(freq ~ x, data = count_swear_dates, type = "point")
```

---

## Swear words (2)


```r
load(file="swear_plot_obj.RData")
# n1$print("chart_swear_words")
n1 # -- won't show up in browser, issue bug to slidify maybe?
```

<iframe src=' assets/fig/unnamed-chunk-14-1.html ' scrolling='no' frameBorder='0' seamless class='rChart polycharts ' id=iframe- chart25901f846207 ></iframe> <style>iframe.rChart{ width: 100%; height: 400px;}</style>

<!-- <center>
<img src="https://dl.dropboxusercontent.com/u/103068909/swearing.png" />
</center> -->

---

## NLP analysis

```{python, eval=FALSE, echo=TRUE}
from textblob import TextBlob
text_data = gracefully_degrade_to_ascii(remove_control_characters(line[2]))
sentyment = text_data.sentiment.polarity
sentyment_subj = text_data.sentiment.subjectivity
```

* Utterances with positive sentiment: 1018370
* Utterances with negative sentiment: 1905329
* Mean sentiment for positive: 0.297915856077
* Mean sentiment for negative: -0.0507566802789
* Utterances with subjectivity: 1708393
* Utterances with 0(none) subjectivity: 1215306
* Mean subjectivity (for > 0): 0.502911222599

---

## NLP analysis (2)

<center>
![Sentiment through time](https://dl.dropboxusercontent.com/u/103068909/sentiment.png "Sentiment through time")
</center>

---

## Multilayer analysis

1. muxViz - Visualization of interconnected multilayer networks
  * aditionaly allows to e.g. make multilayer centrality analysis etc.
2. Different algorithms for connecting layers
  * the most simple is (n-x/n)
  * it means edge in at least 2 layers of 3 is required
3. Possible to detect communities in such multilayered networks

---

## Recognizing dialogue acts

1. In short - every utterances have 1 or more dialogue acts (it's a type of speech classification)
2. It's a microtask for human, but we can tag a represantative dataset and apply supervised machine learning to classify rest of the dialogues
3. Apply the [tf-idf algorithm](https://gist.github.com/oskar-j/181813226e7c4fa9c3c0) to select maximally diverse set of utterances.
```{python}
from sklearn.feature_extraction.text import TfidfVectorizer
```
4. Tag them with min 2 person team and ask a 3rd person (judge) to resolve doubts.

---

## Text annotation tools

* There is a good list on Quora: ["Natural Language Processing: What are the best tools for manually annotating a text corpus with entities and relationships?"](http://www.quora.com/Natural-Language-Processing/What-are-the-best-tools-for-manually-annotating-a-text-corpus-with-entities-and-relationships)
* In my humble opinion, stay away from BRAT Annotation Tool and some old standalone programs for tagging - they are not scalable and very often buggy.
* At this time I used the [GATE Teamware](http://sourceforge.net/p/gate/code/HEAD/tree/teamware/trunk/).

---

## First results from taggging (1st Q of 2014)

