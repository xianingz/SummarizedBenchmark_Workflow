# SummarizedBenchmark_Workflow
### ***SummarizedBenchmark_Workflow*** is an R-based platform for automated benchmarking combinatorial pipelines.

## Introduction
The benchmark of combinatorial analysis pipelines is powerful for studying the impact of each decision-making point in the analysis, but usually creates a large number of pipelines which quickly become untrackable when the number of steps or number of methods in each step increases.
There have been efforts in creating benchmarking platforms to manage datasets and algorithms while they are all designed for benchmarking methods at single analysis step. To accommodate this idea of evaluating combinatorial analysis pipeline and tackle the challenges, we developed a R-based workflow benchmarking platform: SummarizedBenchmark-Workflow. We extend the framework of SummarizedBenchmark (Kimes., et al., 2019) to enable users to setup an analysis workflow consisting of multiple analysis steps. Each individual step can be a container of multiple methods to be benchmarked. Analysis pipelines can be automatically constructed by iterating through all combinations of methods from each step and benchmarked using the same dataset simultaneously. The platform also records the peak memory occupancy during the analysis and the time cost, which are also essential points in benchmarking especially for large datasets. This platform enabled us to evaluate a large number of pipelines more efficiently. It can be used by algorithm developers to incorporate their new methods into the framework quickly. The platform generalizable to benchmarking studies in other fields. 

## Structure of the platform
![Structure of benchmarking platform](./pics/5.png)

## Combinatorial workflow
![Combinatorial workflow consisting of multiple steps](./pics/6.png)

## Usage examples
```
b <- BenchDesign(data = list(tdat = tdat)) //initiate BenchDesign object using dataset
b <- initWorkflow(b, steps = c("First","Second","Third")) //Initiate Workflow object with the names of the steps within the workflow
b <- b %>% 
    addMethodToWorkflow(step = "First",
              method_label = "pre1med",
              func = pre1med,
              params = rlang::quos(data = tdat, method="pre1med")) //Add individual method to individual steps in the workflow
              
b <- buildMethodFromWorkflow(b) //Generate combinatorial pipelines using the workflow setup before
sb <- buildBench(b, truthCols = tdat$H) //Run benchmark
```
