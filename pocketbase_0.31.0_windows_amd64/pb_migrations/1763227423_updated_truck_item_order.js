/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_70126353")

  // remove field
  collection.fields.removeById("relation521872670")

  // add field
  collection.fields.addAt(2, new Field({
    "hidden": false,
    "id": "number2683508278",
    "max": null,
    "min": null,
    "name": "quantity",
    "onlyInt": false,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "number"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_70126353")

  // add field
  collection.fields.addAt(1, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_3573984430",
    "hidden": false,
    "id": "relation521872670",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "item",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  // remove field
  collection.fields.removeById("number2683508278")

  return app.save(collection)
})
