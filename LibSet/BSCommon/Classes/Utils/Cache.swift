//
//  CacheUtils.swift
//  Alamofire
//
//  Created by jiang on 2019/7/23.
//


public class Cache{
    public var name = ""
    
    public init(name:String) {
        self.name = name
    }
    
    ///读取已缓存的文件 -- 获取字典
    public func getDict() -> [String:Any]{
        var resDict = [String:Any]()
        let filePath:String = NSHomeDirectory() + "/Documents/Caches/\(name).plist"
        if let dictionary = NSDictionary(contentsOfFile: filePath) as? [String:Any]{
            resDict = dictionary
        } //full Dictionary
        return resDict
    }
    
    /// 覆盖写入缓存文件(仅沙盒能写入) -- 保存字典
    public func save(_ dict:[String:Any]){
        let cachePath = NSHomeDirectory() + "/Documents/Caches"
        let manager = FileManager.default
        objc_sync_enter(self)
        if !manager.fileExists(atPath: cachePath){
            do {
                try? manager.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
            }catch {
                YYLog(StringUtils.ERROR + "创建缓存目录失败")
            }
        }
        let filePath:String = "\(cachePath)/\(name).plist"
        let success = (dict as NSDictionary).write(toFile: filePath, atomically: true)
        if !success{
            YYLog(StringUtils.ERROR + "写入缓存文件失败")
        }
        else{
            YYLog("缓存字典成功")
        }
        objc_sync_exit(self)
    }
    
    /// 覆盖写入缓存文件(仅沙盒能写入) -- 保存数组
    public func saveArray(_ array: Array<[String:Any]>){
        let cachePath = NSHomeDirectory() + "/Documents/Caches"
        let manager = FileManager.default
        objc_sync_enter(self)
        if !manager.fileExists(atPath: cachePath){
            do {
                try? manager.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
            }catch {
                YYLog(StringUtils.ERROR + "创建缓存目录失败")
            }
        }
        let filePath:String = "\(cachePath)/\(name).plist"
        let success = (array as NSArray).write(toFile: filePath, atomically: true)
        if !success{
            YYLog(StringUtils.ERROR + "写入缓存文件失败")
        } else {
            YYLog("缓存数组成功")
        }
        objc_sync_exit(self)
    }

    ///读取已缓存的文件 -- 获取数组
    public func getArray() -> Array<[String:Any]> {
        var resArray = Array<[String:Any]>()
        let filePath:String = NSHomeDirectory() + "/Documents/Caches/\(name).plist"
        if let array = NSArray(contentsOfFile: filePath) as? Array<[String:Any]> {
            resArray = array
        }
        return resArray
    }

    ///清除全部数据
    public func clean(){
        YYLog("清除缓存成功")
        save([String:Any]())
        saveArray(Array<[String:Any]>())
    }

}
