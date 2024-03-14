bring cloud;
bring util;
bring "../../dynamodb.w" as dynamodb;

let table = new dynamodb.Table(
    name: "blog",
    attributes: [
        {name: "type", type: "S"},
        {name: "id", type: "S"},
        {name: "createdAt", type: "N"},
    ],
    hashKey: "type",
    rangeKey: "id",
    globalSecondaryIndex: [{
        name: "CreatedAtIndex",
        hashKey: "type",
        rangeKey: "createdAt",
        projectionType: "ALL"
    }],
);

// Only Hash Key
let table2 = new dynamodb.Table(
    name: "blog2",
    attributes: [
        {name: "type", type: "S"},
        {name: "id", type: "S"},
    ],
    hashKey: "type",
    rangeKey: "id",
    globalSecondaryIndex: [{
        name: "TypeIndex",
        hashKey: "type",
        projectionType: "ALL"
    }],
) as "blog2";

test "Global secondary index" {
    let idCreated = [
        {id: "zuegksw", createdAt: 1},
        {id: "dirnfhw", createdAt: 3},
        {id: "pdkeruf", createdAt: 5},
        {id: "azjekfw", createdAt: 7},
    ];

    for i in idCreated {
        let id = i.get("id").asStr();
        let createAt = i.get("createdAt").asNum();

        table.put({
            Item: {
                "type": "post",
                "id": id,
                "title": "Title #{i}",
                "createdAt": createAt,
            },
        });
    }

    let items = table.query({
        KeyConditionExpression: "#type = :type",
        ExpressionAttributeNames: {
            "#type": "type",
        },
        ExpressionAttributeValues: {
            ":type": "post",
        },
        ScanIndexForward: false,
    });

    // log("{Json.stringify(items.items)}");

    // returns all items order by id desc
    let ids = ["zuegksw", "pdkeruf", "dirnfhw", "azjekfw"];
    for i in 0..ids.length {
        assert(items.Items.at(i).get("id") == ids.at(i));
    }

    let itemsCreatedAtIndex = table.query(
        IndexName: "CreatedAtIndex",
        KeyConditionExpression: "#type = :type",
        ExpressionAttributeNames: {
            "#type": "type",
        },
        ExpressionAttributeValues: {
            ":type": "post",
        },
        ScanIndexForward: false,
    );

    // log("{Json.stringify(itemsCreatedAtIndex.items)}");

    // returns all items order by createdAt desc
    let idsOrderByCreatedAt = ["azjekfw", "pdkeruf", "dirnfhw", "zuegksw"];
    for i in 0..idsOrderByCreatedAt.length {
        assert(itemsCreatedAtIndex.Items.at(i).get("id") == idsOrderByCreatedAt.at(i));
    }
}
