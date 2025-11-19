/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_710432678")

  // update field
  collection.fields.addAt(3, new Field({
    "hidden": false,
    "id": "select3703245907",
    "maxSelect": 1,
    "name": "unit",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "select",
    "values": [
      "pieces",
      "packs",
      "box"
    ]
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_710432678")

  // update field
  collection.fields.addAt(3, new Field({
    "hidden": false,
    "id": "select3703245907",
    "maxSelect": 1,
    "name": "unit",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "select",
    "values": [
      "pieces",
      "packs",
      "Box"
    ]
  }))

  return app.save(collection)
})
