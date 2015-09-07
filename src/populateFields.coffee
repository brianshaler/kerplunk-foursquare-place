_ = require 'lodash'
Promise = require 'when'

findCountry = (Place) ->
  (place) ->
    mpromise = Place
    .where
      specificity: 1
      '$or': [
        {'data.countryCode': place.country}
        {'data.cca2': place.country}
        {'data.cca3': place.country}
        {'data.name.common': place.country}
        {'data.name.official': place.country}
        {'data.altSpellings': place.country}
      ]
    .find()
    Promise(mpromise).then (countries) ->
      return place unless countries?.length > 0
      countries = _.sortBy countries, (country) ->
        lng = Math.abs country.location[0] - place.location[0]
        lat = Math.abs country.location[1] - place.location[1]
        Math.sqrt lng * lng + lat * lat
      place.country = countries[0].name
      place.containedBy = countries[0]._id
      place

findRegion = (Place) ->
  (place) ->
    mpromise = Place
    .where
      specificity: 2
      $or: [
        {name: place.region}
      ]
    .find()
    Promise(mpromise).then (regions) ->
      return place unless regions?.length > 0
      regions = _.sortBy regions, (region) ->
        lng = Math.abs region.location[0] - place.location[0]
        lat = Math.abs region.location[1] - place.location[1]
        Math.sqrt lng * lng + lat * lat
      place.region = regions[0].name
      place.containedBy = regions[0]._id
      place

# findCounty?

findCity = (Place) ->
  (place) ->
    mpromise = Place
    .where
      specificity: 4
      '$or': [
        {name: place.city}
      ]
    .find()
    Promise(mpromise).then (cities) ->
      return place unless cities?.length > 0
      cities = _.sortBy cities, (city) ->
        lng = Math.abs city.location[0] - place.location[0]
        lat = Math.abs city.location[1] - place.location[1]
        Math.sqrt lng * lng + lat * lat
      place.city = cities[0].name
      place.containedBy = cities[0]._id
      place

# findNeighborhood?

module.exports = (place, Place) ->
  Promise place
  .then findCountry Place
  .then findRegion Place
  # county?
  .then findCity Place
  # neighborhood?
