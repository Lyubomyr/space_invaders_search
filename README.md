Space Invaders Search
================

# Development assignment

Space invaders are upon us!
You were shortlisted as one of the great minds to help us track them down.

Your Ruby application must take a radar sample as an argument and reveal possible locations of those pesky invaders.
Good luck!

### Requirements:
- No image detection, this is all about ASCII patterns
- Good OOP architecture is a must. This is a perfect opportunity to demonstrate the SOLID design principle experience.
- Fully tested code with RSpec

### Tips:
- The noise in the radar can be either false positives or false negatives
- Think of edge cases ... pun intended ;)




# Solution

### Algorythm

Invaders search working in 2 steps:

1. Search for clusters of elements on the radar sample. This helps to localize potential invaders' locations. And avoid searching all over the radar by brute force.

2. Brute force though found clusters of elements with a minimal amount of iterations. To find the best fits for invaders inside each cluster. And choose the locations which fit invaders with a maximal chance.

### Run app

To run the app you need to have Ruby version ~> 2.5 installed

Install gems:
```bundle install```

Run in terminal from project root folder:
```ruby run.rb```


### Run tests

Run all tests: ```rspec spec/*```
