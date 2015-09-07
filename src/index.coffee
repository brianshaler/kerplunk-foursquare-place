_ = require 'lodash'
Promise = require 'when'

itemToPlace = require './itemToPlace'
populateFields = require './populateFields'

module.exports = (System) ->
  Place = System.getModel 'Place'
  Identity = System.getModel 'Identity'
  ActivityItem = System.getModel 'ActivityItem'

  preSave = (item) ->
    return item unless item.platform == 'foursquare'
    return item if item.attributes?.place
    return item unless item.data?.id

    item.attributes = {} unless item.attributes

    placeObj = itemToPlace item
    mpromise = Place
    .where
      guid: placeObj.guid
    .findOne()
    Promise(mpromise).then (place) ->
      if place
        # console.log 'place exists', place._id
        item.markModified 'attributes'
        item.attributes.place = place._id
        return item
      place = new Place placeObj
      populateFields place, Place
      .then (place) ->
        item.attributes.place = place._id
        place.save()
      .then -> item

  events:
    activityItem:
      save:
        pre: preSave
