# Sample Statistics
In the previous two units, we studied populations and how to summarise them with statistics when the *entire* population was measured.  In other words, the measurce of center (the "mean") and measure of spread ("standard deviation") were the summary of all observations.

In the case of yield monitor, these are appropriate statistics.  In most every other agricultural reality, however, we cannot measure every individual in a population.  Instead, we only have enough *sample* the population, that is, measure a subset of individuals from the population.

This, of course, raises questions.  Was the sample (our subset) representative of the population?  If we took another random sample, would we calculate a similar mean or standard deviation?  And, perhaps, how far off could the mean of our sample be from the true population mean?

In other words, there is always uncertainty that statistics calculated from samples represent the true values of a population.  You might even say we lack complete confidence that a mean value calculated from a sample will closely estimate the mean of a population.

Enter statistics.  We can measure the variance of sample means to estimate the distribution of sample means around the true population mean.  Indeed, this is fundamental concept of research and statistics -- using the measured variance of sample statistics to determine how accurate the are in predicting population statistics.

## Samples
To measure the variation of sample means, we need at least two samples to compare.  Ideally we can gather even more.  As we will see, the more samples included in our estimates of the population mean, the more accurate we are likely to be.

A second comment, which may seem intuitive -- but at the retail level may be overlooked -- is randomization.  Samples, for example individual plants, or areas where yield will be measured, are ideally selected at random.  In reality, the plants or areas selected for measures may be less than random. When I used to count weed populations, we used square quadrats (frames) to consistently define the area that was measured.  We would throw them into different areas of the plot and count weeds where ever they landed.

The most important thing about selecting samples, however, is that the researcher work to minimize bias.  Bias is when the samples selected consistently overestimate or underestimate the population mean.  The most aggregious example of this would be a researcher who consistently and purposely sampled the highest- or lowest-measuring parts of a field.  

But bias can enter in other ways.  For example, if our weed populations were very uneven, our thrown quadrat might be more likely to skid to a stop in weedy areas.  A researcher might unconsciously choose taller plants to sample.  In August, we might be tempted to sample a corn field from the edge than walk into that sweltering, allergenic hell. 

Remember, our goal is to represent a population as accurately and as unbiasedly as our resources allow.  Accuracy means our sample means are close to the population mean.  Unbiased means our sample means are equivalently scattered above and below the population mean.


![Accuracy versus Bias](data-unit-3/bias_v_accuracy.png)

## Case Study
Once more, we will work with the Iowa soybean yield dataset from Units 1 and 2.



Let's review the structure of this dataset:

```r
head(yield)
```

```
## Simple feature collection with 6 features and 12 fields
## Geometry type: POINT
## Dimension:     XY
## Bounding box:  xmin: -93.15033 ymin: 41.66641 xmax: -93.15026 ymax: 41.66644
## Geodetic CRS:  WGS 84
##    DISTANCE SWATHWIDTH VRYIELDVOL Crop  WetMass Moisture                 Time
## 1 0.9202733          5   57.38461  174 3443.652     0.00 9/19/2016 4:45:46 PM
## 2 2.6919269          5   55.88097  174 3353.411     0.00 9/19/2016 4:45:48 PM
## 3 2.6263101          5   80.83788  174 4851.075     0.00 9/19/2016 4:45:49 PM
## 4 2.7575437          5   71.76773  174 4306.777     6.22 9/19/2016 4:45:51 PM
## 5 2.3966513          5   91.03274  174 5462.851    12.22 9/19/2016 4:45:54 PM
## 6 3.1840529          5   65.59037  174 3951.056    13.33 9/19/2016 4:45:55 PM
##    Heading VARIETY Elevation                  IsoTime yield_bu
## 1 300.1584   23A42  786.8470 2016-09-19T16:45:46.001Z 65.97034
## 2 303.6084   23A42  786.6140 2016-09-19T16:45:48.004Z 64.24158
## 3 304.3084   23A42  786.1416 2016-09-19T16:45:49.007Z 92.93246
## 4 306.2084   23A42  785.7381 2016-09-19T16:45:51.002Z 77.37348
## 5 309.2284   23A42  785.5937 2016-09-19T16:45:54.002Z 91.86380
## 6 309.7584   23A42  785.7512 2016-09-19T16:45:55.005Z 65.60115
##                     geometry
## 1 POINT (-93.15026 41.66641)
## 2 POINT (-93.15028 41.66641)
## 3 POINT (-93.15028 41.66642)
## 4  POINT (-93.1503 41.66642)
## 5 POINT (-93.15032 41.66644)
## 6 POINT (-93.15033 41.66644)
```

And map the field:

```r
plot(yield["yield_bu"])
```

<img src="03-Sample-Statistics_files/figure-html/plot_field-1.png" width="672" />

In Unit 2, we learned how to describe these data using the normal distribution model.  We learned about how the area under the normal distribution curve corresponds to the proportion of individuals within a certain range of values.  We also discussed how this proportion gave way to inferences about probability.  For example, the area under the curve that corresponded with yields from 70.0 to 79.9 represented the proportion of individuals in the yield population.  But it also represented the probability that, were you to measure selected areas at random, you would measure a yield between 70.0 and 79.9.


## Distribution of Sample Means
In the last unit, we sampled the yield from 1000 locations in the field and counted the number of observations that were equal to or greater than 70 and equal to or less than 80.

What would happen if we only sampled from 1 location.  What would be our sample mean and how close would it be to the population mean?


```r
set.seed(1776)
yield_sample = sample(yield$yield_bu, 1) %>%
      as.data.frame()
names(yield_sample) = c("yield")
ggplot(yield_sample, aes(x=yield)) +
  geom_histogram(fill="white", color="black") +
  geom_vline(xintercept = mean(yield$yield_bu), color = "red") +
  geom_vline(xintercept = mean(yield_sample$yield), color = "blue") +
  lims(x=c(55,105))
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-1-1.png" width="672" />


What would happen if we only sampled twice?


```r
set.seed(1776)
yield_sample = sample(yield$yield_bu, 2) %>%
      as.data.frame()
names(yield_sample) = c("yield")
ggplot(yield_sample, aes(x=yield)) +
  geom_histogram(fill="white", color="black") +
  geom_vline(xintercept = mean(yield$yield_bu), color = "red") +
  geom_vline(xintercept = mean(yield_sample$yield), color = "blue") +
  lims(x=c(55,105))
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-2-1.png" width="672" />

What would happen if we only sampled four times?


```r
set.seed(1776)
yield_sample = sample(yield$yield_bu, 4) %>%
      as.data.frame()
names(yield_sample) = c("yield")
ggplot(yield_sample, aes(x=yield)) +
  geom_histogram(fill="white", color="black") +
  geom_vline(xintercept = mean(yield$yield_bu), color = "red") +
  geom_vline(xintercept = mean(yield_sample$yield), color = "blue") +
  lims(x=c(55,105))
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-3-1.png" width="672" />

What would happen if we only sampled 15 times?


```r
set.seed(1776)
yield_sample = sample(yield$yield_bu, 15) %>%
      as.data.frame()
names(yield_sample) = c("yield")
ggplot(yield_sample, aes(x=yield)) +
  geom_histogram(fill="white", color="black") +
  geom_vline(xintercept = mean(yield$yield_bu), color = "red") +
  geom_vline(xintercept = mean(yield_sample$yield), color = "blue") +
  lims(x=c(55,105))
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-4-1.png" width="672" />

Nineteen times?

```r
set.seed(1776)
yield_sample = sample(yield$yield_bu, 19) %>%
      as.data.frame()
names(yield_sample) = c("yield")
ggplot(yield_sample, aes(x=yield)) +
  geom_histogram(fill="white", color="black") +
  geom_vline(xintercept = mean(yield$yield_bu), color = "red") +
  geom_vline(xintercept = mean(yield_sample$yield), color = "blue") +
  lims(x=c(55,105))
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Click on this link to access an app to help you further understand this concept: app_central_limit_theorem_normal


## Central Limit Theorem

The Central Limit Theorem states that sample means are normally distributed around the population mean.  This concept is so powerful because it allows us to calculate the probability that that a sample mean is a given distance away from the population mean.  In our yield data, for example, the Central Limit Theorem allows us to assign a probability that we would observe a sample mean of 75 bushels/acre, if the population mean is 80 bushels per acre.  More on how we calculate this in a little bit.

What is even more powerful about the Central Limit Theorem is that our sample means are likely to be normally distributed, even if the population does not follow a perfect normal distribution.

Let's take this concept to the extreme.  Suppose we had a population where every value occurred with the same frequency.  This is known as a uniform distribution.  Click on the following link to visit an app where we can explore how the sample distribution changes in response to sampling an uniform distribution: app_central_limit_theorem_uniform



## Standard Error
When we describe the spread of a normally-distributed population -- that is, all of the individuals about which we want to make inferences -- we use the population mean and standard deviation.

When we sample (measure subsets) of a population, we again use two statistics.  The *sample mean* describes the center of the samples..  The spread of the sample means is described by the *standard error of the mean* (often abbreviated to *standard error*).  The standard error is related to the standard deviation as follows:

$$SE = \frac{\sigma}{\sqrt n} $$

The standard error, SE, is equal to the standard deviation, divided by the square root of the number of samples.  This denominator is very important -- it means that our standard error grows as the number of samples increases.  Why is this important?  

The sample mean is an estimate of the true population mean.  The distribution around the sample mean describes not only the sample means, the range of possible values for the true mean.  I realize this is a fuzzy concept.  By studying the distribution of our sample values, we are able to describe the probability that the population mean is a given value.

To better understand this, please visit this link: app_number_of_samples

If you take away nothing else from this lesson, understand whether you collect 2 or 3 samples has tremendous implications for your estimate of the population mean.  4 samples is much better than 3.  Do everything you can to fight for those first few samples.  Collect as many as you can afford, especially if you are below 10 samples.

## Degrees of Freedom
In Unit 1 we first came across degrees of freedom, which was the number of observations in a population or sample, minus 1.  Degrees of Freedom are again used below in calculating the t-distribution.  So what are they and why do we use them.  Turns out there are two explanations.

In the first explanation, "degrees of freedom" refer to the number of individuals or samples that can vary independently given a fixed mean.  So for an individual data point to be free, it must be able to assume any value within a given distribution.  Since the population mean is a fixed number, only n-1 of the data are able to vary.  The last data point is determined by the value of all the other data points, plus the population mean. 

Confusing, huh?  Who starts measuring samples thinking that the data point is fixed, in any case?  But if you think about it, the purpose of the sample is approximate a real population mean out there -- which is indeed fixed.  It's just waiting for us to figure it out.  So if our sample mean is equal to the population mean (which we generally assume), then the sample mean is also fixed.  But it is a very weird way of thinking.

Yet this is the answer beloved by all the textbooks, so you should know about it.

The second answer I like better: samples normally underestimate the true population variance.  This is because the sample variance is calculated from the distribution of the data around the sample mean.  Sample data will always be closer to the sample mean -- which is by definition based on the data themselves -- then the population mean.

Think about this a minute.  Your sample data could be crazy high or low compared to the overall population.  But that dataset will define a mean, and the variance of the population will be estimated from that mean.  In many cases, it turns out that using n-1 degrees of freedom will increase the value of the sample variance so it is closer to the population variance.

## The t-Distribution
In the last unit, we used the Z-distribution to calculate the probability of observing an individual of a given value in a population, given its population mean and standard deviation.  Recall that about 68% of individuals were expected to have values within one standard deviation, or Z, of the population mean.  Approximately 95% of individuals were expected to have values within 1.96 standard deviations of the population mean.  Alternatively, we can ask what the probability is of observing individuals of a particular or greater value in the population, given its mean and standard deviation.

We can ask a similar question of our sample data: what is the probability the population mean is a given value or greater, given the sample mean?  As with the Z-distribution, the distance between the sample mean and hypothesized population mean will determine this probability.  

There is one problem, however, with using the Z-distribution: it is only applicable when the population standard deviation is *known*.  When we sample from a population, we do not know it's true standard deviation.  Instead, we are estimating it from our samples.  This requires we use a different distribution: the t-distribution.

In comparison with the Z-distribution differs from the Z-distribution in that it's shape changes as the number of samples increases.  Notice in the animation above that when the number of samples is low, the distribution is wider and has a shorter peak.  As the number of samples increase, the curve becomes narrower and taller.  This has implications for the relationship between the distance of a hypothetical population mean from the sample mean, and the probability of it being that distant.

We can prove this to ourselves using the shadeDist function in R that was introduced in the last unit.  The first argument to this function is c(-1,1), which tells r how many standard errors to shade above and below the population mean (0 in this demonstration).  The second argument, "dt", simply tells R to use the t-distribution.  


```r
library(fastGraph)
shadeDist( c(-1, 1), "dt", parm2 = 4, lower.tail = FALSE )
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-6-1.png" width="672" />

The last argument, "lower.tail = FALSE, tells R to shade the area between the t-values and zero and calculate its probability.  If we set that argument to "TRUE", R would shade the area beyond the t-values and calculate its probability.

The third argument, parm1 = 2, requires greater explanation.  2 is the degrees of freedom.  Whenever we use sample data, the degrees of freedom is equal to one less than the number of samples.  In this example, 2 degrees of freedom means 3 samples were taken from the population.  

With 4 degrees of freedom, there is about a 63% probability the population mean is within 1 standard error of the mean.  Let's decrease the sample mean to 3 degrees of freedom


```r
library(fastGraph)
shadeDist( c(-1, 1), "dt", parm2 = 3, lower.tail = FALSE )
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-7-1.png" width="672" />

With only 3 degrees of freedom (4 samples), there is only a 61% probability the population mean is within one standard error of the mean.

Now change the parm2 from 3 to 1, which would be our degree of freedom if we only had two samples.  You should see the probability that the population mean is within 1 standard error of the sample mean fall to 50%.

Set parm2 to 10 degrees of freedom (11 samples), and the probability should increase to about 66%.  Set parm2 to 30 degress of freedom, and the probability the population mean is within 1 standard error of the mean increases to 67%.  When parm2 is 50 degrees of freedom (51 samples) the probability is about 68%.  At this point, the t-distribution curve approximates the shape of the z-distribution curve.


We can sum up the relationship between the t-value and probability with this plot.  The probability of the popualation mean being within one standard error of the population mean is represented by by the red line.  The probability of of the population mean being within 2 standard errors of the mean is represented by the blue line.  As you can see, the probability of the population mean being within 1 or 2 standard errors of the sample mean increases with the degrees of freedom (df).  Exact values can be examined by tracing the curves with your mouse.


```r
df = c(1:100) %>%
  as.data.frame()
names(df) = "df"

p_from_tdf = df %>%
  mutate(p1 = ((pt(1, df)) -0.5) * 2) %>%
  mutate(p2 = ((pt(2, df)) -0.5) * 2) %>%
  gather(t, p, p1, p2) %>%
  mutate(t=gsub("p", "", t)) 
  


p = p_from_tdf %>%
  ggplot(aes(x=df, y=p, group=t)) +
  geom_point(aes(color=t))
ggplotly(p)
```

```{=html}
<div id="htmlwidget-a87a01d5bb80c7fab84e" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-a87a01d5bb80c7fab84e">{"x":{"data":[{"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100],"y":[0.5,0.577350269189626,0.60899778104423,0.626099033699941,0.636782532350877,0.644082316250418,0.649383337179793,0.653406492912666,0.656563603862086,0.65910686769794,0.661199303803798,0.662950942046416,0.664438722134577,0.665718056605343,0.666829864084524,0.667805015347021,0.668667237961321,0.669435068721816,0.670123199078875,0.670743422828291,0.671305316763536,0.671816738119329,0.672284193857141,0.672713118720215,0.673108087308159,0.673472977739384,0.673811099320273,0.674125293128339,0.674418011983806,0.67469138457397,0.674947267276466,0.675187286348902,0.675412872511149,0.675625289473794,0.675825657613961,0.676014973734873,0.676194127644582,0.676363916135592,0.676525054828617,0.676678188251709,0.676823898454046,0.676962712397013,0.677095108320392,0.677221521245691,0.677342347750039,0.67745795012101,0.677568659984033,0.677674781478883,0.677776594049325,0.677874354899755,0.677968301164348,0.678058651827166,0.678145609425989,0.678229361567756,0.678310082279472,0.678387933215054,0.678463064735733,0.678535616879184,0.678605720230555,0.678673496706753,0.67873906026394,0.678802517536832,0.678863968417374,0.67892350657939,0.678981219954985,0.679037191167821,0.679091497927738,0.679144213390689,0.679195406487495,0.679245142224526,0.679293481959066,0.679340483651808,0.679386202098682,0.67943068914394,0.679473993876258,0.679516162809411,0.679557240048914,0.679597267445885,0.679636284739268,0.679674329687418,0.679711438189968,0.679747644400813,0.679782980832949,0.679817478455847,0.679851166785973,0.679884073971013,0.679916226868305,0.679947651117946,0.679978371210971,0.680008410553015,0.680037791523777,0.680066535532626,0.680094663070621,0.680122193759232,0.680149146395973,0.680175538997213,0.680201388838328,0.680226712491411,0.680251525860698,0.680275844215876],"text":["t: 1<br />df:   1<br />p: 0.5000000<br />t: 1","t: 1<br />df:   2<br />p: 0.5773503<br />t: 1","t: 1<br />df:   3<br />p: 0.6089978<br />t: 1","t: 1<br />df:   4<br />p: 0.6260990<br />t: 1","t: 1<br />df:   5<br />p: 0.6367825<br />t: 1","t: 1<br />df:   6<br />p: 0.6440823<br />t: 1","t: 1<br />df:   7<br />p: 0.6493833<br />t: 1","t: 1<br />df:   8<br />p: 0.6534065<br />t: 1","t: 1<br />df:   9<br />p: 0.6565636<br />t: 1","t: 1<br />df:  10<br />p: 0.6591069<br />t: 1","t: 1<br />df:  11<br />p: 0.6611993<br />t: 1","t: 1<br />df:  12<br />p: 0.6629509<br />t: 1","t: 1<br />df:  13<br />p: 0.6644387<br />t: 1","t: 1<br />df:  14<br />p: 0.6657181<br />t: 1","t: 1<br />df:  15<br />p: 0.6668299<br />t: 1","t: 1<br />df:  16<br />p: 0.6678050<br />t: 1","t: 1<br />df:  17<br />p: 0.6686672<br />t: 1","t: 1<br />df:  18<br />p: 0.6694351<br />t: 1","t: 1<br />df:  19<br />p: 0.6701232<br />t: 1","t: 1<br />df:  20<br />p: 0.6707434<br />t: 1","t: 1<br />df:  21<br />p: 0.6713053<br />t: 1","t: 1<br />df:  22<br />p: 0.6718167<br />t: 1","t: 1<br />df:  23<br />p: 0.6722842<br />t: 1","t: 1<br />df:  24<br />p: 0.6727131<br />t: 1","t: 1<br />df:  25<br />p: 0.6731081<br />t: 1","t: 1<br />df:  26<br />p: 0.6734730<br />t: 1","t: 1<br />df:  27<br />p: 0.6738111<br />t: 1","t: 1<br />df:  28<br />p: 0.6741253<br />t: 1","t: 1<br />df:  29<br />p: 0.6744180<br />t: 1","t: 1<br />df:  30<br />p: 0.6746914<br />t: 1","t: 1<br />df:  31<br />p: 0.6749473<br />t: 1","t: 1<br />df:  32<br />p: 0.6751873<br />t: 1","t: 1<br />df:  33<br />p: 0.6754129<br />t: 1","t: 1<br />df:  34<br />p: 0.6756253<br />t: 1","t: 1<br />df:  35<br />p: 0.6758257<br />t: 1","t: 1<br />df:  36<br />p: 0.6760150<br />t: 1","t: 1<br />df:  37<br />p: 0.6761941<br />t: 1","t: 1<br />df:  38<br />p: 0.6763639<br />t: 1","t: 1<br />df:  39<br />p: 0.6765251<br />t: 1","t: 1<br />df:  40<br />p: 0.6766782<br />t: 1","t: 1<br />df:  41<br />p: 0.6768239<br />t: 1","t: 1<br />df:  42<br />p: 0.6769627<br />t: 1","t: 1<br />df:  43<br />p: 0.6770951<br />t: 1","t: 1<br />df:  44<br />p: 0.6772215<br />t: 1","t: 1<br />df:  45<br />p: 0.6773423<br />t: 1","t: 1<br />df:  46<br />p: 0.6774580<br />t: 1","t: 1<br />df:  47<br />p: 0.6775687<br />t: 1","t: 1<br />df:  48<br />p: 0.6776748<br />t: 1","t: 1<br />df:  49<br />p: 0.6777766<br />t: 1","t: 1<br />df:  50<br />p: 0.6778744<br />t: 1","t: 1<br />df:  51<br />p: 0.6779683<br />t: 1","t: 1<br />df:  52<br />p: 0.6780587<br />t: 1","t: 1<br />df:  53<br />p: 0.6781456<br />t: 1","t: 1<br />df:  54<br />p: 0.6782294<br />t: 1","t: 1<br />df:  55<br />p: 0.6783101<br />t: 1","t: 1<br />df:  56<br />p: 0.6783879<br />t: 1","t: 1<br />df:  57<br />p: 0.6784631<br />t: 1","t: 1<br />df:  58<br />p: 0.6785356<br />t: 1","t: 1<br />df:  59<br />p: 0.6786057<br />t: 1","t: 1<br />df:  60<br />p: 0.6786735<br />t: 1","t: 1<br />df:  61<br />p: 0.6787391<br />t: 1","t: 1<br />df:  62<br />p: 0.6788025<br />t: 1","t: 1<br />df:  63<br />p: 0.6788640<br />t: 1","t: 1<br />df:  64<br />p: 0.6789235<br />t: 1","t: 1<br />df:  65<br />p: 0.6789812<br />t: 1","t: 1<br />df:  66<br />p: 0.6790372<br />t: 1","t: 1<br />df:  67<br />p: 0.6790915<br />t: 1","t: 1<br />df:  68<br />p: 0.6791442<br />t: 1","t: 1<br />df:  69<br />p: 0.6791954<br />t: 1","t: 1<br />df:  70<br />p: 0.6792451<br />t: 1","t: 1<br />df:  71<br />p: 0.6792935<br />t: 1","t: 1<br />df:  72<br />p: 0.6793405<br />t: 1","t: 1<br />df:  73<br />p: 0.6793862<br />t: 1","t: 1<br />df:  74<br />p: 0.6794307<br />t: 1","t: 1<br />df:  75<br />p: 0.6794740<br />t: 1","t: 1<br />df:  76<br />p: 0.6795162<br />t: 1","t: 1<br />df:  77<br />p: 0.6795572<br />t: 1","t: 1<br />df:  78<br />p: 0.6795973<br />t: 1","t: 1<br />df:  79<br />p: 0.6796363<br />t: 1","t: 1<br />df:  80<br />p: 0.6796743<br />t: 1","t: 1<br />df:  81<br />p: 0.6797114<br />t: 1","t: 1<br />df:  82<br />p: 0.6797476<br />t: 1","t: 1<br />df:  83<br />p: 0.6797830<br />t: 1","t: 1<br />df:  84<br />p: 0.6798175<br />t: 1","t: 1<br />df:  85<br />p: 0.6798512<br />t: 1","t: 1<br />df:  86<br />p: 0.6798841<br />t: 1","t: 1<br />df:  87<br />p: 0.6799162<br />t: 1","t: 1<br />df:  88<br />p: 0.6799477<br />t: 1","t: 1<br />df:  89<br />p: 0.6799784<br />t: 1","t: 1<br />df:  90<br />p: 0.6800084<br />t: 1","t: 1<br />df:  91<br />p: 0.6800378<br />t: 1","t: 1<br />df:  92<br />p: 0.6800665<br />t: 1","t: 1<br />df:  93<br />p: 0.6800947<br />t: 1","t: 1<br />df:  94<br />p: 0.6801222<br />t: 1","t: 1<br />df:  95<br />p: 0.6801491<br />t: 1","t: 1<br />df:  96<br />p: 0.6801755<br />t: 1","t: 1<br />df:  97<br />p: 0.6802014<br />t: 1","t: 1<br />df:  98<br />p: 0.6802267<br />t: 1","t: 1<br />df:  99<br />p: 0.6802515<br />t: 1","t: 1<br />df: 100<br />p: 0.6802758<br />t: 1"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(248,118,109,1)"}},"hoveron":"points","name":"1","legendgroup":"1","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100],"y":[0.704832764699133,0.816496580927726,0.860674031441157,0.883883476483184,0.898060521170142,0.907573688468325,0.914380671437024,0.919483762042737,0.923447176229299,0.926611965229259,0.929196044931965,0.931344985961914,0.933159642351746,0.934712047110888,0.93605499271528,0.937228036485397,0.938261393469881,0.939178534330668,0.939997963613902,0.940734464553429,0.94139998795129,0.942004298297504,0.942555451007917,0.943060150063408,0.943524019573103,0.943951812470487,0.944347572671962,0.944714762358043,0.945056362817033,0.945374955037017,0.945672784632824,0.94595181454561,0.946213768117454,0.94646016452955,0.946692348136803,0.946911512890115,0.947118722779265,0.947314929032333,0.947500984656145,0.947677656784951,0.947845637213081,0.948005551415516,0.948157966303545,0.948303396917609,0.948442312223356,0.948575140147951,0.948702271970294,0.94882406615976,0.948940851742582,0.949052931262307,0.949160583390257,0.949264065233337,0.94936361437931,0.94945945071374,0.949551778037771,0.949640785511757,0.949726648946205,0.949809531958552,0.949889587011756,0.949966956348542,0.95004177283334,0.950114160712357,0.950184236300955,0.950252108606275,0.950317879892141,0.950381646192383,0.950443497777978,0.950503519582798,0.950561791592176,0.95061838919802,0.950673383523782,0.950726841722246,0.950778827248721,0.950829400111998,0.950878617105145,0.950926532018005,0.950973195833069,0.951018656906219,0.951062961133686,0.951106152106441,0.951148271253098,0.951189357972323,0.951229449755632,0.951268582301384,0.951306789620694,0.951344104135932,0.951380556772398,0.951416177043729,0.951450993131517,0.951485031959613,0.951518319263497,0.951550879655121,0.951582736683549,0.951613912891702,0.951644429869528,0.951674308303814,0.951703568024918,0.951732228050632,0.951760306627367,0.951787821268866],"text":["t: 2<br />df:   1<br />p: 0.7048328<br />t: 2","t: 2<br />df:   2<br />p: 0.8164966<br />t: 2","t: 2<br />df:   3<br />p: 0.8606740<br />t: 2","t: 2<br />df:   4<br />p: 0.8838835<br />t: 2","t: 2<br />df:   5<br />p: 0.8980605<br />t: 2","t: 2<br />df:   6<br />p: 0.9075737<br />t: 2","t: 2<br />df:   7<br />p: 0.9143807<br />t: 2","t: 2<br />df:   8<br />p: 0.9194838<br />t: 2","t: 2<br />df:   9<br />p: 0.9234472<br />t: 2","t: 2<br />df:  10<br />p: 0.9266120<br />t: 2","t: 2<br />df:  11<br />p: 0.9291960<br />t: 2","t: 2<br />df:  12<br />p: 0.9313450<br />t: 2","t: 2<br />df:  13<br />p: 0.9331596<br />t: 2","t: 2<br />df:  14<br />p: 0.9347120<br />t: 2","t: 2<br />df:  15<br />p: 0.9360550<br />t: 2","t: 2<br />df:  16<br />p: 0.9372280<br />t: 2","t: 2<br />df:  17<br />p: 0.9382614<br />t: 2","t: 2<br />df:  18<br />p: 0.9391785<br />t: 2","t: 2<br />df:  19<br />p: 0.9399980<br />t: 2","t: 2<br />df:  20<br />p: 0.9407345<br />t: 2","t: 2<br />df:  21<br />p: 0.9414000<br />t: 2","t: 2<br />df:  22<br />p: 0.9420043<br />t: 2","t: 2<br />df:  23<br />p: 0.9425555<br />t: 2","t: 2<br />df:  24<br />p: 0.9430602<br />t: 2","t: 2<br />df:  25<br />p: 0.9435240<br />t: 2","t: 2<br />df:  26<br />p: 0.9439518<br />t: 2","t: 2<br />df:  27<br />p: 0.9443476<br />t: 2","t: 2<br />df:  28<br />p: 0.9447148<br />t: 2","t: 2<br />df:  29<br />p: 0.9450564<br />t: 2","t: 2<br />df:  30<br />p: 0.9453750<br />t: 2","t: 2<br />df:  31<br />p: 0.9456728<br />t: 2","t: 2<br />df:  32<br />p: 0.9459518<br />t: 2","t: 2<br />df:  33<br />p: 0.9462138<br />t: 2","t: 2<br />df:  34<br />p: 0.9464602<br />t: 2","t: 2<br />df:  35<br />p: 0.9466923<br />t: 2","t: 2<br />df:  36<br />p: 0.9469115<br />t: 2","t: 2<br />df:  37<br />p: 0.9471187<br />t: 2","t: 2<br />df:  38<br />p: 0.9473149<br />t: 2","t: 2<br />df:  39<br />p: 0.9475010<br />t: 2","t: 2<br />df:  40<br />p: 0.9476777<br />t: 2","t: 2<br />df:  41<br />p: 0.9478456<br />t: 2","t: 2<br />df:  42<br />p: 0.9480056<br />t: 2","t: 2<br />df:  43<br />p: 0.9481580<br />t: 2","t: 2<br />df:  44<br />p: 0.9483034<br />t: 2","t: 2<br />df:  45<br />p: 0.9484423<br />t: 2","t: 2<br />df:  46<br />p: 0.9485751<br />t: 2","t: 2<br />df:  47<br />p: 0.9487023<br />t: 2","t: 2<br />df:  48<br />p: 0.9488241<br />t: 2","t: 2<br />df:  49<br />p: 0.9489409<br />t: 2","t: 2<br />df:  50<br />p: 0.9490529<br />t: 2","t: 2<br />df:  51<br />p: 0.9491606<br />t: 2","t: 2<br />df:  52<br />p: 0.9492641<br />t: 2","t: 2<br />df:  53<br />p: 0.9493636<br />t: 2","t: 2<br />df:  54<br />p: 0.9494595<br />t: 2","t: 2<br />df:  55<br />p: 0.9495518<br />t: 2","t: 2<br />df:  56<br />p: 0.9496408<br />t: 2","t: 2<br />df:  57<br />p: 0.9497266<br />t: 2","t: 2<br />df:  58<br />p: 0.9498095<br />t: 2","t: 2<br />df:  59<br />p: 0.9498896<br />t: 2","t: 2<br />df:  60<br />p: 0.9499670<br />t: 2","t: 2<br />df:  61<br />p: 0.9500418<br />t: 2","t: 2<br />df:  62<br />p: 0.9501142<br />t: 2","t: 2<br />df:  63<br />p: 0.9501842<br />t: 2","t: 2<br />df:  64<br />p: 0.9502521<br />t: 2","t: 2<br />df:  65<br />p: 0.9503179<br />t: 2","t: 2<br />df:  66<br />p: 0.9503816<br />t: 2","t: 2<br />df:  67<br />p: 0.9504435<br />t: 2","t: 2<br />df:  68<br />p: 0.9505035<br />t: 2","t: 2<br />df:  69<br />p: 0.9505618<br />t: 2","t: 2<br />df:  70<br />p: 0.9506184<br />t: 2","t: 2<br />df:  71<br />p: 0.9506734<br />t: 2","t: 2<br />df:  72<br />p: 0.9507268<br />t: 2","t: 2<br />df:  73<br />p: 0.9507788<br />t: 2","t: 2<br />df:  74<br />p: 0.9508294<br />t: 2","t: 2<br />df:  75<br />p: 0.9508786<br />t: 2","t: 2<br />df:  76<br />p: 0.9509265<br />t: 2","t: 2<br />df:  77<br />p: 0.9509732<br />t: 2","t: 2<br />df:  78<br />p: 0.9510187<br />t: 2","t: 2<br />df:  79<br />p: 0.9510630<br />t: 2","t: 2<br />df:  80<br />p: 0.9511062<br />t: 2","t: 2<br />df:  81<br />p: 0.9511483<br />t: 2","t: 2<br />df:  82<br />p: 0.9511894<br />t: 2","t: 2<br />df:  83<br />p: 0.9512294<br />t: 2","t: 2<br />df:  84<br />p: 0.9512686<br />t: 2","t: 2<br />df:  85<br />p: 0.9513068<br />t: 2","t: 2<br />df:  86<br />p: 0.9513441<br />t: 2","t: 2<br />df:  87<br />p: 0.9513806<br />t: 2","t: 2<br />df:  88<br />p: 0.9514162<br />t: 2","t: 2<br />df:  89<br />p: 0.9514510<br />t: 2","t: 2<br />df:  90<br />p: 0.9514850<br />t: 2","t: 2<br />df:  91<br />p: 0.9515183<br />t: 2","t: 2<br />df:  92<br />p: 0.9515509<br />t: 2","t: 2<br />df:  93<br />p: 0.9515827<br />t: 2","t: 2<br />df:  94<br />p: 0.9516139<br />t: 2","t: 2<br />df:  95<br />p: 0.9516444<br />t: 2","t: 2<br />df:  96<br />p: 0.9516743<br />t: 2","t: 2<br />df:  97<br />p: 0.9517036<br />t: 2","t: 2<br />df:  98<br />p: 0.9517322<br />t: 2","t: 2<br />df:  99<br />p: 0.9517603<br />t: 2","t: 2<br />df: 100<br />p: 0.9517878<br />t: 2"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,191,196,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,191,196,1)"}},"hoveron":"points","name":"2","legendgroup":"2","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":26.2283105022831,"r":7.30593607305936,"b":40.1826484018265,"l":43.1050228310502},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-3.95,104.95],"tickmode":"array","ticktext":["0","25","50","75","100"],"tickvals":[-4.44089209850063e-16,25,50,75,100],"categoryorder":"array","categoryarray":["0","25","50","75","100"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"df","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.477410608936557,0.974377212332309],"tickmode":"array","ticktext":["0.5","0.6","0.7","0.8","0.9"],"tickvals":[0.5,0.6,0.7,0.8,0.9],"categoryorder":"array","categoryarray":["0.5","0.6","0.7","0.8","0.9"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"p","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"y":0.96751968503937},"annotations":[{"text":"t","x":1.02,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"left","yanchor":"bottom","legendTitle":true}],"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"2bf45ca943c4":{"colour":{},"x":{},"y":{},"type":"scatter"}},"cur_data":"2bf45ca943c4","visdat":{"2bf45ca943c4":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```


Conversely, the t-value associated with a given proportion / probability will also decrease as the degrees of freedom increase.  The read line represents the t-values that define the area with a 68% chance of including the population mean.  The blue line represents the t-values that define the area with a 95% chance of including the population mean.  Exact values can be examined by tracing the curves with your mouse. Notice the t-value associated with a 68% chance of including the population mean approaches 1, while the t-value associated with a 95% chance approaches about 1.98.


```r
df = c(2:100) %>%
  as.data.frame()
names(df) = "df"


t_from_pdf = df %>%
  mutate(t68 = qt(0.84, df)) %>%
  mutate(t95 = qt(0.975, df)) %>%
  gather(p, t, t68, t95) %>%
  mutate(p=gsub("t", "", p)) 

p = t_from_pdf %>%
  ggplot(aes(x=df, y=t, group=p)) +
  geom_point(aes(color=p))
ggplotly(p)
```

```{=html}
<div id="htmlwidget-04eb70d68648fe50d640" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-04eb70d68648fe50d640">{"x":{"data":[{"x":[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100],"y":[1.31157847467778,1.18892863647702,1.13439663797405,1.10366827295606,1.08397567912796,1.07028739627429,1.0602240025299,1.05251548909581,1.04642261049796,1.04148601211774,1.03740529350532,1.03397576193416,1.03105314588773,1.0285328423444,1.02633716479475,1.02440721171647,1.02269751409714,1.02117241392535,1.01980355411531,1.01856810136818,1.01744746392165,1.016426350566,1.01549206948097,1.01463399850228,1.01384317984093,1.013112006434,1.01243397663771,1.01180350050043,1.01121574539243,1.01066651197068,1.01015213374546,1.00966939517081,1.00921546439204,1.00878783767945,1.00838429324589,1.00800285265016,1.00764174837135,1.0072993964331,1.00697437318342,1.00666539551235,1.00637130392802,1.00609104802069,1.00582367393047,1.00556831350406,1.00532417488059,1.00509053429156,1.00486672889619,1.00465215050263,1.00444624004993,1.00424848274542,1.00405840376827,1.00387556446397,1.00369955896537,1.00353001118565,1.00336657213621,1.0032089175293,1.00305674563075,1.00290977533284,1.00276774442144,1.00263040801501,1.00249753715574,1.00236891753601,1.0022443483451,1.00212364122313,1.0020066193109,1.00189311638528,1.00178297607159,1.00167605112485,1.00157220277313,1.00147130011672,1.00137321957771,1.0012778443952,1.00118506416158,1.00109477439624,1.00100687615312,1.00092127565905,1.00083788398002,1.00075661671308,1.00067739370135,1.00060013877036,1.00052477948377,1.00045124691682,1.00037947544614,1.00030940255437,1.0002409686486,1.00017411689132,1.00010879304298,1.00004494531528,0.999982524234183,0.999921482512129,0.999861774928533,0.999803358218087,0.999746190966206,0.999690233511122,0.99963544785212,0.999581797563487,0.999529247713749,0.999477764789832,0.99942731662579],"text":["p: 68<br />df:   2<br />t: 1.3115785<br />p: 68","p: 68<br />df:   3<br />t: 1.1889286<br />p: 68","p: 68<br />df:   4<br />t: 1.1343966<br />p: 68","p: 68<br />df:   5<br />t: 1.1036683<br />p: 68","p: 68<br />df:   6<br />t: 1.0839757<br />p: 68","p: 68<br />df:   7<br />t: 1.0702874<br />p: 68","p: 68<br />df:   8<br />t: 1.0602240<br />p: 68","p: 68<br />df:   9<br />t: 1.0525155<br />p: 68","p: 68<br />df:  10<br />t: 1.0464226<br />p: 68","p: 68<br />df:  11<br />t: 1.0414860<br />p: 68","p: 68<br />df:  12<br />t: 1.0374053<br />p: 68","p: 68<br />df:  13<br />t: 1.0339758<br />p: 68","p: 68<br />df:  14<br />t: 1.0310531<br />p: 68","p: 68<br />df:  15<br />t: 1.0285328<br />p: 68","p: 68<br />df:  16<br />t: 1.0263372<br />p: 68","p: 68<br />df:  17<br />t: 1.0244072<br />p: 68","p: 68<br />df:  18<br />t: 1.0226975<br />p: 68","p: 68<br />df:  19<br />t: 1.0211724<br />p: 68","p: 68<br />df:  20<br />t: 1.0198036<br />p: 68","p: 68<br />df:  21<br />t: 1.0185681<br />p: 68","p: 68<br />df:  22<br />t: 1.0174475<br />p: 68","p: 68<br />df:  23<br />t: 1.0164264<br />p: 68","p: 68<br />df:  24<br />t: 1.0154921<br />p: 68","p: 68<br />df:  25<br />t: 1.0146340<br />p: 68","p: 68<br />df:  26<br />t: 1.0138432<br />p: 68","p: 68<br />df:  27<br />t: 1.0131120<br />p: 68","p: 68<br />df:  28<br />t: 1.0124340<br />p: 68","p: 68<br />df:  29<br />t: 1.0118035<br />p: 68","p: 68<br />df:  30<br />t: 1.0112157<br />p: 68","p: 68<br />df:  31<br />t: 1.0106665<br />p: 68","p: 68<br />df:  32<br />t: 1.0101521<br />p: 68","p: 68<br />df:  33<br />t: 1.0096694<br />p: 68","p: 68<br />df:  34<br />t: 1.0092155<br />p: 68","p: 68<br />df:  35<br />t: 1.0087878<br />p: 68","p: 68<br />df:  36<br />t: 1.0083843<br />p: 68","p: 68<br />df:  37<br />t: 1.0080029<br />p: 68","p: 68<br />df:  38<br />t: 1.0076417<br />p: 68","p: 68<br />df:  39<br />t: 1.0072994<br />p: 68","p: 68<br />df:  40<br />t: 1.0069744<br />p: 68","p: 68<br />df:  41<br />t: 1.0066654<br />p: 68","p: 68<br />df:  42<br />t: 1.0063713<br />p: 68","p: 68<br />df:  43<br />t: 1.0060910<br />p: 68","p: 68<br />df:  44<br />t: 1.0058237<br />p: 68","p: 68<br />df:  45<br />t: 1.0055683<br />p: 68","p: 68<br />df:  46<br />t: 1.0053242<br />p: 68","p: 68<br />df:  47<br />t: 1.0050905<br />p: 68","p: 68<br />df:  48<br />t: 1.0048667<br />p: 68","p: 68<br />df:  49<br />t: 1.0046522<br />p: 68","p: 68<br />df:  50<br />t: 1.0044462<br />p: 68","p: 68<br />df:  51<br />t: 1.0042485<br />p: 68","p: 68<br />df:  52<br />t: 1.0040584<br />p: 68","p: 68<br />df:  53<br />t: 1.0038756<br />p: 68","p: 68<br />df:  54<br />t: 1.0036996<br />p: 68","p: 68<br />df:  55<br />t: 1.0035300<br />p: 68","p: 68<br />df:  56<br />t: 1.0033666<br />p: 68","p: 68<br />df:  57<br />t: 1.0032089<br />p: 68","p: 68<br />df:  58<br />t: 1.0030567<br />p: 68","p: 68<br />df:  59<br />t: 1.0029098<br />p: 68","p: 68<br />df:  60<br />t: 1.0027677<br />p: 68","p: 68<br />df:  61<br />t: 1.0026304<br />p: 68","p: 68<br />df:  62<br />t: 1.0024975<br />p: 68","p: 68<br />df:  63<br />t: 1.0023689<br />p: 68","p: 68<br />df:  64<br />t: 1.0022443<br />p: 68","p: 68<br />df:  65<br />t: 1.0021236<br />p: 68","p: 68<br />df:  66<br />t: 1.0020066<br />p: 68","p: 68<br />df:  67<br />t: 1.0018931<br />p: 68","p: 68<br />df:  68<br />t: 1.0017830<br />p: 68","p: 68<br />df:  69<br />t: 1.0016761<br />p: 68","p: 68<br />df:  70<br />t: 1.0015722<br />p: 68","p: 68<br />df:  71<br />t: 1.0014713<br />p: 68","p: 68<br />df:  72<br />t: 1.0013732<br />p: 68","p: 68<br />df:  73<br />t: 1.0012778<br />p: 68","p: 68<br />df:  74<br />t: 1.0011851<br />p: 68","p: 68<br />df:  75<br />t: 1.0010948<br />p: 68","p: 68<br />df:  76<br />t: 1.0010069<br />p: 68","p: 68<br />df:  77<br />t: 1.0009213<br />p: 68","p: 68<br />df:  78<br />t: 1.0008379<br />p: 68","p: 68<br />df:  79<br />t: 1.0007566<br />p: 68","p: 68<br />df:  80<br />t: 1.0006774<br />p: 68","p: 68<br />df:  81<br />t: 1.0006001<br />p: 68","p: 68<br />df:  82<br />t: 1.0005248<br />p: 68","p: 68<br />df:  83<br />t: 1.0004512<br />p: 68","p: 68<br />df:  84<br />t: 1.0003795<br />p: 68","p: 68<br />df:  85<br />t: 1.0003094<br />p: 68","p: 68<br />df:  86<br />t: 1.0002410<br />p: 68","p: 68<br />df:  87<br />t: 1.0001741<br />p: 68","p: 68<br />df:  88<br />t: 1.0001088<br />p: 68","p: 68<br />df:  89<br />t: 1.0000449<br />p: 68","p: 68<br />df:  90<br />t: 0.9999825<br />p: 68","p: 68<br />df:  91<br />t: 0.9999215<br />p: 68","p: 68<br />df:  92<br />t: 0.9998618<br />p: 68","p: 68<br />df:  93<br />t: 0.9998034<br />p: 68","p: 68<br />df:  94<br />t: 0.9997462<br />p: 68","p: 68<br />df:  95<br />t: 0.9996902<br />p: 68","p: 68<br />df:  96<br />t: 0.9996354<br />p: 68","p: 68<br />df:  97<br />t: 0.9995818<br />p: 68","p: 68<br />df:  98<br />t: 0.9995292<br />p: 68","p: 68<br />df:  99<br />t: 0.9994778<br />p: 68","p: 68<br />df: 100<br />t: 0.9994273<br />p: 68"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(248,118,109,1)"}},"hoveron":"points","name":"68","legendgroup":"68","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100],"y":[4.30265272974946,3.18244630528371,2.77644510519779,2.57058183563631,2.44691185114497,2.36462425159278,2.30600413520417,2.2621571627982,2.22813885198627,2.20098516009164,2.17881282966723,2.16036865646279,2.1447866879178,2.13144954555978,2.11990529922125,2.10981557783332,2.10092204024104,2.09302405440831,2.08596344726586,2.07961384472768,2.07387306790403,2.06865761041905,2.06389856162803,2.0595385527533,2.05552943864287,2.05183051648029,2.04840714179524,2.0452296421327,2.04227245630124,2.03951344639641,2.0369333434601,2.03451529744934,2.03224450931772,2.03010792825034,2.02809400098045,2.02619246302911,2.02439416391197,2.02269092003676,2.02107539030627,2.01954097044138,2.01808170281844,2.01669219922782,2.01536757444376,2.01410338888085,2.01289559891943,2.01174051372977,2.01063475762423,2.00957523712924,2.00855911210076,2.00758377031584,2.00664680506169,2.00574599531787,2.00487928818806,2.00404478328915,2.00324071884787,2.00246545929101,2.00171748414524,2.00099537808827,2.00029782201426,1.99962358499494,1.99897151703338,1.99834054252074,1.99772965431769,1.997137908392,1.99656441895231,1.9960083540253,1.99546893142984,1.99494541510724,1.99443711177119,1.99394336784563,1.99346356666187,1.99299712588985,1.99254349518093,1.99210215400224,1.99167260964466,1.99125439538838,1.99084706881169,1.99045021023013,1.99006342125445,1.9896863234569,1.98931855713657,1.98895978017516,1.98860966697571,1.98826790747722,1.98793420623902,1.98760828158907,1.98728986483117,1.98697869950628,1.98667454070377,1.98637715441862,1.98608631695113,1.98580181434582,1.9855234418666,1.9852510035055,1.98498431152246,1.98472318601398,1.98446745450848,1.98421695158642,1.98397151852355],"text":["p: 95<br />df:   2<br />t: 4.3026527<br />p: 95","p: 95<br />df:   3<br />t: 3.1824463<br />p: 95","p: 95<br />df:   4<br />t: 2.7764451<br />p: 95","p: 95<br />df:   5<br />t: 2.5705818<br />p: 95","p: 95<br />df:   6<br />t: 2.4469119<br />p: 95","p: 95<br />df:   7<br />t: 2.3646243<br />p: 95","p: 95<br />df:   8<br />t: 2.3060041<br />p: 95","p: 95<br />df:   9<br />t: 2.2621572<br />p: 95","p: 95<br />df:  10<br />t: 2.2281389<br />p: 95","p: 95<br />df:  11<br />t: 2.2009852<br />p: 95","p: 95<br />df:  12<br />t: 2.1788128<br />p: 95","p: 95<br />df:  13<br />t: 2.1603687<br />p: 95","p: 95<br />df:  14<br />t: 2.1447867<br />p: 95","p: 95<br />df:  15<br />t: 2.1314495<br />p: 95","p: 95<br />df:  16<br />t: 2.1199053<br />p: 95","p: 95<br />df:  17<br />t: 2.1098156<br />p: 95","p: 95<br />df:  18<br />t: 2.1009220<br />p: 95","p: 95<br />df:  19<br />t: 2.0930241<br />p: 95","p: 95<br />df:  20<br />t: 2.0859634<br />p: 95","p: 95<br />df:  21<br />t: 2.0796138<br />p: 95","p: 95<br />df:  22<br />t: 2.0738731<br />p: 95","p: 95<br />df:  23<br />t: 2.0686576<br />p: 95","p: 95<br />df:  24<br />t: 2.0638986<br />p: 95","p: 95<br />df:  25<br />t: 2.0595386<br />p: 95","p: 95<br />df:  26<br />t: 2.0555294<br />p: 95","p: 95<br />df:  27<br />t: 2.0518305<br />p: 95","p: 95<br />df:  28<br />t: 2.0484071<br />p: 95","p: 95<br />df:  29<br />t: 2.0452296<br />p: 95","p: 95<br />df:  30<br />t: 2.0422725<br />p: 95","p: 95<br />df:  31<br />t: 2.0395134<br />p: 95","p: 95<br />df:  32<br />t: 2.0369333<br />p: 95","p: 95<br />df:  33<br />t: 2.0345153<br />p: 95","p: 95<br />df:  34<br />t: 2.0322445<br />p: 95","p: 95<br />df:  35<br />t: 2.0301079<br />p: 95","p: 95<br />df:  36<br />t: 2.0280940<br />p: 95","p: 95<br />df:  37<br />t: 2.0261925<br />p: 95","p: 95<br />df:  38<br />t: 2.0243942<br />p: 95","p: 95<br />df:  39<br />t: 2.0226909<br />p: 95","p: 95<br />df:  40<br />t: 2.0210754<br />p: 95","p: 95<br />df:  41<br />t: 2.0195410<br />p: 95","p: 95<br />df:  42<br />t: 2.0180817<br />p: 95","p: 95<br />df:  43<br />t: 2.0166922<br />p: 95","p: 95<br />df:  44<br />t: 2.0153676<br />p: 95","p: 95<br />df:  45<br />t: 2.0141034<br />p: 95","p: 95<br />df:  46<br />t: 2.0128956<br />p: 95","p: 95<br />df:  47<br />t: 2.0117405<br />p: 95","p: 95<br />df:  48<br />t: 2.0106348<br />p: 95","p: 95<br />df:  49<br />t: 2.0095752<br />p: 95","p: 95<br />df:  50<br />t: 2.0085591<br />p: 95","p: 95<br />df:  51<br />t: 2.0075838<br />p: 95","p: 95<br />df:  52<br />t: 2.0066468<br />p: 95","p: 95<br />df:  53<br />t: 2.0057460<br />p: 95","p: 95<br />df:  54<br />t: 2.0048793<br />p: 95","p: 95<br />df:  55<br />t: 2.0040448<br />p: 95","p: 95<br />df:  56<br />t: 2.0032407<br />p: 95","p: 95<br />df:  57<br />t: 2.0024655<br />p: 95","p: 95<br />df:  58<br />t: 2.0017175<br />p: 95","p: 95<br />df:  59<br />t: 2.0009954<br />p: 95","p: 95<br />df:  60<br />t: 2.0002978<br />p: 95","p: 95<br />df:  61<br />t: 1.9996236<br />p: 95","p: 95<br />df:  62<br />t: 1.9989715<br />p: 95","p: 95<br />df:  63<br />t: 1.9983405<br />p: 95","p: 95<br />df:  64<br />t: 1.9977297<br />p: 95","p: 95<br />df:  65<br />t: 1.9971379<br />p: 95","p: 95<br />df:  66<br />t: 1.9965644<br />p: 95","p: 95<br />df:  67<br />t: 1.9960084<br />p: 95","p: 95<br />df:  68<br />t: 1.9954689<br />p: 95","p: 95<br />df:  69<br />t: 1.9949454<br />p: 95","p: 95<br />df:  70<br />t: 1.9944371<br />p: 95","p: 95<br />df:  71<br />t: 1.9939434<br />p: 95","p: 95<br />df:  72<br />t: 1.9934636<br />p: 95","p: 95<br />df:  73<br />t: 1.9929971<br />p: 95","p: 95<br />df:  74<br />t: 1.9925435<br />p: 95","p: 95<br />df:  75<br />t: 1.9921022<br />p: 95","p: 95<br />df:  76<br />t: 1.9916726<br />p: 95","p: 95<br />df:  77<br />t: 1.9912544<br />p: 95","p: 95<br />df:  78<br />t: 1.9908471<br />p: 95","p: 95<br />df:  79<br />t: 1.9904502<br />p: 95","p: 95<br />df:  80<br />t: 1.9900634<br />p: 95","p: 95<br />df:  81<br />t: 1.9896863<br />p: 95","p: 95<br />df:  82<br />t: 1.9893186<br />p: 95","p: 95<br />df:  83<br />t: 1.9889598<br />p: 95","p: 95<br />df:  84<br />t: 1.9886097<br />p: 95","p: 95<br />df:  85<br />t: 1.9882679<br />p: 95","p: 95<br />df:  86<br />t: 1.9879342<br />p: 95","p: 95<br />df:  87<br />t: 1.9876083<br />p: 95","p: 95<br />df:  88<br />t: 1.9872899<br />p: 95","p: 95<br />df:  89<br />t: 1.9869787<br />p: 95","p: 95<br />df:  90<br />t: 1.9866745<br />p: 95","p: 95<br />df:  91<br />t: 1.9863772<br />p: 95","p: 95<br />df:  92<br />t: 1.9860863<br />p: 95","p: 95<br />df:  93<br />t: 1.9858018<br />p: 95","p: 95<br />df:  94<br />t: 1.9855234<br />p: 95","p: 95<br />df:  95<br />t: 1.9852510<br />p: 95","p: 95<br />df:  96<br />t: 1.9849843<br />p: 95","p: 95<br />df:  97<br />t: 1.9847232<br />p: 95","p: 95<br />df:  98<br />t: 1.9844675<br />p: 95","p: 95<br />df:  99<br />t: 1.9842170<br />p: 95","p: 95<br />df: 100<br />t: 1.9839715<br />p: 95"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,191,196,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,191,196,1)"}},"hoveron":"points","name":"95","legendgroup":"95","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":26.2283105022831,"r":7.30593607305936,"b":40.1826484018265,"l":31.4155251141553},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-2.9,104.9],"tickmode":"array","ticktext":["0","25","50","75","100"],"tickvals":[0,25,50,75,100],"categoryorder":"array","categoryarray":["0","25","50","75","100"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"df","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.834266045969606,4.46781400040565],"tickmode":"array","ticktext":["1","2","3","4"],"tickvals":[1,2,3,4],"categoryorder":"array","categoryarray":["1","2","3","4"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"t","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"y":0.96751968503937},"annotations":[{"text":"p","x":1.02,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"left","yanchor":"bottom","legendTitle":true}],"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"2bf4666b7cf3":{"colour":{},"x":{},"y":{},"type":"scatter"}},"cur_data":"2bf4666b7cf3","visdat":{"2bf4666b7cf3":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```


*Takeaway:* the number of samples affects not only the standard error, but the t-distribution curve we use to solve for the probability that a value will occur, given our sample mean.



## Confidence Interval
The importance of the number of samples the standard error, and the t-distribution becomes even more apparent with the use of confidence interval.  A confidence interval is a range of values around the sample mean that are selected to have a given probability of including the true population mean.  Suppose we want to define, based on a sample size of 4 from the soybean field above, a range of values around our sample mean that has a 95% probability of including the true sample mean.

The 95% confidence interval is equal to the sample mean, plus and minus the product of the standard error and t-value associated with 0.975 in each tail:

$$CI = \bar x + t \times se$$

Where CI is the confidence interval, t is determined by the degrees of freedom, and se is the standard error of the mean

Since the t-value associated with a given probability in each tail decreases with the degrees of freedom, the confidence interval narrows as the degrees of freedom increase -- even when the standard error is unaffected.  

Lets sample our yield population 4 times, using the same code we did earlier


```r
# setting the seed the same as before means the same 4 samples will be pulled
set.seed(1776)
# collect 4 samples 
yield_sample = sample(yield$yield_bu, 4) 
#print results
yield_sample
```

```
## [1] 82.40863 71.68231 73.43349 81.27435
```

We can then calculate the sample mean, sample standard deviation, and standard error of the mean.


```r
sample_mean = mean(yield_sample)
sample_sd = sd(yield_sample)
sample_se = sample_sd/sqrt(4)

sample_mean
```

```
## [1] 77.1997
```

```r
sample_se
```

```
## [1] 2.713572
```

We can then determine the t-value we need to construct our confidence interval and multiply it by our standard error to determine the confidence interval.  To get the upper limit of the 95% confidence interval, we request the t-value above which only 2.5% of the samples are expected to exist.  In other words, we ask R for the t-value below which 95% of the samples are expected to exist.


```r
# t-value associated with 3 df
upper_t = qt(0.975, 3)
upper_t
```

```
## [1] 3.182446
```

We can then add this to the sample mean to get our upper confidence limit.


```r
upper_limit = sample_mean + upper_t
upper_limit
```

```
## [1] 80.38214
```

We can repeate the process to determine the lower limit.  This time, however, we ask R for the t-value below which only 2.5% of the samples are expected to exist.


```r
lower_t = qt(0.025, 3)
lower_t
```

```
## [1] -3.182446
```

```r
lower_limit = sample_mean + lower_t
lower_limit
```

```
## [1] 74.01725
```

You will notice that "lower_t", the t-value that measures from the sample mean to the lower limit of the confidence interval, is just the negative of "upper_t".  Since the normal distribution is symmetrical around the mean, we can just determine the upper limit and use its negative as the lower limit of our confidence interval.

Finally, we can put this all together and express it as follows.  The confidence interval for the population mean, based on the sample mean is:

$$ CI = 80.2 \pm 3.2 $$

We can also express the interval by its lower and upper confidence limits.
$$(77.0, 83.4)$$
We can confirm this interval includes the true population mean, which is 80.1.




## Confidence Interval and Probability

Lets return to the concept of 95% confidence.  This means if we were to collect 100 sets of 4 samples each, 95% of them would estimate confidence intervals that include the true population mean.  The remaining 5% would not. 

Click on this link to better explore this concept: app_confidence_interval

Again, both the standard error and the t-value we use for calculating the confidence interval decrease as the number of samples decrease, so the confidence interval itself will decrease as well.

Click on this link to better explore this concept: app_ci_width




As the number of samples increases, the confidence interval shrinks.  95 out of 100 times, however, the confidence interval will still include the true population mean.  In other words, as our sample size increases, our sample mean becomes less biased (far to either side of the population mean), and it's accuracy (the proximity of the sample mean and  population mean) increases.  In conclusion, the greater the number of samples, the better our estimate of the population mean.

In the next unit, we will use these concepts to analyze our first experimental data: a side by side trial where we will us the confidence interval for the difference between two treatments to test whether they are different.



## Exercise: Standard Error
Just as the standard deviation describes the distribution of individuals around a population mean, so the standard error of the mean describes the distribution of samples around their sample mean.  In fact, the standard error of the mean is simply the standard deviation of the samples around the sample mean.

### Case Study: Tomatoes
Once again, we will work with the tomato, barley, cotton, and peanut datasets.  Let's load the tomato dataset and look at its top six rows of data.


```r
tomato = read.csv("data-unit-3/exercise_data/tomato_uniformity.csv")
head(tomato)
```

```
##   row col yield
## 1   1   1    48
## 2   2   1    61
## 3   3   1    69
## 4   4   1    59
## 5   5   1    71
## 6   6   1    46
```

### Calculating Standard Error
The standard error of the mean is equal to the population standard deviation, divided by the square root of the number of samples.  We can calculate these as follows.  To get the standard deviation, use the sd() function. 


```r
yield = tomato$yield  # define the column of interest

tomato_sd = sd(yield)
```

Then we can divide the standard deviation by the square root of n to get the standard error of the mean.  What would be the standard error of our sample mean, if we took 4 samples?


```r
tomato_se = tomato_sd / sqrt(4)
tomato_se
```

```
## [1] 5.249217
```

We will talk more about the t-distribution in the next exercise, but for now lets assume about 95% of the sample means should be within about two standard errors of the mean of their distribution.  Two times the standard error is about 10.6, so we would expect 95% of sample means to be within 50.3 +/-10.6, or (39.7, 60.9).  

Don't worry about understanding the code below.  Just run it and observe the plot.  In the plot below, we have simulated 1000 sample means, each based on four samples, from the tomato yield population.  We can see the range (39.7, 60.9) does include most of the population, with the exception of the tails.  


```r
library(tidyverse)
set.seed(2003)
sample_list = list()
for(i in c(1:1000)){
  samples = mean(sample(yield, 4))%>%
    as.data.frame() 
  sample_list[[i]] = samples
}
sample_list_df = do.call(rbind.data.frame, sample_list)
names(sample_list_df) = "yield"
pop_mean = mean(yield)
ggplot(sample_list_df, aes(x=yield)) +
  geom_histogram(fill="white", color="black") +
  geom_vline(xintercept = pop_mean, color = "red") 
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-19-1.png" width="672" />

What would be the standard error of our sample mean if we took 7 samples?

```r
tomato_se = tomato_sd / sqrt(7)
tomato_se
```

```
## [1] 3.968035
```



### Practice: Barley
Now let's practice calculating the standard error.  What would be the standard error of our sample mean if we took 8 samples?  I'll get you started.  First, let's load the "barley_uniformity.csv" data and inspect the first six rows.


```r
barley = read.csv("data-unit-3/exercise_data/barley_uniformity.csv")
head(barley)
```

```
##   row col yield
## 1  20   1   185
## 2  19   1   169
## 3  18   1   216
## 4  17   1   165
## 5  16   1   133
## 6  15   1   195
```

Next lets define the column of interest and create a histograma of its distribution.

```r
barley_yield = barley$yield
hist(barley_yield)
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-22-1.png" width="672" />

Remember, we need to know the standard deviation in order to calculate the standard error of the sample mean.


```r
barley_sd = sd(barley_yield)
```

What would the standard error of the sample mean be if we took two samples?


```r
barley_se = barley_sd/sqrt(2)
barley_se
```

```
## [1] 22.01951
```

The standard error woud be about 22.0.

Try calculating additional standard errors.  Here are some of the values you should get.

4 samples, se=15.6
5 samples, se=13.9
7 samples, se=11.8


### Practice: Cotton

Calculate the standard errors of sample means from the "cotton_uniformity.csv" dataset, for sets of 3, 4, and 6 samples.  You should get:

3 samples = 0.13
4 samples = 0.11
6 samples = 0.09



## Exercise: t-Distribution
This week, we are introduced to the t-distribution.  The t-distribution describes the distribution of sample means around their mean value.  Contrast this with the Z-distribution, which describes the distribution of individuals around the population mean.

The most critical way in which the t-distribution is different from the Z-distribution is the shape of the t-distribution changes shape with the number of samples used to calculate the sample mean.  As the number of samples increases, the t-distribution narrows in width, and expands in height.


### Plotting the Distribution
In the lecture, we once again used the "shadeDist" function from the fastGraph package.  Use install.packages("fastGraph") to install fastGraph in your account if you did not do so in the last unit.  Then use library(fastgraph) to tell R to run that package in the current section.

We can use the shadeDist function to observe how the difference of the t-Distribution changes with the number of samples taken.  Say we want to see the t-distribution for a sample size of 2.  We will shade the area from t=-1 to t=1 for reference.


```r
library(fastGraph)
shadeDist(c(-1,1), "dt", 1, lower.tail=FALSE ) # t with 15 d.f. and non-centrality parameter=3
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-25-1.png" width="672" />

Remember, we must provide four arguments to the shadeDist function.  The first, "c(-1,1)", is the range of t-values.  The second, "dt", tells R we are modeling the t-distribution.  The third, 3 is the degrees of freedom associated with t, which is always one less than the number of samples.  the final argument, "lower.tail=FALSE", tells R to shade the middle of the plot.

Now lets change the number of samples to 4.

```r
shadeDist(c(-1,1), "dt", 3, lower.tail=FALSE ) # t with 15 d.f. and non-centrality parameter=3
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-26-1.png" width="672" />

We can see the shaded area gets wider, meaning the distribution is getting narrower.  In we increase to 6, the shape doesn't seem to change much, yet the proportion of the curve that is between t=-1 and t=1 increases.

```r
shadeDist(c(-1,1), "dt", 5, lower.tail=FALSE ) # t with 15 d.f. and non-centrality parameter=3
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-27-1.png" width="672" />

If we increase to n=20, the curve continues to narrow.

```r
shadeDist(c(-1,1), "dt", 19, lower.tail=FALSE ) # t with 15 d.f. and non-centrality parameter=3
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-28-1.png" width="672" />

### Calculating T
To create the plot above, we entered t-values, and the degree of freedom.  R not only drew the plot, but calculate the probability of observing sample means within the given range.

To calculate t, we need to supply the degrees of freedom and the target probability to which t should respond.  We will use the "qt" function in R to do this.

Let's say we want to know the t-values that, given four samples per mean, would be expected to include 50% of potential sample means?  In that case, we are interested in the middle 50% of the distribution.  There will be 25% of the distribution below this range, and 25% above.  So, for the lower t-value, we will tell R to calculate the t-value below which 25% of sample means are expected to occur.


```r
qt(0.25,3)
```

```
## [1] -0.7648923
```

In the argument above, we told R to calculate the t-value associated with the lower 0.25 of the population, and 3 degrees of freedom (for 4 samples).  For the upper t-value, we want the value where 75% of the distribution is lower.



```r
qt(0.75,3)
```

```
## [1] 0.7648923
```

As you can see, the upper and lower limit are symmetrical -- they only differ in sign.  We can use the shadeDist from above to check our work, by plugging in the t-values we just calculated.


```r
shadeDist(c(-0.7649,0.7649), "dt", 3, lower.tail=FALSE ) # t with 15 d.f. and non-centrality parameter=3
```

<img src="03-Sample-Statistics_files/figure-html/unnamed-chunk-31-1.png" width="672" />

As we can see, the defined proportion equals our target.

What if we want the t-values that bind the middle 68% of potential sample means?  Then we would have 32% of the distribution outside this range.  16% of sample means would be expected to be below the range, and 16% percent above.

The t-value associated with the lower range, again assuming 3 df, would be:

```r
qt(0.16,3)
```

```
## [1] -1.188929
```
And the t-value associated with the upper range would be:

```r
qt(0.84,3)
```

```
## [1] 1.188929
```

How about the t-values that would be expected to define the range where 90% of sample means would be expected?

```r
qt(0.05,3)
```

```
## [1] -2.353363
```

```r
qt(0.95,3)
```

```
## [1] 2.353363
```

And, finally, 95%?


```r
qt(0.025,3)
```

```
## [1] -3.182446
```

```r
qt(0.975,3)
```

```
## [1] 3.182446
```

### Practice
Calculate the t-values that would define the middle 60% of potential sample means if there were 10 samples.

The lower limit is:

```r
qt(0.2,9)
```

```
## [1] -0.8834039
```

What is the upper limit?

Q: What is the range of t-values associated with 70% of potential sample means, if the number of samples is 12?
A: (-1.09, 1.09)

Q: What is the range of t-values associated with 80% of potential sample means, if the number of samples is 14?
A: (-1.35, 1.35)

Q: What is the range of t-values associated with 90% of potential sample means, if the number of samples is 17?
A: (-1.75, 1.75)

Q: What is the range of t-values associated with 95% of potential sample means, if the number of samples is 20?
A: (-2.09, 2.09)

Q: What is the range of t-values associated with 95% of potential sample means, if the number of samples is 20?
A: (-2.86, 2.86)



## Exercise: Confidence Interval for Sample Mean
In the last part of this lesson, we learned how the standard error and t-distribution can be combined to define a confidence interval: a range of values around the sample mean that we are confident will, in a given percentage of trials, include the true population mean.  The confidence interval is bound by upper and lower confidence limits that are the product of the t-value and standard error.  

### Calculating the Confidence Interval
Once we understand how to calculate the standard error and t-value, the confidence interval is easily constructed:

1) multiply the standard error times the t-value
2) find the lower confidence limit by subtracting the product from step 1 from the sample mean 
3) find the upper confidence limit by adding the product from step 1 to the sample mean 
4) report the confidence interval in parentheses, like this (lower confidence limit, upper confidence limit)

### Case Study: Peanut Sample 1

In the data folder there are nine sample sets, of different size from the peanut trial.  Let's load the first

```r
peanut = read.csv("data-unit-3/exercise_data/peanut_sample_1.csv")
head(peanut)
```

```
##   sample_no yield
## 1         1  2.30
## 2         2  1.38
```

Let's create a new variable, "yield", from the yield column in the peanut data frame.   

```r
yield = peanut$yield
```

First, lets calculate the sample mean and standard deviation.

```r
yield_mean = mean(yield)
yield_sd = sd(yield)
```

Remember how to calculate the standard error?  Right, divide the standard deviation by the square root of the number of samples.  In this case, we know it is 2, but if we were dealing with a larger sample, it might be easier to let excel do the counting.  So lets use the "length()" argument to do that.


```r
no_samples = length(yield)
```

Finally, we can calculate the standard error.

```r
yield_se = yield_sd/sqrt(no_samples)
```

Now, we need to calculate the t-value to use in calculating the confidence interval.  For this first example, we want a 90% confidence interval.  So we need to tell R to calculate the value of t that leaves 5% of the distribution in each tail.  That means the upper tail will begin at 100% - 5, or 95%.  We can now use the "qt" function in R to calculate t.


```r
t_value = qt(0.95, 1)
```

Where did the 1 come from?  Remember, that is the degrees of freedom, which is equal to the number of samples minus 1.  We have two samples in this first example, thus we have 1 degree of freedom.  

We now know that our standard error is 0.46 and our t_value is about 6.31.  The last step is to add and subtract the product of the standard error and t-value from the sample mean.


```r
lower_limit = yield_mean - (yield_se*t_value)
upper_limit = yield_mean + (yield_se*t_value)

lower_limit
```

```
## [1] -1.064326
```

```r
upper_limit
```

```
## [1] 4.744326
```

So our confidence interval is (-1.06, 4.74).  Now we know the yield cannot possibly be less than zero.  But because the sample mean is close to zero, and because our sample size is so small, the confidence interval is so wide that its lower limit is negative.  This illustrates an important part of statistics or data science -- never underestimate the importance of domain knowledge, that is, your knowledge of the science it is trying to represent.

One last thing: whenever you report a confidence interval, you should report it's confidence level and degrees of freedom, too.  So we would report the above as:

CI(0.90, 1) = (-1.06, 4.74)


### Case Study: Peanut Sample 2
Let's go through this one a little faster.


```r
peanut_2 = read.csv("data-unit-3/exercise_data/peanut_sample_2.csv")
head(peanut_2)
```

```
##   sample_no yield
## 1         1  2.23
## 2         2  1.48
## 3         3  2.20
## 4         4  1.71
## 5         5  1.88
```

First, lets calculate the sample mean, standard deviation, and standard error.

```r
yield_2 = peanut_2$yield
yield_mean_2 = mean(yield_2)
yield_sd_2 = sd(yield_2)
no_samples_2 = length(yield_2)
yield_se_2 = yield_sd_2/sqrt(no_samples_2)
```

This time we want a 95% confidence interval, so we want our distribution to have 2.5% in the top tail.  100% - 2.5% = 97.5%.  We have 5 samples - 1 = 4 degrees of freedom


```r
t_value_2 = qt(0.975, 4)
```

Finally, add and subtract the product of the standard error and t-value from the sample mean.


```r
lower_limit_2 = yield_mean_2 - (yield_se_2*t_value_2)
upper_limit_2 = yield_mean_2 + (yield_se_2*t_value_2)

lower_limit_2
```

```
## [1] 1.501602
```

```r
upper_limit_2
```

```
## [1] 2.298398
```

Our confidence interval is now CI(0.95, 4) = (1.50, 2.30)

### Practice
Datasets peanut_sample_3.csv through peanut_sample_9.csv are available for your practice.  The answers for the 95% confidence intervals are given below.



```r
# change the sample number in the code below to access datasets 3 through 9
peanut = read.csv("data-unit-3/exercise_data/peanut_sample_3.csv")
peanut_mu = mean(peanut$yield)
peanut_sd = sd(peanut$yield)
peanut_no_samples = length(peanut$yield)
peanut_se = peanut_sd / sqrt(peanut_no_samples)
df=peanut_no_samples-1

peanut_t = qt(0.975, df=df)

upper_conf_limit = peanut_mu + (peanut_se*peanut_t)
lower_conf_limit = peanut_mu - (peanut_se*peanut_t)

paste0("(", round(lower_conf_limit,2), ", ", round(upper_conf_limit,2), ")")
```

```
## [1] "(1.95, 2.41)"
```


peanut_sample_3.csv: (1.95, 2.41)
peanut_sample_4.csv: (1.98, 2.34)
peanut_sample_5.csv: (1.86, 2.65)
peanut_sample_6.csv: (1.98, 2.57)
peanut_sample_7.csv: (2.09, 2.42)
peanut_sample_8.csv: (2.12, 2.49)
peanut_sample_9.csv: (1.42, 2.15)
