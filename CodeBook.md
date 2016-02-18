Variables
---------

-   **x\_train, y\_train, subject\_train, y\_test, y\_test,
    subject\_test: ** raw data from the downloaded corresponding
    zip-files

-   **features: ** description of the column names of x\_train and
    x\_test

-   **activitiy\_labels: ** description of the activity numbers in
    y\_test

-   **x\_data, y\_data, subject\_data: ** merged data from training and
    test data sets. The data are subsetted into columns on the mean and
    standard deviation for each measurement

-   **data: ** data set with descriptive variable names which assemblies
    the data sets y\_data, subject\_data, x\_data

-   **data\_tidy: ** aerages of each variable of the data for each
    activity and each subject

Processing of the data
----------------------

The processing of the data is done by an R script called
**run\_analysis.R ** that does the following:

### 1. Merge the training and the test sets to create one data set.

-   **x\_data = x\_train + x\_test **

-   **y\_data = y\_train + y\_test **

-   **subject\_data = subject\_train + subject\_test **

### 2. Extract only the measurements on the mean and standard deviation for each measurement.

-   Subset **x\_data ** into the column indices which contain the
    substrings *-mean()* and *-std()* in the features description.

### 3. Using descriptive activity names to name the activities in the data set.

-   Rename the activity numbers of **y\_data ** as **activity\_labels **

-   Change uppercase letters into lowercase.

### 4. Appropriately labels for the data set with descriptive variable names.

-   Rename column names of the field **x\_data ** as **features **

-   Change "-" into "\_" and "()" into ""

-   Assembly the data sets **x\_data, y\_data, subject\_data ** into one
    data set called **data **

### 5. Creating a tidy data set with the average of each variable for each activity and each subject.

-   For each of the variable of the data set created in step 4 aggregate
    the data by an SQL-request.

-   Assembly the results into a data set called **data\_tidy **

-   Write the results into a file called **data\_tidy.txt**
