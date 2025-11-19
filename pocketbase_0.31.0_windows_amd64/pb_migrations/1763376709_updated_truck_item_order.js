/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_70126353")

  // add field
  collection.fields.addAt(4, new Field({
    "hidden": false,
    "id": "bool1663731225",
    "name": "delivered",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "bool"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_70126353")

  // remove field
  collection.fields.removeById("bool1663731225")

  return app.save(collection)
})
