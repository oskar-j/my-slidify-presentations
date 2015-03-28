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
