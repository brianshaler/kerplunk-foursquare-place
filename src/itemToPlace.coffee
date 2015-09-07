_ = require 'lodash'

module.exports = (item) ->
  {venue} = item.data
  place =
    guid: "foursquare-#{venue.id}"
    name: venue.name
    specificity: 6
    city: venue.location.city
    region: venue.location.state
    country: venue.location.cc
    containedBy: null
    location: [
      venue.location.lng
      venue.location.lat
    ]
    data:
      foursquare: venue
  place
