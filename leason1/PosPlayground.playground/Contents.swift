import UIKit

struct Item {
    let barcode: String
    let name: String
    let unit: String
    let price: Double
}

let items =
    [
        Item(
            barcode: "ITEM000000",
            name: "可口可乐",
            unit: "瓶",
            price: 3.00
        ),
        Item(
            barcode: "ITEM000001",
            name: "雪碧",
            unit: "瓶",
            price: 3.00
        ),
        Item(
            barcode: "ITEM000002",
            name: "苹果",
            unit: "斤",
            price: 5.50
        ),
        Item(
            barcode: "ITEM000003",
            name: "荔枝",
            unit: "斤",
            price: 15.00
        ),
        Item(
            barcode: "ITEM000004",
            name: "电池",
            unit: "个",
            price: 2.00
        ),
        Item(
            barcode: "ITEM000005",
            name: "方便面",
            unit: "袋",
            price: 4.50
        )
];

struct Promotion {
    let type: String
    let barcodes: [String]
}

let promotions = [
    Promotion(
        type:"BUY_TWO_GET_ONE_FREE",
        barcodes:[ "ITEM000000","ITEM000001","ITEM000005"])
]

func countByBarcode (_ itemArray: [String]) -> [String:Int] {
    var result = [String:Int]()
    for itemString in itemArray{
        if(itemString.contains("-")){
            let itemInLine = itemString.split(separator: "-")
            
            let itemString = String(itemInLine[0])
            let itemCount = Int(itemInLine[1])
            
            if(result[itemString] == nil) {
                result[itemString] = itemCount
            }else {
                result[itemString] = (result[itemString])! + itemCount!
            }
            continue
        }
        
        if(result[itemString] == nil) {
            result[itemString] = 1
        }else {
            result[itemString] = (result[itemString])! + 1
        }
    }
    
    return result
}

func ifDiscount(_ barcode : String) -> Bool {
    // TODO only handle 1 item in promotions currently.
    if(promotions[0].barcodes.contains(barcode)){
        return true
    }else{
        return false
    }
}

func countEveryItemMoney(_ item : Item, _ num : Int) -> (Double,Double) {
    if(ifDiscount(item.barcode)){
        let cost = Double(num/3)*item.price*2+Double(num%3)*item.price
        let saved = Double(num)*item.price - cost
        return (cost, saved)
    }
    return (item.price * Double((num)), 0)
}


func getItemByBarcode(_ barcode: String) -> Item {
    for item in items{
        if(item.barcode == barcode){
            return item
        }
    }
    fatalError("Item does not existed.")
}

func printReceipt(_ input: [String]){
    
    print("***<没钱赚商店>收据***")
    
    let countByBarcodeDictionary = countByBarcode(input)
    
    var totalCost: Double = 0
    var totalSaved: Double = 0
    
    for countByBarcodeItem in countByBarcodeDictionary {
        let barcode = countByBarcodeItem.key
        let item = getItemByBarcode(barcode)
        let num = countByBarcodeItem.value
        let itemMoney = countEveryItemMoney(item,num)
        let cost = itemMoney.0
        let saved = itemMoney.1
        print("名称：\(item.name)，数量：\(num)\(item.unit)，单价：\(String(format: "%.2f", item.price))(元)，小计：\(String(format: "%.2f", cost))(元)")
        totalCost += cost
        totalSaved += saved
    }
    print("----------------------")
    
    print("总计：\(String(format: "%.2f", totalCost))(元)")
    print("节省：\(String(format: "%.2f", totalSaved))(元)")
    
    print("**********************")
}

let input = [
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000003-2",
    "ITEM000005",
    "ITEM000005",
    "ITEM000005"
]

printReceipt(input)



