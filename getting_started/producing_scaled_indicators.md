# Producing scaled mobility indicators from the aggregates

The aggregates produced by the queries in this repository do not reveal any personal information about subscribers. However, they may still reveal commercially-sensitive information, such as the size and geographic distribution of the subscriber base. This document describes steps to calculate mobility indicators which are scaled to remove any commercially-sensitive information (for example, by showing proportional changes in subscriber counts relative to a baseline value, rather than showing absolute subscriber counts). These scaled mobility indicators can then safely be shared with external parties.

This document describes the steps to produce three scaled indicators from the outputs of the three aggregates described in [producing_aggregates.md](producing_aggregates.md). Details of other mobility indicators can be found at [covid19.flowminder.org](https://covid19.flowminder.org). Alongside this document, a spreadsheet ([aggregates_to_indicators.xlsx](aggregates_to_indicators.xlsx)) is included which demonstrates how these can be applied. This guidance is written to be general enough to allow the method to be implemented in any programming language should this be preferred.

## Baseline period

The baseline period is a period of time before the COVID-19 crisis began, during which we would expect mobility patterns to be “normal”. We can compare to this baseline period to see how mobility has changed during the crisis. The baseline period should include a whole number of weeks (preferably at least 4 weeks), because the mobility indicators can vary over the days of the week.

The _changes in subscriber density_ and _changes in subscriber movements_ indicators (described below) are calculated as percent changes relative to the baseline. The baseline value for each locality (for _subscriber density_) or pair of localities (for _subscriber movements_) is the median daily **scaled subscriber count** for that locality (or pair of localities) over the baseline period. These values only need to be calculated once.

Example of baseline values for _subscriber density_:

| locality | baseline_scaled_subscriber_count |
| -------- | -------------------------------- |
| Locality01 | 0.1192 |
| Locality02 | 0.0313 |
| Locality03 | 0.0311 |

Example of baseline values for _subscriber movements_:

| locality_from | locality_to | baseline_scaled_subscriber_count |
| ------------- | ----------- | -------------------------------- |
| Locality01 | Locality01 | 0.00696 |
| Locality01 | Locality02 | 0.00195 |
| Locality01 | Locality03 | 0.00206 |
| Locality02 | Locality01 | 0.00195 |
| Locality02 | Locality02 | 0.00614 |
| Locality02 | Locality03 | 0.00218 |
| Locality03 | Locality01 | 0.00200 |
| Locality03 | Locality02 | 0.00207 |
| Locality03 | Locality03 | 0.00701 |

**Note:** The baseline values are not calculated in the spreadsheet [aggregates_to_indicators.xlsx](aggregates_to_indicators.xlsx). They should be calculated separately, and inserted in the 'baseline_subscriber_density' and 'baseline_subscriber_movements' worksheets.

## Indicator 1: changes in subscriber density

This indicator requires the aggregates _count_subscribers_per_locality_per_day_ and _total_subscribers_per_day_.

Analysis steps:

1. Divide each row from _count_subscribers_per_locality_per_day_ by the total subscriber count for that day (from _total_subscribers_per_day_) to get the **scaled subscriber count** for each locality each day.  
2. Divide the **scaled subscriber count** for each locality each day by the **baseline scaled subscriber count** for that locality (see ["baseline period" section](#baseline-period) above), to get the scaled subscriber count as a **proportion of baseline**.  
3. Subtract 1 from the proportion of baseline and multiply by 100, to get the **percentage change from baseline**.

This indicator is calculated in the 'subscriber_density' worksheet of [aggregates_to_indicators.xlsx](aggregates_to_indicators.xlsx), and the output is in the 'OUTPUT_subscriber_density' worksheet.

Example output for _changes in subscriber density_:

| visit_date | locality | percentage_change |
| ---------- | -------- | ----------------- |
| 2020-05-01 | Locality01 | 4.62 |
| 2020-05-01 | Locality02 | 2.22 |
| 2020-05-01 | Locality03 | -13.27 |
| 2020-05-02 | Locality01 | -2.12 |
| ... | ... | ... |

## Indicator 2: changes in subscriber movements

This indicator requires the aggregates _od_matrix_directed_all_pairs_per_day_ and _total_subscribers_per_day_.

Analysis steps:

1. Divide each row from _od_matrix_directed_all_pairs_per_day_ by the total subscriber count for that day (from _total_subscribers_per_day_) to get the **scaled subscriber count** for each pair of localities each day.  
2. Divide the **scaled subscriber count** for each pair of localities each day by the **baseline scaled subscriber count** for that pair of localities (see ["baseline period" section](#baseline-period) above), to get the scaled subscriber count as a **proportion of baseline**.  
3. Subtract 1 from the proportion of baseline and multiply by 100, to get the **percentage change from baseline**.

This indicator is calculated in the 'subscriber_movements' worksheet of [aggregates_to_indicators.xlsx](aggregates_to_indicators.xlsx), and the output is in the 'OUTPUT_subscriber_movements' worksheet.

Example output for _changes in subscriber movements_:

| connection_date | locality_from | locality_to | percentage_change |
| --------------- | ------------- | ----------- | ----------------- |
| 2020-05-01 | Locality01 | Locality01 | 16.70 |
| 2020-05-01 | Locality01 | Locality02 | -3.68 |
| 2020-05-01 | Locality01 | Locality03 | -2.55 |
| 2020-05-01 | Locality02 | Locality01 | -8.21 |
| ... | ... | ... | ... |

## Indicator 3: average number of localities visited per subscriber

This indicator requires the aggregates _count_subscribers_per_locality_per_day_ and _od_matrix_directed_all_pairs_per_day_.

Analysis steps:

1. For each locality _L_ each day, sum the subscriber counts from _od_matrix_directed_all_pairs_per_day_ for that day where locality_from=_L_ and locality_to is not equal to _L_, to get the **sum of outgoing connections**.  
2. For each locality _L_ each day, sum the subscriber counts from _od_matrix_directed_all_pairs_per_day_ for that day where locality_to=_L_ and locality_from is not equal to _L_, to get the **sum of incoming connections**.  
3. Divide the **sum of outgoing connections** for each locality each day by the subscriber count for that locality on that day (from _count_subscribers_per_locality_per_day_), to get the **average number of other localities visited after _L_**.  
4. Divide the **sum of incoming connections** for each locality each day by the subscriber count for that locality on that day (from _count_subscribers_per_locality_per_day_), to get the **average number of other localities visited before _L_**.  

This indicator is calculated in the 'localities_per_subscriber' worksheet of [aggregates_to_indicators.xlsx](aggregates_to_indicators.xlsx), and the output is in the 'OUTPUT_localities_per_subscriber' worksheet.

Example output for _average number of localities visited per subscriber_:

| visit_date | locality | average_other_localities_visited_after | average_other_localities_visited_before |
| ---------- | -------- | -------------------------------------- | --------------------------------------- |
| 2020-05-01 | Locality01 | 1.36 | 1.47 |
| 2020-05-01 | Locality02 | 0.53 | 0.82 |
| 2020-05-01 | Locality03 | 0.46 | 0.67 |
| 2020-05-02 | Locality01 | 1.33 | 1.34 |
| ... | ... | ... | ... |
