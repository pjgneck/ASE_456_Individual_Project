/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_710432678")

  // update field
  collection.fields.addAt(2, new Field({
    "hidden": false,
    "id": "select105650625",
    "maxSelect": 1,
    "name": "perishable",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "select",
    "values": [
      "perishable",
      "unperishable"
    ]
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_710432678")

  // update field
  collection.fields.addAt(2, new Field({
    "hidden": false,
    "id": "select105650625",
    "maxSelect": 1,
    "name": "category",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "select",
    "values": [
      "perishable",
      "unperishable"
    ]
  }))

  return app.save(collection)
})
