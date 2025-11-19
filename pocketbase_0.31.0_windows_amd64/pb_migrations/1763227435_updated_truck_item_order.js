/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_70126353")

  // add field
  collection.fields.addAt(3, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_710432678",
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

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_70126353")

  // remove field
  collection.fields.removeById("relation521872670")

  return app.save(collection)
})
