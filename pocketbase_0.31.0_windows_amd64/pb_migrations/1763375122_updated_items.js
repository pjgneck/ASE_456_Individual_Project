/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_710432678")

  // update field
  collection.fields.addAt(4, new Field({
    "hidden": false,
    "id": "select4090281729",
    "maxSelect": 1,
    "name": "category",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "select",
    "values": [
      "Frozen",
      "Refrigerated",
      "Dry"
    ]
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_710432678")

  // update field
  collection.fields.addAt(4, new Field({
    "hidden": false,
    "id": "select4090281729",
    "maxSelect": 1,
    "name": "catagory",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "select",
    "values": [
      "Frozen",
      "Refrigerated",
      "Dry"
    ]
  }))

  return app.save(collection)
})
