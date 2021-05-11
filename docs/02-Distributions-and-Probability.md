# Distributions and Probability"

## Review
In this unit we will continue with normal distribution model introduced in the previous unit.  As you will recall, the normal distribution is a symmetrical curve that represents the frequency with which individuals with different particular measured values occur in a population.

The peak of the curve is located at the population mean, $\mu$.  The width of the curve reflects how spread out other individuals are from the mean.  We learned three ways to measure this spread: the sum of squares, the variance, and the standard deviation. These statistics can roughly be thought of as representing the sums of the squared differences, the average of the squared distances, and the distances presented in the original units of measure.  These four statistics -- mean, sum of squares, variance, and standard deviation -- are among the most important you will learn in this course.

## Case Study
This week, we will continue to work with the Iowa soybean yield dataset introduced to us in Unit 1.



Let's review the structure of this dataset:

```r
head(yield)
```

```
## Simple feature collection with 6 features and 12 fields
## geometry type:  POINT
## dimension:      XY
## bbox:           xmin: -93.15033 ymin: 41.66641 xmax: -93.15026 ymax: 41.66644
## geographic CRS: WGS 84
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
library(sf)
plot(yield["yield_bu"])
```

<img src="02-Distributions-and-Probability_files/figure-html/plot_field-1.png" width="672" />


## The Normal Distribution Model
Mean, sum of squares, variance, and standard deviation are so important because they allow us to reconstruct the normal distribution model.  Before we go further, what is a model?  Is it frightening we are using that term in the second week of class?

A model is a simplified representation of reality.  No, that doesn't mean that models are "fake" (SMH).  It means that they summarize aspects of data, both measured and predicted.  The normal distribution model describes the relationship between the values of individuals and how frequently they appear in the population.  It's value is it can be reconstructed by knowing just two things about the original dataset -- its mean and its standard deviation.

### The Bell Curve
The normal distribution is also referred to as the "bell curve", since it is taller in the middle and flared on either side.  This shape reflects the tendency of measures within many populations to occur more frequently near the population mean than far from it.  Why does this occur and how do we know this?

As agronomists, we can reflect on what it takes to produce a very good -- or very bad crop.  For a very good crop, many factors need to coincide: temperature, precipitation, soil texture, nitrogen mineralization, proper seed singulation (spacing), pest control, and hybrid or variety selection, to name a few.  We may, in a typical season or within a field, optimize one or two of these conditions, but the possibility of optimizing every one is exceedingly rare.  Thus, if we are measuring yield,  measures near the mean yield will occur more frequently.  Extremely high yields will occur less frequently.

Conversely, very low yields require we manage a crop very badly or that catastrophic weather conditions occur: a hailstorm, flood, or tornado.  A frost at exactly the wrong time during seed germination or a drought.  A planter box running out of seed or a fertilizer nozzle jamming. These things do occur, but less frequently.

The distribution of individuals around the mean is also a the result of measurement inaccuracies.  Carl Friedrich Gauss, who introduced the normal distribution model, showed that it explained the variation in his repeated measurements of the position of stars in the sky.  All measurements of continuous data (those that can be measured with a ruler, a scale, a gradated cylinder, or machine) have variation -- we use the term "accuracy" to explain their variation around the population mean.

### Distribution and Probability
Some areas of mathematics like geometry and algebra produce proven concepts (ie theorems), the product of statistics are almost always probabilities.  To be more specific, most of the statistical tests we will learn can be reduced to the probability that a particular value is observed in a population.  These probabilities include:
- the probability an individual measurement or population mean is observed (normal distribution)
- the difference between two treatments is not zero (t-test and least-significant difference)
- the probability of one measure given another (regression)
- the probability that the spread of individual measures in a population is better predicted by treatment differences than random variation (F-test and analysis of variance)

These probabilities are all calculated from distributions -- the frequency with which individuals appear in a population.  Another way of stating this is that probability is the proportion of individuals in a population that are have measured values within a given range. Examples could include:
- the proportion of individual soybean yield measurements, within one field, that are less than 65 bushels per acre
- the proportion of individual corn fields that have an an average less than 160 bushels per acre
- the proportion of trials in which the difference between two treatments was greater than zero
- the proportion of observations in which the actual crop yield is greater than that predicted from a regression model


### Probability and the Normal Distribution Curve
Probability can be calculated as the proportion of the area underneath the normal distribution that corresponds to a particular range of values.  We can visualize this, but first we need to construct the normal distribution curve for our soybean field.

We need just two data to construct our curve: the mean and standard deviation of our yield.  These are both easily calculated in R.

```r
library(muStat)
yield_mean = mean(yield$yield_bu)
yield_sd = stdev(yield$yield_bu, unbiased = FALSE)

# to see the value of yield_mean and yield_sd, we just type their names and run the code.
yield_mean
```

```
## [1] 80.09084
```

```r
yield_sd
```

```
## [1] 8.72252
```




Now we can build our curve with a single line of code.  The plotDist function in R will reconstruct the  distribution curve for any population, given three arguments, in the following order: what kind of curve to draw, the population mean, and population standard deviation.  
- *dnorm* tells plotDist to draw a normal distribution curve.  This needs to enclosed in quotes 
- *yield_mean* tells plotDist to use the mean we calculated in the previous chunk as the population mean
- *yield_sd* tells plotDist to use the standard deviation we calculated in the previous chunk as the standard deviation




```r
library(fastGraph)
plotDist("dnorm", yield_mean, yield_sd)
```

<img src="02-Distributions-and-Probability_files/figure-html/plot_distribution-1.png" width="672" />

Let's now shade the area underneath the normal curve corresponding to X values from 70 - 80.  This area will represent the proportion of the population Where individuals were measured to have values between 70 and 80 bushels.

The shade.norm function makes effort painless.  There are five arguments in this function: 
- *xshade* is the range of individuals in our population for which we want to calculate their area under the distribution curve.  We pass this range as a vector using c(minimum, maximum), in this case c(70,80)
- *ddist* tells the function what kind of distribution curve to draw.  "dnorm" tells it to construct a normal distribution curve
- the third value we include (and it must be in this order), is the population mean.  In this case, we pass the variable yield_mean whose value we calculated in the previously
- the fourth value is the population standard deviation, which we have already calculated and assigned to the variable yield_sd
- *lower.tail=FALSE* tells shade.norm to shade the area under the curve between 70 and 80 bushels and to calculate its area.


```r
shadeDist(xshade=c(70,80), ddist = "dnorm", yield_mean, yield_sd, lower.tail = FALSE)
```

<img src="02-Distributions-and-Probability_files/figure-html/shade_range-1.png" width="672" />

Pretty cool, huh?  The red area is the proportion of the soybean yield population that was between 70 and 80 bushels.  shadeDist has also presented us with the proportion of the curve represented by that area, which it has labelled "Probability".  The probabiliity in this case is 0.3722.  What does that number mean?

The total area of the curve is 1.  The proportion of the area under the curve that corresponds with yields from 70 to 80 bushels, then, is 3.967 percent of the area.  This means that 37.22 percent of the individuals in our yield population had values from 70 and 80 bushels

But wait a second -- why is R using the term "Probability"?  Think of it this way.  Imagine you sampled 1000 individuals from our population.  If 37.22 percent of our individuals have values from 70 to 80 bushels, then about 37% of the individuals in your sample should have values from 70 to 80 bushels.  In other words, there is a 37% probability that any individual in the population will have a value from 70 to 80 bushels.  

Let's test this.  Let's randomly sample 1000 individuals from our sample.  Then lets count the number of individuals that have yields between 70 and 80 bushels.  We will run three lines of code here:
- we will use the "sample" function to randomly sample our population and return a vector of those numbers
- we will use the "subset" function to subset our data into those that meet logical conditions and return a dataframe or vector.  We provide two arguments: first, the name of the dataset or vector, and second the conditions.
- we will use the "length" function to count the number of observations



```r
yield_sample = sample(yield$yield_bu, 1000)

# "yield_sample >=70 & yield_sample <=80 tells it to only include measures from 70 to 80 in the subset
yield_subset = subset(yield_sample, yield_sample >=70 & yield_sample <=80)

length(yield_subset)
```

```
## [1] 342
```

Is the proportion predicted by the normal distribution curve exactly that of the actual population?  Probably not.  The normal distribution curve is, after all, a model -- it is an approximation of the actual population.

Run the code above multiple times and observe how the percentages change.  The proportions will vary slightly but generall stay in a range from about 0.32 to 0.37.

We will talk more about sampling in the next unit.  



## The Z-Distribution
The relationship between probability and the normal distribution curve is based on the concept of the Z-distribution.  In essence, Z-distribution describes a normal distribution curve with a population mean of 0 and a standard deviation of 1.


```r
plotDist("dnorm", 0, 1)
```

<img src="02-Distributions-and-Probability_files/figure-html/normal_distribution-1.png" width="672" />

The Z-distribution helps us understand how probability relates to standard deviation, regardless of the nature of a study or its measurement units.

For example, the proportion of a population within one standard deviation of the mean is about 68 percent:


```r
shadeDist(xshade=c(-1, 1), ddist = "dnorm", 0, 1, lower.tail = FALSE)
```

<img src="02-Distributions-and-Probability_files/figure-html/one_sd_shaded-1.png" width="672" />

Similarly, the proportion of a population within 1.96 standard deviations of the mean is about 95 percent:


```r
shadeDist(xshade=c(-1.96, 1.96), ddist = "dnorm", 0, 1, lower.tail = FALSE)
```

<img src="02-Distributions-and-Probability_files/figure-html/two_sd_shaded-1.png" width="672" />

Conversely, the proportion of a population beyond 1.96 standard deviations from the mean is about 5 percent.  We can visualize this by changing the last argument of our code to "lower.tail = TRUE". 

```r
shadeDist(xshade=c(-1.96, 1.96), ddist = "dnorm", 0, 1, lower.tail = TRUE)
```

<img src="02-Distributions-and-Probability_files/figure-html/outside_two_sd_shaded-1.png" width="672" />

We refer to the upper and lower ends of the distribution as tails.  In a normal distribution we would expect about 2.5% of observations to less than -1.96 standard deviations of the mean.  We can measure the proportion in one tail by changing our argument in the shadeDist command to "xshade = -1.96".


```r
shadeDist(xshade=-1.96, ddist = "dnorm", 0, 1, lower.tail = TRUE)
```

<img src="02-Distributions-and-Probability_files/figure-html/lower_tail-1.png" width="672" />

And 2.5% of the population to be more than +1.96 above the mean:


```r
shadeDist(xshade=1.96, ddist = "dnorm", 0, 1, lower.tail = FALSE)
```

<img src="02-Distributions-and-Probability_files/figure-html/upper_tail-1.png" width="672" />
Notice we changed the last argument back to "lower.tail = TRUE".  The causes R to shade the area above 1.96 standard deviations of the mean.  

### Important Numbers: 95% and 5%
Above we learned that 95% of a normal distribution is between 1.96 standard deviations of the mean, and that 5% of a normal distribution is outside this range.  Perhaps these numbers sound familiar to you.  Have you ever seen results presented with a 95% confidence interval?  Have you ever read that two treatments were significantly different at the P=0.05 level?

For population statistics, the normal distribution is the origin of those numbers.  As we get further into this course, we will learn about additional distributions -- binomial, chi-square, and F -- and the unique statistical tests they allow.  But the concept will stay the same: identifying whether observed statistical values are more likely to occur (i.e., within the central 95% of values expected in a distribution), or whether the values are unusual (occurring in the remaining 5%).










[insert shiny app where they can sample multiple times and see results]






```r
set.seed(051520)

output = matrix(ncol=1, nrow=100)

for(i in c(1:100)){
  yield_sample = sample(yield$yield_bu, 1000)
  N = length(yield_sample[yield_sample >=80 & yield_sample <=100])
  output[i] = N
}
```











