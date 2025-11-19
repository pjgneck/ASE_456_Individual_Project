/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_710432678")

  // add field
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
      "Refrigerated"
    ]
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_710432678")

  // remove field
  collection.fields.removeById("select4090281729")

  return app.save(collection)
})
