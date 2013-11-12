## Hola
This project was part of a interview challenge.

It contains code to analyze push data to [Github](github.com). I used data downloaded from the [Github Archive](http://www.githubarchive.org/) to answer a couple of questions:

- How many pushes does Github get by hour and by day?
- How many repositories were pushed to in this entire time
  frame, by language?
- In which languages do users commit code most frequently?

Vagrant, Berkshelf, Chef were used to set up a development environment.

Scripts to download the Github Archive data and calculate the metrics are housed in the [app directory](app/).

Visualizations were created using erb and d3.js and are located in the [views directory](/app/views/).